
internal class TestEscaping : SlimTest {
	
	SlimLineElementCompiler oneLine	:= SlimLineElementCompiler(TagStyle.html, SlimComponent[,])

	// ---- Escaped Text ----
	
	Void testBasic() {
		text := oneLine.escape("\${wotever}")
		verifyEq(text, "<%= ((Obj?)(wotever))?.toStr?.toXml %>")
	}

	Void testBefore() {
		text := oneLine.escape("before\${wotever}")
		verifyEq(text, "before<%= ((Obj?)(wotever))?.toStr?.toXml %>")
	}

	Void testAfter() {
		text := oneLine.escape("\${wotever}after")
		verifyEq(text, "<%= ((Obj?)(wotever))?.toStr?.toXml %>after")
	}

	Void testHanging() {
		text := oneLine.escape("before\${wotever")
		verifyEq(text, "before\${wotever")
	}

	Void testMultiple() {
		text := oneLine.escape("before \${1} middle \${2} end")
		verifyEq(text, "before <%= ((Obj?)(1))?.toStr?.toXml %> middle <%= ((Obj?)(2))?.toStr?.toXml %> end")
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
		line := oneLine.compile(Str<|div#${c.t.x}|>)
		text := line.toEfan(StrBuf()).toStr
		verifyEq(text, Str<|%><div id="<%= ((Obj?)(c.t.x))?.toStr?.toXml %>"></div><%#
                            |>)
	}
	Void testClassInterpolation() {
		line := oneLine.compile(Str<|div.dude.${c.t.x}|>)
		text := line.toEfan(StrBuf()).toStr
		verifyEq(text, Str<|%><div class="dude <%= ((Obj?)(c.t.x))?.toStr?.toXml %>"></div><%#
                            |>)
	}

	// ---- Efan Escaping ----

	Void testEfanEscaping1() {
		text := oneLine.escape("<% Look ma! EJS! %>")
		verifyEq(text, "<%% Look ma! EJS! %%>")
	}

	Void testEfanEscaping2() {
		text := slim.renderFromStr("|<% Look ma! EJS! %>")
		verifyEq(text, "<% Look ma! EJS! %>")
	}

	Void testEfanEscaping3() {
		text := oneLine.escape("<% Look \$\${ma}! EJS! %>")
		verifyEq(text, "<%% Look <%= ma %>! EJS! %%>")
	}

	Void testEfanEscaping4() {
		text := oneLine.escape("There \$\${\"is <% NO %> escape\"} !!!")
		verifyEq(text, "There <%= \"is <%% NO %%> escape\" %> !!!")
	}

	Void testEfanEscaping5() {
		text := slim.renderFromStr("|There \$\${ \"is <% NO %> escape\" } !!!")
		verifyEq(text, "There is <% NO %> escape !!!")
	}

	// ---- test no curly bracket interpolation -----

	Void testEsc() {
		text := oneLine.escape("\$wot.ever")
		verifyEq(text, "<%= ((Obj?)(wot.ever))?.toStr?.toXml %>")
	}

	Void testUnesc() {
		text := oneLine.escape("\$\$wot.ever")
		verifyEq(text, "<%= wot.ever %>")
	}

	Void testIngoreEsc() {
		text := oneLine.escape("\\\$wot.ever")
		verifyEq(text, "\$wot.ever")
	}

	Void testIgnoreUnesc() {
		text := oneLine.escape(Str<|\$$wot.ever|>)
		verifyEq(text, Str<|$$wot.ever|>)
	}
			
	Void testIdInterpol() {
		line := oneLine.compile(Str<|div#$ctx|>)
		text := line.toEfan(StrBuf()).toStr
		verifyEq(text, Str<|%><div id="<%= ((Obj?)(ctx))?.toStr?.toXml %>"></div><%#
                            |>)
	}

	Void testClassInterpol() {
		line := oneLine.compile(Str<|div.dude.$ctx|>)
		text := line.toEfan(StrBuf()).toStr
		verifyEq(text, Str<|%><div class="dude <%= ((Obj?)(ctx))?.toStr?.toXml %>"></div><%#
                            |>)
	}

	Void testClassInterpol2() {
		line := oneLine.compile(Str<|div.dude.\$ctx|>)
		text := line.toEfan(StrBuf()).toStr
		verifyEq(text, Str<|%><div class="dude $ctx"></div><%#
                            |>)
	}
}