using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afSlim"
		summary = "A library for generating HTML from concise, lightweight templates."
		version = Version([0,0,6])

		meta	= [	"org.name"		: "Alien-Factory",
					"org.uri"		: "http://www.alienfactory.co.uk/",
					"vcs.uri"		: "https://bitbucket.org/Alien-Factory/afslim",
					"proj.name"		: "Slim",
					"license.name"	: "BSD 2-Clause License",
					"repo.private"	: "false"	// Eeek!
				]

		depends = ["sys 1.0", "afEfan 1.3+", "afPlastic 1.0.4+"]
		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`]
		resDirs = [`doc/`]

		docApi = true
		docSrc = true

		// exclude test code when building the pod
		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }
		resDirs = resDirs.exclude { it.toStr.startsWith("test/") }
	}
}
