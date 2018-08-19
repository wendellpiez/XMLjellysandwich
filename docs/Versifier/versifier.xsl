<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:XJS="http://github.com/wendellpiez/XMLjellysandwich"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                version="3.0"
                extension-element-prefixes="ixsl"
    exclude-result-prefixes="#all">


   
   <xsl:template name="xmljellysandwich_pack">
<!-- Target page components by assigning transformation results to them via their IDs in the host page. -->
      <xsl:result-document href="#xmljellysandwich_css">
         <xsl:call-template name="css"/>
      </xsl:result-document>
      <xsl:result-document href="#xmljellysandwich_directory">
         <!-- Processing the catalog document -->
         <xsl:apply-templates mode="toc"/>
      </xsl:result-document>
      <xsl:apply-templates select="catalog" mode="full-directory"/>
   </xsl:template>

  <xsl:variable name="source-catalog" select="/"/>
   
   <xsl:template name="show-directory">
      <xsl:apply-templates select="$source-catalog" mode="full-directory"/>
   </xsl:template>
   
   
   <xsl:template match="catalog" mode="full-directory">
      <xsl:result-document href="#versifier_css"  method="ixsl:replace-content"/>
      <xsl:result-document href="#xmljellysandwich_body"  method="ixsl:replace-content">
         <div class="catalog">
            <xsl:apply-templates mode="#current"/>
         </div>
      </xsl:result-document>
   </xsl:template>
   
   <xsl:template match="card" mode="full-directory">
      <!-- @onclick is so Safari makes the div 'clickable' -->
      <section class="card toc-entry" data-src="{@src}" onclick="void(0)">
         <xsl:apply-templates mode="#current"/>
      </section>
   </xsl:template>
   
   <xsl:template match="card/title" priority="1" mode="full-directory">
      <p class="{ local-name() }">
         <xsl:apply-templates mode="#current"/>
      </p>
   </xsl:template>
   
   <xsl:template match="card/*" mode="full-directory">
      <p class="{ local-name() }">
         <xsl:apply-templates mode="#current"/>
      </p>
   </xsl:template>
   
   <xsl:template match="catalog" mode="toc">
      <div class="toc">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   
   <xsl:template match="card" mode="toc">
      <h5 class="toc-entry" data-src="{@src}" onclick="void(0)">
         <xsl:apply-templates select="title, date" mode="toc"/>
      </h5>
   </xsl:template>
   
   <xsl:template match="date" mode="toc">
      <xsl:text> (</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>)</xsl:text>
   </xsl:template>
   
   <xsl:template match="*[XJS:has-class(.,'toc-entry')]" mode="ixsl:click">
      <xsl:variable name="where" select="resolve-uri(@data-src)"/>
      <!--<xsl:message>Whee </xsl:message>-->
      <ixsl:schedule-action document="{$where}">
         <xsl:call-template name="load-poem">
            <xsl:with-param name="where" select="$where"/>
         </xsl:call-template>
      </ixsl:schedule-action>
   </xsl:template>
   
   <xsl:template match="id('page-title')" mode="ixsl:click">
      <xsl:call-template name="show-directory"/>
   </xsl:template>
   
   <xsl:template name="load-poem">
      <xsl:param name="where" as="xs:anyURI" required="yes"/>
      <xsl:apply-templates select="document($where)"/>
   </xsl:template>
   
   <!-- In the contents documents ...  -->
   <xsl:template match="pub">
      <!--<xsl:result-document href="#xmljellysandwich_header" method="ixsl:replace-content">
         <h3>Versifier 2018</h3>
         <xsl:apply-templates select="title, author, source"/>
      </xsl:result-document>-->
      
      <xsl:apply-templates select="style, verse"/>
      
      <!--<xsl:apply-templates/>-->
      <!-- Now traversing the page -->
      
   </xsl:template>
 
   <xsl:template match="pub/title">
      <h1>
         <xsl:apply-templates/>
      </h1>
   </xsl:template>
   
   <xsl:template match="pub/author">
      <h2>
         <xsl:apply-templates/>
      </h2>
   </xsl:template>
   
   <xsl:template match="pub/source">
      <h3>
         <xsl:apply-templates/>
         <xsl:for-each select="../date"> (<xsl:value-of select="."/>)</xsl:for-each>
      </h3>
   </xsl:template>
   
   <xsl:template match="pub/style">
      <xsl:result-document href="#versifier_css"  method="ixsl:replace-content">
         <xsl:apply-templates/>
      </xsl:result-document>
   </xsl:template>
   
   <xsl:template match="pub/verse">
      <xsl:result-document href="#xmljellysandwich_body"  method="ixsl:replace-content">
         <xsl:apply-templates select="../(title, author, source)"/>
         <div class="verse" id="{replace(document-uri(/),'^.*/|\..*$','')}">
            <xsl:apply-templates/>
         </div>
      </xsl:result-document>
      
      <xsl:apply-templates select="ixsl:page()//*[XJS:has-class(.,'verse')]" xpath-default-namespace="" mode="spill"/>
   </xsl:template>
   
   
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
   
  
<xsl:template match="@pause">
   <xsl:attribute name="data-pause" select="."/>
</xsl:template>
   
   <xsl:template match="verse">
      <div class="verse">
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template match="stanza | verse-para">
      <div class="{local-name()} hidden">
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="source/title">
      <i class="title">
         <xsl:apply-templates/>
      </i>
   </xsl:template>
   
   <xsl:template match="author | date | source | title">
      <p class="{local-name()}">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template match="l">
      <p class="l hidden { @r }">
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="l/@r"/>

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
   
   <xsl:variable name="terminalchars" as="xs:string">\.!\?;,:—…</xsl:variable>
   
   <!-- These are the phrase demarcators we set above, $terminalchars !,;\.\?  -->
   <xsl:template mode="pause" match="text()[ends-with(.,'.')]" as="xs:integer">7</xsl:template>
   <xsl:template mode="pause" match="text()[ends-with(.,'!')]" as="xs:integer">5</xsl:template>
   <xsl:template mode="pause" match="text()[ends-with(.,'?')]" as="xs:integer">5</xsl:template>
   <xsl:template mode="pause" match="text()[ends-with(.,';')]" as="xs:integer">5</xsl:template>
   <xsl:template mode="pause" match="text()[ends-with(.,',')]" as="xs:integer">4</xsl:template>
   <xsl:template mode="pause" match="text()[ends-with(.,':')]" as="xs:integer">5</xsl:template>
   <xsl:template mode="pause" match="text()[ends-with(.,'—')]" as="xs:integer">4</xsl:template>
   <xsl:template mode="pause" match="text()[ends-with(.,'…')]" as="xs:integer">5</xsl:template>
   
   <!-- There are also elements in the tree that give us pause ...  -->
   <xsl:template mode="pause" match="*[XJS:has-class(.,'stanza')]"     as="xs:integer">12</xsl:template>
   <xsl:template mode="pause" match="*[XJS:has-class(.,'verse-para')]" as="xs:integer">8</xsl:template>
   <xsl:template mode="pause" match="*[XJS:has-class(.,'l')]"          as="xs:integer">3</xsl:template>

   <xsl:template mode="pause" match="*[@data-pause]" priority="1" as="xs:integer" expand-text="true">
     <xsl:value-of select="xs:integer(@data-pause)"/>
   </xsl:template>
   
   
   <!-- This is the tricky part - -->
   <!-- each phrase looks back at the phrase before, for its pause -->
   <xsl:template mode="pause" xpath-default-namespace="" match="span[XJS:has-class(.,'phr')]" as="xs:integer">
      <xsl:if test=". is /descendant::span[XJS:has-class(.,'phr')][1]">0</xsl:if>
      <xsl:apply-templates select="preceding::span[XJS:has-class(.,'phr')][1]/text()" mode="pause"/>
   </xsl:template>
   
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
         
         .ON { font-style: italic; font-weight: bold }
         
         .hidden { color: white }
         
         #xmljellysandwich_footer { clear: both; width: 100%; font-size: 80%;
          border-top: thin solid black; padding-top: 1em; padding-bottom: 2em;
          font-family: 'Roboto Slab', sans-serif;
          margin-top: 1em }
         
         #xmljellysandwich_header {
         top: 1em; right: 1em; position: fixed }
         
         #xmljellysandwich_directory {
         bottom: 1em; right: 1em; position: fixed }
         
         h5.toc-entry { display: inline-block; margin: 0em }
         // .toc-entry:before { content: " ❖ " }
         h5.toc-entry:before { content: " ☙ " }
         h5.toc-entry:first-child:before { content: "" }
         
         .catalog { max-width: 60% }
         section { margin-top: 1em; border: thin solid black; padding: 1em }
         section * { margin: 0em }
         section .title { font-weight: bold }
         section .source { font-style: italic }
         
   </xsl:template>
   
   <!--
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
   
   <xsl:key name="spans-by-class" match="span" xpath-default-namespace="" use="XJS:classes(.)"/>-->
   
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
