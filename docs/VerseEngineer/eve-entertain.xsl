<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:eve="http://pellucidliterature.org/VerseEngineer"
                version="3.0"
                extension-element-prefixes="ixsl"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xpath-default-namespace="http://pellucidliterature.org/VerseEngineer"
    exclude-result-prefixes="#all">

   <xsl:strip-space elements="*"/>
   
   <xsl:preserve-space elements="p line attrib b i"/>
   
   <!-- Parsing logic -->
   <xsl:import href="eve-recognizer.xsl"/>
   
   <!-- Serialization logic -->
   <xsl:import href="eve-writer.xsl"/>
   
   <!-- exposed as a top level parameter for SaxonJS but only used in template 'engineer-verse' -->
   
   <!-- it can be either EVE XML, or plain text to be read for EVE -->
   <xsl:param name="eve-to-read" as="xs:string">ELECTRONIC VERSE ENGINEER eve-csx.xsl parameter $ eve-to-read default</xsl:param>
   
<!-- no-op template for loading makes event bindings available -->
   <xsl:template name="load_verse_engineer"/>
   
   <xsl:template match="/">
      <xsl:sequence select="eve:engineer-verse($eve-to-read)"/>
   </xsl:template>
   
   <xsl:template name="engineer-verse">
      <xsl:param name="eve-xml" select="eve:engineer-verse($eve-to-read)"/>
      <!-- picks up text, processes it and returns it back:
         - as pretty HTML
         - as serialized EVE XML
         - a 'Save As' button pre-loaded for download
         - tbd a 'Save As TEI' option - goes in anthologizer.html
-->
           <xsl:result-document href="#displaybox" method="ixsl:replace-content">
            <xsl:apply-templates select="$eve-xml" mode="plainhtml"/>
         </xsl:result-document>
         <xsl:variable name="filename" expand-text="true">{ $eve-xml/*/head/title/(. || '_') =>
            normalize-space() => replace(' ','-') => encode-for-uri() }{ current-date() !
            format-date(.,'[Y][M01][D01]') }.eve.xml</xsl:variable>
         <!-- add class 'ON' to turn off hiding -->
         <xsl:apply-templates select="ixsl:page()/id('evelink')" mode="show"/>
         <xsl:result-document href="#everesults" method="ixsl:replace-content">
            <details>
               <summary>EVE XML <button onclick="offerDownload('eve-xml','{$filename}')"
                  >Save</button></summary>
               <pre id="eve-xml">
               <xsl:variable name="css-pi">
               <xsl:processing-instruction name="xml-stylesheet">type="text/css" href="eve-xml.css"</xsl:processing-instruction>
                  </xsl:variable>
               <xsl:sequence select="$css-pi[exists($eve-xml/*)] => serialize()"/>
               <xsl:text>&#xA;</xsl:text>
               <xsl:sequence select="$eve-xml => serialize()"/></pre>
            </details>
         </xsl:result-document>
      
   </xsl:template>
   
   <!-- entry point for EVE loaded as a file - tries to parse as XML, reads it as EVE otherwise -->
   <xsl:template name="load-verse">
      <xsl:if test="matches($eve-to-read, '\S')">
         <xsl:variable name="input-xml">
            <xsl:try select="parse-xml($eve-to-read)">
               <xsl:catch select="eve:engineer-verse($eve-to-read)"/>
            </xsl:try>
         </xsl:variable>
         <xsl:variable name="eve-xml">
            <xsl:apply-templates select="$input-xml" mode="insulate-xml"/>
         </xsl:variable>

         <xsl:call-template name="engineer-verse">
            <xsl:with-param name="eve-xml" select="$eve-xml"/>
         </xsl:call-template>
         <xsl:variable name="eve-syntax">
            <xsl:apply-templates select="$eve-xml" mode="eve:write-eve"/>
         </xsl:variable>
         <ixsl:set-property name="value" object="id('evedata',ixsl:page())" select="string($eve-syntax)"/>
      </xsl:if>
   </xsl:template>
   
   
   <!-- 'insulate-xml' mode intercepts any XML not recognized as (close enough) to EVE -->
   <xsl:mode name="insulate-xml" on-no-match="shallow-copy"/>
   
   <xsl:template mode="insulate-xml" match="processing-instruction()"/>
   
   <!-- Nothing gets through unless it matches the template after this one. -->
   <xsl:template mode="insulate-xml" match="/*"/>
   
   <xsl:template priority="101" mode="insulate-xml" match="/EVE">
      <xsl:copy>
         <xsl:apply-templates mode="#current"/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="id('load-example')" mode="ixsl:onclick">
      <xsl:variable name="example-text-location" select="resolve-uri('illustration.eve')"/>
      <ixsl:schedule-action document="{ $example-text-location }">
         <xsl:call-template name="load-eve">
            <xsl:with-param name="evetext" select="unparsed-text($example-text-location)"/>
         </xsl:call-template>
      </ixsl:schedule-action>
   </xsl:template>
   
   <xsl:template match="id('clear-eve')" mode="ixsl:onclick">
      <xsl:result-document href="#displaybox" method="ixsl:replace-content"/>
      <ixsl:set-property name="value" object="id('evedata')" select="''"/>
      <xsl:result-document href="#everesults" method="ixsl:replace-content"/>
      <xsl:apply-templates select="id('evelink')" mode="hide"/>
      <ixsl:set-property name="value" object="id('linkcopy')" select="''"/>
      <!-- We can't rewire the files object but we can replace it with an empty one - -->
      <xsl:result-document href="#loadfile-button" method="ixsl:replace-content">
         <input type="file" id="load-file" name="load-file" title="Load file"
            onchange="dropEVEfile(this.files)" />
      </xsl:result-document>
      <!--window.history.pushState(null, null, window.location.pathname);-->
      <xsl:variable name="doc-href" select="ixsl:window() => ixsl:get('location.pathname')"/>
      <xsl:sequence select="ixsl:window() => ixsl:call('history.pushState',[(),(),$doc-href])"/>
   </xsl:template>
   
   <xsl:template name="load-eve">
      <xsl:param name="evetext"  as="xs:string" required="yes"/>
      <ixsl:set-property name="value" object="id('evedata')" select="$evetext"/>
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
