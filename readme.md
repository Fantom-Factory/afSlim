# afSlim

`Slim` is a [Fantom](http://fantom.org/) library for generating HTML from concise, lightweight templates. Slim is based on [Jade](http://jade-lang.com/) for javascript and [Slim](http://slim-lang.com/) for Ruby.

Features include:
 - indentation driven - closing tags not needed
 - CSS shortcut notation for '#id' and '.class' attributes
 - '${...}' notation to interpolate Fantom code
 - [efan](http://www.fantomfactory.org/pods/afEfan) template generation
 - Template nesting with *Layout* pattern.
 
`ALIEN-AID:` Turn 'Slim' templates into powerful components with [efanXtra](http://www.fantomfactory.org/pods/afEfan)!



## Install

Download from [status302](http://repo.status302.com/browse/afSlim).

Or install via fanr:

    $ fanr install -r http://repo.status302.com/fanr/ afSlim

To use in a project, add a dependency in your `build.fan`:

    depends = ["sys 1.0", ..., "afSlim 1.0+"]



## Documentation

Full API & fandocs are available on the [status302 repository](http://repo.status302.com/doc/afSlim/#overview).



## Quick Start

1). Create a text file called `Example.slim`:

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

        // Embedding Javascript is easy!
        script (type="text/javascript") |
          for (var i=0; i<3; i++) {
            console.info("Greetings from Slim!");
          }

2). Create a text file called `Example.fan`:

    using afSlim

    class Example {
        Void main() {
            ctx  := ["name":"Emma"]
            html := Slim().renderFromFile(`Example.slim`.toFile, ctx)
            echo(html)
        }
    }

3). Run `Example.fan` as a Fantom script from the command line:

    C:\> fan Example.fan
    <!DOCTYPE html>
    <html>
        <head>
            <title>afSlim Example</title>
            <meta name="keywords" content="fantom html template language">
        </head>
        <body>
            <h1>Slim Example</h1>
            ...
            ...


