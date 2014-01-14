
internal class TestDoctype : SlimTest {
	
	Void testOneLineDoctype() {
		text := slim.parseFromStr("doctype html")
		verifyEq(text.splitLines[-1], "<!DOCTYPE html>")
	}
	
	Void testXml() {
		text := slim.parseFromStr("doctype xml")
		verifyEq(text.splitLines[-1], """<?xml version="1.0" ?>""")
	}

	Void testXmlCharset() {
		text := slim.parseFromStr("doctype xml ISO-8859-1")
		verifyEq(text.splitLines[-1], """<?xml version="1.0" encoding="ISO-8859-1" ?>""")
	}

	Void testXhtml() {
		text := slim.parseFromStr("doctype xhtml")
		verifyEq(text.splitLines[-1], """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">""")
	}

	Void testXhtmlStrict() {
		text := slim.parseFromStr("doctype xhtml strict")
		verifyEq(text.splitLines[-1], """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">""")
	}

	Void testHtml4() {
		text := slim.parseFromStr("doctype html4")
		verifyEq(text.splitLines[-1], """<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">""")
	}

	Void testUnknown() {
		verifySlimErrMsg(ErrMsgs.unknownDoctype("wibble")) {
			slim.parseFromStr("doctype wibble")
		}
	}

	Void testCustom() {
		text := slim.parseFromStr("""| <!DOCTYPE custom PUBLIC "http://www.wotever.com">""")
		verifyEq(text.splitLines[-1], """<!DOCTYPE custom PUBLIC "http://www.wotever.com">""")
	}

}
