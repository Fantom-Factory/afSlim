
internal const class SlimLineFanCodeCompiler : SlimLineCompiler {

	override Bool matches(Str line) {
		line.startsWith("--")
	}
	
	override SlimLine compile(Str line) {
		SlimLineFanCode(line[2..-1].trim)
	}
}

internal class SlimLineFanCode : SlimLine {
	
	Str code
	
	new make(Str code) {
		this.code = code
	}
	
	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.add("<% ")
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
}
