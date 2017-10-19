<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:XJS="http://github.com/wendellpiez/XMLjellysandwich"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                version="3.0"
                extension-element-prefixes="ixsl">

<!--Starter XSLT written courtesy of XML Jelly Sandwich -->

   <!-- We want nothing to happen (yet) at load time ... -->
   <xsl:template name="xmljellysandwich_pack"/>
<!-- Target page components by assigning transformation results to them via their IDs in the host page. -->
      <!--<xsl:result-document href="#xmljellysandwich_body">
         <xsl:apply-templates/>
      </xsl:result-document>-->
   <!--</xsl:template>-->

<!-- Entry template for XTractor - XML will be whatever was parsed from provided input, good luck! --> 
<xsl:template name="XTractor-acquire">
   <xsl:result-document href="#XTractor" method="ixsl:replace-content">
      <xsl:apply-templates mode="flag"/>
   </xsl:result-document>
   
   
</xsl:template>
   
   <xsl:template match="id('file')" mode="ixsl:onchange">
      <!-- pre loading -->
      <xsl:variable name="fileobj" select="map:get( ixsl:get(id('file'),'files'),'0')"/>
      <xsl:result-document href="#xmljellysandwich_header" method="ixsl:append-content">
         <h4>
            <xsl:text>... reading file </xsl:text>
            <xsl:value-of select="map:find(ixsl:get(.,'files'),'name')"/>
         </h4>
      </xsl:result-document>
      
         <!-- Call to $content will inject transformation results
              into #XTractor -->
      <xsl:variable name="content" select="ixsl:call(ixsl:window(),'loadFromZip',[ $fileobj,'word/document.xml' ])"/>
      <xsl:copy-of select="$content"/>
      
   </xsl:template>
   
   <!--<xsl:template match="id('go')" mode="ixsl:onclick">
      <xsl:result-document href="#xmljellysandwich_body">
         <xsl:variable name="content" select="id('XTractor')"/>
         <!-\-<xsl:variable name="xml-we-think" select="parse-xml($content)"/>-\->
         <div>
            <!-\-<xsl:text expand-text="yes">
               count($content):  { count($content) } 
               exists($content): { exists($content) }          
               content:          { $content }
            </xsl:text>-\->
            <xsl:apply-templates select="$content" mode="render"/>
         </div>
         
      </xsl:result-document>
      
   </xsl:template>-->
   
   <xsl:function name="XJS:classes">
      <xsl:param name="who" as="element()"/>
      <xsl:sequence select="tokenize($who/@class, '\s+') ! lower-case(.)"/>
   </xsl:function>

   <xsl:function name="XJS:has-class">
      <xsl:param name="who" as="element()"/>
      <xsl:param name="ilk" as="xs:string"/>
      <xsl:sequence select="$ilk = XJS:classes($who)"/>
   </xsl:function>
   
   <xsl:template match="*" mode="render flag">
      <span style="color: green; font-size: 70%; font-family: sans-serif">
         <xsl:value-of select="local-name()"/>
      </span>
      <xsl:apply-templates mode="#current"/>
      <span style="color: green; font-size: 70%; font-family: sans-serif">
         <xsl:value-of select="local-name()"/>
      </span>
   </xsl:template>

   <xsl:template match="." mode="render flag">
      <span style="color: blue">
      <xsl:value-of select="."/>
      </span>
   </xsl:template>

   <xsl:template match="w:document" mode="#all"
      xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
      <xsl:apply-templates select="w:body"/>
   </xsl:template>
   
   <!-- Assumed by included XSLT, whereas this stylesheet copies through by default -->
   <xsl:template match="w:*"
      xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   
   <xsl:include href="../../../../Documents/XSweet/applications/docx-extract/docx-html-extract-mini.xsl"/>
   
</xsl:stylesheet>
