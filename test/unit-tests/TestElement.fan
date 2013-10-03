
internal class TestElement : SlimTest {
	
	Void testTags() {
s := """tag"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag></tag>\n")
	}

	Void testText() {
s := """tag text"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag>text</tag>\n")
	}

	Void testAttributes() {
s := """tag(data="wotever") text"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag data=\"wotever\">text</tag>\n")
	}

	Void testAttributes2() {
s := """tag (data="wotever") text"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag data=\"wotever\">text</tag>\n")
	}

	Void testAttributesSquare() {
s := """tag[data="wotever"] (text)"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag data=\"wotever\">(text)</tag>\n")
	}

	Void testAttributesSquare2() {
s := """tag [data="wotever"] (text)"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag data=\"wotever\">(text)</tag>\n")
	}

	Void testAttributesCurly() {
s := """tag{data="wotever"} [text]"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag data=\"wotever\">[text]</tag>\n")
	}

	Void testAttributesCurly2() {
s := """tag {data="wotever"} [text]"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag data=\"wotever\">[text]</tag>\n")
	}

	Void testId() {
s := """tag#id"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag id=\"id\"></tag>\n")
	}

	Void testClass() {
s := """tag.class"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag class=\"class\"></tag>\n")
	}

	Void testMultiClass() {
s := """tag.class1.class2"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag class=\"class1 class2\"></tag>\n")
	}

	Void testEverythingTogether() {
s := """tag#id.class (wot="ever") stuff"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, """<tag id="id" class="class" wot="ever">stuff</tag>\n""")
	}

	Void testNameAndText() {
s := """title dude :: still text!"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, """<title>dude :: still text!</title>\n""")
	}

	Void testNameAndAttr() {
s := """dude (name="bier") """
		text := compiler.compileFromStr(``, s)
		verifyEq(text, """<dude name="bier"></dude>\n""")
	}

	Void testAttributesMixed() {
s := """tag(data="[wot]{ever}") text"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<tag data=\"[wot]{ever}\">text</tag>\n")
	}
}