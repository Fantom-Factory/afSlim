
internal mixin SlimLineCompiler : SlimEscape {
	
	abstract Bool matches(Str line)
	
	abstract SlimLine compile(Str line)
	
}
