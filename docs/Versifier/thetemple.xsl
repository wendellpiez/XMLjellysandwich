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
      
      
      <xsl:apply-templates select="ixsl:page()//*[XJS:has-class(.,'verse')]" xpath-default-namespace="" mode="spill"/>
      
   </xsl:template>

   <xsl:variable name="terminalchars" as="xs:string">!,;\.\?</xsl:variable>
   
   <xsl:template match="l//text()">
      <xsl:analyze-string select="." regex="[^{$terminalchars}]*[{$terminalchars}]">
         <xsl:matching-substring>
            <span class="phr hidden">
               <xsl:value-of select="."/>
            </span>
         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <span class="phr hidden">
               <xsl:value-of select="."/>
            </span>
         </xsl:non-matching-substring>
      </xsl:analyze-string>
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
      <div class="stanza hidden">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template match="title"/>
   
   <xsl:template match="source/title">
      <i>
         <xsl:apply-templates/>
      </i>
   </xsl:template>
   
   <xsl:template match="author">
      <p class="author">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template match="source">
      <p class="source">
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

   <xsl:template match="*" priority="-0.2" mode="spill">
      <!--<xsl:message>spilling <xsl:value-of select="local-name()"/></xsl:message>-->
      <xsl:variable name="pause">
         <xsl:apply-templates select="." mode="pause"/>
      </xsl:variable>
      <!-- waiting zero just suspends -->
      <xsl:variable name="wait" select="xs:integer($pause * 360) + 1"/>
      <!--<xsl:message>wait is <xsl:value-of select="$wait"/></xsl:message>-->
      <ixsl:schedule-action wait="$wait">
         <xsl:call-template name="show"/>
      </ixsl:schedule-action>
      <!--<xsl:call-template name="show"/>-->
   </xsl:template>

   <!-- 'spill' mode performs a sibling traversal in document order -->
   <xsl:template match="node()" mode="spill">
      <xsl:apply-templates select="(child::node() | following::node())[1]" mode="spill"/>
   </xsl:template>
   
   <!-- stop spilling -->
   <xsl:template match="*[not(ancestor-or-self::*/XJS:classes(.)='verse')]" mode="spill"/>
   
   <xsl:template name="show">
      <xsl:variable name="already-has" select="XJS:classes(.)"/>
      <ixsl:set-attribute name="class"
         select="string-join($already-has[not(. = 'hidden')], ' ')"/>
      <xsl:apply-templates select="(child::node() | following::node())[1]" mode="spill"/>
   </xsl:template>
   <!--<xsl:template name="show"/>-->
   
   <!-- catchall: by default we do not pause for anything -->
   <xsl:template mode="pause" match="node()" as="xs:integer">0</xsl:template>
   
   <!-- These are the phrase demarcators we set above, $terminalchars !,;\.\?  -->
   <xsl:template mode="pause" match="text()[ends-with(.,'.')]" as="xs:integer">7</xsl:template>
   <xsl:template mode="pause" match="text()[ends-with(.,'!')]" as="xs:integer">5</xsl:template>
   <xsl:template mode="pause" match="text()[ends-with(.,'?')]" as="xs:integer">5</xsl:template>
   <xsl:template mode="pause" match="text()[ends-with(.,';')]" as="xs:integer">5</xsl:template>
   <xsl:template mode="pause" match="text()[ends-with(.,',')]" as="xs:integer">4</xsl:template>
   
   <!-- There are also elements in the tree that give us pause ...  -->
   <xsl:template mode="pause" xpath-default-namespace="" match="*[XJS:has-class(.,'stanza')]" as="xs:integer">12</xsl:template>
   <xsl:template mode="pause" xpath-default-namespace="" match="*[XJS:has-class(.,'l')]"      as="xs:integer">3</xsl:template>
   
   
   <!-- This is the tricky part - -->
   <!-- each phrase looks back at the phrase before, for its pause -->
   <xsl:template mode="pause" xpath-default-namespace="" match="span[XJS:has-class(.,'phr')]" as="xs:integer">
      <xsl:if test=". is /descendant::span[XJS:has-class(.,'phr')][1]">0</xsl:if>
      <xsl:apply-templates select="preceding::span[XJS:has-class(.,'phr')][1]/text()" mode="pause"/>
   </xsl:template>
   
   <xsl:template name="css">
      <style type="text/css">
         html, body { background-color: white }
         
         .tag { color: green; font-family: sans-serif; font-size: 80%; font-weight: bold }
         
         
         .pub { }
         
         .title { }
         
         .author { }
         
         .verse { clear: both; margin-top: 1em; margin-bottom: 1em }
         
         .stanza { margin-top: 1em; margin-bottom: 1em; margin-right: 2%; 
                   width: 28%; float: left; line-height: 150%; opacity: 1;
                  transition: opacity 10s ease-in;
                  -moz-transition: opacity 10s ease-in;
                  -webkit-transition: opacity 10s ease-in;
         } 
         
         .l { padding-left: 2em; text-indent: -2em }
         
         .indent { padding-left: 6em; text-indent: -2em }
         
         .l * { display: inline }
         
         span.phr {transition: color 1s ease-in;
              -moz-transition: color 1s ease-in;
              -webkit-transition: color 1s ease-in; }
         
         .ON { font-style: italic; font-weight: bold }
         
         .hidden { color: white }
         
         .stanza.hidden { opacity: 0.5 }
         
         #xmljellysandwich_footer { clear: both; width: 100%; font-size: 80%;
          border-top: thin solid black; padding-top: 2em;
          font-family: 'Roboto Slab', sans-serif }
         
         
      </style>
   </xsl:template>
   
   <xsl:template mode="ixsl:onmouseover" match="span[XJS:has-class(.,'i')]">
      <xsl:apply-templates select="key('spans-by-class','i')" mode="on"/>
   </xsl:template>
   
   <xsl:template mode="ixsl:onmouseout"  match="span[XJS:has-class(.,'i')]">
      <xsl:apply-templates select="key('spans-by-class','i')" mode="off"/>
   </xsl:template>
   
   <xsl:template mode="ixsl:onmouseover" match="span[XJS:has-class(.,'love')]">
      <xsl:apply-templates select="key('spans-by-class','love')" mode="on"/>
   </xsl:template>
   
   <xsl:template mode="ixsl:onmouseout"  match="span[XJS:has-class(.,'love')]">
      <xsl:apply-templates select="key('spans-by-class','love')" mode="off"/>
   </xsl:template>
   
   <xsl:template match="*" mode="off">
      <ixsl:set-attribute name="class"
         select="string-join( (tokenize(@class,'\s+')[not(. eq 'ON')]), ' ')"/>
   </xsl:template>
   
   <xsl:template match="*" mode="on">
      <ixsl:set-attribute name="class"
         select="string-join( (tokenize(@class,'\s+')[not(. eq 'ON')],'ON'), ' ')"/>
   </xsl:template>
   
   <xsl:key name="spans-by-class" match="span" xpath-default-namespace="" use="XJS:classes(.)"/>
   
   <xsl:function name="XJS:classes">
      <xsl:param name="who" as="element()"/>
      <xsl:sequence select="tokenize($who/@class, '\s+') ! lower-case(.)"/>
   </xsl:function>

   <xsl:function name="XJS:has-class">
      <xsl:param name="who" as="element()"/>
      <xsl:param name="ilk" as="xs:string+"/>
      <xsl:sequence select="$ilk = XJS:classes($who)"/>
   </xsl:function>
</xsl:stylesheet>
