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

   <xsl:import href="eve-reform.xsl"/>

   <!-- exposed as a top level parameter for SaxonJS but only used in template 'engineer-verse' -->
   <xsl:param name="eve-to-read" as="xs:string">ELECTRONIC VERSE ENGINEER eve-csx.xsl parameter $ eve-to-read default</xsl:param>
   
<!-- no-op template for loading makes event bindings available -->
   <xsl:template name="load_verse_engineer"/>
   
   <xsl:variable name="indented-xml" as="element()">
      <output:serialization-parameters
         xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
         <output:indent value="true"/>
         <output:omit-xml-declaration value="true"/>
      </output:serialization-parameters>
   </xsl:variable>
   
   <xsl:template match="/">
      <xsl:sequence select="pb:engineer-verse($eve-to-read)"/>
   </xsl:template>
   
   <xsl:template name="engineer-verse">
<!-- picks up text, processes it and returns it back:
         - as pretty HTML
         - as serialized EVE XML
         - a 'Save As' button pre-loaded for download
         - tbd a 'Save As TEI' option - goes in anthologizer.html
-->         
      <xsl:variable name="eve-xml" select="pb:engineer-verse($eve-to-read)"/>
      <xsl:if test="matches($eve-to-read,'\S')">
      <xsl:result-document href="#displaybox" method="ixsl:replace-content">
         <xsl:apply-templates select="$eve-xml" mode="plainhtml"/>
      </xsl:result-document>
      <xsl:variable name="filename" expand-text="true">{ $eve-xml/*/head/title/(. || '_') => normalize-space() => replace(' ','-') => encode-for-uri() }{ current-date() ! format-date(.,'[Y][M01][D01]') }.eve.xml</xsl:variable>
      <!-- add class 'ON' to turn off hiding -->
      <xsl:apply-templates select="ixsl:page()/id('evelink')" mode="show"/>         
      <xsl:result-document href="#everesults" method="ixsl:replace-content">
         <details>
            <summary>EVE XML <button onclick="offerDownload('eve-xml','{$filename}')">Save</button></summary>
            <pre id="eve-xml"><xsl:sequence select="$eve-xml => serialize()"/></pre>   
         </details>
      </xsl:result-document>
      </xsl:if>
<!--      <xsl:result-document href="#evelink" method="ixsl:replace-content">
         
      </xsl:result-document>-->
   </xsl:template>
   
   
   <xsl:template match="id('load-example')" mode="ixsl:onclick">
      <xsl:variable name="example-text-location" select="resolve-uri('johndonne-example1.eve.txt')"/>
      <ixsl:schedule-action document="{ $example-text-location }">
         <xsl:call-template name="load-eve">
            <xsl:with-param name="where" select="$example-text-location"/>
         </xsl:call-template>
      </ixsl:schedule-action>
   </xsl:template>
   
   <xsl:template name="load-eve">
      <xsl:param name="where" as="xs:anyURI" required="yes"/>
      <xsl:variable name="evetext" select="unparsed-text($where)"/>
      <ixsl:set-property name="value" object="id('evedata')" select="$evetext"/>
      <!--<xsl:result-document href="#evedata" method="ixsl:replace-content">
         <xsl:value-of select="$evetext"/>
      </xsl:result-document>-->
      <xsl:sequence select="ixsl:call(ixsl:window(),'engineerVerse',[$evetext])"/>
   </xsl:template>
   
   <xsl:template match="EVE" mode="plainhtml">
      <div class="EVE">
         <xsl:apply-templates mode="#current"/>
      </div>
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
   
   <xsl:template mode="ixsl:onmouseover" match="html:a[contains-token(@class,'fnr')]">
      <xsl:apply-templates select="key('div-by-href',@href)" mode="on"/>
   </xsl:template>
   
   <xsl:template mode="ixsl:onmouseout"  match="html:a[contains-token(@class,'fnr')]">
      <xsl:apply-templates select="key('div-by-href',@href)" mode="off"/>
   </xsl:template>
   
   <xsl:key name="div-by-href" match="html:div" use="'#' || @id"/>
   
   <xsl:template match="*" mode="off">
      <ixsl:set-attribute name="class"
         select="string-join( (tokenize(@class,'\s+')[not(. eq 'ON')]), ' ')"/>
   </xsl:template>
   
   <xsl:template match="*" mode="on">
      <ixsl:set-attribute name="class"
         select="string-join( (tokenize(@class,'\s+')[not(. eq 'ON')],'ON'), ' ')"/>
   </xsl:template>
   
   <xsl:template match="*" mode="show">
      <ixsl:set-attribute name="class"
         select="string-join( (tokenize(@class,'\s+')[not(. eq 'hidden')]), ' ')"/>
   </xsl:template>
   
   
   
   
</xsl:stylesheet>
