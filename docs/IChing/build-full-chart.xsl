<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://wendellpiez.com/iching"
    xpath-default-namespace="http://wendellpiez.com/iching" 
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">

   <xsl:import href="enhance-bagua.xsl"/>
    
    <xsl:output indent="yes"/>

<!-- Produces a full chart of hexagrams, in binary order, yin first -->
<!-- Useful for testing and analysis -->
    <xsl:template match="/">
        <xsl:copy-of select="$annotated-bagua"/>
    </xsl:template>
    
    
    <xsl:variable name="annotated-bagua">
        <!-- annotates a tree of hexes -->
        <xsl:apply-templates select="$binary-bagua" mode="annotate"/>
    </xsl:variable>

    <xsl:template match="*[empty(*)]" mode="annotate">
        <xsl:copy>
            <xsl:apply-templates select="." mode="draw-a-line"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*" mode="annotate">
        <xsl:copy>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:variable name="binary-bagua">
        <xsl:call-template name="yin-first-bagua"/>
    </xsl:variable>

    <!-- p 722 Richard Wilhelm (Bollingen ed.) -->
    <xsl:template mode="draw" match="日">———————</xsl:template>
    <xsl:template mode="draw" match="日[@to = '月']">———o———</xsl:template>
    <xsl:template mode="draw" match="月">——— ———</xsl:template>
    <xsl:template mode="draw" match="月[@to = '日']">———x———</xsl:template>

    <xsl:template match="*" mode="draw-lines">
        <!-- have to go top down meaning starting from the deepest branch
             since the root of the tree is the base of the hex -->
        <xsl:apply-templates select="/descendant::*[empty(*)]" mode="draw-a-line"/>
    </xsl:template>

    <xsl:template match="*" mode="draw-a-line">
        <line>
            <xsl:apply-templates select="." mode="draw"/>
        </line>
        <!-- next one down, namely up -->
        <xsl:apply-templates select="parent::*" mode="draw-a-line"/>
    </xsl:template>

    <xsl:template name="yin-first-bagua">
        <xsl:param name="remaining" select="6"/>
        <xsl:if test="$remaining">
            <xsl:for-each select="('月', '日')">
                <xsl:element name="{.}">
                    <xsl:call-template name="yin-first-bagua">
                        <xsl:with-param name="remaining" select="$remaining - 1"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>