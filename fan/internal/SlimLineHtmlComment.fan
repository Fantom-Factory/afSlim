
internal const class SlimLineHtmlCommentCompiler : SlimLineCompiler {
	
	private const Method localeFn
	
	new make(Method localeFn) {
		this.localeFn = localeFn
	}
	
	override Bool matches(Str line) {
		line.startsWith("/!")
	}
	
	override SlimLine compile(Str line) {
		SlimLineHtmlComment(escape(line[2..-1].trim, localeFn))
	}
}

internal class SlimLineHtmlComment : SlimLine {

	Str comment
	
	new make(Str comment) {
		this.comment = comment
	}
	
	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.add("<!-- ${comment} -->")
		newLine(buf)
	}

	override Void onExit(StrBuf buf) { }
}
