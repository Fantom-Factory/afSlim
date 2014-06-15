
internal const class SlimLineBlockCommentCompiler : SlimLineCompiler {
	
	override Bool matches(Str line) {
		line.startsWith("/*")
	}
	
	override SlimLine compile(Str line) {
		SlimLineBlockComment(line[2..-1].trim)
	}
}

internal class SlimLineBlockComment : SlimLine, Escape {

	Str comment
	
	new make(Str comment) {
		this.comment = comment
	}
	
	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.add("<%# ${escapeEfan(comment)} %>")
		newLine(buf)
	}

	override Bool consume(Int leadingWs, Str line) {
		// consume all children!
		if (leadingWs <= this.leadingWs)
			return false
		
		line 	= line[this.leadingWs..-1]
		comment	+= "\n${line}"
		return true
	}
	
	override Void onExit(StrBuf buf) { }
	
	override Type[] legalChildren() {
		[SlimLine#]	// ALL SlimLines
	}
}
