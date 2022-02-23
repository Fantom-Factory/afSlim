
internal class TestSlimComponents : Test {
	
	Void testComponent() {
		that := Unsafe(this)
		slim := Slim([
			SlimComponent.fromFn("fo-o") |entryExit, buf, ctx| {
				if (entryExit) {
					buf.add("<bar $ctx.id $ctx.classes $ctx.attrs>")
					// internal text and element text are always auto-added by SlimLineElement
					that.val->verifyEq(ctx.text, "glug")
				} else {
					buf.add("</bar>")
				}
			}
		])
		
		str := slim.renderFromStr("div\n  fo-o#brandy.fine.cognac (beers) glug")

		verifyEq("<div><bar brandy [fine, cognac] beers>glug</bar></div>", str)
	}
	
//	Void testIoc() {
//		reg := afIoc::RegistryBuilder()
//			.addModule(SlimModule#)
//			.contributeToServiceType(Slim#) |afIoc::Configuration c| {
//				c.add(
//					SlimComponent.fromFn("foo") |entryExit, buf, ctx| {
//						if (entryExit) {
//							buf.add("<bar $ctx.id $ctx.classes $ctx.attrs>")
//						} else {
//							buf.add("</bar>")
//						}
//					}
//				)
//			}
//			.build
//		
//		slim := reg.activeScope.serviceByType(Slim#) as Slim
//		verifyEq(slim->components->size, 1)
//		
//		str := slim.renderFromStr("div\n  foo#brandy.fine.cognac (beers) glug")
//		verifyEq("<div><bar brandy [fine, cognac] beers>glug</bar></div>", str)
//		
//		reg.shutdown
//	}
}
