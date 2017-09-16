<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:XJS="http://github.com/wendellpiez/XMLjellysandwich"
  xmlns:xjs="http://github.com/wendellpiez/XMLjellysandwich"
  version="2.0"
  exclude-result-prefixes="#all">
  
  <!-- John Lumley suggests putting the ns prefix in upper case excellent idea -->
  <xsl:namespace-alias stylesheet-prefix="XJS" result-prefix="xsl"/>
  
  <xsl:output indent="yes"/>
  
  <!-- Set $xsl-version to 1.0 and you get an XSLT that will run in any old browser. -->
  <xsl:param name="xsl-version">3.0</xsl:param>
  
  <!-- The assumption is, elements in the input data sample will fall into
    three classes:
    'wrappers' are elements that never contain text directly, only elements.
    So blocks, divs, sections and other content structures are likely to be wrappers.
    'inlines' are those that appear next to content, such as 'italics' and 'bold' and
    what not, unless they are already wrappers. (Wrappers will remain wrappers.)
    'paras' (paragraphs) are those that contain text children, such as p and td, but
    do not appear next to text (so they are not inlines).
    'divs' are all elements except inlines and paragraphs, which amounts to $wrappers.
       -->

<xsl:variable name="element-analysis">
  <!-- a little tree of element descriptors.
    Its traversal can be limited by adjusting the path (e.g. to leave out //teiHeader elements) -->
  <xsl:for-each-group select="//*" group-by="name()">
    <element name="{current-grouping-key()}"
      has-text-children="{ exists(current-group()/text()[matches(.,'\S')]) }"
      has-text-siblings="{ exists(current-group()/../text()[matches(.,'\S')]) }"/>
  </xsl:for-each-group>
</xsl:variable>
      
  <xsl:variable name="lf"> <xsl:text>&#xA;</xsl:text></xsl:variable>
  <xsl:variable name="lf2"><xsl:text>&#xA;&#xA;</xsl:text></xsl:variable>
  
  <xsl:variable name="wrappers" select="$element-analysis/*[@has-text-children='false']"/>
  
  <!-- We only need to match the following; $wrappers are determined only to help determine the others. -->
  <xsl:variable name="inlines"  select="$element-analysis/*[@has-text-siblings='true'] except $wrappers"/>
  <xsl:variable name="paras"    select="$element-analysis/*[@has-text-children='true'] except $inlines"/>
  <!-- Since $divs is everything but $paras and $inlines, this amounts to $wrappers -->
  <xsl:variable name="divs"     select="$element-analysis/* except ($inlines|$paras)"/>
  
  
  <xsl:template match="/">
    <XJS:stylesheet version="{$xsl-version}"
      extension-element-prefixes="ixsl">
      <xsl:namespace name="xs">http://www.w3.org/2001/XMLSchema</xsl:namespace>
      <xsl:namespace name="xjs">http://github.com/wendellpiez/XMLjellysandwich</xsl:namespace>
      <xsl:namespace name="ixsl">http://saxonica.com/ns/interactiveXSLT</xsl:namespace>
      <xsl:copy-of select="//namespace::*[not(name()='')]"/>
      <xsl:for-each select="//namespace::*[name()='']">
        <xsl:attribute name="xpath-default-namespace">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:for-each>
      <!--<xsl:copy-of select="$element-analysis"/>-->
      
      <xsl:copy-of select="$lf2"/>
      <xsl:comment>Starter XSLT written courtesy of XML Jelly Sandwich </xsl:comment>
      <xsl:copy-of select="$lf2"/>
      <XJS:template name="xmljellysandwich_pack">
        <xsl:copy-of select="$lf"/>
        <xsl:comment> Target page components by assigning transformation results to them via their IDs in the host page. </xsl:comment>
        <xsl:copy-of select="$lf"/>
        <XJS:result-document href="#xmljellysandwich_body">
            <XJS:apply-templates/>
        </XJS:result-document>
      </XJS:template>
      
      <xsl:for-each-group select="$divs" group-by="@name">
        <xsl:copy-of select="$lf2"/>
        <XJS:template mode="asleep" match="{current-grouping-key()}">
          <div class="{current-grouping-key()}">
            <XJS:apply-templates/>
          </div>
        </XJS:template>
      </xsl:for-each-group>
      <xsl:for-each-group select="$paras" group-by="@name">
        <xsl:copy-of select="$lf2"/>
        <XJS:template mode="asleep" match="{current-grouping-key()}">
          <p class="{current-grouping-key()}">
            <XJS:apply-templates/>
          </p>
        </XJS:template>
      </xsl:for-each-group>
      <xsl:for-each-group select="$inlines" group-by="@name">
        <xsl:copy-of select="$lf2"/>
        <XJS:template mode="asleep" match="{current-grouping-key()}">
          <span class="{current-grouping-key()}">
            <XJS:apply-templates/>
          </span>
        </XJS:template>
      </xsl:for-each-group>
      
      <xsl:copy-of select="$lf2"/>
      <XJS:template name="css">
        <style type="text/css">
          <xsl:text>
html, body { font-size: 10pt }
div { margin-left: 1rem }
.tag { color: green; font-family: sans-serif; font-size: 80%; font-weight: bold }
</xsl:text>
          <xsl:for-each-group select="//*" group-by="name()">
            <xsl:text>&#xA;&#xA;.</xsl:text>
            <xsl:value-of select="current-grouping-key()"/>
            <xsl:text> { </xsl:text>
            <xsl:if test="current-grouping-key() = $inlines/@name"> display: inline; </xsl:if>
            <xsl:text>}</xsl:text>
          </xsl:for-each-group>
          <xsl:text>&#xA;&#xA;</xsl:text>
        </style>
      </XJS:template>
      
      <xsl:copy-of select="$lf2"/>
      
      <xsl:if test="exists($divs)">
        <xsl:copy-of select="$lf2"/>
        <XJS:template priority="-0.4" match="{ string-join($divs/@name,' | ')}">
          <div class="{{name()}}">
            <div class="tag"><XJS:value-of select="name()"/>: </div>
            <XJS:apply-templates/>
          </div>
        </XJS:template>
      </xsl:if>
      
        <xsl:if test="exists($paras)">
          <xsl:copy-of select="$lf2"/>
          <XJS:template priority="-0.4" match="{ string-join($paras/@name,' | ')}">
            <p class="{{name()}}">
              <span class="tag"><XJS:value-of select="name()"/>: </span>
              <XJS:apply-templates/>
            </p>
          </XJS:template>
        </xsl:if>
        
        <xsl:if test="exists($inlines)">
          <xsl:copy-of select="$lf2"/>
          <XJS:template priority="-0.4" match="{ string-join($inlines/@name,' | ')}">
            <span class="{{name()}}">
              <span class="tag"><XJS:value-of select="name()"/>: </span>
              <XJS:apply-templates/>
            </span>
          </XJS:template>
        </xsl:if>
      
      <xsl:if test="not($xsl-version = '1.0')">
        <xsl:copy-of select="$lf2"/>
        <xsl:copy-of select="$lf2"/>
        <XJS:function name="xjs:classes">
          <XJS:param name="who" as="element()"/>
          <XJS:sequence select="tokenize($who/@class, '\s+') ! lower-case(.)"/>
        </XJS:function>

        <xsl:copy-of select="$lf2"/>
        <XJS:function name="xjs:has-class">
          <XJS:param name="who" as="element()"/>
          <XJS:param name="ilk" as="xs:string"/>
          <XJS:sequence select="$ilk = xjs:classes($who)"/>
        </XJS:function>
      </xsl:if>
      
    </XJS:stylesheet>
  </xsl:template>
  
</xsl:stylesheet>