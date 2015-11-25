using build

class Build : BuildPod {

	new make() {
		podName = "afSlim"
		summary = "A library for generating HTML from concise, lightweight templates"
		version = Version("1.2.0")

		meta = [	
			"proj.name"		: "Slim",
			"afIoc.module"	: "afSlim::SlimModule",
			"repo.tags"		: "templating, web",
			"repo.public"	: "false"
		]

		depends = [
			"sys 1.0", 

			"afEfan    1.5.0 - 1.5", 
			"afPlastic 1.1.0 - 1.1",
			"afPegger  0.1.0 - 0.1",
			
			// ---- Testing ----
			"concurrent 1.0.8 - 1.0"
		]
		
		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`]
		resDirs = [`doc/`]
	}
	
	override Void compile() {
		// remove test pods from final build
		testPods := "concurrent".split
		depends = depends.exclude { testPods.contains(it.split.first) }
		super.compile
	}
}
