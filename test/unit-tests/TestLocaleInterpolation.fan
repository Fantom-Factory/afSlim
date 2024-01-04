
internal class TestLocaleInterpolation : SlimTest{
	Void testLocaleArgInterpolation() {
		string	:= null as Str
		
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once upon a midnight dreary"
		], "look.up.foo", Locale.en)
		verifyEq(string, "Once upon a midnight dreary")
		
		// test 1 arg - single word
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} a midnight dreary"
		], "look.up.foo", Locale.en, "upon")
		verifyEq(string, "Once upon a midnight dreary")

		// test 1 arg - multiword
		string	= Slim.localeStr([
			"look.up.foo.en" : "\${1}"
		], "look.up.foo", Locale.en, "Once upon a midnight dreary")
		verifyEq(string, "Once upon a midnight dreary")
		
		// test 2 args
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} midnight dreary"
		], "look.up.foo", Locale.en, "upon", "a")
		verifyEq(string, "Once upon a midnight dreary")
		
		// test 3 args
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} \${3} dreary"
		], "look.up.foo", Locale.en, "upon", "a", "midnight")
		verifyEq(string, "Once upon a midnight dreary")
		
		// test 4 args
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} \${3} \${4}"
		], "look.up.foo", Locale.en, "upon", "a", "midnight", "dreary")
		verifyEq(string, "Once upon a midnight dreary")
		
		// test a few permuatations of skipping args
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} a midnight \${4}"
		], "look.up.foo", Locale.en, "upon", null, null, "dreary")
		verifyEq(string, "Once upon a midnight dreary")
		
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once upon \${2} \${3} \${4}"
		], "look.up.foo", Locale.en, null, "a", "midnight", "dreary")
		verifyEq(string, "Once upon a midnight dreary")
		
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once upon a \${3} dreary"
		], "look.up.foo", Locale.en, null, null, "midnight", null)
		verifyEq(string, "Once upon a midnight dreary")
		
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once upon \${2} midnight \${4}"
		], "look.up.foo", Locale.en, null, "a", null, "dreary")
		verifyEq(string, "Once upon a midnight dreary")
		
		
		// test args as map
		// 1 arg
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${arg1} a midnight dreary"
		], "look.up.foo", Locale.en, ["arg1" : "upon"])
		verifyEq(string, "Once upon a midnight dreary")
		
		// 2 args
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${arg1} \${arg2} midnight dreary"
		], "look.up.foo", Locale.en, ["arg1" : "upon", "arg2" : "a"])
		verifyEq(string, "Once upon a midnight dreary")
		
		// 4 args
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${arg1} \${arg2} \${arg3} \${arg4}"
		], "look.up.foo", Locale.en, ["arg1" : "upon", "arg2" : "a", "arg3" : "midnight", "arg4" : "dreary"])
		verifyEq(string, "Once upon a midnight dreary")
		
		
		// test args as list
		// 1 arg
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} a midnight dreary"
		], "look.up.foo", Locale.en, ["upon"])
		verifyEq(string, "Once upon a midnight dreary")
		
		// 2 args
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} midnight dreary"
		], "look.up.foo", Locale.en, ["upon", "a"])
		verifyEq(string, "Once upon a midnight dreary")
		
		// 4 args
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} \${3} \${4}"
		], "look.up.foo", Locale.en, ["upon", "a", "midnight", "dreary"])
		verifyEq(string, "Once upon a midnight dreary")
		
		// 7 args
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} \${3} \${4} \${5} \${6} \${7}"
		], "look.up.foo", Locale.en, ["upon", "a", "midnight", "dreary", "while", "I", "pondered"])
		verifyEq(string, "Once upon a midnight dreary while I pondered")
		
		
		// test multiple keys in a 'pod'
		// same language, different key
		string	= Slim.localeStr([
			"look.up.foo.en" 	: "This should not be picked up!",
			"look.down.foo.en" 	: "Once upon a midnight dreary",
		], "look.down.foo", Locale.en)
		verifyEq(string, "Once upon a midnight dreary")
		
		// different language, different key
		string	= Slim.localeStr([
			"look.up.foo.en" 	: "This should not be picked up!",
			"look.down.foo.cy" 	: "Once upon a midnight dreary",
		], "look.down.foo", Locale.fromStr("cy"))
		verifyEq(string, "Once upon a midnight dreary")
		
		// different language, same key
		string	= Slim.localeStr([
			"look.up.foo.en" 	: "This should not be picked up!",
			"look.up.foo.cy" 	: "Once upon a midnight dreary",
		], "look.up.foo", Locale.fromStr("cy"))
		verifyEq(string, "Once upon a midnight dreary")
		
		// verify a warning is logged when key doesn't exist for the locale
		verifyEq(Log.get("sys").level.toStr, "info") // make sure nothing has raised the level previously - we need to detect a change!
		string	= Slim.localeStr([
			"look.up.foo.en" 	: "Once upon a midnight dreary",
		], "look.up.foo",  Locale.fromStr("cy"))
		verifyEq(Log.get("sys").isWarn, true)
		
		
		// test null handling 
		// nulls in lists
		// 1 item (only null)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} a midnight dreary"
		], "look.up.foo", Locale.en, [null])
		verifyEq(string, "Once null a midnight dreary")
		
		// 2 items (1 null)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} midnight dreary"
		], "look.up.foo", Locale.en, [null, "a"])
		verifyEq(string, "Once null a midnight dreary")
		
		// 2 items (both null)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} midnight dreary"
		], "look.up.foo", Locale.en, [null, null])
		verifyEq(string, "Once null null midnight dreary")
		
		// 3 items (1 null)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} \${3} dreary"
		], "look.up.foo", Locale.en, [null, "a", "midnight"])
		verifyEq(string, "Once null a midnight dreary")
		
		// 3 items (2 nulls)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} \${3} dreary"
		], "look.up.foo", Locale.en, [null, "a", null])
		verifyEq(string, "Once null a null dreary")
		
		// 3 items (3 nulls)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} \${3} dreary"
		], "look.up.foo", Locale.en, [null, null, null])
		verifyEq(string, "Once null null null dreary")
		
		// nulls in maps
		// 1 item (only null)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} a midnight dreary"
		], "look.up.foo", Locale.en, ["1" : null])
		verifyEq(string, "Once null a midnight dreary")
		
		// 2 items (1 null)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} midnight dreary"
		], "look.up.foo", Locale.en, ["1" : null, "2" : "a"])
		verifyEq(string, "Once null a midnight dreary")
		
		// 2 items (both null)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} midnight dreary"
		], "look.up.foo", Locale.en, ["1" : null, "2" : null])
		verifyEq(string, "Once null null midnight dreary")
		
		// 3 items (1 null)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} \${3} dreary"
		], "look.up.foo", Locale.en, ["1" : null, "2" : "a", "3" : "midnight"])
		verifyEq(string, "Once null a midnight dreary")
		
		// 3 items (2 nulls)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} \${3} dreary"
		], "look.up.foo", Locale.en, ["1" : null, "2" : "a", "3" : null])
		verifyEq(string, "Once null a null dreary")
		
		// 3 items (3 nulls)
		string	= Slim.localeStr([
			"look.up.foo.en" : "Once \${1} \${2} \${3} dreary"
		], "look.up.foo", Locale.en, ["1" : null, "2" : null, "3" : null])
		verifyEq(string, "Once null null null dreary")
	}
}
