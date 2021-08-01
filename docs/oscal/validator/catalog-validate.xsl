<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
               xmlns="http://www.w3.org/1999/xhtml"
               version="3.0"
               xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0"
               exclude-result-prefixes="#all">
   <xsl:mode name="test" on-no-match="shallow-skip"/>
   <!-- Generated 2021-08-01T16:46:11.578-04:00 -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Root -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template match="/catalog" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="require-for-catalog-assembly"/>
   </xsl:template>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Occurrences - templates in mode 'test' -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template priority="5" match="catalog/metadata" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::metadata) gt 1"/>
         <xsl:with-param name="msg">
            <code>metadata</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::param | preceding-sibling::control | preceding-sibling::group | preceding-sibling::back-matter )"/>
         <xsl:with-param name="msg">
            <code>metadata</code> is not expected to follow <code>param</code>, <code>control</code>, <code>group</code>,  or <code>back-matter</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-metadata-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="catalog/param" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::control | preceding-sibling::group | preceding-sibling::back-matter )"/>
         <xsl:with-param name="msg">
            <code>param</code> is not expected to follow <code>control</code>, <code>group</code>,  or <code>back-matter</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-parameter-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="catalog/control" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::group | preceding-sibling::back-matter )"/>
         <xsl:with-param name="msg">
            <code>control</code> is not expected to follow <code>group</code> or <code>back-matter</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-control-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="catalog/group" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::back-matter )"/>
         <xsl:with-param name="msg">
            <code>group</code> is not expected to follow <code>back-matter</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-group-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="catalog/back-matter" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::back-matter) gt 1"/>
         <xsl:with-param name="msg">
            <code>back-matter</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-back-matter-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="group/param" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prop | preceding-sibling::link | preceding-sibling::part | preceding-sibling::group | preceding-sibling::control )"/>
         <xsl:with-param name="msg">
            <code>param</code> is not expected to follow <code>prop</code>, <code>link</code>, <code>part</code>, <code>group</code>,  or <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-parameter-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="group/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::link | preceding-sibling::part | preceding-sibling::group | preceding-sibling::control )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>link</code>, <code>part</code>, <code>group</code>,  or <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="group/link" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::part | preceding-sibling::group | preceding-sibling::control )"/>
         <xsl:with-param name="msg">
            <code>link</code> is not expected to follow <code>part</code>, <code>group</code>,  or <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="group/part" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::group | preceding-sibling::control )"/>
         <xsl:with-param name="msg">
            <code>part</code> is not expected to follow <code>group</code> or <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-part-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="group/group" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="condition" select="exists(../(control))"/>
         <xsl:with-param name="cat">choice</xsl:with-param>
         <xsl:with-param name="msg">
            <code>group</code>is not expected along with <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::control )"/>
         <xsl:with-param name="msg">
            <code>group</code> is not expected to follow <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-group-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="group/control" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="condition" select="exists(../(group))"/>
         <xsl:with-param name="cat">choice</xsl:with-param>
         <xsl:with-param name="msg">
            <code>control</code>is not expected along with <code>group</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-control-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="control/param" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prop | preceding-sibling::link | preceding-sibling::part | preceding-sibling::control )"/>
         <xsl:with-param name="msg">
            <code>param</code> is not expected to follow <code>prop</code>, <code>link</code>, <code>part</code>,  or <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-parameter-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="control/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::link | preceding-sibling::part | preceding-sibling::control )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>link</code>, <code>part</code>,  or <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="control/link" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::part | preceding-sibling::control )"/>
         <xsl:with-param name="msg">
            <code>link</code> is not expected to follow <code>part</code> or <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="control/part" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::control )"/>
         <xsl:with-param name="msg">
            <code>part</code> is not expected to follow <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-part-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="control/control" mode="test">
      <xsl:call-template name="require-for-control-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="part/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prose | preceding-sibling::part | preceding-sibling::link )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>prose</code>, <code>part</code>,  or <code>link</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="part/part" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::link )"/>
         <xsl:with-param name="msg">
            <code>part</code> is not expected to follow <code>link</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-part-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="part/link" mode="test">
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="param/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::link | preceding-sibling::label | preceding-sibling::usage | preceding-sibling::constraint | preceding-sibling::guideline | preceding-sibling::value | preceding-sibling::select | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>link</code>, <code>label</code>, <code>usage</code>, <code>constraint</code>, <code>guideline</code>, <code>value</code>, <code>select</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="param/link" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::label | preceding-sibling::usage | preceding-sibling::constraint | preceding-sibling::guideline | preceding-sibling::value | preceding-sibling::select | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>link</code> is not expected to follow <code>label</code>, <code>usage</code>, <code>constraint</code>, <code>guideline</code>, <code>value</code>, <code>select</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="param/constraint" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::guideline | preceding-sibling::value | preceding-sibling::select | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>constraint</code> is not expected to follow <code>guideline</code>, <code>value</code>, <code>select</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-parameter-constraint-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="param/guideline" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::value | preceding-sibling::select | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>guideline</code> is not expected to follow <code>value</code>, <code>select</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-parameter-guideline-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="param/select" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::select) gt 1"/>
         <xsl:with-param name="msg">
            <code>select</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="condition" select="exists(../(value))"/>
         <xsl:with-param name="cat">choice</xsl:with-param>
         <xsl:with-param name="msg">
            <code>select</code>is not expected along with <code>value</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-parameter-selection-assembly"/>
   </xsl:template>
   <xsl:template match="metadata/revisions" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::document-id | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::role | preceding-sibling::location | preceding-sibling::party | preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>revision</code> is not expected to follow <code>document-id</code>, <code>prop</code>, <code>link</code>, <code>role</code>, <code>location</code>, <code>party</code>, <code>responsible-party</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template priority="5" match="metadata/revisions/revision" mode="test">
      <xsl:call-template name="require-for-revision-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="metadata/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::link | preceding-sibling::role | preceding-sibling::location | preceding-sibling::party | preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>link</code>, <code>role</code>, <code>location</code>, <code>party</code>, <code>responsible-party</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="metadata/link" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::role | preceding-sibling::location | preceding-sibling::party | preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>link</code> is not expected to follow <code>role</code>, <code>location</code>, <code>party</code>, <code>responsible-party</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="metadata/role" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::location | preceding-sibling::party | preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>role</code> is not expected to follow <code>location</code>, <code>party</code>, <code>responsible-party</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-role-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="metadata/location" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::party | preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>location</code> is not expected to follow <code>party</code>, <code>responsible-party</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-location-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="metadata/party" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>party</code> is not expected to follow <code>responsible-party</code> or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-party-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="metadata/responsible-party" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>responsible-party</code> is not expected to follow <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-responsible-party-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="revision/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>link</code> or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="revision/link" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>link</code> is not expected to follow <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="location/address" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::address) gt 1"/>
         <xsl:with-param name="msg">
            <code>address</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::email-address | preceding-sibling::telephone-number | preceding-sibling::url | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>address</code> is not expected to follow <code>email-address</code>, <code>telephone-number</code>, <code>url</code>, <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-address-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="location/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>link</code> or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="location/link" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>link</code> is not expected to follow <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="party/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::link | preceding-sibling::email-address | preceding-sibling::telephone-number | preceding-sibling::address | preceding-sibling::location-uuid | preceding-sibling::member-of-organization | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>link</code>, <code>email-address</code>, <code>telephone-number</code>, <code>address</code>, <code>location-uuid</code>, <code>member-of-organization</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="party/link" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::email-address | preceding-sibling::telephone-number | preceding-sibling::address | preceding-sibling::location-uuid | preceding-sibling::member-of-organization | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>link</code> is not expected to follow <code>email-address</code>, <code>telephone-number</code>, <code>address</code>, <code>location-uuid</code>, <code>member-of-organization</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="party/address" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="condition" select="exists(../(location-uuid))"/>
         <xsl:with-param name="cat">choice</xsl:with-param>
         <xsl:with-param name="msg">
            <code>address</code>is not expected along with <code>location-uuid</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::location-uuid )"/>
         <xsl:with-param name="msg">
            <code>address</code> is not expected to follow <code>location-uuid</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-address-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="role/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>link</code> or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="role/link" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>link</code> is not expected to follow <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="resource/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::document-id | preceding-sibling::citation | preceding-sibling::rlink | preceding-sibling::base64 | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>document-id</code>, <code>citation</code>, <code>rlink</code>, <code>base64</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="citation/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::link )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>link</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="citation/link" mode="test">
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="responsible-party/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>link</code> or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="responsible-party/link" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>link</code> is not expected to follow <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="responsible-role/prop" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::link | preceding-sibling::party-uuid | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>prop</code> is not expected to follow <code>link</code>, <code>party-uuid</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-property-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="responsible-role/link" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::party-uuid | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>link</code> is not expected to follow <code>party-uuid</code> or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-link-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="parameter-constraint/test" mode="test">
      <xsl:call-template name="require-for-parameter-constraint_..._test-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="back-matter/resource" mode="test">
      <xsl:call-template name="require-for-back-matter_..._resource-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="resource/citation" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::citation) gt 1"/>
         <xsl:with-param name="msg">
            <code>citation</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::rlink | preceding-sibling::base64 | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>citation</code> is not expected to follow <code>rlink</code>, <code>base64</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-back-matter_..._resource_..._citation-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="resource/rlink" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::base64 | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>rlink</code> is not expected to follow <code>base64</code> or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-back-matter_..._resource_..._rlink-assembly"/>
   </xsl:template>
   <xsl:template match="param/value/text()" mode="test"/>
   <xsl:template priority="5" match="param/value" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="condition" select="exists(../(select))"/>
         <xsl:with-param name="cat">choice</xsl:with-param>
         <xsl:with-param name="msg">
            <code>value</code>is not expected along with <code>select</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::select )"/>
         <xsl:with-param name="msg">
            <code>value</code> is not expected to follow <code>select</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-parameter-value-field"/>
   </xsl:template>
   <xsl:template match="param/remarks/text()" mode="test"/>
   <xsl:template priority="5" match="param/remarks" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::remarks) gt 1"/>
         <xsl:with-param name="msg">
            <code>remarks</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-remarks-field"/>
   </xsl:template>
   <xsl:template match="test/remarks/text()" mode="test"/>
   <xsl:template priority="5" match="test/remarks" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::remarks) gt 1"/>
         <xsl:with-param name="msg">
            <code>remarks</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-remarks-field"/>
   </xsl:template>
   <xsl:template match="metadata/published/text()" mode="test"/>
   <xsl:template priority="5" match="metadata/published" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::published) gt 1"/>
         <xsl:with-param name="msg">
            <code>published</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::last-modified | preceding-sibling::version | preceding-sibling::oscal-version | preceding-sibling::revisions/revision | preceding-sibling::document-id | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::role | preceding-sibling::location | preceding-sibling::party | preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>published</code> is not expected to follow <code>last-modified</code>, <code>version</code>, <code>oscal-version</code>, <code>revisions/revision</code>, <code>document-id</code>, <code>prop</code>, <code>link</code>, <code>role</code>, <code>location</code>, <code>party</code>, <code>responsible-party</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-published-field"/>
   </xsl:template>
   <xsl:template match="metadata/last-modified/text()" mode="test"/>
   <xsl:template priority="5" match="metadata/last-modified" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::last-modified) gt 1"/>
         <xsl:with-param name="msg">
            <code>last-modified</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::version | preceding-sibling::oscal-version | preceding-sibling::revisions/revision | preceding-sibling::document-id | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::role | preceding-sibling::location | preceding-sibling::party | preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>last-modified</code> is not expected to follow <code>version</code>, <code>oscal-version</code>, <code>revisions/revision</code>, <code>document-id</code>, <code>prop</code>, <code>link</code>, <code>role</code>, <code>location</code>, <code>party</code>, <code>responsible-party</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-last-modified-field"/>
   </xsl:template>
   <xsl:template match="metadata/version/text()" mode="test"/>
   <xsl:template priority="5" match="metadata/version" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::version) gt 1"/>
         <xsl:with-param name="msg">
            <code>version</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::oscal-version | preceding-sibling::revisions/revision | preceding-sibling::document-id | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::role | preceding-sibling::location | preceding-sibling::party | preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>version</code> is not expected to follow <code>oscal-version</code>, <code>revisions/revision</code>, <code>document-id</code>, <code>prop</code>, <code>link</code>, <code>role</code>, <code>location</code>, <code>party</code>, <code>responsible-party</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-version-field"/>
   </xsl:template>
   <xsl:template match="metadata/oscal-version/text()" mode="test"/>
   <xsl:template priority="5" match="metadata/oscal-version" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::oscal-version) gt 1"/>
         <xsl:with-param name="msg">
            <code>oscal-version</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::revisions/revision | preceding-sibling::document-id | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::role | preceding-sibling::location | preceding-sibling::party | preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>oscal-version</code> is not expected to follow <code>revisions/revision</code>, <code>document-id</code>, <code>prop</code>, <code>link</code>, <code>role</code>, <code>location</code>, <code>party</code>, <code>responsible-party</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-oscal-version-field"/>
   </xsl:template>
   <xsl:template match="metadata/document-id/text()" mode="test"/>
   <xsl:template priority="5" match="metadata/document-id" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prop | preceding-sibling::link | preceding-sibling::role | preceding-sibling::location | preceding-sibling::party | preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>document-id</code> is not expected to follow <code>prop</code>, <code>link</code>, <code>role</code>, <code>location</code>, <code>party</code>, <code>responsible-party</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-document-id-field"/>
   </xsl:template>
   <xsl:template match="metadata/remarks/text()" mode="test"/>
   <xsl:template priority="5" match="metadata/remarks" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::remarks) gt 1"/>
         <xsl:with-param name="msg">
            <code>remarks</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-remarks-field"/>
   </xsl:template>
   <xsl:template match="revision/published/text()" mode="test"/>
   <xsl:template priority="5" match="revision/published" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::published) gt 1"/>
         <xsl:with-param name="msg">
            <code>published</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::last-modified | preceding-sibling::version | preceding-sibling::oscal-version | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>published</code> is not expected to follow <code>last-modified</code>, <code>version</code>, <code>oscal-version</code>, <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-published-field"/>
   </xsl:template>
   <xsl:template match="revision/last-modified/text()" mode="test"/>
   <xsl:template priority="5" match="revision/last-modified" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::last-modified) gt 1"/>
         <xsl:with-param name="msg">
            <code>last-modified</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::version | preceding-sibling::oscal-version | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>last-modified</code> is not expected to follow <code>version</code>, <code>oscal-version</code>, <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-last-modified-field"/>
   </xsl:template>
   <xsl:template match="revision/version/text()" mode="test"/>
   <xsl:template priority="5" match="revision/version" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::version) gt 1"/>
         <xsl:with-param name="msg">
            <code>version</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::oscal-version | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>version</code> is not expected to follow <code>oscal-version</code>, <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-version-field"/>
   </xsl:template>
   <xsl:template match="revision/oscal-version/text()" mode="test"/>
   <xsl:template priority="5" match="revision/oscal-version" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::oscal-version) gt 1"/>
         <xsl:with-param name="msg">
            <code>oscal-version</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>oscal-version</code> is not expected to follow <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-oscal-version-field"/>
   </xsl:template>
   <xsl:template match="revision/remarks/text()" mode="test"/>
   <xsl:template priority="5" match="revision/remarks" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::remarks) gt 1"/>
         <xsl:with-param name="msg">
            <code>remarks</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-remarks-field"/>
   </xsl:template>
   <xsl:template match="location/email-address/text()" mode="test"/>
   <xsl:template priority="5" match="location/email-address" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::telephone-number | preceding-sibling::url | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>email-address</code> is not expected to follow <code>telephone-number</code>, <code>url</code>, <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-email-address-field"/>
   </xsl:template>
   <xsl:template match="location/telephone-number/text()" mode="test"/>
   <xsl:template priority="5" match="location/telephone-number" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::url | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>telephone-number</code> is not expected to follow <code>url</code>, <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-telephone-number-field"/>
   </xsl:template>
   <xsl:template match="location/remarks/text()" mode="test"/>
   <xsl:template priority="5" match="location/remarks" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::remarks) gt 1"/>
         <xsl:with-param name="msg">
            <code>remarks</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-remarks-field"/>
   </xsl:template>
   <xsl:template match="party/email-address/text()" mode="test"/>
   <xsl:template priority="5" match="party/email-address" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::telephone-number | preceding-sibling::address | preceding-sibling::location-uuid | preceding-sibling::member-of-organization | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>email-address</code> is not expected to follow <code>telephone-number</code>, <code>address</code>, <code>location-uuid</code>, <code>member-of-organization</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-email-address-field"/>
   </xsl:template>
   <xsl:template match="party/telephone-number/text()" mode="test"/>
   <xsl:template priority="5" match="party/telephone-number" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::address | preceding-sibling::location-uuid | preceding-sibling::member-of-organization | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>telephone-number</code> is not expected to follow <code>address</code>, <code>location-uuid</code>, <code>member-of-organization</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-telephone-number-field"/>
   </xsl:template>
   <xsl:template match="party/location-uuid/text()" mode="test"/>
   <xsl:template priority="5" match="party/location-uuid" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="condition" select="exists(../(address))"/>
         <xsl:with-param name="cat">choice</xsl:with-param>
         <xsl:with-param name="msg">
            <code>location-uuid</code>is not expected along with <code>address</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-location-uuid-field"/>
   </xsl:template>
   <xsl:template match="party/remarks/text()" mode="test"/>
   <xsl:template priority="5" match="party/remarks" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::remarks) gt 1"/>
         <xsl:with-param name="msg">
            <code>remarks</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-remarks-field"/>
   </xsl:template>
   <xsl:template match="role/remarks/text()" mode="test"/>
   <xsl:template priority="5" match="role/remarks" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::remarks) gt 1"/>
         <xsl:with-param name="msg">
            <code>remarks</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-remarks-field"/>
   </xsl:template>
   <xsl:template match="resource/document-id/text()" mode="test"/>
   <xsl:template priority="5" match="resource/document-id" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::citation | preceding-sibling::rlink | preceding-sibling::base64 | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>document-id</code> is not expected to follow <code>citation</code>, <code>rlink</code>, <code>base64</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-document-id-field"/>
   </xsl:template>
   <xsl:template match="rlink/hash/text()" mode="test"/>
   <xsl:template priority="5" match="rlink/hash" mode="test">
      <xsl:call-template name="require-for-hash-field"/>
   </xsl:template>
   <xsl:template match="resource/remarks/text()" mode="test"/>
   <xsl:template priority="5" match="resource/remarks" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::remarks) gt 1"/>
         <xsl:with-param name="msg">
            <code>remarks</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-remarks-field"/>
   </xsl:template>
   <xsl:template match="prop/remarks/text()" mode="test"/>
   <xsl:template priority="5" match="prop/remarks" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::remarks) gt 1"/>
         <xsl:with-param name="msg">
            <code>remarks</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-remarks-field"/>
   </xsl:template>
   <xsl:template match="responsible-party/party-uuid/text()" mode="test"/>
   <xsl:template priority="5" match="responsible-party/party-uuid" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>party-uuid</code> is not expected to follow <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-party-uuid-field"/>
   </xsl:template>
   <xsl:template match="responsible-party/remarks/text()" mode="test"/>
   <xsl:template priority="5" match="responsible-party/remarks" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::remarks) gt 1"/>
         <xsl:with-param name="msg">
            <code>remarks</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-remarks-field"/>
   </xsl:template>
   <xsl:template match="responsible-role/party-uuid/text()" mode="test"/>
   <xsl:template priority="5" match="responsible-role/party-uuid" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>party-uuid</code> is not expected to follow <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-party-uuid-field"/>
   </xsl:template>
   <xsl:template match="responsible-role/remarks/text()" mode="test"/>
   <xsl:template priority="5" match="responsible-role/remarks" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::remarks) gt 1"/>
         <xsl:with-param name="msg">
            <code>remarks</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-remarks-field"/>
   </xsl:template>
   <xsl:template match="address/addr-line/text()" mode="test"/>
   <xsl:template priority="5" match="address/addr-line" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::city | preceding-sibling::state | preceding-sibling::postal-code | preceding-sibling::country )"/>
         <xsl:with-param name="msg">
            <code>addr-line</code> is not expected to follow <code>city</code>, <code>state</code>, <code>postal-code</code>,  or <code>country</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-addr-line-field"/>
   </xsl:template>
   <xsl:template match="group/title/text()" mode="test"/>
   <xsl:template priority="5" match="group/title" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::title) gt 1"/>
         <xsl:with-param name="msg">
            <code>title</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::param | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::part | preceding-sibling::group | preceding-sibling::control )"/>
         <xsl:with-param name="msg">
            <code>title</code> is not expected to follow <code>param</code>, <code>prop</code>, <code>link</code>, <code>part</code>, <code>group</code>,  or <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-group_..._title-field"/>
   </xsl:template>
   <xsl:template match="control/title/text()" mode="test"/>
   <xsl:template priority="5" match="control/title" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::title) gt 1"/>
         <xsl:with-param name="msg">
            <code>title</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::param | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::part | preceding-sibling::control )"/>
         <xsl:with-param name="msg">
            <code>title</code> is not expected to follow <code>param</code>, <code>prop</code>, <code>link</code>, <code>part</code>,  or <code>control</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-control_..._title-field"/>
   </xsl:template>
   <xsl:template match="part/title/text()" mode="test"/>
   <xsl:template priority="5" match="part/title" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::title) gt 1"/>
         <xsl:with-param name="msg">
            <code>title</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prop | preceding-sibling::prose | preceding-sibling::part | preceding-sibling::link )"/>
         <xsl:with-param name="msg">
            <code>title</code> is not expected to follow <code>prop</code>, <code>prose</code>, <code>part</code>,  or <code>link</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-part_..._title-field"/>
   </xsl:template>
   <xsl:template match="param/label/text()" mode="test"/>
   <xsl:template priority="5" match="param/label" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::label) gt 1"/>
         <xsl:with-param name="msg">
            <code>label</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::usage | preceding-sibling::constraint | preceding-sibling::guideline | preceding-sibling::value | preceding-sibling::select | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>label</code> is not expected to follow <code>usage</code>, <code>constraint</code>, <code>guideline</code>, <code>value</code>, <code>select</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-parameter_..._label-field"/>
   </xsl:template>
   <xsl:template match="param/usage/text()" mode="test"/>
   <xsl:template priority="5" match="param/usage" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::usage) gt 1"/>
         <xsl:with-param name="msg">
            <code>usage</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::constraint | preceding-sibling::guideline | preceding-sibling::value | preceding-sibling::select | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>usage</code> is not expected to follow <code>constraint</code>, <code>guideline</code>, <code>value</code>, <code>select</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-parameter_..._usage-field"/>
   </xsl:template>
   <xsl:template match="parameter-constraint/description/text()" mode="test"/>
   <xsl:template priority="5" match="parameter-constraint/description" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::description) gt 1"/>
         <xsl:with-param name="msg">
            <code>description</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::test )"/>
         <xsl:with-param name="msg">
            <code>description</code> is not expected to follow <code>test</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-parameter-constraint_..._description-field"/>
   </xsl:template>
   <xsl:template match="test/expression/text()" mode="test"/>
   <xsl:template priority="5" match="test/expression" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::expression) gt 1"/>
         <xsl:with-param name="msg">
            <code>expression</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>expression</code> is not expected to follow <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-parameter-constraint_..._test_..._expression-field"/>
   </xsl:template>
   <xsl:template match="parameter-selection/choice/text()" mode="test"/>
   <xsl:template priority="5" match="parameter-selection/choice" mode="test">
      <xsl:call-template name="require-for-parameter-selection_..._parameter-choice-field"/>
   </xsl:template>
   <xsl:template match="metadata/title/text()" mode="test"/>
   <xsl:template priority="5" match="metadata/title" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::title) gt 1"/>
         <xsl:with-param name="msg">
            <code>title</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::published | preceding-sibling::last-modified | preceding-sibling::version | preceding-sibling::oscal-version | preceding-sibling::revisions/revision | preceding-sibling::document-id | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::role | preceding-sibling::location | preceding-sibling::party | preceding-sibling::responsible-party | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>title</code> is not expected to follow <code>published</code>, <code>last-modified</code>, <code>version</code>, <code>oscal-version</code>, <code>revisions/revision</code>, <code>document-id</code>, <code>prop</code>, <code>link</code>, <code>role</code>, <code>location</code>, <code>party</code>, <code>responsible-party</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-metadata_..._title-field"/>
   </xsl:template>
   <xsl:template match="revision/title/text()" mode="test"/>
   <xsl:template priority="5" match="revision/title" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::title) gt 1"/>
         <xsl:with-param name="msg">
            <code>title</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::published | preceding-sibling::last-modified | preceding-sibling::version | preceding-sibling::oscal-version | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>title</code> is not expected to follow <code>published</code>, <code>last-modified</code>, <code>version</code>, <code>oscal-version</code>, <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-revision_..._title-field"/>
   </xsl:template>
   <xsl:template match="location/title/text()" mode="test"/>
   <xsl:template priority="5" match="location/title" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::title) gt 1"/>
         <xsl:with-param name="msg">
            <code>title</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::address | preceding-sibling::email-address | preceding-sibling::telephone-number | preceding-sibling::url | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>title</code> is not expected to follow <code>address</code>, <code>email-address</code>, <code>telephone-number</code>, <code>url</code>, <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-location_..._title-field"/>
   </xsl:template>
   <xsl:template match="location/url/text()" mode="test"/>
   <xsl:template priority="5" match="location/url" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>url</code> is not expected to follow <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-location_..._url-field"/>
   </xsl:template>
   <xsl:template match="party/name/text()" mode="test"/>
   <xsl:template priority="5" match="party/name" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::name) gt 1"/>
         <xsl:with-param name="msg">
            <code>name</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::short-name | preceding-sibling::external-id | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::email-address | preceding-sibling::telephone-number | preceding-sibling::address | preceding-sibling::location-uuid | preceding-sibling::member-of-organization | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>name</code> is not expected to follow <code>short-name</code>, <code>external-id</code>, <code>prop</code>, <code>link</code>, <code>email-address</code>, <code>telephone-number</code>, <code>address</code>, <code>location-uuid</code>, <code>member-of-organization</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-party_..._name-field"/>
   </xsl:template>
   <xsl:template match="party/short-name/text()" mode="test"/>
   <xsl:template priority="5" match="party/short-name" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::short-name) gt 1"/>
         <xsl:with-param name="msg">
            <code>short-name</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::external-id | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::email-address | preceding-sibling::telephone-number | preceding-sibling::address | preceding-sibling::location-uuid | preceding-sibling::member-of-organization | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>short-name</code> is not expected to follow <code>external-id</code>, <code>prop</code>, <code>link</code>, <code>email-address</code>, <code>telephone-number</code>, <code>address</code>, <code>location-uuid</code>, <code>member-of-organization</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-party_..._short-name-field"/>
   </xsl:template>
   <xsl:template match="party/external-id/text()" mode="test"/>
   <xsl:template priority="5" match="party/external-id" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prop | preceding-sibling::link | preceding-sibling::email-address | preceding-sibling::telephone-number | preceding-sibling::address | preceding-sibling::location-uuid | preceding-sibling::member-of-organization | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>external-id</code> is not expected to follow <code>prop</code>, <code>link</code>, <code>email-address</code>, <code>telephone-number</code>, <code>address</code>, <code>location-uuid</code>, <code>member-of-organization</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-party_..._external-id-field"/>
   </xsl:template>
   <xsl:template match="party/member-of-organization/text()" mode="test"/>
   <xsl:template priority="5" match="party/member-of-organization" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>member-of-organization</code> is not expected to follow <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-party_..._member-of-organization-field"/>
   </xsl:template>
   <xsl:template match="role/title/text()" mode="test"/>
   <xsl:template priority="5" match="role/title" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::title) gt 1"/>
         <xsl:with-param name="msg">
            <code>title</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::short-name | preceding-sibling::description | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>title</code> is not expected to follow <code>short-name</code>, <code>description</code>, <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-role_..._title-field"/>
   </xsl:template>
   <xsl:template match="role/short-name/text()" mode="test"/>
   <xsl:template priority="5" match="role/short-name" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::short-name) gt 1"/>
         <xsl:with-param name="msg">
            <code>short-name</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::description | preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>short-name</code> is not expected to follow <code>description</code>, <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-role_..._short-name-field"/>
   </xsl:template>
   <xsl:template match="role/description/text()" mode="test"/>
   <xsl:template priority="5" match="role/description" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::description) gt 1"/>
         <xsl:with-param name="msg">
            <code>description</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prop | preceding-sibling::link | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>description</code> is not expected to follow <code>prop</code>, <code>link</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-role_..._description-field"/>
   </xsl:template>
   <xsl:template match="resource/title/text()" mode="test"/>
   <xsl:template priority="5" match="resource/title" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::title) gt 1"/>
         <xsl:with-param name="msg">
            <code>title</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::description | preceding-sibling::prop | preceding-sibling::document-id | preceding-sibling::citation | preceding-sibling::rlink | preceding-sibling::base64 | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>title</code> is not expected to follow <code>description</code>, <code>prop</code>, <code>document-id</code>, <code>citation</code>, <code>rlink</code>, <code>base64</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-back-matter_..._resource_..._title-field"/>
   </xsl:template>
   <xsl:template match="resource/description/text()" mode="test"/>
   <xsl:template priority="5" match="resource/description" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::description) gt 1"/>
         <xsl:with-param name="msg">
            <code>description</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prop | preceding-sibling::document-id | preceding-sibling::citation | preceding-sibling::rlink | preceding-sibling::base64 | preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>description</code> is not expected to follow <code>prop</code>, <code>document-id</code>, <code>citation</code>, <code>rlink</code>, <code>base64</code>,  or <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-back-matter_..._resource_..._description-field"/>
   </xsl:template>
   <xsl:template match="citation/text/text()" mode="test"/>
   <xsl:template priority="5" match="citation/text" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::text) gt 1"/>
         <xsl:with-param name="msg">
            <code>text</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::prop | preceding-sibling::link )"/>
         <xsl:with-param name="msg">
            <code>text</code> is not expected to follow <code>prop</code> or <code>link</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-back-matter_..._resource_..._citation_..._text-field"/>
   </xsl:template>
   <xsl:template match="resource/base64/text()" mode="test"/>
   <xsl:template priority="5" match="resource/base64" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::base64) gt 1"/>
         <xsl:with-param name="msg">
            <code>base64</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::remarks )"/>
         <xsl:with-param name="msg">
            <code>base64</code> is not expected to follow <code>remarks</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-back-matter_..._resource_..._base64-field"/>
   </xsl:template>
   <xsl:template match="link/text/text()" mode="test"/>
   <xsl:template priority="5" match="link/text" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::text) gt 1"/>
         <xsl:with-param name="msg">
            <code>text</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-link_..._text-field"/>
   </xsl:template>
   <xsl:template match="address/city/text()" mode="test"/>
   <xsl:template priority="5" match="address/city" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::city) gt 1"/>
         <xsl:with-param name="msg">
            <code>city</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::state | preceding-sibling::postal-code | preceding-sibling::country )"/>
         <xsl:with-param name="msg">
            <code>city</code> is not expected to follow <code>state</code>, <code>postal-code</code>,  or <code>country</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-address_..._city-field"/>
   </xsl:template>
   <xsl:template match="address/state/text()" mode="test"/>
   <xsl:template priority="5" match="address/state" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::state) gt 1"/>
         <xsl:with-param name="msg">
            <code>state</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::postal-code | preceding-sibling::country )"/>
         <xsl:with-param name="msg">
            <code>state</code> is not expected to follow <code>postal-code</code> or <code>country</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-address_..._state-field"/>
   </xsl:template>
   <xsl:template match="address/postal-code/text()" mode="test"/>
   <xsl:template priority="5" match="address/postal-code" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::postal-code) gt 1"/>
         <xsl:with-param name="msg">
            <code>postal-code</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::country )"/>
         <xsl:with-param name="msg">
            <code>postal-code</code> is not expected to follow <code>country</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-address_..._postal-code-field"/>
   </xsl:template>
   <xsl:template match="address/country/text()" mode="test"/>
   <xsl:template priority="5" match="address/country" mode="test">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::country) gt 1"/>
         <xsl:with-param name="msg">
            <code>country</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-address_..._country-field"/>
   </xsl:template>
   <xsl:template match="param/@depends-on" mode="test">
      <xsl:call-template name="require-for-depends-on-flag"/>
   </xsl:template>
   <xsl:template match="back-matter/resource/rlink/@media-type" mode="test">
      <xsl:call-template name="require-for-media-type-flag"/>
   </xsl:template>
   <xsl:template match="back-matter/resource/base64/@media-type" mode="test">
      <xsl:call-template name="require-for-media-type-flag"/>
   </xsl:template>
   <xsl:template match="link/@media-type" mode="test">
      <xsl:call-template name="require-for-media-type-flag"/>
   </xsl:template>
   <xsl:template match="address/@type" mode="test">
      <xsl:call-template name="require-for-location-type-flag"/>
   </xsl:template>
   <xsl:template match="catalog/@uuid" mode="test">
      <xsl:call-template name="require-for-catalog_..._uuid-flag"/>
   </xsl:template>
   <xsl:template match="group/@id" mode="test">
      <xsl:call-template name="require-for-group_..._id-flag"/>
   </xsl:template>
   <xsl:template match="group/@class" mode="test">
      <xsl:call-template name="require-for-group_..._class-flag"/>
   </xsl:template>
   <xsl:template match="control/@id" mode="test">
      <xsl:call-template name="require-for-control_..._id-flag"/>
   </xsl:template>
   <xsl:template match="control/@class" mode="test">
      <xsl:call-template name="require-for-control_..._class-flag"/>
   </xsl:template>
   <xsl:template match="part/@id" mode="test">
      <xsl:call-template name="require-for-part_..._id-flag"/>
   </xsl:template>
   <xsl:template match="part/@name" mode="test">
      <xsl:call-template name="require-for-part_..._name-flag"/>
   </xsl:template>
   <xsl:template match="part/@ns" mode="test">
      <xsl:call-template name="require-for-part_..._ns-flag"/>
   </xsl:template>
   <xsl:template match="part/@class" mode="test">
      <xsl:call-template name="require-for-part_..._class-flag"/>
   </xsl:template>
   <xsl:template match="param/@id" mode="test">
      <xsl:call-template name="require-for-parameter_..._id-flag"/>
   </xsl:template>
   <xsl:template match="param/@class" mode="test">
      <xsl:call-template name="require-for-parameter_..._class-flag"/>
   </xsl:template>
   <xsl:template match="parameter-selection/@how-many" mode="test">
      <xsl:call-template name="require-for-parameter-selection_..._how-many-flag"/>
   </xsl:template>
   <xsl:template match="location/@uuid" mode="test">
      <xsl:call-template name="require-for-location_..._uuid-flag"/>
   </xsl:template>
   <xsl:template match="party/@uuid" mode="test">
      <xsl:call-template name="require-for-party_..._uuid-flag"/>
   </xsl:template>
   <xsl:template match="party/@type" mode="test">
      <xsl:call-template name="require-for-party_..._type-flag"/>
   </xsl:template>
   <xsl:template match="party/external-id/@scheme" mode="test">
      <xsl:call-template name="require-for-party_..._external-id_..._scheme-flag"/>
   </xsl:template>
   <xsl:template match="role/@id" mode="test">
      <xsl:call-template name="require-for-role_..._id-flag"/>
   </xsl:template>
   <xsl:template match="back-matter/resource/@uuid" mode="test">
      <xsl:call-template name="require-for-back-matter_..._resource_..._uuid-flag"/>
   </xsl:template>
   <xsl:template match="back-matter/resource/rlink/@href" mode="test">
      <xsl:call-template name="require-for-back-matter_..._resource_..._rlink_..._href-flag"/>
   </xsl:template>
   <xsl:template match="back-matter/resource/base64/@filename" mode="test">
      <xsl:call-template name="require-for-back-matter_..._resource_..._base64_..._filename-flag"/>
   </xsl:template>
   <xsl:template match="prop/@name" mode="test">
      <xsl:call-template name="require-for-property_..._name-flag"/>
   </xsl:template>
   <xsl:template match="prop/@uuid" mode="test">
      <xsl:call-template name="require-for-property_..._uuid-flag"/>
   </xsl:template>
   <xsl:template match="prop/@ns" mode="test">
      <xsl:call-template name="require-for-property_..._ns-flag"/>
   </xsl:template>
   <xsl:template match="prop/@value" mode="test">
      <xsl:call-template name="require-for-property_..._value-flag"/>
   </xsl:template>
   <xsl:template match="prop/@class" mode="test">
      <xsl:call-template name="require-for-property_..._class-flag"/>
   </xsl:template>
   <xsl:template match="link/@href" mode="test">
      <xsl:call-template name="require-for-link_..._href-flag"/>
   </xsl:template>
   <xsl:template match="link/@rel" mode="test">
      <xsl:call-template name="require-for-link_..._rel-flag"/>
   </xsl:template>
   <xsl:template match="responsible-party/@role-id" mode="test">
      <xsl:call-template name="require-for-responsible-party_..._role-id-flag"/>
   </xsl:template>
   <xsl:template match="responsible-role/@role-id" mode="test">
      <xsl:call-template name="require-for-responsible-role_..._role-id-flag"/>
   </xsl:template>
   <xsl:template match="hash/@algorithm" mode="test">
      <xsl:call-template name="require-for-hash_..._algorithm-flag"/>
   </xsl:template>
   <xsl:template match="telephone-number/@type" mode="test">
      <xsl:call-template name="require-for-telephone-number_..._type-flag"/>
   </xsl:template>
   <xsl:template match="document-id/@scheme" mode="test">
      <xsl:call-template name="require-for-document-id_..._scheme-flag"/>
   </xsl:template>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Fallbacks for occurrences of known elements and attributes, except out of context -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template mode="test"
                 match="catalog | metadata | param | control | group | back-matter | title | prop | link | part | label | usage | constraint | guideline | value | select | remarks | description | test | expression | choice | published | last-modified | version | oscal-version | revision | document-id | role | location | party | responsible-party | address | email-address | telephone-number | url | name | short-name | external-id | location-uuid | member-of-organization | resource | citation | text | rlink | hash | base64 | party-uuid | addr-line | city | state | postal-code | country">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">context</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> is not expected here.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template mode="test"
                 match="@uuid | @id | @class | @name | @ns | @depends-on | @how-many | @type | @href | @media-type | @value | @rel | @role-id | @algorithm | @scheme">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">context</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">
            <code>@{ name() }</code> is not expected here.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Definitions - a named template for each -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template name="require-for-catalog-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@uuid)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@uuid</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(metadata)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>metadata</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-catalog_..._uuid-flag">
      <xsl:call-template name="check-uuid-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-group-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(title)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>title</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-group_..._id-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-group_..._class-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template match="group/title/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-group_..._title-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-control-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@id)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@id</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(title)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>title</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-control_..._id-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-control_..._class-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template match="control/title/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-control_..._title-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-part-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@name</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates mode="validate-markup-multiline"/>
   </xsl:template>
   <xsl:template match="group/part/p | control/part/p | part/part/p | group/part/ul | control/part/ul | part/part/ul | group/part/ol | control/part/ol | part/part/ol | group/part/table | control/part/table | part/part/table | group/part/pre | control/part/pre | part/part/pre | group/part/h1 | control/part/h1 | part/part/h1 | group/part/h2 | control/part/h2 | part/part/h2 | group/part/h3 | control/part/h3 | part/part/h3 | group/part/h4 | control/part/h4 | part/part/h4 | group/part/h5 | control/part/h5 | part/part/h5 | group/part/h6 | control/part/h6 | part/part/h6"
                 mode="validate"/>
   <xsl:template name="require-for-part_..._id-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-part_..._name-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-part_..._ns-flag">
      <xsl:call-template name="check-uri-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-part_..._class-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template match="part/title/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-part_..._title-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template match="part/prose/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-part_..._prose-field">
      <xsl:call-template name="check-markup-multiline-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-parameter-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@id)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@id</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-parameter_..._id-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-parameter_..._class-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template match="param/label/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-parameter_..._label-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template match="param/usage/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-parameter_..._usage-field">
      <xsl:call-template name="check-markup-multiline-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-parameter-constraint-assembly"/>
   <xsl:template match="parameter-constraint/description/*"
                 priority="7"
                 mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-parameter-constraint_..._description-field">
      <xsl:call-template name="check-markup-multiline-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-parameter-constraint_..._test-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(expression)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>expression</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-parameter-constraint_..._test_..._expression-field"/>
   <xsl:template name="require-for-parameter-guideline-assembly">
      <xsl:apply-templates mode="validate-markup-multiline"/>
   </xsl:template>
   <xsl:template match="param/guideline/p | param/guideline/ul | param/guideline/ol | param/guideline/table | param/guideline/pre | param/guideline/h1 | param/guideline/h2 | param/guideline/h3 | param/guideline/h4 | param/guideline/h5 | param/guideline/h6"
                 mode="validate"/>
   <xsl:template match="parameter-guideline/prose/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-parameter-guideline_..._prose-field">
      <xsl:call-template name="check-markup-multiline-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-parameter-value-field"/>
   <xsl:template name="require-for-parameter-selection-assembly"/>
   <xsl:template name="require-for-parameter-selection_..._how-many-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template match="parameter-selection/choice/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-parameter-selection_..._parameter-choice-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-depends-on-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-control-id-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-metadata-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(title)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>title</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(last-modified)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>last-modified</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(version)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>version</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(oscal-version)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>oscal-version</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="metadata/title/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-metadata_..._title-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-revision-assembly"/>
   <xsl:template match="revision/title/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-revision_..._title-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-location-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@uuid)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@uuid</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(address)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>address</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-location_..._uuid-flag">
      <xsl:call-template name="check-uuid-datatype"/>
   </xsl:template>
   <xsl:template match="location/title/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-location_..._title-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-location_..._url-field">
      <xsl:call-template name="check-uri-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-location-uuid-flag">
      <xsl:call-template name="check-uuid-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-location-uuid-field">
      <xsl:call-template name="check-uuid-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-party-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@uuid)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@uuid</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@type)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@type</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-party_..._uuid-flag">
      <xsl:call-template name="check-uuid-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-party_..._type-flag"/>
   <xsl:template name="require-for-party_..._name-field"/>
   <xsl:template name="require-for-party_..._short-name-field"/>
   <xsl:template name="require-for-party_..._external-id-field">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@scheme)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@scheme</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-party_..._external-id_..._scheme-flag">
      <xsl:call-template name="check-uri-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-party_..._member-of-organization-field">
      <xsl:call-template name="check-uuid-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-party-uuid-field">
      <xsl:call-template name="check-uuid-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-role-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@id)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@id</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(title)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>title</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-role_..._id-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template match="role/title/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-role_..._title-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-role_..._short-name-field"/>
   <xsl:template match="role/description/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-role_..._description-field">
      <xsl:call-template name="check-markup-multiline-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-role-id-field">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-back-matter-assembly"/>
   <xsl:template name="require-for-back-matter_..._resource-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@uuid)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@uuid</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-back-matter_..._resource_..._uuid-flag">
      <xsl:call-template name="check-uuid-datatype"/>
   </xsl:template>
   <xsl:template match="resource/title/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-back-matter_..._resource_..._title-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template match="resource/description/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-back-matter_..._resource_..._description-field">
      <xsl:call-template name="check-markup-multiline-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-back-matter_..._resource_..._citation-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(text)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>text</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="citation/text/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-back-matter_..._resource_..._citation_..._text-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-back-matter_..._resource_..._rlink-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@href)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@href</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-back-matter_..._resource_..._rlink_..._href-flag">
      <xsl:call-template name="check-uri-reference-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-back-matter_..._resource_..._base64-field">
      <xsl:call-template name="check-base64Binary-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-back-matter_..._resource_..._base64_..._filename-flag">
      <xsl:call-template name="check-uri-reference-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-property-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@name</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@value)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@value</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-property_..._name-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-property_..._uuid-flag">
      <xsl:call-template name="check-uuid-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-property_..._ns-flag">
      <xsl:call-template name="check-uri-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-property_..._value-flag"/>
   <xsl:template name="require-for-property_..._class-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-link-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@href)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@href</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-link_..._href-flag">
      <xsl:call-template name="check-uri-reference-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-link_..._rel-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template match="link/text/*" priority="7" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-link_..._text-field">
      <xsl:call-template name="check-markup-line-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-responsible-party-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@role-id)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@role-id</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(party-uuid)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>party-uuid</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-responsible-party_..._role-id-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-responsible-role-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@role-id)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@role-id</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-responsible-role_..._role-id-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-hash-field">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@algorithm)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@algorithm</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-hash_..._algorithm-flag"/>
   <xsl:template name="require-for-media-type-flag"/>
   <xsl:template match="remarks/*" priority="5" mode="validate">
      <xsl:apply-templates mode="value-only"/>
   </xsl:template>
   <xsl:template name="require-for-remarks-field">
      <xsl:call-template name="check-markup-multiline-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-published-field">
      <xsl:call-template name="check-dateTime-with-timezone-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-last-modified-field">
      <xsl:call-template name="check-dateTime-with-timezone-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-version-field"/>
   <xsl:template name="require-for-oscal-version-field"/>
   <xsl:template name="require-for-email-address-field">
      <xsl:call-template name="check-email-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-telephone-number-field"/>
   <xsl:template name="require-for-telephone-number_..._type-flag"/>
   <xsl:template name="require-for-address-assembly"/>
   <xsl:template name="require-for-address_..._city-field"/>
   <xsl:template name="require-for-address_..._state-field"/>
   <xsl:template name="require-for-address_..._postal-code-field"/>
   <xsl:template name="require-for-address_..._country-field"/>
   <xsl:template name="require-for-addr-line-field"/>
   <xsl:template name="require-for-location-type-flag">
      <xsl:call-template name="check-token-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-document-id-field"/>
   <xsl:template name="require-for-document-id_..._scheme-flag">
      <xsl:call-template name="check-uri-datatype"/>
   </xsl:template>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Datatypes - a named template for each occurring -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template name="check-uuid-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="condition" select="not( pb:datatype-validate(.,'uuid') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> does not conform to <em>uuid</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-token-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="condition" select="not( pb:datatype-validate(.,'token') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> does not conform to <em>token</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-uri-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="condition" select="not( pb:datatype-validate(.,'uri') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> does not conform to <em>uri</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-string-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="condition" select="not( pb:datatype-validate(.,'string') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> does not conform to <em>string</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-uri-reference-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not( pb:datatype-validate(.,'uri-reference') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> does not conform to <em>uri-reference</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-base64Binary-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="condition" select="not( pb:datatype-validate(.,'base64Binary') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> does not conform to <em>base64Binary</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-dateTime-with-timezone-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not( pb:datatype-validate(.,'dateTime-with-timezone') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> does not conform to <em>dateTime-with-timezone</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-email-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="condition" select="not( pb:datatype-validate(.,'email') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> does not conform to <em>email</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="ul | ol" mode="validate-markup-multiline">
      <xsl:apply-templates select="li" mode="validate-markup-multiline"/>
      <xsl:for-each select="* except li">
         <xsl:call-template name="notice-multiline"/>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="table" mode="validate-markup-multiline">
      <xsl:apply-templates select="tr" mode="validate-markup-multiline"/>
      <xsl:for-each select="* except tr">
         <xsl:call-template name="notice-multiline"/>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="tr" mode="validate-markup-multiline">
      <xsl:apply-templates select="td" mode="validate-markup-multiline"/>
      <xsl:for-each select="* except td">
         <xsl:call-template name="notice-multiline"/>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="p | li | h1 | h2 | h3 | h4 | h5 | h6"
                 mode="validate-markup-multiline">
      <xsl:apply-templates mode="validate-markup-multiline" select="@*"/>
      <xsl:apply-templates mode="validate-markup-line"/>
   </xsl:template>
   <xsl:template match="em | i | strong | b | u | q | code | img | insert"
                 mode="validate-markup-line">
      <xsl:apply-templates mode="validate-markup-line" select="@*"/>
      <xsl:apply-templates mode="validate-markup-line"/>
   </xsl:template>
   <xsl:template match="a/@href | img/@src | img/@title | insert/@type | insert/@id-ref"
                 mode="validate-markup-line"/>
   <xsl:template match="p/text() | li/text() | h1/text() | h2/text() | h3/text() | h4/text() | h5/text() | h6/text()"
                 mode="test"/>
   <xsl:template match="em/text() | i/text() | strong/text() | b/text() | u/text() | q/text() | code/text() | a/text()"
                 mode="test"/>
</xsl:transform>
