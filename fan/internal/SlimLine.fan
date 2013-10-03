
internal abstract class SlimLine {
	Int slimLineNo
	Int leadingWs
	
	Int indentBy
	SlimLine? parent
	
	SlimLine[]	children	:= [,]
	
	new make() { }

	virtual SlimLine add(SlimLine slimLine) {
		// back out
		if (slimLine.leadingWs <= leadingWs)
			return parent.add(slimLine)
		
		children.getSafe(-1)?.addSibling(slimLine)
		children.add(slimLine)
		slimLine.parent = this
		slimLine.indentBy = indentBy + 1
		return slimLine		
//		return addChild(slimLine)
	}

	virtual Void addSibling(SlimLine slimLine) { }
//	virtual SlimLine addChild(SlimLine slimLine) {
//	}

	
//	Bool shouldContain(SlimLine slimLine) {
//		slimLine.leadingWs > leadingWs
//	}
	
//	Bool isInside(SlimLine slimLine) {
//		slimLine.leadingWs < leadingWs		
//	}
	
	virtual Bool consume(Int leadingWs, Str line) { false }
	
	abstract Void onEntry(StrBuf buf)
	abstract Void onExit(StrBuf buf)
	
	StrBuf toEfan(StrBuf buf) {
		onEntry(buf)
		children.each { it.toEfan(buf) }
		onExit(buf)
		return buf
	}
	
	Void indent(StrBuf buf, Int plus := 0) {
		(indentBy + plus).times { buf.addChar('\t') }
	}
	
	override Str toStr() {
		toEfan(StrBuf()).toStr
	}
}
