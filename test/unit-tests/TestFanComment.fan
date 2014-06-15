
internal class TestFanComment : SlimTest {
	
	Void testFanComment() {
		text := slim.parseFromStr("// wotever")
		verifyEq(text, "<%# wotever %>")
	}

	Void testFanCommentTrim() {
		text := slim.parseFromStr("//    wotever     ")
		verifyEq(text, "<%# wotever %>")
		
		text = slim.renderFromStr("//    wotever     ")
		verifyEq(text, "")
	}
	
	Void testEfanInComment() {
		text := slim.parseFromStr("// wot%>ever")
		verifyEq(text, "<%# wot%%>ever %>")
		
		text = slim.renderFromStr("// wot%>ever")
		verifyEq(text, "")
	}

	Void testSimpleNested() {
s := """html
         // head
        body"""
		text := slim.renderFromStr(s)
		verifyEq(text, "<html></html><body></body>")
	}

	Void testSimpleSibling() {
s := """html1
        // html2
        body"""
		text := slim.renderFromStr(s)
		verifyEq(text, "<html1></html1><body></body>")
	}

	Void testMultiLine() {
s := """html
          // head
             body
          head2"""
		text := slim.renderFromStr(s)
		verifyEq(text, "<html><body></body><head2></head2></html>")
	}

	Void testNestedComment() {
s := """html
          // head
             // body
        html2"""
		text := slim.renderFromStr(s)
		verifyEq(text, "<html></html><html2></html2>")
	}

	Void testMultiComment() {
s := """html
          // // head
          // body
        html2"""
		text := slim.renderFromStr(s)
		verifyEq(text, "<html></html><html2></html2>")
	}

	Void testCommentsDontExecute() {
s := """html
          // before \${head} after
        """
		text := slim.renderFromStr(s)
		verifyEq(text, "<html></html>")
	}
}

