
@NoDoc	// advanced use only
const class SlimModule {
	
	Str:Obj nonInvasiveIocModule() {
		[
			"services"	: [
				[
					"id"	: Slim#.qname,
					"type"	: Slim#,
//					"scopes": ["root"],
				]
			],

			"contributions" : [
				[
					"serviceId"	: "afEfanXtra::TemplateConverters",
					"key"		: "slim",
					"valueFunc"	: |Slim slim -> Obj| {
						|Str src -> Str| { slim.parseFromStr(src) }
					}
				]
			]
		]
	}
}
