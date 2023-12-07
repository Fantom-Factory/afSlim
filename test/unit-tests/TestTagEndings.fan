using concurrent

internal class TestTagEndings : SlimTest {

	override Void setup() {
		Actor.locals.remove("slim.log")		
	}
	
	Void testHtmlVoid() {
		slim := Slim(["tagStyle":TagStyle.html])
		text := slim.parseFromStr("meta (dude)")
		verifyEq(text.splitLines[-1], "<meta dude>")
	}

	Void testHtmlNonVoid() {
		slim := Slim(["tagStyle":TagStyle.html])
		text := slim.parseFromStr("script (src='')")
		verifyEq(text.splitLines[-1], "<script src=''></script>")		
	}

	Void testHtmlNonVoidWarning() {
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(["tagStyle":TagStyle.html])
		text := slim.parseFromStr("meta\n span text")
		Log.removeHandler(handler)

		verify(text.splitLines[0].startsWith("<meta>"))		
		verify(text.splitLines[-1].endsWith ("</meta>"))
		
		verify(Actor.locals["slim.log"].toStr.contains("Void tag 'meta' *MUST NOT* have content!"))
		verify(Actor.locals["slim.log"].toStr.contains(": Line 1"))
	}

	Void testHtmlNonVoidWarning2() {
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(["tagStyle":TagStyle.html])
		text := slim.parseFromStr("meta dude")
		Log.removeHandler(handler)

		verify(text.splitLines[0].startsWith("<meta>"), text)
		verify(text.splitLines[-1].endsWith ("</meta>"), text)
		
		verify(Actor.locals["slim.log"].toStr.contains("Void tag 'meta' *MUST NOT* have content!"))
		verify(Actor.locals["slim.log"].toStr.contains(": Line 1"))
	}
	
	
	
	Void testXhtmlVoid() {
		slim := Slim(["tagStyle":TagStyle.xhtml])
		text := slim.parseFromStr("meta (dude)")
		verifyEq(text.splitLines[-1], "<meta dude />")
	}

	Void testXhtmlNonVoid() {
		slim := Slim(["tagStyle":TagStyle.xhtml])
		text := slim.parseFromStr("script (src='')")
		verifyEq(text.splitLines[-1], "<script src=''></script>")		
	}

	Void testXhtmlNonVoidWarning() {
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(["tagStyle":TagStyle.html])
		text := slim.parseFromStr("meta\n span text")
		Log.removeHandler(handler)
		
		verify(text.splitLines[0].startsWith("<meta>"), text)
		verify(text.splitLines[-1].endsWith ("</meta>"), text)

		verify(Actor.locals["slim.log"].toStr.contains("Void tag 'meta' *MUST NOT* have content!"))
		verify(Actor.locals["slim.log"].toStr.contains(": Line 1"))
	}
	
	Void testXhtmlNonVoidWarning2() {
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(["tagStyle":TagStyle.xhtml])
		text := slim.parseFromStr("meta dude")
		Log.removeHandler(handler)

		verify(text.splitLines[0].startsWith("<meta>"), text)
		verify(text.splitLines[-1].endsWith ("</meta>"), text)
		
		verify(Actor.locals["slim.log"].toStr.contains("Void tag 'meta' *MUST NOT* have content!"))
		verify(Actor.locals["slim.log"].toStr.contains(": Line 1"))
	}



	Void testXmlVoid() {
		slim := Slim(["tagStyle":TagStyle.xml])
		text := slim.parseFromStr("meta (dude)")
		verifyEq(text.splitLines[-1], "<meta dude />")
	}

	Void testXmlNonVoid() {
		slim := Slim(["tagStyle":TagStyle.xml])
		text := slim.parseFromStr("script (src='')")
		verifyEq(text.splitLines[-1], "<script src='' />")	// this is XML, so no special treatment for tags
	}

	Void testXmlNonVoidWarning() {
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(["tagStyle":TagStyle.xml])
		text := slim.parseFromStr("meta\n span text")
		Log.removeHandler(handler)

		verify(text.splitLines[0].startsWith("<meta>"), text)
		verify(text.splitLines[-1].endsWith ("</meta>"), text)

		verifyEq(Actor.locals["slim.log"], null)
	}

	Void testXmlNonVoidWarning2() {
		handler := |LogRec rec| { Actor.locals["slim.log"] = rec.msg }
		Log.addHandler(handler)
		
		slim := Slim(["tagStyle":TagStyle.xml])
		text := slim.parseFromStr("meta dude")
		Log.removeHandler(handler)

		verify(text.splitLines[0].startsWith("<meta>"), text)
		verify(text.splitLines[-1].endsWith ("</meta>"), text)
		
		verifyEq(Actor.locals["slim.log"], null)
	}
}
