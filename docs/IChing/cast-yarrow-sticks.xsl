<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://wendellpiez.com/iching"
    xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    version="3.0">
    
    <!-- produces an HTML page reporting the results
         of a cast according to yarrow-stalk probabilities
         (in yarrowcount.xsl) -->
    
    <xsl:import href="yarrowcount.xsl"/>
    <xsl:import href="svg-grams.xsl"/>
    
    <xsl:output indent="yes"/>
    
    <xsl:param name="yarrowSequence" as="xs:string" select="'6 6 6 9 9 9'"/>
    <xsl:param name="yarrow-sequence" as="xs:string" select="$yarrowSequence"/>
    
    <xsl:template match="/">
        <xsl:variable name="cast">
            <xsl:apply-imports/>
        </xsl:variable>
        
        <html>
            <head>
                <title xsl:expand-text="true">I Ching reading: { $cast/*/@time }</title>
            </head>
            <body>
                <xsl:apply-templates select="$cast" mode="read"/>
                <div id="footer" style="font-size: smaller">
                    <p><i>I Ching</i> implementation by Wendell Piez, 2019-2020.</p>
                </div>
            </body>
        </html>
        <!--<xsl:copy-of select="$cast"/>-->
        
    </xsl:template>
    
    <xsl:variable name="scrub-chars" as="xs:string">[^\p{L}\d\-]</xsl:variable>
    
    <xsl:template name="make-download-link">
        <xsl:param name="payload" select="()"/>
        <xsl:variable name="tag" expand-text="true">{
            $payload/descendant::*:h1[1] ! replace(.,'\s+','') ! replace(.,$scrub-chars,'_') 
            }_{ replace($yarrowSequence,'\s+','') }</xsl:variable>
        <xsl:variable name="fileName" expand-text="true">{format-dateTime(current-dateTime(),'[Y][M01][D01]-[H01][m01][s01]')}_{$tag}.html</xsl:variable>
        
        <!-- first, provide serialized $payload into hidden div       -->
        <xsl:result-document href="#serialized-save" method="ixsl:replace-content">
            <xsl:sequence select="serialize($payload)"/>
        </xsl:result-document>
        <xsl:result-document href="#save-as" method="ixsl:replace-content">
            <button onclick="acquireDownload('{$fileName}')">Save</button>
        </xsl:result-document>
    </xsl:template>
    

    <xsl:param name="framingText" select="''"/>
        
    <xsl:template name="cast">
        <xsl:choose>
            <xsl:when test="normalize-space($framingText)">
                <!-- cast delivers a tree representing the cast see yarrowcount.xsl for details -->
                <!-- <日><月><月><月><日><日 to="月"/></日></月></月></月></日> -->
                
                <xsl:variable name="cast">
                    <xsl:call-template name="reading"/>
                </xsl:variable>
                <xsl:result-document href="#page_body" method="ixsl:replace-content">
                    <main>
                        <xsl:apply-templates select="$cast" mode="read">
                            <xsl:with-param name="framing-text" select="$framingText"/>
                        </xsl:apply-templates>
                    </main>
                </xsl:result-document>
                <xsl:result-document href="#html_title" method="ixsl:replace-content">
                    <xsl:apply-templates select="$cast/reading/current" mode="page-head-text"/>
                </xsl:result-document>
                <xsl:call-template name="make-download-link">
                    <xsl:with-param name="payload">
                        <html>
                            <head>
                                <title>
                                    <xsl:apply-templates select="$cast/reading/current" mode="page-head-text"/>
                                </title>
                                <meta charset="utf-8"/>
                            </head>
                            <body>
                                <xsl:apply-templates select="$cast/reading" mode="read">
                                    <xsl:with-param name="framing-text" select="$framingText"/>
                                </xsl:apply-templates>
                                <div id="page_footer" style="font-size: smaller; border-top: medium groove black">
                                    <p>Reading produced by <a href="https://github.com/wendellpiez/XMLjellysandwich">XMLjellysandwich <i>I Ching</i></a> (Wendell Piez, 2019-2020).</p>
                                    <p>Dedicated to the teachers and transmitters, especially Thomas Cleary, <a href="ctext.org">CTP</a> and all open-source I Ching.</p>
                                    <p>Don't be a robot! Never click without consciousness or deliberation.</p>
                                </div>
                            </body>
                        </html>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:result-document href="#page_body" method="ixsl:replace-content">
                    <main>
                        <p class="framing">Enter a question or prompt.</p>
                </main>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        
    <xsl:template mode="read" match="reading" expand-text="true">
        <xsl:param name="framing-text" select="''"/>
        <!-- draw an SVG here :-) -->
        <div id="ideogram-block" style="float:right">
            <xsl:apply-templates select="current/*" mode="svg-gram"/>
        </div>
        
        <h2>{ @time }</h2>
        <xsl:if test="normalize-space($framing-text)">
            <p class="framing"><b>Prompt</b>: <xsl:value-of select="$framing-text"/></p>
        </xsl:if>
        <xsl:apply-templates mode="read"/>
        <div style="font-size:smaller">
            <p>The notes given are from <a target="wikipedia" href="https://en.wikipedia.org/wiki/List_of_hexagrams_of_the_I_Ching">Wikipedia</a>: please refer to your sources.</p>
        </div>
            </xsl:template>
    
    <!-- Here things are matching in any namespace to work around
         namespace issues in internal pipelining? -->
    
    <xsl:key name="section-by-char"
        match="*:section" use="tokenize(@class,'\s+')[2]"/>
    
    
    <xsl:template match="current" mode="page-head-text">
        <xsl:variable name="character" select="@char"/>
        <xsl:value-of select="key('section-by-char',$character,$kingwen)/*:header/string(.)"
          xpath-default-namespace="http://www.w3.org/1999/xhtml"/>
    </xsl:template>
    
    <xsl:template match="current" mode="read">
        <xsl:variable name="character" select="@char"/>
        <div class="hex current">
            
            <xsl:apply-templates 
                xpath-default-namespace="http://www.w3.org/1999/xhtml"
                mode="read" select="key('section-by-char',$character,$kingwen)/*:header"/>
           <!-- <xsl:for-each 
                select="$kingwen/*:html" expand-text="true">
                <!-\-/html/body/section[contains-token(@class,$character)]-\->
                <h1>King Wen is visible for { $character } at { namespace-uri(.) }:{ local-name(.) }</h1>
            </xsl:for-each>-->
            
            
         <xsl:apply-templates select="." mode="changing"/>
            
            <!--<xsl:copy-of select="."/>-->
            <xsl:apply-templates xpath-default-namespace="http://www.w3.org/1999/xhtml"
                mode="read" select="key('section-by-char',@char,$kingwen)/(* except *:header)"/>
            <xsl:apply-templates mode="ctext-link" select="key('anchor-for-hex',@char,$ctext)"/>
            
        </div>
    </xsl:template>
 
    <xsl:template match="current" mode="changing">
        <p class="changing">
            <xsl:text>Changing lines: </xsl:text>
            <xsl:for-each select="descendant::*[exists(@to)]">
                <xsl:if test="not(position() eq 1)">, </xsl:if>
                
                <xsl:apply-templates select="." mode="changing"/>
            </xsl:for-each>
        </p>
    </xsl:template>
    
    <xsl:template match="current[empty(descendant::*/@to)]" mode="changing">
        <p class="changing">No lines are changing</p>
    </xsl:template>
    
    <xsl:template mode="changing" match="*">
        <xsl:variable name="pos" select="count(ancestor::*) -1"/>
        <xsl:variable name="pseudo-date" select="'2000-01-0' || $pos"/>
        <xsl:variable name="eng" select="xs:date($pseudo-date) ! format-date(.,'[Dwo]')"/>
        <xsl:apply-templates select="." mode="name"/>
        <xsl:text expand-text="true"> in { $eng} place</xsl:text>
    </xsl:template>
    
    <xsl:template mode="name" match="日">nine</xsl:template>
    <xsl:template mode="name" match="月">six</xsl:template>
    
        
    <xsl:template match="becoming" mode="read">
        <div class="hex becoming">
            <xsl:apply-templates mode="read" select="key('section-by-char',@char,$kingwen)"/>
            <xsl:apply-templates mode="ctext-link" select="key('anchor-for-hex',@char,$ctext)"/>
            
        </div>
    </xsl:template>
    
    <xsl:template mode="read" match="*:section">
        <xsl:apply-templates mode="read"/>
    </xsl:template>
    
    <xsl:template mode="read" match="*:section/*:header">
        <h1>
            <xsl:apply-templates mode="read"/>
        </h1>
    </xsl:template>
    
    <xsl:template match="text()" mode="read">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <xsl:mode name="read" on-no-match="shallow-copy"/>
    
    <xsl:key name="anchor-for-hex" match="*:a"
        use="substring(.,1,1)"/>
    
<!-- should match an 'a' whose @href we can just splice   -->
    <xsl:template mode="ctext-link" match="*">
        <p class="link">Link to <a target="ctext" href="http://ctext.org/{@href}"
            xsl:expand-text="true">Chinese Text Project on { . }</a></p>
    </xsl:template>


   
    <xsl:variable name="kingwen">
        <!-- copied verbatim from refined kingwen-list.xhtml -->
        <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <title>I Ching Summary (King Wen Order)</title>
   </head>
   <body>
      <section class="hexagram ䷀">
         <header>1 ䷀ The Creative Heaven</header>
         <p>Hexagram 1 is named 乾 (qián), "Force". Other variations include "the creative", "strong
            action", "the key", and "god". Its inner (lower) trigram is ☰ (乾 qián) force = (天)
            heaven, and its outer (upper) trigram is the same.</p>
      </section>
      <section class="hexagram ䷁">
         <header>2 ䷁ The Receptive Earth</header>
         <p>Hexagram 2 is named 坤 (kūn), "Field". Other variations include "the receptive",
            "acquiescence", and "the flow". Its inner (lower) trigram is ☷ (坤 kūn) field = (地)
            earth, and its outer (upper) trigram is identical.</p>
      </section>
      <section class="hexagram ䷂">
         <header>3 ䷂ Difficulty at the Beginning</header>
         <p>Hexagram 3 is named 屯 (zhūn), "Sprouting". Other variations include "difficulty at the
            beginning", "gathering support", and "hoarding". Its inner (lower) trigram is ☳ (震 zhèn)
            shake = (雷) thunder, and its outer (upper) trigram is ☵ (坎 kǎn) gorge = (水) water.</p>
      </section>
      <section class="hexagram ䷃">
         <header>4 ䷃ Youthful Folly</header>
         <p>Hexagram 4 is named 蒙 (méng), "Enveloping". Other variations include "youthful folly",
            "the young shoot", and "discovering". Its inner trigram is ☵ (坎 kǎn) gorge = (水) water.
            Its outer trigram is ☶ (艮 gèn) bound = (山) mountain.</p>
      </section>
      <section class="hexagram ䷄">
         <header>5 ䷄ Waiting</header>
         <p>Hexagram 5 is named 需 (xū), "Attending". Other variations include "waiting",
            "moistened", and "arriving". Its inner (lower) trigram is ☰ (乾 qián) force = (天) heaven,
            and its outer (upper) trigram is ☵ (坎 kǎn) gorge = (水) water.</p>
      </section>
      <section class="hexagram ䷅">
         <header>6 ䷅ Conflict</header>
         <p>Hexagram 6 is named 訟 (sòng), "Arguing". Other variations include "conflict" and
            "lawsuit". Its inner (lower) trigram is ☵ (坎 kǎn) gorge = (水) water, and its outer
            (upper) trigram is ☰ (乾 qián) force = (天) heaven.</p>
      </section>
      <section class="hexagram ䷆">
         <header>7 ䷆ The Army</header>
         <p>Hexagram 7 is named 師 (shī), "Leading". Other variations include "the army" and "the
            troops". Its inner (lower) trigram is ☵ (坎 kǎn) gorge = (水) water, and its outer (upper)
            trigram is ☷ (坤 kūn) field = (地) earth.</p>
      </section>
      <section class="hexagram ䷇">
         <header>8 ䷇ Holding Together</header>
         <p>Hexagram 8 is named 比 (bǐ), "Grouping". Other variations include "holding together" and
            "alliance". Its inner (lower) trigram is ☷ (坤 kūn) field = (地) earth, and its outer
            (upper) trigram is ☵ (坎 kǎn) gorge = (水) water.</p>
      </section>
      <section class="hexagram ䷈">
         <header>9 ䷈ Small Taming</header>
         <p>Hexagram 9 is named 小畜 (xiǎo chù), "Small Accumulating". Other variations include "the
            taming power of the small" and "small harvest". Its inner (lower) trigram is ☰ (乾 qián)
            force = (天) heaven, and its outer (upper) trigram is ☴ (巽 xùn) ground = (風) wind.</p>
      </section>
      <section class="hexagram ䷉">
         <header>10 ䷉ Treading</header>
         <p>Hexagram 10 is named 履 (lǚ), "Treading". Other variations include "treading (conduct)"
            and "continuing". Its inner (lower) trigram is ☱ (兌 duì) open = (澤) swamp, and its outer
            (upper) trigram is ☰ (乾 qián) force = (天) heaven.</p>
      </section>
      <section class="hexagram ䷊">
         <header>11 ䷊ Peace</header>
         <p>Hexagram 11 is named 泰 (tài), "Pervading". Other variations include "peace" and
            "greatness". Its inner (lower) trigram is ☰ (乾 qián) force = (天) heaven, and its outer
            (upper) trigram is ☷ (坤 kūn) field = (地) earth.</p>
      </section>
      <section class="hexagram ䷋">
         <header>12 ䷋ Standstill</header>
         <p>Hexagram 12 is named 否 (pǐ), "Obstruction". Other variations include "standstill
            (stagnation)" and "selfish persons". Its inner (lower) trigram is ☷ (坤 kūn) field = (地)
            earth, and its outer (upper) trigram is ☰ (乾 qián) force = (天) heaven.</p>
      </section>
      <section class="hexagram ䷌">
         <header>13 ䷌ Fellowship</header>
         <p>Hexagram 13 is named 同人 (tóng rén), "Concording People". Other variations include
            "fellowship with men" and "gathering men". Its inner (lower) trigram is ☲ (離 lí)
            radiance = (火) fire, and its outer (upper) trigram is ☰ (乾 qián) force = (天) heaven.</p>
      </section>
      <section class="hexagram ䷍">
         <header>14 ䷍ Great Possession</header>
         <p>Hexagram 14 is named 大有 (dà yǒu), "Great Possessing". Other variations include
            "possession in great measure" and "the great possession". Its inner (lower) trigram is ☰
            (乾 qián) force = (天) heaven, and its outer (upper) trigram is ☲ (離 lí) radiance = (火)
            fire.</p>
      </section>
      <section class="hexagram ䷎">
         <header>15 ䷎ Modesty</header>
         <p>Hexagram 15 is named 謙 (qiān), "Humbling". Other variations include "modesty". Its inner
            (lower) trigram is ☶ (艮 gèn) bound = (山) mountain and its outer (upper) trigram is ☷ (坤
            kūn) field = (地) earth.</p>
      </section>
      <section class="hexagram ䷏">
         <header>16 ䷏ Enthusiasm</header>
         <p>Hexagram 16 is named 豫 (yù), "Providing-For". Other variations include "enthusiasm" and
            "excess". Its inner (lower) trigram is ☷ (坤 kūn) field = (地) earth, and its outer
            (upper) trigram is ☳ (震 zhèn) shake = (雷) thunder.</p>
      </section>
      <section class="hexagram ䷐">
         <header>17 ䷐ Following</header>
         <p>Hexagram 17 is named 隨 (suí), "Following". Its inner (lower) trigram is ☳ (震 zhèn) shake
            = (雷) thunder, and its outer (upper) trigram is ☱ (兌 duì) open = (澤) swamp.</p>
      </section>
      <section class="hexagram ䷑">
         <header>18 ䷑ Work on the Decayed</header>
         <p>Hexagram 18 is named 蠱 (gǔ), "Correcting". Other variations include "work on what has
            been spoiled (decay)", decaying and "branch".<sup id="cite_ref-1" class="reference"
               >[1]</sup> Its inner (lower) trigram is ☴ (巽 xùn) ground = (風) wind, and its outer
            (upper) trigram is ☶ (艮 gèn) bound = (山) mountain. Gu is the name of a venom-based
            poison traditionally used in Chinese witchcraft.</p>
      </section>
      <section class="hexagram ䷒">
         <header>19 ䷒ Approach</header>
         <p>Hexagram 19 is named 臨 (lín), "Nearing". Other variations include "approach" and "the
            forest". Its inner (lower) trigram is ☱ (兌 duì) open = (澤) swamp, and its outer (upper)
            trigram is ☷ (坤 kūn) field = (地) earth.</p>
      </section>
      <section class="hexagram ䷓">
         <header>20 ䷓ Contemplation</header>
         <p>Hexagram 20 is named 觀 (guān), "Viewing". Other variations include "contemplation
            (view)" and "looking up". Its inner (lower) trigram is ☷ (坤 kūn) field = (地) earth, and
            its outer (upper) trigram is ☴ (巽 xùn) ground = (風) wind.</p>
      </section>
      <section class="hexagram ䷔">
         <header>21 ䷔ Biting Through</header>
         <p>Hexagram 21 is named 噬嗑 (shì kè), "Gnawing Bite". Other variations include "biting
            through" and "biting and chewing". Its inner (lower) trigram is ☳ (震 zhèn) shake = (雷)
            thunder, and its outer trigram is ☲ (離 lí) radiance = (火) fire. <sup id="cite_ref-2"
               class="reference">[2]</sup></p>
      </section>
      <section class="hexagram ䷕">
         <header>22 ䷕ Grace</header>
         <p>Hexagram 22 is named 賁 (bì), "Adorning". Other variations include "grace" and
            "luxuriance". Its inner (lower) trigram is ☲ (離 lí) radiance = (火) fire, and its outer
            (upper) trigram is ☶ (艮 gèn) bound = (山) mountain. <sup id="cite_ref-3"
               class="reference">[3]</sup></p>
      </section>
      <section class="hexagram ䷖">
         <header>23 ䷖ Splitting Apart</header>
         <p>Hexagram 23 is named 剝 (bō), "Stripping". Other variations include "splitting apart" and
            "flaying". Its inner trigram is ☷ (坤 kūn) field = (地) earth, and its outer trigram is ☶
            (艮 gèn) bound = (山) mountain.</p>
      </section>
      <section class="hexagram ䷗">
         <header>24 ䷗ Return</header>
         <p>Hexagram 24 is named 復 (fù), "Returning". Other variations include "return (the turning
            point)". Its inner trigram is ☳ (震 zhèn) shake = (雷) thunder, and its outer trigram is ☷
            (坤 kūn) field = (地) earth.</p>
      </section>
      <section class="hexagram ䷘">
         <header>25 ䷘ Innocence</header>
         <p>Hexagram 25 is named 無妄 (wú wàng), "Without Embroiling". Other variations include
            "innocence (the unexpected)" and "pestilence". Its inner trigram is ☳ (震 zhèn) shake =
            (雷) thunder, and its outer trigram is ☰ (乾 qián) force = (天) heaven.</p>
      </section>
      <section class="hexagram ䷙">
         <header>26 ䷙ Great Taming</header>
         <p>Hexagram 26 is named 大畜 (dà chù), "Great Accumulating". Other variations include "the
            taming power of the great", "great storage", and "potential energy". Its inner trigram
            is ☰ (乾 qián) force = (天) heaven, and its outer trigram is ☶ (艮 gèn) bound = (山)
            mountain.</p>
      </section>
      <section class="hexagram ䷚">
         <header>27 ䷚ Mouth Corners</header>
         <p>Hexagram 27 is named 頤 (yí), "Swallowing". Other variations include "the corners of the
            mouth (providing nourishment)", "jaws" and "comfort/security". Its inner trigram is ☳ (震
            zhèn) shake = (雷) thunder, and its outer trigram is ☶ (艮 gèn) bound = (山) mountain.</p>
      </section>
      <section class="hexagram ䷛">
         <header>28 ䷛ Great Preponderance</header>
         <p>Hexagram 28 is named 大過 (dà guò), "Great Exceeding". Other variations include
            "preponderance of the great", "great surpassing" and "critical mass". Its inner trigram
            is ☴ (巽 xùn) ground = (風) wind, and its outer trigram is ☱ (兌 duì) open = (澤) swamp.</p>
      </section>
      <section class="hexagram ䷜">
         <header>29 ䷜ The Abysmal Water</header>
         <p>Hexagram 29 is named 坎 (kǎn), "Gorge". Other variations include "the abyss" (in the
            oceanographic sense) and "repeated entrapment". Its inner trigram is ☵ (坎 kǎn) gorge =
            (水) water, and its outer trigram is identical.</p>
      </section>
      <section class="hexagram ䷝">
         <header>30 ䷝ The Clinging Fire</header>
         <p>Hexagram 30 is named 離 (lí), "Radiance". Other variations include "the clinging, fire"
            and "the net". Its inner trigram is ☲ (離 lí) radiance = (火) fire, and its outer trigram
            is identical. The origin of the character has its roots in symbols of long-tailed birds
            such as the peacock or the legendary phoenix.</p>
      </section>
      <section class="hexagram ䷞">
         <header>31 ䷞ Influence</header>
         <p>Hexagram 31 is named 咸 (xián), "Conjoining". Other variations include "influence
            (wooing)" and "feelings". Its inner trigram is ☶ (艮 gèn) bound = (山) mountain, and its
            outer trigram is ☱ (兌 duì) open = (澤) swamp.</p>
      </section>
      <section class="hexagram ䷟">
         <header>32 ䷟ Duration</header>
         <p>Hexagram 32 is named 恆 (héng), "Persevering". Other variations include "duration" and
            "constancy". Its inner trigram is ☴ (巽 xùn) ground = (風) wind, and its outer trigram is
            ☳ (震 zhèn) shake = (雷) thunder.</p>
      </section>
      <section class="hexagram ䷠">
         <header>33 ䷠ Retreat</header>
         <p>Hexagram 33 is named 遯 (dùn), "Retiring". Other variations include "retreat" and
            "yielding". Its inner trigram is ☶ (艮 gèn) bound = (山) mountain, and its outer trigram
            is ☰ (乾 qián) force = (天) heaven.</p>
      </section>
      <section class="hexagram ䷡">
         <header>34 ䷡ Great Power</header>
         <p>Hexagram 34 is named 大壯 (dà zhuàng), "Great Invigorating". Other variations include "the
            power of the great" and "great maturity". Its inner trigram is ☰ (乾 qián) force = (天)
            heaven, and its outer trigram is ☳ (震 zhèn) shake = (雷) thunder.</p>
      </section>
      <section class="hexagram ䷢">
         <header>35 ䷢ Progress</header>
         <p>Hexagram 35 is named 晉 (jìn), "Prospering". Other variations include "progress" and
            "aquas". Its inner trigram is ☷ (坤 kūn) field = (地) earth, and its outer trigram is ☲ (離
            lí) radiance = (火) fire.</p>
      </section>
      <section class="hexagram ䷣">
         <header>36 ䷣ Darkening of the Light</header>
         <p>Hexagram 36 is named 明夷 (míng yí), "Darkening of the Light". Other variations include
            "brilliance injured" and "intelligence hidden". Its inner trigram is ☲ (離 lí) radiance =
            (火) fire, and its outer trigram is ☷ (坤 kūn) field = (地) earth.</p>
      </section>
      <section class="hexagram ䷤">
         <header>37 ䷤ The Family</header>
         <p>Hexagram 37 is named 家人 (jiā rén), "Dwelling People". Other variations include "the
            family (the clan)" and "family members". Its inner trigram is ☲ (離 lí) radiance = (火)
            fire, and its outer trigram is ☴ (巽 xùn) ground = (風) wind.</p>
      </section>
      <section class="hexagram ䷥">
         <header>38 ䷥ Opposition</header>
         <p>Hexagram 38 is named 睽 (kuí), "Polarising". Other variations include "opposition" and
            "perversion". Its inner trigram is ☱ (兌 duì) open = (澤) swamp, and its outer trigram is
            ☲ (離 lí) radiance = (火) fire.</p>
      </section>
      <section class="hexagram ䷦">
         <header>39 ䷦ Obstruction</header>
         <p>Hexagram 39 is named 蹇 (jiǎn), "Limping". Other variations include "obstruction" and
            "afoot". Its inner trigram is ☶ (艮 gèn) bound = (山) mountain, and its outer trigram is ☵
            (坎 kǎn) gorge = (水) water.</p>
      </section>
      <section class="hexagram ䷧">
         <header>40 ䷧ Deliverance</header>
         <p>Hexagram 40 is named 解 (xiè), "Taking-Apart". Other variations include "deliverance" and
            "untangled". Its inner trigram is ☵ (坎 kǎn) gorge = (水) water, and its outer trigram is
            ☳ (震 zhèn) shake = (雷) thunder.</p>
      </section>
      <section class="hexagram ䷨">
         <header>41 ䷨ Decrease</header>
         <p>Hexagram 41 is named 損 (sǔn), "Diminishing". Other variations include "decrease". Its
            inner trigram is ☱ (兌 duì) open = (澤) swamp, and its outer trigram is ☶ (艮 gèn) bound =
            (山) mountain.</p>
      </section>
      <section class="hexagram ䷩">
         <header>42 ䷩ Increase</header>
         <p>Hexagram 42 is named 益 (yì), "Augmenting". Other variations include "increase". Its
            inner trigram is ☳ (震 zhèn) shake = (雷) thunder, and its outer trigram is ☴ (巽 xùn)
            ground = (風) wind.</p>
      </section>
      <section class="hexagram ䷪">
         <header>43 ䷪ Breakthrough</header>
         <p>Hexagram 43 is named 夬 (guài), "Displacement". Other variations include "resoluteness",
            "parting", and "break-through". Its inner trigram is ☰ (乾 qián) force = (天) heaven, and
            its outer trigram is ☱ (兌 duì) open = (澤) swamp.</p>
      </section>
      <section class="hexagram ䷫">
         <header>44 ䷫ Coming to Meet</header>
         <p>Hexagram 44 is named 姤 (gòu), "Coupling". Other variations include "coming to meet" and
            "meeting". Its inner trigram is ☴ (巽 xùn) ground = (風) wind, and its outer trigram is ☰
            (乾 qián) force = (天) heaven.</p>
      </section>
      <section class="hexagram ䷬">
         <header>45 ䷬ Gathering Together</header>
         <p>Hexagram 45 is named 萃 (cuì), "Clustering". Other variations include "gathering together
            (massing)" and "finished". Its inner trigram is ☷ (坤 kūn) field = (地) earth, and its
            outer trigram is ☱ (兌 duì) open = (澤) swamp.</p>
      </section>
      <section class="hexagram ䷭">
         <header>46 ䷭ Pushing Upward</header>
         <p>Hexagram 46 is named 升 (shēng), "Ascending". Other variations include "pushing upward".
            Its inner trigram is ☴ (巽 xùn) ground = (風) wind, and its outer trigram is ☷ (坤 kūn)
            field = (地) earth.</p>
      </section>
      <section class="hexagram ䷮">
         <header>47 ䷮ Oppression</header>
         <p>Hexagram 47 is named 困 (kùn), "Confining". Other variations include "oppression
            (exhaustion)" and "entangled". Its inner trigram is ☵ (坎 kǎn) gorge = (水) water, and its
            outer trigram is ☱ (兌 duì) open = (澤) swamp.</p>
      </section>
      <section class="hexagram ䷯">
         <header>48 ䷯ The Well</header>
         <p>Hexagram 48 is named 井 (jǐng), "Welling". Other variations include "the well". Its inner
            trigram is ☴ (巽 xùn) ground = (風) wind, and its outer trigram is ☵ (坎 kǎn) gorge = (水)
            water.</p>
      </section>
      <section class="hexagram ䷰">
         <header>49 ䷰ Revolution</header>
         <p>Hexagram 49 is named 革 (gé), "Skinning". Other variations include "revolution (molting)"
            and "the bridle". Its inner trigram is ☲ (離 lí) radiance = (火) fire, and its outer
            trigram is ☱ (兌 duì) open = (澤) swamp.</p>
      </section>
      <section class="hexagram ䷱">
         <header>50 ䷱ The Cauldron</header>
         <p>Hexagram 50 is named 鼎 (dǐng), "Holding". Other variations include "the cauldron". Its
            inner trigram is ☴ (巽 xùn) ground = (風) wind, and its outer trigram is ☲ (離 lí) radiance
            = (火) fire.</p>
      </section>
      <section class="hexagram ䷲">
         <header>51 ䷲ The Arousing Thunder</header>
         <p>Hexagram 51 is named 震 (zhèn), "Shake". Other variations include "the arousing (shock,
            thunder)" and "thunder". Both its inner and outer trigrams are ☳ (震 zhèn) shake = (雷)
            thunder.</p>
      </section>
      <section class="hexagram ䷳">
         <header>52 ䷳ The Keeping Still Mountain</header>
         <p>Hexagram 52 is named 艮 (gèn), "Bound". Other variations include "keeping still,
            mountain" and "stilling". Both its inner and outer trigrams are ☶ (艮 gèn) bound = (山)
            mountain.</p>
      </section>
      <section class="hexagram ䷴">
         <header>53 ䷴ Development</header>
         <p>Hexagram 53 is named 漸 (jiàn), "Infiltrating". Other variations include "development
            (gradual progress)" and "advancement". Its inner trigram is ☶ (艮 gèn) bound = (山)
            mountain, and its outer trigram is ☴ (巽 xùn) ground = (風) wind.</p>
      </section>
      <section class="hexagram ䷵">
         <header>54 ䷵ The Marrying Maiden</header>
         <p>Hexagram 54 is named 歸妹 (guī mèi), "Converting the Maiden". Other variations include
            "the marrying maiden" and "returning maiden". Its inner trigram is ☱ (兌 duì) open = (澤)
            swamp, and its outer trigram is ☳ (震 zhèn) shake = (雷) thunder.</p>
      </section>
      <section class="hexagram ䷶">
         <header>55 ䷶ Abundance</header>
         <p>Hexagram 55 is named 豐 (fēng), "Abounding". Other variations include "abundance" and
            "fullness". Its inner trigram is ☲ (離 lí) radiance = (火) fire, and its outer trigram is
            ☳ (震 zhèn) shake = (雷) thunder.</p>
      </section>
      <section class="hexagram ䷷">
         <header>56 ䷷ The Wanderer</header>
         <p>Hexagram 56 is named 旅 (lǚ), "Sojourning". Other variations include "the wanderer" and
            "traveling". Its inner trigram is ☶ (艮 gèn) bound = (山) mountain, and its outer trigram
            is ☲ (離 lí) radiance = (火) fire.</p>
      </section>
      <section class="hexagram ䷸">
         <header>57 ䷸ The Gentle Wind</header>
         <p>Hexagram 57 is named 巽 (xùn), "Ground". Other variations include "the gentle (the
            penetrating, wind)" and "calculations". Both its inner and outer trigrams are ☴ (巽 xùn)
            ground = (風) wind.</p>
      </section>
      <section class="hexagram ䷹">
         <header>58 ䷹ The Joyous Lake</header>
         <p>Hexagram 58 is named 兌 (duì), "Open". Other variations include "the joyous, lake" and
            "usurpation". Both its inner and outer trigrams are ☱ (兌 duì) open = (澤) swamp.</p>
      </section>
      <section class="hexagram ䷺">
         <header>59 ䷺ Dispersion</header>
         <p>Hexagram 59 is named 渙 (huàn), "Dispersing". Other variations include "dispersion
            (dissolution)" and "dispersal". Its inner trigram is ☵ (坎 kǎn) gorge = (水) water, and
            its outer trigram is ☴ (巽 xùn) ground = (風) wind.</p>
      </section>
      <section class="hexagram ䷻">
         <header>60 ䷻ Limitation</header>
         <p>Hexagram 60 is named 節 (jié), "Articulating". Other variations include "limitation" and
            "moderation". Its inner trigram is ☱ (兌 duì) open = (澤) swamp, and its outer trigram is
            ☵ (坎 kǎn) gorge = (水) water.</p>
      </section>
      <section class="hexagram ䷼">
         <header>61 ䷼ Inner Truth</header>
         <p>Hexagram 61 is named 中孚 (zhōng fú), "Center Returning". Other variations include "inner
            truth" and "central return". Its inner trigram is ☱ (兌 duì) open = (澤) swamp, and its
            outer trigram is ☴ (巽 xùn) ground = (風) wind.</p>
      </section>
      <section class="hexagram ䷽">
         <header>62 ䷽ Small Preponderance</header>
         <p>Hexagram 62 is named 小過 (xiǎo guò), "Small Exceeding". Other variations include
            "preponderance of the small" and "small surpassing". Its inner trigram is ☶ (艮 gèn)
            bound = (山) mountain, and its outer trigram is ☳ (震 zhèn) shake = (雷) thunder.</p>
      </section>
      <section class="hexagram ䷾">
         <header>63 ䷾ After Completion</header>
         <p>Hexagram 63 is named 既濟 (jì jì), "Already Fording". Other variations include "after
            completion" and "already completed" or "already done" . Its inner trigram is ☲ (離 lí)
            radiance = (火) fire, and its outer trigram is ☵ (坎 kǎn) gorge = (水) water.</p>
      </section>
      <section class="hexagram ䷿">
         <header>64 ䷿ Before Completion</header>
         <p>Hexagram 64 is named 未濟 (wèi jì), "Not Yet Fording". Other variations include "before
            completion" and "not yet completed". Its inner trigram is ☵ (坎 kǎn) gorge = (水) water,
            and its outer trigram is ☲ (離 lí) radiance = (火) fire.</p>
      </section>
   </body>
</html>
    </xsl:variable>
 
 
    <xsl:variable name="ctext">
        <!--  select="document('ctextdotorg-toc.xhtml')" -->
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>CText ToC</title>
            </head>
            <!-- https://ctext.org/book-of-changes/yi-jing copied by hand 2019 Feb 2 wap
    ctext.org explicitly forbids scraping / mass download so don't do it!
    the links are provided here so they can be retrieved dynamically
    -->
            <body>　1. <a href="book-of-changes/qian">䷀乾 - Qian</a>
                <div style="display: inline-block">
                    <a href="discuss.pl?if=en&amp;bookid=25006" class="sprite-discuss"
                        title="Related discussion">Related discussion<div style="display: inline;"
                            ></div></a>
                </div><br class="br" />　2. <a href="book-of-changes/kun">䷁坤 - Kun</a>
                <br class="br" />　3. <a href="book-of-changes/zhun">䷂屯 - Zhun</a>
                <br class="br" />　4. <a href="book-of-changes/meng">䷃蒙 - Meng</a>
                <br class="br" />　5. <a href="book-of-changes/xu">䷄需 - Xu</a>
                <br class="br" />　6. <a href="book-of-changes/song">䷅訟 - Song</a>
                <br class="br" />　7. <a href="book-of-changes/shi">䷆師 - Shi</a>
                <br class="br" />　8. <a href="book-of-changes/bi">䷇比 - Bi</a>
                <br class="br" />　9. <a href="book-of-changes/xiao-xu">䷈小畜 - Xiao Xu</a>
                <br class="br" />　10. <a href="book-of-changes/lu">䷉履 - Lu</a>
                <br class="br" />　11. <a href="book-of-changes/tai">䷊泰 - Tai</a>
                <br class="br" />　12. <a href="book-of-changes/pi">䷋否 - Pi</a>
                <br class="br" />　13. <a href="book-of-changes/tong-ren">䷌同人 - Tong Ren</a>
                <br class="br" />　14. <a href="book-of-changes/da-you">䷍大有 - Da You</a>
                <br class="br" />　15. <a href="book-of-changes/qian1">䷎謙 - Qian</a>
                <br class="br" />　16. <a href="book-of-changes/yu">䷏豫 - Yu</a>
                <br class="br" />　17. <a href="book-of-changes/sui">䷐隨 - Sui</a>
                <br class="br" />　18. <a href="book-of-changes/gu">䷑蠱 - Gu</a>
                <br class="br" />　19. <a href="book-of-changes/lin">䷒臨 - Lin</a>
                <br class="br" />　20. <a href="book-of-changes/guan">䷓觀 - Guan</a>
                <br class="br" />　21. <a href="book-of-changes/shi-he">䷔噬嗑 - Shi He</a>
                <br class="br" />　22. <a href="book-of-changes/bi1">䷕賁 - Bi</a>
                <br class="br" />　23. <a href="book-of-changes/bo">䷖剝 - Bo</a>
                <br class="br" />　24. <a href="book-of-changes/fu">䷗復 - Fu</a>
                <br class="br" />　25. <a href="book-of-changes/wu-wang">䷘无妄 - Wu Wang</a>
                <br class="br" />　26. <a href="book-of-changes/da-xu">䷙大畜 - Da Xu</a>
                <div style="display: inline-block">
                    <a href="discuss.pl?if=en&amp;bookid=25460" class="sprite-discuss"
                        title="Related discussion">Related discussion<div style="display: inline;"
                            ></div></a>
                </div><br class="br" />　27. <a href="book-of-changes/yi">䷚頤 - Yi</a>
                <br class="br" />　28. <a href="book-of-changes/da-guo">䷛大過 - Da Guo</a>
                <br class="br" />　29. <a href="book-of-changes/kan">䷜坎 - Kan</a>
                <br class="br" />　30. <a href="book-of-changes/li">䷝離 - Li</a>
                <br class="br" />　31. <a href="book-of-changes/xian">䷞咸 - Xian</a>
                <br class="br" />　32. <a href="book-of-changes/heng">䷟恆 - Heng</a>
                <br class="br" />　33. <a href="book-of-changes/dun">䷠遯 - Dun</a>
                <br class="br" />　34. <a href="book-of-changes/da-zhuang">䷡大壯 - Da Zhuang</a>
                <div style="display: inline-block">
                    <a href="discuss.pl?if=en&amp;bookid=25601" class="sprite-discuss"
                        title="Related discussion">Related discussion<div style="display: inline;"
                            ></div></a>
                </div><br class="br" />　35. <a href="book-of-changes/jin">䷢晉 - Jin</a>
                <br class="br" />　36. <a href="book-of-changes/ming-yi">䷣明夷 - Ming Yi</a>
                <br class="br" />　37. <a href="book-of-changes/jia-ren">䷤家人 - Jia Ren</a>
                <br class="br" />　38. <a href="book-of-changes/kui">䷥睽 - Kui</a>
                <div style="display: inline-block">
                    <a href="discuss.pl?if=en&amp;bookid=25673" class="sprite-discuss"
                        title="Related discussion">Related discussion<div style="display: inline;"
                            ></div></a>
                </div><br class="br" />　39. <a href="book-of-changes/jian">䷦蹇 - Jian</a>
                <br class="br" />　40. <a href="book-of-changes/jie">䷧解 - Jie</a>
                <br class="br" />　41. <a href="book-of-changes/sun">䷨損 - Sun</a>
                <br class="br" />　42. <a href="book-of-changes/yi1">䷩益 - Yi</a>
                <br class="br" />　43. <a href="book-of-changes/guai">䷪夬 - Guai</a>
                <br class="br" />　44. <a href="book-of-changes/gou">䷫姤 - Gou</a>
                <br class="br" />　45. <a href="book-of-changes/cui">䷬萃 - Cui</a>
                <br class="br" />　46. <a href="book-of-changes/sheng">䷭升 - Sheng</a>
                <br class="br" />　47. <a href="book-of-changes/kun1">䷮困 - Kun</a>
                <br class="br" />　48. <a href="book-of-changes/jing">䷯井 - Jing</a>
                <br class="br" />　49. <a href="book-of-changes/ge">䷰革 - Ge</a>
                <br class="br" />　50. <a href="book-of-changes/ding">䷱鼎 - Ding</a>
                <br class="br" />　51. <a href="book-of-changes/zhen">䷲震 - Zhen</a>
                <br class="br" />　52. <a href="book-of-changes/gen">䷳艮 - Gen</a>
                <br class="br" />　53. <a href="book-of-changes/jian1">䷴漸 - Jian</a>
                <br class="br" />　54. <a href="book-of-changes/gui-mei">䷵歸妹 - Gui Mei</a>
                <br class="br" />　55. <a href="book-of-changes/feng">䷶豐 - Feng</a>
                <br class="br" />　56. <a href="book-of-changes/lu1">䷷旅 - Lu</a>
                <div style="display: inline-block">
                    <a href="discuss.pl?if=en&amp;bookid=25998" class="sprite-discuss"
                        title="Related discussion">Related discussion<div style="display: inline;"
                            ></div></a>
                </div><br class="br" />　57. <a href="book-of-changes/xun">䷸巽 - Xun</a>
                <br class="br" />　58. <a href="book-of-changes/dui">䷹兌 - Dui</a>
                <br class="br" />　59. <a href="book-of-changes/huan">䷺渙 - Huan</a>
                <br class="br" />　60. <a href="book-of-changes/jie1">䷻節 - Jie</a>
                <br class="br" />　61. <a href="book-of-changes/zhong-fu">䷼中孚 - Zhong Fu</a>
                <br class="br" />　62. <a href="book-of-changes/xiao-guo">䷽小過 - Xiao Guo</a>
                <br class="br" />　63. <a href="book-of-changes/ji-ji">䷾既濟 - Ji Ji</a>
                <br class="br" />　64. <a href="book-of-changes/wei-ji">䷿未濟 - Wei Ji</a>
            </body>
        </html>
        
    </xsl:variable>
    
</xsl:stylesheet>