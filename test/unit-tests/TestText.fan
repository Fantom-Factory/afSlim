
internal class TestText : SlimTest {
	
	Void testTextBasic() {
s := """| Dude"""
		text := slim.parseFromStr(s)
		verifyEq(text, "Dude")
	}

	Void testMultipleTextsInsertWhitespace() {
s := """| Wot
        | ever"""
		text := slim.parseFromStr(s)
		// this ensures sentencesdon't suddenly loose spacesbetween words when wrapped!
		verifyEq(text, "Wot <%#\n%>ever")
	}

	Void testTextWithElements() {
s := """| Wot
        a.link thing
        | Ever"""
		text := slim.parseFromStr(s)
		verifyEq(text, "Wot<%#\n%><a class=\"link\">thing</a><%#\n%>Ever")
	}

	Void testNestedText() {
s := """|
        	Dude"""
		text := slim.parseFromStr(s)
		verifyEq(text, "\nDude")
	}

	Void testNestedMultiText() {
s := """|
          alert();
            console.log;"""
		text := slim.parseFromStr(s)
		verifyEq(text, "\n alert();\n   console.log;")
	}

	Void testNestedNestedIsIgnored() {
s := """| wot
           | ever"""
		text := slim.parseFromStr(s)
		verifyEq(text, "wot\n | ever")
	}

	// Advanced!!!
	Void testElementContainsText() {
s := """a.link |
        	    link text"""	// tab + 4 spaces
		text := slim.renderFromStr(s)
		// we trim the tab
		verifyEq(text, "<a class=\"link\">    link text</a>")
	}

	Void testElementContainsText2() {
s := """script (type='text/javascript') |
        	alert();
        	var x = 3;
        a Dude"""
		text := slim.renderFromStr(s)
//<script type='text/javascript'><%#
//	%><%#
//	%><alert();></alert();><%#
//%></script>
		print(text)
		// we trim the leading tab
		verifyEq(text, "<script type='text/javascript'>alert();\nvar x = 3;</script><a>Dude</a>")
	}

	Void testTextCanContainBlankLines() {
s := """script (type='text/javascript') |
        	alert();
        
        	var x = 3;
        a Dude"""
		text := slim.renderFromStr(s)
		verifyEq(text, "<script type='text/javascript'>alert();\n\nvar x = 3;</script><a>Dude</a>")
	}
}