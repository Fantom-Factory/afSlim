
internal class TestElement : SlimTest {
	
	Void testTags() {
s := """tag"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag></tag>\n")
	}

	Void testText() {
s := """tag text"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag>text</tag>\n")
	}

	Void testAttributes() {
s := """tag(data="wotever") text"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag data=\"wotever\">text</tag>\n")
	}

	Void testAttributes2() {
s := """tag (data="wotever") text"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag data=\"wotever\">text</tag>\n")
	}

	Void testAttributesSquare() {
s := """tag[data="wotever"] (text)"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag data=\"wotever\">(text)</tag>\n")
	}

	Void testAttributesSquare2() {
s := """tag [data="wotever"] (text)"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag data=\"wotever\">(text)</tag>\n")
	}

	Void testAttributesCurly() {
s := """tag{data="wotever"} [text]"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag data=\"wotever\">[text]</tag>\n")
	}

	Void testAttributesCurly2() {
s := """tag {data="wotever"} [text]"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag data=\"wotever\">[text]</tag>\n")
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

	Void testMultiClass() {
s := """tag.class1.class2"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag class=\"class1 class2\"></tag>\n")
	}

	Void testEverythingTogether() {
s := """tag#id.class (wot="ever") stuff"""
		text := compiler.compile(``, s)
		verifyEq(text, """<tag id="id" class="class" wot="ever">stuff</tag>\n""")
	}

	Void testNameAndText() {
s := """title dude :: still text!"""
		text := compiler.compile(``, s)
		verifyEq(text, """<title>dude :: still text!</title>\n""")
	}

	Void testNameAndAttr() {
s := """meta (name="bier") """
		text := compiler.compile(``, s)
		verifyEq(text, """<meta name="bier"></meta>\n""")
	}

	Void testAttributesMixed() {
s := """tag(data="[wot]{ever}") text"""
		text := compiler.compile(``, s)
		verifyEq(text, "<tag data=\"[wot]{ever}\">text</tag>\n")
	}
}