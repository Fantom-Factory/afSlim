
internal const class SlimLineElementCompiler : SlimLineCompiler {

	private const SlimLineTextCompiler textCompiler	:= SlimLineTextCompiler()
	
	override Bool matches(Str line) {
		// catch all / wotever's left 
		true
	}
	
	override SlimLine compile(Str line) {
		// I know, I'll use Regular Expressions! ...
		
		// match name (attr) text
		regx := Regex<|^([^\s^\[^\{]+)\s*\((.+)\)(.*)$|>.matcher(line)
		if (regx.find)
			return match(regx.group(1), regx.group(2), regx.group(3))

		// match name [attr] text
		regx = Regex<|^([^\s^\[^\{]+)\s*\[(.+)\](.*)$|>.matcher(line)
		if (regx.find)
			return match(regx.group(1), regx.group(2), regx.group(3))
		
		// match name {attr} text
		regx = Regex<|^([^\s^\[^\{]+)\s*\{(.+)\}(.*)$|>.matcher(line)
		if (regx.find)
			return match(regx.group(1), regx.group(2), regx.group(3))
		
		// match name text
		regx = Regex<|^([^\s]+)\s*(.*)$|>.matcher(line)
		if (regx.find)
			return match(regx.group(1), "", regx.group(2))
		
		throw SlimErr("Could not match element in: ${line}")
	}
	
	SlimLine match(Str tag, Str attr, Str text) {
		attrs	:= Str[,]
		name	:= ""
		id		:= ""
		classes	:= ""
		
		// match name#id.class.class
		regx := Regex<|^(.+?)(#.+?)?(\..+)*$|>.matcher(tag)
		regx.find
		for (i := 1; i <= regx.groupCount; i++) {
			group := regx.group(i)
			if (group == null)
				continue
			if (group.startsWith("#")) {
				id = group[1..-1].trim
				continue
			}
			if (group.startsWith(".")) {
				classes = group[1..-1].split('.').join(" ")
				continue
			}
			name = group.trim
		}

		if (!id.isEmpty)
			attrs.add("id=\"${id}\"")
		
		if (!classes.isEmpty)
			attrs.add("class=\"${classes}\"")
		
		if (!attr.isEmpty)
			attrs.add(attr.trim)		
		
		text = text.trimStart	// very important!
		element	:= SlimLineElement(escape(name), escape(attrs.join(" ")), escape(text))

		// fudge for javascript type lines
		if (textCompiler.matches(text)) {
			element.multiLine	= textCompiler.compile(text)
			element.text		= ""
		}
		return element
	}
}

internal class SlimLineElement : SlimLine {
	
	Str name
	Str attr
	Str text
	
	TagEndingsHtml5 endings	:= TagEndingsHtml5()
	
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
		
		buf.add(endings.completeStartTag(name))
		
		if (!children.isEmpty) {
			newLine(buf)
			if (!text.isEmpty) {
				indent(buf, 1)
			}
		}
		if (!text.isEmpty) {
			buf.add(text)
			if (!children.isEmpty) {
				newLine(buf)
			}
		}
	}

	override Void onExit(StrBuf buf) {
		if (!children.isEmpty) {
			indent(buf)
		}
		buf.add(endings.endTag(name))
		newLine(buf)
	}
	
}
