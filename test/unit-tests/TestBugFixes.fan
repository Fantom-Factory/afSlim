
internal class TestBugFixes : SlimTest {
	
	Void testBugFromGundamIndex() {
s := """		p
        			| More recently, I discovered the 
        			a (href="http://fantom.org/") Fantom programming language
        			| , a niffty pragmatic language"""
		text := slim.parseFromStr(s)

e := """<p><%#
        	%>More recently, I discovered the <%#
        	%><a href="http://fantom.org/">Fantom programming language</a><%#
        	%>, a niffty pragmatic language<%#
        %></p>"""

		verifyEq(text, e)
	}

	Void testBugFromGundamIndex2() {
s := """
        		p
        			| More recently
        			| re-writing Gundam in Fantom.
        		p
        			| And so was born Gundam v2.
        """
		renderer := slim.compileFromStr(s)
		text 	 := renderer.render(null)
		verifyEq(text, "<p>More recently re-writing Gundam in Fantom.</p><p>And so was born Gundam v2.\n</p>")
	}
	
	// Fook this - I discovered that *I* want text on multilines - it just looks better!
//	Void testBugFromGundamIndex3() {
//		// don't allow text on multilines - for it leads you down a BAD path, i.e. testBugFromGundamIndex
//		// will no longer work
//s := """		p	| More recently
//        			| re-writing Gundam in Fantom.
//        		p	| And so was born Gundam v2.
//        """
//		renderer := slim.compileFromStr(s)
//		text 	 := renderer.render(null)
//		print(text)
//		verifyEq(text, "<p>| More recentlyre-writing Gundam in Fantom.</p><p>| And so was born Gundam v2.</p>")
//	}

	Void testHowMultilineUsage1() {
s := """		p	| More recently
        			  re-writing Gundam in Fantom.
        			  Again.
        """
		renderer := slim.compileFromStr(s)
		text 	 := renderer.render(null)
		verifyEq(text, "<p>More recently\n re-writing Gundam in Fantom.\n Again.\n</p>")
	}

	Void testHowMultilineUsage2() {
s := """		p|More recently
        		  re-writing Gundam in Fantom.
        		  Again.
        """
		renderer := slim.compileFromStr(s)
		text 	 := renderer.render(null)
		verifyEq(text, "<p>More recently\nre-writing Gundam in Fantom.\nAgain.\n</p>")
	}

	Void testHowMultilineUsage3() {
s := """		p |	And so was born Gundam v2.
        		 	Maybe there'll be a v3?
        """
		renderer := slim.compileFromStr(s)
		text 	 := renderer.render(null)
		verifyEq(text, "<p>And so was born Gundam v2.\nMaybe there'll be a v3?\n</p>")
	}

	Void testHowMultilineUsage4() {
s := """		p | etc/
        		     |--web.fan
        """
		renderer := slim.compileFromStr(s)
		text 	 := renderer.render(null)
		verifyEq(text, "<p>etc/\n   |--web.fan\n</p>")
	}

	Void testHowMultilineUsage5() {
s := """		p | 
        		    etc/
        		     |--web.fan
        """
		renderer := slim.compileFromStr(s)
		text 	 := renderer.render(null)
		verifyEq(text, "<p>   etc/\n    |--web.fan\n</p>")
	}

	Void testHowMultilineUsage6() {
s := """		p	| More recently
        			| re-writing Gundam in Fantom.
        			| Again.
        """
		renderer := slim.compileFromStr(s)
		text 	 := renderer.render(null)
		print(text)
		verifyEq(text, "<p>More recently re-writing Gundam in Fantom. Again.\n</p>")
	}

	Void testAddingLeadingSpacesToText() {
s := """a wot
        |  ever
        """
		renderer := slim.compileFromStr(s)
		text 	 := renderer.render(null)
		verifyEq(text, "<a>wot</a> ever\n")
	}

	Void testMutilineTextIsInterpolated() {
s := """| line 1 \${ctx}
          line 2 \${ctx}
        """
		renderer := slim.compileFromStr(s)
		text 	 := renderer.render("HaHa!")
		verifyEq(text, "line 1 HaHa!\nline 2 HaHa!\n")
	}
	
	// ---- Slim v1.1 --------------------------------------------------------------------------------------------------

	Void testNullsAreRendered() {
		text	:= slim.renderFromStr("|[\${ctx}]", (Str?) null)
		verifyEq(text, "[null]")
	}

	Void testNullsAreRendered2() {
		text	:= slim.renderFromStr("|[\${ctx}]", "null")	// test compilation of non-null
		verifyEq(text, "[null]")
	}

	Void testBracketsAllowedInText() {
		text	:= slim.renderFromStr("a (href=url) Embedded Fantom (efan)", null)
		verifyEq(text, "<a href=url>Embedded Fantom (efan)</a>")
	}

	Void testBracketsAllowedInText2() {
		text	:= slim.renderFromStr("a [href=url] Embedded Fantom [efan]", null)
		verifyEq(text, "<a href=url>Embedded Fantom [efan]</a>")
	}
}
