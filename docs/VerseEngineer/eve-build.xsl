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
      <xsl:variable name="basename" select="ixsl:page()/id('anthology-title') => normalize-space() => encode-for-uri()"/>
      <xsl:result-document href="#download" method="ixsl:replace-content">
         <details>
         <summary>EVE, dressed for the web (an HTML page) <button onclick="offerDownload('download-content','{ $basename }.html','html')">Save HTML</button></summary>
         <!--Here we need to serialize the HTML code holding the anthology - or translate it into TEI, JATS or what have you,
         then serialize it -->
         <pre id="download-content">
            <xsl:variable name="htmlpage" expand-text="true">
               <html>
                  <head>
                     <title>{ ixsl:page()/id('anthology-byline') ! (. || ': ')}{ ixsl:page()/id('anthology-title') }</title>
                     <!--<style type="text/css">
                        <xsl:variable name="lines" select="ixsl:page()/id('eve-collection')//html:p[contains-token(@class,'line')]"/>
                        <xsl:variable name="indents" select="$lines/@class/tokenize(.,'\s+')[starts-with(.,'indent')] => distinct-values()"/>
                        <xsl:text>&#xA;.line {{ margin: 0em }}</xsl:text>
                        <xsl:for-each select="$indents">
                           <xsl:variable name="deg" select="replace(.,'\D','')"/>
                           <xsl:text>&#xA;{ . } {{ padding-left:{$deg}em; text-indent:-{$deg}em }}</xsl:text>
                        </xsl:for-each>
                        
                     </style>-->
                  </head>
                  <body>
                     <xsl:apply-templates select="ixsl:page()/id('anthology-title')" mode="savable-html"/>
                     <xsl:apply-templates select="ixsl:page()/id('anthology-byline')" mode="savable-html"/>
                     <xsl:apply-templates mode="savable-html" select="ixsl:page()/id('eve-collection')"/>
                  </body>
               </html>
            </xsl:variable>
            <xsl:value-of select="serialize($htmlpage,$indented-xml)"/>
         </pre>
         </details>
      </xsl:result-document>   
      <xsl:apply-templates select="ixsl:page()/id('download')" mode="show"/>
   </xsl:template>
   
   <xsl:mode name="savable-html" on-no-match="shallow-copy"/>
   
   <xsl:template match="@contenteditable" mode="savable-html"/>
   
   <xsl:variable name="indented-xml" as="element()">
      <output:serialization-parameters
         xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
         <output:indent value="true"/>
         <output:omit-xml-declaration value="true"/>
      </output:serialization-parameters>
   </xsl:variable>
   <xsl:import href="eve-plainhtml.xsl"/>
   
   <xsl:template match="EVE" mode="plainhtml">
      <section class="EVE">
         <xsl:apply-templates mode="#current"/>
      </section>
   </xsl:template>
   
   <xsl:template match="html:style" mode="plainhtml"/>
   
   <xsl:template mode="savable-html" match="html:p[contains-token(@class,'line')]">
      <xsl:variable name="indent" select="tokenize(@class,'\s+')[starts-with(.,'indent')]"/>
      <xsl:variable name="deg" select="$indent ! replace(.,'\D','')"/>
      <p style="margin:0em;{ $deg ! ('padding-left:' || . || 'em;text-indent:-' || . || 'em;') }">
         <xsl:apply-templates mode="#current"/>
      </p>
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
      <xsl:apply-templates select="ixsl:page()/id('download')" mode="hide"/>
      <xsl:result-document href="#eve-collection" method="ixsl:replace-content"/>
   </xsl:template>
   
   <!--<xsl:template match="id('download-html')" mode="ixsl:onclick">
      <!-\-function offerDownload(variant,fileName) where variant is a pre into which we inject the contents -\->
      
      
   </xsl:template>-->
   
   <xsl:template match="*" mode="show">
      <ixsl:set-attribute name="class"
         select="string-join( (tokenize(@class,'\s+')[not(. eq 'hidden')]), ' ')"/>
   </xsl:template>
   
   <xsl:template match="*" mode="hide">
      <ixsl:set-attribute name="class"
         select="string-join( (tokenize(@class,'\s+')[not(. eq 'hidden')],'hidden'), ' ')"/>
   </xsl:template>
   
   <xsl:template match="html:br" mode="savable-html"/>
   
   <xsl:template match="@style" mode="savable-html"/>
   
   <xsl:template match="html:div[@class='head']" mode="savable-html">
      <header>
         <xsl:apply-templates mode="#current"/>
      </header>
   </xsl:template>
   
</xsl:stylesheet>
