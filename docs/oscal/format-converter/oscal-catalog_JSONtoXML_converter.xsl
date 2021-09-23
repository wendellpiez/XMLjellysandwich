<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
  xmlns:j="http://www.w3.org/2005/xpath-functions"
  xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
  xmlns:err="http://www.w3.org/2005/xqt-errors"
  extension-element-prefixes="ixsl"
  exclude-result-prefixes="#all"
  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0"
  version="3.0">

  <!-- oscal-text coming in is either unparsed XML or JSON -->
  <xsl:param as="xs:string" name="oscal-data">text here</xsl:param>

  <xsl:variable name="indented" as="element()">
    <output:serialization-parameters
      xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
      <output:indent value="true"/>
    </output:serialization-parameters>
  </xsl:variable>
  
  <!-- importing the distributed XSLT 20210916 -->
  <xsl:import href="lib/oscal_catalog_json-to-xml-converter.xsl"/>
  
  <!--UNPLANNED AS ENTRY POINT-->
  <xsl:template match="/">
    <ERROR>MATCHED /</ERROR>
  </xsl:template>
  
  <!--PLANNED ENTRY POINT-->
  <xsl:template name="make-xml">
    <!-- testing $oscal-data here: if it's JSON, run it through the converter and deliver the XML back-->
    <xsl:variable name="json-or-pb">
      <xsl:try xmlns:err="http://www.w3.org/2005/xqt-errors" select="json-to-xml($oscal-data)">
        <xsl:catch expand-text="true">
          <pb:ERROR>
            <pb:desc>Data provided does not appear to be JSON</pb:desc>
            <pb:traceback  code="{ $err:code }">{ $err:description }</pb:traceback>
            <pb:input>{ $oscal-data} </pb:input>
          </pb:ERROR>
        </xsl:catch>
      </xsl:try>
    </xsl:variable>
    <xsl:variable name="actually-xml">
      <!-- Try and splice XML onto here only if it isn't JSON (for diagnostic) -->
      <xsl:if test="exists($json-or-pb/pb:ERROR)">
      <xsl:try select="parse-xml($oscal-data)">
        <xsl:catch expand-text="true">
          <pb:ERROR>
            <pb:desc>Data provided does not appear to be XML</pb:desc>
            <!--<pb:traceback  code="{ $err:code }">{ $err:description }</pb:traceback>-->
            <!--<pb:input>{ $oscal-data} </pb:input>-->
          </pb:ERROR>
        </xsl:catch>
      </xsl:try>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="results">
      <xsl:choose expand-text="true">
        <xsl:when test="empty($json-or-pb/j:map)">
          <div class="report">
            <p class="error">Input is not JSON</p>
            <!-- not announcing if XML but not in OSCAL namespace -->
            <xsl:if test="$actually-xml/*/namespace-uri() = 'http://csrc.nist.gov/ns/oscal/1.0'">
              <p>It appears to be OSCAL XML (please try the XML converter)</p>
            </xsl:if>
            <pre class="codedump{ ' inxml'[empty($actually-xml/pb:*)]}">{ $oscal-data  }</pre>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="result-xml">
            <xsl:call-template name="from-xdm-json-xml">
              <xsl:with-param name="source" select="$json-or-pb"/>
            </xsl:call-template>
          </xsl:variable>
          <h4>This produces XML</h4><button onclick="offerDownload('converted.xml')">Save As</button>
          <pre class="codedump inxml" id="success">{ serialize($result-xml, $indented) }</pre>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
<!-- add a feature to accept XPath JSON XML input?   -->

    <xsl:result-document href="#resultbox" method="ixsl:replace-content">
      <xsl:sequence select="$results"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="pb:*" mode="#default write-xml">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>