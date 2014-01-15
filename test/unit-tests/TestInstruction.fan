
internal class TestInstruction : SlimTest {
	
	Void testInstruction() {
		text := slim.parseFromStr("-? using afSlim")
		verifyEq(text, "<%? using afSlim %>")
	}

	Void testInstructionTrim() {
		text := slim.parseFromStr("-?    using afSlim     ")
		verifyEq(text, "<%? using afSlim %>")
	}

	Void testUsage() {
		text := slim.renderFromStr("== Dude.fromStr(\"69\") \n-? using sys::Int as Dude")
		verifyEq(text, "69")
	}
}

