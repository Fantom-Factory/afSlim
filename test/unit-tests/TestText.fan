
internal class TestText : SlimTest {
	
	Void testTextBasic() {
s := """| Dude"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "Dude\n")
	}

	Void testTextBasicPreservesWhitespace() {
s := """|  Dude"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, " Dude\n")
	}

	Void testMultipleTextsInsertWhitespace() {
s := """| Wot
        | ever"""
		text := compiler.compileFromStr(``, s)
		// this ensures sentencesdon't suddenly loose spacesbetween words when wrapped!
		verifyEq(text, "Wot \never\n")
	}

	Void testTextWithElements() {
s := """| Wot
        a.link thing
        | Ever"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "Wot\n<a class=\"link\">thing</a>\nEver\n")
	}

	Void testNestedText() {
s := """|
        	Dude"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "\nDude\n")
	}

	Void testNestedMultiText() {
s := """|
          alert();
            console.log;"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "\n alert();\n   console.log;\n")
	}

	Void testNestedNestedIsIgnored() {
s := """| wot
           | ever"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "wot\n | ever\n")
	}

	// Advanced!!!
	Void testElementContainsText() {
s := """a.link |
        	    link text"""	// tab + 4 spaces - trim empty lines
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<a class=\"link\">\n\t\n    link text\n</a>\n")
	}

	Void testElementContainsText2() {
		// testing the space before pipe (BUGFIX!)
s := """script (type='text/javascript') |
        	alert();"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<script type='text/javascript'>\n\t\nalert();\n</script>\n")
	}

}