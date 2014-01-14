using afEfan

abstract internal class SlimTest : Test {
	
	Slim			slim		:= Slim(TagStyle.html)
	EfanCompiler	efanComp	:= EfanCompiler()
	
	Void verifySlimErrMsg(Str errMsg, |Obj| func) {
		verifyErrTypeAndMsg(SlimErr#, errMsg, func)
	}

	protected Void verifyErrTypeAndMsg(Type errType, Str errMsg, |Obj| func) {
		try {
			func(69)
		} catch (Err e) {
			if (!e.typeof.fits(errType)) 
				throw Err("Expected $errType got $e.typeof", e)
			msg := e.msg
			if (msg != errMsg)
				verifyEq(errMsg, msg)	// this gives the Str comparator in eclipse
			return
		}
		throw Err("$errType not thrown")
	}
	
	Void print(Str text) {
		Env.cur.err.printLine("[$text]")
//		concurrent::Actor.sleep(20ms)
	}
}
