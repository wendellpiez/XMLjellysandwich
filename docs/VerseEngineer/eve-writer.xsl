<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math pb eve"
  xmlns="http://pellucidliterature.org/VerseEngineer"
  xpath-default-namespace="http://pellucidliterature.org/VerseEngineer"
  xmlns:eve="http://pellucidliterature.org/VerseEngineer"
  default-mode="eve:write-eve"
  version="3.0">
  
  <xsl:output method="text"/>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:preserve-space elements="p line attrib b i"/>
  
  <xsl:template mode="eve:write-eve" match="text()[not(matches(.,'\S'))]"/>
  
  <xsl:template mode="eve:write-eve" match="p//text() | line//text() | attrib//text()" priority="100">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="head/*" mode="eve:write-eve">
    <xsl:text expand-text="true">{ preceding-sibling::*[1]/'&#xA;' }{ local-name() }: </xsl:text>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="section" mode="eve:write-eve">
    <xsl:text expand-text="true">{ preceding-sibling::section[1]/'&#xA;' }</xsl:text>
    <xsl:apply-templates select="title" mode="#current"/>
    <xsl:text expand-text="true">&#xA;---</xsl:text>
    <xsl:value-of select="title => replace('.','-') => substring(4)"/>
    <xsl:apply-templates select="* except title" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="epigraph | verse | title" mode="eve:write-eve">
    <xsl:text>&#xA;</xsl:text>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="p | line" mode="eve:write-eve">
    <xsl:if test="parent::section or not(. is ../child::*[1])">
      <xsl:apply-templates select="." mode="eve:inset-LF"/>
    </xsl:if>
    <xsl:apply-templates select="." mode="eve:inset-LF"/>
    <xsl:apply-templates mode="#current" select="@ind"/>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="note/*[1]/self::p" mode="eve:write-eve">
    <xsl:text> </xsl:text>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="verse/line" mode="eve:write-eve">
    <xsl:apply-templates select="." mode="eve:inset-LF"/>
    <xsl:apply-templates mode="#current" select="@ind"/>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="line/@ind" mode="eve:write-eve">
    <xsl:text expand-text="true">{ ( (1 to xs:integer(.)) ! ' ' ) => string-join() }</xsl:text>
  </xsl:template>
  
  <xsl:template match="attrib" mode="eve:write-eve">
    <xsl:apply-templates select="." mode="eve:inset-LF"/>
    <xsl:text>-- </xsl:text>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="i" mode="eve:write-eve">
    <xsl:text>*</xsl:text>
    <xsl:apply-templates mode="#current"/>
    <xsl:text>*</xsl:text>
  </xsl:template>
  
  <xsl:template match="b" mode="eve:write-eve">
    <xsl:text>**</xsl:text>
    <xsl:apply-templates mode="#current"/>
    <xsl:text>**</xsl:text>
  </xsl:template>
  
  <xsl:template match="fnr" mode="eve:write-eve">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="@ref"/>
    <xsl:text>]</xsl:text>
  </xsl:template>
  
  <xsl:template match="note" mode="eve:write-eve">
    <xsl:text>&#xA;&#xA;[[</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>]]</xsl:text>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  
  <xsl:template match="*" mode="eve:inset-LF">
    <xsl:text>&#xA;</xsl:text>
    <xsl:text expand-text="true">{ (ancestor::inset|ancestor::epigraph)/'>' }{ (ancestor::inset|ancestor::epigraph)[1]/' ' }</xsl:text>
  </xsl:template>  
</xsl:stylesheet>