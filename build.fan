using build

class Build : BuildPod {

	new make() {
		podName = "afSlim"
		summary = "A concise and lightweight templating language for generating HTML"
		version = Version("1.5.0")

		meta = [	
			"pod.dis"		: "Slim",
			"afIoc.module"	: "afSlim::SlimModule",
			"repo.tags"		: "templating, web",
			"repo.public"	: "true"
		]

		depends = [
			// ---- Fantom Core -----------------
			"sys        1.0.71 - 1.0", 

			// ---- Fantom Factory --------------
			"afEfan     2.0.4  - 2.0", 
			"afPlastic  1.1.6  - 1.1",
			"afPegger   1.1.0  - 1.1",

			// ---- Testing ---------------------
			"concurrent 1.0.71 - 1.0"
		]
	
		srcDirs = [`fan/`, `fan/internal/`, `fan/public/`, `test/unit-tests/`]
		resDirs = [`doc/`, `res/`]

		meta["afBuild.testPods"]	= "concurrent"
	}
}
