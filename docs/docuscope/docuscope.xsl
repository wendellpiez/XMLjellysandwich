<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    xmlns:XJS="http://github.com/wendellpiez/XMLjellysandwich"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map" extension-element-prefixes="ixsl"
    exclude-result-prefixes="#all" xmlns:svg="http://www.w3.org/2000/svg"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:oxy="http://www.oxygenxml.com/oxy">

    <xsl:output indent="yes"/>

    <xsl:param name="fileName" as="xs:string"/>

    <xsl:variable name="indented-serialization" as="element()">
        <output:serialization-parameters
            xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
            <output:indent value="true"/>
        </output:serialization-parameters>
    </xsl:variable>

    <!--entry points: template 'incipit' is a no-op; it loads the XSLT to permit bindings for UI -->

    <xsl:template name="append-to-body">
        <xsl:result-document href="#dpbody" method="ixsl:append-content">
            <xsl:apply-templates select="/"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:key name="element-by-name" match="*" use="local-name()"/>
    
    <xsl:template match="/">

        <!-- pipeline is handled internally for now
        <xsl:variable name="element-tree">
            <xsl:apply-templates mode="build-tree"/>
        </xsl:variable>
        <xsl:variable name="measured-tree">
            <xsl:apply-templates select="$element-tree" mode="measure-tree"/>
        </xsl:variable> -->

        <div class="docscope">
            <h2><xsl:text expand-text="true">File: { $fileName }</xsl:text></h2>
            <xsl:call-template name="produce-summary"/>
            <!-- <div class="sketch">
                <xsl:apply-templates mode="draw" select="$measured-tree"/>
            </div> -->
            <div>
                <details>
                    <summary>Element type frequency (histogram)</summary>
                    <xsl:call-template name="element-histogram">
                        <xsl:with-param name="elements" select="//*"/>
                    </xsl:call-template>
                </details>
            </div>
            <div>
                <details>
                    <summary>Element structure - abstract</summary>
                    <xsl:variable name="abstract-structure">
                        <xsl:apply-templates select="/*" mode="abstract"/>
                    </xsl:variable>
                    <xsl:apply-templates select="$abstract-structure" mode="outline"/>
                </details>
            </div>
            <div>
                <details>
                    <summary>Element structure - actual</summary>
                    <xsl:apply-templates select="*" mode="outline"/>
                </details>
            </div>
            <div>
                <details>
                    <summary>XML source</summary>
                    <pre>
                <xsl:value-of select="serialize(/)"/>
            </pre>
                </details>
            </div>

            <!--<div>
            <details>
                <summary>Element tree (source)</summary>
                <pre>
                <xsl:value-of select="serialize($measured-tree,$indented-serialization)"/>
            </pre>
                
            </details>
        </div>-->

            <div>
                <h3>More ideas</h3>
                <ul>
                    <li>Attribute usage survey</li>
                    <li>Element 'promiscuity' (ratio of parent/child pairs to element types) in the instance (not the same as the schema)</li>
                </ul>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="produce-summary">
        <div>
            <table class="smmry">
                <xsl:sequence expand-text="true">
                    <tr>
                        <th>
                            <span class="lbl">Root element namespace</span>
                        </th>
                        <td>
                            <span class="lit">{ (namespace-uri(/*)[matches(.,'\S')],'[none]')[1]
                                }</span>
                        </td>
                        <td class="n"><q>[none]</q> means the root element is not assigned a namespace</td>
                    </tr>
                    <tr>
                      <xsl:variable name="title1" select="/descendant::*:title[1]"/>
                        <th>
                            <span class="lbl">(Value of) First element named <q>title</q></span>
                        </th>
                        <td>
                            <span class="lit">{ $title1 }</span>
                        </td>
                        <td class="n">
                        <xsl:for-each select="$title1">
                            <span class="xpath">
                                <xsl:apply-templates select="$title1" mode="xpath"/>
                            </span>
                        </xsl:for-each>                          
                            
                            <xsl:if test="empty($title1)">(none found)</xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span class="lbl">Root element name as given</span>
                        </th>
                        <td>
                            <span class="lit">{ name(/*) }</span>
                        </td>
                        <td class="n"> </td>
                    </tr>
                    <tr>
                        <th>
                            <span class="lbl">Element count</span>
                        </th>
                        <td>
                            <span class="ct">{ count( //* ) }</span>
                        </td>
                        <td class="n"> </td>
                    </tr>
                    <tr>
                        <th>
                            <span class="lbl">Word count*</span>
                        </th>
                        <td>
                            <span class="ct">{ XJS:word-count( /* ) }</span>
                        </td>
                        <td class="n">* <q>word</q> as sequence of non-whitespace characters</td>
                    </tr>
                </xsl:sequence>
            </table>
        </div>
    </xsl:template>
    
    <xsl:template match="/*" mode="abstract">
        <xsl:copy>
            <xsl:call-template name="group">
                <xsl:with-param name="next" select="*"/>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="group">
        <xsl:param name="next"/>
        <xsl:for-each-group select="$next" group-by="node-name()">
          <xsl:copy>
              <xsl:attribute name="count" select="count(current-group())"/>
              <xsl:call-template name="group">
                  <xsl:with-param name="next" select="current-group()/*"/>
              </xsl:call-template>
          </xsl:copy>    
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template mode="xpath" match="*">
      <xsl:apply-templates select="parent::*" mode="#current"/>
      <xsl:text expand-text="true">/{ name() }</xsl:text>
    </xsl:template>

    <xsl:template mode="xpath" match="*[node-name=(../* except current() )/node-name()]">
      <xsl:apply-templates select="parent::*" mode="#current"/>
      <xsl:variable name="predecessors" select="preceding-sibling::*[node-name()=current()/node-name()]"/>
      <xsl:text expand-text="true">/{ name() }[{ count(. | $predecessors) }]</xsl:text>
    </xsl:template>

    <xsl:template match="*" mode="outline" expand-text="true">
        <div class="outline">
            <div class="oll"><span>{ name() }</span>
                <xsl:for-each select="@count">
                    <span class="lit"> ({ . })</span>
                </xsl:for-each>
            </div>
            <div class="olc">
              <xsl:apply-templates mode="outline"/>
            </div>
        </div>
    </xsl:template>

    <!-- <xsl:template match="*[exists(child::text()[matches(.,'\S')])]" mode="outline" expand-text="true">
        <div class="oll">{ name() }</div>
        <xsl:apply-templates mode="outline"/>
    </xsl:template> -->

<xsl:template match="text()[matches(.,'^\s+$')]" mode="outline"/>

<xsl:template match="text()" mode="outline" expand-text="true">
        <!-- <div class="olt" style="width: { normalize-space(.) ! string-length(.) }; flex-basis: { normalize-space(.) ! string-length(.) }">&#xA0;</div> -->
        <div class="olt">{ normalize-space(.) }</div>
    </xsl:template>

    <xsl:template name="element-histogram" expand-text="true">
        <xsl:param name="elements" required="true"/>
            <table class="histogram">
            <xsl:variable name="elemcount" select="count(//*)"/>
            <xsl:for-each-group select="$elements" group-by="name()">
                <xsl:sort select="count(current-group())" order="descending"/>
                    <tr>
                        <th><span class="lit">{ current-grouping-key() }</span></th>
                        <td class="rightalign">({ count(current-group() ) })</td>
                        <td class="rightalign">{ ((count(current-group()) div $elemcount) => round(3) ) * 100 }%</td>
                        <td class="bar">
                            <xsl:for-each select="current-group()">
                                <!-- &#8226; is a bullet  &#9646; a vertical rectangle -->
                                <xsl:variable name="class">
                                    <xsl:choose>
                                        <xsl:when test="empty(child::*|child::text()[matches(.,'\S')] )">e</xsl:when>
                                        <xsl:when test="empty(child::text()[matches(.,'\S')] )">s</xsl:when>
                                        <xsl:otherwise>t</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <b class="{ $class }">&#9646;</b>
                            </xsl:for-each>
                        </td>
                    </tr>
            </xsl:for-each-group>
            </table>
    </xsl:template>

    <xsl:function name="XJS:word-count" as="xs:integer">
        <xsl:param name="who" as="node()"/>
        <xsl:sequence select="string($who) => tokenize() => count()"/>
    </xsl:function>

</xsl:stylesheet>
