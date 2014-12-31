using afPlastic::SrcCodeSnippet

internal const class SlimParser {

	private const SlimLineCompiler[] compilers

	new make(TagStyle tagStyle) {
		this.compilers = [
			SlimLineDoctypeCompiler(),
			SlimLineFanCodeCompiler(),
			SlimLineFanEvalCompiler(),
			SlimLineInstructionCompiler(),
			SlimLineFanCommentCompiler(),
			SlimLineHtmlCommentCompiler(),
			SlimLineBlockCommentCompiler(),
			SlimLineTextCompiler(),
			SlimLineElementCompiler(tagStyle)
		]
	}

	Void parse(Uri srcLocation, Str slimTemplate, SlimLine current) {
		srcSnippet := SrcCodeSnippet(srcLocation, slimTemplate)
		slimTemplate.splitLines.each |line, lineNo| {
			try {
				leadingWs 	:= line.chars.findIndex { !it.isSpace } ?: 0
				source		:= line.trimStart
				
				// this allows TextLines to consume / span across multiple lines
				if (!current.consume(leadingWs, line)) {
					while (!source.isEmpty) {
						lineCompiler	:= compilers.find { it.matches(source) }
						slimLine		:= lineCompiler.compile(source) { it.srcSnippet = srcSnippet; it.slimLineNo = lineNo; it.leadingWs = leadingWs }
						current 		= current.add(slimLine)
						source			= slimLine.nextLine ?: ""

						if (slimLine.multiLineTextFudge)
							leadingWs++
					}					
				}
			} catch (SlimErr slimErr) {
				snippet := SrcCodeSnippet(srcLocation, slimTemplate)
				// + 1 'cos lineNo is zero based
				throw SlimParseErr(snippet, lineNo + 1, slimErr.msg, 5)
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
	
	override Type[] legalChildren() {
		[SlimLine#]	// ALL SlimLines
	}
}



