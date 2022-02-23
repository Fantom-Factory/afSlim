using afPegger::Peg
using afPegger::Grammar
using afPegger::PegGrammar

internal class SlimLineElementCompiler : SlimLineCompiler {
	private const	TagStyle			tagStyle
	private const	Str:SlimComponent	components
	private			Grammar				attrGrammar
	private 		Grammar				tagGrammar
	
	new make(TagStyle tagStyle, SlimComponent[] components) {
		this.tagStyle	 = tagStyle
		this.attrGrammar = Peg.parseGrammar(`fan://afSlim/res/tagAttributes.peg.txt`.toFile.readAllStr)
		this.tagGrammar	 = Peg.parseGrammar(`fan://afSlim/res/tagIdClass.peg.txt`	.toFile.readAllStr)
		
		comMap	 := Str:SlimComponent[:]
		components.each { comMap[it.tagName] = it }
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
		attrs		:= Str[,]
		vals		:= tagGrammar.firstRule.match(tag) 

		tagName		:= vals["tag"]?.toStr ?: ""
		component	:= components[tagName]
		comCtx		:= null as SlimComponentCtx
		
		id			:= vals["id"]?.toStr?.trimToNull
		if (id != null)
			attrs.add("id=\"${id}\"")
		
		classes 	:= vals.matches.findAll { it.name == "class" }
		if (classes.size > 0) {
			css := classes.join(" ")
			attrs.add("class=\"${css}\"")
		}
		
		if (!attr.isEmpty)
			attrs.add(attr.trim)		
		
		if (component != null) {
			comCtx	= SlimComponentCtx {
				it.tagStyle	= this.tagStyle
				it.tagName	= tagName
				it.id		= id
				it.classes	= classes.map { it.toStr }
				it.attrs	= attr
				it.text		= text	
			}
		}
	
		element		:= SlimLineElement(tagStyle, escape(tagName), escape(attrs.join(" ")), escape(text), component, comCtx)

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
			if (!attr.isEmpty) {
				buf.addChar(' ')
				buf.add(attr)
			}

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
