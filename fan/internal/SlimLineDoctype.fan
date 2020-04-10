
internal const class SlimLineDoctypeCompiler : SlimLineCompiler {
	
	override Bool matches(Str line) {
		line.lower.startsWith("doctype")
	}
	
	override SlimLine compile(Str line) {
		SlimLineDoctype(line[7..-1].trim)
	}
}

internal class SlimLineDoctype : SlimLine {

	// don't confuse doctypes and tag endings
	private static const Str:Str doctypes	:= Str:Str [:] { caseInsensitive = true } .addAll([
		"xml"				: """<?xml version="1.0" ?>""",
		
		"html"				: """<!DOCTYPE html>""",
		
		// HTML5 XHTML?
		"xhtml"				: """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">""",
		"xhtml strict"		: """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">""",
		"xhtml frameset"	: """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">""",
		"xhtml mobile"		: """<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">""",
		"xhtml basic"		: """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">""",
		"xhtml transitional": """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">""",
		
		"html4"				: """<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">""",
		"html4 frameset"	: """<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">""",
		"html4 transitional": """<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">"""
	])
	
	Str doctype
	
	new make(Str doctype) {	
		xmlCharset := (Str?) null
		if (doctype.lower.startsWith("xml ")) {
			xmlCharset = doctype[4..-1]
			doctype = "xml"
		}
		
		this.doctype = doctypes[doctype] ?: throw SlimErr("Unknown Doctype: ${doctype}")
		if (xmlCharset != null) 
			this.doctype = this.doctype[0..-3] + "encoding=\"${xmlCharset}\" ?>" 
	}

	override Void onEntry(StrBuf buf) {
		indent(buf)
		buf.add(doctype)
		newLine(buf)
	}

	override Void onExit(StrBuf buf) { }
	
}
