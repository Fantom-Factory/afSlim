
internal mixin SlimLineCompiler : Escape {
	
	abstract Bool matches(Str line)
	
	abstract SlimLine compile(Str line)
	
}
