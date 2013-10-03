
internal class TestFanComment : SlimTest {
	
	Void testFanComment() {
		text := compiler.compileFromStr(``, "// wotever")
		verifyEq(text, "<%# wotever %>\n")
	}

	Void testFanCommentTrim() {
		text := compiler.compileFromStr(``, "//    wotever     ")
		verifyEq(text, "<%# wotever %>\n")
	}

}

