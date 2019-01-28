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
    
    <xsl:output indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:variable name="page" select="."/>
    
    
    
    <xsl:key name="table-by-hexchar" match="table"
        use="tbody/tr[td[1]='character']/td[2]/normalize-space(.)"/>
    
    <xsl:key name="table-by-position" match="table"
        use="preceding-sibling::p[1]/replace(normalize-space(.),'^Hexagram (\d\d?).*','$1')"/>
    
    <xsl:template match="/" expand-text="true">
        <body>
        <xsl:for-each select="1 to 64">
            <xsl:variable name="table"
                select="key('table-by-position',string(.),$page)"/>
            <xsl:variable name="char" select="$table//tbody/tr[td='character']/td[2]/normalize-space(.)"/>
            <section class="hexagram { $char }">
                <header>{.} { $char } { $table/tbody/tr[td = 'Unicode name']/td[2] ! substring-after(.,'Hexagram for ') ! normalize-space(.)}</header>
                <xsl:apply-templates select="$table/preceding-sibling::p[1]"/>
                
            </section>
        </xsl:for-each>
        </body>
    </xsl:template>
    
    <xsl:template match="small | a | i">
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