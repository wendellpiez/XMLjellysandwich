<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xjs="http://github.com/wendellpiez/xmljigsaw"
  version="2.0">
  
  <xsl:namespace-alias stylesheet-prefix="xjs" result-prefix="xsl"/>
  
  <xsl:output indent="yes"/>
  
  <!-- Set $xsl-version to 1.0 and you get an XSLT that will run in any old browser. -->
  <xsl:param name="xsl-version">3.0</xsl:param>
  
  <!-- The assumption is, elements in the input data sample will fall into
    three classes:
    1. Those that appear next to text data i.e. in mixed content
        - should become span
    2. Those that directly contain text data but never appear next to text
        - will become p
    3. Everything else
        - will become div
  The rules go in order and name tests provide exclusion - so always-empty elements become
  span or div depending on their context, while sometimes-empty elements become span when
  text is (somewhere) a neighbor and p if not, but text is (somewhere) in its content. -->

<!-- //* except //text()/.. -->

<xsl:variable name="element-analysis">
  <!-- a little tree of element descriptors.
    Its traversal can be limited by adjusting the path (e.g. to leave out //teiHeader elements) -->
  <xsl:for-each-group select="//*" group-by="name()">
    <element name="{current-grouping-key()}"
      has-text-children="{ exists(current-group()/text()[matches(.,'\S')]) }"
      has-text-siblings="{ exists(current-group()/../text()[matches(.,'\S')]) }"/>
  </xsl:for-each-group>
</xsl:variable>
      
  <xsl:variable name="wrappers" select="$element-analysis/*[@has-text-children='false']"/>
  
  <!-- We only need to match the following; $wrappers are determined only to help determine the others. -->
  <xsl:variable name="inlines"  select="$element-analysis/*[@has-text-siblings='true'] except $wrappers"/>
  <xsl:variable name="paras"    select="$element-analysis/*[@has-text-children='true'] except $inlines"/>
  <!-- Since $divs is everything but $paras and $inlines, nominal wrappers are accounted for. -->
  <xsl:variable name="divs"     select="$element-analysis/* except ($inlines|$paras)"/>
  
  
  <xsl:template match="/">
    <xjs:stylesheet version="{$xsl-version}"
      extension-element-prefixes="ixsl">
      <xsl:namespace name="ixsl">http://saxonica.com/ns/interactiveXSLT</xsl:namespace>
        
      <!--<xsl:copy-of select="$element-analysis"/>-->
      
      <xjs:template name="xmljigsaw_fetch">
        <xsl:comment> Target page components by assigning transformation results to them via their IDs. </xsl:comment>
        <xjs:result-document href="#xmljigsaw_body">
            <xjs:apply-templates/>
        </xjs:result-document>
      </xjs:template>
      
      <xsl:for-each-group select="$divs" group-by="@name">
        <xjs:template mode="asleep" match="{current-grouping-key()}">
          <div class="{current-grouping-key()}">
            <xjs:apply-templates/>
          </div>
        </xjs:template>
      </xsl:for-each-group>
      <xsl:for-each-group select="$paras" group-by="@name">
        <xjs:template mode="asleep" match="{current-grouping-key()}">
          <p class="{current-grouping-key()}">
            <xjs:apply-templates/>
          </p>
        </xjs:template>
      </xsl:for-each-group>
      <xsl:for-each-group select="$inlines" group-by="@name">
        <xjs:template mode="asleep" match="{current-grouping-key()}">
          <span class="{current-grouping-key()}">
            <xjs:apply-templates/>
          </span>
        </xjs:template>
      </xsl:for-each-group>
      
      <xjs:template name="css">
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
      </xjs:template>
      
      <xjs:template priority="-0.4" match="{ string-join($divs/@name,' | ')}">
        <div class="{{name()}}">
          <div class="tag"><xjs:value-of select="name()"/>: </div>
          <xjs:apply-templates/>
        </div>
      </xjs:template>
      <xjs:template priority="-0.4" match="{ string-join($paras/@name,' | ')}">
        <p class="{{name()}}">
          <span class="tag"><xjs:value-of select="name()"/>: </span>
          <xjs:apply-templates/>
        </p>
      </xjs:template>
      <xjs:template priority="-0.4" match="{ string-join($inlines/@name,' | ')}">
        <span class="{{name()}}">
          <span class="tag"><xjs:value-of select="name()"/>: </span>
          <xjs:apply-templates/>
        </span>
      </xjs:template>
      
      <xsl:if test="not($xsl-version = '1.0')">
        <xjs:function name="xjs:classes">
          <xjs:param name="who" as="element()"/>
          <xjs:sequence select="tokenize($who/@class, '\s+') ! lower-case(.)"/>
        </xjs:function>

        <xjs:function name="xjs:has-class">
          <xjs:param name="who" as="element()"/>
          <xjs:param name="ilk" as="xs:string"/>
          <xjs:sequence select="$ilk = xjs:classes($who)"/>
        </xjs:function>
      </xsl:if>
      
    </xjs:stylesheet>
  </xsl:template>
  
</xsl:stylesheet>