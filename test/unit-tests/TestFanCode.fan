
internal class TestFanCode : SlimTest {
	
	Void test1Line() {
s := """-- if (wotever) ... """
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<% if (wotever) ... %>\n")
	}

	Void testMultiline() {
s := """-- if (wotever) 
          para"""
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<% if (wotever) { %>\n\t<para></para>\n<% } %>\n")
	}

}