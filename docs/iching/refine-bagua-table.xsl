<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.w3.org/1999/xhtml">
    
<!-- incidental XSLT (gets run once) to reduce raw-bagua-table down
     into a legible form for further processing. -->
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="@*"/>
    
    <xsl:template match="img/@alt">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="img" priority="1">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="td//*">
        <xsl:apply-templates/>
    </xsl:template>
    <!--<xsl:template match="*[exists(br)]">
        <xsl:variable name="here" select="."/>
        <xsl:for-each-group select="node()" group-adjacent="exists(self::br)">
            <xsl:if test="not(current-grouping-key())">
                <xsl:for-each select="$here">
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="current-group()"/>
                </xsl:copy>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>-->
    
</xsl:stylesheet>