using afEfan::EfanCompiler
using afEfan::EfanRenderer

** Simple service methods for compiling and rendering slim templates.
const class Slim {
	
	const private SlimCompiler	slimCompiler	:= SlimCompiler()
	const private EfanCompiler	efanCompiler	:= EfanCompiler()
	
	Str renderFromStr(Str slimTemplate, Obj? ctx := null, Type[] viewHelpers := Type#.emptyList) {
		location	:= `render/from/str`
		efan		:= slimCompiler.compileFromStr(location, slimTemplate)
		renderType	:= efanCompiler.compileWithHelpers(location, efan, ctx?.typeof, viewHelpers)
		renderer	:= (EfanRenderer) renderType.make
		return renderer.render(ctx)
	}

	Str renderFromFile(File slimFile, Obj? ctx := null, Type[] viewHelpers := Type#.emptyList) {
		location	:= slimFile.normalize.uri
		efan		:= slimCompiler.compileFromFile(slimFile)
		renderType	:= efanCompiler.compileWithHelpers(location, efan, ctx?.typeof, viewHelpers)
		renderer	:= (EfanRenderer) renderType.make
		return renderer.render(ctx)
	}
	
}
