<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:m="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
                xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                version="3.0"
                exclude-result-prefixes="#all"
                xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
<!-- XML to JSON conversion: pipeline -->
<!-- Supports either of two interfaces:
      simply handle the XML as source (easier), producing the JSON as output, or
      use arguments (equivalent to): -it from-xml produce=json file=[file] (mirrors the JSON converter interface) -->
<!-- Parameter 'produce' supports acquiring outputs other than JSON:
      produce=xpath produces XPath JSON (an XML syntax)
      produce=supermodel produces intermediate (internal) 'supermodel' format-->
<!-- Parameter setting 'json-indent=yes' produces JSON indented using the internal serializer-->
   <xsl:param name="file" as="xs:string?"/>
   <xsl:param name="produce" as="xs:string">json</xsl:param>
   <xsl:param name="json-indent" as="xs:string">no</xsl:param>
   <!-- NB the output method is XML but serialized JSON is written with disable-output-escaping (below)
     permitting inspection of intermediate results without changing the serialization method.-->
   <xsl:output omit-xml-declaration="true" method="xml"/>
   <xsl:variable name="write-options" as="map(*)">
      <xsl:map>
         <xsl:map-entry key="'indent'" select="$json-indent='yes'"/>
      </xsl:map>
   </xsl:variable>
   <xsl:variable name="source-xml" select="/"/>
   <xsl:template match="/" name="from-xml">
      <xsl:param name="source">
         <xsl:choose><!-- evaluating $file as URI relative to nominal source directory -->
            <xsl:when test="exists($file)">
               <xsl:try xmlns:err="http://www.w3.org/2005/xqt-errors"
                        select="$file ! document(.,$source-xml)">
                  <xsl:catch expand-text="true">
                     <nm:ERROR xmlns:nm="http://csrc.nist.gov/ns/metaschema" code="{ $err:code }">{ $err:description }</nm:ERROR>
                  </xsl:catch>
               </xsl:try>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="/"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:param>
      <xsl:variable name="supermodel">
         <xsl:apply-templates select="$source/*"/>
      </xsl:variable>
      <xsl:variable name="result">
         <xsl:choose>
            <xsl:when test="$produce = 'supermodel'">
               <xsl:sequence select="$supermodel"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:variable name="new-json-xml">
                  <xsl:apply-templates select="$supermodel/*" mode="write-json"/>
               </xsl:variable>
               <xsl:choose>
                  <xsl:when test="matches($produce,('xpath|xdm|xml'))">
                     <xsl:sequence select="$new-json-xml"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:try xmlns:err="http://www.w3.org/2005/xqt-errors"
                              select="xml-to-json($new-json-xml, $write-options)">
                        <xsl:catch expand-text="true">
                           <nm:ERROR xmlns:nm="http://csrc.nist.gov/ns/metaschema" code="{ $err:code }">{ $err:description }</nm:ERROR>
                        </xsl:catch>
                     </xsl:try>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:sequence select="$result/*"/>
      <xsl:if test="matches($result,'\S') and empty($result/*)">
         <xsl:value-of select="$result" disable-output-escaping="true"/>
      </xsl:if>
   </xsl:template>
   <!-- XML to JSON conversion: object filters -->
   <xsl:strip-space elements="catalog metadata revision prop link role location address party responsible-party param constraint test guideline select control part group back-matter resource citation rlink"/>
   <!-- METASCHEMA conversion stylesheet supports XML -> METASCHEMA/SUPERMODEL conversion -->
   <!-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ -->
   <!-- METASCHEMA:  in namespace "http://csrc.nist.gov/ns/oscal/1.0"-->
   <xsl:template match="catalog"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="catalog" key="catalog" gi="catalog">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">catalog</xsl:attribute>
         </xsl:if>
         <xsl:if test=". is /*">
            <xsl:attribute name="namespace">http://csrc.nist.gov/ns/oscal/1.0</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="@uuid"/>
         <xsl:apply-templates select="metadata"/>
         <xsl:for-each-group select="param" group-by="true()">
            <group in-json="ARRAY" key="params">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="control" group-by="true()">
            <group in-json="ARRAY" key="controls">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="group" group-by="true()">
            <group in-json="ARRAY" key="groups">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="back-matter"/>
      </assembly>
   </xsl:template>
   <xsl:template match="metadata"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="metadata" key="metadata" gi="metadata">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">metadata</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="title"/>
         <xsl:apply-templates select="published"/>
         <xsl:apply-templates select="last-modified"/>
         <xsl:apply-templates select="version"/>
         <xsl:apply-templates select="oscal-version"/>
         <xsl:apply-templates select="revisions"/>
         <xsl:for-each-group select="document-id" group-by="true()">
            <group in-json="ARRAY" key="document-ids">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="link" group-by="true()">
            <group in-json="ARRAY" key="links">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="role" group-by="true()">
            <group in-json="ARRAY" key="roles">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="location" group-by="true()">
            <group in-json="ARRAY" key="locations">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="party" group-by="true()">
            <group in-json="ARRAY" key="parties">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="responsible-party" group-by="true()">
            <group in-json="ARRAY" key="responsible-parties">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="prop"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="property" gi="prop">
         <xsl:apply-templates select="@name"/>
         <xsl:apply-templates select="@uuid"/>
         <xsl:apply-templates select="@ns"/>
         <xsl:apply-templates select="@value"/>
         <xsl:apply-templates select="@class"/>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="link"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="link" gi="link">
         <xsl:apply-templates select="@href"/>
         <xsl:apply-templates select="@rel"/>
         <xsl:apply-templates select="@media-type"/>
         <xsl:apply-templates select="text"/>
      </assembly>
   </xsl:template>
   <xsl:template match="role"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="role" gi="role">
         <xsl:apply-templates select="@id"/>
         <xsl:apply-templates select="title"/>
         <xsl:apply-templates select="short-name"/>
         <xsl:apply-templates select="description"/>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="link" group-by="true()">
            <group in-json="ARRAY" key="links">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="location"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="location" gi="location">
         <xsl:apply-templates select="@uuid"/>
         <xsl:apply-templates select="title"/>
         <xsl:apply-templates select="address"/>
         <xsl:for-each-group select="email-address" group-by="true()">
            <group in-json="ARRAY" key="email-addresses">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="telephone-number" group-by="true()">
            <group in-json="ARRAY" key="telephone-numbers">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="url" group-by="true()">
            <group in-json="ARRAY" key="urls">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="link" group-by="true()">
            <group in-json="ARRAY" key="links">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="party"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="party" gi="party">
         <xsl:apply-templates select="@uuid"/>
         <xsl:apply-templates select="@type"/>
         <xsl:apply-templates select="name"/>
         <xsl:apply-templates select="short-name"/>
         <xsl:for-each-group select="external-id" group-by="true()">
            <group in-json="ARRAY" key="external-ids">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="link" group-by="true()">
            <group in-json="ARRAY" key="links">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="email-address" group-by="true()">
            <group in-json="ARRAY" key="email-addresses">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="telephone-number" group-by="true()">
            <group in-json="ARRAY" key="telephone-numbers">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="address" group-by="true()">
            <group in-json="ARRAY" key="addresses">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="location-uuid" group-by="true()">
            <group in-json="ARRAY" key="location-uuids">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="member-of-organization" group-by="true()">
            <group in-json="ARRAY" key="member-of-organizations">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="responsible-party"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="responsible-party" gi="responsible-party">
         <xsl:apply-templates select="@role-id"/>
         <xsl:for-each-group select="party-uuid" group-by="true()">
            <group in-json="ARRAY" key="party-uuids">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="link" group-by="true()">
            <group in-json="ARRAY" key="links">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="param"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="parameter" gi="param">
         <xsl:apply-templates select="@id"/>
         <xsl:apply-templates select="@class"/>
         <xsl:apply-templates select="@depends-on"/>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="link" group-by="true()">
            <group in-json="ARRAY" key="links">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="label"/>
         <xsl:apply-templates select="usage"/>
         <xsl:for-each-group select="constraint" group-by="true()">
            <group in-json="ARRAY" key="constraints">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="guideline" group-by="true()">
            <group in-json="ARRAY" key="guidelines">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="value" group-by="true()">
            <group in-json="ARRAY" key="values">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="select"/>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="constraint"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="parameter-constraint" gi="constraint">
         <xsl:apply-templates select="description"/>
         <xsl:for-each-group select="test" group-by="true()">
            <group in-json="ARRAY" key="tests">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
      </assembly>
   </xsl:template>
   <xsl:template match="guideline"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="parameter-guideline" gi="guideline">
         <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                             group-by="true()">
            <field in-json="SCALAR"
                   in-xml="UNWRAPPED"
                   collapsible="no"
                   as-type="markup-multiline"
                   name="prose"
                   key="prose">
               <value in-json="string"
                      as-type="markup-multiline"
                      _metaschema-xml-id="/assembly/oscal-catalog-common/parameter-guideline/prose/PROSE"
                      _metaschema-json-id="/assembly/oscal-catalog-common/parameter-guideline/prose/PROSE">
                  <xsl:apply-templates select="current-group()" mode="cast-prose"/>
               </value>
            </field>
         </xsl:for-each-group>
      </assembly>
   </xsl:template>
   <xsl:template match="select"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="parameter-selection" key="select" gi="select">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">select</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="@how-many"/>
         <xsl:for-each-group select="choice" group-by="true()">
            <group in-json="ARRAY" key="choice">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
      </assembly>
   </xsl:template>
   <xsl:template match="control"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="control" gi="control">
         <xsl:apply-templates select="@id"/>
         <xsl:apply-templates select="@class"/>
         <xsl:apply-templates select="title"/>
         <xsl:for-each-group select="param" group-by="true()">
            <group in-json="ARRAY" key="params">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="link" group-by="true()">
            <group in-json="ARRAY" key="links">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="part" group-by="true()">
            <group in-json="ARRAY" key="parts">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="control" group-by="true()">
            <group in-json="ARRAY" key="controls">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
      </assembly>
   </xsl:template>
   <xsl:template match="part"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="part" gi="part">
         <xsl:apply-templates select="@id"/>
         <xsl:apply-templates select="@name"/>
         <xsl:apply-templates select="@ns"/>
         <xsl:apply-templates select="@class"/>
         <xsl:apply-templates select="title"/>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                             group-by="true()">
            <field in-json="SCALAR"
                   in-xml="UNWRAPPED"
                   collapsible="no"
                   as-type="markup-multiline"
                   name="prose"
                   key="prose">
               <value in-json="string"
                      as-type="markup-multiline"
                      _metaschema-xml-id="/assembly/oscal-catalog-common/part/prose/PROSE"
                      _metaschema-json-id="/assembly/oscal-catalog-common/part/prose/PROSE">
                  <xsl:apply-templates select="current-group()" mode="cast-prose"/>
               </value>
            </field>
         </xsl:for-each-group>
         <xsl:for-each-group select="part" group-by="true()">
            <group in-json="ARRAY" key="parts">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="link" group-by="true()">
            <group in-json="ARRAY" key="links">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
      </assembly>
   </xsl:template>
   <xsl:template match="group"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="group" gi="group">
         <xsl:apply-templates select="@id"/>
         <xsl:apply-templates select="@class"/>
         <xsl:apply-templates select="title"/>
         <xsl:for-each-group select="param" group-by="true()">
            <group in-json="ARRAY" key="params">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="link" group-by="true()">
            <group in-json="ARRAY" key="links">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="part" group-by="true()">
            <group in-json="ARRAY" key="parts">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="group" group-by="true()">
            <group in-json="ARRAY" key="groups">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="control" group-by="true()">
            <group in-json="ARRAY" key="controls">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
      </assembly>
   </xsl:template>
   <xsl:template match="back-matter"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="back-matter" key="back-matter" gi="back-matter">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">back-matter</xsl:attribute>
         </xsl:if>
         <xsl:for-each-group select="resource" group-by="true()">
            <group in-json="ARRAY" key="resources">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
      </assembly>
   </xsl:template>
   <xsl:template match="remarks"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="remarks"
             key="remarks"
             gi="remarks"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">remarks</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="location-uuid"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="uuid"
             name="location-uuid"
             gi="location-uuid"
             in-json="SCALAR">
         <value as-type="uuid" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="party-uuid"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="uuid"
             name="party-uuid"
             gi="party-uuid"
             in-json="SCALAR">
         <value as-type="uuid" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="value"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="parameter-value"
             gi="value"
             in-json="SCALAR">
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="hash"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no" as-type="string" name="hash" gi="hash">
         <xsl:apply-templates select="@algorithm"/>
         <value as-type="string" key="value" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/@uuid"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="uuid"
            name="uuid"
            key="uuid"
            gi="uuid">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="prop/@name"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="name"
            key="name"
            gi="name">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="prop/@uuid"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="uuid"
            name="uuid"
            key="uuid"
            gi="uuid">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="prop/@ns"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string" as-type="uri" name="ns" key="ns" gi="ns">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="prop/@value"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="string"
            name="value"
            key="value"
            gi="value">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="prop/@class"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="class"
            key="class"
            gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="link/@href"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="uri-reference"
            name="href"
            key="href"
            gi="href">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="link/@rel"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="rel"
            key="rel"
            gi="rel">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="link/@media-type"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="string"
            name="media-type"
            key="media-type"
            gi="media-type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="catalog/metadata/document-id/@scheme | catalog/back-matter/resource/document-id/@scheme"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="uri"
            name="scheme"
            key="scheme"
            gi="scheme">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="role/@id"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string" as-type="token" name="id" key="id" gi="id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="location/@uuid"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="uuid"
            name="uuid"
            key="uuid"
            gi="uuid">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/address/@type | catalog/metadata/party/address/@type"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="location-type"
            key="type"
            gi="type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/telephone-number/@type | catalog/metadata/party/telephone-number/@type"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="string"
            name="type"
            key="type"
            gi="type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="party/@uuid"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="uuid"
            name="uuid"
            key="uuid"
            gi="uuid">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="party/@type"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="string"
            name="type"
            key="type"
            gi="type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/external-id/@scheme"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="uri"
            name="scheme"
            key="scheme"
            gi="scheme">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="responsible-party/@role-id"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="role-id"
            key="role-id"
            gi="role-id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="param/@id"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string" as-type="token" name="id" key="id" gi="id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="param/@class"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="class"
            key="class"
            gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="param/@depends-on"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="depends-on"
            key="depends-on"
            gi="depends-on">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="select/@how-many"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="how-many"
            key="how-many"
            gi="how-many">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="control/@id"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string" as-type="token" name="id" key="id" gi="id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="control/@class"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="class"
            key="class"
            gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="part/@id"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string" as-type="token" name="id" key="id" gi="id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="part/@name"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="name"
            key="name"
            gi="name">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="part/@ns"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string" as-type="uri" name="ns" key="ns" gi="ns">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="part/@class"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="class"
            key="class"
            gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="group/@id"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string" as-type="token" name="id" key="id" gi="id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="group/@class"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="token"
            name="class"
            key="class"
            gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/@uuid"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="uuid"
            name="uuid"
            key="uuid"
            gi="uuid">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/rlink/@href"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="uri-reference"
            name="href"
            key="href"
            gi="href">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/rlink/@media-type"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="string"
            name="media-type"
            key="media-type"
            gi="media-type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="hash/@algorithm"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="string"
            name="algorithm"
            key="algorithm"
            gi="algorithm">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/base64/@filename"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="uri-reference"
            name="filename"
            key="filename"
            gi="filename">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/base64/@media-type"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <flag in-json="string"
            as-type="string"
            name="media-type"
            key="media-type"
            gi="media-type">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="catalog/metadata/title"
                 priority="4"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/published"
                 priority="4"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="dateTime-with-timezone"
             name="published"
             key="published"
             gi="published"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">published</xsl:attribute>
         </xsl:if>
         <value as-type="dateTime-with-timezone" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/last-modified"
                 priority="4"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="dateTime-with-timezone"
             name="last-modified"
             key="last-modified"
             gi="last-modified"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">last-modified</xsl:attribute>
         </xsl:if>
         <value as-type="dateTime-with-timezone" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/version"
                 priority="4"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="version"
             key="version"
             gi="version"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">version</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/oscal-version"
                 priority="4"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="oscal-version"
             key="oscal-version"
             gi="oscal-version"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">oscal-version</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/revisions/revision"
                 priority="5"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="revision" gi="revision">
         <xsl:apply-templates select="title"/>
         <xsl:apply-templates select="published"/>
         <xsl:apply-templates select="last-modified"/>
         <xsl:apply-templates select="version"/>
         <xsl:apply-templates select="oscal-version"/>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="link" group-by="true()">
            <group in-json="ARRAY" key="links">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="catalog/metadata/revisions"
                 priority="4"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <group in-xml="SHOWN"
             gi="revisions"
             group-json="ARRAY"
             name="revision"
             key="revisions">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">revisions</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="revision"/>
      </group>
   </xsl:template>
   <xsl:template match="catalog/metadata/revisions/revision/title"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/revisions/revision/published"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="dateTime-with-timezone"
             name="published"
             key="published"
             gi="published"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">published</xsl:attribute>
         </xsl:if>
         <value as-type="dateTime-with-timezone" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/revisions/revision/last-modified"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="dateTime-with-timezone"
             name="last-modified"
             key="last-modified"
             gi="last-modified"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">last-modified</xsl:attribute>
         </xsl:if>
         <value as-type="dateTime-with-timezone" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/revisions/revision/version"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="version"
             key="version"
             gi="version"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">version</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/revisions/revision/oscal-version"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="oscal-version"
             key="oscal-version"
             gi="oscal-version"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">oscal-version</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/revisions/revision/link/text"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/document-id"
                 priority="5"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="document-id"
             gi="document-id">
         <xsl:apply-templates select="@scheme"/>
         <value as-type="string" key="identifier" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/link/text"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/role/title"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/role/short-name"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="short-name"
             key="short-name"
             gi="short-name"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">short-name</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/role/description"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="description"
             key="description"
             gi="description"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">description</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/role/link/text"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/title"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/address"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="address" key="address" gi="address">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">address</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="@type"/>
         <xsl:for-each-group select="addr-line" group-by="true()">
            <group in-json="ARRAY" key="addr-lines">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="city"/>
         <xsl:apply-templates select="state"/>
         <xsl:apply-templates select="postal-code"/>
         <xsl:apply-templates select="country"/>
      </assembly>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/address/addr-line"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="addr-line"
             gi="addr-line"
             in-json="SCALAR">
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/address/city"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="city"
             key="city"
             gi="city"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">city</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/address/state"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="state"
             key="state"
             gi="state"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">state</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/address/postal-code"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="postal-code"
             key="postal-code"
             gi="postal-code"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">postal-code</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/address/country"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="country"
             key="country"
             gi="country"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">country</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/email-address"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="email"
             name="email-address"
             gi="email-address"
             in-json="SCALAR">
         <value as-type="email" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/telephone-number"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="telephone-number"
             gi="telephone-number">
         <xsl:apply-templates select="@type"/>
         <value as-type="string" key="number" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/url"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="uri"
             name="url"
             gi="url"
             in-json="SCALAR">
         <value as-type="uri" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/location/link/text"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/name"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="name"
             key="name"
             gi="name"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">name</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/short-name"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="short-name"
             key="short-name"
             gi="short-name"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">short-name</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/external-id"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="external-id"
             gi="external-id">
         <xsl:apply-templates select="@scheme"/>
         <value as-type="string" key="id" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/link/text"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/email-address"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="email"
             name="email-address"
             gi="email-address"
             in-json="SCALAR">
         <value as-type="email" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/telephone-number"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="telephone-number"
             gi="telephone-number">
         <xsl:apply-templates select="@type"/>
         <value as-type="string" key="number" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/address"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="address" gi="address">
         <xsl:apply-templates select="@type"/>
         <xsl:for-each-group select="addr-line" group-by="true()">
            <group in-json="ARRAY" key="addr-lines">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="city"/>
         <xsl:apply-templates select="state"/>
         <xsl:apply-templates select="postal-code"/>
         <xsl:apply-templates select="country"/>
      </assembly>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/address/addr-line"
                 priority="10"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="addr-line"
             gi="addr-line"
             in-json="SCALAR">
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/address/city"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="city"
             key="city"
             gi="city"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">city</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/address/state"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="state"
             key="state"
             gi="state"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">state</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/address/postal-code"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="postal-code"
             key="postal-code"
             gi="postal-code"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">postal-code</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/address/country"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="country"
             key="country"
             gi="country"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">country</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/party/member-of-organization"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="uuid"
             name="member-of-organization"
             gi="member-of-organization"
             in-json="SCALAR">
         <value as-type="uuid" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/metadata/responsible-party/link/text"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/param/link/text"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/param/label"
                 priority="5"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="label"
             key="label"
             gi="label"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">label</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/param/usage"
                 priority="5"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="usage"
             key="usage"
             gi="usage"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">usage</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/param/constraint/description"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="description"
             key="description"
             gi="description"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">description</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/param/constraint/test"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="test" gi="test">
         <xsl:apply-templates select="expression"/>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="catalog/param/constraint/test/expression"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="expression"
             key="expression"
             gi="expression"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">expression</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/param/select/choice"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="parameter-choice"
             gi="choice"
             in-json="SCALAR">
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//control/title"
                 priority="5"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//control/param/link/text"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//control/param/label"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="label"
             key="label"
             gi="label"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">label</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//control/param/usage"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="usage"
             key="usage"
             gi="usage"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">usage</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//control/param/constraint/description"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="description"
             key="description"
             gi="description"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">description</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//control/param/constraint/test"
                 priority="10"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="test" gi="test">
         <xsl:apply-templates select="expression"/>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="catalog//control/param/constraint/test/expression"
                 priority="11"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="expression"
             key="expression"
             gi="expression"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">expression</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//control/param/select/choice"
                 priority="10"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="parameter-choice"
             gi="choice"
             in-json="SCALAR">
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//control/link/text"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//control//part/title"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//control//part/link/text"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group/title"
                 priority="5"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group/param/link/text"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group/param/label"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="label"
             key="label"
             gi="label"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">label</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group/param/usage"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="usage"
             key="usage"
             gi="usage"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">usage</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group/param/constraint/description"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="description"
             key="description"
             gi="description"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">description</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group/param/constraint/test"
                 priority="10"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="test" gi="test">
         <xsl:apply-templates select="expression"/>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="catalog//group/param/constraint/test/expression"
                 priority="11"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="expression"
             key="expression"
             gi="expression"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">expression</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group/param/select/choice"
                 priority="10"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="parameter-choice"
             gi="choice"
             in-json="SCALAR">
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group/link/text"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//part/title"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//part/link/text"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//control/title"
                 priority="8"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//control/param/link/text"
                 priority="12"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//control/param/label"
                 priority="10"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="label"
             key="label"
             gi="label"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">label</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//control/param/usage"
                 priority="10"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="usage"
             key="usage"
             gi="usage"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">usage</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//control/param/constraint/description"
                 priority="12"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="description"
             key="description"
             gi="description"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">description</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//control/param/constraint/test"
                 priority="13"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="test" gi="test">
         <xsl:apply-templates select="expression"/>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="catalog//group//control/param/constraint/test/expression"
                 priority="14"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="expression"
             key="expression"
             gi="expression"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">expression</xsl:attribute>
         </xsl:if>
         <value as-type="string" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//control/param/select/choice"
                 priority="13"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="parameter-choice"
             gi="choice"
             in-json="SCALAR">
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//control/link/text"
                 priority="10"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//control//part/title"
                 priority="10"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog//group//control//part/link/text"
                 priority="12"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource"
                 priority="5"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="resource" gi="resource">
         <xsl:apply-templates select="@uuid"/>
         <xsl:apply-templates select="title"/>
         <xsl:apply-templates select="description"/>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="document-id" group-by="true()">
            <group in-json="ARRAY" key="document-ids">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="citation"/>
         <xsl:for-each-group select="rlink" group-by="true()">
            <group in-json="ARRAY" key="rlinks">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="base64"/>
         <xsl:apply-templates select="remarks"/>
      </assembly>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/title"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="title"
             key="title"
             gi="title"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/description"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WITH_WRAPPER"
             collapsible="no"
             as-type="markup-multiline"
             name="description"
             key="description"
             gi="description"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">description</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/document-id"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="string"
             name="document-id"
             gi="document-id">
         <xsl:apply-templates select="@scheme"/>
         <value as-type="string" key="identifier" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/citation"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="citation" key="citation" gi="citation">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">citation</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="text"/>
         <xsl:for-each-group select="prop" group-by="true()">
            <group in-json="ARRAY" key="props">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="link" group-by="true()">
            <group in-json="ARRAY" key="links">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
      </assembly>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/citation/text"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/citation/link/text"
                 priority="9"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="markup-line"
             name="text"
             key="text"
             gi="text"
             in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">text</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/rlink"
                 priority="7"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="rlink" gi="rlink">
         <xsl:apply-templates select="@href"/>
         <xsl:apply-templates select="@media-type"/>
         <xsl:for-each-group select="hash" group-by="true()">
            <group in-json="ARRAY" key="hashes">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
      </assembly>
   </xsl:template>
   <xsl:template match="catalog/back-matter/resource/base64"
                 priority="6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
             as-type="base64Binary"
             name="base64"
             key="base64"
             gi="base64">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">base64</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="@filename"/>
         <xsl:apply-templates select="@media-type"/>
         <value as-type="base64Binary" key="value" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="*"
                 mode="cast-prose"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
      <xsl:element name="{ local-name() }"
                   namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates mode="#current"/>
      </xsl:element>
   </xsl:template>
   <!-- XML to JSON conversion: Supermodel serialization as JSON
        including markdown production -->
   <xsl:variable xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 name="ns"
                 select="/*/@namespace"/>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="group"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <array>
         <xsl:copy-of select="@key"/>
         <xsl:apply-templates mode="#current"/>
      </array>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="group[@in-json='BY_KEY']"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <map>
         <xsl:copy-of select="@key"/>
         <xsl:apply-templates mode="#current"/>
      </map>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="flag[@key=../@json-key-flag]"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"/>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="group[@in-json='SINGLETON_OR_ARRAY'][count(*)=1]"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:apply-templates mode="write-json">
         <xsl:with-param name="group-key" select="@key"/>
      </xsl:apply-templates>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 priority="2"
                 match="group/assembly | group/field"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
        <!-- $group-key is only provided when group/@in-json="SINGLETON_OR_ASSEMBLY" and there is one member of the group -->
      <xsl:param name="group-key" select="()"/>
      <!--@json-key-flag is only available when group/@in-json="BY_KEY"-->
      <xsl:variable name="json-key-flag-name" select="@json-key-flag"/>
      <!-- this will be an array member unless its group is a singleton or BY_KEY -->
      <!-- so we want no key except -->
      <map>
            <!-- we take a $group-key if given -->
         <xsl:copy-of select="$group-key"/>
         <!-- when there's a JSON key flag, we get the key from there -->
         <xsl:for-each select="flag[@key=$json-key-flag-name]">
            <xsl:attribute name="key" select="."/>
         </xsl:for-each>
         <xsl:apply-templates mode="#current"/>
      </map>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 priority="3"
                 match="group/field[@in-json='SCALAR']"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:param name="group-key" select="()"/>
      <xsl:variable name="json-key-flag-name" select="@json-key-flag"/>
      <!-- with no flags, this field has only its value -->
      <xsl:apply-templates mode="write-json">
         <xsl:with-param name="use-key" select="flag[@key = $json-key-flag-name]"/>
      </xsl:apply-templates>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="/assembly"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <map>
         <xsl:next-match/>
      </map>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="assembly"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <map key="{@key}">
         <xsl:apply-templates mode="#current"/>
      </map>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="field"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <map key="{@key}">
         <xsl:apply-templates mode="#current"/>
      </map>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="field[@in-json='SCALAR']"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:apply-templates mode="#current"/>
      <!--
        <!-\- when there are no flags, the field is a string whose value is the value -\->
        <string>
            <xsl:copy-of select="@key"/>
            <xsl:value-of select="value"/>
        </string> -->
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="flag[@key=../value/@key-flag]"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"/>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="flag"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:element name="{(@in-json[matches(.,'\S')],'string')[1]}"
                   namespace="http://www.w3.org/2005/xpath-functions">
         <xsl:copy-of select="@key"/>
         <xsl:apply-templates mode="#current"/>
      </xsl:element>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 priority="2"
                 match="field[exists(@json-key-flag)]/value"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:variable name="key-flag-name" select="../@json-key-flag"/>
      <xsl:element name="{@in-json}" namespace="http://www.w3.org/2005/xpath-functions">
         <xsl:attribute name="key" select="../flag[@key = $key-flag-name]"/>
         <xsl:apply-templates mode="#current"/>
      </xsl:element>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="value"
                 mode="write-json"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:variable name="key-flag-name" select="@key-flag"/>
      <xsl:element name="{(@in-json[matches(.,'\S')],'string')[1]}"
                   namespace="http://www.w3.org/2005/xpath-functions">
         <xsl:copy-of select="((../flag[@key=$key-flag-name],parent::field[@in-json = 'SCALAR'])/@key, @key)[1]"/>
         <!-- overriding the key           -->
         <xsl:if test="exists(@key-flag)">
            <xsl:attribute name="key">
               <xsl:apply-templates select="../flag[@name=$key-flag-name]" mode="cast-data"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="cast-data"/>
      </xsl:element>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="*"
                 mode="cast-data"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="value[@as-type='markup-line']"
                 mode="cast-data"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:apply-templates mode="md"/>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 match="value[@as-type='markup-multiline']"
                 mode="cast-data"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:variable name="lines" as="node()*">
         <xsl:apply-templates select="*" mode="md"/>
      </xsl:variable>
      <xsl:value-of select="$lines/self::* =&gt; string-join('&#xA;')"/>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 name="conditional-lf"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:if test="exists(preceding-sibling::*)">
         <string/>
      </xsl:if>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="text()[empty(ancestor::pre)]"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:variable name="escaped">
         <xsl:value-of select="replace(., '([`~\^\*&#34;])', '\\$1')"/>
      </xsl:variable>
      <xsl:value-of select="replace($escaped,'\s+',' ')"/>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="text()"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
        <!-- Escapes go here       -->
        <!-- prefixes ` ~ ^ * with char E0000 from Unicode PUA -->
        <!--<xsl:value-of select="replace(., '([`~\^\*''&quot;])', '&#xE0000;$1')"/>-->
        <!-- prefixes ` ~ ^ * ' " with reverse solidus -->
      <xsl:value-of select="replace(., '([`~\^\*&#34;])', '\\$1')"/>
      <!--<xsl:value-of select="."/>-->
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="p"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:call-template name="conditional-lf"/>
      <string>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="h1 | h2 | h3 | h4 | h5 | h6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:call-template name="conditional-lf"/>
      <string>
         <xsl:apply-templates select="." mode="mark"/>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="mark"
                 match="h1"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"># </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="mark"
                 match="h2"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">## </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="mark"
                 match="h3"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">### </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="mark"
                 match="h4"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">#### </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="mark"
                 match="h5"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">##### </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="mark"
                 match="h6"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">###### </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="table"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:call-template name="conditional-lf"/>
      <xsl:apply-templates select="*" mode="md"/>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="tr"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <string>
         <xsl:apply-templates select="*" mode="md"/>
      </string>
      <xsl:if test="empty(preceding-sibling::tr)">
         <string>
            <xsl:text>|</xsl:text>
            <xsl:for-each select="th | td">
               <xsl:text> --- |</xsl:text>
            </xsl:for-each>
         </string>
      </xsl:if>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="th | td"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:if test="empty(preceding-sibling::*)">|</xsl:if>
      <xsl:text> </xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text> |</xsl:text>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 priority="1"
                 match="pre"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:call-template name="conditional-lf"/>
      <string>```</string>
      <string>
         <xsl:apply-templates mode="md"/>
      </string>
      <string>```</string>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 priority="1"
                 match="ul | ol"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:call-template name="conditional-lf"/>
      <xsl:apply-templates mode="md"/>
      <string/>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="ul//ul | ol//ol | ol//ul | ul//ol"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:apply-templates mode="md"/>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="li"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <string>
         <xsl:for-each select="(../ancestor::ul | ../ancestor::ol)">
            <xsl:text>  </xsl:text>
         </xsl:for-each>
         <xsl:text>* </xsl:text>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="ol/li"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <string>
         <xsl:for-each select="(../ancestor::ul | ../ancestor::ol)">
            <xsl:text xml:space="preserve">  </xsl:text>
         </xsl:for-each>
         <xsl:text>1. </xsl:text>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="code | span[contains(@class, 'code')]"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>`</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>`</xsl:text>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="em | i"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>*</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>*</xsl:text>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="strong | b"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>**</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>**</xsl:text>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="q"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>"</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>"</xsl:text>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="insert"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>{{ insert: </xsl:text>
      <xsl:value-of select="@type, @id-ref" separator=", "/>
      <xsl:text> }}</xsl:text>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="a"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>]</xsl:text>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@href"/>
      <xsl:text>)</xsl:text>
   </xsl:template>
   <xsl:template xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                 xmlns="http://www.w3.org/2005/xpath-functions"
                 mode="md"
                 match="img"
                 xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>![</xsl:text>
      <xsl:value-of select="(@alt,@src)[1]"/>
      <xsl:text>]</xsl:text>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@src"/>
      <xsl:for-each select="@title">
         <xsl:text expand-text="true"> "{.}"</xsl:text>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
   </xsl:template>
</xsl:stylesheet>
