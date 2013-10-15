
internal class TestFanCode : SlimTest {
	
	Void test1Line() {
s := """-- if (wotever) ... """
		text := slim.parseFromStr(s)
		verifyEq(text, "<% if (wotever) ... %>")
	}

	Void testMultiline() {
s := """-- if (wotever) 
          para"""
		text := slim.parseFromStr(s)
		verifyEq(text, "<% if (wotever) { %><%#\n\t%><para></para><%#\n%><% } %>")
	}

}