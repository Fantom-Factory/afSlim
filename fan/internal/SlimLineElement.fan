
internal const class SlimLineElementCompiler : SlimLineCompiler {

	override Bool matches(Str line) {
		// catch all / wotever's left 
		true
	}
	
	override SlimLine compile(Str line) {

		name	:= ""
		id		:= ""
		classes	:= ""
		attr	:= ""
		text	:= ""
		attrs	:= Str[,]

		name	= line.split[0]
		remain	:= line[name.size..-1]
		
		if (name.contains("#")) {
			temp	:= name.split('#', false)
			name	= temp[0]
			temp	= temp[1..-1].join("#").split('.', false)
			id		= temp[0]
			classes	= temp[1..-1].join(" ")
		} else 

		if (name.contains(".")) {
			temp	:= name.split('.', false)
			name	= temp[0]
			classes	= temp[1..-1].join(" ")
		}

		if (remain.contains(":")) {
			attr	= remain.split(':', false)[0]
			text	= remain[attr.size+1..-1]
		} else 
		
		if (name.endsWith(":")) {
			name	= name[0..-2]
			text	= remain
		}

		if (!id.isEmpty)
			attrs.add("id=\"${id.trim}\"")
		
		if (!classes.isEmpty)
			attrs.add("class=\"${classes.trim}\"")

		if (!attr.isEmpty)
			attrs.add(attr.trim)
		
		return SlimLineElement(escape(name), escape(attrs.join(" ")), escape(text.trim))
	}
}

internal class SlimLineElement : SlimLine {
	
	Str name
	Str attr
	Str text
	
	new make(Str name, Str attr, Str text) {
		this.name = name
		this.attr = attr
		this.text = text
	}
	
	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.addChar('<')
		buf.add(name)
		if (!attr.isEmpty) {
			buf.addChar(' ')
			buf.add(attr)
		}
		buf.addChar('>')
		if (!children.isEmpty) {
			buf.addChar('\n')
			if (!text.isEmpty) {
				indent(buf, 1)
			}
		}
		if (!text.isEmpty) {
			buf.add(text)
			if (!children.isEmpty) {
				buf.addChar('\n')
			}
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
