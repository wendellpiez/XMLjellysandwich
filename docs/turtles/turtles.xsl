<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:svg="http://www.w3.org/2000/svg">
    
    <xsl:variable name="specs" select="/svg:svg/svg:defs/svg:g[@id='specs']/*"/>
    
    <xsl:template match="* | @*">
        <xsl:copy>
            <xsl:apply-templates select="* | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="svg:g[@id='pond']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="svg:defs//svg:use">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="svg:use">
        <xsl:apply-templates select="." mode="spawn"/>
    </xsl:template>
    
    <xsl:template match="svg:use" mode="spawn">
        <xsl:param name="gen" select="42"/>
        <xsl:if test="$gen &gt;= 1">
            <xsl:apply-templates mode="round" select="$specs">
                <xsl:with-param name="who" select="."/>
                <xsl:with-param name="gen" select="$gen"/>
            </xsl:apply-templates>
        </xsl:if>
     
    </xsl:template>
    
    <xsl:template match="*" mode="round">
        <xsl:param name="who"/>
        <xsl:param name="gen"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="round">
                <xsl:with-param name="who" select="$who"/>
                <xsl:with-param name="gen" select="$gen"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="svg:g[@id='specs']"/>
    
    <xsl:template match="svg:g[@id='spawn']" mode="round">
        <xsl:param name="who"/>
        <xsl:param name="gen"/>
        <xsl:variable name="tag" select="concat('turtle_',$gen)"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="$who"/>
            <xsl:apply-templates select="$who" mode="spawn">
                <xsl:with-param name="gen" select="$gen - 1"/>
            </xsl:apply-templates>
                    <!--</g>-->
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>