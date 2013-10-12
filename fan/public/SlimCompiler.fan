
** Compiles slim templates into efan templates.
const class SlimCompiler {
	
	private const SlimParser	parser	:= SlimParser()
	
	** Compiles the given slim template into an efan template.
	Str compileFromStr(Uri srcLocation, Str slimTemplate) {
		tree := SlimLineRoot()
		parser.parse(srcLocation, slimTemplate, tree)
		buf	 := StrBuf(slimTemplate.size)
		efan := tree.toEfan(buf).toStr.trim
		if (efan.startsWith("%>"))
			efan = efan[2..-1]
		if (efan.endsWith("<%#"))
			efan = efan[0..-4]
		return efan
	}

	** Compiles the given slim file into an efan template.
	Str compileFromFile(File slimFile) {
		compileFromStr(slimFile.normalize.uri, slimFile.readAllStr)
	}
}
