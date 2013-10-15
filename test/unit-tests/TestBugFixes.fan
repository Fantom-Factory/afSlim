
internal class TestBugFixes : SlimTest {
	
	Void testBugFromGundamIndex() {
s := """		p	| More recently, I discovered the 
        			a (href="http://fantom.org/") Fantom programming language
        			| , a niffty pragmatic language"""
		text := slim.parseFromStr(s)

e := """<p><%#
        	%>More recently, I discovered the <%#
        	%><a href="http://fantom.org/">Fantom programming language</a><%#
        	%>, a niffty pragmatic language<%#
        %></p>"""

		print(text)
		verifyEq(text, e)
	}
}
