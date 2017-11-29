<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:XJS="http://github.com/wendellpiez/XMLjellysandwich"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                version="3.0"
                extension-element-prefixes="ixsl">

<!--Starter XSLT written courtesy of XML Jelly Sandwich -->


   <!-- We'd do this dynamically if SaxonJS supported accumulators - 
      
      <xsl:include href="accrue-timing.xsl"/>
   
   <xsl:variable name="all-timed">
      <xsl:call-template name="mark-time"/>
   </xsl:variable>-->
   
   <xsl:template name="xmljellysandwich_pack">
<!-- Target page components by assigning transformation results to them via their IDs in the host page. -->
      <xsl:result-document href="#xmljellysandwich_css">
         <xsl:call-template name="css"/>
      </xsl:result-document>
      <xsl:result-document href="#xmljellysandwich_body">
         <xsl:apply-templates/>
      </xsl:result-document>
      
      
      <xsl:apply-templates select="ixsl:page()//span[XJS:classes(.)='hidden']" xpath-default-namespace="" mode="showing"/>
      
   </xsl:template>

   <xsl:template match="pub">
      <div class="pub">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template match="verse">
      <div class="verse">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template match="stanza">
      <div class="stanza">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template match="title"/>

   <xsl:template match="author">
      <p class="author">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="l">
      <p class="l{ if (count(preceding-sibling::*) mod 2) then ' indent' else '' }">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="i">
      <span class="i">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template match="love">
      <span class="love">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template match="d">
      <span class="paused_{@d} phr hidden">
         <xsl:apply-templates/>
      </span>
   </xsl:template>
   
   <xsl:template name="show">
      <xsl:variable name="already-has" select="XJS:classes(.)"/>
      <ixsl:set-attribute name="class"
         select="string-join($already-has[not(. = 'hidden')], ' ')"/>
   </xsl:template>
   
   
   
   <xsl:template match="span" mode="showing" xpath-default-namespace="">
      <xsl:variable name="pause" select="XJS:classes(.)[starts-with(.,'paused_')] => replace('\D','') => number()"/>
      <xsl:variable name="wait" select="xs:integer($pause * 360)"/>
         <!--<ixsl:schedule-action wait="(substring-after(@class,'paused_') ! number(.)) * $wait">-->
      <ixsl:schedule-action wait="$wait">
            <xsl:call-template name="show"/>
         </ixsl:schedule-action>
   </xsl:template>
      
   <xsl:template name="css">
      <style type="text/css">
html, body { font-size: 16pt }
div { margin-left: 1rem }

.tag { color: green; font-family: sans-serif; font-size: 80%; font-weight: bold }


.pub { }

.title { }

.author { }

.verse { }

.stanza { display: table-cell; margin: 1em; color: white; background-color: black;
padding: 1em;
border: medium solid skyblue;
float: left;
width: 25% } 

.l { padding-left: 2em; text-indent: -2em }

.indent { padding-left: 6em; text-indent: -2em }

.l * { display: inline }

.i:hover { font-size: 110% }

.love:hover {  font-size: 120% }

span.phr { opacity: 1;
         transition: opacity .25s ease-in-out;
         -moz-transition: opacity .25s ease-in-out;
         -webkit-transition: opacity .25s ease-in-out;
} 
span.hidden { display: none }

#xmljellysandwich_footer { clear: both }


</style>
   </xsl:template>

<!--

   <xsl:template priority="-0.4" match="pub | verse | stanza">
      <div class="{name()}">
         <div class="tag">
            <xsl:value-of select="name()"/>: </div>
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template priority="-0.4" match="title | author | l">
      <p class="{name()}">
         <span class="tag">
            <xsl:value-of select="name()"/>: </span>
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template priority="-0.4" match="i | love">
      <span class="{name()}">
         <span class="tag">
            <xsl:value-of select="name()"/>: </span>
         <xsl:apply-templates/>
      </span>
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
</xsl:stylesheet>
