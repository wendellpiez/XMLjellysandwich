<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    exclude-result-prefixes="xs math"
    extension-element-prefixes="ixsl"
    version="3.0">
    
    <xsl:variable name="dim" as="xs:integer">24</xsl:variable>
    
    <xsl:template name="incipit">
        <!-- Begin by populating the page with the grid of cells. -->
        <xsl:result-document href="#page_body" method="ixsl:replace-content">
            <xsl:call-template name="grid"/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="grid">
        <table id="world">
            <tbody>
                <xsl:for-each select="1 to $dim"><!-- as many rows as stipulated -->
                <xsl:variable name="gens" select="."/>
                <tr id="gens{.}">
                    <xsl:for-each select="1 to $dim"><!-- and as many columns -->
                        <xsl:variable name="clan" select="."/>
                        <!-- 1A for cell in col 1 row 1 -->
                        <xsl:variable name="label" select="$gens || format-integer($clan, 'A')"/>
                        <!-- nb $neighborhood includes the cell itself -->
                        <xsl:variable name="neighborhood" as="xs:string*"
                            select="
                                for $y in (($gens - 1) to ($gens + 1)),
                                    $x in (($clan - 1) to ($clan + 1))
                                return
                                    (string($y) || format-integer($x, 'A'))"/> 
                        <td id="{$label}" data-neighborhood="{$neighborhood}" onclick="void(0)">&#x200b;</td>
                        <!-- zero-width space-->
                    </xsl:for-each>
                </tr>
            </xsl:for-each>
            </tbody>
        </table>

        <!-- One might prefer SVG to HTML but the id() function isn't binding to it, HTML DOM how sad ...
        <svg:svg  xmlns:svg="http://www.w3.org/2000/svg"
            id="world" version="1.1" width="100%" viewBox="0.5 0.5 {$dim} {$dim}">
            <svg:circle id="{{$label}}" data-neighborhood="{{$neighborhood}}" onclick="void(0)"
                cx="{{$family}}" cy="{{$tribe}}" r="0.4" fill="green"/>
        </svg:svg> -->
    </xsl:template>
    
    <!-- Interactivity: toggle cells alive and dead. -->
    <xsl:template mode="ixsl:click" match="td[@class='alive']">
        <xsl:call-template name="kill"/>
    </xsl:template>
    
    <!-- Implicit @priority="0" loses to priority 0.5 template above. -->
    <!-- Also svg:circle (some day) -->
    <xsl:template mode="ixsl:click" match="td">
        <xsl:call-template name="grow"/>
    </xsl:template>
    
    <!-- "Do it" does a single generation (if it's included)   -->
    <xsl:template mode="ixsl:click" match="id('do_it_button')">
        <xsl:apply-templates select="id('world',ixsl:page())" mode="regenerate"/>
    </xsl:template>
    
    <!-- Clicking the Stop button replaces it with the Go button (only) -->
    <xsl:template name="stop" mode="ixsl:click" match="id('stop_button')">
        <xsl:result-document href="#dashboard" method="ixsl:replace-content">
            <button id="go_button">Go</button>
            <xsl:text>&#xA0;</xsl:text>
            <button id="clear_button">Clear</button>
        </xsl:result-document>
    </xsl:template>

    <!-- Clicking the go button replaces it with the Stop button, and also ... goes  ... -->
    <xsl:template mode="ixsl:click" match="id('go_button')">
        <xsl:result-document href="#dashboard" method="ixsl:replace-content">
            <button id="stop_button">Stop</button>
            <xsl:text>&#xA0;</xsl:text>
            <button id="clear_button">Clear</button>
        </xsl:result-document>
        <xsl:call-template name="go"/>
    </xsl:template>
    
    <!--  The Clear button clears the grid (even if still going)  -->
    <xsl:template mode="ixsl:click" match="id('clear_button')">
        <xsl:apply-templates select="id('world',ixsl:page())/tbody/tr/td[@class='alive']" mode="kill"/>
    </xsl:template>
    
    <xsl:template name="go">
        <!-- We go only if the stop button shows we are still 'going' -->
        <xsl:if test="exists(id('stop_button', ixsl:page()))">
            <xsl:apply-templates select="id('world', ixsl:page())" mode="regenerate"/>
            <!-- The delay could be parameterized and a controller offered once Saxon supports variables -->
            <ixsl:schedule-action wait="1000">
                <xsl:call-template name="go-again"/>
            </ixsl:schedule-action>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="go-again">
        <xsl:choose>
            <xsl:when test="not(id('world',ixsl:page())/tbody/tr/td/@class='alive')">
                <xsl:call-template name="stop"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="go"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template mode="regenerate" match="id('world')">
        <!-- When producing the next generation, we must refer to the present state not the emerging one -->
        <xsl:apply-templates mode="regenerate" select="tbody/tr/td">
            <xsl:with-param name="was">
                <xsl:copy-of select="."/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:key name="td-by-neighbor" match="td" use="tokenize(@data-neighborhood,' ')"/>
    
    <!-- The logic accounts for both live cells and empty ones. -->
    <xsl:template mode="regenerate" match="td">
        <xsl:param name="was" required="yes" as="document-node()"/>
        <xsl:variable name="population" select="count(key('td-by-neighbor',@id,$was)[@class='alive'])"/>
        <xsl:choose>
            <xsl:when test="$population lt 3">
                <xsl:call-template name="kill"/>
            </xsl:when>
            <xsl:when test="$population gt 4">
                <xsl:call-template name="kill"/>
            </xsl:when>
            <xsl:when test="$population eq 3">
                <xsl:call-template name="grow"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="kill" mode="kill" match="td">
        <ixsl:remove-attribute name="class"/>
    </xsl:template>
    
    <xsl:template name="grow">
        <ixsl:set-attribute name="class" select="'alive'"/>
    </xsl:template>

</xsl:stylesheet>