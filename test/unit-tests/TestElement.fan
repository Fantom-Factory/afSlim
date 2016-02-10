
internal class TestElement : SlimTest {
	
	Void testTags() {
s := """tag"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag></tag>")
	}

	Void testText() {
s := """tag text"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag>text</tag>")
	}

	Void testAttributes() {
s := """tag(data="wotever") text"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag data=\"wotever\">text</tag>")
	}

	Void testAttributes2() {
s := """tag (data="wotever") text"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag data=\"wotever\">text</tag>")
	}

	Void testAttributesSquare() {
s := """tag[data="wotever"] (text)"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag data=\"wotever\">(text)</tag>")
	}

	Void testAttributesSquare2() {
s := """tag [data="wotever"] (text)"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag data=\"wotever\">(text)</tag>")
	}

	Void testId() {
s := """tag#id"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag id=\"id\"></tag>")
	}

	Void testClass() {
s := """tag.class"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag class=\"class\"></tag>")
	}

	Void testMultiClass() {
s := """tag.class1.class2"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag class=\"class1 class2\"></tag>")
	}

	Void testEverythingTogether() {
s := """tag#id.class (wot="ever") stuff"""
		text := slim.parseFromStr(s)
		verifyEq(text, """<tag id="id" class="class" wot="ever">stuff</tag>""")
	}

	Void testNameAndText() {
s := """title dude :: still text!"""
		text := slim.parseFromStr(s)
		verifyEq(text, """<title>dude :: still text!</title>""")
	}

	Void testNameAndAttr() {
s := """dude (name="bier") """
		text := slim.parseFromStr(s)
		verifyEq(text, """<dude name="bier"></dude>""")
	}

	Void testAttributesMixed() {
s := """tag(data="[wot]{ever}") text"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag data=\"[wot]{ever}\">text</tag>")
	}

	Void testAttributesWithEscapedId() {
s := """tag#\$\${id} (data="wot") ever"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag id=\"<%= id %>\" data=\"wot\">ever</tag>")
	}

	Void testAttributesWithEscapedClass() {
s := """tag.\$\${id} (data="wot") ever"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag class=\"<%= id %>\" data=\"wot\">ever</tag>")
	}

	Void testNestedRoundBrackets() {
s := """tag (data="wot()") ever"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag data=\"wot()\">ever</tag>")
	}

	Void testNestedSquareBrackets() {
s := """tag[data="wot[0]"] ever"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag data=\"wot[0]\">ever</tag>")
	}

	Void testLotsaNestedRoundBrackets() {
s := """tag (data="wot(.(.(.(.(.).).).).)") ever"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<tag data=\"wot(.(.(.(.(.).).).).)\">ever</tag>")
	}
	
	Void testInterpolationInId() {
		s := "tag#\${ctx.toStr} dude"
		text := slim.renderFromStr(s, "wotever")
		verifyEq(text, "<tag id=\"wotever\">dude</tag>")		
	}

	Void testInterpolationInClass() {
		s := "tag.\${ctx.toStr} dude"
		text := slim.renderFromStr(s, "wotever")
		verifyEq(text, "<tag class=\"wotever\">dude</tag>")		
	}

	Void testInterpolationInClassAndId() {
		s := "tag#\${ctx.toStr}.\${ctx.toStr} dude"
		text := slim.renderFromStr(s, "wotever")
		verifyEq(text, "<tag id=\"wotever\" class=\"wotever\">dude</tag>")		
	}

	Void testSpacesInInterpolationInClassAndId() {
		s := "tag#\${ ctx.toStr }.\${ ctx.toStr } dude"
		text := slim.renderFromStr(s, "wotever")
		verifyEq(text, "<tag id=\"wotever\" class=\"wotever\">dude</tag>")		
	}

	Void testSpacesAtStartOfElementAreRetained() {
		// useful for ensuring tags don't butt up against each other
		// see SlimLineElement.make(...)
		s := "tag  dude"
		text := slim.renderFromStr(s, "wotever")
		verifyEq(text, "<tag> dude</tag>")		

		s = "tag#\${ ctx.toStr }.\${ ctx.toStr }  dude"
		text = slim.renderFromStr(s, "wotever")
		verifyEq(text, "<tag id=\"wotever\" class=\"wotever\"> dude</tag>")		
	}
}