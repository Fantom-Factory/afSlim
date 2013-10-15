
internal class TestDoctype : SlimTest {
	
	Void testOneLineDoctype() {
		text := slim.parseFromStr("doctype html")
		verifyEq(text, "<!DOCTYPE html>")
	}

}
