
internal class TestMultilineSyntax : SlimTest {
	
	Void testMultiline1() {
		s := "li; a text"
		text := slim.renderFromStr(s)
		verifyEq(text, "<li><a>text</a></li>")
	}
	
	Void testMultiline2() {
		s := "li; a
		        span wotever"
		text := slim.renderFromStr(s)
		verifyEq(text, "<li><a><span>wotever</span></a></li>")
	}
	
	Void testMultiline3() {
		s := "li; a (href=\"#\"); span wotever"
		text := slim.renderFromStr(s)
		verifyEq(text, "<li><a href=\"#\"><span>wotever</span></a></li>")
	}
	
	Void testMultiline4() {
		s := "div
		        li; a (href=\"#\");
		          span wotever"
		text := slim.renderFromStr(s)
		verifyEq(text, "<div><li><a href=\"#\"><span>wotever</span></a></li></div>")
	}

	Void testNonMultiline() {
		s := "div ; Dude!"
		text := slim.renderFromStr(s)
		verifyEq(text, "<div>; Dude!</div>")
	}

	Void testEmptyMultiline() {
		s := "div;
		      div;"
		text := slim.renderFromStr(s)
		verifyEq(text, "<div></div><div></div>")
	}
}
