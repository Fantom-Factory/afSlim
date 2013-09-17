using afEfan::EfanCompiler
using afEfan::EfanRenderer

const class Slim {
	
	const private SlimCompiler	slimCompiler	:= SlimCompiler()
	const private EfanCompiler	efanCompiler	:= EfanCompiler()
	
	Str renderFromStr(Str slim, Obj? ctx := null, Type[] viewHelpers := Type#.emptyList) {
		location	:= `render/from/str`
		efan		:= slimCompiler.compile(location, slim)
		renderType	:= efanCompiler.compileWithHelpers(location, efan, ctx?.typeof, viewHelpers)
		renderer	:= (EfanRenderer) renderType.make
		return renderer.render(ctx)
	}
	
}
