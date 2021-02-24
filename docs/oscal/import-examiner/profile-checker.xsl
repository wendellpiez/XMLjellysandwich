<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    xmlns:XJS="http://github.com/wendellpiez/XMLjellysandwich"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    extension-element-prefixes="ixsl"
    exclude-result-prefixes="#all"
    default-mode="examine"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0"
    >

    <xsl:output indent="yes"/>

    <xsl:param name="fileName" as="xs:string"/>
    
    <xsl:param name="baseline" as="xs:string">sp800-53rev5</xsl:param>
    
    <xsl:param name="import-index" select="0"/>
    
    <!-- declaring as document node so we have a context for traversal w/ document() -->
    <xsl:variable name="baseline-options">
        <option value="sp800-53rev5"                   file="../NIST_SP-800-53_rev5_catalog.xml"                                   >NIST SP 800-53, revision 5</option>
        <option value="sp800-53rev5_baseline-HIGH"     file="../NIST_SP-800-53_rev5_HIGH-baseline-resolved-profile_catalog.xml"    >NIST SP 800-53 HIGH baseline</option>
        <option value="sp800-53rev5_baseline-MODERATE" file="../NIST_SP-800-53_rev5_MODERATE-baseline-resolved-profile_catalog.xml">NIST SP 800-53 MODERATE baseline</option>
        <option value="sp800-53rev5_baseline-LOW"      file="../NIST_SP-800-53_rev5_LOW-baseline-resolved-profile_catalog.xml"     >NIST SP 800-53 LOW baseline</option>
    </xsl:variable>
    
    <xsl:variable name="rev5-catalog"     select="$baseline-options/*[@value='sp800-53rev5']/document(@file)"/>
    <xsl:variable name="baseline-catalog" select="$baseline-options/*[@value=$baseline]/document(@file)"/>
    
    <xsl:variable name="all-rev5-controls" select="$rev5-catalog//control"/>
    <xsl:variable name="baseline-controls" select="$baseline-catalog//control"/>
    
    <xsl:variable name="baseline-title" select="$baseline-catalog/*/metadata/title"/>
    
    <xsl:template name="examine-profile">
        <xsl:result-document href="#bxbody" method="ixsl:append-content">
            <details>
                <summary>XML source</summary>
                <pre id="profile-source">
                    <xsl:value-of select="serialize(/,$indented-serialization)"/>
                </pre>
            </details>
            <section class="examination">
                <xsl:apply-templates mode="examine"/>
            </section>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="refresh-baseline">
        <xsl:result-document href="#import{ $import-index }" method="ixsl:replace-content" expand-text="true">
            <xsl:variable name="profile-xml" select="id('profile-source',ixsl:page()) => parse-xml()"/>
            
            <xsl:apply-templates select="$profile-xml/*/import[ ($import-index + 1) ]" mode="refresh-import">
                <xsl:with-param tunnel="true" name="refreshing" select="true()"/>
            </xsl:apply-templates>
            <!--<h4>{ $baseline }</h4>
            <h3>{ $baseline-title }</h3>-->
                <!--<xsl:value-of select="serialize(/, $indented-serialization)"/>-->
            <!--</pre>-->
        </xsl:result-document>
    </xsl:template>
    <!-- ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### -->

    <xsl:mode name="examine" on-no-match="shallow-skip"/>
    
    
    <xsl:template priority="100" match="/*" mode="examine">
            <section class="notifications">
                <h2>Test results</h2>
                <section>
                    <h3>Profile structure (top level)</h3>
                    <div class="report">
                        <xsl:call-template name="tell">
                        <xsl:with-param name="when" select="empty(self::profile)"/>
                        <xsl:with-param name="title">Not an OSCAL profile</xsl:with-param>
                            <xsl:with-param name="msg" expand-text="true">Not an OSCAL profile, this document has element <code>{ name(.) }</code> in namespace <code>{ if (matches(namespace-uri(.),'\S')) then namespace-uri(.) else '[none]' }</code>.</xsl:with-param>
                        <xsl:with-param name="status">problematic</xsl:with-param>
                    </xsl:call-template>
                    <xsl:for-each select="self::profile">
                        <xsl:call-template name="profile-check"/>
                    </xsl:for-each>
                    </div>
                </section>
                <xsl:apply-templates select="self::profile/child::*" mode="examine"/>
            </section>
            
            <section class="map">
                <h2>Profile map</h2>
                <xsl:apply-templates select="." mode="map"/>
            </section>
    </xsl:template>
    
    <xsl:template name="profile-check">
        <xsl:call-template name="tell">
            <xsl:with-param name="when" select="empty(import)"/>
            <xsl:with-param name="title">Import count</xsl:with-param>
            <xsl:with-param name="msg">Profile has no imports ...</xsl:with-param>
            <!-- explicit oscal ns works around a SaxonJS bug? -->
            <xsl:with-param name="ifnot" expand-text="true">{ count(oscal:import)} { if
                (count(oscal:import) eq 1) then 'import' else 'imports'} found</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="tell">
            <xsl:with-param name="when" select="empty(merge)"/>
            <xsl:with-param name="title">No merge</xsl:with-param>
            <xsl:with-param name="msg">Profile has no <code class="drctv">merge</code> ...</xsl:with-param>
            <xsl:with-param name="status">remarkable</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template mode="examine" match="text()"/>
    
    <!--<xsl:template match="profile/import[empty(@href)]" mode="test">
    <tell>
        <title>No href</title>
        <message>Profile import has no href given</message>
        <ifnot>alternative message</ifnot>
    </tell>
    </xsl:template>-->
    
    <xsl:template match="import" mode="examine" expand-text="true">
        <xsl:variable name="pos0" select="count(preceding-sibling::import)"/>
        
        <section>
            <h3>Import <code>{ @href }</code></h3>
            <p class="control-widget">
                <xsl:text>Examined with reference to </xsl:text>
                <select onchange="refreshBaseline(this.value,{ ($pos0 ) })">
                    <xsl:for-each select="$baseline-options/*">
                        <xsl:copy>
                            <xsl:copy-of select="@* except @file, text()"/>
                        </xsl:copy>
                    </xsl:for-each>
                </select>
            </p>            
            <xsl:for-each select="key('linked-resource',@href)">
                <section class="map">
                    <xsl:apply-templates select="." mode="map"/>
                </section>
            </xsl:for-each>
               
            <div id="import{ $pos0 }">
              <xsl:apply-templates select="." mode="refresh-import"/>
            </div>
            
        </section>
    </xsl:template>
    
    
<!--    -->
    <xsl:template match="import" mode="refresh-import">
        <xsl:param name="refreshing" tunnel="true" select="false()"/>
        <div class="report">
            <xsl:call-template name="tell">
                <xsl:with-param name="when" select="empty(@href)"/>
                <xsl:with-param name="title">No href</xsl:with-param>
                <xsl:with-param name="msg">Profile import has no href given.</xsl:with-param>
            </xsl:call-template>
            <xsl:if test="not($refreshing)">
                <xsl:call-template name="tell">
                    <xsl:with-param name="when" select="not(XJS:rev5-import(.))"/>
                    <xsl:with-param name="title">Marked as SP 800-53?</xsl:with-param>
                    <xsl:with-param name="msg">Designated import source does not suggest SP 800-53.</xsl:with-param>
                    <xsl:with-param name="ifnot">Appears to call SP 800-53.</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <xsl:variable name="good-calls" select="include/call[@control-id = $all-rev5-controls/@id]"/>
            <xsl:call-template name="tell">
                <xsl:with-param name="when"
                    select="exists( $good-calls )"/>
                <xsl:with-param name="title">Viable as SP 800-53?</xsl:with-param>
                <xsl:with-param name="msg" expand-text="true">{ count($good-calls) } SP 800-53 control { if (count($good-calls) eq 1) then 'ID is' else 'IDs are'} called.</xsl:with-param>
                <xsl:with-param name="status">
                    <xsl:choose>
                        <xsl:when test="not(XJS:rev5-import(.)) or $refreshing">remarkable</xsl:when>
                        <xsl:otherwise>noteworthy</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tell">
                <xsl:with-param name="when"
                    select="exists(include/call) and empty( include/call[not(@control-id = $all-rev5-controls/@id)] )"/>
                <xsl:with-param name="title">Viable as SP 800-53?</xsl:with-param>
                <xsl:with-param name="msg"><em>All included controls</em> appear in SP 800-53, rev 5.</xsl:with-param>
                <xsl:with-param name="status">
                    <xsl:choose>
                        <xsl:when test="not(XJS:rev5-import(.)) or $refreshing">remarkable</xsl:when>
                        <xsl:otherwise>noteworthy</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tell">
                <xsl:with-param name="when" select="not($baseline='sp800-53rev5') and exists(include/call[ @control-id = $baseline-controls/@id ])"/>
                <xsl:with-param name="title">Viable selecting from this baseline?</xsl:with-param>
                <xsl:with-param name="msg" expand-text="true">One or more control IDs are called from <b>{ $baseline-title }</b>.</xsl:with-param>
                <xsl:with-param name="status">
                    <xsl:choose>
                        <xsl:when test="not(XJS:rev5-import(.)) or $refreshing">remarkable</xsl:when>
                        <xsl:otherwise>noteworthy</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tell">
                <xsl:with-param name="when" select="not($baseline='sp800-53rev5') and exists(include/call) and empty(include/call[ not(@control-id = $baseline-controls/@id) ])"/>
                <xsl:with-param name="title">Viable selecting from this baseline?</xsl:with-param>
                <xsl:with-param name="msg" expand-text="true"><em>All included controls</em> appear in <b>{ $baseline-title }</b>.</xsl:with-param>
                <xsl:with-param name="status">
                    <xsl:choose>
                        <xsl:when test="not(XJS:rev5-import(.)) or $refreshing">remarkable</xsl:when>
                        <xsl:otherwise>noteworthy</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="tell">
                <xsl:with-param name="when"
                    select="exists(oscal:include/oscal:all) and empty(oscal:exclude/*)"/>
                <xsl:with-param name="title">Including all, excluding none</xsl:with-param>
                <xsl:with-param name="msg" expand-text="true">With <code class="drctv">include/all</code> and
                    nothing excluded, { count($baseline-controls) } controls and enhancements will
                    appear.</xsl:with-param>
                <xsl:with-param name="status">noteworthy</xsl:with-param>
            </xsl:call-template>
        </div>
        <xsl:apply-templates mode="examine"/>
    </xsl:template>
    
    <xsl:template match="include" mode="examine">
        <xsl:where-populated>
        <div class="report">
            <xsl:sequence>
                <xsl:variable name="rev5-calls" select="child::call[@control-id = $baseline-controls/@id]"/>
                <xsl:call-template name="tell">
                    <xsl:with-param name="when" select="empty(child::all | $rev5-calls)"/>
                    <xsl:with-param name="title">No Rev 5 controls</xsl:with-param>
                    <xsl:with-param name="msg">Include directive shows no controls calling SP 800-53 Rev 5 (by control-id).</xsl:with-param>
                </xsl:call-template>
                <xsl:apply-templates mode="examine"/>
                <!--<xsl:on-empty>
                    <h4 class="title noteworthy"><code>include</code> check</h4>
                    <p class="msg noteworthy">
                        <xsl:text>Checks okay.</xsl:text>
                    <xsl:if test="empty(all)" expand-text="true">{ count( $rev5-calls ) } controls are called.</xsl:if></p>
                </xsl:on-empty>-->
            </xsl:sequence>
        </div>
        </xsl:where-populated>
            
    </xsl:template>
    
    <xsl:template match="exclude/call" mode="examine" expand-text="true">
        <xsl:variable name="me" select="."/>
        <xsl:call-template name="tell">
            <xsl:with-param name="when" select="empty(../include/all) or not(@control-id = ../include/call/@control-id)"/>
            <xsl:with-param name="title">Control excluded but not included</xsl:with-param>
            <xsl:with-param name="msg">Exclusion of control <code class="ctrl">{ @control-id }</code> is inoperative as it is not included.</xsl:with-param>
        </xsl:call-template>
        
        <xsl:next-match/>
    </xsl:template>
    
    <xsl:template match="call" mode="examine" expand-text="true">
        <xsl:param name="refreshing" tunnel="true" select="false()"/>
        <xsl:variable name="me" select="."/>
        <xsl:call-template name="tell">
            <xsl:with-param name="when" select="not(@control-id= $baseline-controls/@id)"/>
            <xsl:with-param name="title">Calling an unknown control</xsl:with-param>
            <xsl:with-param name="msg">Control <code class="ctrl">{ @control-id }</code> is not found in <b>{ $baseline-title }</b>.</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="tell">
            <xsl:with-param name="when" select="exists(preceding-sibling::call[@control-id=$me/@control-id])"/>
            <xsl:with-param name="title">Repeated calls on a control</xsl:with-param>
            <xsl:with-param name="msg">Control <code class="ctrl">{ @control-id }</code> is called more than once.</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="tell">
            <xsl:with-param name="when" select="$refreshing and (@control-id= $baseline-controls/@id)"/>
            <xsl:with-param name="title">Calling a recognized control</xsl:with-param>
            <xsl:with-param name="msg">Control <code class="ctrl">{ @control-id }</code> appears in <b>{ $baseline-title }</b>.</xsl:with-param>
            <xsl:with-param name="status">noteworthy</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
        
    <!--<xsl:template mode="examine" match="merge[empty(as-is|custom)]">
        <xsl:call-template name="spill-flat"/>
    </xsl:template>-->
    
    <xsl:template name="spill-flat">
        <!--<xsl:variable name="whole-profile" select="ancestor-or-self::profile[1]"/>
        <xsl:variable name="called-controls"
            select="$rev5-catalog//oscal:control[XJS:called-by-profile(., $whole-profile)]"/>
        <xsl:if test="exists($called-controls)">
            <details>
                <summary>Included controls</summary>
                <div class="control-list">
                    <xsl:apply-templates mode="list" select="$called-controls"/>
                </div>
            </details>
        </xsl:if>
        <xsl:if test="exists($rev5-catalog//control except $called-controls)">
            <details>
                <summary>Controls not included</summary>
                <div class="control-list">
                    <xsl:apply-templates mode="list"
                        select="$rev5-catalog//control except $called-controls"/>
                </div>
            </details>
        </xsl:if>-->
    </xsl:template>
    
    <!--<xsl:function name="XJS:called-by-profile">
        <xsl:param name="control" as="element(control)"/>
        <xsl:param name="profile" as="element(profile)"/>
        <xsl:sequence select="some $i in ($profile/import) satisfies XJS:imports-control($i,$control/@id)"/>        
    </xsl:function>-->
    
    
    <!-- ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### -->
    
    <xsl:template match="control" mode="list">
        <xsl:apply-templates mode="list" select="prop[@name='label']"/>
        <xsl:apply-templates mode="list" select="title"/>
    </xsl:template>
    
    <xsl:template match="title" mode="list">
        <span class="control-title { if (exists(parent::control/parent::control)) then 'enhancement' else 'control' }">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="prop" mode="list">
        <span class="{ @name } prop">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <!-- ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### -->
    
    <xsl:mode name="map" on-no-match="shallow-skip"/>
    
    <xsl:template match="metadata" mode="map"/>
    
    <xsl:template match="merge | modify" mode="map"/>
    
    <xsl:template match="back-matter" mode="map"/>
    
    <xsl:template match="resource/prop" mode="map"/>
    
    <xsl:template match="*" mode="map">
        <div class="element">
            <xsl:apply-templates select="." mode="tag"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="*" mode="tag" expand-text="true">
        <p class="tag" id="tag-{XJS:xid(.)}">{ name() }</p>
    </xsl:template>
    
    <xsl:template match="import" mode="tag" expand-text="true">
        <p class="tag" id="tag-{XJS:xid(.)}">
            <xsl:text>import</xsl:text>
            <span class="flag">
                <xsl:apply-templates select="." mode="get-href"/>
            </span>
        </p>
    </xsl:template>
    
    <!-- support link to resource here -->
    <xsl:template mode="get-href" match="import">
        <xsl:value-of select="@href"/>
    </xsl:template>
    
    <xsl:template match="call" mode="tag" expand-text="true">
        <p class="tag" id="tag-{XJS:xid(.)}">
            <xsl:text>call</xsl:text>
            <span class="flag">
                <xsl:value-of select="@control-id"/>
            </span>
        </p>
    </xsl:template>
    
    <xsl:template match="resource" mode="tag" expand-text="true">
        <p class="tag">resource <span class="flag">{ @uuid }</span></p>
    </xsl:template>
    
    <xsl:template match="rlink" mode="tag" expand-text="true">
        <p class="tag">rlink <span class="flag">{ @href }</span></p>
    </xsl:template>
    
    <xsl:template match="title" mode="tag" expand-text="true">
        <p class="tag">title <span class="flag"><xsl:apply-templates select="." mode="inline"/></span></p>
    </xsl:template>
    
    <xsl:template mode="ixsl:onmouseover" match="html:p[contains-token(@class,'path')]">
        <xsl:apply-templates select="key('tag-for-path',@id)" mode="on"/>
    </xsl:template>
    
    <xsl:template mode="ixsl:onmouseout"  match="html:p[contains-token(@class,'path')]">
        <xsl:apply-templates select="key('tag-for-path',@id)" mode="off"/>
    </xsl:template>
    
    <xsl:key name="tag-for-path" match="html:p" use="replace(@id,'^tag','path')"/>
    
    <xsl:template match="*" mode="off">
        <ixsl:set-attribute name="class"
            select="string-join( (tokenize(@class,'\s+')[not(. eq 'ON')]), ' ')"/>
    </xsl:template>
    
    <xsl:template match="*" mode="on">
        <ixsl:set-attribute name="class"
            select="string-join( (tokenize(@class,'\s+')[not(. eq 'ON')],'ON'), ' ')"/>
    </xsl:template>
    
    <!-- ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### -->
    
    
    <xsl:template name="tell">
        <xsl:param name="when" select="false()"/>
        <xsl:param name="msg">[none]</xsl:param>
        <xsl:param name="ifnot" select="()"/>
        <xsl:param name="status">problematic</xsl:param>
        <xsl:param name="title">Test</xsl:param>
        <xsl:if test="$when or exists($ifnot)">
        <h4 class="title { $status[$when] }">
            <xsl:sequence select="$title"/>
        </h4>
        <p class="msg { $status[$when] }">
            <xsl:sequence select="$msg[$when]"/>
            <xsl:sequence select="$ifnot[not($when)]"/>
        </p>
        <xsl:if test="$when">
            <p class="path" id="path-{XJS:xid(.)}">
                <xsl:apply-templates select="." mode="xpath"/>
            </p>
        </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template mode="xpath" match="*">
        <xsl:apply-templates select="parent::*" mode="xpath"/>
        <xsl:variable name="me" select="."/>
        <xsl:text expand-text="true">/{ name($me) }</xsl:text>
        <xsl:if test="exists(../* except .)" expand-text="true">[{ count(.|preceding-sibling::*[node-name() eq node-name($me)]) }]</xsl:if>
    </xsl:template>
    
    <xsl:template mode="xid" match="*">
        <xsl:apply-templates select="parent::*" mode="xid"/>
        <xsl:variable name="me" select="."/>
        <xsl:text expand-text="true">_{ name($me) }</xsl:text>
        <xsl:if test="exists(../* except .)" expand-text="true">-{ count(.|preceding-sibling::*[node-name() eq node-name($me)]) }</xsl:if>
    </xsl:template>
    
    <xsl:variable name="indented-serialization" as="element()">
        <output:serialization-parameters
            xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
            <output:indent value="true"/>
        </output:serialization-parameters>
    </xsl:variable>
        
    <xsl:key name="linked-resource" match="oscal:resource" use="'#' || @uuid"/>
    
    <xsl:function name="XJS:xid">
        <xsl:param name="who" as="element()"/>
        <xsl:apply-templates select="$who" mode="xid"/>
    </xsl:function>
    
    <xsl:function name="XJS:rev5-import">
        <xsl:param name="who" as="element(import)"/>
        <xsl:variable name="resource" select="key('linked-resource',$who/@href,root($who))"/>
        <xsl:sequence select="some $href in ($who/@href | $resource/rlink/@href) satisfies matches($href,'sp.800.53','i')"/>
    </xsl:function>
    
    <!--<xsl:function name="XJS:mark-baseline-occurrence">
      <xsl:param name="profile" as="document-node()"/>
      <xsl:param name="controlid" as="xs:string"/>
      <xsl:variable name="imports"
          select="$profile/profile/import[XJS:rev5-import(.)]"/>
        <xsl:choose>
            <xsl:when
                test="
                    some $import in ($imports)
                    satisfies XJS:imports-control($import,$controlid)"
                >x</xsl:when>
          <xsl:otherwise>&#xA0;</xsl:otherwise>
        </xsl:choose>
    </xsl:function>-->

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
