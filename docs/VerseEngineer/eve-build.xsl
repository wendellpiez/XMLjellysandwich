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

   <!-- exposed as a top level parameter for SaxonJS but only used in template 'engineer-verse' -->
   <xsl:param name="eve-to-read" as="xs:string">&lt;EVE/></xsl:param>
   
<!-- no-op template for loading makes event bindings available -->
   <xsl:template name="load_verse_engineer"/>
   
   <xsl:variable name="indented-xml" as="element()">
      <output:serialization-parameters
         xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
         <output:indent value="true"/>
         <output:omit-xml-declaration value="true"/>
      </output:serialization-parameters>
   </xsl:variable>
   
   <xsl:template match="/">
      <xsl:apply-templates mode="eve-display"/>
      <!--<xsl:apply-templates mode="eve-tei"/>-->
      <!--<xsl:apply-templates mode="eve-bits"/>-->
   </xsl:template>
   
   <xsl:template name="acquire-TEI">
      <!--Entry point reads the page and writes TEI into a pre for display
      waking up a button enabling user download-->
   </xsl:template>
   
   <xsl:template name="acquire-BITS">
      <!--Entry point reads the page and writes BITS into a pre for display
      waking up a button enabling user download-->
   </xsl:template>
   
   <xsl:template name="acquire-HTML">
      <!--Entry point reads the page and writes full-page (X)HTML literal (escaped?) into a pre for display
      waking up a button enabling user download-->
   </xsl:template>
   
   
   <xsl:template name="add-eve">
     <xsl:result-document href="#eve-collection" method="ixsl:append-content">
            <xsl:apply-templates select="/" mode="plainhtml"/>
         </xsl:result-document>
         
   </xsl:template>
   
   <xsl:import href="eve-plainhtml.xsl"/>
   
   <xsl:template match="EVE" mode="plainhtml">
      <section class="EVE">
         <xsl:apply-templates mode="#current"/>
      </section>
   </xsl:template>
   
   <!--<xsl:template match="id('load-example')" mode="ixsl:onclick">
      <xsl:variable name="example-text-location" select="resolve-uri('stlucysday1.eve')"/>
      <ixsl:schedule-action document="{ $example-text-location }">
         <xsl:call-template name="load-eve">
            <xsl:with-param name="where" select="$example-text-location"/>
         </xsl:call-template>
      </ixsl:schedule-action>
   </xsl:template>-->
   
   <xsl:template match="id('clear-eve')" mode="ixsl:onclick">
      <ixsl:set-property name="value" object="id('evefileset')" select="()"/>
      <xsl:result-document href="#eve-collection" method="ixsl:replace-content"/>
   </xsl:template>
   
   
   
   
</xsl:stylesheet>
