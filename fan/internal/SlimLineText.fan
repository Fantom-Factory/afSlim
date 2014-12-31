
internal const class SlimLineTextCompiler : SlimLineCompiler {

	override Bool matches(Str line) {
		line.startsWith("|")
	}
	
	override SlimLineText compile(Str line) {
		text := line.trimStart[1..-1]
		
		// count and note the leading whitespace
		optionalPadding := text.chars.findIndex |char->Bool| { !char.isSpace } ?: 0
		
		// actually, limit optionalPadding to 1 so we can add leading spaces after elements
		// see TestBugFixes.testAddingLeadingSpacesToText()
		optionalPadding = optionalPadding.min(1) 
		
		text = text[optionalPadding..-1]
		
		// +1 for the | (leave it for multilines - it soaks up the leading tab)
		return SlimLineText(escape(text), optionalPadding + 1)
	}
	
	static Bool isMultiLine(Str line) {
		line.trimStart.startsWith("|")
	}
}

internal class SlimLineText : SlimLine, Escape {
	private const SlimLineTextCompiler textCompiler	:= SlimLineTextCompiler()
	
	Str text
	Bool fromMultiLine
	Int	optionalPadding

	new make(Str text, Int optionalPadding) {
		this.text = text
		this.optionalPadding = optionalPadding
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
				return true
			}
			
			return false
		}
		
		line 	= line[this.leadingWs..-1]
		chomp 	:= optionalPadding.min(line.chars.findIndex { !it.isSpace } ?: 0)
		line	= line[chomp..-1]
		
		text	+= "\n${escape(line)}"

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
