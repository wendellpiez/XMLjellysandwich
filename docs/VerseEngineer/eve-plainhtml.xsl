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
                default-mode="plainhtml"
   
    exclude-result-prefixes="#all">
   
   <!-- hovering on a link affects display on the link target to highlight -->
   <xsl:template priority="2" mode="ixsl:onmouseover" match="html:span[contains-token(@class,'glossed')]
      | html:div[contains-token(@class,'glossed')]">
      <xsl:apply-templates select="key('gloss-by-term',@data-term)" mode="on"/>
      <xsl:next-match/>
   </xsl:template>
   
   <xsl:template priority="2" mode="ixsl:onmouseout"  match="html:span[contains-token(@class,'glossed')]
      | html:div[contains-token(@class,'glossed')]">
      <xsl:apply-templates select="key('gloss-by-term',@data-term)" mode="off"/>
      <xsl:next-match/>
   </xsl:template>
   
   <xsl:template mode="ixsl:onclick" match="html:span[contains-token(@class,'glossed')]
      | html:div[contains-token(@class,'glossed')]">
      <xsl:apply-templates select="key('gloss-by-term',@data-term)" mode="nudge"/>
   </xsl:template>
   
   
   
   <!-- hovering on a link affects display on the link target to highlight -->
   <xsl:template mode="ixsl:onmouseover" match="html:a[contains-token(@class,'fnr')]">
      <xsl:apply-templates select="key('html-internal',@href)" mode="on"/>
   </xsl:template>
   
   <xsl:template mode="ixsl:onmouseout"  match="html:a[contains-token(@class,'fnr')]">
      <xsl:apply-templates select="key('html-internal',@href)" mode="off"/>
   </xsl:template>
   
   <xsl:key name="html-internal" match="html:*" use="'#' || @id"/>
   
   <xsl:key name="gloss-by-term" match="html:span[contains-token(@class,'glossed')]" use="@data-term"/>
   
   <xsl:key name="gloss-by-term" match="html:div[contains-token(@class,'glossed')]" use="@data-term"/>
   
   <xsl:key name="div-by-href" match="html:div" use="'#' || @id"/>
   
   <xsl:template mode="nudge" match="*">
      <xsl:choose>
         <xsl:when test="contains-token(@class,'AWAKE')">
            <xsl:apply-templates select="." mode="sleep"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="." mode="awaken"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   
   <xsl:template mode="off" match="*">
      <ixsl:set-attribute name="class" select="(tokenize(@class,'\s+')[not(. eq 'ON')]) => string-join(' ')"/>
   </xsl:template>
   
   <xsl:template mode="on" match="*">
      <ixsl:set-attribute name="class" select="(tokenize(@class,'\s+')[not(. eq 'ON')],'ON') => string-join(' ')"/>
   </xsl:template>
   
   <xsl:template mode="sleep" match="*">
      <ixsl:set-attribute name="class" select="(tokenize(@class,'\s+')[not(. eq 'AWAKE')]) => string-join(' ')"/>
   </xsl:template>
   
   <xsl:template mode="awaken" match="*">
      <ixsl:set-attribute name="class" select="(tokenize(@class,'\s+')[not(. eq 'AWAKE')],'AWAKE') => string-join(' ')"/>
   </xsl:template>
   
   
   <xsl:template match="EVE" mode="plainhtml">
      
      <main class="EVE">
         <xsl:where-populated>
            <div class="links">
               <xsl:apply-templates mode="plainhtml" select="/EVE/head/link"/>
            </div>
         </xsl:where-populated>
         <xsl:apply-templates mode="#current"/>
         
      </main>
   </xsl:template>
   
   <xsl:template match="head" mode="plainhtml">
      <header>
         <xsl:apply-templates mode="#current" select="title, author, date"/>
      </header>
   </xsl:template>
   
   <xsl:template match="section" mode="plainhtml">
      <section class="section">
         <xsl:apply-templates mode="#current"/>
      </section>
   </xsl:template>
   
   <xsl:template match="head/title" mode="plainhtml">
      <h2 class="eve-title">
         <xsl:apply-templates mode="#current"/>
      </h2>
   </xsl:template>
   
   <xsl:template priority="0.4" match="head/*" mode="plainhtml">
      <h4 class="eve-{local-name()}">
         <xsl:apply-templates mode="#current"/>
      </h4>
   </xsl:template>
   
   <xsl:template priority="0.4" match="head/link" mode="plainhtml">
      <p class="eve-reflink">
         <a href="{ . }">
           <xsl:apply-templates mode="#current"/>
         </a>
      </p>
   </xsl:template>
   
   <xsl:template match="verse | inset | epigraph" mode="plainhtml">
      <div class="{ local-name() }">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   
   <xsl:template match="attrib" mode="plainhtml">
      <p class="attrib">
         <xsl:apply-templates mode="#current"/>
      </p>
   </xsl:template>
   
   <xsl:template match="p" mode="plainhtml">
      <p class="p">
         <xsl:apply-templates mode="#current"/>
      </p>
   </xsl:template>
   
   <xsl:template match="title" mode="plainhtml">
      <h3 class="section-title">
         <xsl:apply-templates mode="#current"/>
      </h3>
   </xsl:template>
   
   <xsl:template match="line" mode="plainhtml">
      <!-- line[@ind='3'] become p.line.indent3 -->
      <p class="line{ @ind ! (' indent' || .) }">
         <xsl:apply-templates mode="#current"/>
      </p>
   </xsl:template>
   
   <xsl:template match="i" mode="plainhtml">
      <i>
         <xsl:apply-templates mode="#current"/>
      </i>
   </xsl:template>
   
   <xsl:template match="b" mode="plainhtml">
      <b>
         <xsl:apply-templates mode="#current"/>
      </b>
   </xsl:template>
   
   <xsl:template match="gl">
      <span class="glossed" data-term="{ @t }">
         <xsl:apply-templates/>
      </span>
   </xsl:template>
   
   <!-- fnr that points nowhere will not be resolved, but Eve gives us none
     (it only produces fnr when a target is found) -->
   <xsl:template match="fnr" mode="plainhtml">
      <xsl:apply-templates select="key('note-for-ref',@ref)" mode="linkto"/>
   </xsl:template>
   
   <xsl:key name="note-for-ref" match="notes/note" use="@id"/>
   
   <xsl:template match="note" mode="linkto">
      <a href="#{@id}" class="fnr">
         <xsl:apply-templates select="." mode="symbol"/>
      </a>
   </xsl:template>
      
   <xsl:template match="glossary" mode="plainhtml">
      <xsl:where-populated>
         <div class="glossary">
            <xsl:apply-templates mode="#current"/>
         </div>
      </xsl:where-populated>
   </xsl:template>
   
   <xsl:template match="glossary/gloss" mode="plainhtml" expand-text="true">
      <!-- displayed in a grid, so unwrapped -->
      <div class="glossed term" data-term="{ @text }">
         <p>{ @text }</p>
      </div>
      <div class="glossed gloss" data-term="{ @text }">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   
   <xsl:template match="note" mode="plainhtml">
      <aside class="sidenote">
         <xsl:apply-templates mode="#current"/>
      </aside>
   </xsl:template>
   
   <xsl:template match="notes" mode="plainhtml">
      <xsl:where-populated>
         <div class="endnotes">
            <xsl:apply-templates mode="#current"/>
         </div>
      </xsl:where-populated>
   </xsl:template>
   
   <xsl:template match="notes/note" mode="plainhtml">
      <!-- displayed in a grid, so unwrapped -->
      <div class="notesym">
         <p>
           <xsl:apply-templates select="." mode="symbol"/>
         </p>
      </div>
      <div class="notebody" id="{@id}">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   
   <xsl:variable name="symbolstring" as="xs:string">&#x2A; &#x2020; &#x2021; &#xA7; &#x2016; &#xB6;</xsl:variable>
   
   <xsl:variable name="fnsymbols" select="tokenize( $symbolstring,' ')"/>
   
   <xsl:template match="notes/note" mode="symbol">
      <xsl:variable name="pos" select="count(.|preceding-sibling::note)"/>
      <xsl:variable name="sym" select="let $p := ($pos mod 6) return ($fnsymbols[$p],$fnsymbols[6])[1]"/>
      <xsl:variable name="count" select="1 + (($pos - 1) idiv 6)"/>
      <xsl:for-each select="1 to $count" expand-text="true">{ $sym }</xsl:for-each>
   </xsl:template>
   
</xsl:stylesheet>