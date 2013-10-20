
// TODO: add all other doctypes
internal const class SlimLineDoctypeCompiler : SlimLineCompiler {
	
	override Bool matches(Str line) {
		line.lower.startsWith("doctype")
	}
	
	override SlimLine compile(Str line) {
		SlimLineDoctype()
	}
}

internal class SlimLineDoctype : SlimLine {

	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.add("<!DOCTYPE html>")
		newLine(buf)
	}

	override Void onExit(StrBuf buf) { }
	
}
