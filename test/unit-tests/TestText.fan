
internal class TestText : SlimTest {
	
	Void testTextBasic() {
s := """| Dude"""
		text := slim.parseFromStr(s)
		verifyEq(text, "Dude")
	}

	Void testTextBasicPreservesWhitespace() {
s := """|  Dude"""
		text := slim.parseFromStr(s)
		verifyEq(text, " Dude")
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
		print(text)
		verifyEq(text, "wot\n| ever")
	}

	// Advanced!!!
	Void testElementContainsText() {
s := """a.link |
        	    link text"""	// tab + 4 spaces - trim empty lines
		text := slim.parseFromStr(s)
		print(text)
		// only 3 spaces added before 'link text' because 1 is always chomped after |
		verifyEq(text, "<a class=\"link\"><%#\n\t%>\n    link text<%#\n%></a>")
	}

	Void testElementContainsText2() {
s := """script (type='text/javascript') |
        	alert();"""
		text := slim.parseFromStr(s)
//<script type='text/javascript'><%#
//	%><%#
//	%><alert();></alert();><%#
//%></script>
		print(text)
		// there's this extra <%#\n\t%> but as it's an efan comment - I don't case! 
		verifyEq(text, "<script type='text/javascript'><%#\n\t%>\nalert();<%#\n%></script>")
	}

//s := """
//        		p	| More recently
//        			| re-writing Gundam in Fantom.
//        		p	| And so was born Gundam v2.
//        """
	
}