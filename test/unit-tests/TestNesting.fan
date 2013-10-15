using afEfan

internal class TestNesting2 : SlimTest { 

	Void testNesting() {
o := """p outer-start
        == ctx.render(null)
        	p outer-body
        p outer-end"""
		
i := """p inner-start
        == renderBody
        p inner-end"""
		
		// FIXME: mention the (null) thing
		oo := slim.compileFromStr(o, EfanRenderer#)
		ii := slim.compileFromStr(i)
		
		print(oo.efanMetaData.efanTemplate)
		print(ii.efanMetaData.efanTemplate)
		
		text := oo.render(ii)

e := """<p>outer-start</p><p>inner-start</p><p>outer-body</p><p>inner-end</p><p>outer-end</p>"""

		print(text)
		verifyEq(text, e)
	}
	
}