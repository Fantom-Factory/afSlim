
internal const mixin SlimLineCompiler {
	
	abstract Bool matches(Str line)
	
	abstract SlimLine compile(Str line)
	
	Str escape(Str line) {
		// hmmm - I'm back in the dodgy world of escaping code (re: the medievil days of efan)
		// I know, I'll use Regular Expressions! ...
		code := StrBuf(line.size)		
		regx := Regex<|(.*?)\$\{(.+?)}|>.matcher(line)
		find := regx.find
		last := 0
		while (find) {
			escp := (line.getSafe(regx.end(1) - 1) == '\\')
			if (!escp) {
				code.add( regx.group(1) )
				code.add( "<%= "        )
				code.add( regx.group(2) )
				code.add( " %>"         )
			} else {
				code.add( regx.group(1)[0..<-1] )
				code.add( "\${"         )
				code.add( regx.group(2) )
				code.add( "}"	        )
			}
		
			last = regx.end(2)+1
			find = regx.find
		}

		code.add( line[last..-1] )
		return code.toStr
	}
	
}

