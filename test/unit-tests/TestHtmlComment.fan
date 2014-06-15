
internal class TestHtmlComment : SlimTest {
	
	Void testFanComment() {
		text := slim.parseFromStr("/! wotever")
		verifyEq(text, "<!-- wotever -->")
	}

	Void testFanCommentTrim() {
		text := slim.parseFromStr("/!    wotever     ")
		verifyEq(text, "<!-- wotever -->")
	}

	Void testEfanInComment() {
		text := slim.renderFromStr("/! wotever \${1+1}")
		verifyEq(text, "<!-- wotever 2 -->")
	}

	Void testEfan2InComment() {
		text := slim.renderFromStr("/! wot%>ever")
		verifyEq(text, "<!-- wot%>ever -->")
	}
}