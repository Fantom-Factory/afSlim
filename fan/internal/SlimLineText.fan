
internal const class SlimLineTextCompiler : SlimLineCompiler {

	override Bool matches(Str line) {
		line.startsWith("|")
	}
	
	override SlimLine compile(Str line) {
		text := line[1..-1]
		extraPadding := 1
		
		if (text.startsWith(" ")) {
			text = text[1..-1]
			extraPadding += 1
		}
		
		return SlimLineText(escape(text), extraPadding)
	}
}

internal class SlimLineText : SlimLine {
	
	Str text
	Int extraPadding
	
	new make(Str text, Int extraPadding) {
		this.text = text
		this.extraPadding = extraPadding
	}
	
	override Void addSibling(SlimLine slimLine) {
		// when adding text on the same level, ensure a trailing space
		if (slimLine is SlimLineText)
			if (!text.endsWith(" "))
				text += " "
	}
	
	override Bool consume(Int leadingWs, Str line) {
		// consume all children!
		padding := leadingWs - this.leadingWs
		if (padding <= 0)
			return false
		
		// preserve any leading whitespace
		padding -= extraPadding
		space := "".padl(padding, ' ')
		text += "\n${space}${line}"
		return true
	}
	
	override Void onEntry(StrBuf buf) {
		// trim empty lines - don't! Wot of <pre>!!!
//		if (text.trim.isEmpty)
//			return
		indent(buf)
		buf.add(text)
	}

	override Void onExit(StrBuf buf) {
		buf.addChar('\n')
	}
}
