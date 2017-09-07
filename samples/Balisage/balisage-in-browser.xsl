<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xjs="http://github.com/wendellpiez/XMLjellysandwich"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                version="3.0"
                extension-element-prefixes="ixsl"
                xpath-default-namespace="http://docbook.org/ns/docbook"
                xmlns:b="http://docbook.org/ns/docbook">


  <xsl:import href="balisage-html.xsl"/>

  <xsl:variable name="doc" select="/"/>
  
  <xsl:key name="sec-by-id" match="section" use="(@id,generate-id(.))[1]"/>
  
  
  
  <xsl:template match="/">
    <!-- Target page components by assigning transformation results to them via their IDs in the host page. -->
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="xmljellysandwich_pack">
    <!-- Target page components by assigning transformation results to them via their IDs. -->
    
    <xsl:result-document href="#xmljellysandwich_body" method="ixsl:replace-content">
      <xsl:call-template name="front-page"/>
    </xsl:result-document>
    <xsl:result-document href="#xmljellysandwich_css" method="ixsl:replace-content">
      <xsl:call-template name="css"/>
    </xsl:result-document>
    <xsl:result-document href="#xmljellysandwich_directory" method="ixsl:replace-content">
      <xsl:call-template name="nav"/>
    </xsl:result-document>
    
  </xsl:template>
  
  <xsl:template name="front-page">
    <div class="front-page">
      <xsl:for-each select="$doc/article/section">
        <h4 id="{(@id,generate-id(.))[1]}-link">
          <xsl:apply-templates select="title" mode="nobrk"/>
        </h4>
      </xsl:for-each>
    </div>
  </xsl:template>
  
  <xsl:template mode="nobrk" match="*">
    <xsl:apply-templates select="."/>
  </xsl:template>
  
  <xsl:template name="nav">
    <div class="nav">
      <xsl:for-each select="$doc/article/section">
        <h5 id="{(@id,generate-id(.))[1]}-nav" class="navbutton">&#xA0;&#xA0;&#xA0;</h5>
      </xsl:for-each>
    </div>
  </xsl:template>
  
  <xsl:template mode="ixsl:onclick"
    match="div[xjs:has-class(.,'front-page')]/h4" xpath-default-namespace="">
    <xsl:call-template name="open-section">
      <xsl:with-param name="sec-id" select="replace(@id,'-link$','')"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template mode="ixsl:onclick"
    match="div[xjs:has-class(.,'nav')]/h5" xpath-default-namespace="">
    <xsl:call-template name="open-section">
      <xsl:with-param name="sec-id" select="replace(@id,'-nav$','')"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="open-section">
    <xsl:param name="sec-id" required="yes"/>
    <xsl:apply-templates mode="mark-visited" select="ixsl:page()//id(concat($sec-id,'-nav'))"/>
    <xsl:result-document href="#xmljellysandwich_body" method="ixsl:replace-content">
      <xsl:apply-templates select="key('sec-by-id',$sec-id,$doc)"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template mode="mark-visited" match="*" xpath-default-namespace="">
    <ixsl:set-attribute name="class"
      select="string-join((xjs:classes(.)[not(.='visited')],'visited' ),' ')"/>
  </xsl:template>
  
  <xsl:template mode="mark-unvisited" match="*" xpath-default-namespace="">
    <ixsl:set-attribute name="class" select="string-join(xjs:classes(.)[not(.='visited')],' ')"/>
  </xsl:template>
  
  <xsl:template name="clear-boxes" xpath-default-namespace="">
    <xsl:apply-templates mode="mark-unvisited"
      select="ixsl:page()//id('xmljellysandwich_directory')/div[xjs:has-class(.,'nav')]/h5"/>
  </xsl:template>
  
   
  
  <xsl:template name="load-front-page" mode="ixsl:onclick"
    match="id('xmljellysandwich_title') | id('up-button')" xpath-default-namespace="">
    <xsl:call-template name="clear-boxes"/>
    <xsl:result-document href="#xmljellysandwich_body" method="ixsl:replace-content">
      <xsl:call-template name="front-page"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template mode="ixsl:onclick" match="id('back-button')" xpath-default-namespace="">
    <xsl:variable name="here"
      select="ixsl:page()//id('xmljellysandwich_body')/div[xjs:has-class(., 'section')]"/>
    <xsl:variable name="source" select="key('sec-by-id', $here/@id, $doc)"/>
    <xsl:for-each select="$source/preceding-sibling::b:section[1]">
      <xsl:call-template name="open-section">
        <xsl:with-param name="sec-id" select="(@id, generate-id())[1]"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="empty($source/preceding-sibling::b:section)">
      <xsl:call-template name="load-front-page"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="ixsl:onclick"
    match="id('advance-button')" xpath-default-namespace="">
    <!-- $here is the section element presently loaded, if there is one;
         $source is its correspondent source section. -->
    <xsl:variable name="here" select="ixsl:page()//id('xmljellysandwich_body')/div[xjs:has-class(.,'section')]"/>
    <xsl:variable name="next-sec"
      select="if (empty($here)) then $doc/descendant::b:section[1] else key('sec-by-id',$here/@id,$doc)/following-sibling::b:section[1]"/>
    
    <xsl:for-each select="$next-sec">
      <xsl:call-template name="open-section">
        <xsl:with-param name="sec-id" select="(@id,generate-id())[1]"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="empty($next-sec)">
      <xsl:call-template name="load-front-page"/>
    </xsl:if>
    
  </xsl:template>
  
  <!-- Being used to hide things in this application. -->
  <xsl:template match="note"/>
  
  <xsl:template match="article/section">
    <div class="section" id="{(@id,generate-id(.))[1]}">
      <div class="figure-block" style="max-width:40%; float: left">
        <xsl:apply-templates select="figure"/>
        
      </div>
      <div class="page-body" style="float:right; width: 58%; padding-left: 2%">
        <xsl:apply-templates select="* except figure"/>
      </div>
    </div>
  </xsl:template>




   <xsl:template mode="asleep" match="article">
      <div class="article">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="info">
      <div class="info">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="abstract">
      <div class="abstract">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="author">
      <div class="author">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="personname">
      <div class="personname">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="personblurb">
      <div class="personblurb">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="section">
      <div class="section">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="itemizedlist">
      <div class="itemizedlist">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="listitem">
      <div class="listitem">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="variablelist">
      <div class="variablelist">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="varlistentry">
      <div class="varlistentry">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="bibliography">
      <div class="bibliography">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template mode="asleep" match="title">
      <p class="title">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template mode="asleep" match="para">
      <p class="para">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template mode="asleep" match="firstname">
      <p class="firstname">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template mode="asleep" match="surname">
      <p class="surname">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template mode="asleep" match="term">
      <p class="term">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template mode="asleep" match="bibliomixed">
      <p class="bibliomixed">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template mode="asleep" match="emphasis">
      <span class="emphasis">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template mode="asleep" match="code">
      <span class="code">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template mode="asleep" match="citation">
      <span class="citation">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template mode="asleep" match="link">
      <span class="link">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template mode="asleep" match="quote">
      <span class="quote">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template mode="asleep" match="biblioid">
      <span class="biblioid">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template name="css">
      <style type="text/css">
html, body { font-size: 10pt }

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

.section { }

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

.figure > .title { display: none }


.caption { text-align: center; margin-top: 0.5em; font-size: 80% }
.caption * { margin: 0pt }

.ital { font-style: italic }
.bold { font-weight: bold }
.bital { font-style: italic; font-weight: bold }

.page-body > *:first-child { margin-top: 0em }

.section .title { text-align: center; border-bottom: medium double black; padding-bottom: 1ex }

.front-page h4 { margin-top: 1em; margin-bottom: 0em; font-size: 80% }

div#xmljellysandwich_body > div { max-width:80%; background-color: white }
div#xmljellysandwich_body > div > *:first-child { margin-top: 0em }

div#xmljellysandwich_footer { margin-top: 2%; font-size: 80%; font-family: sans-serif;
  padding: 0.5em; border: thin solid black; clear: both }

#xmljellysandwich_directory div.nav { padding-left: 85%; font-size: 60%; margin-top: 1em }
h5.navbutton { background-color: midnightblue; border: thin solid midnightblue; margin: 0.2em; min-width: 2em }
h5.navbutton.visited { background-color: skyblue }

a { font-family: sans-serif; font-size: 85% }
a:visited { color: midnightblue }
a:hover { text-decoration: underline }

</style>
   </xsl:template>



  <!-- <xsl:template priority="-0.4"
                 match="article | info | abstract | author | personname | personblurb | section | itemizedlist | listitem | variablelist | varlistentry | bibliography">
      <div class="{name()}">
         <div class="tag">
            <xsl:value-of select="name()"/>: </div>
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template priority="-0.4"
                 match="title | para | firstname | surname | term | bibliomixed">
      <p class="{name()}">
         <span class="tag">
            <xsl:value-of select="name()"/>: </span>
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template priority="-0.4"
                 match="emphasis | code | citation | link | quote | biblioid">
      <span class="{name()}">
         <span class="tag">
            <xsl:value-of select="name()"/>: </span>
         <xsl:apply-templates/>
      </span>
   </xsl:template>-->



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
