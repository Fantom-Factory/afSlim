
internal class TestEscaping : SlimTest {
	
	SlimLineElementCompiler oneLine	:= SlimLineElementCompiler(TagStyle.html)

	// ---- Escaped Text ----
	
	Void testBasic() {
		text := oneLine.escape("\${wotever}")
		verifyEq(text, "<%= (wotever).toStr.toXml %>")
	}

	Void testBefore() {
		text := oneLine.escape("before\${wotever}")
		verifyEq(text, "before<%= (wotever).toStr.toXml %>")
	}

	Void testAfter() {
		text := oneLine.escape("\${wotever}after")
		verifyEq(text, "<%= (wotever).toStr.toXml %>after")
	}

	Void testHanging() {
		text := oneLine.escape("before\${wotever")
		verifyEq(text, "before\${wotever")
	}

	Void testMultiple() {
		text := oneLine.escape("before \${1} middle \${2} end")
		verifyEq(text, "before <%= (1).toStr.toXml %> middle <%= (2).toStr.toXml %> end")
	}

	// ---- Unescaped Text ----
	
	Void testBasic2() {
		text := oneLine.escape("\$\${wotever}")
		verifyEq(text, "<%= wotever %>")
	}

	Void testBefore2() {
		text := oneLine.escape("before\$\${wotever}")
		verifyEq(text, "before<%= wotever %>")
	}

	Void testAfter2() {
		text := oneLine.escape("\$\${wotever}after")
		verifyEq(text, "<%= wotever %>after")
	}

	Void testHanging2() {
		text := oneLine.escape("before\$\${wotever")
		verifyEq(text, "before\$\${wotever")
	}

	Void testMultiple2() {
		text := oneLine.escape("before \$\${1} middle \$\${2} end")
		verifyEq(text, "before <%= 1 %> middle <%= 2 %> end")
	}

	// ---- Ignored Text v1 ----
	
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

	// ---- Ignored Text v2 ----
	
	Void testEscaping2() {
		text := oneLine.escape(Str<|\$${wotever}|>)
		verifyEq(text, Str<|$${wotever}|>)
	}

	Void testEscapingBoth2() {
		text := oneLine.escape(Str<|before\$${wotever}after|>)
		verifyEq(text, Str<|before$${wotever}after|>)
	}

	Void testEscapingHanging2() {
		text := oneLine.escape(Str<|before\$${wotever|>)
		verifyEq(text, Str<|before\$${wotever|>)
	}
			
	// ---- element shortcut escaping ----

	Void testIdInterpolation() {
		line := oneLine.compile(Str<|div#${ctx}|>)
		text := line.toEfan(StrBuf()).toStr
		verifyEq(text, Str<|%><div id="<%= (ctx).toStr.toXml %>"></div><%#
                            |>)
	}
	Void testClassInterpolation() {
		line := oneLine.compile(Str<|div.dude.${ctx}|>)
		text := line.toEfan(StrBuf()).toStr
		verifyEq(text, Str<|%><div class="dude <%= (ctx).toStr.toXml %>"></div><%#
                            |>)
	}
}