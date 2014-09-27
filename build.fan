using build

class Build : BuildPod {

	new make() {
		podName = "afSlim"
		summary = "A library for generating HTML from concise, lightweight templates"
		version = Version("1.1.11")

		meta = [	
			"proj.name"		: "Slim",
			"tags"			: "templating, web",
			"repo.private"	: "true"
		]

		depends = [
			"sys 1.0", 

			"afEfan 1.4.0.1+", 
			"afPlastic 1.0.14+",
			"afPegger 0+",
			
			// for testing
			"concurrent 1.0"
		]
		
		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`]
		resDirs = [,]
	}
	
	override Void compile() {
		// remove test pods from final build
		testPods := "concurrent".split
		depends = depends.exclude { testPods.contains(it.split.first) }
		super.compile
	}
}
