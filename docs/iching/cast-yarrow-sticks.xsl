<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://wendellpiez.com/iching"
    version="3.0">
    
    <!-- produces an HTML page reporting the results
         of a cast according to yarrow-stalk probabilities
         (in yarrowcount.xsl) -->
    
    <xsl:import href="yarrowcount.xsl"/>
    
    <xsl:output indent="yes"/>
    
    <xsl:template match="/">
        <xsl:variable name="cast">
            <xsl:apply-imports/>
        </xsl:variable>
        
        <html>
            <head>
                <title xsl:expand-text="true">I Ching Reading: { $cast/*/@time }</title>
            </head>
            <body>
                <xsl:apply-templates select="$cast" mode="read"/>
            </body>
        </html>
        <!--<xsl:copy-of select="$cast"/>-->
        
    </xsl:template>
    
    <xsl:template mode="read" match="reading" expand-text="true">
        <h2>I Ching reading: { @time }</h2>
        <xsl:apply-templates mode="read"/>
    </xsl:template>
    
    <xsl:variable name="kingwen" select="document('refined-kingwen-list.xhtml')"/>
    
    <xsl:key name="section-by-char"
        xpath-default-namespace="http://www.w3.org/1999/xhtml" match="section" use="tokenize(@class,'\s+')[2]"/>
    
    
    <xsl:template match="current" mode="read">
        <div class="hex current">
<!-- draw an SVG here :-) -->
            <xsl:apply-templates mode="read" select="key('section-by-char',@char,$kingwen)/header"/>
         
         <xsl:apply-templates select="." mode="changing"/>
            
            <!--<xsl:copy-of select="."/>-->
           
            <xsl:apply-templates mode="read" select="key('section-by-char',@char,$kingwen)/(* except header)"/>
            
        </div>
    </xsl:template>
 
    <xsl:template match="current" mode="changing">
        <p class="changing">
            <xsl:text>Changing lines: </xsl:text>
            <xsl:for-each select="descendant::*[exists(@to)]">
                <xsl:if test="not(position() eq 1)">, </xsl:if>
                
                <xsl:apply-templates select="." mode="changing"/>
            </xsl:for-each>
        </p>
    </xsl:template>
    
    <xsl:template match="current[empty(descendant::*/@to)]" mode="changing">
        <p class="changing">No lines are changing</p>
    </xsl:template>
    
    <xsl:template mode="changing" match="*">
        <xsl:variable name="pos" select="count(ancestor::*) -1"/>
        <xsl:variable name="pseudo-date" select="'2000-01-0' || $pos"/>
        <xsl:variable name="eng" select="xs:date($pseudo-date) ! format-date(.,'[Dwo]')"/>
        <xsl:apply-templates select="." mode="name"/>
        <xsl:text expand-text="true"> in { $eng} place</xsl:text>
    </xsl:template>
    
    <xsl:template mode="name" match="日">nine</xsl:template>
    <xsl:template mode="name" match="月">six</xsl:template>
    
        
    <xsl:template match="becoming" mode="read">
        <div class="hex becoming">
            <xsl:apply-templates mode="read" select="key('section-by-char',@char,$kingwen)"/>
        </div>
    </xsl:template>
    
    <xsl:template mode="read" xpath-default-namespace="http://www.w3.org/1999/xhtml" match="section">
        <xsl:apply-templates mode="read"/>
    </xsl:template>
    <xsl:template mode="read" xpath-default-namespace="http://www.w3.org/1999/xhtml" match="section/header">
        <h1>
            <xsl:apply-templates mode="read"/>
        </h1>
    </xsl:template>
    
    <xsl:template match="text()" mode="read">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <xsl:mode name="read" on-no-match="shallow-copy"/>
</xsl:stylesheet>