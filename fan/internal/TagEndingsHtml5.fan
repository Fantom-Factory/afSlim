
** @see http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements
const class TagEndingsHtml5 {
	
	const Str[] voidTags	:= "area, base, br, col, embed, hr, img, input, keygen, link, menuitem, meta, param, source, track, wbr".split(',')
	
	Str completeStartTag(Str tag) {
		">"
	}
	
	Str endTag(Str tag) {
		voidTags.contains(tag.lower) ? "" : "</${tag}>"		
	}
}
