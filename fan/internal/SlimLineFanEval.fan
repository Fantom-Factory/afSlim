
internal const class SlimLineFanEvalCompiler : SlimLineCompiler {

	override Bool matches(Str line) {
		line.startsWith("==")
	}
	
	override SlimLine compile(Str line) {
		SlimLineFanEval(line[2..-1].trim)
	}
}

internal class SlimLineFanEval : SlimLine {
	
	Str code
	
	new make(Str code) {
		this.code = code
	}
	
	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.add("<%= ")
		buf.add(code)
		if (!children.isEmpty)
			buf.add(" {")
		buf.add(" %>")
		newLine(buf)
	}

	override Void onExit(StrBuf buf) {
		if (!children.isEmpty) {
			indent(buf)
			buf.add("<% } %>")
			newLine(buf)
		}
	}

	override Type[] legalChildren() {
		[SlimLineElement#, SlimLineFanCode#, SlimLineFanComment#, SlimLineFanEval#, SlimLineHtmlComment#, SlimLineText#]
	}
}
