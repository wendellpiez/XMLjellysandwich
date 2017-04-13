<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xs math"
  version="3.0">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  
  <xsl:param name="resource_filename" as="xs:string" select="replace(document-uri(/),'(.*/)','')"/>
  <xsl:param name="transform_href"    as="xs:string">transform.sef</xsl:param>

  <xsl:param name="given-title" select="/descendant::*:title[1]"/>
  
  <xsl:template match="/" expand-text="yes">
 
    <html>
       <head>
        <title>{$given-title}</title>
        <meta charset="utf-8"/>
        <!--<link rel="stylesheet" href="books.css" type="text/css">-->
        <style type="text/css" id="xmljigsaw_css">
          <xsl:comment> Include your CSS here ... or target #xmljigsaw_css from your XSLT ... </xsl:comment></style>
        <script type="text/javascript" language="javascript" src="lib/saxon/SaxonJS.min.js">
          <xsl:comment> parsers are so easily confused </xsl:comment>
        </script>
        <script>
          window.onload = function() {{
          SaxonJS.transform({{
            sourceLocation:     "{$resource_filename}",
            stylesheetLocation: "{$transform_href}",
            initialTemplate:    "xmljigsaw_fetch"
          }});
          }}     
        </script>
      </head>
      
      <body>
        <div id="xmljigsaw_header">
          <h1 id="xmljigsaw_title">
            <xsl:value-of select="$given-title"/>
            <xsl:comment><![CDATA[ target with
      <xsl:result-document href="#xmljigsaw_title"> .... </xsl:result-document>
    ]]></xsl:comment>
          </h1>
        </div>
        
        <div id="xmljigsaw_directory">
          <xsl:comment><![CDATA[ target with
      <xsl:result-document href="#xmljigsaw_directory"> .... </xsl:result-document>
    ]]></xsl:comment>
        </div>
        
        <div id="xmljigsaw_body">
          <xsl:comment><![CDATA[ target with
      <xsl:result-document href="#xmljigsaw_body"> .... </xsl:result-document>
    ]]></xsl:comment>
        </div>
        
        <div id="xmljigsaw_footer">
          <p>XML+XSLT under JS in the browser using <a href="http://www.saxonica.com/saxon-js/index.xml">SaxonJS</a>, from
            <a href="http://www.saxonica.com">Saxonica</a>, with help from <a href="http://github.com/wendellpiez/xmlJigsaw">XML Jigsaw</a>.</p>
        </div>
      </body>
    </html>
    
  </xsl:template>
</xsl:stylesheet>