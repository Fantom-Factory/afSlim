
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

	Void testBugFromGundamIndex2() {
s := """
        		p	| More recently
        			| re-writing Gundam in Fantom.
        		p	| And so was born Gundam v2.
        """
		renderer := slim.compileFromStr(s)

		text := renderer.render(null)
		print(text)
		verifyEq(text, "<p>More recently re-writing Gundam in Fantom.</p><p>And so was born Gundam v2.</p>")
	}
}
