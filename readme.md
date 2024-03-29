# Slim v1.5.0
---

[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](https://fantom-lang.org/)
[![pod: v1.5.0](http://img.shields.io/badge/pod-v1.5.0-yellow.svg)](http://eggbox.fantomfactory.org/pods/afSlim)
[![Licence: ISC](http://img.shields.io/badge/licence-ISC-blue.svg)](https://choosealicense.com/licenses/isc/)

## <a name="overview"></a>Overview

Slim is a library for generating HTML from concise, lightweight templates. Slim is based on [Jade](http://jade-lang.com/) for javascript and [Slim](http://slim-lang.com/) for Ruby.

Features include:

* indentation driven - closing tags not needed
* CSS shortcut notation for `#id` and `.class` attributes
* `${...}` notation to interpolate Fantom code
* Configurable HTML, XHTML or XML tag endings
* [efan](http://eggbox.fantomfactory.org/pods/afEfan) template generation
* Template nesting with *Layout* pattern.


.

> **ALIEN-AID:** Turn `Slim` templates into powerful HTML components with [efanXtra](http://eggbox.fantomfactory.org/pods/afEfan)!


## <a name="Install"></a>Install

Install `Slim` with the Fantom Pod Manager ( [FPM](http://eggbox.fantomfactory.org/pods/afFpm) ):

    C:\> fpm install afSlim

Or install `Slim` with [fanr](https://fantom.org/doc/docFanr/Tool.html#install):

    C:\> fanr install -r http://eggbox.fantomfactory.org/fanr/ afSlim

To use in a [Fantom](https://fantom-lang.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afSlim 1.5"]

## <a name="documentation"></a>Documentation

Full API & fandocs are available on the [Eggbox](http://eggbox.fantomfactory.org/pods/afSlim/) - the Fantom Pod Repository.

## <a name="quickStart"></a>Quick Start

1. Create a text file called `Example.slim`    -? using concurrent
    doctype html
    html
      head
        title afSlim Example
        meta (name="keywords" content="fantom html template language")
    
      body
        h1 Slim Example
    
        h2 Element shortcut notation:
    
        div#slimer This div has an ID of 'slimer'
        div.wombat This div has a class of 'wombat'
        div (style="color: red;") Attributes are specified in brackets
        div You can even embed <abbr>HTML</abbr> tags!
    
        | Use the pipe character for text
          that may be spanned across
          multiple lines!
    
        // This is a single line comment
    
        /* This is a block...
           .. or multiline comment
    
        /! This is a HTML comment
    
        // Use -- to execute Fantom code
        -- echo("Hello Pips!")
    
        // Use == to print the result of a Fantom expression
        == "Hello " + ctx["name"] + "!"
    
        // Use $(...) notation to embed Fantom expressions
        | Hello ${ ctx["name"] }!
    
        // Embedding Javascript is easy!
        script (type="text/javascript") |
          for (var i=0; i<3; i++) {
            console.info("Greetings from Slim!");
          }
    
        // Use ';' to condense elements onto one line
        ul; li; a (href="#") One line!


2. Create a text file called `Example.fan`    using afSlim
    
    class Example {
        Void main() {
            ctx  := ["name":"Emma"]
            html := Slim().renderFromFile(`Example.slim`.toFile, ctx)
            echo(html)
        }
    }


3. Run `Example.fan` as a Fantom script from the command line:    C:\> fan Example.fan
    <!DOCTYPE html>
    <html>
        <head>
            <title>afSlim Example</title>
            <meta name="keywords" content="fantom html template language">
        </head>
        <body>
            <h1>Slim Example</h1>
        ....
        ....




## <a name="syntax"></a>Syntax

The first non-whitespace characters of each line defines the content of the line:

    doctype : <!DOCTYPE ... >
        -?  : using statement
        --  : fantom code
        ==  : fantom eval
        //  : single line comment
        /*  : block comment
        /!  : HTML comment (single line only)
       a-Z  : HTML element
         |  : plain text
    

> **ALIEN-AID:** Whitespace indentation is *very* important! If your HTML looks wrong, click `Show Whitespace` in your editor / IDE and make sure you are not mixing up tabs and spaces.


### <a name="doctype"></a>Doctype

Start a line with `doctype` to print a document type. The common type would be `html`:

    doctype html
      <!DOCTYPE html>

If you specify a doctype of `xml` then what follows is taken to be the charset and is printed with the XML processing instruction. (In this case, the directive `doctype` is a bit of a misnomer.)

    doctype xml ISO-8859-1
      <?xml version="1.0" encoding="ISO-8859-1" ?>

Supported XHTML Doctypes:

    doctype xhtml
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
        "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
    
    doctype xhtml strict
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    
    doctype xhtml frameset
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
    
    doctype xhtml mobile
      <!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN"
      "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">
    
    doctype xhtml basic
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN"
        "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">
    
    doctype xhtml transitional
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

Supported HTML4 Doctypes:

    doctype html4
      <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
        "http://www.w3.org/TR/html4/strict.dtd">
    
    doctype html4 frameset
      <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
        "http://www.w3.org/TR/html4/frameset.dtd">
    
    doctype html4 transitional
      <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/html4/loose.dtd">

Note that the `doctype` directive is just a short hand notation for common DOCTYPE declarations, it does not enforce constaints on your template or alter it in any way.

To print custom DOCTYPE declarations, use the `|` character to print a standard string:

    | <!DOCTYPE wotever PUBLIC "http://www.wotever.com">

### <a name="using"></a>Using Statements

Start any line with `-?` to add a Fantom using statement.

    -? using afSlim

The `using statement` means you don't have to use fully qualified class names:

    -? using concurrent
    == Actor.locals("my.value")

### <a name="elements"></a>Elements

Element lines are formatted as:

    element[#id][.class][.class] [(attributes)] [text]
    
    div Text here           --> <div>Text here</div>
    div#wombat Text here    --> <div id="wombat">Text here</div>
    div.wombat Text here    --> <div class="wombat">Text here</div>
    div(data-type="wombat") --> <div data-type="wombat"></div>
    

Whitespace before the attribute brackets is optional:

    a (href="http://www.fantomfactory.org") Fantom
    a(href="http://www.fantomfactory.org") Fantom
    

Attributes may also be enclosed in square brackets:

    div[data-type="wombat"]
    

Use all the shortcuts together:

    div#robert.juice.media (data-on="You Tube") Rap News
    
    <div id="robert" class="juice media" data-on="You Tube">Rap News</div>
    

Note that attribute contents are not parsed. Whatever is inbetween the `(` - `)` or `[` - `]` is rendered exactly as is. This means you should not mix `id` and `class` attributes with shortcut notation as this would result in two `id` and `class` attributes, which would be invalid.

    div#top (id="bottom")
    
    <div id="top" id="bottom"></div>

If the text of an element needs to start with a bracket, then use empty attribute notation to avoid confusion:

    div() (In Brackets)
    
    <div>(In Brackets)</div>

If an element has no text, then it may be immediatly followed by a semi-colon `;` to start a fresh line. This concise syntax prevents `<li>`, and other empty elements, from taking up a whole line of their own.

    ul
      li; a (href="#") home
      li; span.highlight other page
      li; == ctx.otherPage
    

### <a name="comments-line"></a>Single Line Comments

Start any line with `//` to add a comment.

    // This is a comment
        div This is still rendered

Comments *do not* appear in the generated html, but *do* appear in the efan template.

### <a name="comments-block"></a>Block Comments

Start any line with `/*` to add a block comment.

    /* This is a Block comment
         Block comments span multiple lines
           And are great for temporarily removing chunks of HTML

Block comments *do not* appear in the generated html, but *do* appear in the efan template.

### <a name="comments-html"></a>HTML Comments

Start any line with `/!` to add a HTML comment.

    /! This is a HTML comment

becomes

    <!-- This is a HTML comment -->

HTML comments *do* appear in the generated HTML.

### <a name="fantomCode"></a>Fantom Code

Start any line with `--` to write Fantom code. Use to call efan helper methods.

    -- echo("Hello Mum!")

Note because Slim does not have end tags, you do not specify opening or closing { curly } brackets to denote blocks of code. Due to indentation, Slim works out where they should be.

    -- if (ctx.doughnuts.isEmpty)
      p You're not a *real* policeman!
    -- else
      ul
        -- ctx.doughnuts.each |nut|
          li Mmm... ${nut.filling}!

### <a name="fantomEval"></a>Fantom Eval

Start any line with `==` to evaluate a line of Fantom code and print it out in the template

    == ctx.doughnut.filling

The resulting string is printed raw and is *not* HTML escaped.

### <a name="plainText"></a>Plain Text

Any line starting with a `|` denotes plain text and is printed raw. You can even embed HTML:

    | Look at how <small>BIG</small> I am!

Unlike other line types, text may flow / span multiple lines.

    | Use the pipe character for text.
      It also lets text be spanned
      across multiple lines!
    

You can use `|` as the first character of an element. So the following:

    p
      | More recently, I discovered
        Fantom
        a niffty pragmatic language
    

May be re-written as:

    p | More recently, I discovered
        Fantom
        a niffty pragmatic language
    

This is handy for writing `<script>` tags:

    script (type="text/javascript") |
      console.info("Hello...");
      console.info("     ...Pips!");
    

Text may be mixed with elements:

    p
      | More recently, I discovered
      a (href="http://fantom.org/") FANTOM
      |  a niffty pragmatic language (*)
      | which runs on Java and .NET
    

(*) Note the extra leading space at the start of the line. This prevents it from butting up against the previous `<a>` tag:

    ... FANTOM a niffty pragmatic language

and not

    ... FANTOMa niffty pragmatic language

Slim trims 1 character of whitespace after a `|` and preserves trailing whitespace.

## <a name="fantomInterpolation"></a>Fantom Interpolation

Similar to [Fantom Str interpolation](https://fantom.org/doc/docLang/Literals.html), you can output Fantom expressions *anywhere* in the template using the standard `${...}` notation;

    div Mmmm... ${ctx.doughnut.filling} is my favourite!

By default all text rendered via `${...}` is XML escaped. To print raw / unescaped text use `$${...}`. Backslash escape any expression to ignore it and print it as is.

To summarise:

    .
      ${...} : XML escaped
     \${...} : ignored
     $${...} : raw / unescaped
    \$${...} : ignored
    

For simple expressions, the curly brackets may be omitted:

    div Mmmm... $ctx.doughnut.filling is my favourite!

## <a name="localisation"></a>Localisation

Similar to [Fantom Locale Literals](https://fantom.org/doc/docLang/Localization.html), you can output localised Fantom strings *anywhere* in the template using the standard `$<key>` notation;

    div Mmmm... $<doughnut.filling.raspberry> is my favourite!

Values pertaining to the key must be defined in locale props files as specified by [Fantom Localized Properties](https://fantom.org/doc/docLang/Localization.html). Property resolution follows the usual fallbacks of `locale -> lang -> en`. The `key` itself is printed should a localised value not exist.

By default all text rendered via `$<...>` is XML escaped. To print raw / unescaped text use `$$<...>`. Backslash escape any expression to ignore it and print it as is.

To summarise:

    .
      $<...> : XML escaped
     \$<...> : ignored
     $$<...> : raw / unescaped
    \$$<...> : ignored
    

### Arg Interpolation

Arguments may be passed as fantom literals / code to be interpolated into the localised values. Up to 4 arguments may be provided.

    div Mmmm... $<doughnuts, "cream", raspberry()> are my favourites!

Arguments are specified by `${x}` notation in the property value.

    doughnuts = Doughnuts with ${1} and ${2}

If more arguments are required, a list may be passed as the first argument.

    div Mmmm... $<doughnuts, ["cream", "raspberry", "vanilla", "strawberry", "chocolate"]> are my favourites!

A map may also be passed as the first arguments.

    div Mmmm... $<doughnuts, ["1st":"raspberry", "2nd":"cream"]>

Map arguments are interpolated via their keys.

    doughnuts = Doughnuts with ${1st} and ${2nd}

No checks are made to ensure all args are used, and no error is thrown should an arg does not exist.

## <a name="HtmlXhtmlXml"></a>HTML vs XHTML vs XML

### <a name="html"></a>HTML

By default `Slim` renders tags as HTML5 elements; that is, all tags representing [void elements](http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements) such as `meta`, `br` and `input` are printed without an end tag:

    <input type="submit">
    <br>

Warnings are logged should a void element NOT be empty.

HTML5 documents should be served up (from a web / app server such as [BedSheet](http://eggbox.fantomfactory.org/pods/afBedSheet)) with a `Content-Type` of:

    text/html

While HTML is nice for browsers, this format doesn't lend itself to XML parsing; should you wish to use [Sizzle](http://eggbox.fantomfactory.org/pods/afSizzle) for instance. So `Slim` offers alternative renderings of tag endings.

### <a name="xhtml"></a>XHTML

By creating [Slim](http://eggbox.fantomfactory.org/pods/afSlim/api/Slim) with a [TagStyle](http://eggbox.fantomfactory.org/pods/afSlim/api/TagStyle) of `xhtml` all [void elements](http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements) are rendered as a self-closing tags. Warnings are logged should a void element NOT be empty.

    <input type="submit" />
    <br />

All non void elements are *NOT* rendered as self closing, even when empty.

    <script></script>

XHTML documents should be served up with a `Content-Type` of:

    application/xhtml+xml

Note that Internet Explorer versions 8 and below are reported not to accept this MimeType, resulting in a download dialogue box shown to the user.

> Note that XHTML files **must** declare the xhtml namespace in the html tag or browsers will **not** render the page. Example:


    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">
      ...
    </html>

### <a name="xml"></a>XML

If you create [Slim](http://eggbox.fantomfactory.org/pods/afSlim/api/Slim) with a [TagStyle](http://eggbox.fantomfactory.org/pods/afSlim/api/TagStyle) of `xml` then *ALL* empty tags are self-closing and void tags have no special meaning. Use this style when Slim is to create pure XML documents.

[Depending on usage](http://stackoverflow.com/questions/4832357/whats-the-difference-between-text-xml-vs-application-xml-for-webservice-respons) XML documents may be served up with a `Content-Type` of either:

    text/xml
    application/xml

## <a name="customComponents"></a>Custom Components

If standard HTML tags aren't enough, you may register your own tags with Slim that render custom templates.

Pass your cutsom [SlimComponents](http://eggbox.fantomfactory.org/pods/afSlim/api/SlimComponent) to the Slim ctor and they get invoked whenever they are encountered in the Slim template.

    div:componentName#id.class (attributes)

or more simply:

    componentName#id.class (attributes)

## <a name="ioc"></a>IoC

Slim makes use of the non-invasive module feature of IoC 3.

When Slim is added as a dependency to an IoC enabled application, such as [BedSheet](http://eggbox.fantomfactory.org/pods/afBedSheet) or [Reflux](http://eggbox.fantomfactory.org/pods/afReflux), then:

* [Slim](http://eggbox.fantomfactory.org/pods/afSlim/api/Slim) becomes an injectable service
* [efan Xtra](http://eggbox.fantomfactory.org/pods/afEfanXtra) becomes aware of, and can parse, slim templates and `.slim` files.


