
internal class TestDoctype : SlimTest {
	
	Void testOneLineDoctype() {
		text := compiler.compileFromStr(``, "doctype html")
		verifyEq(text, "<!DOCTYPE html>")
	}

}
