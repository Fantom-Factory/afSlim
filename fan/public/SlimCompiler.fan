
const class SlimCompiler {
	
	private const SlimParser 		parser	:= SlimParser()
	
	Str compile(Uri srcLocation, Str slimTemplate) {
		tree := SlimLineRoot()
		parser.parse(srcLocation, slimTemplate, tree)
		buf	 := StrBuf(slimTemplate.size)
		return tree.toEfan(buf).toStr
	}
	
}
