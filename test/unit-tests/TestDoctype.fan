
internal class TestDoctype : SlimTest {
	
	Void testOneLineDoctype() {
		text := compiler.compile(``, "doctype html")
		verifyEq(text, "<!DOCTYPE html>\n")
	}

}
