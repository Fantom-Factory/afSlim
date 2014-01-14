using concurrent

internal class TestTagEndings : SlimTest {

	Void testHtmlVoid() {
		slim := Slim(TagStyle.html)
		text := slim.parseFromStr("meta (dude)")
		verifyEq(text.splitLines[-1], "<meta dude>")
	}

	Void testHtmlNonVoid() {
		slim := Slim(TagStyle.html)
		text := slim.parseFromStr("script (src='')")
		verifyEq(text.splitLines[-1], "<script src=''></script>")		
	}

	Void testHtmlNonVoidWarning() {
		Actor.locals.remove("slim.log")
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(TagStyle.html)
		text := slim.parseFromStr("meta\n span text")
		Log.removeHandler(handler)

		verify(text.splitLines[0].startsWith("<meta>"))		
		verify(text.splitLines[-1].endsWith ("</meta>"))	
		
		verify(Actor.locals["slim.log"].toStr.contains(ErrMsgs.voidTagsMustNotHaveContent("meta")))
	}

	Void testHtmlNonVoidWarning2() {
		Actor.locals.remove("slim.log")
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(TagStyle.html)
		text := slim.parseFromStr("meta dude")
		Log.removeHandler(handler)

		verify(text.splitLines[0].startsWith("<meta>"), text)
		verify(text.splitLines[-1].endsWith ("</meta>"), text)
		
		verify(Actor.locals["slim.log"].toStr.contains(ErrMsgs.voidTagsMustNotHaveContent("meta")))
	}
	
	
	
	Void testXhtmlVoid() {
		slim := Slim(TagStyle.xhtml)
		text := slim.parseFromStr("meta (dude)")
		verifyEq(text.splitLines[-1], "<meta dude />")
	}

	Void testXhtmlNonVoid() {
		slim := Slim(TagStyle.xhtml)
		text := slim.parseFromStr("script (src='')")
		verifyEq(text.splitLines[-1], "<script src=''></script>")		
	}

	Void testXhtmlNonVoidWarning() {
		Actor.locals.remove("slim.log")
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(TagStyle.html)
		text := slim.parseFromStr("meta\n span text")
		Log.removeHandler(handler)
		
		verify(text.splitLines[0].startsWith("<meta>"), text)
		verify(text.splitLines[-1].endsWith ("</meta>"), text)

		verify(Actor.locals["slim.log"].toStr.contains(ErrMsgs.voidTagsMustNotHaveContent("meta")))
	}
	
	Void testXhtmlNonVoidWarning2() {
		Actor.locals.remove("slim.log")
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(TagStyle.xhtml)
		text := slim.parseFromStr("meta dude")
		Log.removeHandler(handler)

		verify(text.splitLines[0].startsWith("<meta>"), text)
		verify(text.splitLines[-1].endsWith ("</meta>"), text)
		
		verify(Actor.locals["slim.log"].toStr.contains(ErrMsgs.voidTagsMustNotHaveContent("meta")))
	}



	Void testXmlVoid() {
		slim := Slim(TagStyle.xml)
		text := slim.parseFromStr("meta (dude)")
		verifyEq(text.splitLines[-1], "<meta dude />")
	}

	Void testXmlNonVoid() {
		slim := Slim(TagStyle.xml)
		text := slim.parseFromStr("script (src='')")
		verifyEq(text.splitLines[-1], "<script src='' />")	// this is XML, so no special treatment for tags
	}

	Void testXmlNonVoidWarning() {
		Actor.locals.remove("slim.log")
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(TagStyle.xml)
		text := slim.parseFromStr("meta\n span text")
		Log.removeHandler(handler)

		verify(text.splitLines[0].startsWith("<meta>"), text)
		verify(text.splitLines[-1].endsWith ("</meta>"), text)

		verifyEq(Actor.locals["slim.log"], null)
	}

	Void testXmlNonVoidWarning2() {
		Actor.locals.remove("slim.log")
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(TagStyle.xml)
		text := slim.parseFromStr("meta dude")
		Log.removeHandler(handler)

		verify(text.splitLines[0].startsWith("<meta>"), text)
		verify(text.splitLines[-1].endsWith ("</meta>"), text)
		
		verifyEq(Actor.locals["slim.log"], null)
	}
}
