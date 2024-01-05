
class TestLocaleLiterals : Test {

	Void testDefault() {
		str := Slim().parseFromStr("p	\$<test>")
		// I know this is ugly, but lets just make sure the default function is being called correctly
		verifyEq(str, "<p><%= ((Obj?) afSlim::Slim.localeFn(this.typeof, \"test\"))?.toStr?.toXml %></p>")
	}
	
	Void testArgLiterals() {
		slim := Slim([
			"localeMethod"	: #localeFnTest,
		])
		
		str	:= "p	\$<test>"
		verifyEq(slim.renderFromStr(str), "<p>key : test</p>")
		
		str	= "p	\$<test, 1>"
		verifyEq(slim.renderFromStr(str), "<p>key : test arg1 : 1</p>")
		
		str	= "p	\$<test, 1, 2>"
		verifyEq(slim.renderFromStr(str), "<p>key : test arg1 : 1 arg2 : 2</p>")
		
		str	= "p	\$<test, 1, 2, 3>"
		verifyEq(slim.renderFromStr(str), "<p>key : test arg1 : 1 arg2 : 2 arg3 : 3</p>")
		
		str	= "p	\$<test, 1, 2, 3, 4>"
		verifyEq(slim.renderFromStr(str), "<p>key : test arg1 : 1 arg2 : 2 arg3 : 3 arg4 : 4</p>")
		
		
		// test ignore
		str = "p	\\\$<test>"
		verifyEq(slim.renderFromStr(str), "<p>\$<test></p>")
		
		
		// test args as functions are executed properly
		// just the key
		str	= "p	\$<${1+1}>"
		verifyEq(slim.renderFromStr(str), "<p>key : 2</p>")
		
		// one arg
		str	= "p	\$<test, ${1+0}>"
		verifyEq(slim.renderFromStr(str), "<p>key : test arg1 : 1</p>")
		
		// one arg, function for key
		str	= "p	\$<${1+1}, ${1+0}>"
		verifyEq(slim.renderFromStr(str), "<p>key : 2 arg1 : 1</p>")
		
		// multiple args, one function
		str	= "p	\$<test, 1, ${1+1}>"
		verifyEq(slim.renderFromStr(str), "<p>key : test arg1 : 1 arg2 : 2</p>")
		
		// multiple args, one function, function for key
		str	= "p	\$<${1+1}, 1, ${1+1}>"
		verifyEq(slim.renderFromStr(str), "<p>key : 2 arg1 : 1 arg2 : 2</p>")
		
		// multiple args, all functions
		str	= "p	\$<test, ${1+0}, ${1+1}>"
		verifyEq(slim.renderFromStr(str), "<p>key : test arg1 : 1 arg2 : 2</p>")
		
		// multiple args, all functions, function for key
		str	= "p	\$<${1+1}, ${1+0}, ${1+1}>"
		verifyEq(slim.renderFromStr(str), "<p>key : 2 arg1 : 1 arg2 : 2</p>")
		
		
		// test escaping within strings 
		// key as escaped function
		str	= Str<|p	$<${test}>|>
		verifyEq(slim.renderFromStr(str), Str<|<p>key : ${test}</p>|>)
		
		// one arg
		str	= Str<|p	$<test, "\${foo}">|> 
		verifyEq(slim.renderFromStr(str), Str<|<p>key : test arg1 : ${foo}</p>|>)

		// one arg, key as escaped function
		str	= Str<|p	$<${test}, "\${foo}">|> 
		verifyEq(slim.renderFromStr(str), Str<|<p>key : ${test} arg1 : ${foo}</p>|>)

		// multiple args, one function
		str	= Str<|p	$<test, 1, "\${bar}">|> 
		verifyEq(slim.renderFromStr(str), Str<|<p>key : test arg1 : 1 arg2 : ${bar}</p>|>)

		// multiple args, one function, key as escaped function
		str	= Str<|p	$<${test}, 1, "\${bar}">|> 
		verifyEq(slim.renderFromStr(str), Str<|<p>key : ${test} arg1 : 1 arg2 : ${bar}</p>|>)
		
		// multiple args, all functions
		str	= Str<|p	$<test, "\${foo}", "\${bar}">|> 
		verifyEq(slim.renderFromStr(str), Str<|<p>key : test arg1 : ${foo} arg2 : ${bar}</p>|>)
		
		// multiple args, all functions, key as escaped function
		str	= Str<|p	$<${test}, "\${foo}", "\${bar}">|> 
		verifyEq(slim.renderFromStr(str), Str<|<p>key : ${test} arg1 : ${foo} arg2 : ${bar}</p>|>)
	}
	
	Void testXml() {
		slim := Slim([
			"localeMethod"	: #localeFnTest,
		])

		// one tag - in arg
		str	:= Str<|p	$$<test, "<b>test</b>">|>
		verifyEq(slim.renderFromStr(str), "<p>key : test arg1 : <b>test</b></p>")

		// two tags
		str	= Str<|p	$$<test, "<b><c>test</c></b>">|>
		verifyEq(slim.renderFromStr(str), "<p>key : test arg1 : <b><c>test</c></b></p>")
		
		// invalid XML - beyond our control, but let's at least make sure the output is as we like it!
		str	= Str<|p	$$<test, "<b>test">|>
		verifyEq(slim.renderFromStr(str), "<p>key : test arg1 : <b>test</p>")
		
		// test escaping
		str	= Str<|p	\$$<test, "<b>test</b>">|>
		verifyEq(slim.renderFromStr(str), Str<|<p>$$<test, "<b>test</b>"></p>|>)
	}
	
	public static Str localeFnTest(Obj poddy, Str key, Obj? arg1 := null, Obj? arg2 := null, Obj? arg3 := null, Obj? arg4 := null) {
		buf := StrBuf()
		
		buf.add("key : $key")
		
		if (arg1 != null)
			buf.add(" ").add("arg1 : $arg1")
		if (arg2 != null)
			buf.add(" ").add("arg2 : $arg2")
		if (arg3 != null)
			buf.add(" ").add("arg3 : $arg3")
		if (arg4 != null)
			buf.add(" ").add("arg4 : $arg4")
		
		return buf.toStr
	}
}
