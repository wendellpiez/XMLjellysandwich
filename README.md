# XMLJigsaw
Starter kit for client-side XSLT using SaxonJS

To use: try any of the XSLT stylesheets on your XML.

## Starter XSLT maker

The starterXSLT-maker.xsl stylesheet will produce an XSLT stylesheet from your XML. It can be used to transform your XML into HTML for display. While it is rough and ready, it gives you a place to start.

This XSLT will be marked XSLT v3.0 (for SaxonJS) unless you set parameter $xsl-version at runtime. Set $xsl-version to "1.0" and you get a functioning XSLT 1.0 stylesheet (yes).

This stylesheet can then be compiled for SaxonJS using SaxonEE or in (recent) oXygen XML Editor.

## Host HTML File maker
The result of stylesheet hostHTMLfile-maker.xsl is an HTML file with code in place to invoke SaxonJS on your XML.

Name your compiled transformation by assigning parameter $transform-href at runtime, or repair this value in the result.

That is, if your compiled XSLT is (will be) named XYZTransFormation.sef, ensure the result HTML has (inside a `script` element)

```
stylesheetLocation: "XYZTransformation.sef",
```

The parameter $resource_filename should similarly designate the XML file you wish to be called in. This can be either your source XML (which will be named by default) or another name: if for example you have a normalized standalone version you can name that file.

If all the glue is stuck on right, things will "just work".

See SaxonJS docs for more help on the HTML host file and how to populate it dynamically from XSLT: http://www.saxonica.com/saxon-js/documentation/

## XML Normalizer

You may wish to tweak your XML for delivery, for example to resolve entities in a "standalone" version.

A stylesheet is enclosed that can do this for you.
