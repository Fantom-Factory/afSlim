# afSlim

afSlim is a [Fantom](http://fantom.org/) library for generating HTML from concise, lightweight templates. 'afSlim' is based on [Jade](http://jade-lang.com/) for javascript and [Slim](http://slim-lang.com/) for Ruby.



## Quick Start

    doctype html
    html
      head
     title afSlim Example
     meta name="keywords" content="fantom html template language"

      body
     h1 Slim Example

     h2 Element shortcut notation:

       div#slimer This div has an ID of 'slimer'
       div.wombat This div has a class of 'wombat'
       div (style="color: red;") Attributes are specified in brackets

     | Use the pipe character for text.
       It also lets text be spanned
       across multiple lines!

     // This is a Slim comment

     /! This is a HTML comment

     | Use -- to execute Fantom code
     -- echo("Hello Pips!")

     | Use == to print the result of a fantom expression
     == "Hello " + ctx["name"] + "!"

     // Use $(...) notation to embed Fantom expressions
     | Hello ${ctx["name"]}!

     // Use the | char for javascript snippets
     script (type="text/javascript") |
       for (var i=0; i<3; i++) {
         console.info("Greetings from Slim!");
       }



## Documentation

Full API & fandocs are available on the [status302 repository](http://repo.status302.com/doc/afSlim/#overview).



## Install

Download from [status302](http://repo.status302.com/browse/afSlim).

Or install via fanr:

    $ fanr install -r http://repo.status302.com/fanr/ afSlim

To use in a project, add it as a dependency in your `build.fan`:

    depends = ["sys 1.0", ..., "afSlim 0+"]

    