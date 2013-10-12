
internal class TestBugFixes : SlimTest {
	
	Void testBugFromGundamIndex() {
s := """		p	| More recently, I discovered the 
        			a (href="http://fantom.org/") Fantom programming language
        			| , a niffty pragmatic language"""
		text := compiler.compileFromStr(``, s)

e := """<p><%#
        	%>More recently, I discovered the <%#
        	%><a href="http://fantom.org/">Fantom programming language</a><%#
        	%>, a niffty pragmatic language<%#
        %></p>"""

//<p><%#
//	%>More recently, I discovered the 		%><a href="http://fantom.org/">Fantom programming language</a><%#
//		%>, a niffty pragmatic language<%#
//<%#
//%></p>
		Env.cur.err.printLine(text)
		concurrent::Actor.sleep(20ms)	

		verifyEq(text, e)
	}
}
