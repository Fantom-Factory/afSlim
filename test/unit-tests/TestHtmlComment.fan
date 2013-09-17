
internal class TestHtmlComment : SlimTest {
	
	Void testFanComment() {
		text := compiler.compile(``, "/! wotever")
		verifyEq(text, "<!-- wotever -->\n")
	}

	Void testFanCommentTrim() {
		text := compiler.compile(``, "/!    wotever     ")
		verifyEq(text, "<!-- wotever -->\n")
	}

}