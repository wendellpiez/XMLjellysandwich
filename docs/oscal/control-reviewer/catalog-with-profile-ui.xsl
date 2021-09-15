<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    extension-element-prefixes="ixsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0"
    >

    <xsl:output indent="yes"/>

<!-- next up
        
    dynamic profiles
      view switcher
    count controls in summaries
    expand full view showing parameters and patches -->
    
    <xsl:param as="xs:string" name="profileXML" select="''"/>
    
    <xsl:variable name="sp800-53-catalog" select="/"/>
    
    <xsl:param name="fileName" as="xs:string"/>
    
    <!-- declaring as document node so we have a context for traversal w/ document() -->
    <xsl:variable name="baseline-options">
        <option value="sp800-53rev5" selected="selected"                                                          >SHOW ALL SP 800-53 CONTROLS</option>
        <option value="sp800-53rev5_baseline-HIGH"     file="../NIST_SP-800-53_rev5_HIGH-baseline_profile.xml"    >NIST SP 800-53 HIGH IMPACT baseline</option>
        <option value="sp800-53rev5_baseline-MODERATE" file="../NIST_SP-800-53_rev5_MODERATE-baseline_profile.xml">NIST SP 800-53 MODERATE IMPACT baseline</option>
        <option value="sp800-53rev5_baseline-LOW"      file="../NIST_SP-800-53_rev5_LOW-baseline_profile.xml"     >NIST SP 800-53 LOW IMPACT baseline</option>
        <option value="sp800-53rev5_baseline-HIGH_PRIVACY"     file="../NIST_SP-800-53_rev5_PRIVACY-baseline_profile.xml ../NIST_SP-800-53_rev5_HIGH-baseline_profile.xml"    >NIST SP 800-53 HIGH IMPACT + PRIVACY baseline</option>
        <option value="sp800-53rev5_baseline-MODERATE_PRIVACY" file="../NIST_SP-800-53_rev5_PRIVACY-baseline_profile.xml ../NIST_SP-800-53_rev5_MODERATE-baseline_profile.xml">NIST SP 800-53 MODERATE IMPACT + PRIVACY baseline</option>
        <option value="sp800-53rev5_baseline-LOW_PRIVACY"      file="../NIST_SP-800-53_rev5_PRIVACY-baseline_profile.xml ../NIST_SP-800-53_rev5_LOW-baseline_profile.xml"     >NIST SP 800-53 LOW IMPACT + PRIVACY baseline</option>
    </xsl:variable>
    
    <xsl:template name="display-catalog">
        <xsl:call-template name="page-controls"/>
        <xsl:result-document href="#bxbody" method="ixsl:replace-content">
            <div class="profile-description">
                <p>Showing all controls...</p>
            </div>
            <div>
              <xsl:apply-templates select="$sp800-53-catalog/catalog">
                  <xsl:with-param name="profile" tunnel="true" select="()"/>
              </xsl:apply-templates>
            </div>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="refresh-catalog">
        <xsl:param name="profile" as="element()*" select="($profileXML[matches(.,'\S')] => parse-xml() )/child::profile"/>
        <xsl:result-document href="#bxbody" method="ixsl:replace-content">
            <form id="display-setting">
                <div>
                    <span> Show </span><label for="show-all">all controls </label>
                    <input type="radio" id="show-all" name="showing" value="showing-all"/>
                    <span> or </span>
                    <input type="radio" id="show-selected" name="showing" value="showing-selected"/>
                    <label for="show-selected"> only selected controls</label>
                </div>
            </form>
            <xsl:apply-templates mode="profile-description" select="$profile"/>
            <div id="controls-listing" class="showing-all">
                <xsl:apply-templates select="$sp800-53-catalog/catalog">
                    <xsl:with-param name="profile" tunnel="true" select="$profile"/>
                </xsl:apply-templates>
            </div>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="profile" mode="profile-description" expand-text="true">
        <div class="profile-description">
            
            <xsl:apply-templates select="metadata" mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="id('display-setting')" mode="ixsl:onchange">
        <xsl:variable name="selected-value" select="ixsl:get(., 'showing.value')"/>
        <xsl:for-each select="id('controls-listing')">
                <ixsl:set-attribute name="class" select="$selected-value"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="metadata" mode="profile-description" expand-text="true">
        <h4 class="profile-header">
            <xsl:apply-templates mode="#current" select="title, last-modified"/>
        </h4>
    </xsl:template>
    
    <xsl:template match="metadata/title" mode="profile-description" expand-text="true">
        <span class="profile-title">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="metadata/last-modified" mode="profile-description" expand-text="true">
        <xsl:text> (</xsl:text>
        <span class="timestamp">{ format-dateTime(.,'[D] [MN,3-3] [Y]') }</span>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    
    <!-- We could include these as literals except some parts are dynamic/configurable -->
    <xsl:template name="page-controls">
        <xsl:result-document href="#button-block" method="ixsl:replace-content">
            <p class="control-widget">
                <xsl:text>Load with profile </xsl:text>
                <select id="profile-selector">
                    <xsl:for-each select="$baseline-options/*">
                        <xsl:copy>
                            <xsl:copy-of select="@* except @file, text()"/>
                        </xsl:copy>
                    </xsl:for-each>
                </select>
            </p>
            <p class="control-widget">Or load your own: <input type="file" accept=".xml,text/xml"
                    id="loadfileInput" name="loadfileInput" title="Drop XML"
                    onchange="viewWithProfile(this.files)"/>
            </p>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="id('profile-selector')" mode="ixsl:onchange">
        <xsl:variable name="selected-value" select="ixsl:get(., 'value')"/>
        
        <xsl:variable name="profile-if-any" select="$baseline-options/*[@value=$selected-value]/@file"/>
        
        <xsl:choose>
            <xsl:when test="exists($profile-if-any)">
                <ixsl:schedule-action document="{$profile-if-any }">
                    <xsl:call-template name="refresh-catalog">
                        <xsl:with-param name="profile" select="tokenize($profile-if-any,'\s+') ! document(.)/profile"/>
                    </xsl:call-template>
                </ixsl:schedule-action>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="display-catalog"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--
        Next up:
          Copy profile sources into repository
          wire this up (see poem teller for asynchronous document load)
       
        <xsl:template match="id('profile-selector')" mode="ixsl:onchange">
       look up document in baseline-options
       when available, call refresh-catalog with the loaded profile as $profile
       otherwise call display-catalog (?)
    
    </xsl:template>-->
    
    <xsl:template match="metadata | back-matter"/>
    
    <xsl:template match="group">
        <details id="{@id}" class="group deck" open="open">
            <summary>
              <xsl:apply-templates select="title | prop"/>
              <xsl:text> </xsl:text>
              <button class="stackability" id="{@id}-stacking" >show list</button>
                <xsl:apply-templates select="* except (title | prop | control)"/>
                
            </summary>
            <div class="control-group">
              <xsl:apply-templates select="control"/>
            </div>
        </details>
    </xsl:template>
    
    <xsl:template match="html:button[pb:classes(.)='stackability']" mode="ixsl:onclick">
        <xsl:apply-templates select="../parent::html:details" mode="restack">
            <xsl:with-param name="button-id" select="@id"/>
        </xsl:apply-templates>
    </xsl:template>
    
    
    <!--<xsl:template mode="restack2" match="html:details[pb:classes(.)='deck']" priority="5">
        <ixsl:set-attribute name="open" select="'open'"/>
        <ixsl:set-attribute name="class" select="pb:classes(.)[not(.='deck')] => string-join(' ')"/>
    </xsl:template>
    
    <xsl:template mode="restack2" match="html:details">
        <ixsl:set-attribute name="open" select="'open'"/>
        <ixsl:set-attribute name="class" select="(pb:classes(.),'deck') => string-join(' ')"/>
    </xsl:template>-->
    
    <!-- Interactivity templates produce side effects writing back into the page to tweak display -->
    <!-- Two templates for this makes more lines of code but neater execution -->
    <!-- removing .deck -->
    <xsl:template mode="restack" match="html:details[pb:classes(.)='deck']" priority="5">
        <xsl:param name="button-id" as="attribute(id)" required="true"/>
        <ixsl:set-attribute name="open" select="'open'"/><!-- clicking the button always opens the details -->
        <ixsl:set-attribute name="class" select="pb:classes(.)[not(.='deck')] => string-join(' ')"/>
        <xsl:result-document href="#{ $button-id }" method="ixsl:replace-content" expand-text="true"> show deck </xsl:result-document>
    </xsl:template>
    
    <!-- adding .deck back -->
    <xsl:template mode="restack" match="html:details">
        <xsl:param name="button-id" as="attribute(id)" required="true"/>
        <ixsl:set-attribute name="open" select="'open'"/><!-- clicking the button always opens the details -->
        <ixsl:set-attribute name="class" select="(pb:classes(.),'deck') => string-join(' ')"/>
        <xsl:result-document href="#{ $button-id }" method="ixsl:replace-content" expand-text="true"> show list </xsl:result-document>
    </xsl:template>
    
    <!--<xsl:template match="control">
        <div id="{@id}" class="control">
            <xsl:apply-templates select="* except control"/>
            <xsl:where-populated>
                <div class="control-group">
                    <xsl:apply-templates select="control"/>
                </div>
            </xsl:where-populated>
        </div>
    </xsl:template>-->
    
    
    <xsl:template match="title" mode="expanded-title">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="control/control/title" mode="expanded-title">
        <xsl:apply-templates mode="#current" select="../parent::control/title"/>
        <xsl:text> | </xsl:text>
        <span class="enhancement-title">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
    <xsl:template match="control">
        <div id="{@id}" class="control">
            <xsl:apply-templates select="." mode="assign-class"/>
            <div class="controlbx">
                <xsl:apply-templates select="prop[@name='label'][1]"/>
                <details class="statement">
                    <summary>
                       <span class="control-listing">
                          <xsl:apply-templates select="title" mode="expanded-title"/>
                       </span>
                    </summary>
                    <xsl:apply-templates select="prop[@name='status'][@value='withdrawn']"/>
                    <!-- statements except in withdrawn controls where they are folded in already -->
                    <xsl:apply-templates select="part[@name='statement'][not(../prop[@name='status']/lower-case(@value)='withdrawn')]"/>
                </details>
                <xsl:where-populated>
                    <div class="control-enhancements">
                        <xsl:apply-templates select="control"/>        
                    </div>
                </xsl:where-populated>
                
            </div>
        </div>
    </xsl:template>
    
    <!-- template borrowed and modified from oscal-tools/xslt/publish/nist-emulation/sp800-53A-catalog_html.xsl-->
    <xsl:template match="prop[@name='status'][matches(@value,'Withdrawn','i')]">
        <p class="withdrawn-status">
            <xsl:text>[Withdrawn</xsl:text>
            <xsl:variable name="withdrawn-to" select="../link[@rel = ('moved-to', 'incorporated-into')]"/>
            <xsl:variable name="link-label">
                <xsl:choose>
                    <xsl:when test="empty($withdrawn-to)">. </xsl:when>
                    <xsl:when test="$withdrawn-to/@rel = 'incorporated-into'">: Incorporated into </xsl:when>
                    <xsl:otherwise>: Moved to </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="withdrawn-statement">
                <xsl:sequence select="$link-label"/>
                <xsl:for-each-group select="$withdrawn-to" group-by="true()">
                    <xsl:for-each select="current-group()">
                        <xsl:if test="position() gt 1">, </xsl:if>
                        <xsl:apply-templates select="." mode="link-as-link"/>
                    </xsl:for-each>
                </xsl:for-each-group>
                <xsl:for-each select="../part[@name = 'statement']/*">
                    <xsl:apply-templates/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="$withdrawn-statement"/>
            <xsl:if test="not(matches(string($withdrawn-statement), '\.\s*$'))">.</xsl:if>
            <xsl:text>]</xsl:text>
        </p>
    </xsl:template>
    
    <xsl:key name="cross-reference-targets" match="*[exists(@id|@uuid)]" use="(@uuid | @id) ! ('#' || .)"/>
    
    <xsl:template match="link" mode="link-as-link">
        <a href="{@href}">
            <xsl:apply-templates select="text"/>
            <xsl:if test="not(matches(text,'\S'))" expand-text="true">
                <xsl:value-of select="@href"/> 
            </xsl:if>
        </a>
    </xsl:template>
    
    <xsl:template match="link[starts-with(@href,'#')]" mode="link-as-link">
        <xsl:variable name="target" select="key('cross-reference-targets',@href)"/>
        <xsl:choose>
            <xsl:when test="exists($target)">
                <xsl:apply-templates select="$target" mode="link-as-link">
                    <xsl:with-param name="link" select="."/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*" mode="link-as-link">
        <a href="#{ (@uuid, @id)[1] }">
            <xsl:apply-templates select="." mode="link-text"/>
        </a>
    </xsl:template>
    
    <xsl:template match="control" mode="link-as-link" expand-text="true">
        <a href="#{ @id }">{ prop[@name='label']/@value }</a>
    </xsl:template>
    
    <xsl:template match="part" mode="link-as-link" expand-text="true">
        <a href="#{ ancestor::control[1]/@id }">
            <xsl:value-of select="ancestor-or-self::*/prop[@name='label']/@value"/>
        </a>
    </xsl:template>
    
    
    
    
    <xsl:template match="group/title">
        <span class="h3 label">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="prop[@name='label']">
        <h4>
            <span class="label">
                <xsl:value-of select="@value"/>
            </span>
            <xsl:for-each select="../title">
                <xsl:text> </xsl:text>
                <span class="control-title">
                    <xsl:apply-templates select="." mode="expanded-title"/>
                </span>
            </xsl:for-each>
        </h4>
    </xsl:template>
    
    <xsl:template match="part/title">
        <h5 class="h5 label">
            <xsl:apply-templates/>
        </h5>
    </xsl:template>
    
    
    <xsl:template match="part">
        <div class="part {@name}">
            <xsl:copy-of select="@id"/>
            <!--<xsl:apply-templates select="." mode="title"/>-->
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="part[@name='item'] | part[@name='objective']">
        <div class="part">
            <xsl:copy-of select="@id"/>
            <!--<xsl:apply-templates select="." mode="title"/>-->
            <table class="objective-part">
                <tbody>
                    <tr>
                        <td>
                            <xsl:apply-templates select="." mode="part-number"/>
                        </td>
                        <td>
                            <xsl:apply-templates/>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>
    
    <xsl:template priority="3" match="part[@name='item']/prop[@name='label'] | part[@name='objective']/prop[@name='label']"/>
        
    <xsl:template match="part[prop/@name='label']" mode="part-number">
        <xsl:apply-templates mode="#current" select="prop[@name='label']"/>
    </xsl:template>
    
    <xsl:template match="prop" mode="part-number">
        <xsl:value-of select="@value"/>
    </xsl:template>
    
    <!--<xsl:template match="part//* | title//*">
        <xsl:element namespace="http://www.w3.org/1999/xhtml" name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>-->
    
    <xsl:key name="param-for-id" match="param" use="@id"/>
    
    <xsl:key name="by-id" match="*" use="@id"/>
    
    <xsl:template match="insert">
        <xsl:variable name="target" select="key('by-id',@id-ref)[last()]"/>
        <span class="insert">
            <xsl:apply-templates select="$target" mode="inline-ref"/>
        </span>
    </xsl:template>
    
    <xsl:template match="*" mode="inline-ref">
        <xsl:message expand-text="true">cross-reference fallback on { name() }</xsl:message>
        <xsl:value-of select="(child::title,@id,name()) => head()"/>
    </xsl:template>
    
    <xsl:template match="insert[@type='param']">
        <xsl:variable name="param"
            select="key('param-for-id',@id-ref)[last()]"/>
        <!-- Providing substitution via declaration not yet supported -->
        <span class="insert">
            <xsl:apply-templates select="$param/(value, select , label)[1]"/>
        </span>
    </xsl:template>
    
    <xsl:template match="param/value">
        <span class="value">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="param/label">
        <span class="unassigned">
            <xsl:text>[Assignment: </xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="param/select">
        <span class="selection">
            <xsl:text>[Selection: </xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="param/select/choice">
        <span class="value">
            <xsl:if test="exists(preceding-sibling::choice)">; </xsl:if>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="p | table | pre | ul | ol | li | h1 | h2 | h3 | h4 | h5 | h6 | code |      
        a | img | strong | em | b | i | sup | sub | q">
        <xsl:apply-templates select="." mode="html-ns"/>
    </xsl:template>
    
    <xsl:template match="insert" mode="html-ns">
        <xsl:apply-templates select="." mode="#default"/>
    </xsl:template>
    
    <xsl:template match="*" mode="html-ns">
        <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template priority="101" match="control" mode="assign-class">
        <xsl:param tunnel="true" name="profile" as="element(profile)*"/>
        <xsl:variable name="me" select="."/>
        <xsl:variable name="effective-classes" as="xs:string*">
            <xsl:if test="prop[@name='status']/lower-case(@value) = 'withdrawn'">withdrawn</xsl:if>
            <xsl:if test="empty($profile)">selected</xsl:if>
            <xsl:if test="some $i in ($profile) satisfies pb:included-by-profile($me, $i)">selected</xsl:if>
            <xsl:text>control</xsl:text>
        </xsl:variable>
        <xsl:attribute name="class" select="string-join($effective-classes,' ')"/>
    </xsl:template>
    
    <xsl:template match="*" mode="assign-class">
        <xsl:attribute name="class" expand-text="true">{ local-name() }</xsl:attribute>
    </xsl:template>
    
    <xsl:template match="control/* | group/*" priority="-0.1"/>
    
    <xsl:function name="pb:classes">
        <xsl:param name="who" as="element()"/>
        <xsl:sequence select="tokenize($who/@class, '\s+') ! lower-case(.)"/>
    </xsl:function>
    
    <xsl:function name="pb:included-by-profile" as="xs:boolean">
        <xsl:param name="who" as="element(control)"/>
        <xsl:param name="profile" as="element(profile)?"/>
        <!-- True if any import has either an inclusion by ID, or an include all without an exclusion -->
        <xsl:sequence select="$who/@id = $profile/import/include-controls/with-id
            or $profile/import/include-all/empty(../exclude-controls/with-id = $who/id)"/>
<!--       /profile/import[1]/include-controls[1]/with-id[4]  -->
    </xsl:function>
</xsl:stylesheet>
