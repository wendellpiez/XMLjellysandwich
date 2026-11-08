<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math"
  version="3.0"  expand-text="true"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  
  <!--Purpose: reads near-TEI ILIAD with Treebank markup produced in MAKE_REFERENCE_ILIAD.xpr
  
  annotates words with link to lexentry in Cunliffe data using the div/@xml:id
  -->
  
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xsl:variable name="cunliffe" select="document('../../Sources/gregorycrane/cunliffe.lexentries.unicode.xml')"/>
  
  <!-- <bibl n="Perseus:abo:tlg,0012,001:23:513">513</bibl> -->
  <xsl:key name="lexentry-for-appearance" match="body/div"
    use=".//bibl[starts-with(@n,'Perseus:abo:tlg,0012,001')]/@n"/>
  
  <xsl:template match="w">
    <xsl:variable name="lemma" select="@lemma[normalize-space(.)]"/>
    <!-- @id: urn:cts:greekLit:tlg0012.tlg001:1.1-->
    <xsl:variable name="line_cit">Perseus:abo:tlg,0012,001:{ tokenize(../@id,':')[last()] ! replace(.,'\.',':') }</xsl:variable>
    <xsl:variable name="cunliffe-listings"
      select="$cunliffe/key('lexentry-for-appearance', $line_cit)[@n = $lemma]"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="exists($cunliffe-listings)">
        <xsl:attribute name="lex" select="$cunliffe-listings/@xml:id" separator=" "/>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>