using build

class Build : BuildPod {

	new make() {
		podName = "afSlim"
		summary = "A library for generating HTML from concise, lightweight templates"
		version = Version("1.1.3")

		meta = [	
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "Slim",
			"proj.uri"		: "http://www.fantomfactory.org/pods/afSlim",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afslim",
			"license.name"	: "The MIT Licence",
			"repo.private"	: "true",
			
			"tags"			: "templating, web"
		]

		depends = [
			"sys 1.0", 

			"afEfan 1.3.8+", 
			"afPlastic 1.0.10+",
			
			// for testing
			"concurrent 1.0"
		]
		
		srcDirs = [`test/unit-tests/`, `fan/`, `fan/public/`, `fan/internal/`]
		resDirs = [`licence.txt`, `doc/`]

		docApi = true
		docSrc = true
	}
	
	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		// see "stripTest" in `/etc/build/config.props` to exclude test src & res dirs
		super.compile
		
		destDir := Env.cur.homeDir.plus(`src/${podName}/`)
		destDir.delete
		destDir.create		
		`fan/`.toFile.copyInto(destDir)
		
		log.indent
		log.info("Copied `fan/` to ${destDir.normalize}")
		log.unindent
	}	
}
