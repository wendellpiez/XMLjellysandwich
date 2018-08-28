# XML Jelly Sandwich

Starter kit for XSLT 3.0 in the browser using SaxonJS

(Might have named it "XSLT Jump Start" except for the excellent book of that title, or XML Jigsaw, except that too is taken. Jelly sandwiches are simple to make, tasty, nutritious, and portable.)

To see examples: http://wendellpiez.github.io/XMLjellysandwich

Also, a couple of demonstration applications here can be used as starter frameworks for XML/CSS editing (no XSLT required). See the docs for more on that.

To use: try any of the XSLT stylesheets on your XML. Its result will be either an HTML file, an XSLT stylesheet (which happens to match elements in your source XML), or a normalized XML copy of your input, depending on the stylesheet. Assemble the results of these (several) transformations, make your adjustments, compile the stylesheet, and you have a complete application you can park on a web server. (More details below.)

SaxonJS is documented here: http://www.saxonica.com/saxon-js/documentation/index.html

## To set up and run

You have XML and you wish to style it in the browser with XSLT.

### Initial (web site/server) setup

If you wish to publish on your own localhost or must set up a server for any reason ...

As described in Saxonica docs, copy the SaxonJS libraries into a `/lib/saxon` subdirectory on your web server. (Or some other subdirectory.) Here is the v1.0 download: http://www.saxonica.com/saxon-js/download/Saxon-JS-1.0.0.zip.

Just in case, copy the `.htaccess` file to your web server or otherwise configure it to serve up SEF as XML.

(Cf http://www.saxonica.com/saxon-js/documentation/#!starting/export)

Alternatively, skip all this and simply run off a plain vanilla web site from a commercial provider. Even works under Github Pages.

### Runtime resources

You have XML or know how to produce it. And you've copied the libraries.

Once you have XML, making it available via SaxonJS entails:

* A harness or "host" file (landing page) where a browser can find what it needs
* XSLT written to process your XML, compiled into SEF
* Your XML source data (this file or a syntax-normalized copy

Check out the Saxon docs as always for more background / guidance.

#### 'hosting' (HTML) page

Produce and adjust your HTML 'hosting' file, either by hand (copy/alter) or by using the XSLT as described below. Adjust it to match your settings.

It has a few control points:

- There should be a `script[@src='lib/saxon/SaxonJS.min.js']`, or equivalent. The named Javascript file must be in the location mentioned

```
<script type="text/javascript"
        src="../lib/saxon/SaxonJS.min.js"><!-- cosmetic comment --></script>
```

- Within a second `script` element there are settings for your source XML and your SEF (compiled XSLT) some as follows:


```
<script>
    window.onload = function() {
    SaxonJS.transform({
        sourceLocation:     "{$resource_filename}",
        stylesheetLocation: "{$transform_href}",
        initialTemplate:    "xmljellysandwich_pack"
    });
    }     
</script>
```


`$resource_filename` should name the XML file you plan to deliver. `transform_href` should point to your your SEF. `xmljellysandwich_pack` identifies the entry point for the stylesheet (this names a template appearing in XSLTs produced by the starter-maker, but your XSLT could offer its own entry points). Adjust as necessary for your XSLT. You are done with the host file. (You can come back.)

These and many other runtime options for SaxonJS are documented at http://www.saxonica.com/saxon-js/documentation/index.html#!api/transform.

See examples of hosting pages in any of the projects in `docs`. A hosting file can be named `index.html` if you like.

#### XSLT compiled into SEF

You may already have XSLT that is capable of performing the necessary transformations on the XML to render and present it in the browser. (Presumably it specifies a tranformation from an XML language or dialect, into HTML/CSS or perhaps SVG/CSS; in any case its target notation is browser-digestible.) Or you may write this yourself. Or you can produce a functional "starter" XSLT using the utility as described below, getting something "good enough to improve" without having to start from scratch.

In any case, you will need to compile the XSLT for SaxonJS or have it compiled, into Saxon's SEF notation (an XML application that configures an XSLT runtime.) You will need a licensed copy of Saxon or of a toolkit that contains it (such as oXygen XMl Editor/Developer) to do this.

Again, all the projects in `docs` have XSLT files (at various stages of finish, with apologies) along with SEF files produced from them (for SaxonJS to deliver).

##### XML source data

Optionally, produce a normalized standalone XML file to share as source data.

Note that the demonstrations show different kinds of source data. The Balisage examples are in a flavor of Docbook. The JATSCon example uses JATS. The Irish Airman example uses a bespoke homemade XML just for this little project. Other examples have their own markup formats including BITS (JATS for books) and TEI.

### Give it a run

Point your browser to your host file on the web site.
 
If all resources are copied to a web site and links configured in the host file, are resolving correctly, SaxonJS should do the rest. This works on a local host or on the open web. After a client has a copy of the Javascript processor, it doesn't need a second copy (i.e. the library can be cached). Transformation time, of course, depends on your XML and what the XSLT is being asked to do with it.

Of particular interest to developers is not only that this is end-to-end XML pipelining in the client, but also how the user interface in the displayed page (HTML/SVG) are now programmable with XSLT.

## XML Jelly Sandwich Components

### Starter XSLT maker

The `starterXSLT-maker.xsl` stylesheet will produce an XSLT stylesheet from your XML. The XSLT it produces can be used to transform your XML into HTML for display. While it is rough and ready, this stylesheet gives you a place to start: by default, it shows where elements are matched only by default (making these easy to find and adjust), while it also contains a mess of templates and CSS ready for activation and extension.

(Hint: take any template marked with mode "asleep", and remove the mode to "wake it up".)

Your starter XSLT will be marked XSLT v3.0 (for SaxonJS) unless you set parameter `$xsl-version` at runtime. Set `$xsl-version` to "1.0" and you get a functioning XSLT 1.0 stylesheet (yes).

Note that before it will work in SaxonJS, this stylesheet must be compiled using a recent SaxonEE (9.7 or later) for example in oXygen XML Editor.

### Host HTML File maker

The result of stylesheet `hostHTMLfile-maker.xsl` is an HTML file with code in place to invoke SaxonJS on your XML.

Copy this file along with the XML and SEF (compiled XSLT) files it invokes, along with the SaxonJS libraries as referenced, to a plain old web server, and you have a complete SaxonJS application.

NOTE: For a receiving browser to be able to sort things out, your server must attribute MIME type 'application/xml' to files suffixed `.sef.` An `.htaccess` file that does this for Apache is included in this distribution. If you are unable to bind the mime type to `.sef` for any reason, a workaround is to name these files `.xml` (and to reference the file as such e.g. `stylesheetLocation: 'myXSLT.sef.xml'`).

Assign this name your compiled transformation by assigning parameter `$transform-href` at runtime, or repair this value in the resulting html file.

That is, if your compiled XSLT is (will be) named `XYZTransFormation.sef`, ensure the result HTML has (inside a `script` element)

```
stylesheetLocation: "XYZTransformation.sef",
```

The parameter `$resource_filename` should similarly designate the XML file you wish to be called in. This can be either your source XML (which will be named by default) or another name: if for example you have a normalized standalone version, you can name that file as your XML source file.

As soon as you have the pieces aligned and glued together correctly, they will "just work". A host file can be complex, and can offer multiple locations where contents may be acquired dynamically (that is, written and rewritten by the transformation engine).

See SaxonJS docs for more help on the HTML host file and how to populate it dynamically from XSLT: http://www.saxonica.com/saxon-js/documentation/

### XML Normalizer

You may wish to tweak your XML for delivery, for example to resolve entities in a "standalone" version.

A stylesheet is enclosed that can do this for you.

This stylesheet is also a natural place to provide for any whitespace normalization or other adjustments to the XML you will serve up.

