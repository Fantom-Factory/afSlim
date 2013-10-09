
internal const class SlimParser {

	const SlimLineCompiler[]	compilers := 
		[	SlimLineDoctypeCompiler(),
			SlimLineFanCodeCompiler(),
			SlimLineFanEvalCompiler(),
			SlimLineFanCommentCompiler(),
			SlimLineHtmlCommentCompiler(),
			SlimLineTextCompiler(),
			SlimLineElementCompiler()
		].toImmutable


	Void parse(Uri srcLocation, Str slimTemplate, SlimLine current) {
		
		slimTemplate.splitLines.each |line, lineNo| {
			if (line.trim.isEmpty)
				return
			
			leadingWs 	:= line.chars.findIndex { !it.isSpace } ?: 0
			source		:= line.trimStart
			
			if (!current.consume(leadingWs, source)) {
				lineCompiler	:= compilers.find { it.matches(source) }
				slimLine		:= lineCompiler.compile(source) { it.slimLineNo = lineNo; it.leadingWs = leadingWs }
				current 		= current.add(slimLine)
				
				// fudge for: script (type="text/javascript") | 
				if (current.isMultiLine) {
					multiLine	:= current.multiLine.with { it.slimLineNo = lineNo; it.leadingWs = leadingWs}
					current		= current.addChild(multiLine)
				}
			}
		}
	}
}


internal class SlimLineRoot : SlimLine {

	new make() {
		super.leadingWs = -1
		super.indentBy	= -1
	}
	
	override Void onEntry(StrBuf buf) {	}
	override Void onExit(StrBuf buf) {	}
}



