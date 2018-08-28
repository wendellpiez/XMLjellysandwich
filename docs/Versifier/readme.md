# Versifier

Copy the Versifier to a directory under a web browser, and it should "just work".

The Versifier comes with the Poem Teller. So try both the entry points:

(Versifier)[index.html] - (try it)[https://wendellpiez.github.io/XMLjellysandwich/Versifier/]
(Poem Teller)[teller.html] - (this too)[https://wendellpiez.github.io/XMLjellysandwich/Versifier/teller.html]

## Modding / Extending

### Step One: XML+CSS --

(a) Create new XML documents like the ones you find here, and (b) list them in the catalog. Let the Versifier run to see them in your library.

This requires that you get the syntax correct and that you use XML in familiar/anticipated ways.

Use a web developer UI especially with an inspector tool for the document model (DOM), to see (among other things) how CSS can be written along with this XML in order to extend its display "ad hoc". (Premium on diagnostic skills.)

Once you've figured out the basic tagging rules either through analysis or observation, it should be relatively easy to scale out the library, even rapidly. When you do this (as soon as you do) you may wish you had a schema. Feel free to develop one, as appropriate. (This is when it's nice to have a fork.)

To the extent that more than CSS is needed to support new/extended behaviors, see Step Two --

### Step Two: XSLT extension/rewrite

The Versifier is deployed as a SaxonJS application, under whose licensing terms, a license for the Enterprise version of Saxon (Saxon-EE) is required in order to produce its "transformation runtimes".

If you have this license, you can rewrite or add to the XSLT here for more/better everything.

This is the way to extend or rework the Versifier to do pretty much anything you like!

All the stylesheets here are pretty easy to patch for small things, emulate for similar/different things, or completely overturn.

\[Plug: The (oXygen XML Editor)[https://www.oxygenxml.com] comes with a license for SaxonEE and the SaxonJS compiler, and is available at educational rates.\]

\[SaxonJS from Saxonica: http://saxonica.com/saxon-js/index.xml see especially [licensing](http://saxonica.com/license/license.xml).\]

### Step Three

Go beyond SaxonJS, or just skip it? Should be easy enough. Rewrite the XSLT and run them on most any platform, even one at a time ... there are many, many ways this could be done ...
