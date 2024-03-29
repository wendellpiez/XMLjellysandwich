
# SaxonJS OSCAL applications

OSCAL is the Open Security Controls Assessment Language.

For *examples* of XML documents designed to showcase functionalities of the OSCAL applications, download and unzip the file [oscal-examples.zip](oscal-examples.zip "oscal-examples.zip")

## Current applications:

* [Baseline matrix](baseline-matrix) - paints your OSCAL profile's coverage of 800-53 control families, following look/feel of the official NIST publication (SP800-53B).
* [Import examiner](import-examiner) - validates your OSCAL profile's imports against known public baselines
* [Baseline Reviewer](baseline-reviewer) - presents controls from the SP 800-53 catalog, marked for selection by an OSCAL profile (selected or loaded by the user)
* [Catalog Validator](validator/catalog.html) - tag validation of OSCAL catalog contents, emulating schema validation
* (experimental!) [XML to JSON](format-converter/convert-xml2json.html) and [JSON to XML](format-converter/convert-json2xml.html) OSCAL catalog converters (demonstrations / PoC of this conversion in a browser)
 
## Further applications (tbd):

- "Control landscape" Catalog mapper - use D3 (bubbles) also CSS to present summary/snapshot views
- Unresolved profile analytical display
  - rendered view of unresolved profile
  - shows selections, modifications, remarks
  - errors for broken links etc.
- profile resolution (display)
- XML - JSON conversion
  - wrap fn:transform() dynamically per document type?
- Preview
  - Catalog?
  - SSP?
- spreadsheet to OSCAL profile converter
  - reads (zip) and permits mappings from grid into values?
  - or, reads an exported file

# Security posture of SaxonJS applications:

* No client data is moved off the client system or uploaded (anywhere)
* No cookies are placed on the system; state is maintained only for the runtime
* Runtime code is all downloaded and (once cached) can be run off line
* Distributed from a plain generic web server delivering HTML, XML, Javascript and JSON (SEF)
* Code is auditable
  * SEF is machine-generated JSON produced by 'compiling' XSLT
  * Original XSLT sources are also public
  * Executed transformations originate as W3C-compliant XSLT
    * in principle, this makes all these capabilities also portable to other XSLT processors
    * also, open source and declarative
* Architecture is documented:
  * Browser parses HTML file that loads resources
    * SaxonJS
    * SEF (templates)
    * catalog(s) from server
  * Initial transformation over base catalog is rendered with UI
  * The user loads a file from the system into the browser
    * Page is refreshed with rendered outputs from processing this input through template set for viewer to inspect
  * Nothing is saved (a user would have to take a screenshot or scrape contents)
