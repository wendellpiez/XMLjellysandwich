<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
  xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
  xmlns:err="http://www.w3.org/2005/xqt-errors"
  xmlns:j="http://www.w3.org/2005/xpath-functions"
  extension-element-prefixes="ixsl"
  exclude-result-prefixes="#all"
  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0"
  version="3.0">
  
<!-- This wrapper stylesheet calls the standard OSCAL catalog XML to JSON converter\
     as a module and presents an interface for SaxonJS -->

  <!-- oscal-text coming in is either unparsed XML or JSON -->
  <xsl:param as="xs:string" name="oscal-data">text here</xsl:param>
  
  <!-- overrides import to produce XML representation of JSON (easier debugging) -->
  <xsl:param as="xs:string" name="produce">xml</xsl:param>
  
  <!-- importing the distributed XSLT 20210916 -->
  <xsl:import href="lib/oscal_catalog_xml-to-json-converter.xsl"/>
  
  <xsl:variable name="indented-xml" as="element()">
    <output:serialization-parameters
      xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
      <output:indent value="true"/>
    </output:serialization-parameters>
  </xsl:variable>
  
  <xsl:variable name="indented-json" as="map(*)">
    <xsl:map>
      <xsl:map-entry key="'indent'" select="true()"/>
    </xsl:map>
  </xsl:variable>
  
  <!--UNPLANNED AS ENTRY POINT-->
  <xsl:template match="/">
    <ERROR>MATCHED /</ERROR>
  </xsl:template>
  
  
  <!--PLANNED ENTRY POINT-->
  <xsl:template name="make-json">
    <!-- testing $oscal-data here: if it's JSON, run it through the converter and deliver the XML back-->
    <xsl:variable name="pb-or-xml">
      <xsl:try select="parse-xml($oscal-data)">
        <xsl:catch expand-text="true">
          <pb:ERROR>
            <pb:desc>Data provided does not appear to be XML</pb:desc>
            <!--<pb:traceback  code="{ $err:code }">{ $err:description }</pb:traceback>-->
            <!--<pb:input>{ $oscal-data} </pb:input>-->
          </pb:ERROR>
        </xsl:catch>
      </xsl:try>
    </xsl:variable>
    <xsl:variable name="actually-json">
      <xsl:try select="json-to-xml($oscal-data)">
        <xsl:catch expand-text="true">
          <pb:ERROR>
            <pb:desc>Data provided does not appear to be JSON</pb:desc>
            <!--<pb:traceback  code="{ $err:code }">{ $err:description }</pb:traceback>-->
            <!--<pb:input>{ $oscal-data} </pb:input>-->
          </pb:ERROR>
        </xsl:catch>
      </xsl:try>
    </xsl:variable>
    
    <xsl:variable name="results">
    <xsl:choose>
      <xsl:when test="exists($actually-json/j:map)" expand-text="true">
        <div class="report">
          <p class="error">Input is actually JSON - please try the JSON converter?</p>
          <pre class="codedump">{ $oscal-data  }</pre>
        </div>
      </xsl:when>
      
        <xsl:otherwise>
          <xsl:variable name="result-json-xml">
            <xsl:call-template name="from-xml">
              <xsl:with-param name="source" select="$pb-or-xml"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="okay-json-result">
            <xsl:try select="xml-to-json($result-json-xml, $indented-json)">
              <xsl:catch expand-text="true">
                <pb:ERROR>
                  <pb:desc>Transformed result does not produce JSON</pb:desc>
                  <!--<pb:traceback  code="{ $err:code }">{ $err:description }</pb:traceback>-->
                  <!-- does not implement indenting                  -->
                  <pb:input>{ serialize($result-json-xml,$indented-xml) } </pb:input>
                </pb:ERROR>
              </xsl:catch>
            </xsl:try>
          </xsl:variable>
          
          <xsl:choose>
            <xsl:when test="exists($okay-json-result/pb:ERROR)">
              <p>ERROR: transformed result does not result as JSON</p>
              <p>XPath XML notation for the result is given (for debugging)</p>
              <pre class="codedump">
            <xsl:value-of select="$okay-json-result/pb:ERROR/pb:input"/>
          </pre>
              
            </xsl:when>
            <xsl:otherwise><!-- we have a JSON string -->
             
            <xsl:value-of select="$okay-json-result"/>
          
              
            </xsl:otherwise>
          </xsl:choose>
          
        </xsl:otherwise>  
    </xsl:choose>
    </xsl:variable>
    
    <xsl:result-document href="#resultbox" method="ixsl:replace-content">
      <pre class="codedump inxml">
        <xsl:sequence select="$results"/>
      </pre>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="pb:*" mode="#default">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
 
</xsl:stylesheet>