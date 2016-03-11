using build

class Build : BuildPod {

	new make() {
		podName = "afSlim"
		summary = "A library for generating HTML from concise, lightweight templates"
		version = Version("1.2.0")

		meta = [	
			"proj.name"		: "Slim",
			"testPods"		: "concurrent",
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
		
		srcDirs = [`fan/`, `fan/internal/`, `fan/public/`, `test/unit-tests/`]
		resDirs = [`doc/`]
	}
}
