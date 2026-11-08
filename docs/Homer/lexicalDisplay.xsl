<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    exclude-result-prefixes="#all"
    extension-element-prefixes="ixsl"
    expand-text="true"
    version="3.0">
    
    
    <!-- 
    Additionally: a control panel to bold verbs by person and mood and nouns by number+case
      (checkboxes)
      CASE nom voc gen dat acc
      NUMBER singular dual plural
      PERSON 1st/2nd/3rd person
      MOOD ind/inf/subj/opt
      VOICE act/pass/med

    -->
    
    <xsl:import href="cunliffe-html.xsl"/>
    
    <xsl:template match="/" name="incipit">
        <xsl:result-document href="#page_body" method="ixsl:replace-content">
            <xsl:apply-templates/>
        </xsl:result-document>
        <xsl:call-template name="initialize-lexicon"/>
    </xsl:template>
    
    <xsl:template match="header | teiHeader"/>
    
    <xsl:template match="body/div">
        <details class="book" data-no="{ @n }">
            <summary class="title">Book { @n }</summary>
            <xsl:apply-templates/>
        </details>
    </xsl:template>
    
    <!--<xsl:template match="body/div[position() gt 1]" priority="11"/>
    
    <xsl:template match="l[position() gt 18]" priority="11"/>-->
    
    <xsl:template match="l">
        <p class="line" data-no="{ @n }" id="line_{ replace(@n,'\.','-')}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="child::*"/>
        </p>
    </xsl:template>
    
    <xsl:template match="w">
        <xsl:text>{ preceding-sibling::*[1]/' ' }</xsl:text>
        <span class="w" data-postag="{ @postag }" data-lemma="{ @lemma }">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="@*"/>
    
    
    <xsl:include href="interactivity.xsl"/>
    

    <!--Next: event handling -
      inject morphology + lemma into panel on click
      hold def(s) inside details
      
      build bibl id for any w from parent::l and ../parent::book
        span parent::p ../parent::details
      look up word in cunliffe XML by lemma and by bibl @ref
      parameterize bibl id for display
        -->
    
    <!--tunnel parameter $word in mode 'lexicography' carries an HTML span element--> 
    <xsl:template mode="lexicography" priority="101" match="body/div">
        <div class="lexentry">
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
        
</xsl:stylesheet>