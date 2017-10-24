<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xjs="http://github.com/wendellpiez/XMLjellysandwich"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                version="3.0"
                exclude-result-prefixes="#all"
                extension-element-prefixes="ixsl"
                xpath-default-namespace="http://docbook.org/ns/docbook"
                xmlns:b="http://docbook.org/ns/docbook">

  <xsl:import href="balisage-html.xsl"/>

  <xsl:variable name="doc" select="/"/>
  
  <xsl:key name="sec-by-id" match="section" use="(@id,generate-id(.))[1]"/>
  
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template name="xmljellysandwich_pack">
    <!-- Target page components by assigning transformation results to them via their IDs. -->
    
    <xsl:result-document href="#xmljellysandwich_header" method="ixsl:replace-content">
      <div id="header-box">
        <xsl:for-each select="/article/title">
        <h2 ><xsl:apply-templates/></h2>
      </xsl:for-each>
      <h3>Wendell Piez · Balisage 2017 · Rockville Maryland</h3>
      </div>
    </xsl:result-document>
    <xsl:result-document href="#xmljellysandwich_body">
      <xsl:apply-templates/>
    </xsl:result-document>
    <xsl:result-document href="#xmljellysandwich_css" method="ixsl:replace-content">
      <xsl:call-template name="css"/>
    </xsl:result-document>
    <xsl:result-document href="#xmljellysandwich_directory" method="ixsl:replace-content">
      <xsl:call-template name="nav"/>
    </xsl:result-document>
    
  </xsl:template>
  
  
  <xsl:template mode="nobrk" match="*">
    <xsl:apply-templates select="."/>
  </xsl:template>
  
  
  <xsl:template name="toc"/>
  
  <xsl:template name="nav">
    <div class="nav">
      <xsl:for-each select="$doc/article/section">
        <xsl:variable name="my-id" select="(@id,generate-id(.))[1]"/>
        <h4 id="{$my-id}-nav" class="navbutton">
          <xsl:apply-templates select="title" mode="nav-link"/>
        </h4>
        <xsl:for-each select="section">
          <h5 id="{(@id,generate-id(.))[1]}-nav" class="navbutton">&#xA0;&#xA0;&#xA0;
            <xsl:apply-templates select="title" mode="nav-link"/>
          </h5>
        </xsl:for-each>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="title" mode="nav-link">
    <xsl:variable name="here-id" select="../(@id,generate-id(.))[1]"/>
    <a href="#{$here-id}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  
  <xsl:template mode="ixsl:onclick"
    match="div[xjs:has-class(.,'nav')]/h4" xpath-default-namespace="">
    <xsl:variable name="sec-id" select="replace(@id,'-nav$','')"/>
    
    <xsl:apply-templates select="id($sec-id)/div[xjs:has-class(.,'section')]" mode="shut"/>
  </xsl:template>

  <xsl:template mode="ixsl:onclick"
    match="div[xjs:has-class(.,'nav')]/h5" xpath-default-namespace="">
    <xsl:variable name="sec-id" select="replace(@id,'-nav$','')"/>
    
    <xsl:apply-templates select="id($sec-id)" mode="open"/>
  </xsl:template>
  
  <xsl:template mode="ixsl:onclick"
    match="id('xmljellysandwich_body')//h2 | id('xmljellysandwich_body')//h3 | id('xmljellysandwich_body')//h4" xpath-default-namespace="">
    <xsl:variable name="sec-id" select="../@id"/>
    
    <xsl:apply-templates select=".." mode="open-or-shut"/>
    
  </xsl:template>
  
  
  
<!-- Open any section by removing a 'shut' attribute -->
  <xsl:template match="*" mode="shut" xpath-default-namespace="">
    <xsl:variable name="already-has" select="tokenize(@class, '\s+')"/>
    <ixsl:set-attribute name="class"
      select="string-join(
      if ($already-has = 'shut') then $already-has else ($already-has,'shut'),' ')"/>
  </xsl:template>
  
  <xsl:template match="*" mode="open" xpath-default-namespace="">
    <xsl:variable name="already-has" select="tokenize(@class, '\s+')"/>
    <ixsl:set-attribute name="class" select="string-join(($already-has[not(. = 'shut')]), ' ')"/>
  </xsl:template>
  
  <xsl:template match="*" mode="open-or-shut" xpath-default-namespace="">
    <xsl:variable name="already-has" select="tokenize(@class, '\s+')"/>
    <ixsl:set-attribute name="class"
      select="string-join(
      if ($already-has = 'shut') then $already-has[not(. = 'shut')] else ($already-has,'shut'),' ')"/>
  </xsl:template>
  
  
  <xsl:template match="article/section">
    <div class="section" id="{(@id,generate-id(.))[1]}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="section | appendix">
    <div class="{local-name()}{ if (empty(section)) then ' shut' else '' }">
      <xsl:call-template name="attach-id"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  
  <xsl:template match="blockquote">
    <blockquote class="blockquote">
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>
  
  

   <xsl:template name="css">
      <style type="text/css">

div.nav * { margin-top: 1ex; margin-bottom: 0ex }
div.nav h5 { padding-right: 2em }

.tag { color: green; font-family: sans-serif; font-size: 80%; font-weight: bold }


.article { }

.title { }

.info { }

.abstract { }

.para { }

.author { }

.personname { }

.firstname { }

.surname { }

.personblurb { }

.section { margin-left: 2em; margin-top: 1em }

.itemizedlist { }

.listitem { }

.variablelist { }

.varlistentry { }

.term { }

.emphasis {  display: inline; }

.code {  display: inline; }

.citation {  display: inline; }

.link {  display: inline; }

.quote {  display: inline; }

.bibliography { }

.bibliomixed { }

.biblioid {  display: inline; }

img { max-width: 100% }

.figure { padding: 0.5em; border: thin inset black; margin-bottom: 1em }
.figure-contents { margin-left: 0em }
.figure-contents div { text-align: center }

.figure { max-width: 30%; display: inline-block; margin-right: 2% }
.figure:hover { max-width: 100% }

.figure > .title { display: none }

.variablelist td { vertical-align: top; border-top: thin solid black;
  margin-top: 0.5em; padding-top: 0.5em }

.caption { text-align: center; margin-top: 0.5em; font-size: 80% }
.caption * { margin: 0pt }

.ital { font-style: italic }
.bold { font-weight: bold }
.bital { font-style: italic; font-weight: bold }

.page-body > *:first-child { margin-top: 0em }

.section .title { border-bottom: medium double black; padding-bottom: 1ex }

.front-page h4 { margin-top: 1em; margin-bottom: 0em; font-size: 80% }


div#xmljellysandwich_body > div { max-width:70%; background-color: white }
div#xmljellysandwich_body > div > *:first-child { margin-top: 0em }

div#xmljellysandwich_footer { margin-top: 2%; font-size: 80%; font-family: sans-serif;
  padding: 0.5em; border: thin solid black; clear: both }

#header-box { padding: 0.5em; background-color: gainsboro; border: thin solid black; width: 80%
  margin-top: 1em; margin-bottom: 1em }
#header-box * { margin: 0em }

.shut > * { display: none }
.shut > .title { display: block }

li p { margin-top: 0.5em; margin-bottom: 0em }

a { font-family: sans-serif; font-size: 85% }
a:visited { color: midnightblue }
a:hover { text-decoration: underline }

</style>
   </xsl:template>




   <xsl:function name="xjs:classes">
      <xsl:param name="who" as="element()"/>
      <xsl:sequence select="tokenize($who/@class, '\s+') ! lower-case(.)"/>
   </xsl:function>

   <xsl:function name="xjs:has-class">
      <xsl:param name="who" as="element()"/>
      <xsl:param name="ilk" as="xs:string"/>
      <xsl:sequence select="$ilk = xjs:classes($who)"/>
   </xsl:function>
</xsl:stylesheet>
