<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:XJS="http://github.com/wendellpiez/XMLjellysandwich"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                version="3.0"
                extension-element-prefixes="ixsl">

<!--Starter XSLT written courtesy of XML Jelly Sandwich -->

   <xsl:template name="xmljellysandwich_pack">
<!-- Target page components by assigning transformation results to them via their IDs in the host page. -->
      <xsl:result-document href="#xmljellysandwich_body">
         <xsl:apply-templates/>
      </xsl:result-document>
   </xsl:template>

  <xsl:mode on-no-match="shallow-copy"/>
   
   <xsl:template match="document">
      <div class="document">
         <h3>
           <xsl:apply-templates/>
         </h3>
         
      </div>
   </xsl:template>

   <xsl:template name="css">
      <style type="text/css">
html, body { font-size: 10pt }
div { margin-left: 1rem }
.tag { color: green; font-family: sans-serif; font-size: 80%; font-weight: bold }


.document { }

</style>
   </xsl:template>

  <xsl:template match="input | id('file')" mode="ixsl:onchange">
     <xsl:result-document href="#xmljellysandwich_body">
        <h1>
           <xsl:text> beep </xsl:text>
           <xsl:value-of select="map:find(ixsl:get(.,'files'),'name')"/>
        </h1>
        
        <xsl:variable name="fileobj" select="map:get( ixsl:get(.,'files'),'0')"/>
        <xsl:variable name="content" select="ixsl:call(ixsl:window(),'loadFromZip',[ $fileobj,'content.xml' ])"/>
        
              <p>X
                 <!--<xsl:copy-of select="$content"/>-->
              </p>
        <!--
        <xsl:value-of select="count($fileobj )"/>
        <xsl:value-of select="map:find($fileobj,'name')"/>-->
    
     </xsl:result-document>
     
  </xsl:template>

   <xsl:template priority="-0.4" match="document">
      <div class="{name()}">
         <div class="tag">
            <xsl:value-of select="name()"/>: </div>
         <xsl:apply-templates/>
      </div>
   </xsl:template>



   <xsl:function name="XJS:classes">
      <xsl:param name="who" as="element()"/>
      <xsl:sequence select="tokenize($who/@class, '\s+') ! lower-case(.)"/>
   </xsl:function>

   <xsl:function name="XJS:has-class">
      <xsl:param name="who" as="element()"/>
      <xsl:param name="ilk" as="xs:string"/>
      <xsl:sequence select="$ilk = XJS:classes($who)"/>
   </xsl:function>
</xsl:stylesheet>
