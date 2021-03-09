
# SaxonJS OSCAL applications

OSCAL is the Open Security Controls Assessment Language.

Possible applications (tbd):

- Metaschema-driven validation
- Validation to local rules set (e.g. profile integrity vis a vis catalog)
- profile resolution (save)
- profile resolution (display)
- XML|JSON conversion
  - wrap fn:transform() dynamically per document type?

- Preview
  - Catalog?
  - SSP?

# Security posture of SaxonJS applications:

*  No client data is moved off the client system or uploaded (anywhere)
* No cookies are placed on the system; state is maintained *only* for the runtime
* Runtime code is all downloaded and (once cached) can be run off line
* Distributed from a plain generic web server delivering HTML, XML, Javascript and JSON (SEF)
  * Can be run as localhost or on a local network/VPN
  * Nothing is installed it is all static files to be served
  * A single client is served the resources only on request and never remembers clients
      (though they are free to cache the resources for future runtimes)
  * Referenced resources are all determinable (subject to design of UIs) and traceable
* Code is auditable
  * SEF is machine-generated JSON produced by 'compiling' XSLT
  * Original XSLT sources are also public
  * Executed transformations originate as W3C compliant XSLT
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
