<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns="http://wendellpiez.com/iching"
    exclude-result-prefixes="xs math"
    version="3.0">

    <xsl:import href="enhance-chart.xsl"/>
    
    <xsl:output indent="yes"/>

    <xsl:variable name="seed" select="/*"/>
    <!-- use the same seed, get the same answer -->

    <!-- so, mix it up further with this -->
    <xsl:param name="mantra" as="xs:string"> Blessings to all sentient beings </xsl:param>

    <xsl:variable name="hexagram">

        <!-- a hex is contructed as a tree, six nodes deep -->
        <xsl:call-template name="build-hex"/>
    </xsl:variable>

    <xsl:template name="build-hex">
        <!-- a hexagram is a tree six deep of monogram elements -->
        <xsl:call-template name="add-line"/>
    </xsl:template>

    <xsl:variable name="example">
        <日>
            <月>
                <月>
                    <月>
                        <日 to="月">
                            <日 to="月"/>
                        </日>
                    </月>
                </月>
            </月>
        </日>
    </xsl:variable>

    <xsl:variable name="dateString"
        select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01] [H01]:[m01]:[s01]')"/>

    <xsl:template name="add-line">
        <xsl:param name="seed" select="string($seed) || $dateString || $mantra"/>
        <xsl:param name="generator" select="random-number-generator($seed)"/>
        <xsl:param name="level" select="6"/>
        <!-- defaults six -->
        <!-- each line is a random choice among $probabilities -->
        <xsl:if test="$level gt 0">
            <!-- selecting a proxy for yarrow sorting -->
            <xsl:for-each select="$generator?permute($probabilities/*)[1]">
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:call-template name="add-line">
                        <xsl:with-param name="level" select="$level - 1"/>
                        <xsl:with-param name="generator" select="$generator?next()"/>
                    </xsl:call-template>
                </xsl:copy>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

   

    <xsl:template match="/">
        <reading time="{$dateString}">
            <current>
                <xsl:apply-templates select="$hexagram" mode="detail-hexagram"/>
                <!--<xsl:apply-templates select="$hexagram" mode="draw-lines"/>-->
            </current>
            <xsl:variable name="becoming">
                <xsl:apply-templates select="$hexagram" mode="transmute"/>
            </xsl:variable>
            <xsl:if test="not(deep-equal($hexagram, $becoming))">
                <becoming>
                    <xsl:apply-templates select="$becoming" mode="detail-hexagram"/>
                </becoming>
            </xsl:if>
        </reading>
    </xsl:template>
    
    <xsl:template match="/" mode="detail-hexagram">
        <xsl:attribute name="char">
            <xsl:apply-templates mode="hexagram" select="*/*/*/*/*/*"/>
        </xsl:attribute>
        <xsl:attribute name="upper">
            <xsl:apply-templates mode="trigram" select="*/*/*/*/*/*"/>
        </xsl:attribute>
        <xsl:attribute name="lower">
            <xsl:apply-templates mode="trigram" select="*/*/*"/>
        </xsl:attribute>
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="*" mode="transmute">
        <xsl:element name="{(@to,name())[1]}">
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>

    <xsl:variable name="probabilities" as="element()">
        <!-- ⚊ yang monogram ⚋ yin monogram -->
<!-- But we use kanji for sun and moon for Yang and Yin
     (element names)
        note their actual characters
        
        -->
        <!-- Probabilies are as given here: https://en.wikibooks.org/wiki/I_Ching/The_Ancient_Yarrow_Stalk_Method -->
        
        <chart>
            <日 to="月"/>
            <!-- changing yang -->
            <日 to="月"/>
            <日 to="月"/>
            <日/>
            <!-- steady yang -->
            <日/>
            <日/>
            <日/>
            <日/>
            <月/>
            <!-- steady yin -->
            <月/>
            <月/>
            <月/>
            <月/>
            <月/>
            <月/>
            <月 to="日"/>
            <!-- changing yin -->
        </chart>
    </xsl:variable>

    <!-- p 722 Richard Wilhelm (Bollingen ed.) -->
    <xsl:template mode="draw" match="日">———————</xsl:template>
    <xsl:template mode="draw" match="日[@to = '月']">———o———</xsl:template>
    <xsl:template mode="draw" match="月">——— ———</xsl:template>
    <xsl:template mode="draw" match="月[@to = '日']">———x———</xsl:template>

    <xsl:template match="*" mode="draw-lines">
        <!-- have to go top down meaning starting from the deepest branch
             since the root of the tree is the base of the hex -->
        <xsl:apply-templates select="/descendant::*[empty(*)]" mode="draw-line"/>
    </xsl:template>

    <xsl:template match="*" mode="draw-line">
        <line>
            <xsl:apply-templates select="." mode="draw"/>
        </line>
        <!-- next one down, namely up -->
        <xsl:apply-templates select="parent::*" mode="draw-line"/>
    </xsl:template>

    
</xsl:stylesheet>