<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:XJS="http://github.com/wendellpiez/XMLjellysandwich"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                version="3.0"
                extension-element-prefixes="ixsl"
    exclude-result-prefixes="#all">


<!--Starter XSLT written courtesy of XML Jelly Sandwich -->


   <!-- We'd do this dynamically if SaxonJS supported accumulators - 
      
      <xsl:include href="accrue-timing.xsl"/>
   
   <xsl:variable name="all-timed">
      <xsl:call-template name="mark-time"/>
   </xsl:variable>-->
   
   <!-- Should bind to catalog document -->
   <!--<xsl:variable name="src-uri" select="document-uri(/)"/>-->
   
   <xsl:template name="xmljellysandwich_pack">
      <xsl:result-document href="#teller-css">
         <xsl:call-template name="css"/>
      </xsl:result-document>
   </xsl:template>

   <xsl:template match="id('text_select')" mode="ixsl:click">
      <xsl:apply-templates select="id('text_panel')" mode="switch-in"/>
   </xsl:template>
  
   <xsl:template match="id('tell_select')" mode="ixsl:click">
      <xsl:result-document href="#tell_panel" method="ixsl:replace-content">
         <section class="verse">
            <xsl:for-each select="id('poetry-in-motion', ixsl:page())">
               <xsl:for-each-group select="tokenize(ixsl:get(., 'value'), '\n')"
                  group-adjacent="matches(., '\S')">
                  <xsl:if test="current-grouping-key()">
                     <div class="stanza">
                        <xsl:for-each select="current-group()">
                           <xsl:variable name="indent" select="replace(., '\S.*$', '')"/>
                           <xsl:variable name="spaces"
                              select="string-length(replace($indent, '\t', ''))"/>
                           <xsl:variable name="tabs"
                              select="string-length(replace($indent, ' ', ''))"/>
                           <p class="line indent{ ($tabs * 3) + $spaces }">
                              <!--<xsl:value-of select="."/>-->
                              <xsl:call-template name="spill-out">
                                 <xsl:with-param name="spilling" select="string(.)"/>
                              </xsl:call-template>
                           </p>
                        </xsl:for-each>
                     </div>
                  </xsl:if>

               </xsl:for-each-group>
            </xsl:for-each>
            <!--<button id="save_me">Save me</button>-->
         </section>
      </xsl:result-document>

      <xsl:apply-templates select="id('tweak_panel')"  mode="off"/>
      <xsl:apply-templates select="id('tell_panel')"   mode="on"/>
      <xsl:apply-templates select="id('tell_panel')/*" mode="spill"/>
      
   </xsl:template>
   
   <xsl:template match="id('tweak_select')" mode="ixsl:click">
      <xsl:apply-templates select="id('tweak_panel')" mode="switch-in"/>
   </xsl:template>
   
   

<!-- matching div.panel elements, turns its display on and its neighbor div.panel elements, off  -->
   <xsl:template mode="switch-in" match="*[contains-token(@class,'ON')]">
            <xsl:apply-templates select="." mode="off"/>
   </xsl:template>
   
   <xsl:template mode="switch-in" match="*">
      <xsl:apply-templates select="." mode="on"/>
   </xsl:template>
   
   
   <xsl:variable name="terminalchars" as="xs:string">\.!\?;,:—…</xsl:variable>
   
   <xsl:template name="spill-out">
      <xsl:param name="spilling" as="xs:string"/>
      
      <xsl:analyze-string select="$spilling" regex="[^{$terminalchars}]*[{$terminalchars}]">
         <xsl:matching-substring>
            <span class="phr hide">
               <xsl:value-of select="."/>
            </span>
         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <span class="phr hide">
               <xsl:value-of select="."/>
            </span>
         </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:template>
   
   
   <xsl:template match="@pause">
      <xsl:attribute name="data-pause" select="."/>
   </xsl:template>
   
   <xsl:template match="*" priority="-0.2" mode="spill">
      <xsl:variable name="pause">
         <xsl:apply-templates select="." mode="pause"/>
      </xsl:variable>
      <xsl:message>pausing <xsl:value-of select="$pause"/> for <xsl:value-of select="name()"/></xsl:message>
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
   <xsl:template match="*[not(ancestor-or-self::*[contains-token(@class,'verse')])]" mode="spill"/>
   
   <xsl:template name="show">
      <ixsl:set-attribute name="class"
         select="string-join(tokenize(@class,'\s+')[not(. = 'hide')], ' ')"/>
      <xsl:apply-templates select="(child::node() | following::node())[1]" mode="spill"/>
   </xsl:template>
   <!--<xsl:template name="show"/>-->
   
   <!-- catchall: by default we do not pause for anything -->
   <xsl:template mode="pause" match="node()"     as="xs:integer">
      <xsl:value-of select="(key('input-by-name','fallback',ixsl:page()) ! ixsl:get(., 'value'),0)[1]"/>
   </xsl:template>
   
   <xsl:template mode="pause" match="text()[matches(.,('[' || $terminalchars|| ']$'))]" as="xs:integer">
      <xsl:variable name="char" select="replace(.,('.*([' || $terminalchars|| '])$'),'$1')"/>
      <xsl:value-of select="(key('input-by-name',$char,ixsl:page()) ! ixsl:get(., 'value'),0)[1]"/>
   </xsl:template>
   
   <!-- There are also elements in the tree that give us pause ...  -->
   <xsl:template mode="pause" match="*[contains-token(@class,'stanza')]"     as="xs:integer">
      <xsl:value-of select="(key('input-by-name','stanza',ixsl:page()) ! ixsl:get(., 'value'),12)[1]"/>
   </xsl:template>
   <xsl:template mode="pause" match="*[contains-token(@class,'verse-para')]" as="xs:integer">
      <xsl:value-of select="(key('input-by-name','verse-para',ixsl:page()) ! ixsl:get(., 'value'),8)[1]"/>
   </xsl:template>
   
   <xsl:template mode="pause" match="*[contains-token(@class,'line')]"       as="xs:integer">
      <xsl:value-of select="(key('input-by-name','line',ixsl:page()) ! ixsl:get(., 'value'),3)[1]"/>
   </xsl:template>
   
   <xsl:template mode="pause" match="*[@data-pause]" priority="1" as="xs:integer" expand-text="true">
      <xsl:value-of select="xs:integer(@data-pause)"/>
   </xsl:template>
   
   
   <!-- This is the tricky part - -->
   <!-- each phrase looks back at the phrase before, for its pause -->
   <xsl:template mode="pause" xpath-default-namespace="" priority="10"
      match="span[. is root()/descendant::span[contains-token(@class,'phr')][1] ]" 
      as="xs:integer">0</xsl:template>
   
      <xsl:template mode="pause" xpath-default-namespace="" match="span[contains-token(@class,'phr')]" as="xs:integer">
         <!-- Note extra step to text node child: this is what keeps us from recursing to the front. -->
      <xsl:apply-templates select="preceding::span[contains-token(@class,'phr')][1]/text()" mode="pause"/>
   </xsl:template>
   
   <xsl:key name="input-by-name" match="input" use="@name"/>

<xsl:template name="css">
         html, body { background-color: white }
         
         .tag { color: green; font-family: sans-serif; font-size: 80%; font-weight: bold }
         
         
         .pub { }
         
         .title { }
         
         .author { }
         
         .l { padding-left: 2em; text-indent: -2em; margin-top: 0ex; margin-bottom: 0ex }
         
         .l * { display: inline }
         
         span.phr {transition: color 1s ease-in;
              -moz-transition: color 1s ease-in;
              -webkit-transition: color 1s ease-in; }
         
         #xmljellysandwich_footer { clear: both; width: 100%; font-size: 80%;
          border-top: thin solid black; padding-top: 1em; padding-bottom: 2em;
          font-family: 'Roboto Slab', sans-serif;
          margin-top: 1em }
         
         
         h5.toc-entry { display: inline-block; margin: 0em }
         // .toc-entry:before { content: " ❖ " }
         h5.toc-entry:before { content: " ☙ " }
         h5.toc-entry:first-child:before { content: "" }
         
         .catalog { max-width: 60% }
         section { border: medium solid black; padding: 1ex }
         section * { margin: 0em }
         section .title { font-weight: bold }
         section .source { font-style: italic }
         
         section { max-width: 32em }
         
         #page { float: right }
         
         .verse p { padding-left: 3em; text-indent: -3em }
         .stanza p { margin-top: 0ex; margin-bottom: 0ex }
         .stanza { margin-top: 3ex }
         .stanza:first-child { margin-top: 0ex}
         
         .verse .indent1 { padding-left: 3em }
         .verse .indent2 { padding-left: 4em }
         .verse .indent3 { padding-left: 5em }
         .verse .indent4 { padding-left: 6em }
         .verse .indent5 { padding-left: 7em }
         .verse .indent6 { padding-left: 8em }
         .verse .indent7 { padding-left: 9em }
         .verse .indent8 { padding-left: 10em }
         .verse .indent9 { padding-left: 11em }
         
         .panel { display: none }
         .panel.ON { display: block }
         
         .hide { color: white }
         
         #tell_panel { margin-left: 24em }
         
         #tweak_panel { z-index: 1; position: fixed; right: 1ex; margin-top: 1ex;
           background-color: gainsboro; padding: 1em; border: thin outset black;
           font-family: sans-serif; font-size: 80%; 
            width: 40%; float: right; clear: both; text-align: right }
         #tweak_panel > *:first-child { margin-top: 0ex }
   </xsl:template>
   
   <xsl:template match="*" mode="off">
      <xsl:message>OFF</xsl:message>
      <ixsl:set-attribute name="class"
         select="string-join( (tokenize(@class,'\s+')[not(. eq 'ON')]), ' ')"/>
   </xsl:template>
   
   <xsl:template match="*" mode="on">
      <ixsl:set-attribute name="class"
         select="string-join( (tokenize(@class,'\s+')[not(. eq 'ON')],'ON'), ' ')"/>
   </xsl:template>
   
   
</xsl:stylesheet>
