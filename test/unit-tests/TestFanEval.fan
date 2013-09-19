
internal class TestFanEval : SlimTest {
	
	Void test1Line() {
s := """== renderStuff() """
		text := compiler.compile(``, s)
		verifyEq(text, "<%= renderStuff() %>\n")
	}

}