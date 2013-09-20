
internal class TestEscaping : SlimTest {
	
	SlimLineCompiler oneLine	:= SlimLineElementCompiler()
	
	Void testBasic() {
		text := oneLine.escape("\${wotever}")
		verifyEq(text, "<%= wotever %>")
	}

	Void testBefore() {
		text := oneLine.escape("before\${wotever}")
		verifyEq(text, "before<%= wotever %>")
	}

	Void testAfter() {
		text := oneLine.escape("\${wotever}after")
		verifyEq(text, "<%= wotever %>after")
	}

	Void testHanging() {
		text := oneLine.escape("before\${wotever")
		verifyEq(text, "before\${wotever")
	}

	Void testMultiple() {
		text := oneLine.escape("before \${1} middle \${2} end")
		verifyEq(text, "before <%= 1 %> middle <%= 2 %> end")
	}

	// ---- Escaping Tests 
	
	Void testEscaping() {
		text := oneLine.escape("\\\${wotever}")
		verifyEq(text, "\${wotever}")
	}

	Void testEscapingBoth() {
		text := oneLine.escape("before\\\${wotever}after")
		verifyEq(text, "before\${wotever}after")
	}

	Void testEscapingHanging() {
		text := oneLine.escape("before\\\${wotever")
		verifyEq(text, "before\\\${wotever")
	}
}