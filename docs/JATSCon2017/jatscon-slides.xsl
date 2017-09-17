<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xjs="http://github.com/wendellpiez/XMLjellysandwich"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                version="3.0"
                extension-element-prefixes="ixsl">

<!-- XSLT produced via XML jellysandwich then worked up by hand.
     Please excuse the mess, we weren't expecting guests. -->
  
  <xsl:template name="xmljellysandwich_fetch">
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
      <xsl:for-each select="$doc/*/body/sec/title">
        <h4 id="{(../@id,generate-id(..))[1]}-link">
          <xsl:apply-templates mode="nobrk"/>
        </h4>
      </xsl:for-each>
    </div>
  </xsl:template>
  
  <xsl:template name="nav">
    <div class="nav">
      <xsl:for-each select="$doc/*/body/sec">
        <h5 id="{(@id,generate-id(.))[1]}-nav" class="navbutton">&#xA0;</h5>
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
  
  <xsl:template name="clear-boxes">
    <xsl:apply-templates mode="mark-unvisited"
     select="ixsl:page()//id('xmljellysandwich_directory')/div[xjs:has-class(.,'nav')]/h5"/>
  </xsl:template>

  <xsl:variable name="doc" select="/"/>
  
  <xsl:key name="sec-by-id" match="sec" use="(@id,generate-id(.))[1]"/>
  
  
  
  <xsl:template name="load-front-page" mode="ixsl:onclick"
    match="id('xmljellysandwich_title') | id('up-button')" xpath-default-namespace="">
    <xsl:call-template name="clear-boxes"/>
    <xsl:result-document href="#xmljellysandwich_body" method="ixsl:replace-content">
      <xsl:call-template name="front-page"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template mode="ixsl:onclick" match="id('back-button')" xpath-default-namespace="">
    <xsl:variable name="here"
      select="ixsl:page()//id('xmljellysandwich_body')/div[xjs:has-class(., 'sec')]"/>
    <xsl:variable name="source" select="key('sec-by-id', $here/@id, $doc)"/>
    <xsl:for-each select="$source/preceding-sibling::sec[1]">
      <xsl:call-template name="open-section">
        <xsl:with-param name="sec-id" select="(@id, generate-id())[1]"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="empty($source/preceding-sibling::sec)">
      <xsl:call-template name="load-front-page"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="ixsl:onclick"
    match="id('advance-button')" xpath-default-namespace="">
    <!-- $here is the section element presently loaded, if there is one;
         $source is its correspondent source section. -->
    <xsl:variable name="here" select="ixsl:page()//id('xmljellysandwich_body')/div[xjs:has-class(.,'sec')]"/>
    <xsl:variable name="next-sec"
      select="if (empty($here)) then $doc/descendant::sec[1] else key('sec-by-id',$here/@id,$doc)/following-sibling::sec[1]"/>
    
    <xsl:for-each select="$next-sec">
      <xsl:call-template name="open-section">
        <xsl:with-param name="sec-id" select="(@id,generate-id())[1]"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="empty($next-sec)">
      <xsl:call-template name="load-front-page"/>
    </xsl:if>
    
  </xsl:template>
  
  <xsl:template mode="nobrk" match="*">
    <xsl:apply-templates select="."/>
  </xsl:template>
  
  <xsl:template mode="nobrk" match="break"/>
  
   
  <!-- Boilerplate templates not in use. -->
  <xsl:template mode="asleep" match="article">
      <div class="article">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="front">
      <div class="front">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="article-meta">
      <div class="article-meta">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="title-group">
      <div class="title-group">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="article-title">
      <div class="article-title">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="contrib-group">
      <div class="contrib-group">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="contrib">
      <div class="contrib">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="contrib-id">
      <div class="contrib-id">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="name">
      <div class="name">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="surname">
      <div class="surname">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="given-names">
      <div class="given-names">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="abstract">
      <div class="abstract">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
  
   <xsl:template mode="asleep" match="body">
      <div class="body">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
  
  <!-- <xsl:template name="jumpbar">
     <div id="jumpbar">
       <xsl:for-each select="preceding-sibling::sec[1]/title">
         <h6 style="float:left" class="jump_{generate-id(..)}">
           <xsl:apply-templates mode="nobrk"/>
         </h6>
       </xsl:for-each>
       <xsl:for-each select="following-sibling::sec[1]/title">
         <h6 style="float:right" class="jump_{generate-id(..)}">
           <xsl:apply-templates mode="nobrk"/>
         </h6>
       </xsl:for-each>
       <xsl:if test="empty(following-sibling::sec)">
         <h6 style="float:right" class="jump_loadfrontpage">
           <xsl:apply-templates mode="nobrk"/>
         </h6>
       </xsl:if>
       
     </div>
   </xsl:template>-->
  
<!-- Active templates now. -->
 
  <xsl:template match="sec">
      <!--<xsl:call-template name="jumpbar"/>-->
      <div class="sec" id="{(@id,generate-id(.))[1]}">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
  
  <xsl:template match="list">
    <!-- treating all lists as ul -->
      <div class="list">
        <xsl:apply-templates select="title"/>
        <ul>
         <xsl:apply-templates select="* except title"/>
        </ul>
      </div>
   </xsl:template>
  
   <xsl:template match="list-item">
      <li class="list-item">
         <xsl:apply-templates/>
      </li>
   </xsl:template>
   
  <xsl:template mode="asleep" match="back">
      <div class="back">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
  
  <xsl:template match="ref-list">
      <div class="ref-list">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
  
   <xsl:template match="ref">
      <div class="ref">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
  
  <xsl:template match="mixed-citation">
      <p class="mixed-citation">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
  
  <xsl:template match="p">
    <p class="p">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="bold">
    <b class="bold">
      <xsl:apply-templates/>
    </b>
  </xsl:template>
  
  <xsl:template match="break">
    <br class="br"/>
  </xsl:template>
  
  <xsl:template match="ext-link">
    <a target="{generate-id(.)}" href="{@xlink:href}">
      <xsl:apply-templates select="@xlink:href"/>
    </a>
  </xsl:template>
  
  <xsl:template match="ext-link[matches(.,'\S')]">
    <a target="{generate-id(.)}" href="{(@xlink:href,string(.)[. castable as xs:anyURI])[1]}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  
  <xsl:template match="sec/title">
    <h1 class="title">
      <xsl:apply-templates/>
    </h1>
  </xsl:template>
  
  <xsl:template match="fig">
    <div class="fig">
      <xsl:apply-templates select="* except caption, caption"/>
    </div>
  </xsl:template>
  
  <xsl:template match="caption">
    <div class="caption">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="caption/title">
    <h5 class="title">
      <xsl:apply-templates/>
    </h5>
  </xsl:template>
  
  <xsl:template match="graphic">
    <img class="graphic{ @content-type/concat(' ',.) }" src="{@xlink:href}"/>
  </xsl:template>
  
  
  <xsl:template match="monospace">
    <code class="monospace">
      <xsl:apply-templates/>
    </code>
  </xsl:template>
  
  <xsl:template match="italic">
    <i class="italic">
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  
  <xsl:template match="code">
    <pre class="code">
      <xsl:apply-templates/>
    </pre>
  </xsl:template>
  
  <xsl:template name="css">
      <style type="text/css">
html, body { background-color: skyblue }

.tag { color: green; font-family: sans-serif; font-size: 80%; font-weight: bold }


.article { }

.front { }

.article-meta { }

.title-group { }

.article-title { }

.contrib-group { }

.contrib { }

.contrib-id { }

.name { }

.surname { }

.given-names { }

.abstract { }

.p { }

.fig { display: table-cell }
.graphic { border: thin dotted black }

.caption { text-align: center; margin-top: 0.5em }
.caption * { margin: 0pt }

.body { }

.sec { }

.sec > .title { text-align: center; border-bottom: medium double black }

.list { }

.list-item { }

.back { }

.ref-list { }

.ref { }

.mixed-citation { }

img { max-width: 40em }

.front-page h4 { margin-top: 1em; margin-bottom: 0em; font-size: 80% }

div#xmljellysandwich_body > div { padding: 0.5em; border: thin solid black; max-width:80%; background-color: white }
div#xmljellysandwich_body > div > *:first-child { margin-top: 0em }

div#xmljellysandwich_footer { margin-top: 2%;
  font-size: 70%; padding: 0.5em; border: thin solid black; max-width:80%; color: white; background-color: midnightblue  }
div#xmljellysandwich_footer * { margin: 0em }

#xmljellysandwich_footer a { color: skyblue }


#xmljellysandwich_directory div.nav { padding-left: 85%; font-size: 60%; margin-top: 1em }
h5.navbutton { background-color: midnightblue; border: thin solid midnightblue; margin: 0.2em }
h5.navbutton.visited { background-color: skyblue }

a { font-family: sans-serif; font-size: 85% }
a:visited { color: midnightblue }
a:hover { text-decoration: underline }

</style>
   </xsl:template>
   <xsl:template priority="-0.4"
                 match="article | front | article-meta | title-group | article-title | contrib-group | contrib | contrib-id | name | surname | given-names | abstract | body | sec | list | list-item | back | ref-list | ref | mixed-citation">
      <div class="{name()}">
         <div class="tag">
            <xsl:value-of select="name()"/>: </div>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template priority="-0.4" match="p | title">
      <p class="{name()}">
         <span class="tag">
            <xsl:value-of select="name()"/>: </span>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xsl:template priority="-0.4" match="italic | bold | monospace">
      <span class="{name()}">
         <span class="tag">
            <xsl:value-of select="name()"/>: </span>
         <xsl:apply-templates/>
      </span>
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
