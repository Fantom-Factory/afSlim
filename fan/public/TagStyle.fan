

public enum class TagStyle {
	
	** http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements
	html	(TagEndingHtml()),
	

	xhtml	(TagEndingXhtml()),

	xml		(TagEndingXml());
	
	internal const TagEnding tagEnding
	
	private new make(TagEnding tagEnding) {
		this.tagEnding = tagEnding
	}
}

@NoDoc
const abstract class TagEnding {
	static const Str[] voidTags := "area, base, br, col, embed, hr, img, input, keygen, link, menuitem, meta, param, source, track, wbr".split(',')
	
	Bool isVoid(Str tag) {
		voidTags.contains(tag.lower)
	}
	
	abstract Str startTag(Str tag, Bool isEmpty)

	abstract Str endTag(Str tag, Bool isEmpty)
}

** @see http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements
@NoDoc
const class TagEndingHtml : TagEnding {	
	private static const Log log := TagEnding#.pod.log

	override Str startTag(Str tag, Bool isEmpty) {
		// log errors at the *start* so we pick up the Slim Line No.  
		if (isVoid(tag) && !isEmpty)
			log.warn("YA!")	// print 
		return ">"
	}

	override Str endTag(Str tag, Bool isEmpty) {
		if (isVoid(tag) && isEmpty)
			return ""
		return "</${tag}>"
	}
}

@NoDoc
const class TagEndingXhtml : TagEnding {
	private static const Log log := TagEnding#.pod.log
	
	override Str startTag(Str tag, Bool isEmpty) {
		if (isVoid(tag) && isEmpty)
			return "/>"
		if (isVoid(tag) && !isEmpty)
			log.warn("YA!")	// print 
		return ">"
	}

	override Str endTag(Str tag, Bool isEmpty) {
		if (isVoid(tag) && isEmpty)
			return ""
		return "</${tag}>"
	}
}

@NoDoc
const class TagEndingXml : TagEndingXhtml {
	override Str startTag(Str tag, Bool isEmpty) {
		isEmpty ? "/>" : ">"
	}

	override Str endTag(Str tag, Bool isEmpty) {
		isEmpty ? "" : "</${tag}>"
	}
}
