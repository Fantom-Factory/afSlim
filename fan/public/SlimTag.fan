
** A utility class for use by custom Slim components.
** Builds and writes a HTML tag with custom attrs.
class SlimTag {

	** The standard sizes.
	static const Str[]	sizes	:= "xs sm lg xl".split

	private Str			tagName
	private	Str?		id
	private Str:Str?	attrs
	private Str[]		classes
	private Str			style
	
	** Creates a tag builder initialised from the given 'SlimComponentCtx'.
	** 
	** Tag Name defaults to ctx, falls back to the given name, or defaults to 'div'.
	new fromCtx(SlimComponentCtx ctx, Str? tagName := null) {
		this.tagName	= (ctx.tagName ?: tagName) ?: "div"
		this.id			= null
		this.attrs		= Str:Str?[:] { it.ordered = true }
		this.classes	= Str[,]
		this.style		= ""
		
		this.id			= ctx.id
		this.attrs  .addAll(ctx.attrs)
		this.classes.addAll(ctx.classes)
		this.style		= this.attrs.remove("style")?.trimToNull ?: ""
	}
	
	** Creates a tag builder.
	** 
	** Tag Name defaults to 'div'.
	new make(Str? tagName := null) {
		this.tagName	= tagName ?: "div"
		this.id			= null
		this.attrs		= Str:Str?[:] { it.ordered = true }
		this.classes	= Str[,]
		this.style		= ""
	}
	
	** Is the value one of the standard sizes? 
	Bool isSize(Str val) {
		sizes.contains(val)
	}
	
	** Returns the attr value as an Int.
	Int? attrInt(Str name) {
		attrs.remove(name)?.toInt
	}
	
	** Returns 'true' if the attr name exists.
	Bool attrBool(Str name) {
		bool := attrs.containsKey(name)
		attrs.remove(name)
		return bool
	}	

	** Returns the attr value as a standard size, an empty string if the base value,
	** or 'null' if not found.
	Str? attrSize(Str name) {
		if (attrs.containsKey(name) && attrs[name] == null) {
			attrs.remove(name)
			return ""
		}
		return sizes.find { attrBool("${name}-${it}") }
	}
	
	** Returns the attr value.
	Str? attrStr(Str name) {
		attrs.remove(name)
	}

	** Returns the first enum value in the given SSV string,
	** or 'null' if not found.
	Str? attrEnum(Str enum) {
		enum.split.find { attrBool(it) }
	}
	
	** Adds a CSS class (if it's not 'null' or empty).
	This addClass(Str? klass) {
		if (klass != null && klass.size > 0)
			classes.add(klass)
		return this
	}
	
	** Adds a single CSS property to the 'style' attribute.
	** 'size' is appended to the value (if given).
	** 'null' values are skipped.
	** 'value' is wrapped in 'var(...)' if a CSS var name (starts with '--').
	** 
	** pre>
	** syntax: fantom
	** addStyle("padding", "2rem")
	** addStyle("margin", "padding", "sm")
	** addStyle("margin", "--padding-sm")
	** <pre
	This addStyle(Str name, Str? value, Str size := "") {
		if (value == null) return this

		if (this.style.size > 0) {
			if (this.style.endsWith(";") == false)
				this.style += ";"
			this.style += " "
		}
		val := size == "" ? value.trim : "${value.trim}-${size}"
		if (val.startsWith("--"))
			val = "var(${val})"
		this.style += "${name.trim}: ${val}"
		return this
	}
	
	** Adds a attr name value pair. 'value' may be 'null' for boolean attributes.
	This addAttr(Str name, Str? value := null) {
		this.attrs.remove(name)
		this.attrs[name] = value
		return this
	}
	
	** Writes the opening start tag to the given out. 
	This write(StrBuf out) {
		atts := Str:Str?[:]
		atts.ordered = true
		
		if (this.id != null)
			atts["id"] = this.id
	
		if (classes.size > 0)
			atts["class"] = classes.join(" ")
		
		if (style.size > 0)
			atts["style"] = style
		
		atts.addAll(attrs)
		writeTag(out, tagName, atts)
		return this
	}
	
	** Writes the end tag.
	This writeEnd(StrBuf out) {
		out.addChar('<').addChar('/').add(tagName).addChar('>')
		return this
	}
	
	private static Void writeTag(StrBuf out, Str tagName, [Str:Str?]? attrs) {
		out.addChar('<').add(tagName)
		
		// we purposely do NOT escape XML so we can write efan code values
		if (attrs != null && attrs.size > 0)
			attrs.each |val, nom| {
				out.join(nom, " ")
				if (val != null)
					out.addChar('=').addChar('"').add(val).addChar('"')
			}
		
		out.addChar('>')
	}
}
