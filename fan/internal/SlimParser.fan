
internal const class SlimParser {

	const  Int 	srcCodePadding	:= 5 

	const SlimLineCompiler[]	compilers := 
		[	SlimLineDoctypeCompiler(),
			SlimLineFanCodeCompiler(),
			SlimLineFanEvalCompiler(),
			SlimLineFanCommentCompiler(),
			SlimLineHtmlCommentCompiler(),
			SlimLineElementCompiler()
		].toImmutable


	new make(|This|? in := null) { in?.call(this) }
	
	Void parse(Uri srcLocation, Str slimTemplate, SlimLine tree) {
		
		current		:= tree
		
		slimTemplate.splitLines.each |line, lineNo| {
			if (line.trim.isEmpty)
				return
			
			leadingWs 		:= line.chars.findIndex { !it.isSpace  } ?: 0
			source			:= line.trimStart
			lineCompiler	:= compilers.find { it.matches(source) }
			slimLine		:= lineCompiler.compile(source) { it.slimLineNo = lineNo; it.leadingWs = leadingWs }
			
			current 		= current.add(slimLine)
		}
		
		Env.cur.err.printLine(tree.toEfan(StrBuf()).toStr)
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



