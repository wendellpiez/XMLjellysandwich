<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    xmlns:XJS="http://github.com/wendellpiez/XMLjellysandwich"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map" extension-element-prefixes="ixsl"
    exclude-result-prefixes="#all" xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">

    <xsl:output indent="yes"/>

    <xsl:param name="fileName" as="xs:string"/>


<!-- to do:
    
    mark 'withdrawn' controls
    rewrite td/@colspan with an increment ...
    -->
    <xsl:variable name="indented-serialization" as="element()">
        <output:serialization-parameters
            xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
            <output:indent value="true"/>
        </output:serialization-parameters>
    </xsl:variable>


    <!-- 'initialize' is called with a copy of the Rev 5 catalog as input
          we could save cycles by doing this statically up front, but for now -->
    <xsl:template name="initialize">
        <xsl:result-document href="#bxbody" method="ixsl:append-content">
            <xsl:call-template name="make-full-table"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="/" name="make-full-table">
        <xsl:variable name="ready-catalog">
            <xsl:apply-templates select="/*" mode="capture-controls"/>
        </xsl:variable>
        <xsl:apply-templates select="$ready-catalog" mode="make-table"/>
    </xsl:template>


    <xsl:mode name="capture-controls" on-no-match="text-only-copy"/>

    <xsl:template match="catalog" mode="capture-controls">
        <xsl:copy>
            <xsl:apply-templates select="metadata, group" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="metadata" mode="capture-controls">
        <xsl:copy>
            <xsl:copy-of select="title"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="group" mode="capture-controls">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="title, prop"/>
            <xsl:apply-templates select="group | control" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <!--<link rel="incorporated-into" href="#ac-2_smt.k"/>-->
    <xsl:template match="control" mode="capture-controls">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="title, prop, link[@rel='incorporated-into']"/>
            <xsl:apply-templates select="control" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:mode name="make-table" on-no-match="text-only-copy"/>


    <xsl:template match="catalog" mode="make-table">
        <xsl:apply-templates select="group" mode="#current"/>
    </xsl:template>

    <xsl:template match="catalog/group" mode="make-table" expand-text="true">
        <details class="family" id="{@id}">
          <summary>
            <xsl:apply-templates select="title" mode="#current"/>
          </summary>
            <table class="control-matrix" id="{@id}-matrix">
                <tr class="control-matrix-header">
                    <th class="controlno">Control number</th>
                    <!--extra 'span' wrapper to accommodate CSS -->
                    <th class="controltitle">Control name<br class="br"/><span class="enhancement"><span class="title">control enhancement name</span></span></th>
                </tr>
                <xsl:apply-templates select="group | control" mode="make-table"/>
            </table>
        </details>
    </xsl:template>

    <xsl:template match="group/title" mode="make-table" expand-text="true">
        <span class="h2 title">
            <xsl:apply-templates/>
            <xsl:text> family </xsl:text>
            <span class="controlno">({ ../@id }) </span>
        </span>
    </xsl:template>


    <xsl:template match="control" mode="make-table">
        <xsl:variable name="withdrawn" select="prop[@name='status']='withdrawn'"/>
        <tr id="{@id}"
            class="{ if (contains(@class,'enhancement') or exists(parent::control)) then 'enhancement' else 'control' } lineitem{ ' withdrawn'[$withdrawn] }">
            <td class="controlno">
                <xsl:apply-templates mode="#current" select="prop[@name = 'label']"/>
            </td>
            <td class="controltitle">
                <xsl:apply-templates mode="#current" select="title"/>
            </td>
            <xsl:if test="$withdrawn">
            <td colspan="1" class="withdrawnnotice">
                <xsl:text>W</xsl:text>
                <xsl:for-each-group select="link[@rel='incorporated-into']" group-by="true()">
                    <xsl:text>: Incorporated into </xsl:text>
                    <xsl:variable name="control-targets" select="current-group()/@href ! replace(.,'^#','')"/>
                    <xsl:value-of select="$control-targets ! XJS:label-for-id(.)" separator=", "/>
                </xsl:for-each-group>
            </td>
            </xsl:if>
        </tr>
        <xsl:apply-templates mode="#current" select="control"/>
    </xsl:template>

    <xsl:function name="XJS:label-for-id" as="xs:string">
        <xsl:param name="id" as="xs:string"/>
        <xsl:value-of>
            <xsl:analyze-string select="replace($id,'_.*$','')" regex="\.(.+)$">
                <xsl:matching-substring>
                    <xsl:text>(</xsl:text>
                    <xsl:value-of select="regex-group(1)"/>
                    <xsl:text>)</xsl:text>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="upper-case(.)"/>
                </xsl:non-matching-substring>                
            </xsl:analyze-string>
        </xsl:value-of>
    </xsl:function>
    
    <xsl:template mode="control-label" match="control">
        <xsl:value-of select="prop[@name='label']"/>
    </xsl:template>
    
    <xsl:template match="title" mode="make-table">
        <span class="title">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>

    <xsl:template match="prop" mode="make-table">
        <span class="{@name}">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>

    <!-- Entry point for updating a table with information about the
     baseline. We do this by rewriting the tables presently on the page. -->
    <xsl:template name="amend-table">
      <xsl:variable name="baseline-profile" select="/"/>
        <xsl:variable name="is-okay-as-sp800-53-profile" as="xs:boolean"
            select="exists($baseline-profile/profile)"/>
      <xsl:variable name="profile-code">
        <xsl:sequence>
          <xsl:apply-templates select="$baseline-profile/profile/metadata" mode="profile-code"/>
          <xsl:on-empty select="'profile_' || string(count( ixsl:page()/id('file-roster')/html:div ) + 1)"/>
        </xsl:sequence>
      </xsl:variable>
    
        <xsl:result-document href="#file-roster" method="ixsl:append-content" expand-text="true">
            <div class="filelisting">
                <h4>
                  <span class="profilecode">
                    <xsl:sequence select="$profile-code"/>
                  </span>
                  <xsl:text> file: { $fileName }</xsl:text>
                </h4>
                <p>
                  <xsl:apply-templates select="$baseline-profile/profile/metadata/title"/>
                </p>
                <!--<p>Tests okay: <code>{ $is-okay-as-sp800-53-profile }</code></p>
                <details>
                    <summary>XML source</summary>
                    <pre>
                <xsl:value-of select="serialize($baseline-profile, $indented-serialization)"/>
            </pre>
                </details>-->
            </div>
        </xsl:result-document>

        <!-- we aim for the families currently displayed on the page -->
      <xsl:variable name="families"
        select="ixsl:page()//html:details[@class = 'family']/@id/string(.)"/>
        <xsl:for-each select="$families">
            <xsl:variable name="table-id" expand-text="true">{.}-matrix</xsl:variable>
            <!-- here we target the table and rewrite it with
                 a new table, produced by processing the old one,
                 passing in the profile as $profile -->
            <xsl:result-document href="#{ $table-id }" method="ixsl:replace-content">
                <xsl:apply-templates mode="amend-table" select="ixsl:page()/id($table-id)">
                    <xsl:with-param tunnel="true" name="profile" select="$baseline-profile"/>
                  <xsl:with-param tunnel="true" name="profile-code" select="$profile-code"/>
                </xsl:apply-templates>
            </xsl:result-document>
        </xsl:for-each>

    </xsl:template>

    <!-- Mostly the new table is a copy of the old one -->
    <xsl:mode name="amend-table" on-no-match="shallow-copy"/>


    <!-- But don't copy the table itself ...  -->
    <xsl:template mode="amend-table" match="html:table">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>

    <xsl:template mode="amend-table" match="html:tr/html:th[last()]">
      <xsl:param tunnel="true" name="profile" as="document-node()" required="true"/>
      <xsl:param tunnel="true" name="profile-code" required="true"/>
      <xsl:next-match/>
        <th class="occurtitle">
          <div>
            <span>
              <xsl:sequence select="$profile-code"/> 
            </span>
          </div>
        </th>
    </xsl:template>

  <xsl:template mode="profile-code" match="metadata[title='NIST Special Publication 800-53 Revision 5 LOW IMPACT BASELINE']">FISMA LOW</xsl:template>
  
  <xsl:template mode="profile-code" match="metadata[title='NIST Special Publication 800-53 Revision 5 MODERATE IMPACT BASELINE']">FISMA MOD</xsl:template>
  
  <xsl:template mode="profile-code" match="metadata[title='NIST Special Publication 800-53 Revision 5 HIGH IMPACT BASELINE']">FISMA HIGH</xsl:template>
  
  <xsl:template mode="profile-code" match="metadata[title='NIST Special Publication 800-53 Revision 5 PRIVACY BASELINE']">FISMA PRIVACY</xsl:template>
  
  
  
      <!-- profiles we don't recognize get a dynamic code assignment (above) -->
      <xsl:template mode="profile-code" match="metadata"/>
      
  
    <xsl:template priority="10" mode="amend-table" match="html:tr[contains-token(@class,'withdrawn')]/html:td[last()]">
        <td colspan="{ number(@colspan) + 1}" class="withdrawnnotice">
            <xsl:apply-templates mode="#current"/>
        </td>
    </xsl:template>
    
    <xsl:template mode="amend-table" match="html:tr/html:td[last()]">
        <xsl:param tunnel="true" name="profile" as="document-node()" required="true"/>
        <xsl:variable name="controlid" select="parent::html:tr/@id"/>
        <xsl:next-match/>
        <xsl:message expand-text="true">{ $controlid } CELL -</xsl:message>
        <td class="occur">
            <xsl:sequence select="XJS:mark-baseline-occurrence($profile, $controlid)"/>
        </td>
    </xsl:template>
    
    <xsl:function name="XJS:mark-baseline-occurrence">
      <xsl:param name="profile" as="document-node()"/>
      <xsl:param name="controlid" as="xs:string"/>
      <xsl:variable name="imports"
            select="$profile/profile/import[@href = 'NIST_SP-800-53_rev5_catalog.xml']"/>
        <xsl:choose>
            <xsl:when
                test="
                    some $import in ($imports)
                    satisfies XJS:imports-control($import,$controlid)"
                >x</xsl:when>
          <xsl:otherwise>&#xA0;</xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- @with-control logic goes here - -->
    <xsl:function name="XJS:imports-control" as="xs:boolean">
      <xsl:param name="import" as="element(import)"/>
      <xsl:param name="controlid" as="xs:string"/>
      <xsl:sequence
            select="
                (exists($import/include/all) or
                ($controlid = $import/include/call/@control-id)) and
                not($controlid = $import/exclude/call/@control-id)"
        />
    </xsl:function>

</xsl:stylesheet>
