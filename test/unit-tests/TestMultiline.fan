
internal class TestMultiline : SlimTest {

	Void testOneLine() {
		text := compiler.compile(``, "html")
		verifyEq(text, "<html></html>\n")
	}

	Void test1SpaceSimpleNested() {
s := """html
         head"""
		text := compiler.compile(``, s)
		verifyEq(text, "<html>\n\t<head></head>\n</html>\n")
	}

	Void test2SpaceSimpleNested() {
s := """html
          head"""
		text := compiler.compile(``, s)
		verifyEq(text, "<html>\n\t<head></head>\n</html>\n")
	}

	Void testSimpleSibling() {
s := """html1
        html2"""
		text := compiler.compile(``, s)
		verifyEq(text, "<html1></html1>\n<html2></html2>\n")
	}

	Void testMultiLine() {
s := """html
          head
          body"""
		text := compiler.compile(``, s)
		verifyEq(text, "<html>\n\t<head></head>\n\t<body></body>\n</html>\n")
	}

	Void testHangingNesting() {
s := """html
          body
            div"""
		text := compiler.compile(``, s)
		verifyEq(text, "<html>\n\t<body>\n\t\t<div></div>\n\t</body>\n</html>\n")
	}

	Void testHangingSibling() {
s := """html1
          body
            div
        html2"""
		text := compiler.compile(``, s)
		verifyEq(text, "<html1>\n\t<body>\n\t\t<div></div>\n\t</body>\n</html1>\n<html2></html2>\n")
	}

}
