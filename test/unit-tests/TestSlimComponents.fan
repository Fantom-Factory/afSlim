
class TestSlimComponents : Test {
	
	Void testComponent() {
		that := Unsafe(this)
		slim := Slim(["components":[
			SlimComponent.fromFn("fo-o") |entryExit, buf, ctx| {
				if (entryExit) {
					buf.add("<bar $ctx.id $ctx.classes $ctx.attrs>")
					// internal text and element text are always auto-added by SlimLineElement
					that.val->verifyEq(ctx.text, "glug")
				} else {
					buf.add("</bar>")
				}
			}
		]])
		
		str := slim.renderFromStr("div\n  fo-o#brandy.fine.cognac (beers) glug")
		verifyEq("<div><bar brandy [fine, cognac] [beers:null]>glug</bar></div>", str)
	}
	
	Void testComponentMixin() {
		that := Unsafe(this)
		slim := Slim(["components":[
			SlimComponent.fromFn("bar") |entryExit, buf, ctx| {
				if (entryExit) {
					buf.add("<$ctx.tagName suckers>")
				} else {
					buf.add("</$ctx.tagName>")
				}
			}
		]])
	
		// test the "tag:mixin" format
		str := slim.renderFromStr("div\n  foo:bar glug")
		verifyEq("<div><foo suckers>glug</foo></div>", str)	

		// test tags default to "div"
		str = slim.renderFromStr("div\n  bar glug")
		verifyEq("<div><div suckers>glug</div></div>", str)	
	}	

	Void testAttrInterpolationComponent() {
		that := Unsafe(this)
		slim := Slim(["components":[
			SlimComponent.fromFn("foo") |entryExit, buf, ctx| {
				if (entryExit) {
					buf.add("<div ${ctx.id} ${ctx.classes} ${ctx.attrs}>")
				} else {
					buf.add("</div>")
				}
			}
		]])
		
		// test that $interpolation gets converted to efan code
		tem := slim.compileFromStr("div\n  foo#\${ctx.one}.\${ctx.the} (one \${ctx.two} three) glug", typeof)
		verifyEq("<div><%#
		          	%><div <%= ((Obj?)(ctx.one))?.toStr?.toXml %> [<%= ((Obj?)(ctx.the))?.toStr?.toXml %>] [one:null, <%= ((Obj?)(ctx.two))?.toStr?.toXml %>:null, three:null]>glug</div><%#
		          %></div>", tem.templateSrc)

		// test it still works!
		str := tem.render(this)
		verifyEq("<div><div judge [dredd] [one:null, Hello!:null, three:null]>glug</div></div>", str)	
	}
	Str one() { "judge" }
	Str two() { "Hello!" }
	Str the() { "dredd" }
	

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
