<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math"
  version="3.0"  expand-text="true">
  
  <!-- Unprefixed namespace in content is TEI; unprefixed XPath names match no-namespace -->
  
  <xsl:mode use-accumulators="citation"/>
  
  <xsl:accumulator name="citation" initial-value="'0'">
    <xsl:accumulator-rule match="*[matches(@cite,'\S')]" select="string(@cite)" phase="start"/>
  </xsl:accumulator>
  
  <xsl:template match="/treebank">
    <TEI>
      <xsl:copy-of select="header"/>
      <teiHeader>
        <xsl:comment> TODO: HEADER </xsl:comment>
      </teiHeader>
      <xsl:apply-templates select="body"/>
    </TEI>
  </xsl:template>
  
  
  <!-- Just making lines, not grouping into books -->
  <xsl:template match="body">
    <body>
      <xsl:for-each-group select="descendant::word" group-by="accumulator-after('citation')">
        <l id="{ current-grouping-key() }" n="{ tokenize(current-grouping-key(), ':')[last()] }">
          <xsl:variable name="line_cit">Perseus:abo:tlg,0012,001:{ parent::l/replace(@n,'\.',':') }</xsl:variable>
          <xsl:apply-templates select="current-group()"/>
        </l>        
      </xsl:for-each-group>
    </body>
  </xsl:template>
  
  <xsl:template match="word">
    <xsl:text>{ position()[. > 1] ! ' ' }</xsl:text>
    <w sntnc="{ parent::sentence/@id }">
      <xsl:apply-templates select="@*"/>
      <xsl:text>{ @form }</xsl:text>
    </w>
  </xsl:template>
  
  <xsl:template priority="101" match="word[@postag='u--------']">
    <punct>{ @form }</punct>
  </xsl:template>
  
  <xsl:template priority="1001" match="word[empty(@postag)]"/>
    
  <xsl:template match="word/@*"/>
  
  <xsl:template match="word/@lemma | word/@postag" priority="101">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  
</xsl:stylesheet>