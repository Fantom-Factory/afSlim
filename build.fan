using build

class Build : BuildPod {

	new make() {
		podName = "afSlim"
		summary = "A library for generating HTML from concise, lightweight templates"
		version = Version("1.1.5")

		meta = [	
			"proj.name"		: "Slim",
			"tags"			: "templating, web",
			"repo.private"	: "true"
		]

		depends = [
			"sys 1.0", 

			"afEfan 1.4.0.1+", 
			"afPlastic 1.0.12+",
			
			// for testing
			"concurrent 1.0"
		]
		
		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`]
		resDirs = [,]

		docApi = true
		docSrc = true
	}
}
