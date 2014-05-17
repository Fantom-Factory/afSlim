## Overview 

`Slim` is a library for generating HTML from concise, lightweight templates. `Slim` is based on [Jade](http://jade-lang.com/) for javascript and [Slim](http://slim-lang.com/) for Ruby.

Features include:

- indentation driven - closing tags not needed
- CSS shortcut notation for `#id` and `.class` attributes
- `${...}` notation to interpolate Fantom code
- Configurable HTML, XHTML or XML tag endings
- [efan](http://www.fantomfactory.org/pods/afEfan) template generation
- Template nesting with *Layout* pattern.

.

> **ALIEN-AID:** Turn `Slim` templates into powerful HTML components with [efanXtra](http://www.fantomfactory.org/pods/afEfan)!

## Install 

Install `Slim` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://repo.status302.com/fanr/ afSlim

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afSlim 1.1+"]

## Documentation 

Full API & fandocs are available on the [Status302 repository](http://repo.status302.com/doc/afSlim/).

## Quick Start 

1). Create a text file called `Example.slim`:

```
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

    | Use the pipe character for text.
      Text may also be spanned
      across multiple lines!

    // This is a Slim comment

    /! This is a HTML comment

    | Use -- to execute Fantom code
    -- echo("Hello Pips!")

    | Use == to print the result of a fantom expression
    == "Hello " + ctx["name"] + "!"

    // Use $(...) notation to embed Fantom expressions
    | Hello ${ctx["name"]}!

    // embedding Javascript is easy!
    script (type="text/javascript") |
      for (var i=0; i<3; i++) {
        console.info("Greetings from Slim!");
      }
```

2). Create a text file called `Example.fan`:

```
using afSlim

class Example {
    Void main() {
        ctx  := ["name":"Emma"]
        html := Slim().renderFromFile(`Example.slim`.toFile, ctx)
        echo(html)
    }
}
```

3). Run `Example.fan` as a Fantom script from the command line:

```
C:\> fan Example.fan
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
```

## Syntax 

The first non-whitespace characters of each line defines the content of the line:

```
doctype : <!DOCTYPE ... >
    -?  : using statement
    --  : fantom code
    ==  : fantom eval
    //  : Slim comment
    /!  : HTML comment
   a-Z  : HTML element
     |  : plain text
```

> **ALIEN-AID:** Whitespace indentation is *very* important! If your HTML looks wrong, click `Show Whitespace` in your editor / IDE and make sure you are not mixing up tabs and spaces.

### Doctype 

Start a line with `doctype` to print a document type. The common type would be `html`:

    doctype html   -->   <!DOCTYPE html>

If you specify a doctype of `xml` then what follows is taken to be the charset and is printed with the XML processing instruction. (In this case, the directive `doctype` is a bit of a misnomer.)

    doctype xml ISO-8859-1  -->
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

### Using Statements 

Start any line with `-?` to add a fantom using statement.

    -? using afSlim

The `using statement` means you don't have to use fully qualified class names:

    -? using concurrent
    == Actor.locals("my.value")

### Elements 

Element lines are formatted as:

```
element[#id][.class][.class] [(attributes)] [text]

div Text here           --> <div>Text here</div>
div#wombat Text here    --> <div id="wombat">Text here</div>
div.wombat Text here    --> <div class="wombat">Text here</div>
div(data-type="wombat") --> <div data-type="wombat"></div>
```

Whitespace around the attributes is optional:

```
a (href="http://www.fantomfactory.org") Fantom
a(href="http://www.fantomfactory.org") Fantom
```

Attributes may also be enclosed in square brackets. Handy when calling methods using Fantom interpolation:

```
div[data-type="${calculateWombat()}"]
```

Use all the shortcuts together:

```
div#robert.juice.media (data-on="You Tube") Rap News

<div id="robert" class="juice media" data-on="You Tube">Rap News</div>
```

### Slim Comments 

Start any line with `//` to add a slim comment.

    // This is a Slim comment

Slim comments *do not* appear in the generated html, but *do* appear in the efan template.

### HTML Comments 

Start any line with `/!` to add a HTML comment.

    /! This is a HTML comment   -->   <!-- This is a HTML comment -->

HTML comments *do* appear in the generated HTML.

### Fantom Code 

Start any line with `--` to write Fantom code. Use to call efan helper methods.

    -- echo("Hello Mum!")

Note because Slim does not have end tags, you do not specify opening or closing { curly } brackets to denote blocks of code. Due to indentation, Slim works out where they should be.

    -- if (ctx.doughnuts.isEmpty)
      | You're not a *real* policeman!
    -- else
      ul
        -- ctx.doughnuts.each |nut|
          li Mmm... ${nut.filling}!

### Fantom Eval 

Start any line with `==` to evaluate a line of Fantom code and print it out in the template

    == ctx.doughnut.filling

The resulting string is printed raw and is *not* HTML escaped.

### Plain Text 

Any line starting with a `|` denotes plain text and is printed raw. You can even embed HTML:

    | Look at how <small>BIG</small> I am!

Unlike other line types, text may flow / span multiple lines.

```
| Use the pipe character for text.
  It also lets text be spanned
  across multiple lines!
```

You can use `|` as the first character of an element. So the following:

```
p
  | More recently, I discovered
    Fantom
    a niffty pragmatic language
```

May be re-written as:

```
p | More recently, I discovered
    Fantom
    a niffty pragmatic language
```

This is handy for writing `<script>` tags:

```
script (type="text/javascript") |
  console.info("Hello...");       // note the leading 2 spaces
  console.info("     ...Pips!");  // note the leading 2 spaces
```

Note you *must* indent the text by at least 2 whitespace characters to ensure the text is inside the `|` character. Remember what you're actually writing is a condensed version of:

```
script (type="text/javascript")
 |
  console.info("Hello...");
  console.info("     ...Pips!");
```

This means that, even though it looks okay to the naked eye, indenting the script by **1 Tab will not work!**

A personal formatting preference is to use the `|` character for each line of text, prefixed with a tab. Text may then be freely mixed with elements and it all lines up nicely. Example using `>` to show tabs:

```
p>  | More recently, I discovered
>   a (href="http://fantom.org/") Fantom
>   |  a niffty pragmatic language (*)
>   | which runs on Java and .NET
```

(*) Note: the extra leading space at the start of the line prevents it from butting up against the previous `<a>` tag:

    <a href="http://fantom.org/">Fantom</a> a niffty pragmatic language --> Fantom a niffty pragmatic language

and not

    <a href="http://fantom.org/">Fantom</a>a niffty pragmatic language --> Fantoma niffty pragmatic language

### HTML Escaping 

Similar to [Fantom Str interpolation](http://fantom.org/doc/docLang/Literals.html#interpolation), you can output Fantom expressions *anywhere* in the template using the standard `${...}` notation;

    div Mmmm... ${ctx.doughnut.filling} is my favourite!

By default all text rendered via `${...}` is XML escaped. To print raw / unescaped text use `$${...}`. Backslash escape any expression to ignore it and print it as is.

To summarise:

```
.
  ${...} : XML escaped
 \${...} : ignored
 $${...} : raw / unescaped
\$${...} : ignored
```

## Layout Pattern / Nesting Templates 

Just like efan, Slim templates may be nested inside one another, effectively allowing you to componentise your templates. This is accomplished by passing body functions to the efan `render()` method and calling `renderBody()` to invoke it.

This is best explained in an example. Here we will use the *layout pattern*:

layout.slim:

```
head
  title ${ctx}
body
  == renderBody()
```

index.slim:

```
html
  == ctx.layout.render("Cranberry Whips")
    ...my cool page content...
```

Code to run the above example:

Index.fan:

```
using afSlim

class Index {
  Str renderIndex() {
    index  := Slim().compileFromFile(`index.slim` .toFile, EfanRenderer#)
    layout := Slim().compileFromFile(`layout.slim`.tofile, Str#)
    return index.render(layout)
  }
}
```

This produces an amalgamation of the two templates:

```
<html>
<head>
  <title>Cranberry Whips</title>
</head>
<body>
    ...my cool page content...
</body>
</html>
```

## HTML vs XHTML vs XML 

### HTML 

By default `Slim` renders tags as HTML5 elements; that is, all tags representing [void elements](http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements) such as `meta`, `br` and `input` are printed without an end tag:

    <input type="submit">
    <br>

Warnings are logged should a void element NOT be empty.

HTML5 documents should be served up (from a web / app server such as [BedSheet](http://www.fantomfactory.org/pods/afBedSheet)) with a MimeType of:

    text/html

While HTML is nice for browsers, this format doesn't lend itself to XML parsing; should you wish to use [Sizzle](http://www.fantomfactory.org/pods/afSizzle) for instance. So `Slim` offers alternative renderings of tag endings.

### XHTML 

By creating [Slim](http://repo.status302.com/doc/afSlim/Slim.html) with a [TagStyle](http://repo.status302.com/doc/afSlim/TagStyle.html) of `xhtml` all [void elements](http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements) are rendered as a self-closing tags. Warnings are logged should a void element NOT be empty.

    <input type="submit" />
    <br />

All non void elements are *NOT* rendered as self closing, even when empty.

    <script></script>

XHTML documents should be served up with a MimeType of:

    application/xhtml+xml

Note that Internet Explorer versions 8 and below are reported not to accept this MimeType, resulting in a download dialogue box shown to the user.

### XML 

If you create [Slim](http://repo.status302.com/doc/afSlim/Slim.html) with a [TagStyle](http://repo.status302.com/doc/afSlim/TagStyle.html) of `xml` then *ALL* empty tags are self-closing and void tags have no special meaning. Use this style when Slim is to create pure XML documents.

[Depending on usage](http://stackoverflow.com/questions/4832357/whats-the-difference-between-text-xml-vs-application-xml-for-webservice-respons) XML documents may be served up with a MimeType of either:

    text/xml
    application/xml

