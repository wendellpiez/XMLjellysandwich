<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"


    xmlns:XJS="wendellpiez.com"
    exclude-result-prefixes="xs math XJS"
    version="3.0">
    
    <!--<xsl:strip-space elements="pub verse stanza"/>
    
    <xsl:output indent="yes"/>-->
    
<!-- breaks text nodes at (certain) punctuation and annotates them with delays.
     Delays are accrued from the start of the poem (that is, scoped across the document) -->
    
    <xsl:mode name="copy"     on-no-match="shallow-copy"/>
    <xsl:mode name="breakout" on-no-match="shallow-copy"/>
    <xsl:mode name="accrue"   on-no-match="shallow-copy"/>
    
    
    <xsl:template match="/" name="mark-time">
        <xsl:variable name="breakout">
          <xsl:apply-templates mode="breakout"/>
        </xsl:variable>
        <!--<xsl:copy-of select="$breakout"/>-->
        <xsl:apply-templates select="$breakout" mode="accrue"/>
    </xsl:template>
    
    <xsl:template match="l//text()" mode="breakout">
        <xsl:analyze-string select="." regex="[^,;\.]*[,;\.]">
            <xsl:matching-substring>
                <xsl:apply-templates select="." mode="delay"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <d0>
                    <xsl:value-of select="."/>
                </d0>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template match=".[ends-with(.,'.')]" mode="delay">
        <dp>
            <xsl:value-of select="."/>
        </dp>
    </xsl:template>
    
    <xsl:template match=".[ends-with(.,',')]" mode="delay">
        <dc>
            <xsl:value-of select="."/>
        </dc>
    </xsl:template>
    <xsl:template match=".[ends-with(.,';')]" mode="delay">
        <ds>
            <xsl:value-of select="."/>
        </ds>
    </xsl:template>
    
    <xsl:accumulator name="delay" initial-value="0">
        <xsl:accumulator-rule match="stanza | l | dc | ds | dp" select="$value + XJS:incr(.)"/>
    </xsl:accumulator>
    
    <xsl:template mode="pause" match="*"      as="xs:integer">0</xsl:template>
    <xsl:template mode="pause" match="stanza" as="xs:integer">12</xsl:template>
    <xsl:template mode="pause" match="l"      as="xs:integer">1</xsl:template>
    <xsl:template mode="pause" match="dc"     as="xs:integer">3</xsl:template>
    <xsl:template mode="pause" match="ds"     as="xs:integer">5</xsl:template>
    <xsl:template mode="pause" match="dp"     as="xs:integer">7</xsl:template>
    
    <xsl:function name="XJS:incr" as="xs:integer">
        <xsl:param name="who" as="element()"/>
        <xsl:apply-templates mode="pause" select="$who"/>
    </xsl:function>
    
    <xsl:template match="d0 | dc | ds | dp" mode="accrue">
        <d d="{accumulator-before('delay') - XJS:incr(.) }">
            <xsl:apply-templates mode="#current"/>
        </d>
    </xsl:template>
    
   
    
    
        
</xsl:stylesheet>