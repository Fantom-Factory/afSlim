
internal class TestFanComment : SlimTest {
	
	Void testFanComment() {
		text := slim.parseFromStr("// wotever")
		verifyEq(text, "<%# wotever %>")
	}

	Void testFanCommentTrim() {
		text := slim.parseFromStr("//    wotever     ")
		verifyEq(text, "<%# wotever %>")
	}

}

