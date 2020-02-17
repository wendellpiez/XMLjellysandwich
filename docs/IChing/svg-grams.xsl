<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0"
    xmlns="http://www.w3.org/2000/svg"
    xpath-default-namespace="http://wendellpiez.com/iching">
    
    <!-- DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
           "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd" -->
    
    <xsl:template match="*" mode="svg-gram">
        <xsl:param name="dimension">12em</xsl:param>
        <!--override either of these for specialized applications -->
        <xsl:param name="manner" tunnel="yes">hex</xsl:param>
        <xsl:param name="contents">
            <xsl:apply-templates/>
        </xsl:param>
        <svg width="{$dimension}" height="{$dimension}" viewBox="0 0 80 80">
            <desc>SVG gram</desc>
            <g transform="translate(0 75)">
                <xsl:apply-templates select="." mode="draw-line"/>
            </g>
        </svg>
    </xsl:template>
    
        <!--
        <xsl:template mode="draw" match="日">———————</xsl:template>
        <xsl:template mode="draw" match="日[@to = '月']">———o———</xsl:template>
        <xsl:template mode="draw" match="月">——— ———</xsl:template>
        <xsl:template mode="draw" match="月[@to = '日']">———x———</xsl:template>-->
    <xsl:template match="*" mode="draw-line">
        <g transform="translate(0 -10)">
            <xsl:apply-templates select="." mode="svg-line"/>
            <xsl:apply-templates mode="#current"/>
        </g>
    </xsl:template>
    
    <xsl:template mode="svg-line" match="*" expand-text="true">
        <text>{ name() }</text>
    </xsl:template>
        <xsl:template mode="svg-line" match="日"><!--———————-->
            <text font-size="6" y="2">8</text>
            <path d="m 10 0 h 60" stroke-width="6" stroke="black" fill="none"/>
        </xsl:template>
            
        <xsl:template mode="svg-line" match="日[@to = '月']"><!--———o———-->
            <text font-size="6" y="2">9</text>
            <path d="m 10 0 h 60" stroke-width="6" stroke="black" fill="none"/>
            <!--<path d="m 35 0 h 10" stroke-width="2" stroke="red" fill="none"/>-->
            <circle cx="40" cy="0" r="1" fill="white"/>
        </xsl:template>
        <xsl:template mode="svg-line" match="月"><!--——— ———-->
            <text font-size="6" y="2">7</text>
            <path d="m 10 0 h 25" stroke-width="6" stroke="black" fill="none"/>
            <path d="m 45 0 h 25" stroke-width="6" stroke="black" fill="none"/>
        </xsl:template>
        <xsl:template mode="svg-line" match="月[@to = '日']"><!--———x———-->
            <text font-size="6" y="2">6</text>
            <path d="m 10 0 h 25" stroke-width="6" stroke="black" fill="none"/>
            <path d="m 45 0 h 25" stroke-width="6" stroke="black" fill="none"/>
            <!--<path d="m 35 0 h 10" stroke-width="2" stroke="red" fill="none"/>-->
            <circle cx="40" cy="0" r="1" fill="black"/>
        </xsl:template>
        
</xsl:stylesheet>