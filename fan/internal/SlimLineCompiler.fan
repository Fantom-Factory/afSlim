
internal const mixin SlimLineCompiler {
	
	abstract Bool matches(Str line)
	
	abstract SlimLine compile(Str line)
	
	Str escape(Str line) {
		if (!line.contains("\${"))
			return line

		// hmmm - I'm back in the dodgy world of escaping code (re: the medievil days of efan)
		esc := ""

		srt	:= 0
		end	:= 0
		while (line.index("\${", end) != null) {
			idx	:= line.index("\${", end)
			
			code := (line.getSafe(idx-1) == '\\')
			end = idx
			if (code) {
				end--
				esc += line[srt..end]
				esc += "\${"
			} else {
				code = true
				esc += line[srt..end]
				esc += "<%= "
			}
			srt = end

			idx	= line.index("}", end)
			if (idx == null)
				end = code ? -1 : throw SlimErr("Argh!")
			end = idx

			if (code) {
				esc += line[srt..end]
				esc += "}"				
			} else {
				esc += line[srt..end]
				esc += " %>"			
			}
			srt = end
		}

		Env.cur.err.printLine(esc)
		return esc
	}
	
}

