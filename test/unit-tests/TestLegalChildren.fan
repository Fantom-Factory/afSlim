
internal class TestLegalChildren : SlimTest {
	
	Void testIllegal() {
s := """	-? using
        		-- illegal nested comment"""
		
		verifySlimErrMsg(ErrMsgs.slimLineCanNotNest(SlimLineInstruction#, SlimLineFanCode#)) {
			slim.parseFromStr(s)
		}		
	}

	Void testlegal1() {
s := """== fan eval
        	/* block comment"""
		slim.parseFromStr(s)
	}

	Void testlegal2() {
s := """-- fan code
        	/* block comment"""
		slim.parseFromStr(s)
	}

}
