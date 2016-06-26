using build

class Build : BuildPod {

	new make() {
		podName = "afSlim"
		summary = "A concise and lightweight templating language for generating HTML"
		version = Version("1.2.1")

		meta = [	
			"proj.name"		: "Slim",
			"afIoc.module"	: "afSlim::SlimModule",
			"repo.tags"		: "templating, web",
			"repo.public"	: "false"
		]

		depends = [
			"sys 1.0.68 - 1.0", 

			"afEfan    1.5.0 - 1.5", 
			"afPlastic 1.1.0 - 1.1",
			"afPegger  0.1.0 - 0.1",
			
			// ---- Testing ----
			"concurrent 1.0.8 - 1.0"
		]
		
		srcDirs = [`fan/`, `fan/internal/`, `fan/public/`, `test/unit-tests/`]
		resDirs = [`doc/`]
		
		meta["afBuild.testPods"]	= "concurrent"
	}
}
