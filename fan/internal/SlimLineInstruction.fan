
internal const class SlimLineInstructionCompiler : SlimLineCompiler {
	
	override Bool matches(Str line) {
		line.startsWith("-?")
	}
	
	override SlimLine compile(Str line) {
		SlimLineInstruction(line[2..-1].trim)
	}
}

internal class SlimLineInstruction : SlimLine {

	Str instruction
	
	new make(Str instruction) {
		this.instruction = instruction
	}
	
	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.add("<%? ${instruction} %>")
		newLine(buf)
	}

	override Void onExit(StrBuf buf) { }
}
