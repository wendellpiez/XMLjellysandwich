<?xml version="1.0" encoding="UTF-8"?>
<!-- Generated from generate-datatype-functions.xsl running on itself -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pb="http://github.com/wendellpiez/XMLjellsandwich/oscal/validator"
                xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
                version="3.0">
   <xsl:function name="pb:datatype-validate" as="xs:boolean">
      <xsl:param name="value" as="item()"/>
      <xsl:param name="nominal-type" as="item()?"/>
      <xsl:variable name="test-type" as="xs:string">
         <xsl:choose>
            <xsl:when test="empty($nominal-type)">string</xsl:when>
            <xsl:when test="$nominal-type = ('IDREFS', 'NMTOKENS')">string</xsl:when>
            <xsl:when test="$nominal-type = ('ID', 'IDREF')">NCName</xsl:when>
            <xsl:otherwise expand-text="yes">{ $nominal-type }</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="proxy" as="element()">
         <xsl:element namespace="http://github.com/wendellpiez/XMLjellsandwich/oscal/validator"
                      name="{$test-type}"
                      expand-text="true">{$value}</xsl:element>
      </xsl:variable>
      <xsl:apply-templates select="$proxy" mode="pb:validate-type"/>
   </xsl:function>
   <!-- XXX -->
   <xsl:template match="pb:string" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select="true()"/>
   </xsl:template>
   <xsl:template match="pb:boolean" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:boolean"/>
   </xsl:template>
   <xsl:template match="pb:base64Binary" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:base64Binary"/>
   </xsl:template>
   <xsl:template match="pb:string" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:string"/>
   </xsl:template>
   <xsl:template match="pb:NCName" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:NCName"/>
   </xsl:template>
   <xsl:template match="pb:NMTOKENS" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:NMTOKENS"/>
   </xsl:template>
   <xsl:template match="pb:decimal" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:decimal"/>
   </xsl:template>
   <xsl:template match="pb:integer" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:integer"/>
   </xsl:template>
   <xsl:template match="pb:nonNegativeInteger"
                 mode="pb:validate-type"
                 as="xs:boolean">
      <xsl:sequence select=". castable as xs:nonNegativeInteger"/>
   </xsl:template>
   <xsl:template match="pb:positiveInteger" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:positiveInteger"/>
   </xsl:template>
   <xsl:template match="pb:ID" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:ID"/>
   </xsl:template>
   <xsl:template match="pb:IDREF" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:IDREF"/>
   </xsl:template>
   <xsl:template match="pb:IDREFS" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:IDREFS"/>
   </xsl:template>
   <xsl:template match="pb:date" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:date"/>
   </xsl:template>
   <xsl:template match="pb:dateTime" mode="pb:validate-type" as="xs:boolean">
      <xsl:sequence select=". castable as xs:dateTime"/>
   </xsl:template>
   <xsl:template match="pb:ip-v4-address" mode="pb:validate-type" as="xs:boolean">
      <xsl:variable name="extra">
         <xsl:sequence select="matches(.,'^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9]).){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])$')"/>
      </xsl:variable>
      <xsl:sequence select="(. castable as xs:string) and $extra"/>
   </xsl:template>
   <xsl:template match="pb:ip-v6-address" mode="pb:validate-type" as="xs:boolean">
      <xsl:variable name="extra">
         <xsl:sequence select="matches(.,'^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|[fF][eE]80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::([fF]{4}(:0{1,4}){0,1}:){0,1}((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9]).){3,3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9]).){3,3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9]))$')"/>
      </xsl:variable>
      <xsl:sequence select="(. castable as xs:string) and $extra"/>
   </xsl:template>
   <xsl:template match="pb:dateTime-with-timezone"
                 mode="pb:validate-type"
                 as="xs:boolean">
      <xsl:variable name="extra">
         <xsl:sequence select="matches(.,'^.+T.+(Z|[+-].+)$')"/>
      </xsl:variable>
      <xsl:sequence select="(. castable as xs:dateTime) and $extra"/>
   </xsl:template>
   <xsl:template match="pb:date-with-timezone"
                 mode="pb:validate-type"
                 as="xs:boolean">
      <xsl:variable name="extra">
         <xsl:sequence select="matches(.,'^.+[:Z].*$')"/>
      </xsl:variable>
      <xsl:sequence select="(. castable as xs:date) and $extra"/>
   </xsl:template>
   <xsl:template match="pb:email" mode="pb:validate-type" as="xs:boolean">
      <xsl:variable name="extra">
         <xsl:sequence select="matches(.,'^.+@.+$')"/>
      </xsl:variable>
      <xsl:sequence select="(. castable as xs:string) and $extra"/>
   </xsl:template>
   <xsl:template match="pb:hostname" mode="pb:validate-type" as="xs:boolean">
      <xsl:variable name="extra">
         <xsl:sequence select="matches(.,'^.+$')"/>
      </xsl:variable>
      <xsl:sequence select="(. castable as xs:string) and $extra"/>
   </xsl:template>
   <xsl:template match="pb:uri" mode="pb:validate-type" as="xs:boolean">
      <xsl:variable name="extra">
         <xsl:sequence select="matches(.,'^\p{L}[\p{L}\d+\-\.]*:.+$')"/>
      </xsl:variable>
      <xsl:sequence select="(. castable as xs:anyURI) and $extra"/>
   </xsl:template>
   <xsl:template match="pb:uri-reference" mode="pb:validate-type" as="xs:boolean">
      <xsl:variable name="extra"/>
      <xsl:sequence select="(. castable as xs:anyURI) and $extra"/>
   </xsl:template>
   <xsl:template match="pb:uuid" mode="pb:validate-type" as="xs:boolean">
      <xsl:variable name="extra">
         <xsl:sequence select="matches(.,'^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-4[0-9A-Fa-f]{3}-[89ABab][0-9A-Fa-f]{3}-[0-9A-Fa-f]{12}$')"/>
      </xsl:variable>
      <xsl:sequence select="(. castable as xs:string) and $extra"/>
   </xsl:template>
</xsl:stylesheet>
