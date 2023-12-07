
** Interpolates fantom "$fantom.code" into "<%= efan.code %>".
** 
** More specifically:
**   ${fantom.code}             -->  <%= ((Obj?)( fantom.code ))?.toStr?.toXml %>
**   $<locale.key>              -->  <%= Slim.localeStr(this.typeof, "locale.key") %>
**   $<locale.key, 1, "arg2">   -->  <%= Slim.localeStr(this.typeof, "locale.key", null, 1, "arg2") %>
** 
** 'Slim.localeStr()' may be replaced with custom func - see 'Slim' ctor.
internal mixin SlimEscape {
	
	// FIXME allow end tokens to be escaped, e.g. ${" -{hello\} "}
	static const Regex localeRegex	:= Regex<|(.*?)(?:(?:(\\?\$?\$\<)(.+?)>)|(\\?\$?\$)([a-zA-Z0-9\.]+))|> 
	static const Regex fantomRegex	:= Regex<|(.*?)(?:(?:(\\?\$?\$\{)(.+?)})|(\\?\$?\$)([a-zA-Z0-9\.]+))|> 
	
	Str? escape(Str? line, Method localeFn) {
		if (line == null) return null

		// hmmm - I'm back in the dodgy world of escaping code (re: the medievil days of efan)
		// I know, I'll use Regular Expressions! ...
		code := StrBuf(line.size)
		escapeLocale(code, line, localeFn)
		
		line = code.toStr
		code.clear
		escapeFantom(code, line)
		return code.toStr
	}

	Str escapeEfan(Str efan) {
		efan.replace("<%", "<%%").replace("%>", "%%>")
	}
	
	private Void escapeLocale(StrBuf code, Str line, Method localeFn) {
		code.add(line)
	}

	private Void escapeFantom(StrBuf code, Str line) {
		regx := fantomRegex.matcher(line)
		find := regx.find
		last := 0
		while (find) {
			
			if (regx.group(2) != null) {
				if (regx.group(2) == "\${") {
					code.add( escapeEfan(regx.group(1))	)
					code.add( "<%= ((Obj?)("			)
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
					code.add( "<%= ((Obj?)("			)
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
			}
		}

		code.add( escapeEfan(line[last..-1]) )
	}
}
