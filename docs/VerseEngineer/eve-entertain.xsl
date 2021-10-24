<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                version="3.0"
                extension-element-prefixes="ixsl"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xpath-default-namespace="http://pellucidliterature.org/VerseEngineer"
    exclude-result-prefixes="#all">

   <xsl:import href="eve-recognizer.xsl"/>

   <!-- exposed as a top level parameter for SaxonJS but only used in template 'engineer-verse' -->
   <xsl:param name="eve-to-read" as="xs:string">ELECTRONIC VERSE ENGINEER eve-csx.xsl parameter $ eve-to-read default</xsl:param>
   
<!-- no-op template for loading makes event bindings available -->
   <xsl:template name="load_verse_engineer"/>
   
   <xsl:template match="/">
      <xsl:sequence select="pb:engineer-verse($eve-to-read)"/>
   </xsl:template>
   
   <xsl:template name="engineer-verse">
<!-- picks up text, processes it and returns it back:
         - as pretty HTML
         - as serialized EVE XML
         - a 'Save As' button pre-loaded for download
         - tbd a 'Save As TEI' option - goes in anthologizer.html
-->         
      <xsl:variable name="eve-xml" select="pb:engineer-verse($eve-to-read)"/>
      <xsl:if test="matches($eve-to-read,'\S')">
      <xsl:result-document href="#displaybox" method="ixsl:replace-content">
         <xsl:apply-templates select="$eve-xml" mode="plainhtml"/>
      </xsl:result-document>
      <xsl:variable name="filename" expand-text="true">{ $eve-xml/*/head/title/(. || '_') => normalize-space() => replace(' ','-') => encode-for-uri() }{ current-date() ! format-date(.,'[Y][M01][D01]') }.eve.xml</xsl:variable>
      <!-- add class 'ON' to turn off hiding -->
      <xsl:apply-templates select="ixsl:page()/id('evelink')" mode="show"/>         
      <xsl:result-document href="#everesults" method="ixsl:replace-content">
         <details>
            <summary>EVE XML <button onclick="offerDownload('eve-xml','{$filename}')">Save</button></summary>
            <pre id="eve-xml"><xsl:sequence select="$eve-xml => serialize()"/></pre>   
         </details>
      </xsl:result-document>
      </xsl:if>
<!--      <xsl:result-document href="#evelink" method="ixsl:replace-content">
         
      </xsl:result-document>-->
   </xsl:template>
   
   
   <xsl:template match="id('load-example')" mode="ixsl:onclick">
      <xsl:variable name="example-text-location" select="resolve-uri('stlucysday1.eve')"/>
      <ixsl:schedule-action document="{ $example-text-location }">
         <xsl:call-template name="load-eve">
            <xsl:with-param name="where" select="$example-text-location"/>
         </xsl:call-template>
      </ixsl:schedule-action>
   </xsl:template>
   
   <xsl:template match="id('clear-eve')" mode="ixsl:onclick">
      <xsl:result-document href="#displaybox" method="ixsl:replace-content"/>
      <ixsl:set-property name="value" object="id('evedata')" select="''"/>
      <xsl:result-document href="#everesults" method="ixsl:replace-content"/>
      <xsl:apply-templates select="id('evelink')" mode="hide"/>
      <ixsl:set-property name="value" object="id('linkcopy')" select="''"/>
   </xsl:template>
   
   <xsl:template name="load-eve">
      <xsl:param name="where" as="xs:anyURI" required="yes"/>
      <xsl:variable name="evetext" select="unparsed-text($where)"/>
      <ixsl:set-property name="value" object="id('evedata')" select="$evetext"/>
      <!--<xsl:result-document href="#evedata" method="ixsl:replace-content">
         <xsl:value-of select="$evetext"/>
      </xsl:result-document>-->
      <xsl:sequence select="ixsl:call(ixsl:window(),'engineerVerse',[$evetext])"/>
   </xsl:template>
   
   <xsl:import href="eve-plainhtml.xsl"/>
   
   <xsl:template match="*" mode="show">
      <ixsl:set-attribute name="class"
         select="string-join( (tokenize(@class,'\s+')[not(. eq 'hidden')]), ' ')"/>
   </xsl:template>
   
   <xsl:template match="*" mode="hide">
      <ixsl:set-attribute name="class"
         select="string-join( (tokenize(@class,'\s+')[not(. eq 'hidden')],'hidden'), ' ')"/>
   </xsl:template>
   
   
   
   
</xsl:stylesheet>
