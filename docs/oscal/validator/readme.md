
# hints

See the OSCAL Catalog Validator (or Metaschema Emulator) run [here](catalog.html)

These notes are for maintenance.

## produce updated composed metaschema

This presently can't be done under SaxonJS due to no support for external parsed entities (a current requirement).

But runs fine under Saxon in Java, etc. It invoked code from the OSCAL Metaschema repository[OSCAL Metaschema repository](https://github.com/usnistgov/metaschema) to compose a single metaschema entity from its modules. Run it like this (in this case to produce a validator for the catalog format):

```
$ xslt3 -s:https://raw.githubusercontent.com/usnistgov/OSCAL/master/src/metaschema/oscal_catalog_metaschema.xml -xsl:https://raw.githubusercontent.com/usnistgov/metaschema/master/toolchains/xslt-M4/nist-metaschema-COMPOSE.xsl -o:generators/oscal_catalog_metaschema-COMPOSED.xml          
```

## update validator from metaschema

For example, for the OSCAL catalog:

```
$ xslt3 -s:generators/oscal_catalog_metaschema-COMPOSED.xml -xsl:generators/generate-validator.xsl -o:catalog-validate-new.xsl
```

## compile for SaxonJS

Likewise --

```
$ xslt3 -export:apply-validator.sef.json -xsl:apply-validator.xsl -nogo
```


