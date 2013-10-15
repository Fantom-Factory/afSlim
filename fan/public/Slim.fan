using afEfan::EfanCompiler
using afEfan::EfanRenderer

** Non-caching service methods for parsing, compiling and rendering slim templates into HTML.
** 
** For further information on the 'ctx' parameter, see 
** [efan: Passing Data]`http://repo.status302.com/doc/afEfan/#ctx`
const class Slim {
	
	private const SlimParser	slimParser		:= SlimParser()
	const private EfanCompiler	efanCompiler	:= EfanCompiler()

	
	** Parses the given slim template into an efan template.
	** 
	** 'srcLocation' may anything - used for meta information only.
	Str parseFromStr(Str slimTemplate, Uri? srcLocation := null) {
		srcLocation	=  srcLocation ?: `from/slim/template`
		tree := SlimLineRoot()
		slimParser.parse(srcLocation, slimTemplate, tree)
		buf	 := StrBuf(slimTemplate.size)
		efan := tree.toEfan(buf).toStr.trim
		if (efan.startsWith("%>"))
			efan = efan[2..-1]
		if (efan.endsWith("<%#"))
			efan = efan[0..-4]
		return efan
	}

	** Parses the given slim file into an efan template.
	Str parseFromFile(File slimFile) {
		srcLocation	:=  slimFile.normalize.uri
		return parseFromStr(slimFile.readAllStr, srcLocation)
	}

	** Compiles a renderer from the given slim template.
	** 
	** 'srcLocation' may anything - used for meta information only.
	EfanRenderer compileFromStr(Str slimTemplate, Type? ctxType := null, Type[] viewHelpers := Type#.emptyList, Uri? srcLocation := null) {
		srcLocation	=  srcLocation ?: `from/slim/template`
		efan		:= this.parseFromStr(slimTemplate, srcLocation)
		renderer	:= efanCompiler.compileWithHelpers(srcLocation, efan, ctxType, viewHelpers)
		return renderer
	}

	** Compiles a renderer from the given slim file.
	EfanRenderer compileFromFile(File slimFile, Type? ctxType := null, Type[] viewHelpers := Type#.emptyList) {
		srcLocation	:= slimFile.normalize.uri
		efan		:= this.parseFromStr(slimFile.readAllStr, srcLocation)
		renderer	:= efanCompiler.compileWithHelpers(srcLocation, efan, ctxType, viewHelpers)
		return renderer
	}

	** Renders the given slim template into HTML.
	** 
	** 'srcLocation' may anything - used for meta information only.
	Str renderFromStr(Str slimTemplate, Obj? ctx := null, Type[] viewHelpers := Type#.emptyList, Uri? srcLocation := null) {
		srcLocation	=  srcLocation ?: `from/slim/template`
		renderer	:= this.compileFromStr(slimTemplate, ctx?.typeof, viewHelpers, srcLocation)
		return renderer.render(ctx)
	}

	** Renders the given slim template file into HTML.
	Str renderFromFile(File slimFile, Obj? ctx := null, Type[] viewHelpers := Type#.emptyList) {
		renderer	:= this.compileFromFile(slimFile, ctx?.typeof, viewHelpers)
		return renderer.render(ctx)
	}
	
}
