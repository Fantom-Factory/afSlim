
internal class ErrMsgs {

	static Str elementCompilerNoMatch(Str line) {
		"Could not match element in: ${line}"
	}

	static Str slimLineCanNotNest(Type parent, Type child) {
		pName := parent.name[8..-1].toDisplayName
		cName := child.name[8..-1].toDisplayName
		return "Can not nest a ${cName} in a ${pName}"
	}

	static Str unknownDoctype(Str doctype) {
		"Unknown Doctype: ${doctype}"
	}
}
