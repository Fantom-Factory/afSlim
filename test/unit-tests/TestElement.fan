
internal class TestElement : SlimTest {
	
	Void testTags() {
s := """tag"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag></tag>\n")
	}

	Void testText() {
s := """tag: text"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag>text</tag>\n")
	}

	Void testAttributes() {
s := """tag data="wotever": text"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag data=\"wotever\">text</tag>\n")
	}

	Void testId() {
s := """tag#id"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag id=\"id\"></tag>\n")
	}

	Void testClass() {
s := """tag.class"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag class=\"class\"></tag>\n")
	}

	Void testEverythingTogether() {
s := """tag#id.class wot="ever": stuff"""
		text := compiler.compile(``, s)
		verifyEq(text, """<tag id="id" class="class" wot="ever">stuff</tag>\n""")
	}

}