
internal class TestMultiline : SlimTest {

	Void testOneLine() {
		text := compiler.compileFromStr(``, "html")
		verifyEq(text, "<html></html>")
	}

	Void test1SpaceSimpleNested() {
s := """html
         head"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<html><%#\n\t%><head></head><%#\n%></html>")
	}

	Void test2SpaceSimpleNested() {
s := """html
          head"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<html><%#\n\t%><head></head><%#\n%></html>")
	}

	Void testSimpleSibling() {
s := """html1
        html2"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<html1></html1><%#\n%><html2></html2>")
	}

	Void testMultiLine() {
s := """html
          head
          body"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<html><%#\n\t%><head></head><%#\n\t%><body></body><%#\n%></html>")
	}

	Void testHangingNesting() {
s := """html
          body
            div"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<html><%#\n\t%><body><%#\n\t\t%><div></div><%#\n\t%></body><%#\n%></html>")
	}

	Void testHangingSibling() {
s := """html1
          body
            div
        html2"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<html1><%#\n\t%><body><%#\n\t\t%><div></div><%#\n\t%></body><%#\n%></html1><%#\n%><html2></html2>")
	}

}
