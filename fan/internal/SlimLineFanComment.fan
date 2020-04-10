
internal const class SlimLineFanCommentCompiler : SlimLineCompiler {
	
	override Bool matches(Str line) {
		line.startsWith("//")
	}
	
	override SlimLine compile(Str line) {
		SlimLineFanComment(line[2..-1].trim)
	}
}

internal class SlimLineFanComment : SlimLine, SlimEscape {

	Str comment
	
	new make(Str comment) {
		this.comment = comment
	}
	
	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.add("<%# ${escapeEfan(comment)} %>")
		newLine(buf)
	}

	override Void onExit(StrBuf buf) { }
	
	override Type[] legalChildren() {
		parent.legalChildren	// whatever we're embedded in
	}
}
