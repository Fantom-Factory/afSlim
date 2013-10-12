
internal class TestFanEval : SlimTest {
	
	Void test1Line() {
s := """== renderStuff() """
		text := compiler.compileFromStr(``, s)
		verifyEq(text, "<%= renderStuff() %>")
	}

}