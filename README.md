# XMLjellysandwich aka "XML Jelly Sandwich"

Starter kit for client-side XSLT using SaxonJS

(Might have named it XSLT jumpstart except for the book of that title, which looks commendable!)

To use: try any of the XSLT stylesheets on your XML.

## Setup and run

You have XML and you wish to style it in the browser with XSLT.

### Initial (web setup)

As described in Saxonica docs, copy the SaxonJS libraries into a `/lib/saxon` subdirectory on your web server. (Or some other subdirectory.) Here is the v1.0 download: http://www.saxonica.com/saxon-js/download/Saxon-JS-1.0.0.zip.

Copy the `.htaccess` file to your web server or otherwise configure it to serve up SEF as XML.

(Cf http://www.saxonica.com/saxon-js/documentation/#!starting/export)

### For the XML

Produce and adjust your HTML 'hosting' file, either by hand (copy/alter) or by using the XSLT as described below. Adjust it to match your settings.

It has a few control points:

- There should be a `script[@src='lib/saxon/SaxonJS.min.js']`, or equivalent. The named Javascript file must be in the location mentioned
 
- Within a second `script` element there are settings for your source XML and your SEF (compiled XSLT) some as follows:
 
```
sourceLocation:     "{$resource_filename}",
stylesheetLocation: "{$transform_href}",
initialTemplate:    "xmljellysandwich_fetch"
```

`sourceLocation` should name the XML file you plan to deliver. `stylesheetLocation` should name your SEF. `xmljellysandwich_fetch` identifies the entry point for the stylesheet (this names a template appearing in XSLTs produced by the starter-maker). Adjust as necessary for your XSLT. You are done with the host file. (You can come back.)

Next, produce and adjust your XSLT as described below, or develop your own. Compile it using SaxonEE into SEF format.

Optionally, produce a normalized standalone XML file to share as source data.

Copy the host file, 'resource' XML file, and compiled stylesheet (SEF) to your web site.

Point your browser to your host file on the web site and let SaxonJS do the rest.


## Components

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

If all the glue is stuck on right, things will "just work".

See SaxonJS docs for more help on the HTML host file and how to populate it dynamically from XSLT: http://www.saxonica.com/saxon-js/documentation/

### XML Normalizer

You may wish to tweak your XML for delivery, for example to resolve entities in a "standalone" version.

A stylesheet is enclosed that can do this for you.

This stylesheet is also a natural place to provide for any whitespace normalization or other adjustments to the XML you will serve up.

