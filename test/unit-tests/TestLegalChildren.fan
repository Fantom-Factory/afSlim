
internal class TestLegalChildren : SlimTest {
	
	Void testBugFromGundamIndex() {
s := """	-? using
        		-- illegal nested comment"""
		
		verifySlimErrMsg(ErrMsgs.slimLineCanNotNest(SlimLineInstruction#, SlimLineFanCode#)) {
			slim.parseFromStr(s)
		}		
	}

}
