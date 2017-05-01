# XMLjellysandwich aka "XML Jelly Sandwich"

Starter kit for client-side XSLT using SaxonJS

(Might have named it XSLT jumpstart except for the book of that title, which looks commendable!)

To use: try any of the XSLT stylesheets on your XML.

## Components

### Starter XSLT maker

The `starterXSLT-maker.xsl` stylesheet will produce an XSLT stylesheet from your XML. It can be used to transform your XML into HTML for display. While it is rough and ready, it gives you a place to start.

This XSLT will be marked XSLT v3.0 (for SaxonJS) unless you set parameter `$xsl-version` at runtime. Set `$xsl-version` to "1.0" and you get a functioning XSLT 1.0 stylesheet (yes).

This stylesheet can then be compiled for SaxonJS using SaxonEE or in (recent) oXygen XML Editor.

### Host HTML File maker

The result of stylesheet `hostHTMLfile-maker.xsl` is an HTML file with code in place to invoke SaxonJS on your XML.

Copy this file along with the XML and SEF (compiled XSLT) files it invokes, along with the SaxonJS libraries as referenced, to a plain old web server, and you have a complete SaxonJS application.

NOTE: Your server must attribute MIME type 'application/xml' to files suffixed .sef. An .htaccess file that does this for Apache is included. 

Name your compiled transformation by assigning parameter $transform-href at runtime, or repair this value in the result.

That is, if your compiled XSLT is (will be) named XYZTransFormation.sef, ensure the result HTML has (inside a `script` element)

```
stylesheetLocation: "XYZTransformation.sef",
```

The parameter $resource_filename should similarly designate the XML file you wish to be called in. This can be either your source XML (which will be named by default) or another name: if for example you have a normalized standalone version you can name that file.

If all the glue is stuck on right, things will "just work".

See SaxonJS docs for more help on the HTML host file and how to populate it dynamically from XSLT: http://www.saxonica.com/saxon-js/documentation/

### XML Normalizer

You may wish to tweak your XML for delivery, for example to resolve entities in a "standalone" version.

A stylesheet is enclosed that can do this for you.

## Setup and run

As described in Saxonica docs, copy the SaxonJS libraries into a `/lib/saxon` subdirectory on your web server. (Or some other subdirectory.)

Copy the `.htaccess` file to your web server or otherwise configure it to serve up SEF as XML.

(Cf http://www.saxonica.com/saxon-js/documentation/#!starting/export)

Produce and adjust your HTML 'hosting' file as described above. Adjust it to match any adjustments you have made so far.

It has a few settings:

- There should be a `script[@src='lib/saxon/SaxonJS.min.js']`, or equivalent. The named Javascript file must be in the location mentioned
 
- Within a second `script` element there are settings for your source XML and your SEF (compiled XSLT) some as follows:
 
```
sourceLocation:     "{$resource_filename}",
stylesheetLocation: "{$transform_href}",
initialTemplate:    "xmljigsaw_fetch"
```

`sourceLocation` should name your XML source file. `stylesheetLocation` should name your SEF. `xmljigsaw_fetch` identifies the entry point for the stylesheet (this names a template appearing in XSLTs produced by the starter-maker). Adjust as necessary for your XSLT. You are done with the host file.

Next, produce and adjust your XSLT as described above, or develop your own. Compile it using SaxonEE into SEF format.

Optionally, produce a normalized standalone XML file to share as source data.

Copy the host file, source XML file, and compiled stylesheet (SEF) to your browser.

Point your browser to your host file and let SaxonJS do the rest.
