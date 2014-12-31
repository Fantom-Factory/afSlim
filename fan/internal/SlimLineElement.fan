using afPegger

internal const class SlimLineElementCompiler : SlimLineCompiler {
	private const TagStyle tagStyle
	
	new make(TagStyle tagStyle) {
		this.tagStyle = tagStyle
	}
	
	override Bool matches(Str line) {
		// XML elements may have Unicode chars - the list is quite exhaustive, so just return true for ease of use
		// see http://www.w3.org/TR/xml11/#sec-common-syn
		true
	}
	
	override SlimLine compile(Str line) {
		// I know, I'll use Regular Expressions! ...
		// Actually, I've got enough problems so I'll use Pegger instead!
		attrs := AttributeParser().parseAttributes(line)
		return match(attrs.name, attrs.attr, attrs.text, attrs.multi)
	}
	
	SlimLine match(Str tag, Str attr, Str text, Bool multi) {
		attrs	:= Str[,]
		vals	:= TagIdClassParser().parse(tag)

		if (!vals.id.isEmpty)
			attrs.add("id=\"${vals.id}\"")
		
		if (!vals.classes.isEmpty) {
			css := vals.classes.join(" ")
			attrs.add("class=\"${css}\"")
		}
		
		if (!attr.isEmpty)
			attrs.add(attr.trim)		
		
		text = text.trimStart	// very important!
		element	:= SlimLineElement(tagStyle, escape(vals.name), escape(attrs.join(" ")), escape(text))

		if (multi) {
			element.nextLine = text
			element.text	 = ""
		}

		// fudge for javascript type lines
		if (SlimLineTextCompiler.isMultiLine(text)) {
			element.nextLine = text
			element.text	 = ""
			element.multiLineTextFudge = true
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

internal class AttributeParser : Rules {
	Str?	name
	Str		attr	:= Str.defVal
	Str		text	:= Str.defVal
	Bool	multi	:= false
	
	AttributeParser parseAttributes(Str line) {
		if (Parser(rules).parse(line.in) == null)
			throw SlimErr(ErrMsgs.elementCompilerNoMatch(line))
		return this
	}
	
	Rule rules() {
		rules 			:= NamedRules()
		tagName			:= rules["tagName"]
		attributes		:= rules["attributes"]
		roundBrackets	:= rules["roundBrackets"]
		squareBrackets	:= rules["squareBrackets"]
		multiLine		:= rules["multiLine"]
		content			:= rules["content"]

		// { curly } brackets not allowed 'cos it messes with ${interpolation} in ID and class names.
		// TODO: allow { curly } brackets now that we're using Pegger - needed?
		
		rules["tagName"]		= oneOrMore(anyCharNotOf(" \t\n\r\f([;".chars)).withAction { name = it }
		rules["attributes"]		= sequence { zeroOrMore(anySpaceChar), firstOf { roundBrackets, squareBrackets } }
		rules["roundBrackets"]	= sequence { char('('), zeroOrMore(firstOf { anyCharNotOf("()".chars), roundBrackets }).withAction { attr = it }, char(')'), }
		rules["squareBrackets"]	= sequence { char('['), zeroOrMore(firstOf { anyCharNotOf("[]".chars), squareBrackets}).withAction { attr = it }, char(']'), }
		rules["multiLine"]		= char(';').withAction { multi = true }
		rules["content"]		= zeroOrMore(anyChar).withAction { text = it }
		return sequence { tagName, optional(attributes), optional(multiLine), content }
	}	
}

internal class TagIdClassParser : Rules {
	Str		name	:= Str.defVal
	Str?	id		:= Str.defVal
	Str[]	classes	:= Str[,]
	
	TagIdClassParser parse(Str line) {
		if (Parser(rules).parse(line.in) == null)
			throw SlimErr(ErrMsgs.elementCompilerNoMatch(line))
		return this
	}
	
	Rule rules() {
		rules 		:= NamedRules()
		interpol	:= rules["interpol"]
		tagRule		:= rules["tagRule"]
		idRule		:= rules["idRule"]
		classRule	:= rules["classRule"]

		// TODO: maybe allow nested interpolation here...
		rules["interpol"]	= sequence { char('$'), char('{'), zeroOrMore(anyCharNot('}')), char('}') }
		rules["tagRule"]	= oneOrMore( anyCharNotOf("#.".chars) ).withAction { name = it }
		rules["idRule"]		= sequence { char('#'), zeroOrMore( firstOf { interpol, anyCharNotOf(".".chars) } ).withAction { id = it } }
		rules["classRule"]	= sequence { char('.'), zeroOrMore( firstOf { interpol, anyCharNotOf(".".chars) } ).withAction { classes.push(it) } }
		return sequence { tagRule, optional(idRule), zeroOrMore(classRule) }
	}	
}

