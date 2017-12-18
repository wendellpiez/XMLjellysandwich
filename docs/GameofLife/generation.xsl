<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    exclude-result-prefixes="xs math"
    extension-element-prefixes="ixsl"
    version="3.0">
    
    <xsl:output indent="yes"/>
    
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
                                    (string($y) || format-integer($x, 'A'))"> </xsl:variable>
                        <td id="{$label}" data-neighborhood="{$neighborhood}" onclick="void(0)"
                            >&#x200b;</td>
                        <!-- zero-width space-->

                    </xsl:for-each>
                </tr>
            </xsl:for-each>
            </tbody>
        </table>

        <!-- Would like to do SVG but id() isn't binding to it, HTML DOM how sad ...
        <svg:svg  xmlns:svg="http://www.w3.org/2000/svg"
            id="world" version="1.1" width="100%" viewBox="0.5 0.5 {$dim} {$dim}">
            <svg:circle id="{{$label}}" data-neighborhood="{{$neighborhood}}" onclick="void(0)"
                cx="{{$family}}" cy="{{$tribe}}" r="0.4" fill="green"/>
        </svg:svg> -->
    </xsl:template>
    
    <!-- Interactivity: toggle cells alive and dead. -->
    <xsl:template mode="ixsl:click" match="td[@class='alive']">
        <xsl:apply-templates select="." mode="kill"/>
    </xsl:template>
    
    <!-- Implicit @priority="0" loses to priority 0.5 template above. -->
    <!-- Also svg:circle (some day) -->
    <xsl:template mode="ixsl:click" match="td">
        <xsl:apply-templates select="." mode="grow"/>
    </xsl:template>
    
    <xsl:template match="id('do_it_button')" mode="ixsl:click">
        <xsl:apply-templates select="id('world',ixsl:page())" mode="regenerate"/>
    </xsl:template>
    
    <!-- Clicking the Stop button replaces it with the Go button (only) -->
    <xsl:template match="id('stop_button')" mode="ixsl:click">
        <xsl:result-document href="#stopgo" method="ixsl:replace-content">
            <button id="go_button">Go</button>
        </xsl:result-document>
    </xsl:template>

    <!-- Clicking the go button does the same, and also ... goes  ... -->
    <xsl:template match="id('go_button')" mode="ixsl:click" >
        <xsl:result-document href="#stopgo" method="ixsl:replace-content">
            <button id="stop_button">Stop</button>
        </xsl:result-document>
        <xsl:call-template name="go"/>
    </xsl:template>

    <xsl:template name="go">
        <!-- We go only if the stop button shows we are still 'going' -->
        <xsl:if test="exists(id('stop_button', ixsl:page()))">
            <xsl:apply-templates select="id('world', ixsl:page())" mode="regenerate"/>
            <!-- The delay could be parameterized and a controller offered once Saxon supports variables -->
            <ixsl:schedule-action wait="500">
                <xsl:call-template name="go"/>
            </ixsl:schedule-action>
        </xsl:if>
    </xsl:template>
    
    <xsl:template mode="regenerate" match="id('world')">
        <!-- When producing the next generation, we must refer to the present state not the emerging one -->
        <xsl:apply-templates mode="regenerate" select="tbody/tr/td">
            <xsl:with-param name="was">
                <xsl:copy-of select="."/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template mode="regenerate" match="td">
        <xsl:param name="was" required="yes" as="document-node()"/>
        <xsl:variable name="population" select="count( (tokenize(@data-neighborhood,' ') ! id(.,$was) )[@class='alive'] )"/>
        <!--<xsl:message> population <xsl:value-of select="$population"/></xsl:message>-->
        <!-- overcrowded -->
        <xsl:apply-templates select=".[$population gt 4]" mode="kill"/>
        <!-- spawning, or already spawned and sustaining -->
        <xsl:apply-templates select=".[$population = 3]"  mode="grow"/>
        <!-- starving -->
        <xsl:apply-templates select=".[$population lt 3]" mode="kill"/>
    </xsl:template>

    <xsl:template match="*" mode="kill">
        <ixsl:remove-attribute name="class"/>
    </xsl:template>
    
    <xsl:template match="*" mode="grow">
        <ixsl:set-attribute name="class" select="'alive'"/>
    </xsl:template>

</xsl:stylesheet>