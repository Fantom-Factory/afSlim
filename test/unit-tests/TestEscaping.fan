
internal class TestEscaping : SlimTest {
	
	SlimLineCompiler oneLine	:= SlimLineElementCompiler()
	
	Void testBasic() {
		text := oneLine.escape("\${wotever}")
		verifyEq(text, "<%= wotever %>")
	}

//	Void testEscaping() {
//		text := oneLine.escape("\\\${wotever}")
//		Env.cur.err.printLine(text)
//		verifyEq(text, "\${wotever}")
//	}
//
//	Void testBefore() {
//		text := oneLine.escape("before\${wotever}")
//		verifyEq(text, "before<%= wotever %>")
//	}
//
//	Void testAfter() {
//		text := oneLine.escape("\${wotever}after")
//		verifyEq(text, "<%= wotever %>after")
//	}
//
//	Void testEscapingBoth() {
//		text := oneLine.escape("before\\\${wotever}after")
//		verifyEq(text, "before\${wotever}after")
//	}
//
//	Void testEscapingHanging() {
//		text := oneLine.escape("before\\\${wotever")
//		verifyEq(text, "before\${wotever")
//	}
//
//	Void testHanging() {
//		verifySlimErrMsg("Wotever") {
//			oneLine.escape("before\${wotever")
//		}
//	}

}