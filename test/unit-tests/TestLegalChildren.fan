
internal class TestLegalChildren : SlimTest {
	
	Void testBugFromGundamIndex() {
s := """	// coment
        		-- illegal nested comment"""
		
		verifySlimErrMsg(ErrMsgs.slimLineCanNotNest(SlimLineFanComment#, SlimLineFanCode#)) {
			slim.parseFromStr(s)
		}		
	}

}
