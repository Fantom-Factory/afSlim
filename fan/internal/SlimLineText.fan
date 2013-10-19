
internal const class SlimLineTextCompiler : SlimLineCompiler {

	override Bool matches(Str line) {
		line.startsWith("|")
	}
	
	override SlimLineText compile(Str line) {
		text := line[1..-1]
		
		// !text.trim.isEmpty not tested, the idea being, don't force padding for empty lines
//		if (text.getSafe(0).isSpace && !text.trim.isEmpty) {

//		if (text.getSafe(0).isSpace) {
//			text = text[1..-1]
//			extraPadding += 1
//		}
		
		return SlimLineText(escape(text))
	}
}

internal class SlimLineText : SlimLine {
	
	Str text
	Bool fromMultiLine
	
	
	override This with(|This| f) {
		f(this)
		return this
	}
	
	new make(Str text) {
		this.text = text
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
		space := "".padl(padding, ' ')
		text += "\n${space}${line}"
		return true
	}
	
	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.add(text)
	}

	override Void onExit(StrBuf buf) {
		newLine(buf)
	}
}
