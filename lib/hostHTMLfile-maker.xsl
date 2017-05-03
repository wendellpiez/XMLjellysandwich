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
        <style type="text/css" id="xmljellysandwich_css">
          <xsl:comment> Include your CSS here ... or target #xmljellysandwich_css from your XSLT ... </xsl:comment></style>
        <script type="text/javascript" language="javascript" src="lib/saxon/SaxonJS.min.js">
          <xsl:comment> parsers are so easily confused </xsl:comment>
        </script>
        <script>
          window.onload = function() {{
          SaxonJS.transform({{
            sourceLocation:     "{$resource_filename}",
            stylesheetLocation: "{$transform_href}",
            initialTemplate:    "xmljellysandwich_pack"
          }});
          }}     
        </script>
      </head>
      
      <body>
        <div id="xmljellysandwich_header">
          <h1 id="xmljellysandwich_title">
            <xsl:value-of select="$given-title"/>
            <xsl:comment><![CDATA[ target with
      <xsl:result-document href="#xmljellysandwich_title"> .... </xsl:result-document>
    ]]></xsl:comment>
          </h1>
        </div>
        
        <div id="xmljellysandwich_directory">
          <xsl:comment><![CDATA[ target with
      <xsl:result-document href="#xmljellysandwich_directory"> .... </xsl:result-document>
    ]]></xsl:comment>
        </div>
        
        <div id="xmljellysandwich_body">
          <xsl:comment><![CDATA[ target with
      <xsl:result-document href="#xmljellysandwich_body"> .... </xsl:result-document>
    ]]></xsl:comment>
        </div>
        
        <div id="xmljellysandwich_footer">
          <p>XML+XSLT under JS in the browser using <a href="http://www.saxonica.com/saxon-js/index.xml">SaxonJS</a>, from
            <a href="http://www.saxonica.com">Saxonica</a>, with help from <a href="http://github.com/wendellpiez/XMLjellysandwich">XML Jelly Sandwich</a>.</p>
        </div>
      </body>
    </html>
    
  </xsl:template>
</xsl:stylesheet>