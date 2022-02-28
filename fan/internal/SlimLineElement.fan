using afPegger::Peg
using afPegger::Grammar
using afPegger::PegGrammar
using afPegger::Match

internal class SlimLineElementCompiler : SlimLineCompiler {
	private const	TagStyle			tagStyle
	private const	Str:SlimComponent	components
	private 		Grammar				tagGrammar
	private			Grammar				attrGrammar
	private			Grammar				splitGrammar
	
	new make(TagStyle tagStyle, SlimComponent[] components) {
		this.tagStyle	 = tagStyle
		this.tagGrammar	 = Peg.parseGrammar(`fan://afSlim/res/tagIdClass.peg.txt`		.toFile.readAllStr)
		this.attrGrammar = Peg.parseGrammar(`fan://afSlim/res/tagAttributes.peg.txt`	.toFile.readAllStr)
		this.splitGrammar= Peg.parseGrammar(`fan://afSlim/res/tagAttributeSplit.peg.txt`.toFile.readAllStr)

		comMap	 := Str:SlimComponent[:]
		components.each { comMap[it.name] = it }
		this.components	= comMap
	}

	override Bool matches(Str line) {
		// XML elements may have Unicode chars - the list is quite exhaustive, so just return true for ease of use
		// see http://www.w3.org/TR/xml11/#sec-common-syn
		true
	}
	
	override SlimLine compile(Str line) {
		// I know, I'll use Regular Expressions! ...
		// Actually, I've got enough problems so I'll use Pegger instead!
		pegged := attrGrammar.firstRule.match(line)
		return match(pegged["tagName"]?.toStr ?: "", pegged["attributes"]?.toStr ?: "", pegged["content"]?.toStr ?: "", pegged["multiLine"] != null)
	}
	
	SlimLine match(Str tag, Str attr, Str text, Bool multi) {
		vals		:= tagGrammar.firstRule.match(tag) 

		// allow "tag:component" syntax
		tagName		:= escape(vals["tag"].matched)
		comName		:= null as Str
		if (tagName.contains(":") && !tagName.contains("\$")) {
			noms	:= tagName.split(':')
			if (noms.size > 2)
				throw UnsupportedErr("Only ONE Slim component may be defined: $tagName")
			tagName	= noms[0]
			comName = noms[1]
		}
		
		component	:= components[comName ?: tagName]
		if (component != null && comName == null) {
			comName = tagName
			tagName	= "div"
		}
		
		id			:= escape(vals["id"]?.toStr?.trimToNull)
		classes 	:= vals.matches.findAll { it.name == "class" }.map { escape(it.matched) }
		eAttr		:= attr.trimToNull
		eText		:= escape(text.trimToNull == null ? null : text)	// don't trim extra space
		comCtx		:= null as SlimComponentCtx
		
		if (component != null)
			comCtx	= SlimComponentCtx {
				it.tagStyle	= this.tagStyle
				it.tagName	= tagName
				it.comName	= comName
				it.id		= id
				it.classes	= classes
				it.attrs	= splitAttrs(eAttr)
				it.text		= eText
			}
	
		attrs		:= Str[,]
		if (id != null)
			attrs.add("id=\"${id}\"")
		if (classes.size > 0) {
			css := classes.join(" ")
			attrs.add("class=\"${css}\"")
		}
		if (eAttr != null)
			attrs.add(escape(eAttr))		
		element		:= SlimLineElement(tagStyle, tagName, attrs.join(" "), eText ?: "", component, comCtx)

		if (multi) {
			element.nextLine = text
			element.text	 = ""
		}

		// fudge for javascript type lines
		if (SlimLineTextCompiler.isMultiLine(text)) {
			element.nextLine = text
			element.text	 = ""
		}

		return element
	}
	
	Str:Str? splitAttrs(Str? attrsStr) {
		pegged	:= (Match?) (attrsStr == null ? null : splitGrammar.firstRule.match(attrsStr))
		attrs	:= Str:Str?[:] { it.ordered = true }
		pegged?.matches?.each |m| {
			nom	:= escape(m.getMatch("attrName" ) .matched)
			val := escape(m.getMatch("attrValue")?.matched)
			attrs[nom] = val
		}
		return attrs
	}
}

internal class SlimLineElement : SlimLine {
	SlimComponent?		component
	SlimComponentCtx?	componentCtx
	TagStyle			tagStyle
	Str					name
	Str					attr
	Str					text

	new make(TagStyle tagStyle, Str name, Str attr, Str text, SlimComponent? component, SlimComponentCtx? ctx) {
		this.component		= component
		this.componentCtx	= ctx
		this.tagStyle		= tagStyle
		this.name			= name
		this.attr			= attr
		this.text			= text
		
		// trim ONE character of whitespace
		// useful for ensuring tags don't butt up against each other
		// I could make it 2 chars, but I usually use a tab
		// people could also use | for more control
		if (this.text.size > 0 && this.text[0].isSpace)
			this.text = this.text[1..-1]
	}
	
	override Void onEntry(StrBuf buf) {
		indent(buf)

		if (component != null)
			component.onEntry(buf, componentCtx)

		else {
			buf.addChar('<')
			buf.add(name)
			if (!attr.isEmpty)
				buf.join(attr, " ")

			buf.add(tagStyle.tagEnding.startTag(name, children.isEmpty && text.isEmpty, srcSnippet, slimLineNo+1))
		}
		
		if (!children.isEmpty) {
			newLine(buf)
			if (!text.isEmpty) {
				indent(buf, 1)
			}
		}
		if (!text.isEmpty) {
			buf.add(text)
			if (!children.isEmpty) {
				newLine(buf)
			}
		}
	}

	override Void onExit(StrBuf buf) {
		if (!children.isEmpty) {
			indent(buf)
		}
		
		if (component != null)
			component.onExit(buf, componentCtx)
		else
			buf.add(tagStyle.tagEnding.endTag(name, children.isEmpty && text.isEmpty))
		
		newLine(buf)
	}
	
	override Type[] legalChildren() {
		[SlimLineElement#, SlimLineFanCode#, SlimLineFanComment#, SlimLineFanEval#, SlimLineBlockComment#, SlimLineHtmlComment#, SlimLineText#]
	}
}
