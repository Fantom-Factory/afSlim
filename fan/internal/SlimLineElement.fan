
internal const class SlimLineElementCompiler : SlimLineCompiler {

	override Bool matches(Str line) {
		true
	}
	
	override SlimLine compile(Str line) {
		SlimLineElement(line)
	}
}

internal class SlimLineElement : SlimLine {
	
	Str name
	
	new make(Str line) {
		this.name = line
	}
	
	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.addChar('<')
		buf.add(name)
		buf.addChar('>')
		if (!children.isEmpty) {
			buf.addChar('\n')
		}
	}

	override Void onExit(StrBuf buf) {
		if (!children.isEmpty) {
			indent(buf)
		}
		buf.addChar('<').addChar('/')
		buf.add(name)
		buf.addChar('>')
		buf.addChar('\n')
	}
	
}
