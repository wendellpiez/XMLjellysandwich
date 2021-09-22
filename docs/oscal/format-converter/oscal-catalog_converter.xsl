<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
  xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
  xmlns:j="http://www.w3.org/2005/xpath-functions"
  extension-element-prefixes="ixsl"
  exclude-result-prefixes="#all"
  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0"
  version="3.0">

<!--  This 'unified' XSLT presents a runtime interface for SaxonJS to
      *either* the XML-to-JSON *or* the JSON-to-XML OSCAL catalog converter.
      Because these transformations currently (20210921) will not import together
      we use the transform() function to get around it.
      Currently under SaxonJS this takes time! because the called logic is in its native XSLT,
      not compiled as SEF JSON, and must be compiled in the browser.
      When calls directly to sef.json work, we will do that.
      To try: call an SEF XML file.
  -->
  
  <!-- oscal-text coming in is either unparsed XML or JSON -->
  <xsl:param as="xs:string" name="oscal-data">text here</xsl:param>

  <!-- importing the distributed XSLTs 20210916 -->
  <!--<xsl:import href="lib/oscal_catalog_json-to-xml-converter.xsl"/>-->
  <!--<xsl:import href="lib/oscal_catalog_xml-to-json-converter.xsl"/>-->
  
  <!--<xsl:template match="/" expand-text="true">
    <out>{ $oscal-data }</out>
  </xsl:template>-->
  
  <!-- these wrapper converters call the libraries with an adapted interface
       (accepting plain text and wrapping everything in try/catch) -->
  <!-- try compiling and delivering as sef.json for performance?  -->
  <xsl:variable name="exemel-converter" as="xs:string">lib/oscal_catalog_xml-to-json-converter.xsl</xsl:variable>
  <xsl:variable name="jayson-converter" as="xs:string">lib/oscal_catalog_json-to-xml-converter.xsl</xsl:variable>

  <xsl:variable name="oscal-ns" as="xs:string">http://csrc.nist.gov/ns/oscal/1.0</xsl:variable>
 
  <xsl:variable name="indented-xml" as="element()">
    <output:serialization-parameters
      xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
      <output:indent value="true"/>
      <output:omit-xml-declaration value="true"/>
    </output:serialization-parameters>
  </xsl:variable>
  
  <xsl:variable name="indented-json" as="map(*)">
    <!--     map{'indent':true()} -->
    <xsl:map>
      <xsl:map-entry key="'indent'" select="true()"/>
    </xsl:map>
  </xsl:variable>
  
  <!-- returns XML if that's what it is; otherwise pb:ERROR -->
  <xsl:variable name="pb-or-xml">
    <xsl:try xmlns:err="http://www.w3.org/2005/xqt-errors" select="parse-xml($oscal-data)">
      <xsl:catch expand-text="true">
        <pb:ERROR>
          <pb:desc>No XML is available parsing the input</pb:desc>
          <!--<pb:traceback  code="{ $err:code }">{ $err:description }</pb:traceback>-->
          <!--<pb:input>{ $oscal-data} </pb:input>-->
        </pb:ERROR>
      </xsl:catch>
    </xsl:try>
  </xsl:variable>
  
  <!-- returns a json tree if there is one; otherwise pb:ERROR -->
  <xsl:variable name="actually-json">
    <xsl:try xmlns:err="http://www.w3.org/2005/xqt-errors" select="json-to-xml($oscal-data)">
      <xsl:catch expand-text="true">
        <pb:ERROR>
          <pb:desc>No JSON is available parsing the input</pb:desc>
          <!--<pb:traceback  code="{ $err:code }">{ $err:description }</pb:traceback>-->
          <!--<pb:input>{ $oscal-data} </pb:input>-->
        </pb:ERROR>
      </xsl:catch>
    </xsl:try>
  </xsl:variable>
  
   <!-- ENTRY POINT -->
  <xsl:template name="convert-oscal-data">
    <!-- testing $oscal-data here: if it's JSON, run it through the converter and deliver the XML back-->
      <xsl:choose>
        <!-- if we have json we go for it -->
        <xsl:when test="exists($actually-json/j:map)" expand-text="true">
          <!-- We execute the transformation producing XML from the JSON -->
          <xsl:call-template name="produce-xml"/>
        </xsl:when>
        
      <xsl:when test="exists($pb-or-xml/pb:*)" expand-text="true">
        <!-- Not having JSON, we produce an error if we have no XML either -->
        <xsl:call-template name="paste-results">
          <xsl:with-param name="results" expand-text="true">
            <div class="report">
              <p class="error">Input is not XML or JSON</p>
              <pre class="codedump">{ $oscal-data }</pre>
            </div>
          </xsl:with-param>
        </xsl:call-template>

      </xsl:when>
      <xsl:when test="not($pb-or-xml/namespace-uri(*) = $oscal-ns)" expand-text="true">
        <!-- If we have XML, it still might not be OSCAL -->
        <xsl:variable name="some_ns" select="$pb-or-xml/namespace-uri(*)"/>
        <xsl:call-template name="paste-results">
          <xsl:with-param name="results" expand-text="true">
            <div class="report">
              <p class="error">Input XML is not bound to the OSCAL namespace</p>
              <p>Instead we have an element <code>{$pb-or-xml/name(*)}</code> in { if ($some_ns='')
                then 'no namespace' else ('namespace ' || $some_ns ) }</p>
              <!-- escape markup: . => replace('&amp;','&amp;amp;')  => replace('&lt;','&amp;lt;' -->
              <pre class="codedump">{ $oscal-data }</pre>
            </div>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
        <xsl:otherwise>
          <!-- Okay we call it OSCAL XML and try and produce JSON for it -->
          <xsl:call-template name="produce-json"/>
        </xsl:otherwise>  
      </xsl:choose>
    
    <!--<xsl:for-each select="ixsl:page()/id('jsondata')">
      <ixsl:set-attribute name="class" select="'loaded'"/>
      <ixsl:set-property name="value" select="$result-string"/>
    </xsl:for-each>-->
    <!-- Dropping the result in - - - -->
    
  </xsl:template>
  
  <xsl:template match="pb:*" mode="#default write-xml">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="produce-json">
    <!--<xsl:call-template name="capture-json"/>-->
    <xsl:message expand-text="true">trying for { $exemel-converter }</xsl:message>
    <ixsl:schedule-action document="{ $exemel-converter }">
      <!-- execute transform() -->
      <xsl:call-template name="capture-json"/>      
    </ixsl:schedule-action>
  </xsl:template>
  
  <xsl:template name="capture-json">
    <xsl:call-template name="paste-results">
      <xsl:with-param name="results">
        <xsl:variable name="runtime-params" as="map(xs:QName,item()*)">
          <xsl:map>
            <xsl:map-entry key="QName('','produce')"     select="'xpath'"/>
            <!--<xsl:map-entry key="QName('','json-indent')" select="'yes'"/>-->
            <!--<xsl:map-entry key="QName('','indent')"      select="true()"/>-->
          </xsl:map>
        </xsl:variable>
        <xsl:variable name="runtime" as="map(xs:string, item())">
          <xsl:map>
            <xsl:map-entry key="'xslt-version'"        select="3.0"/>
            <xsl:map-entry key="'stylesheet-location'" select="resolve-uri($exemel-converter)"/>
            <!-- starting with whatever the XML is ... it should be OSCAL -->
            <xsl:map-entry key="'source-node'"         select="$pb-or-xml"/>
            <xsl:map-entry key="'initial-template'"    select="QName('','from-xml')"/>
            <xsl:map-entry key="'stylesheet-params'"   select="$runtime-params"/>
          </xsl:map>
        </xsl:variable>
        <p>JSON out - check carefully (as only valid OSCAL will come through)</p>
        <pre class="codedump">
          <xsl:sequence select="transform($runtime)?output => xml-to-json($indented-json)"/>
          
        </pre>
      </xsl:with-param>
    </xsl:call-template>
    
  </xsl:template>
  
  <xsl:template name="produce-xml">
    <!--<xsl:call-template name="capture-xml"/>-->
    <ixsl:schedule-action document="{ $jayson-converter }">
      <xsl:call-template name="capture-xml"/>
    </ixsl:schedule-action>
  </xsl:template>
  
  <xsl:template name="capture-xml">
    <xsl:call-template name="paste-results">
      <xsl:with-param name="results">
        <!--call transform()-->
        <!--<xsl:variable name="runtime-params" as="map(xs:QName,item()*)">
          <xsl:map/>
            <!-\-<xsl:map-entry key="QName('','profile-origin-uri')" select="document-uri($home)"/>
            <xsl:map-entry key="QName('','path-to-source')"     select="$path-to-source"/>
            <xsl:map-entry key="QName('','uri-stack-in')"       select="($uri-stack, document-uri($home))"/>-\->
          <xsl:map-entry key="QName('','initialTemplate')"       select="($uri-stack, document-uri($home))"/>
          from-xdm-json-xml
          </xsl:map>
        </xsl:variable>-->
        
        <xsl:variable name="runtime" as="map(xs:string, item())">
          <xsl:map>
            <xsl:map-entry key="'xslt-version'"        select="3.0"/>
            <xsl:map-entry key="'stylesheet-location'" select="resolve-uri($jayson-converter)"/>
            <!-- starting w/ the XPath JSON produced -->
            <xsl:map-entry key="'source-node'"         select="$actually-json"/>
            <xsl:map-entry key="'initial-template'"        select="QName('','from-xdm-json-xml')"/>
            <!--<xsl:map-entry key="'stylesheet-params'"   select="$runtime-params"/>-->
          </xsl:map>
        </xsl:variable>
        
        <p>XML out - check carefully (as only valid OSCAL will come through)</p>
        <pre class="codedump">
          <xsl:sequence select="transform($runtime)?output => serialize($indented-xml)"/>
        </pre>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="paste-results">
    <xsl:param name="results" select="()"/>
    <xsl:result-document href="#resultbox" method="ixsl:replace-content">
      <xsl:sequence select="$results"/>
    </xsl:result-document>  
  </xsl:template>
  
  <!--<xsl:variable name="runtime-params" as="map(xs:QName,item()*)">
    <xsl:map>
      <!-\-<xsl:map-entry key="QName('','profile-origin-uri')" select="document-uri($home)"/>
      <xsl:map-entry key="QName('','path-to-source')"     select="$path-to-source"/>
      <xsl:map-entry key="QName('','uri-stack-in')"       select="($uri-stack, document-uri($home))"/>-\->
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="runtime" as="map(xs:string, item())">
    <xsl:map>
      <xsl:map-entry key="'xslt-version'"        select="xs:decimal($xslt-spec/@version)"/>
      <xsl:map-entry key="'stylesheet-location'" select="resolve-uri(string($xslt-spec),$xslt-base)"/>
      <xsl:map-entry key="'source-node'"         select="$sourcedoc"/>
      <xsl:map-entry key="'stylesheet-params'"   select="$runtime-params"/>
    </xsl:map>
  </xsl:variable>
  
  <!-\- The function returns a map; primary results are under 'output'
             unless a base output URI is given
             https://www.w3.org/TR/xpath-functions-31/#func-transform -\->
  <xsl:sequence select="transform($runtime)?output"/>-->
  
  
  
  
</xsl:stylesheet>