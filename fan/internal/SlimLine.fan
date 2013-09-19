
internal abstract class SlimLine {
	Int slimLineNo
	Int leadingWs
	
	Int indentBy
	SlimLine? parent
	
	SlimLine[]	children	:= [,]
	
	new make() { }

	Bool shouldContain(SlimLine slimLine) {
		slimLine.leadingWs > leadingWs
	}
	
	SlimLine add(SlimLine slimLine) {
		if (slimLine.leadingWs <= leadingWs)
			return parent.add(slimLine)
		children.add(slimLine)
		slimLine.parent = this
		slimLine.indentBy = indentBy + 1
		return slimLine
	}
	
	Bool isInside(SlimLine slimLine) {
		slimLine.leadingWs < leadingWs		
	}
	
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
