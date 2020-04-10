
internal const class SlimLineTextCompiler : SlimLineCompiler {

	override Bool matches(Str line) {
		line.startsWith("|")
	}
	
	override SlimLineText compile(Str line) {
		text := line.trimStart[1..-1]
		text  = (text.chars.first?.isSpace ?: false) ? text[1..-1] : text
		return SlimLineText(escape(text))
	}
	
	static Bool isMultiLine(Str line) {
		line.trimStart.startsWith("|")
	}
}

internal class SlimLineText : SlimLine, SlimEscape {
	private const SlimLineTextCompiler textCompiler	:= SlimLineTextCompiler()
	
	Str 	text
	Bool	textOnFirstLine

	new make(Str text) {
		this.text = text
		textOnFirstLine = !text.trimStart.isEmpty
	}
	
	override SlimLine add(SlimLine slimLine, Bool multiLine) {
		// back out so we don't add text to text
		if (slimLine is SlimLineText)
			return parent.add(slimLine, multiLine)
		return super.add(slimLine, multiLine)
	}
	
	override Void addSibling(SlimLine slimLine) {
		// when adding text on the same level, ensure a trailing space
		if (slimLine is SlimLineText)
			if (!text.endsWith(" "))
				text += " "
	}
		
	override Bool consume(Int leadingWs, Str line) {
		// consume all children!
		if (leadingWs <= this.leadingWs) {
			
			// allow blank lines through
			if (line.trim.isEmpty) {
				text += "\n"
				// preserve and indented whitespace
				if (line.size > this.leadingWs)
					text += line[this.leadingWs..-1]
				return true
			}
			
			return false
		}
		
		line 	= line[this.leadingWs..-1]
		line 	= line.chars.first.isSpace ? line[1..-1] : line
		nline	:= true
		
		if (textOnFirstLine)
			if (line.chars.first == '|') {
				// this section is to maintain backward compatibility - could be deleted

				line = line[1..-1]	// chomp the |
				// chomp the usual optional space after the | 
				line = line.chars.first.isSpace ? line[1..-1] : line

				// fake adding a sibling
				if (!text.endsWith(" "))
					text += " "
				nline = false
				
			} else
				// soak up a space for what would be the '|' char
				line = line.chars.first.isSpace ? line[1..-1] : line

		text	+= nline ? "\n${escape(line)}" : escape(line) 

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
