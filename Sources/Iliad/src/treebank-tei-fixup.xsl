<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math"
  version="3.0"  expand-text="true"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xsl:template match="body">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each-group select="l" group-by="tokenize(@n,'\.')[1]">
        <xsl:sort select="current-grouping-key() => number()" data-type="number"/>
        <div type="book" n="{ current-grouping-key() }">
          <xsl:apply-templates select="current-group()"/>
        </div>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
 
  
</xsl:stylesheet>