<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT" xmlns="http://www.w3.org/2000/svg"
    exclude-result-prefixes="#all" extension-element-prefixes="ixsl" version="3.0">

    <!--    Pass in $set-time as a string. Errors if not hh:mm:ss (with zeroes).
        Note this is a 24-hour clock! -->


    <xsl:output method="xml" indent="true"/>

    <xsl:param name="clockSet" select="format-time(current-time(), '[H01]:[m01]:[s01]')"/>

    <xsl:param name="load-time" select="xs:time($clockSet)"/>

    <xsl:template match="/">
        <xsl:call-template name="draw-clock">
            <xsl:with-param name="now" select="$load-time"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="tell">
        <xsl:param name="when" select="$load-time"/>
        <!-- Begin by populating the page with the grid of cells. -->
        <xsl:result-document href="#page_body" method="ixsl:replace-content">
            <xsl:call-template name="draw-clock">
                <xsl:with-param name="now" select="$when"/>
                <xsl:with-param name="show-plain" select="id('view-toggle',ixsl:page())='Literal'"/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="draw-clock">
        <xsl:param name="now" select="$load-time"/>
        <xsl:param name="show-plain" select="true()"/>
        <svg id="clock" viewBox="0 0 400 300">

            <text x="200" y="250" text-anchor="middle" font-size="14" font-style="italic">Ist das
                nicht eine Uhr?</text>
            <text x="10" y="50" id="time-setting">
                <xsl:value-of select="format-time($now, '[h]:[m02] [Pn]')"/>
            </text>
            <g transform="translate(200 120)">
                <g id="legible-view" class="timeView{ if ($show-plain) then ' opened' else '' }">
                    <circle r="90" fill="none" fill-opacity="0.2" stroke="steelblue"
                        stroke-opacity="0.2" stroke-width="10"/>
                    <xsl:call-template name="ticks"/>
                    <xsl:call-template name="dots"/>
                    <xsl:call-template name="basic">
                        <xsl:with-param name="when" select="$now"/>
                    </xsl:call-template>
                </g>
                <g id="literal-view" class="timeView{ if ($show-plain) then '' else ' opened' }">
                    <xsl:call-template name="freaky">
                        <xsl:with-param name="when" select="$now"/>
                    </xsl:call-template>
                </g>
            </g>
            <!-- <xsl:result-document href="#xmljellysandwich_body"> .... </xsl:result-document> -->
        </svg>
    </xsl:template>


    <!-- Noon starts the page from the top, at noon. -->
    <xsl:template mode="ixsl:click" match="id('noon-reset_button')">
        <xsl:call-template name="tell">
            <xsl:with-param name="when" select="xs:time('00:00:00')"/>
        </xsl:call-template>
    </xsl:template>

    <!-- System resets to whatever comes back by asking for the time -->
    <xsl:template mode="ixsl:click" match="id('local-reset_button')">
        <xsl:call-template name="tell">
            <xsl:with-param name="when" select="current-time()"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template mode="label-rewrite" match="id('view-toggle')[. = 'Literal']">
        <xsl:result-document method="ixsl:replace-content" href="#view-toggle">Legible</xsl:result-document>
    </xsl:template>

    <xsl:template mode="label-rewrite" match="id('view-toggle')[. = 'Legible']">
        <xsl:result-document method="ixsl:replace-content" href="#view-toggle">Literal</xsl:result-document>
    </xsl:template>


    <xsl:template mode="ixsl:click" match="id('view-toggle')">
        <xsl:apply-templates select="." mode="label-rewrite"/>

        <xsl:for-each select="id('literal-view') | id('legible-view')">
            <xsl:call-template name="open-or-shut"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="open-or-shut" xpath-default-namespace="">
      <xsl:variable name="already-has" select="tokenize(@class, '\s+')"/>
      <ixsl:set-attribute name="class"
            select="string-join(
                ($already-has[not(. = 'opened')],
                  (if ($already-has = 'opened') then '' else 'opened')),
                ' ')"/>
    </xsl:template>
    
    <xsl:template name="ticks">
        <xsl:for-each select="1 to 11">
            <path stroke-width="2" d="M 0 -85 v -10" stroke="black" fill="none"
                transform="rotate({. * 30})"/>
        </xsl:for-each>
        <path stroke-width="2" d="M -3 -80 v -15" stroke="black" fill="none"/>
        <path stroke-width="2" d="M 3  -80 v -15" stroke="black" fill="none"/>

    </xsl:template>

    <xsl:template name="dots">
        <xsl:for-each select="1 to 59">
            <path stroke-width="1" d="M 0 -90 v 1" stroke="black" fill="none"
                transform="rotate({. * 6})"/>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="basic">
        <xsl:param name="when" as="xs:time" select="$load-time"/>
        <xsl:variable name="hours" select="hours-from-time($when) mod 12"/>
        <xsl:variable name="minutes" select="minutes-from-time($when)"/>
        <xsl:variable name="seconds" select="seconds-from-time($when)"/>
        <path d="M 0 3 v -50" stroke-width="5" stroke="black" fill="none">
            <xsl:variable name="hour-at" select="($hours * 30) + ($minutes div 2)"/>
            <animateTransform attributeName="transform" attributeType="XML" type="rotate"
                from="{$hour-at}" to="{360 + $hour-at}" dur="43200s" repeatCount="indefinite"/>
        </path>
        <path d="M 0 5 v -85" stroke-width="3" stroke="black" fill="none">
            <xsl:variable name="minutes-at" select="($minutes * 6) + ($seconds div 10)"/>
            <animateTransform attributeName="transform" attributeType="XML" type="rotate"
                from="{$minutes-at }" to="{360 + $minutes-at}" dur="3600s" repeatCount="indefinite"
            />
        </path>
        <path d="M 0 6 v -96" stroke-width="1" stroke="black" fill="none">
            <xsl:variable name="seconds-at" select="$seconds * 6"/>
            <animateTransform attributeName="transform" attributeType="XML" type="rotate"
                from="{$seconds-at}" to="{360 + $seconds-at}" dur="60s" repeatCount="indefinite"/>
        </path>
        <circle r="3" fill="black"/>
    </xsl:template>

    <xsl:template name="freaky">
        <xsl:param name="when" as="xs:time" select="$load-time"/>
        <xsl:variable name="hours" select="hours-from-time($when) mod 12"/>
        <xsl:variable name="minutes" select="minutes-from-time($when)"/>
        <xsl:variable name="seconds" select="seconds-from-time($when)"/>
        <g font-family="sans-serif" text-anchor="middle">
            <g>
                <text font-size="108" fill="darkgrey">O</text>
                <xsl:variable name="hour-at" select="($hours * 30) + ($minutes div 2)"/>
                <animateTransform attributeName="transform" attributeType="XML" type="rotate"
                    from="{$hour-at}" to="{360 + $hour-at}" dur="43200s" repeatCount="indefinite"/>
            </g>
            <g>
                <text y="-30" font-size="48">R</text>
                <xsl:variable name="minutes-at" select="($minutes * 6) + ($seconds div 10)"/>
                <animateTransform attributeName="transform" attributeType="XML" type="rotate"
                    from="{$minutes-at }" to="{360 + $minutes-at}" dur="3600s"
                    repeatCount="indefinite"/>
            </g>
            <g>
                <text y="-80" font-size="40">A</text>
                <xsl:variable name="seconds-at" select="$seconds * 6"/>
                <animateTransform attributeName="transform" attributeType="XML" type="rotate"
                    from="{$seconds-at}" to="{360 + $seconds-at}" dur="60s" repeatCount="indefinite"
                />
            </g>
            <text y="-12" font-size="16">H</text>

        </g>
    </xsl:template>


</xsl:stylesheet>