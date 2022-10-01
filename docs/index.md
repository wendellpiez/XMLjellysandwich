# XML Jelly Sandwich Demos

## Update Sep 2022

Students of XSLT may be interested in a NIST project newly underway, [XSLT Blender](https://pages.nist.gov/xslt-blender) (for the demo, with link to repository). XSLT 1.0 still punching above its weight.

### Rights

Also, by popular demand, an [MIT License](https://github.com/wendellpiez/XMLjellysandwich/blob/master/LICENSE.md) now explicitly grants permission for reuse of software developed on this site.

With respect to interpretive works herein, or parts of works with design aspects such as page layout or interfaces, please consider them copyright by the author.

## Update Nov 2021

OSCAL demonstrations (originally developed for Balisage 2021) are now at [an official home](https://pages.nist.gov/oscal-tools/demos/csx/).

Quick links - served from this site:

* [Docuscope](docuscope/) - load and examine your XML document
* [EVE](VerseEngineer/) - the Electronic Verse Engineer
  * [create (and save)](VerseEngineer/) your EVE XML
  * [collect](VerseEngineer/anthologizer) your EVE XML
* [Cast I Ching](IChing/)
* [Isn't it a clock?](ApresMagritte/)
* [The Versifier](Versifier/)
* [The Poem Teller](Versifier/teller.html)
* [Conway's Life - in XSLT](GameofLife/)

These and additional demonstrations are described below.

## Ideas / tbd

- Put JellySandwich itself into SaxonJS to produce the XSLT for an XML? dynamic execution? (but see [XSLT Fiddle](https://martin-honnen.github.io/xslt3fiddle/) )
- Various EVE ideas
  - BITS or TEI conversion
  - Load EVE into editor
    - EVE XML -> EVE.txt serializer 

## The code

To produce your own XML application using XSLT and SaxonJS, XML Jelly Sandwich offers XSLT you can use to produce "starter" files, which you can subsequently modify and improve. See the repo.

All these demonstrations are meant to show what can be done with XSLT in the browser (client-side XSLT or CSX) and to provide a jump start to devs working on similar problems.

## EVE: the ELECTRONIC VERSE ENGINEER

This application permits creation of lightweight XML with local save for persistence, specifically oriented to structured (lineated) verse in the Western tradition (left-to-right top-to-bottom with defined conventions for line endings and indents). Transcribing Poe or Wordsworth? Markdown for versifiers!

- Create your EVE: https://wendellpiez.github.io/XMLjellysandwich/VerseEngineer/
- Collect your EVE: https://wendellpiez.github.io/XMLjellysandwich/VerseEngineer/anthologizer.html

## Balisage 2021 Demonstrations

For *examples* of XML documents designed to showcase functionalities of the OSCAL applications, download and unzip the file [oscal/oscal-examples.zip](oscal/oscal-examples.zip)

Note that the OSCAL demos now link to the sites where they are maintained:

* [Docuscope](docuscope/)
* [OSCAL Baseline Matrix](https://pages.nist.gov/oscal-tools/demos/csx/baseline-matrix/) - now at NIST!
* [OSCAL Profile Import Examiner](https://pages.nist.gov/oscal-tools/demos/csx/import-examiner/) - now at NIST!
* [OSCAL Metaschema Emulator](https://pages.nist.gov/oscal-tools/demos/csx/validator/) - now at NIST!

## What this is

XML Jelly Sandwich is a library of XSLTs you can use to create XML/XSLT applications using SaxonJS. These will run in most any modern browser with Javascript.

The demonstrations, and XML Jelly Sandwich in general, are entirely dependent on SaxonJS and would hardly have been conceivable without the contributions of [Saxonica](http://saxonica.com) and [oXygen XML IDE](http://oxygenxml.com) among many others.

Each of the demonstrations listed is provided with source XSLT. The page code will show you where: if a call to SaxonJS inside an HTML page says to invoke `stylesheet: 'transform.sef'`, the stylesheet (from which the compiled `.sef` file was produced) will be there as file `transform.xsl`.

They have been made at various times to different versions of Saxon-JS, which continues to improve, so your mileage may vary. *Apologies in advance* if a page fails to load, and please feel free to report bugs via Issues in the Github repository.

> Additional note: Although Saxon-JS libraries are available on this site -- which is designed for maximum transparency -- they are presented for *demonstration only*. When building your own Saxon-JS applications you should not rely on the currency or availability of copies found here, instead maintaining your copies of up-to-date distributable sources from Saxonica.

## Latest Demonstrations (2019ish)

These may (also) be published elsewhere but are maintained here for long-term accessibility.

* [Isn't it a clock?](ApresMagritte/)
* [Cast I Ching](IChing/)
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
