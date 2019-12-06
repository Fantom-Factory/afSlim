using build

class Build : BuildPod {

	new make() {
		podName = "afSlim"
		summary = "A concise and lightweight templating language for generating HTML"
		version = Version("2.0.0")

		meta = [	
			"proj.name"		: "Slim",
			"afIoc.module"	: "afSlim::SlimModule",
			"repo.tags"		: "templating, web",
			"repo.public"	: "true"
		]

		depends = [
			"sys        1.0.73 - 1.0", 

			"afEfan     2.0.0  - 2.0", 
			"afPlastic  1.1.6  - 1.1",
			"afPegger   0.1.0  - 0.1",
			
			// ---- Testing ----
			"concurrent 1.0.73 - 1.0"
		]
		
		srcDirs = [`fan/`, `fan/internal/`, `fan/public/`, `test/unit-tests/`]
		resDirs = [`doc/`]
		
		meta["afBuild.testPods"]	= "concurrent"
	}
}
