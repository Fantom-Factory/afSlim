using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afSlim"
		summary = "A library for generating HTML from concise, lightweight templates"
		version = Version([1,0,3])

		meta	= [	
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "Slim",
			"proj.uri"		: "http://www.fantomfactory.org/pods/afSlim",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afslim",
			"license.name"	: "BSD 2-Clause License",
			"repo.private"	: "true"
		]

		depends = [
			"sys 1.0", 
			"concurrent 1.0", 
			"afEfan 1.3.6+", 
			"afPlastic 1.0.4+"
		]
		
		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`]
		resDirs = [`doc/`]

		docApi = true
		docSrc = true

		// exclude test code when building the pod
//		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }
//		resDirs = resDirs.exclude { it.toStr.startsWith("test/") }
	}
}
