# XML Jelly Sandwich Demos

XML Jelly Sandwich is a library of XSLTs you can use to create XML/XSLT applications using SaxonJS. These will run in most any modern browser with Javascript.

The demonstrations, and XML Jelly Sandwich in general, are entirely dependent on SaxonJS and would hardly have been conceivable without the contributions of [Saxonica](http://saxonica.com) and [oXygen XML IDE](http://oxygenxml.com) among many others.

Each of the demonstrations listed is provided with source XSLT. The page code will show you where: if a call to SaxonJS inside an HTML page says to invoke `stylesheet: 'transform.sef'`, the stylesheet (from which the compiled `.sef` file was produced) will be there as file `transform.xsl`.

## Latest Demonstrations

These may (also) be published elsewhere but are maintained here for long-term accessibility.

* [The Versifier](Versifier/)
* [The Poem Teller](Versifier/teller.html)
* [Conway's Life - in XSLT](GameofLife/)

## Published at large

* W.B. Yeats' [Irish Airman (an SVG rendering)](http:pellucidliterature.org/IrishAirman)
* Rob't Southey's [Thalaba](http://pellucidliterature.org/Thalaba) in TEI encoding
* [Epigram Microphone](http://pausepress.net/EpigramMicrophone), by Mark Scott
* [Constitutional Convention 1787](http://pellucidliterature.org/ConstitutionalConvention), by Jim Surkamp
* [George Herbert, Love III](http://pellucidliterature.org/LoveIII), a "timed rendition" of seventeenth-century lyric poetry

The Thalaba demo calls a file in a fork of E Beshero-Bandar's [TEI Thalaba](https://github.com/ebeshero/Thalaba). Thanks Elisa!

The Constitutional Convention is as mostly restored from a 2002 SVG original produced by Jim Surkamp with the developer. It still relies on original SVG declarative animations -- YMMV on different browsers (try Firefox).

Note that while SaxonJS is a dependency for these demonstrations, the XML Jelly Sandwich XSLTS were only an expediency, not a requirement. The Jelly Sandwich utilities have simply made these easy to set up and launch.

## Also maintained in this repository

* [JATSCon presentation slides](JATSCon2017)
* [Balisage Upconversion Workshop slides](Balisage2017/workshop-slides.html)
* [Balisage Upconversion Workshop final paper](Balisage2017/workshop-paper.html)
* [Balisage SaxonJS presentation slides](Balisage2017/balisage2017-slides.html)
* [Balisage SaxonJS final paper](Balisage2017/balisage2017-final.html)

Note that the demonstrations were all made at various times using different generations of tools available in the repo. Each has subsequently undergone more or less radical configuration and rewrite.

## The code

To produce your own XML application using XSLT and SaxonJS, XML Jelly Sandwich offers XSLT you can use to produce "starter" files, which you can subsequently modify and improve. See the repo.