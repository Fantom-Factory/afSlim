using concurrent
using afPlastic::SrcCodeSnippet

** Defines the ending style rendered tags should have: HTML, XHTML or XML. 
public enum class TagStyle {
	
	** Dictates that all [void elements]`http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements` such as 
	** 'meta', 'br' and 'input' are printed without an end tag:
	** 
	**   <input type="submit">
	**   <br>
	** 
	** All non [void elements]`http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements` are *NOT* 
	** rendered as self closing, even when empty:
	** 
	**   <script></script>
	** 
	** Serve up HTML documents with a MimeType of 'text/html'.
	html	(TagEndingHtml()),
	

	** Dictates that all [void elements]`http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements` such as 
	** 'meta', 'br' and 'input' are printed as self closing tags:
	** 
	**   <input type="submit" />
	**   <br />
	** 
	** All non [void elements]`http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements` are *NOT* 
	** rendered as self closing, even when empty.
	** 
	**   <script></script>
	** 
	** Serve up HTML documents with a MimeType of 'application/xhtml+xml'.
	xhtml	(TagEndingXhtml()),

	** Dictates that *ALL* empty tags are self-closing and void tags have no special meaning: 
	** 
	**   <input type="submit" />
	**   <script />
	** 
	** Serve up XML documents with a MimeType of 'text/xml' or 'application/xml' 
	** [depending on usage]`http://stackoverflow.com/questions/4832357/whats-the-difference-between-text-xml-vs-application-xml-for-webservice-respons`
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
	
	SrcCodeSnippet srcSnippet() {
		srcLocation  := (Uri) (Actor.locals["slim.srcLocation"]  ?: ``)
		slimTemplate := (Str) (Actor.locals["slim.slimTemplate"] ?: "")
		return SrcCodeSnippet(srcLocation, slimTemplate)
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
		if (isVoid(tag) && !isEmpty) {
			lineNo 	:= Int.fromStr(Actor.locals["slim.lineNo"] ?: "0")
			warning	:= srcSnippet.srcCodeSnippet(lineNo, ErrMsgs.voidTagsMustNotHaveContent(tag))
			log.warn(warning) 
		}
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
			return " />"
		if (isVoid(tag) && !isEmpty) {
			lineNo 	:= Int.fromStr(Actor.locals["slim.lineNo"] ?: "0")
			warning	:= srcSnippet.srcCodeSnippet(lineNo, ErrMsgs.voidTagsMustNotHaveContent(tag))
			log.warn(warning) 
		}
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
		isEmpty ? " />" : ">"
	}

	override Str endTag(Str tag, Bool isEmpty) {
		isEmpty ? "" : "</${tag}>"
	}
}
