using afPlastic::SrcCodeErr
using afPlastic::SrcCodeSnippet

** As thrown by Slim.
const class SlimErr : Err {
	new make(Str msg := "", Err? cause := null) : super(msg, cause) {}
}

** As thrown by Slim.
const class SlimParserErr : SlimErr, SrcCodeErr {
	const override SrcCodeSnippet 	srcCode
	const override Int 				errLineNo
	private const  Int 				linesOfPadding

	internal new make(SrcCodeSnippet srcCode, Int errLineNo, Str errMsg, Int linesOfPadding) : super(errMsg) {
		this.srcCode = srcCode
		this.errLineNo = errLineNo
		this.linesOfPadding = linesOfPadding
	}
	
	override Str toStr() {
		print(msg, linesOfPadding)
	}
}
