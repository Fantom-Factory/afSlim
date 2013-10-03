using afEfan::EfanCompiler
using afEfan::EfanRenderer

** Simple service methods for compiling and rendering slim templates into HTML.
** For further information on the 'ctx' parameter, see 
** [efan: Passing Data]`http://repo.status302.com/doc/afEfan/#ctx`
const class Slim {
	
	const private SlimCompiler	slimCompiler	:= SlimCompiler()
	const private EfanCompiler	efanCompiler	:= EfanCompiler()
	
	** Renders the given slim template into HTML.
	Str renderFromStr(Str slimTemplate, Obj? ctx := null, Type[] viewHelpers := Type#.emptyList) {
		location	:= `render/from/str`
		efan		:= slimCompiler.compileFromStr(location, slimTemplate)
		renderType	:= efanCompiler.compileWithHelpers(location, efan, ctx?.typeof, viewHelpers)
		renderer	:= (EfanRenderer) renderType.make
		return renderer.render(ctx)
	}

	** Renders the given slim template file into HTML.
	Str renderFromFile(File slimFile, Obj? ctx := null, Type[] viewHelpers := Type#.emptyList) {
		location	:= slimFile.normalize.uri
		efan		:= slimCompiler.compileFromFile(slimFile)
		renderType	:= efanCompiler.compileWithHelpers(location, efan, ctx?.typeof, viewHelpers)
		renderer	:= (EfanRenderer) renderType.make
		return renderer.render(ctx)
	}
	
}
