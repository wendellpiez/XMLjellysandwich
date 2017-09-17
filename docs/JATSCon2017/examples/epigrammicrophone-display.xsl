<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  
  <xsl:output indent="no"/>
  
   <xsl:template match="/">
      <html>
         <head>
            <title>Epigram Microphone</title>
           
           <xsl:call-template name="css"/>
           <link href="https://fonts.googleapis.com/css?family=Cantarell|Lora" rel="stylesheet"/>
           
           <xsl:call-template name="script"/>
         </head>
         <body>
            <xsl:apply-templates/>
         </body>
      </html>
   </xsl:template>

  
   <xsl:template priority="2" match="book">
      <div class="book">
        <!--<div id="toc" class="toc">
          <xsl:apply-templates select="book-body" mode="toc"/>
        </div>-->
         <xsl:apply-templates/>
        <div id="navigator">
          <xsl:apply-templates mode="navigator"/>
        </div>
        <div class="footer">
          <xsl:for-each select="/book/book-meta/book-title-group/book-title |
            /book/book-meta/contrib-group/* |
            /book/book-meta/permissions">
            <xsl:apply-templates select="."/>
          </xsl:for-each>
          <p>Produced for <a href="http://www.pausepress.net">Pause Press</a> by Wendell Piez</p>
        </div>
      </div>
   </xsl:template>
   <xsl:template priority="2" match="book-meta">
      <div class="book-meta">
         <xsl:apply-templates select="book-title-group | contrib-group"/>
      </div>
   </xsl:template>
   <xsl:template priority="2" match="book-title-group">
      <div class="book-title-group">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template priority="2" match="contrib-group">
      <div class="contrib-group">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template priority="2" match="contrib">
      <div class="contrib">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template priority="2" match="permissions">
    <div class="permissions">
      <p>
        <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">
          <img alt="Creative Commons License" style="border-width:0; padding:0.5em"
            src="https://i.creativecommons.org/l/by/4.0/80x15.png"/>
        </a>
      </p>
      <p>Copy, share and republish under a </p>
      <p><a rel="license" href="http://creativecommons.org/licenses/by/4.0/"
          >Creative Commons Attribution 4.0 International License</a>.</p>
    </div>
   </xsl:template>
   <xsl:template priority="2" match="book-body">
      <div class="book-body">
         <xsl:apply-templates/>
        
      </div>
   </xsl:template>
   <xsl:template priority="2" match="book-part">
     <xsl:variable name="type">
       <xsl:if test="not(body/*[not(self::statement)])"> epigrams</xsl:if>
     </xsl:variable>
      <div class="book-part{$type}" id="{generate-id(.)}">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template priority="2" match="book-part-meta">
      <div class="book-part-meta">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template priority="2" match="title-group">
      <div class="title-group">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template priority="2" match="body">
     <div class="body" id="{generate-id(.)}">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template priority="2" match="sec">
     <div class="sec" id="{generate-id(.)}">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
  <xsl:template priority="2" match="list">
    <div class="plain-list">
    <xsl:apply-templates select="title"/>
    <ul>
      <xsl:apply-templates select="list-item"/>
    </ul>
    </div>
  </xsl:template>
  <xsl:template priority="2" match="list[@list-type='ordered']">
    <div class="ordered-list">
    <xsl:apply-templates select="title"/>
    <ol>
      <xsl:apply-templates select="list-item"/>
    </ol>
    </div>
  </xsl:template>
  <xsl:template priority="2" match="list-item">
      <li class="list-item">
         <xsl:apply-templates/>
      </li>
   </xsl:template>
  <xsl:template priority="2" match="disp-quote">
    <div class="disp-quote {@content-type}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template priority="2" match="statement">
     <xsl:variable name="next" select="(/descendant::statement[1] | following::statement[1])[last()]"/>
     <div class="statement">
         <xsl:apply-templates/>
      </div>
     <!--<div class="statement epigram" id="{generate-id(.)}"
       onclick="hop('{generate-id(.)}','{generate-id($next)}','on');">
       <xsl:if test="not(preceding::statement)">
         <xsl:attribute name="class">statement epigram on</xsl:attribute>
       </xsl:if>
       <xsl:apply-templates/>
     </div>-->
   </xsl:template>
   <xsl:template priority="2" match="book-title">
      <p class="book-title" id="{generate-id(.)}">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xsl:template priority="2" match="string-name">
     <p class="string-name" id="{generate-id(.)}">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xsl:template priority="2" match="email">
     <p class="email" id="{generate-id(.)}">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xsl:template priority="2" match="copyright-statement">
     <p class="copyright-statement" id="{generate-id(.)}">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
  <xsl:template priority="2" match="title">
    <h2 class="title" id="{generate-id(.)}">
      <xsl:apply-templates/>
    </h2>
  </xsl:template>
  <xsl:template priority="2" match="list/title">
    <h4 class="title" id="{generate-id(.)}">
      <xsl:apply-templates/>
    </h4>
  </xsl:template>
  <xsl:template priority="2" match="p">
    <p class="p" id="{generate-id(.)}">
        <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xsl:template priority="2" match="italic">
      <i class="italic">
         <xsl:apply-templates/>
      </i>
   </xsl:template>
  <xsl:template priority="2" match="sup">
    <sup class="sup">
      <xsl:apply-templates/>
    </sup>
  </xsl:template>
  <xsl:template priority="2" match="underline">
    <u class="underline">
      <xsl:apply-templates/>
    </u>
  </xsl:template>
  
  <xsl:template match="book-title//text() | title//text() | p//text()">
    <xsl:variable name="home" select="(ancestor::book-title|ancestor::title|ancestor::p)[last()]"/>
    <xsl:variable name="partnerID" select="concat('nav_',generate-id($home))"/>
    <span onclick="alignPartner('{$partnerID}');"
      onmouseover="flash('{$partnerID}','on');"
      onmouseout="flash('{$partnerID}','on');">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>
  
  <xsl:template priority="2" match="list/text() | list-item/text() | disp-quote/text()">
    <xsl:value-of select="."/>
  </xsl:template>
  
  
  <!-- Patched in from epmic-bits-html.xsl -->
  <xsl:template match="book-body" mode="toc">
    <xsl:for-each select="../book-meta/book-title-group/book-title">
      <p class="toc-head">
        <a href="#">
          <xsl:apply-templates/>
        </a>
      </p>
    </xsl:for-each>
    <xsl:apply-templates mode="toc" select="book-part"/>
  </xsl:template>
  
  <xsl:template match="book-part" mode="toc">
    <div class="toc-group">
      <xsl:if test="not(body/*[not(self::statement)])">
        <xsl:attribute name="class">toc-group epigrams</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="toc" select="book-part-meta/title-group/title"/>
    </div>
  </xsl:template>
  
  <xsl:template match="title" mode="toc">
    <p class="toc-line">
      <xsl:variable name="target-id" select="generate-id((ancestor::sec|ancestor::book-part)[last()])"/>
      <a href="#{$target-id}">
        <xsl:apply-templates/>
      </a>
    </p>
  </xsl:template>


  <xsl:template mode="navigator" match="book | book-title-group | contrib-group | contrib | permissions | book-body | book-part | book-part-meta | title-group | body | sec | list | list-item | disp-quote | statement">
      <div class="{name()}">
        <xsl:apply-templates select="." mode="navigator-embellish"/>
        <xsl:apply-templates mode="navigator"/>
      </div>
   </xsl:template>
  <xsl:template mode="navigator" match="book-meta">
    <div>
      <xsl:apply-templates select="book-title-group" mode="navigator"/>
    </div>
  </xsl:template>
  
  <xsl:template  mode="navigator" match="book-title | string-name | email | copyright-statement | title | p">
    <p class="{name()}" id="nav_{generate-id(.)}">
      <xsl:apply-templates mode="navigator"/>
    </p>
  </xsl:template>

  <xsl:template mode="navigator" match="book-title//text()">
    <a href="#">
      <xsl:value-of select="."/>
    </a>
  </xsl:template>
  
  <xsl:template mode="navigator" match="title//text() | p//text()">
    <xsl:variable name="home" select="(ancestor::title|ancestor::p)[last()]"/>
    <xsl:variable name="partnerID" select="generate-id($home)"/>
    <span onclick="alignPartner('{$partnerID}');"
      onmouseover="flash('{$partnerID}','on');"
      onmouseout="flash('{$partnerID}','on');">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>

  <xsl:template mode="navigator" priority="2" match="list/text() | list-item/text() | disp-quote/text()">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template mode="navigator" match="italic | sup | underline">
      <span class="{name()}">
       <xsl:apply-templates mode="navigator"/>
      </span>
   </xsl:template>

  <!-- All this would be so much easier in XSLT 2.0 ... -->
  <xsl:template mode="navigator" priority="2" match="list">
    <div class="plain-list">
      <xsl:apply-templates select="title"/>
      <ul>
        <xsl:apply-templates mode="navigator" select="list-item"/>
      </ul>
    </div>
  </xsl:template>
  <xsl:template mode="navigator" priority="2" match="list[@list-type='ordered']">
    <div class="ordered-list">
      <xsl:apply-templates mode="navigator" select="title"/>
      <ol>
        <xsl:apply-templates mode="navigator" select="list-item"/>
      </ol>
    </div>
  </xsl:template>
  <xsl:template mode="navigator" priority="2" match="list-item">
    <li class="list-item">
      <xsl:apply-templates mode="navigator"/>
    </li>
  </xsl:template>
  <xsl:template mode="navigator" priority="2" match="disp-quote">
    <div class="disp-quote {@content-type}">
      <xsl:apply-templates mode="navigator"/>
    </div>
  </xsl:template>
  
  <xsl:template mode="navigator-embellish" match="*"/>
  
  <xsl:template mode="navigator-embellish" match="book-part">
    <xsl:if test="not(body/*[not(self::statement)])">
      <xsl:attribute name="class">book-part epigrams</xsl:attribute>
    </xsl:if>
  </xsl:template>
  
  
  
  <xsl:variable name="colwidth">32em</xsl:variable>
  
  <xsl:template name="css">
      <style type="text/css">
html, body { background-color: ghostwhite }
div { margin-left: 1em; margin-right: 1em }
div.plain-list, div.ordered-list { margin: 0em }

sup, sub {
  vertical-align: baseline;
  position: relative;
  top: -0.4em; }
sub { 
  top: 0.4em; }

a { color: inherit; text-decoration: none }
a:hover { text-decoration: underline }

.book { padding-bottom: 2em; font-family: 'Cantarell', sans-serif; }

.book-meta { text-align: center; max-width: 55%;
  margin: 2em; border: thin solid black; background-color: white }

.book-title-group { }

.book-title { font-size: 160%; font-weight: bold }
.footer .book-title { font-size: inherit }

.contrib-group { }

.contrib { }

.string-name { }

.email { }

.permissions { font-size: 60%; margin-top: 1em; margin-bottom: 1em }
.permissions * { margin: 0em }

.copyright-statement { }

.book-part { }

.book-part-meta { margin-left: 0em }

.book-body { max-width: 55% }

.title-group { margin-left: 0em}

.title {  font-family: 'Lora', sans-serif }
.plain-list .title { margin-left: 0em; font-family: inherit; text-decoration: underline }

.body { margin-left: 0em;  margin-top: 1em; max-width: <xsl:value-of select="$colwidth"/> }

.sec {  margin-left: 0em;  border-top: thin solid grey;
  padding-top: 1em; padding-bottom: 1em }
.sec:first-child { border-top: none; padding-top: 0em }

.p { text-indent: 8% }
.p * { text-indent: 0em }
.p:first-child { text-indent: 0em; margin-top: 0em }
.p:last-child { margin-bottom: 0em }

.p div { margin-top: 1em; margin-bottom: 1em }

.italic { }

.list { }

.disp-quote { margin: 1em 8%; font-size: 105%; line-height: 140%;
  break-inside: avoid-column; }
  
      <!-- background-color: darkslategrey; color: white; padding: 0.5em -->
.disp-quote *:first-child { margin-top: 0em }
.disp-quote *:last-child  { margin-bottom: 0em }
  
.disp-quote.vernacular { color: inherit; font-size:90%; font-style: italic;
  background-color: inherit; padding: 0em  }
.vernacular i, .vernacular .italic { font-style: normal }

.sup { }

.statement { margin-left: 0em; font-style: italic;
  border-top: thin solid grey; border-bottom: thin solid grey;
  padding: 1em 0.25em; margin: 0.5em 0em }

.statement i, .statement .italic { font-style: normal }
.statement p { text-indent: 0em }

.footer { margin-top: 1em; margin-left: 2em; text-align: center;
  max-width: 55%;
  padding-top: 1em; border-top: thin solid black }
  
.footer * { margin: 0em }

.epigrams {  }

.plain-list > *, .ordered-list > * { margin-left: 0em; text-indent: 0em; padding-left: 2em }
.plain-list > h4 { margin: 0em }

li { margin: 0em }
.plain-list li { display: block }

div.toc { margin-top: 4ex; margin-bottom: 4ex;
  margin-left: auto; margin-right: auto;
  max-width: 40%;
  background-color: white; padding: 0.5em;
  border: thin solid black
}

div.toc * { margin: 0em; background-color: white }
div.toc-group { margin: 0em }

div.toc-group.epigrams { margin-left: 4em }

p.toc-head { text-align: center; font-weight: bold; font-size: 80%;
margin-bottom: 0.5em; text-decoration: underline}

p.toc-line { font-size: 85% }

#toc { position: fixed; z-index: 2; top: 0.2em; right: 1em }

#navigator  { position: fixed; right: 0; top: 0;
  overflow: scroll; height: 100%;
  max-width: 37%; font-size: 50%;
   padding: 1em; border-left: thin solid black;
  background-color: white
  }

#navigator .book-body { max-width: 54em; padding-bottom: 1em;
  margin-bottom: 1em; border-bottom: thin solid black }

#navigator .body { max-width: 100%;
  columns: 2; webkit-columns: 2; -moz-columns: 2 }

#navigator .title-group .title { font-size: 200% }

#navigator .epigrams { margin-left: 30%; margin-right: 10% }
#navigator .epigrams .body { columns: 1; webkit-columns: 1; -moz-columns: 1 }

.epigram { display: none; z-index: 2; max-width: 60%;
  font-size: 110%; border: medium solid black; padding: 1em;
  position: fixed; bottom: 2rem; margin-left: 2em; margin-right: 2em;
  background-color: white }

.on { background-color: #dce3e0 }

@media print {
#navigator { display: none }
.book-meta, .book-body, .footer { max-width: 100% }
.body { max-width: 100%; columns: 2 }
.epigrams .body { columns: 1 }
}

span, .p span { display: inline }

p:empty { display: none }

.underline { text-decoration: underline }
</style>
   </xsl:template>
  
  <xsl:template name="script">
    <script type="text/javascript">

function flash(elem,flag) {
      var flasher = document.getElementById(elem);
      flasher.classList.contains(flag) ?
        flasher.classList.remove(flag) :
        flasher.classList.add(flag);
      }

function hop(from,next,flag) {
      flash(from,flag);
      flash(next,flag);
      }
 <!--     
function getVerticalSpace(elem) {
      var rect = elem.getBoundingClientRect();
      return rect.top;
      }-->

function alignPartner(prtnr) {
      var partner = document.getElementById(prtnr);
      partner.scrollIntoView(true);
      <!--partner.scrollTop = getVerticalSpace(element);-->
      }


<!--function alignPartner(elem,prtnr) {
var partner = document.getElementById(prtnr);
var element = document.getElementById(elem);
partner.scrollTop = element.scrollTop;-->
      <!--partner.scrollTop = getVerticalSpace(element);
      }-->
      
    </script></xsl:template>
  
</xsl:stylesheet>
