
internal class TestExample : SlimTest {
	
	Void testDocExample() {
		template := `test/unit-tests/Example.slim`.toFile.readAllStr
		ctx  := ["name":"Emma"]
		
		efan := compiler.compileFromStr(`Dude`, template)
		Env.cur.err.printLine(efan)
		concurrent::Actor.sleep(20ms)

		html := slim.renderFromStr(template, ctx)
		Env.cur.err.printLine(html)
		concurrent::Actor.sleep(20ms)
	}

//	Void testDocs1() {
//s := """-- 3.times |i|
//          -- echo(i)"""
//		text := slim.renderFromStr(s)
//		Env.cur.err.printLine(text)
//	}
//
//	Void testDocs2() {
//s := """-- if (ctx["if"])
//          | true man
//        -- else
//          | shite!"""
//		ctx := ["if":true]
//		text := slim.renderFromStr(s, ctx)
//		verifyEq(text, "true man")
//	}
//
//	Void testDocs3() {
//s := """ | Look at how <small>BIG</small> I am!"""
//		text := slim.renderFromStr(s)
//		verifyEq(text, "Look at how <small>BIG</small> I am!\n")
//	}
}
