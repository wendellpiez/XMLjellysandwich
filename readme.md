# XML Jelly Sandwich

Starter kit for XSLT 3.0 in the browser using SaxonJS

(Might have named it "XSLT Jump Start" except for the excellent book of that title, or XML Jigsaw, except that too is taken. Jelly sandwiches are simple to make, tasty, nutritious, and portable, and go fine with butter or cheese. Plus an XMLjellysandwich fits neatly into an XMLLunchbox, also in this repository.)

## Summary:

In `/docs`, find example demonstrations, viewable through Github Pages at http://wendellpiez.github.io/XMLjellysandwich. A couple of these demonstrations serve as lightweight but complete publishing frameworks; others are designed to show some specialized functionality. Each demonstration has its own entry page or pages, source document(s) and transformation(s). Source code for everything is viewable. 

In `/lib`, find XSLTs for making your own (starter) application, operating on your own XML. See further instructions below.

## SaxonJS notices

SaxonJS is documented here: http://www.saxonica.com/saxon-js/documentation/index.html

Here are the copyright notice and disclaimer that appear with the public license of Saxon-JS (take notice if you fork):

> Software: This license applies to the packages "xslt3" and "saxon-js" distributed via npm (https://www.npmjs.com) and to the modules SaxonJS2.js and SaxonJS2.rt.js available for download from the Saxonica web site (https://www.saxonica.com/).
>
> Copyright: The copyright in the Software belongs to Saxonica Ltd, except for third-party components listed in the documentation that are distributed under license.
>
> ...
>
> DISCLAIMER. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS." ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Additional note: Although Saxon-JS libraries are available on this site -- which is designed for maximum transparency -- they are presented for *demonstration only*. When building your own Saxon-JS applications you should not rely on the currency or availability of copies found here, instead maintaining your copies of up-to-date distributable sources from Saxonica.

Apart from Saxon-JS and similar dependencies as noted, all software on this site is free to borrow, study, use and adapt for any purpose.

## To set up and run

You have XML and you wish to style it in the browser with XSLT.

### Initial (web site/server) setup

If you wish to publish on your own localhost or must set up a server for any reason ...

As described in Saxonica docs, copy the SaxonJS libraries into a `/lib/saxon` subdirectory on your web server. (Or some other subdirectory.) Here is the v2.2 download: http://www.saxonica.com/saxon-js/download/Saxon-JS-2.2.zip.

Just in case, copy the `.htaccess` file to your web server or otherwise configure it to serve up SEF as XML.

(Cf http://www.saxonica.com/saxon-js/documentation/#!starting/export)

Alternatively, skip all this and simply run off a plain vanilla web site from a commercial provider. The applications work fine delivered directly from a git repository by Github Pages.

### Runtime resources

You have XML or know how to produce it. And you've copied the libraries.

Once you have XML, making it available via SaxonJS entails:

* A harness or "host" file (landing page) where a browser can find what it needs
* XSLT written to process your XML, compiled into SEF
* Your XML source data (this file or a syntax-normalized copy

Check out the Saxon docs as always for more background / guidance.

#### ‘hosting’ (HTML) page

The HTML (or XHTML) ‘hosting’ file is the landing page that is loaded into the user’s browser to kick everything else off. You can create one by copying and then altering any one of the `index.html` files from one of the `docs/*/` directories of this repository, or by using the “starter maker” XSLT program described [below](#starter-xslt-maker).

Either way, the ‘hosting’ HTML page needs a few control points:

- There should be a `script[@src='lib/saxon/SaxonJS.min.js']`, or equivalent. The named Javascript file must be in the location mentioned

```
<script type="text/javascript"
        src="../lib/saxon/SaxonJS.min.js"><!-- cosmetic comment --></script>
```

- Within a second `script` element the SaxonJS.transform() function should be set up with settings for your source XML and your SEF (compiled XSLT).  In the example below `{$resource_filename}` should give the path to the XML file you plan to deliver, relative to the hosting page. The `{$transform_href}` should point to your your SEF, also from the hosting page. The `{$xmljellysandwich_pack}` identifies the entry point for the stylesheet (this names a template appearing in XSLTs produced by the starter-maker, but your XSLT could offer its own entry points). Adjust as necessary for your XSLT.

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

 - Either on the `<body>` element of the HTML, or somewhere inside it, make sure to put in a dummy element that has an `@id` attribute. This dummy element will be replaced with whatever the SEFed stylesheet writes to that ID using `<xsl:result-document>`. The `hostHTMLfile-maker.xsl` program (described [below](#host-html-file-maker)) uses the IDs “header”, “directory”, “body”, and “footer”, each prefixed with “xmljellysandwich_”.  These dummy elements (which could be just one element, the entire `<body>`, if you like) will be replaced by a `<xsl:result-document>` instruction in the XSLT-turned-SEF.”.

Note that these and many other runtime options for SaxonJS are documented at http://www.saxonica.com/saxon-js/documentation/index.html#!api/transform.

A hosting file can be named `index.html` if you like.

#### XSLT compiled into SEF

You may already have XSLT that is capable of performing the necessary transformations on the XML to render and present it in the browser. (Presumably it specifies a tranformation from an XML language or dialect, into HTML/CSS or perhaps SVG/CSS; in any case its target format is browser-digestible.) Or you may write this yourself. Or you can produce a functional "starter" XSLT using the utility as described below, getting something "good enough to improve" without having to start from scratch.

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

