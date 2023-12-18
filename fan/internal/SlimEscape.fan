
** Interpolates fantom "$fantom.code" into "<%= efan.code %>".
** 
** More specifically:
**   ${fantom.code}             -->  <%= ((Obj?)( fantom.code ))?.toStr?.toXml %>
**   $<locale.key>              -->  <%= Slim.localeStr(this.typeof, "locale.key") %>
**   $<locale.key, 1, "arg2">   -->  <%= Slim.localeStr(this.typeof, "locale.key", null, 1, "arg2") %>
** 
** 'Slim.localeStr()' may be replaced with custom func - see 'Slim' ctor.
internal mixin SlimEscape {
	
	// todo I should probably convert this confusing mess to Pegger!
	static const Regex fantomRegex	:= Regex<|(.*?)(?:(?:(\\?\$?\$\{)(.+?)})|(\\?\$?\$)([a-zA-Z0-9\.]+)|(?:(?:(\\?\$?\$\<)(.+?)(?:>|,(.+?)>))))|> 
	
	Str? escape(Str? line, Method localeFn) {
		
		if (line == null) return null

		// hmmm - I'm back in the dodgy world of escaping code (re: the medievil days of efan)
		// I know, I'll use Regular Expressions! ...
		code := StrBuf(line.size)
		escapeFantom(code, line, localeFn)
		return code.toStr
	}

	Str escapeEfan(Str efan) {
		efan.replace("<%", "<%%").replace("%>", "%%>")
	}

	private Void escapeFantom(StrBuf code, Str line, Method localeFn) {
		regx := fantomRegex.matcher(line)
		find := regx.find
		last := 0
		
		while (find) {
			
			echo(code)
			
			if (regx.group(2) != null) {
				if (regx.group(2) == "\${") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "<%= ((Obj?) ("			)
					code.add( escapeEfan(regx.group(3))	)
					code.add( "))?.toStr?.toXml %>"		)
				}
	
				if (regx.group(2) == "\\\${") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "\${"						)
					code.add( escapeEfan(regx.group(3))	)
					code.add( "}"						)
				}
	
				if (regx.group(2) == "\$\${") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "<%= "					)
					code.add( escapeEfan(regx.group(3))	)
					code.add( " %>"						)				
				}
	
				if (regx.group(2) == "\\\$\${") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "\$\${"					)
					code.add( escapeEfan(regx.group(3))	)
					code.add( "}"						)
				}
			
				last = regx.end(3) + 1	// +1 for }
				find = regx.find
			} else
			
			if (regx.group(4) != null) {
				if (regx.group(4) == "\$") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "<%= ((Obj?) ("			)
					code.add( escapeEfan(regx.group(5))	)
					code.add( "))?.toStr?.toXml %>"		)
				}
	
				if (regx.group(4) == "\\\$") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "\$"						)
					code.add( escapeEfan(regx.group(5))	)
				}
	
				if (regx.group(4) == "\$\$") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "<%= "					)
					code.add( escapeEfan(regx.group(5))	)
					code.add( " %>"						)				
				}
	
				if (regx.group(4) == "\\\$\$") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "\$\$"					)
					code.add( escapeEfan(regx.group(5))	)
				}
			
				last = regx.end(5)
				find = regx.find
			} else

			if (regx.group(6) != null) {
				if (regx.group(6) == "\$<") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "<%= ((Obj?) "			)
					code.add( localeFn.qname			)
					code.add( "(this.typeof, "			)
					code.add( escapeEfan(regx.group(7)).toCode	)
					if (regx.group(8) != null)
						code.add(", ").add(regx.group(8).trim)
					code.add( ")"						)
					code.add( ")?.toStr?.toXml %>"		)
				}
	
				if (regx.group(6) == "\\\$<") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "\$<"						)
					code.add( escapeEfan(regx.group(7))	)
					code.add( ">"						)
				}
	
				if (regx.group(6) == "\$\$<") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "<%= "					)
					code.add( localeFn.qname			)
					code.add( "(this.typeof, "			)
					code.add( escapeEfan(regx.group(7)).toCode	)
					if (regx.group(8) != null)
						code.add(", ").add(regx.group(8).trim)
					code.add( ")"						)
					code.add( " %>"						)				
				}
	
				if (regx.group(6) == "\\\$\$<") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "\$\$<"					)
					code.add( escapeEfan(regx.group(7))	)
					code.add( ">"						)
				}
			
				last = regx.end(7) + 1	// +1 for >
				find = regx.find
			}
		}

		code.add( escapeEfan(line[last..-1]) )
	}
}
