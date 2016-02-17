using build

class Build : BuildPod {

	new make() {
		podName = "afSlim"
		summary = "A library for generating HTML from concise, lightweight templates"
		version = Version("1.1.20")

		meta = [	
			"proj.name"		: "Slim",
			"repo.tags"		: "templating, web",
			"repo.public"	: "true"
		]

		depends = [
			"sys 1.0", 

			"afEfan    1.4.2  - 1.4", 
			"afPlastic 1.0.16 - 1.0",
			"afPegger  0.0.4  - 0.0",
			
			// ---- Testing ----
			"concurrent 1.0.8 - 1.0"
		]
		
		srcDirs = [`fan/`, `fan/internal/`, `fan/public/`, `test/unit-tests/`]
		resDirs = [`doc/`]
	}
	
	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		// remove test pods from final build
		testPods := "concurrent".split
		depends = depends.exclude { testPods.contains(it.split.first) }
		super.compile
	}
}
