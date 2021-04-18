<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:pb="http://github.com/wendellpiez/XMLjellsandwich/oscal/validator"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
    version="3.0"
    xmlns:XSLT="http://csrc.nist.gov/ns/oscal/metaschema/xslt-alias">
    

    <!-- Copied and modified for XMLJellysandwich from
        https://github.com/wendellpiez/metaschema/blob/master/toolchains/xslt-M4/schema-gen/metatron-datatype-functions.xsl 
        
        Runs on itself.
         Calls data from an OSCAL oscal-datatypes.xsd as $type-definitions    
         Produces a function library for validating datatypes -->
    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:namespace-alias stylesheet-prefix="XSLT" result-prefix="xsl"/>
    
    <xsl:variable name="type-definitions" select="document('https://raw.githubusercontent.com/wendellpiez/metaschema/master/toolchains/xslt-M4/schema-gen/oscal-datatypes.xsd')//xs:simpleType"/>
    
    <xsl:template match="/">
        <xsl:comment expand-text="true"> Generated from { document-uri(/) => replace('.*/','') } running on itself </xsl:comment>
        <XSLT:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0" version="3.0">

            <xsl:call-template name="pb:produce-validation-function"/>

            <xsl:apply-templates select="$type-definitions" mode="pb:make-template"/>

        </XSLT:stylesheet>
    </xsl:template>
    
    <xsl:template name="pb:produce-validation-function">
        <XSLT:function name="pb:datatype-validate" as="xs:boolean">
            <XSLT:param name="value" as="item()"/>
            <XSLT:param name="nominal-type" as="item()?"/>
            <XSLT:variable name="test-type" as="xs:string">
                <XSLT:choose>
                    <XSLT:when test="empty($nominal-type)">string</XSLT:when>
                    <XSLT:when test="$nominal-type = ('IDREFS', 'NMTOKENS')">string</XSLT:when>
                    <XSLT:when test="$nominal-type = ('ID', 'IDREF')">NCName</XSLT:when>
                    <XSLT:otherwise expand-text="yes">{ $nominal-type }</XSLT:otherwise>
                </XSLT:choose>
            </XSLT:variable>
            <XSLT:variable name="proxy" as="element()">
                <XSLT:element namespace="http://github.com/wendellpiez/XMLjellsandwich/oscal/validator"
                    name="{{$test-type}}" expand-text="true">{$value}</XSLT:element>
            </XSLT:variable>
            <XSLT:apply-templates select="$proxy" mode="pb:validate-type"/>
        </XSLT:function>
    </xsl:template>
    
    <xsl:template name="check-NCName-datatype"/>
    
    <xsl:template match="xs:simpleType" mode="pb:make-template">
        <XSLT:template match="pb:{@name}" mode="pb:validate-type" as="xs:boolean">
            <XSLT:sequence select=". castable as xs:{(xs:restriction/@base,@name)[1]}"/>
        </XSLT:template>
    </xsl:template>
    
    <xsl:template match="xs:simpleType[xs:restriction]" mode="pb:make-template">
        <XSLT:template match="pb:{@name}" mode="pb:validate-type" as="xs:boolean">
            <xsl:variable name="extra">
                <xsl:apply-templates mode="#current"/>
            </xsl:variable>
            <XSLT:variable name="extra">
                <xsl:copy-of select="$extra"/>
                <xsl:if test="empty($extra)">
                    <xsl:attribute name="select">true()</xsl:attribute>
                </xsl:if>
            </XSLT:variable>
            
            <XSLT:sequence select="(. castable as {xs:restriction/@base}) and $extra"/>
        </XSLT:template>
    </xsl:template>
    
    <xsl:template match="*" mode="pb:make-template"/>
    
    <xsl:template match="xs:restriction" mode="pb:make-template">
      <xsl:apply-templates mode="#current"/>
    </xsl:template>

    <xsl:template match="xs:pattern" mode="pb:make-template">
        <XSLT:sequence select="matches(.,'^{@value}$')"/>
    </xsl:template>

</xsl:stylesheet>
