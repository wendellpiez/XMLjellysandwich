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
    
    <xsl:key name="docbook-element-by-name" match="docbook:*" use="local-name()" xmlns:docbook="http://docbook.org/ns/docbook"/>
    
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
            <div class="graph">
            
            </div>
            <div>
                <details>
                    <summary>Element structure</summary>
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
                    <xsl:call-template name="element-histogram">
                        <xsl:with-param name="elements" select="//*"/>
                        <xsl:with-param name="label">
                            <span class="lbl">Elements</span>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:sequence>
            </table>
        </div>
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
            <div class="oll">{ name() }</div>
            <div class="olc">
              <xsl:apply-templates mode="outline"/>
            </div>
        </div>
    </xsl:template>

<xsl:template match="text()[matches(.,'^\s+$')]" mode="outline"/>

<xsl:template match="text()" mode="outline">
        <div class="olt" style="width: { normalize-space(.) ! string-length(.) }; flex-basis: { normalize-space(.) ! string-length(.) }">&#xA0;</div>
    </xsl:template>

    <xsl:template name="element-histogram" expand-text="true">
        <xsl:param name="elements" required="true"/>
        <xsl:param name="label">&#xA0;</xsl:param>
        <tr>
            <th>
                <xsl:sequence select="$label"/>
            </th>
            <td colspan="2">
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
                
            </td>
        </tr>
    </xsl:template>

    <xsl:function name="XJS:word-count" as="xs:integer">
        <xsl:param name="who" as="node()"/>
        <xsl:sequence select="string($who) => tokenize() => count()"/>
    </xsl:function>

</xsl:stylesheet>
