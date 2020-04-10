using afPlastic::SrcCodeSnippet

internal abstract class SlimLine {
	SrcCodeSnippet?	srcSnippet
	Int 		slimLineNo
	Int 		leadingWs
	
	Int 		indentBy
	SlimLine? 	parent
	
	SlimLine[]	children	:= [,]

	Str?		nextLine

	new make() { }

	virtual SlimLine add(SlimLine slimLine, Bool multiLine) {
		// back out
		if (slimLine.leadingWs <= leadingWs && !multiLine)
			return parent.add(slimLine, multiLine)
		
		return addChild(slimLine)
	}

	SlimLine addChild(SlimLine slimLine) {
		if (!legalChildren.any { slimLine.typeof.fits(it) })
			throw SlimErr(slimLineCanNotNest(typeof, slimLine.typeof))
		
		children.getSafe(-1)?.addSibling(slimLine)
		children.add(slimLine)
		slimLine.parent = this
		slimLine.indentBy = indentBy + 1
		return slimLine		
	}

	virtual Void addSibling(SlimLine slimLine) { }
	
	virtual Bool consume(Int leadingWs, Str line) { false }
	
	abstract Void onEntry(StrBuf buf)
	abstract Void onExit(StrBuf buf)

	virtual Type[] legalChildren() { Type#.emptyList }
	
	StrBuf toEfan(StrBuf buf) {
		onEntry(buf)
		children.each { it.toEfan(buf) }
		onExit(buf)
		return buf
	}
	
	Void indent(StrBuf buf, Int plus := 0) {
		(indentBy + plus).times { buf.addChar('\t') }
		buf.add("%>")
	}

	Void newLine(StrBuf buf) {
		buf.add("<%#\n")
	}
	
	override Str toStr() {
		toEfan(StrBuf()).toStr
	}
	
	private Str slimLineCanNotNest(Type parent, Type child) {
		pName := parent.name[8..-1].toDisplayName
		cName := child.name[8..-1].toDisplayName
		return "Can not nest a ${cName} in a ${pName}"
	}
}
