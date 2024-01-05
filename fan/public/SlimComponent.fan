
** A customisable component for Slim Template rendering.
** 
** Implement and pass instances to the 'Slim' ctor.
const mixin SlimComponent {
	
	** The tag name this component overrides. May be a *regex glob*. 
	abstract Str name()	
	
	** Called when the component is to render its opening tags. Write HTML to the given 'buf'.
	abstract Void onEntry(StrBuf out, SlimComponentCtx ctx)
	
	** Called when the component is to render its closing tags. Write HTML to the given 'buf'.
	abstract Void onExit(StrBuf out, SlimComponentCtx ctx)
	
	** Create a new 'SlimComponent' from the given func. Use for simple components.
	** 
	** 'entryExit' is 'true' when 'onEntry()' is invoked, and 'false' when 'onExit()' is invoked.
	static new fromFn(Str tagName, |Bool entryExit, StrBuf out, SlimComponentCtx ctx| fn) {
		SlimComponentImpl(tagName, fn)
	}
}

internal const class SlimComponentImpl : SlimComponent {
	override const Str	name
	private	 const Func	func
	
	override Void onEntry(StrBuf out, SlimComponentCtx ctx) {
		func(true, out, ctx)
	}
	
	override Void onExit(StrBuf out, SlimComponentCtx ctx) {
		func(false, out, ctx)
	}
	
	new make(Str name, Func func) {
		this.name	= name
		this.func	= func
	}
}

** An instance is passed to 'SlimComponents' for entry / exit rendering.
const class SlimComponentCtx {
	
	** The tag style.
	const	TagStyle	tagStyle
	
	** The tag name (if defined in the Slim template).
	const	Str?		tagName
	
	** The component name.
	const	Str			comName
	
	** The ID of the element.
	const	Str?		id
	
	** Any classes defined by the element
	const	Str[]		classes
	
	** Any attributes defined by the element.
	const	Str:Str?	attrs
	
	** Any plain text inside the element.
	const	Str?		text
	
	** Std it-block ctor.
	new make(|This| fn) {
		fn(this)
		
		if (this.classes == null)
			this.classes = Str#.emptyList
		
		// duplicate the functionality of the SlimLineElement ctor
		if (this.text != null && this.text.size > 0 && this.text[0].isSpace)
			this.text = this.text[1..-1]
	}
	
	@NoDoc
	override Str toStr() {
		out := StrBuf()
		SlimTag(this).write(out)
		return out.toStr
	}
}
