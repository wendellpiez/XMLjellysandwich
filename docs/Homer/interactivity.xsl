<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    extension-element-prefixes="ixsl"
    expand-text="true"
    version="3.0">
    
    <!-- Called by lexicalDisplay.xsl, this XSLT binds unprefixed names
    to the HTML namespace -->
    
    
    <xsl:variable name="cunliffe-file" select="'cunliffe.lexentries.unicode.xml'"/>
    <xsl:variable name="cunliffe"      select="document($cunliffe-file)"/>
    
    <xsl:key name="lexentry-for-lemma" match="tei:div" use="@n"/>
    
    <xsl:key name="lexentry-for-id" match="tei:div" use="@xml:id"/>
    
    <xsl:template name="initialize-lexicon">
        <ixsl:schedule-action document="{ $cunliffe-file }">
          <xsl:call-template name="insert-cunliffe-header"/>
        </ixsl:schedule-action>
    </xsl:template>
    
    <xsl:template name="insert-cunliffe-header">
        <xsl:result-document href="#lexicon" method="ixsl:replace-content">
            <xsl:apply-templates mode="lexicography" select="$cunliffe/*/tei:teiHeader"/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:import href="expand-tb-postagging.xsl"/>
    
    <xsl:template mode="ixsl:onclick" match="span[contains-token(@class,'w')]">
        <xsl:variable name="pos_markup" as="xs:string?">
            <xsl:apply-templates select="@data-postag" mode="expand-pos"/>
        </xsl:variable>
        <xsl:result-document href="#lexicon" method="ixsl:replace-content">
            <p>{ . } ({ @data-postag => substring(1, 1) => $POS() }): { $pos_markup }</p>
            <xsl:sequence>
                <xsl:apply-templates select="key('lexentry-for-lemma', @data-lemma, $cunliffe)"
                    mode="lexicography">
                    <xsl:with-param name="word" select="." tunnel="true"/>
                </xsl:apply-templates>
                <xsl:on-empty>
                    <p>[No lexicon entry is found for given lemma { @data-lemma }]</p>
                </xsl:on-empty>
            </xsl:sequence>
        </xsl:result-document>    
    </xsl:template>
    
    <xsl:template mode="ixsl:onclick" match="span[contains-token(@class,'ref')]">
        <xsl:result-document href="#lexicon" method="ixsl:replace-content">
            <p>{ . }: { @data-postag }</p>
            <xsl:sequence>
                <xsl:apply-templates select="key('lexentry-for-id', @data-target, $cunliffe)"
                    mode="lexicography"/>
            </xsl:sequence>
        </xsl:result-document>    
    </xsl:template>
    
    <xsl:template mode="ixsl:onclick" match="span[contains-token(@class,'bibl')]">
        <xsl:for-each select="id(@data-lineNo, ixsl:page())">
            <ixsl:set-property name="open" select="true()" object=".."/>
            <xsl:sequence select="ixsl:call(.,'scrollIntoView',[])"/>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>