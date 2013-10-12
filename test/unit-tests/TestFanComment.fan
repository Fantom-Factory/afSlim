
internal class TestFanComment : SlimTest {
	
	Void testFanComment() {
		text := compiler.compileFromStr(``, "// wotever")
		verifyEq(text, "<%# wotever %>")
	}

	Void testFanCommentTrim() {
		text := compiler.compileFromStr(``, "//    wotever     ")
		verifyEq(text, "<%# wotever %>")
	}

}

