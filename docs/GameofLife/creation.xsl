<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    exclude-result-prefixes="xs math"
    extension-element-prefixes="ixsl"
    version="3.0">
    
    <xsl:output indent="yes"/>
    
    <!--<xsl:param name="scale" as="xs:integer">10</xsl:param>-->
    
    <xsl:template name="incipit">
        <!-- Target page components by assigning transformation results to them via their IDs in the host page. -->
        <xsl:result-document href="#page_body" method="ixsl:replace-content">
            <xsl:call-template name="grid">
                <!--<xsl:with-param name="size" select="$scale"/>-->
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="grid">
        <xsl:param name="scale" as="xs:integer">24</xsl:param>
        
        <table id="world">
        <xsl:for-each select="1 to $scale">
            <xsl:variable name="tribe" select="."/>
            <tr id="tribe{.}">
                <xsl:for-each select="1 to $scale">
                    <xsl:variable name="family" select="."/>
                    <xsl:variable name="neighbors" as="xs:string*">
                        <xsl:for-each select="(($tribe - 1) to ($tribe + 1))[not(. lt 1) and not(. gt $scale)]">
                              <xsl:variable name="y" select="."/>
                            <xsl:for-each
                                select="(($family - 1) to ($family + 1))[not(. lt 1) and not(. gt $scale)]">
                                <xsl:variable name="x">
                                    <xsl:number value="." format="A"/>
                                </xsl:variable>
                                <xsl:sequence select="$y || $x"/>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="label">
                        <xsl:value-of>
                            <xsl:value-of select="$tribe"/>
                            <xsl:number value="." format="A"/>
                        </xsl:value-of>
                    </xsl:variable>              
                    <td id="{$label}" data-neighbors="{$neighbors[not(.=$label)]}">&#xA0;</td>
                </xsl:for-each>
            </tr>
        </xsl:for-each>
        </table>
    </xsl:template>
                        
    <xsl:template match="td[@class='alive']" mode="ixsl:click">
        <xsl:apply-templates select="." mode="kill"/>
    </xsl:template>
    
    <!-- Implicit @priority="0" loses to priority 0.5 template above. -->
    <xsl:template match="td" mode="ixsl:click">
        <xsl:apply-templates select="." mode="spawn"/>
    </xsl:template>
    
    <xsl:template match="id('do_it_button')" mode="ixsl:click">
        <xsl:apply-templates select="id('world',ixsl:page())" mode="regenerate"/>
    </xsl:template>
    
    <xsl:template name="go" match="id('go_button')" mode="ixsl:click" >
        <xsl:result-document href="#stopgo" method="ixsl:replace-content"><button id="stop_button">Stop</button></xsl:result-document>
        <ixsl:schedule-action wait="5">
            <xsl:call-template name="go-again"/>
        </ixsl:schedule-action>
        
    </xsl:template>

    <xsl:template name="go-again">
        <!-- We don't go again unless the stop button shows we are still 'going' -->
        <xsl:if test="exists(id('stop_button', ixsl:page()))">
            <xsl:apply-templates select="id('world', ixsl:page())" mode="regenerate"/>
            <ixsl:schedule-action wait="5">
                <xsl:call-template name="go-again"/>
            </ixsl:schedule-action>
        </xsl:if>
    </xsl:template>
    
    <!-- Clicking the Stop button replaces it with the Go button (only) -->
    <xsl:template match="id('stop_button')" mode="ixsl:click">
        <xsl:result-document href="#stopgo" method="ixsl:replace-content"><button id="go_button">Go</button></xsl:result-document>
    </xsl:template>
    
    <xsl:template match="id('world')" mode="regenerate">
        <xsl:variable name="was">
            <xsl:copy-of select="."/>
        </xsl:variable>
        <xsl:apply-templates select=".//td" mode="regenerate">
            <xsl:with-param name="was">
                <xsl:copy-of select="."/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template mode="regenerate" match="td">
        <xsl:param name="was" required="yes" as="document-node()"/>
        <xsl:variable name="neighbor-cells" select="(tokenize(@data-neighbors,' ') ! id(.,$was) )[@class='alive']"/>
        <xsl:apply-templates select=".[count($neighbor-cells) lt 2]" mode="kill"/>
        <xsl:apply-templates select=".[count($neighbor-cells) = 3]"  mode="spawn"/>
        <xsl:apply-templates select=".[count($neighbor-cells) gt 3]" mode="kill"/>
    </xsl:template>
    
    
    <xsl:template match="*"                mode="kill">
        <ixsl:remove-attribute name="class"/>
    </xsl:template>
    
    <xsl:template match="*"                mode="spawn">
        <ixsl:set-attribute name="class" select="'alive'"/>
    </xsl:template>
    
        
        
        
        
</xsl:stylesheet>