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
   <xsl:template mode="ixsl:onmouseover" match="html:a[contains-token(@class,'fnr')]">
      <xsl:apply-templates select="key('html-internal',@href)" mode="on"/>
   </xsl:template>
   
   <xsl:template mode="ixsl:onmouseout"  match="html:a[contains-token(@class,'fnr')]">
      <xsl:apply-templates select="key('html-internal',@href)" mode="off"/>
   </xsl:template>
   
   <xsl:key name="html-internal" match="html:*" use="'#' || @id"/>
   
   <xsl:key name="div-by-href" match="html:div" use="'#' || @id"/>
   
   <xsl:template match="*" mode="off">
      <ixsl:set-attribute name="class" select="(tokenize(@class,'\s+')[not(. eq 'ON')]) => string-join(' ')"/>
   </xsl:template>
   
   <xsl:template match="*" mode="on">
      <ixsl:set-attribute name="class" select="(tokenize(@class,'\s+')[not(. eq 'ON')],'ON') => string-join(' ')"/>
   </xsl:template>
   
   
   <xsl:template match="EVE" mode="plainhtml">
      
      <main class="EVE">
         <xsl:apply-templates mode="#current"/>
      </main>
   </xsl:template>
   
   <xsl:template match="head" mode="plainhtml">
      <div class="head">
         <xsl:apply-templates mode="#current" select="title, author, date"/>
      </div>
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
   
   
   <xsl:template match="verse | group" mode="plainhtml">
      <div class="{ local-name() }">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   
   <xsl:template match="verse | group" mode="plainhtml">
      <div class="{ local-name() }">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   
   <xsl:template match="p" mode="plainhtml">
      <p class="p">
         <xsl:apply-templates mode="#current"/>
      </p>
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
      
   <xsl:template match="note" mode="plainhtml">
      <div class="sidenote">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   
   <xsl:template match="notes" mode="plainhtml">
      <div id="endnotes">
         <xsl:apply-templates mode="#current"/>
      </div>
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