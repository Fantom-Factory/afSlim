using afPegger::Peg
using afPegger::Grammar
using afPegger::PegGrammar

internal class SlimLineElementCompiler : SlimLineCompiler {
	private const TagStyle tagStyle
	private Grammar	attrGrammar
	private Grammar	tagGrammar
	
	new make(TagStyle tagStyle) {
		this.tagStyle	 = tagStyle
		this.attrGrammar = Peg.parseGrammar(`fan://afSlim/res/tagAttributes.peg.txt`.toFile.readAllStr)
		this.tagGrammar	 = Peg.parseGrammar(`fan://afSlim/res/tagIdClass.peg.txt`	.toFile.readAllStr)
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
		attrs	:= Str[,]
		vals	:= tagGrammar.firstRule.match(tag) 

		id		:= vals["id"]?.toStr?.trimToNull
		if (id != null)
			attrs.add("id=\"${id}\"")
		
		classes := vals.matches.findAll { it.name == "class" }
		if (classes.size > 0) {
			css := classes.join(" ")
			attrs.add("class=\"${css}\"")
		}
		
		if (!attr.isEmpty)
			attrs.add(attr.trim)		
		
		element	:= SlimLineElement(tagStyle, escape(vals["tag"]?.toStr ?: ""), escape(attrs.join(" ")), escape(text))

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
	TagStyle tagStyle
	Str name
	Str attr
	Str text
	
	new make(TagStyle tagStyle, Str name, Str attr, Str text) {
		this.tagStyle = tagStyle
		this.name = name
		this.attr = attr
		this.text = text
		
		// trim ONE character of whitespace
		// useful for ensuring tags don't butt up against each other
		// I could make it 2 chars, but I usually use a tab
		// people could also use | for more control
		if (this.text.size > 0 && this.text[0].isSpace)
			this.text = this.text[1..-1]
	}
	
	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.addChar('<')
		buf.add(name)
		if (!attr.isEmpty) {
			buf.addChar(' ')
			buf.add(attr)
		}

		buf.add(tagStyle.tagEnding.startTag(name, children.isEmpty && text.isEmpty, srcSnippet, slimLineNo+1))
		
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
		
		buf.add(tagStyle.tagEnding.endTag(name, children.isEmpty && text.isEmpty))
		
		newLine(buf)
	}
	
	override Type[] legalChildren() {
		[SlimLineElement#, SlimLineFanCode#, SlimLineFanComment#, SlimLineFanEval#, SlimLineBlockComment#, SlimLineHtmlComment#, SlimLineText#]
	}
}
