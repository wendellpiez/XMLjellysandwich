<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0"
    version="3.0">
    
    <xsl:output indent="yes" method="text"/>
    
    <xsl:variable as="map(*)" name="pretty-json">
        <xsl:map>
            <xsl:map-entry key="'indent'" select="true()"/>
        </xsl:map>
    </xsl:variable>
    
    <xsl:template match="/" mode="as-json" name="as-json">
        <xsl:variable name="xpath-json">
            <xsl:apply-templates select="/catalog"/>
        </xsl:variable>
        <xsl:value-of select="xml-to-json($xpath-json,$pretty-json)"/>
    </xsl:template>
    
    <xsl:template match="/catalog">
        <map>
            <string key="name">
                <xsl:value-of select="/descendant::title[1]"/>
            </string>
            <xsl:call-template name="make-children"/>
        </map>
          
    </xsl:template>
    
    <xsl:template name="make-children">
        <xsl:param name="along-with" select="()"/>
        <xsl:for-each-group select="$along-with | group | control | subcontrol | param" group-by="true()">
            <array key="children">
                <xsl:apply-templates select="current-group()"/>
            </array>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="group | control | subcontrol">
        <map>
            <string key="classer" xsl:expand-text="true">{ local-name() }</string>
            <xsl:call-template name="make-name"/>
            <xsl:call-template name="make-children">
                <xsl:with-param name="along-with" select="part[@name='statement']"></xsl:with-param>
            </xsl:call-template>
        </map>
    </xsl:template>
    
    <xsl:template name="make-name">
        <string key="name">
            <xsl:value-of select="(prop[@name = 'label'][1], @id/upper-case(.))[1]"/>
            
        </string>
        <string key="desc">
            <xsl:for-each select="title">
                <xsl:apply-templates/>
                <xsl:if test="prop[@name='status']=('Withdrawn','withdrawn')"> (Withdrawn)</xsl:if>
            </xsl:for-each>
        </string>
    </xsl:template>
    
    <xsl:template match="control[prop[@name='status']=('Withdrawn','withdrawn')]">
        <map>
            <string key="classer" xsl:expand-text="true">{ local-name() }</string>
            <xsl:call-template name="make-name"/>
            <number key="size">50</number>
        </map>
    </xsl:template>
    
    <xsl:template match="param">
        <map>
            <string key="classer">param</string>
            <string key="name">parameter</string>
            <string key="desc"><xsl:value-of select="@id"/></string>
            <number key="size">30</number>
        </map>
    </xsl:template>
    
    <xsl:template match="part[@name='statement']">
        <map>
            <string key="classer">stmt</string>
            <string key="name">statement</string>
            <string key="desc" xsl:expand-text="true">{ count(tokenize(.,'\s+')) } words { count(.//insert) !
               (. || ( if (. eq 1) then ' insertion' else ' insertions') ) }</string>
                    <number key="size">
                    <xsl:value-of select="floor(string-length(.) div 10) + (count(descendant::insert) * 2)"/>
                </number>
            
        </map>
    </xsl:template>
    
    
    
</xsl:stylesheet>