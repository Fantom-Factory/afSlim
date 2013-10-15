
internal class TestFanEval : SlimTest {
	
	Void test1Line() {
s := """== renderStuff() """
		text := slim.parseFromStr(s)
		verifyEq(text, "<%= renderStuff() %>")
	}

}