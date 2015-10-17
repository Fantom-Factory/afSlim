
@NoDoc	// advanced use only
const class SlimModule {
	
	Str:Obj defineModule() {
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
