
** A customisable component for Slim Template rendering.
** 
** Implement and pass instances to the 'Slim' ctor.
const mixin SlimComponent {
	
	** The tag that this component overrides.
	abstract Str tagName()	
	
	** Called when the component is to render its opening tags. Write HTML to the given 'buf'.
	abstract Void onEntry(StrBuf buf, SlimComponentCtx ctx)
	
	** Called when the component is to render its closing tags. Write HTML to the given 'buf'.
	abstract Void onExit(StrBuf buf, SlimComponentCtx ctx)
	
	** Create a new 'SlimComponent' from the given func. Use for simple components.
	** 
	** 'entryExit' is 'true' when 'onEntry()' is invoked, and 'false' when 'onExit()' is invoked.
	static new fromFn(Str tagName, |Bool entryExit, StrBuf buf, SlimComponentCtx ctx| fn) {
		SlimComponentImpl(tagName, fn)
	}
}

internal const class SlimComponentImpl : SlimComponent {
	override const Str	tagName
	private	 const Func	func
	
	override Void onEntry(StrBuf buf, SlimComponentCtx ctx) {
		func(true, buf, ctx)
	}
	
	override Void onExit(StrBuf buf, SlimComponentCtx ctx) {
		func(false, buf, ctx)
	}
	
	new make(Str tagName, Func func) {
		this.tagName	= tagName
		this.func		= func
	}
}

** An instance is passed to 'SlimComponents' for entry / exit rendering.
const class SlimComponentCtx {
	
	** The tag style.
	const	TagStyle	tagStyle
	
	** The tag name.
	const	Str			tagName
	
	** The ID of the element.
	const	Str?		id
	
	** Any classes defined by the element
	const	Str[]		classes
	
	** Any attributes defined by the element.
	const	Str?		attrs
	
	** Any plain text inside the element.
	const	Str?		text
	
	** Std it-block ctor.
	new make(|This| fn) {
		fn(this)
		
		// duplicate the functionality of the SlimLineElement ctor
		if (this.text.size > 0 && this.text[0].isSpace)
			this.text = this.text[1..-1]
	}
}
