<?xml version="1.0"?>
<!-- ============================================================= -->
<!-- MODULE:    Balisage Conference Paper XSLT                     -->
<!-- VERSION:   1.2                                                -->
<!-- DATE:      April, 2010                                        -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:    Balisage: The Markup Conference papers             -->
<!--                                                               -->
<!-- PURPOSE:   Created for HTML production of papers in the       -->
<!--            Proceedings of Balisage: The Markup Conference     -->
<!--                                                               -->
<!-- CREATED BY:                                                   -->
<!--            Mulberry Technologies, Inc. (wap)                  -->
<!--            17 West Jefferson Street, Suite 207                -->
<!--            Rockville, MD  20850  USA                          -->
<!--            Phone:  +1 301/315-9631                            -->
<!--            Fax:    +1 301/315-8285                            -->
<!--            e-mail: info@mulberrytech.com                      -->
<!--            WWW:    http://www.mulberrytech.com                -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    DESIGN CONSIDERATIONS                      -->
<!-- ============================================================= -->
<!-- 
  This stylesheet is designed to handle the subset of Docbook V5
  defined by the Balisage-1-2.dtd. It is implemented in XSLT 1.0
  without extensions, and should work in any XSLT 1.0 processor.
  
  This stylesheet depends on balisage-html.xsl (in the same
  subdirectory) to provide for basic display logic; use that 
  stylesheet alone for a simple "preview" rendition of a Balisage 
  paper. Use this stylesheet if you want to see a paper as it 
  would appear in the published Conference Proceedings
  (at http://balisage.net/Proceedings/index.html).                 -->

<!-- ============================================================= -->
<!--                    OWNERSHIP AND LICENSES                     -->
<!-- ============================================================= -->
<!-- 
  
  This stylesheet was developed by, and is copyright 2010 
  Mulberry Technologies, Inc. It is released for use by authors in 
  production of papers submitted to Balisage: The Markup Conference
  (http://www.balisage.net)                                        -->
<!-- ============================================================= -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://docbook.org/ns/docbook"
  exclude-result-prefixes="d">

  <xsl:import href="balisage-html.xsl"/>

  <xsl:output method="html" encoding="UTF-8"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd" />

  <xsl:param name="css-file" select="'balisage-proceedings.css'"/>

  <xsl:param name="balisage-logo"
    select="'http://balisage.net/Logo/BalisageSeries-logo.png'"/>
  
  <xsl:variable name="stylesheet-version">1.2</xsl:variable>
  
  <xsl:variable name="open-icon" select="'minus.png'"/>
  
  <xsl:variable name="closed-icon" select="'plus.png'"/>

  <xsl:variable name="ex-icon" select="'eks.png'"/>
  
  <xsl:variable name="control" select="/control"/>
  <!-- $control contains a 'control' document element if the source
       document is a control file -->
  
  <xsl:template match="d:article">
    <html lang="en">
      <head>
        <title>
          <xsl:call-template name="html-title"/>
        </title>
        <link rel="stylesheet" href="{$css-file}" type="text/css"/>
        <meta name="generator"
          content="Balisage Conference Proceedings XSLT (v{$stylesheet-version})"/>
        <xsl:call-template name="proceedings-meta"/>
        <xsl:call-template name="script"/>
      </head>
      <body>
        <xsl:call-template name="inline-citations"/>
        <xsl:call-template name="page-apparatus"/>
        <div id="main">
          <div class="article">
            <xsl:call-template name="article-contents"/>
          </div>
          <xsl:call-template name="page-footer"/>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <!-- only used in the production stylesheet: -->
  <xsl:template name="proceedings-meta"/>
  
  <xsl:template name="inline-citations">
    <!-- generates inline popup boxes for citation references -->
    <xsl:apply-templates select="//d:bibliomixed" mode="inline-citation"/>
  </xsl:template>
  
  <xsl:template name="page-apparatus">
    <div id="mast">
      <xsl:call-template name="mast-contents"/>
    </div>
    <div id="navbar">
      <!-- The navigation bar is blank in this preview -->
    </div>
    <xsl:call-template name="page-header"/>
  </xsl:template>
  
  <xsl:template name="mast-contents">
    <div class="content">
      <xsl:apply-templates mode="titlepage" select="d:title | d:subtitle"/>
      <xsl:apply-templates mode="titlepage" select="/d:article/d:info/d:author"/>
      <xsl:apply-templates mode="mast" select="/d:article/d:info/d:legalnotice"/>
      <xsl:apply-templates select="/d:article/d:info/d:abstract" mode="mast"/>
      <xsl:call-template name="toc"/>
      <xsl:apply-templates select="/d:article/d:info/d:author" mode="mast"/>
    </div>
  </xsl:template>
  
  <xsl:template name="page-header">
    <div id="balisage-header" style="background-color: #6699CC">
      <a class="quiet" href="http://www.balisage.net">
        <img style="float:right;border:none" alt="Balisage logo" height="130"
          src="{$balisage-logo}"/>
      </a>
      <h2 class="page-header">Balisage: The Markup Conference</h2>
      <h1 class="page-header">Proceedings preview</h1>
    </div>
  </xsl:template>
  
  <xsl:template name="article-contents">
    <xsl:apply-templates select="d:title | d:subtitle" mode="titlepage"/>
    <xsl:apply-templates/>
    <xsl:call-template name="footnotes"/>
  </xsl:template>
  
  <xsl:template name="page-footer">
    <xsl:call-template name="author-keywords"/>
    <div id="balisage-footer">
      <h3 style="font-family: serif; margin:0.25em; font-style: italic">
        <xsl:text>Balisage Series on Markup Technologies</xsl:text>
      </h3>
    </div>
  </xsl:template>
  
  <xsl:template name="author-keywords">
    <xsl:for-each
      select="/d:article/d:info/d:keywordset[@role='author'][d:keyword[normalize-space(.)]]">
      <div id="author-keywords">
        <h5 class="keywords">
          <span class="label">Author's keywords for this paper: </span>
          <xsl:for-each select="d:keyword[normalize-space()]">
            <span class="keyword">
              <xsl:apply-templates/>
            </span>
            <xsl:if test="not(position() = last())">; </xsl:if>
          </xsl:for-each>
        </h5>
      </div>
    </xsl:for-each>
  </xsl:template>  
  
  <xsl:template match="d:author" mode="mast">
    <xsl:if test="normalize-space(string(d:personblurb))">
    <div class="mast-box">
      <p class="title">
        <a href="javascript:toggle('{generate-id()}')" class="linkbox">
          <img class="toc-icon" src="{$closed-icon}" alt="&#8862;"
            id="icon-{generate-id()}"/>
        </a>
        <xsl:text> </xsl:text>
        <span onclick="javascript:toggle('{generate-id()}');return true">
          <xsl:apply-templates select="d:personname"/>
        </span>
      </p>
      <div class="folder" id="folder-{generate-id()}" style="display:none">
        <xsl:apply-templates select="d:email" mode="titlepage"/>
        <xsl:apply-templates select="d:affiliation" mode="titlepage"/>
        <xsl:apply-templates select="d:personblurb" mode="titlepage"/>
      </div>
    </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="d:legalnotice" mode="mast">
    <div class="legalnotice-block">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="d:abstract" mode="mast">
    <div class="mast-box">
      <p class="title">
        <a href="javascript:toggle('{generate-id()}')" class="quiet">
          <img class="toc-icon" src="{$closed-icon}" alt="&#8862;"
            id="icon-{generate-id()}"/>
        </a>
        <xsl:text> </xsl:text>
        <span onclick="javascript:toggle('{generate-id()}');return true">Abstract</span>
      </p>
      <div class="folder" id="folder-{generate-id()}" style="display:none">
        <xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>

  
  
  <!-- overrides templates in balisage-html.xsl to make popups for
       links to bibliographic references -->
  

  <xsl:template match="d:bibliomixed" mode="xref">
    <xsl:param name="xref-id" select="'xxx'"/>
    <xsl:param name="text-contents">
      <xsl:apply-templates select="." mode="label-text"/>
    </xsl:param>
    <xsl:variable name="cite-id">
      <xsl:text>cite-</xsl:text>
      <xsl:apply-templates select="." mode="id"/>
    </xsl:variable>
    <a class="xref" id="{$xref-id}"
      href="javascript:showcite('{$cite-id}','{$xref-id}')">
      <xsl:copy-of select="$text-contents"/>
    </a>
  </xsl:template>
  
  <xsl:template match="d:bibliomixed" mode="inline-citation">
    <xsl:variable name="cite-id">
      <xsl:text>cite-</xsl:text>
      <xsl:apply-templates select="." mode="id"/>
    </xsl:variable>
    <div class="inline-citation" id="{$cite-id}" style="display:none;width: 240px">
      <a class="quiet" href="javascript:hidecite('{$cite-id}')" style="font-size:90%">
        <img src="{$ex-icon}" alt="[x]" style="float:right;clear:both;margin:1px"/>
      </a>
      <p style="margin:0ex">
        <xsl:apply-templates/>
      </p>
    </div>
  </xsl:template>
  
  <!--
  <xsl:template match="d:bibliography" mode="popup">
    <xsl:apply-templates select="d:bibliomixed" mode="popup"/>
  </xsl:template>
  <xsl:template match="d:bibliomixed" mode="popup">
    <xsl:variable name="id">
      <xsl:text>cite-</xsl:text>
      <xsl:apply-templates select="." mode="id"/>
    </xsl:variable>   
  </xsl:template>  
  -->

  
  <xsl:template name="script">
    <script type="text/javascript">
      <xsl:text>
    function toggle(folderID) {
      folder = document.getElementById("folder-"+folderID);
      icon = document.getElementById("icon-"+folderID)
      // need to:
      //   switch folder.style.display between 'none' and 'block'
      //   switch between collapse and expand icons
      if (folder.style.display != "block") {
        folder.style.display = "block";
        icon.src = "</xsl:text>
  <xsl:value-of select="$open-icon"/>
  <xsl:text>" ;
        icon.alt = "&#8863;" ;
      }
      else {
        folder.style.display = "none";
        icon.src = "</xsl:text>
  <xsl:value-of select="$closed-icon"/>
  <xsl:text>" ;
        icon.alt = "&#8862;" ;
      };
      return;
    }

   function hidecite(citeID) {
     cite = document.getElementById(citeID);
     cite.style.display = "none";
     return;
   }
   
   function showcite(citeID,anchorID) {
     cite = document.getElementById(citeID);

     citeLeft = cite.style.left;
     citeTop = cite.style.top;
     
     if (citeLeft != (getLeft(anchorID)+"px") ||
         citeTop != (getTop(anchorID)+"px")) {
       cite.style.display = "none";
     }
     
     if (cite.style.display != "table-cell") {
        movebox(citeID, anchorID);
        cite.style.display = "table-cell";
     }
     else {
       cite.style.display = "none";
     };
     return;
   }

   function movebox(citeID, anchorID) {

     cite = document.getElementById(citeID);
     
     // alert(cite.offsetWidth + " by " + cite.offsetHeight)
     
     horizontalOffset = getLeft(anchorID);
     // horizontalOffset = (inMain(anchorID)) ?
     // (horizontalOffset - 260) : (horizontalOffset + 20)
     // (horizontalOffset - (20 + cite.offsetWidth)) : (horizontalOffset + 20)

     verticalOffset = getTop(anchorID);
     // verticalOffset = (inMain(anchorID)) ?
     // (verticalOffset - 20) : (verticalOffset + 20)
     // (verticalOffset - (20 + cite.offsetHeight)) : (verticalOffset + 20)

     /*
     horizontalOffset = getAbsoluteLeft(anchorID) - getScrollLeft(anchorID) + 20;
     if (inMain(anchorID)) {
       horizontalOffset = horizontalOffset - 300;
     }
     verticalOffset = getAbsoluteTop(anchorID) - getScrollTop(anchorID) - 40;
     if (inMain(anchorID)) {
       verticalOffset = verticalOffset - 300;
     }
     */
     
     cite.style.left = horizontalOffset + "px";
     cite.style.top = verticalOffset + "px";
   }
   
   function getLeft(objectID) {
     var left = getAbsoluteLeft(objectID) - getScrollLeft(objectID);
     left = (inMain(objectID)) ? (left - 260) : (left + 20)    
     return left;
   }
   
   function getTop(objectID) {
     var top = getAbsoluteTop(objectID) - getScrollTop(objectID);
     top = (inMain(objectID)) ? (top - 50) : (top + 20)
     return top;     
   }
   
   function getAbsoluteLeft(objectId) {
   // Get an object left position from the upper left viewport corner
     o = document.getElementById(objectId)
     oLeft = o.offsetLeft            // Get left position from the parent object
     while(o.offsetParent!=null) {   // Parse the parent hierarchy up to the document element
       oParent = o.offsetParent    // Get parent object reference
       oLeft += oParent.offsetLeft // Add parent left position
       o = oParent
      }
    return oLeft
    }

    function getAbsoluteTop(objectId) {
    // Get an object top position from the upper left viewport corner
      o = document.getElementById(objectId)
      oTop = o.offsetTop            // Get top position from the parent object
      while(o.offsetParent!=null) { // Parse the parent hierarchy up to the document element
        oParent = o.offsetParent  // Get parent object reference
        oTop += oParent.offsetTop // Add parent top position
        o = oParent
      }
    return oTop
    }

   function getScrollLeft(objectId) {
     // Get a left scroll position
     o = document.getElementById(objectId)
     oLeft = o.scrollLeft            // Get left position from the parent object
     while(o.offsetParent!=null) {   // Parse the parent hierarchy up to the document element
       oParent = o.offsetParent    // Get parent object reference
       oLeft += oParent.scrollLeft // Add parent left position
       o = oParent
      }
    return oLeft
    }

    function getScrollTop(objectId) {
    // Get a right scroll position
      o = document.getElementById(objectId)
      oTop = o.scrollTop            // Get top position from the parent object
      while(o.offsetParent!=null) { // Parse the parent hierarchy up to the document element
        oParent = o.offsetParent  // Get parent object reference
        oTop += oParent.scrollTop // Add parent top position
        o = oParent
      }
    return oTop
    }

    function inMain(objectId) {
    // returns true if in div#main
      o = document.getElementById(objectId)
      while(o.parentNode != null) { // Parse the parent hierarchy up to div#main
        oParent = o.parentNode
        if (o.id == "main") { return true; }
        o = oParent;
      }
    return false;
    }


   /*
   function showcite(citeID) {
      cite = document.getElementById(citeID);
      if (cite.style.display != "table-cell") {
        cite.style.display = "table-cell";
      }
      else {
        cite.style.display = "none";
      };
      return;
    }
    */

      </xsl:text>
    </script>
  </xsl:template>
  
</xsl:stylesheet>
