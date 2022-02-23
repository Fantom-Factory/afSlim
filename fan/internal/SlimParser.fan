using afPlastic::SrcCodeSnippet

internal const class SlimParser {
	private const TagStyle				tagStyle
	private const SlimLineCompiler[]	compilers
	private const SlimComponent[]		components

	new make(TagStyle tagStyle, SlimComponent[] components) {
		this.tagStyle	= tagStyle
		this.components	= components
		this.compilers	= [
			SlimLineDoctypeCompiler(),
			SlimLineFanCodeCompiler(),
			SlimLineFanEvalCompiler(),
			SlimLineInstructionCompiler(),
			SlimLineFanCommentCompiler(),
			SlimLineHtmlCommentCompiler(),
			SlimLineBlockCommentCompiler(),
			SlimLineTextCompiler(),
		]
	}

	Void parse(Uri srcLocation, Str slimTemplate, SlimLine current) {
		compilers  := compilers.rw.add(SlimLineElementCompiler(tagStyle, components))
		srcSnippet := SrcCodeSnippet(srcLocation, slimTemplate)
		slimTemplate.splitLines.each |line, lineNo| {
			try {
				leadingWs 	:= line.chars.findIndex { !it.isSpace } ?: 0
				
				// this allows TextLines to consume / span across multiple lines
				if (!current.consume(leadingWs, line)) {
					source		:= line.trimStart
					multiLine	:= false
					while (!source.isEmpty) {
						lineCompiler	:= compilers.find { it.matches(source) }
						slimLine		:= lineCompiler.compile(source) { it.srcSnippet = srcSnippet; it.slimLineNo = lineNo; it.leadingWs = leadingWs }
						source			 = slimLine.nextLine?.trimStart ?: ""
						current 		 = current.add(slimLine, multiLine)
						multiLine		 = true
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
