
// FIXME: test comments can't contain nested slim lines
internal const class SlimLineFanCommentCompiler : SlimLineCompiler {
	
	override Bool matches(Str line) {
		line.startsWith("//")
	}
	
	override SlimLine compile(Str line) {
		SlimLineFanComment(line[2..-1].trim)
	}
}

internal class SlimLineFanComment : SlimLine {

	Str comment
	
	new make(Str comment) {
		this.comment = comment
	}
	
	override Void onEntry(StrBuf buf) {
		buf.add("<%# ${comment} %>\n")
	}

	override Void onExit(StrBuf buf) { }
}
