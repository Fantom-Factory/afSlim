
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
		concurrent::Actor.locals["test"] = "Rubbish!"
		text := slim.renderFromStr("== Actor.locals[\"test\"]\n-? using concurrent")
		verifyEq(text, "Rubbish!")
	}
}

