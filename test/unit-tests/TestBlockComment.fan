
internal class TestBlockComment : SlimTest {
	
	Void testSimpleNested() {
s := """html
         /* head
        body"""
		text := slim.renderFromStr(s)
		verifyEq(text, "<html></html><body></body>")
	}

	Void testSimpleSibling() {
s := """html
        /* html2
        body"""
		text := slim.renderFromStr(s)
		verifyEq(text, "<html></html><body></body>")
	}

	Void testMultiLine() {
s := """html
          /* head
             body
          head2"""
		text := slim.renderFromStr(s)
		Env.cur.err.printLine(text)
		verifyEq(text, "<html><head2></head2></html>")
	}

	Void testMultiComments() {
s := """html
          /* head
             /* body
          head2"""
		text := slim.renderFromStr(s)
		verifyEq(text, "<html><head2></head2></html>")
	}
}

