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

        <!-- pipeline is handled internally for now -->
        <xsl:variable name="element-tree">
            <xsl:apply-templates mode="build-tree"/>
        </xsl:variable>
        <xsl:variable name="measured-tree">
            <xsl:apply-templates select="$element-tree" mode="measure-tree"/>
        </xsl:variable>

        <div class="docscope">
            <h2><xsl:text expand-text="true">File: { $fileName }</xsl:text></h2>
            <xsl:call-template name="produce-summary"/>
            <div class="sketch">
                <xsl:apply-templates mode="draw" select="$measured-tree"/>
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
                        <th>
                            <span class="lbl">(Value of) First element named <q>title</q></span>
                        </th>
                        <td>
                            <span class="lit">{ /descendant::*:title[1] }</span>
                        </td>
                        <td class="n">[todo: XPath to this node]</td>
                    </tr>
                    <tr>
                        <th>
                            <span class="lbl">Testing key() function: how many docbook 'title' elements do we see?</span>
                        </th>
                        <td>
                            <span class="lit">{ count(key('docbook-element-by-name','title')) }</span>
                        </td>
                        <td class="n">docbook is construed to be anything bound to http://docbook.org/ns/docbook</td>
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
                            <td>({ count(current-group() ) })</td>
                            <td>{ ((count(current-group()) div $elemcount) => round(3) ) * 100 }%</td>
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

    <xsl:template match="*" mode="build-tree">
        <XJS:e name="{local-name()}">
            <xsl:for-each select="namespace-uri(.)[matches(., '\S')]">
                <xsl:attribute name="ns" select="."/>
            </xsl:for-each>
            <!--<xsl:copy-of select="@*"/>-->
            <xsl:apply-templates mode="#current"/>
        </XJS:e>
    </xsl:template>

    <xsl:template match="text()" mode="build-tree">
        <xsl:if test="matches(., '\S')">
            <XJS:txt wordcount="{ XJS:word-count(.) }" charcount="{ string-length(.) }"
                normalized-charcount="{ normalize-space(.) => string-length() }"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="measure-tree">
        <xsl:param name="starting" select="0"/>
        <xsl:variable name="extent" select="XJS:measure-children(.)"/>

        <xsl:copy>
            <xsl:copy-of select="@name"/>
            <xsl:attribute name="offset" select="$starting"/>
            <xsl:attribute name="extent" select="$extent"/>

            <xsl:apply-templates select="child::*[1]" mode="#current">
                <xsl:with-param name="starting" select="$starting + 1"/>
            </xsl:apply-templates>
        </xsl:copy>
        <xsl:apply-templates select="following-sibling::*[1]" mode="#current">
            <xsl:with-param name="starting" select="$starting + $extent + 1"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="XJS:txt" mode="measure-tree">
        <xsl:param name="starting" select="0"/>
        <xsl:variable name="extent">
            <xsl:apply-templates select="." mode="measure"/>
        </xsl:variable>
        <xsl:copy>
            <xsl:copy-of select="@name"/>
            <xsl:attribute name="offset" select="$starting"/>
            <xsl:attribute name="extent" select="$extent"/>
        </xsl:copy>
        <xsl:apply-templates select="following-sibling::*[1]" mode="#current">
            <xsl:with-param name="starting" select="$starting + $extent + 1"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="XJS:txt[not(@wordcount > 0)]" mode="measure-tree">
        <xsl:param name="starting" select="0"/>
        <xsl:apply-templates select="following-sibling::*[1]" mode="#current">
            <xsl:with-param name="starting" select="$starting"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:function name="XJS:measure-children" as="xs:integer">
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="child-extents" as="xs:integer*">
            <xsl:apply-templates select="$context/child::*" mode="measure"/>
        </xsl:variable>
        <xsl:variable name="my-extent" select="1 + sum($child-extents) + count($child-extents)"/>
        <!--<xsl:message expand-text="true">At { $context/(@name,local-name())[1]} I see { count($child-extents) } at { string-join($child-extents,' ') }: my extent is '{ $my-extent }' </xsl:message>-->
        <xsl:sequence select="$my-extent"/>
    </xsl:function>

    <xsl:template match="XJS:*" mode="measure" as="xs:integer">
        <xsl:sequence select="XJS:measure-children(.)"/>
    </xsl:template>

    <!-- text nodes get 1 per "word" plus 1 for spacing -->
    <xsl:template match="XJS:txt" mode="measure" as="xs:integer">
        <xsl:sequence select="xs:integer(@wordcount) + 1"/>
    </xsl:template>


    <!-- <xsl:template name="docstamp">
        <!-\- This time we have a document! -\->
        <xsl:result-document href="#dp_body" method="ixsl:replace-content">
            
        </xsl:result-document>
    </xsl:template>-->

    <xsl:template match="/" mode="draw" xmlns="http://www.w3.org/2000/svg">
        <xsl:variable name="last-of-all" select="/descendant::*[last()]"/>
        <xsl:variable name="max-dimension"
            select="$last-of-all/(@offset + @extent + count(ancestor-or-self::*))"/>
        <xsl:variable name="drawscale" select="( (math:sqrt($max-dimension) * 1000) => round() ) div 1000"/>
        <svg width="{$drawscale * 2}vh" height="{$drawscale}vh"
            viewBox="0 0 { $max-dimension * 2 } { $max-dimension }">
            <desc>SVG gram</desc>
            <xsl:apply-templates mode="draw"/>
        </svg>
    </xsl:template>

    <xsl:template match="*" mode="draw" xmlns="http://www.w3.org/2000/svg" expand-text="true">
        <path d="M 0 {@offset} C {@extent} {@offset} {@extent} {@offset + @extent} 0 {@offset + @extent}"
            fill="darkgreen" fill-opacity="0.1" stroke="darkgreen" stroke-width="1"/>
        <text fill="black" fill-opacity="0.1" stroke="black" stroke-width="0.1" y="{@offset + (@extent div 2)}" x="{@extent}" font-size="{@extent div 2}">{@name}</text>
        <xsl:apply-templates mode="draw"/>
    </xsl:template>

    <xsl:template match="XJS:txt" mode="draw" xmlns="http://www.w3.org/2000/svg" expand-text="true">
        <path d="M 0 {@offset} C {@extent} {@offset} {@extent} {@offset + @extent} 0 {@offset + @extent}"
            fill="lavender" stroke="midnightblue" stroke-width="1"/>
        <text fill="black" fill-opacity="0.1" stroke="black" stroke-width="0.1" y="{@offset + (@extent div 2)}" x="{@extent}" font-size="{@extent div 2}">{@wordcount} words</text>
        <xsl:apply-templates mode="draw"/>
    </xsl:template>

    <!--<xsl:template match="id('stampfile')" mode="ixsl:onchange">
        <!-\- pre loading -\->
        <xsl:variable name="fileobj" select="map:get( ixsl:get(id('stampfile'),'files'),'0')"/>
        
        <!-\-<xsl:variable name="fileobj" select="ixsl:get(id('stamp_file'),'files')('0')"/>-\->
        
        <xsl:result-document href="#dpheader" method="ixsl:append-content">
            <h4>
                <xsl:text>... reading file </xsl:text>
                <!-\-<xsl:sequence select="ixsl:call($fileobj,'item',[])"/>-\->
                <xsl:value-of select="$fileobj('name')"/>
            </h4>
        </xsl:result-document>
        
        <!-\- Call to $content will inject transformation results -\->
        <!-\- Call to $content will inject transformation results
              into #XTractor -\->
        <!-\-<xsl:variable name="content" select="ixsl:call(ixsl:window(),'docstamp',[ $fileobj ])"/>
        <xsl:copy-of select="$content"/>-\->
        <!-\-<xsl:variable name="fileobj" select="ixsl:get(.,'files')"/>-\->
        
        <xsl:result-document href="#dpbody" method="ixsl:append-content">
            <div>
                <p>Whoa baby!</p>
<!-\-                    <xsl:for-each select="map:keys($fileobj)">
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                <xsl:text>???</xsl:text>
                <!- -<xsl:value-of select="map:find(ixsl:get(.,'files'),'name')"/>-\->
                <!-\-<xsl:value-of select="$fileobj"/>-\->
            </div>
        </xsl:result-document>
        
    </xsl:template>-->


</xsl:stylesheet>
