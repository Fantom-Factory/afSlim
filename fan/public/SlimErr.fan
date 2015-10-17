using afPlastic::SrcCodeErr
using afPlastic::SrcCodeSnippet

** As thrown by Slim.
const class SlimErr : Err {
	new make(Str msg := "", Err? cause := null) : super(msg, cause) {}
}

** As thrown by Slim.
@NoDoc
const class SlimParseErr : SlimErr, SrcCodeErr {
	const override SrcCodeSnippet 	srcCode
	const override Int 				errLineNo
	const override Int 				linesOfPadding

	internal new make(SrcCodeSnippet srcCode, Int errLineNo, Str errMsg, Int linesOfPadding) : super(errMsg) {
		this.srcCode = srcCode
		this.errLineNo = errLineNo
		this.linesOfPadding = linesOfPadding
	}
	
	@NoDoc
	override Str toStr() {
		trace := causeStr
		trace += snippetStr
		trace += "Stack Trace:"
		return trace
	}
	
	private Str causeStr() {
		cause == null 
			? "${typeof.qname}: ${msg}" 
			: "${cause.typeof.qname}: ${msg}"
	}

	private Str snippetStr() {
		snippet := "\n${typeof.name.toDisplayName}:\n"
		snippet += toSnippetStr
		return snippet
	}
}
