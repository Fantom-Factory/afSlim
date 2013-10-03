
const class SlimCompiler {
	
			const  Int 			srcCodePadding	:= 5 
	
	private const SlimParser	parser	:= SlimParser()

	new make(|This|? in := null) {
		in?.call(this)
		parser	:= SlimParser() { it.srcCodePadding = this.srcCodePadding }
	}
	
	** Compiles the given slim template into an efan template.
	Str compileFromStr(Uri srcLocation, Str slimTemplate) {
		tree := SlimLineRoot()
		parser.parse(srcLocation, slimTemplate, tree)
		buf	 := StrBuf(slimTemplate.size)
		return tree.toEfan(buf).toStr
	}

	** Compiles the given slim file into an efan template.
	Str compileFromFile(File slimFile) {
		compileFromStr(slimFile.normalize.uri, slimFile.readAllStr)
	}

}
