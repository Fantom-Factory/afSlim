using afPlastic
using afEfan

** (Service) - 
** Non-caching service methods for parsing and compiling Slim templates efan templates, and for rendering HTML.
** 
** For further information on the 'ctx' parameter, see 
** [efan: Template Context]`http://eggbox.fantomfactory.org/pods/afEfan/doc#templateContext`
** 
** Note: This class is available as a service in IoC v3 under the 'root' scope with an ID of 'afSlim::Slim'.
const class Slim {
	
	** The void tag ending style for compiled templates
			const TagStyle tagStyle

	private const EfanCompiler		efanCompiler	:= EfanCompiler()
	private const SlimParser		slimParser
	private const SlimComponent[]	components
	
	// TODO debugStr() for AFX - tagStyle, component list, and l10nMethod

	** Creates a 'Slim' instance, setting the ending style for tags.
	** 
	** Default opts:
	** 
	** pre>
	** table:
	** name            default            desc
	** --------------  -----------------  ----
	** 'tagStyle'      'TagStyle.html'    Describes how tags are ended.
	** 'components'    'SlimComponent[]'  SlimComponents to use.
	** 'localeMethod'  'Slim#localeFn'    The static method used to obtain L10N translations.
	** <pre
	new make([Str:Obj]? opts := null) {
		// this opts ctor makes this Slim class an easy AFX service to contribute to! 
		this.tagStyle	 = (opts?.get("tagStyle"	) as TagStyle)			?: TagStyle.html
		this.components	 = (opts?.get("components"	) as SlimComponent[])	?: SlimComponent#.emptyList
			 localeFn	:= (opts?.get("localeMethod") as Method)			?: #localeFn
		this.slimParser	 = SlimParser(tagStyle, this.components, localeFn)
	}
	
	** Parses the given slim template into an efan template.
	** 
	** 'srcLocation' may anything - used for meta information only.
	Str parseFromStr(Str slimTemplate, Uri? srcLocation := null) {
		srcLocation	=  srcLocation ?: `from/slim/template`
		tree := SlimLineRoot()
		slimParser.parse(srcLocation, slimTemplate, tree)
		buf	 := StrBuf(slimTemplate.size)
		efan := tree.toEfan(buf).toStr.trim
		if (efan.startsWith("%>"))
			efan = efan[2..-1]
		if (efan.endsWith("<%#"))
			efan = efan[0..-4]
		return efan
	}

	** Parses the given slim file into an efan template.
	Str parseFromFile(File slimFile) {
		srcLocation	:=  slimFile.normalize.uri
		return parseFromStr(slimFile.readAllStr, srcLocation)
	}

	** Compiles a renderer from the given slim template.
	** 
	** 'srcLocation' may be anything - it is used for meta information only.
	EfanMeta compileFromStr(Str slimTemplate, Type? ctxType := null, Type[]? viewHelpers := null, Uri? srcLocation := null) {
		srcLocation	=  srcLocation ?: `from/slim/template`
		efan		:= this.parseFromStr(slimTemplate, srcLocation)
		template	:= efanCompiler.compile(srcLocation, efan, ctxType, viewHelpers ?: Type#.emptyList)
		return template
	}

	** Compiles a renderer from the given slim file.
	EfanMeta compileFromFile(File slimFile, Type? ctxType := null, Type[]? viewHelpers := null) {
		srcLocation	:= slimFile.normalize.uri
		efan		:= this.parseFromStr(slimFile.readAllStr, srcLocation)
		template	:= efanCompiler.compile(srcLocation, efan, ctxType, viewHelpers ?: Type#.emptyList)
		return template
	}

	** Renders the given slim template into HTML.
	** 
	** 'srcLocation' may anything - used for meta information only.
	Str renderFromStr(Str slimTemplate, Obj? ctx := null, Type[]? viewHelpers := null, Uri? srcLocation := null) {
		template := this.compileFromStr(slimTemplate, ctx?.typeof, viewHelpers, srcLocation)
		return template.render(ctx)
	}

	** Renders the given slim template file into HTML.
	Str renderFromFile(File slimFile, Obj? ctx := null, Type[]? viewHelpers := null) {
		template := this.compileFromFile(slimFile, ctx?.typeof, viewHelpers)
		return template.render(ctx)
	}
	
	** Returns a locale string for the given key and args.
	** Translations are looked up in the given pod (may be a 'Pod', 'Str', 'Type', or instance).
	** 
	** If 'locale' is null, the thread's current Locale is used. 
	** 
	** Args may be interpolated with '${1}'. For more than 4 args, pass a list as 'arg1'.
	** For named args, pass a Map as 'arg1' - '${someKey}'
	static Str localeStr(Obj poddy, Str key, Locale? locale := null, Obj? arg1 := null, Obj? arg2 := null, Obj? arg3 := null, Obj? arg4 := null) {
		// look for a pod that may contain the translation - ignoring afPlastic abominations
		pod := poddy as Pod

		if (pod == null && poddy is Str)
			pod = Pod.find(poddy, false)

		if (pod == null) {
			type := poddy as Type
			if (type == null)
				type = poddy.typeof
			while (type.pod.name.startsWith("afPlastic"))
				type = type.base
			pod = type.pod
		}

		locale = locale ?: Locale.cur
		str := Env.cur.locale(pod, key, null, locale)

		// try just the lang, e.g. en-GB -> en
		if (str == null && locale.country != null) {
			lang := Locale(locale.lang)
			str = Env.cur.locale(pod, key, null, lang)
		}

		if (str == null)
			str = Env.cur.locale(pod, key, null, Locale.en)

		// backdoor for testing - let poddy also be a Map
		if (str == null && poddy is Map)
			str = ((Str:Str) poddy)["${key}.${locale}"]

		if (str == null) {
			pod.log.warn("Could NOT find locale str - ${pod.name}::${key}")
			return "???"
		}
		
		if (arg1 != null)
			str = str.replace("\${1}", arg1.toStr)
		
		// TODO test and perform MOAR interpolation

		return str
	}
	
	@NoDoc
	static Str localeFn(Obj poddy, Str key, Obj? arg1 := null, Obj? arg2 := null, Obj? arg3 := null, Obj? arg4 := null) {
		// defer to localeStr() as it is more useful / generic as it also takes a Locale
		localeStr(poddy, key, null, arg1, arg2, arg3, arg4)
	}
}
