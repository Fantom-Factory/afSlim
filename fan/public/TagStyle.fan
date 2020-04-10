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
	** HTML documents, when served up from a web server, should have a 'Content-Type' of 'text/html'.
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
	** XHTML documents, when served up from a web server, should have a 'Content-Type' of 'application/xhtml+xml'.
	xhtml	(TagEndingXhtml()),

	** Dictates that *ALL* empty tags are self-closing and void tags have no special meaning: 
	** 
	**   <input type="submit" />
	**   <script />
	** 
	** XML documents, when served up from a web server, should have a 'Content-Type' of 'text/xml' or 'application/xml' 
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
	
	abstract Str startTag(Str tag, Bool isEmpty, SrcCodeSnippet? srcSnippet, Int lineNo)

	abstract Str endTag(Str tag, Bool isEmpty)
}

** @see http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements
@NoDoc
const class TagEndingHtml : TagEnding {	
	private static const Log log := TagEnding#.pod.log

	override Str startTag(Str tag, Bool isEmpty, SrcCodeSnippet? srcSnippet, Int lineNo) {
		// log errors at the *start* so we pick up the Slim Line No.  
		if (isVoid(tag) && !isEmpty) {
			// null check is just for test cases
			msg		:= "Void tag '${tag}' *MUST NOT* have content!"
			warning	:= srcSnippet?.srcCodeSnippet(lineNo, msg) ?: msg
			log.warn(warning) 
		}
		return ">"
	}

	override Str endTag(Str tag, Bool isEmpty) {
		if (isVoid(tag) && isEmpty)
			return ""
		return "</${tag.toXml}>"
	}
}

@NoDoc
const class TagEndingXhtml : TagEnding {
	private static const Log log := TagEnding#.pod.log
	
	override Str startTag(Str tag, Bool isEmpty, SrcCodeSnippet? srcSnippet, Int lineNo) {
		if (isVoid(tag) && isEmpty)
			return " />"
		if (isVoid(tag) && !isEmpty) {
			// null check is just for test cases
			msg		:= "Void tag '${tag}' *MUST NOT* have content!"
			warning	:= srcSnippet?.srcCodeSnippet(lineNo, msg) ?: msg
			log.warn(warning) 
		}
		return ">"
	}

	override Str endTag(Str tag, Bool isEmpty) {
		if (isVoid(tag) && isEmpty)
			return ""
		return "</${tag.toXml}>"
	}
}

@NoDoc
const class TagEndingXml : TagEndingXhtml {
	override Str startTag(Str tag, Bool isEmpty, SrcCodeSnippet? srcSnippet, Int lineNo) {
		isEmpty ? " />" : ">"
	}

	override Str endTag(Str tag, Bool isEmpty) {
		isEmpty ? "" : "</${tag.toXml}>"
	}
}
