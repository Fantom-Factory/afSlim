
@NoDoc	// advanced use only
const class SlimModule {
	
	Str:Obj nonInvasiveIocModule() {
		[
			"services"	: [
				[
					"id"	: Slim#.qname,
					"type"	: Slim#,
					"scopes": ["root"]
				]
			]
		]
	}

}
