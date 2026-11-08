<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:XJS="http://github.com/wendellpiez/XMLjellysandwich"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0"
                extension-element-prefixes="ixsl"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="XJS"
                expand-text="true"
    default-mode="lexicography">

<!-- features Todo -->

   <xsl:template mode="lexicography" match="TEI">
      <div class="TEI">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   
   <xsl:template mode="lexicography" match="teiHeader">
      <details class="teiHeader">
         <summary>TEI Header</summary>
         <xsl:apply-templates mode="#current"/>
      </details>
   </xsl:template>
   <xsl:template mode="lexicography" match="fileDesc">
      <div class="fileDesc">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   <xsl:template mode="lexicography" match="titleStmt">
      <div class="titleStmt">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   <xsl:template mode="lexicography" match="respStmt">
      <div class="respStmt">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   <xsl:template mode="lexicography" match="publicationStmt">
      <div class="publicationStmt">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   <xsl:template mode="lexicography" match="sourceDesc">
      <div class="sourceDesc">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   <xsl:template mode="lexicography" match="biblStruct">
      <div class="biblStruct">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   <xsl:template mode="lexicography" match="monogr">
      <span class="monogr">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   <xsl:template mode="lexicography" match="imprint">
      <span class="imprint">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   
   <xsl:template mode="lexicography" match="encodingDesc"/>
   
   <xsl:template mode="lexicography" match="refsDecl"/>
   
   <xsl:template mode="lexicography" match="profileDesc"/>
   
   <xsl:template mode="lexicography" match="revisionDesc"/>
   
   <xsl:template mode="lexicography" match="text">
      <div class="text">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   <xsl:template mode="lexicography" match="body">
      <div class="body">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   
   <xsl:template mode="lexicography" match="pb"/>
   
   <xsl:template mode="lexicography" match="div">
      <div class="div">
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   
   <xsl:template mode="lexicography" match="div/div/*" priority="0.1">
      <span class="{ local-name() }">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   
   <xsl:template mode="lexicography" match="cit">
      <span class="cit">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   
   <xsl:template match="teiHeader//*" mode="lexicography" priority="-0.1">
      <span class="{ local-name() }">
         <xsl:apply-templates/>
      </span>
   </xsl:template>
   
   
   <xsl:template mode="lexicography" match="p">
      <p class="p">
         <xsl:apply-templates mode="#current"/>
      </p>
   </xsl:template>
   <xsl:template mode="lexicography" match="language">
      <p class="language">
         <xsl:apply-templates mode="#current"/>
      </p>
   </xsl:template>
   <xsl:template mode="lexicography" match="change">
      <p class="change">
         <xsl:apply-templates mode="#current"/>
      </p>
   </xsl:template>
   
   <xsl:template mode="lexicography" match="head">
      <p class="head">
         <xsl:apply-templates mode="#current"/>
      </p>
   </xsl:template>
   
   <xsl:template mode="lexicography" match="title">
      <span class="title">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   <xsl:template mode="lexicography" match="author">
      <span class="author">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   
   <xsl:template mode="lexicography" match="foreign" priority="1">
      <i class="foreign">
         <xsl:apply-templates mode="#current"/>
      </i>
   </xsl:template>
   <!--<xsl:template mode="lexicography" match="foreign[@xml:lang='greek']">
         <xsl:apply-templates mode="#current"/>
   </xsl:template>-->
   
   <xsl:template mode="lexicography" match="term">
      <span class="term">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   
   <xsl:template mode="lexicography" match="ref" priority="1">
      <span class="ref" data-target="{ @target }">
         <xsl:apply-templates mode="#current"/>
      </span>
      
   </xsl:template>
   <!--<ref xml:lang="greek" target="protos-cunliffe-lex">πρῶτος</ref>-->
   
   
   
   <xsl:template mode="lexicography" match="gloss">
      <span class="gloss">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   <xsl:template mode="lexicography" match="quote">
      <xsl:text>&#8220;</xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>&#8221;</xsl:text>      
   </xsl:template>
   
   <xsl:template mode="lexicography" match="bibl">
      <span class="bibl">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   
   <xsl:template mode="lexicography" match="bibl[starts-with(@n,'Perseus:abo:tlg,0012,001:')]" priority="101" >
      <xsl:param name="word" tunnel="true" required="yes"/>
      <xsl:variable name="lineNo">line_{ substring-after(@n,'Perseus:abo:tlg,0012,001:') => replace(':','-') }</xsl:variable>
      <span class="bibl" data-lineNo="{ $lineNo }">
         <xsl:if test="$lineNo = $word/parent::*/@id">
            <xsl:attribute name="class">foundMe bibl</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   
   <xsl:template mode="lexicography" match="hi">
      <span class="hi">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   <xsl:template mode="lexicography" match="note">
      <span class="note">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   <xsl:template mode="lexicography" match="mod">
      <span class="mod">
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
   
   <xsl:template name="css" expand-text="false">
      <style type="text/css">
html, body { font-size: 10pt }
div { margin-left: 1rem }
.tag { color: green; font-family: sans-serif; font-size: 80%; font-weight: bold }


.TEI { }

.teiHeader { }

.fileDesc { }

.titleStmt { }

.title {  display: inline; }

.author {  display: inline; }

.editor { }

.sponsor { }

.principal { }

.respStmt { }

.persName { }

.resp { }

.name { }

.funder { }

.extent { }

.publicationStmt { }

.publisher { }

.pubPlace { }

.authority { }

.sourceDesc { }

.biblStruct { }

.monogr { }

.imprint { }

.date { }

.encodingDesc { }

.refsDecl { }

.cRefPattern { }

.p { }

.profileDesc { }

.langUsage { }

.language { }

.revisionDesc { }

.change { }

.text { }

.body { }

.pb { }

.head { }

.div { }

.foreign {  display: inline; }

.term {  display: inline; }

.ref {  display: inline; }

.gloss {  display: inline; }

.cit { }

.quote {  display: inline; }

.bibl {  display: inline; }

.hi {  display: inline; }

.note {  display: inline; }

.mod {  display: inline; }

</style>
   </xsl:template>
   <xsl:template priority="-0.4"
                 match="TEI | teiHeader | fileDesc | titleStmt | respStmt | publicationStmt | sourceDesc | biblStruct | monogr | imprint | encodingDesc | refsDecl | cRefPattern | profileDesc | langUsage | revisionDesc | text | body | pb | div | cit" mode="lexicography">
      <div class="{name()}">
         <div class="tag">
            <xsl:value-of select="name()"/>: </div>
         <xsl:apply-templates mode="#current"/>
      </div>
   </xsl:template>
   <xsl:template priority="-0.4"
                 match="editor | sponsor | principal | persName | resp | name | funder | extent | publisher | pubPlace | authority | date | p | language | change | head" mode="lexicography">
      <p class="{name()}">
         <span class="tag">
            <xsl:value-of select="name()"/>: </span>
         <xsl:apply-templates mode="#current"/>
      </p>
   </xsl:template>
   <xsl:template priority="-0.4"
                 match="title | author | foreign | term | ref | gloss | quote | bibl | hi | note | mod" mode="lexicography">
      <span class="{name()}">
         <span class="tag">
            <xsl:value-of select="name()"/>: </span>
         <xsl:apply-templates mode="#current"/>
      </span>
   </xsl:template>
</xsl:stylesheet>
