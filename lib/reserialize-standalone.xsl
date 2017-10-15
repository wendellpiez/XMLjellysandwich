<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
<!-- In order to normalize output, we reserialize.
    This ought to resolve all entities, XIncludes etc. etc.
    
    It may be convenient to extend here to improve whitespace,
    normalize namespace usage, and/or perform other interventions.  -->
  
  <xsl:output standalone="yes" encoding="UTF-8"/>
  
  <xsl:template match="/">
    <!--  <xsl:comment>Nothing for now</xsl:comment>-->
    <!-- Skipping PIs and comments at the top. -->
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="/*">
    <!-- Just copying the rest. -->
    <xsl:copy-of select="." copy-namespaces="no"/>
  </xsl:template>
  
  <!-- <xsl:template match="node() | @*">
     <xsl:copy copy-namespaces="no">
       <xsl:apply-templates select="node() | @*"/>
     </xsl:copy>
   </xsl:template>-->
  
  
</xsl:stylesheet>