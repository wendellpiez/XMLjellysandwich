<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs math pb eve functx"
  xmlns="http://pellucidliterature.org/VerseEngineer"
  xpath-default-namespace="http://pellucidliterature.org/VerseEngineer"
  xmlns:eve="http://pellucidliterature.org/VerseEngineer"
  version="3.0">
  
  <!--  Test this XSLT by running it on itself -->
  <!-- Use one of its functions as an entry point from elsewhere. -->
  
  <xsl:output indent="true"/>
    
  <xsl:param name="debug" select="unparsed-text('debug.eve')"/>
  
  <xsl:variable name="try-me">
author: bob
link: http:blha 
---

TITLE OF SECTION
----------------

T.S. Eliot
  became jolly at
the slightest hint
  of chocolate mint.

> There once was a fellow whose coding
> was subject to serious bloating[bl]:
>  he blow up his stack
>  in a service attack
> and they found him in transit, uploading.

Oh what a blow! His pneuma? started.

[[bl]] "bloating" is a technical term, referring to an egregiously wasteful use of system resources including available RAM.

[}pneuma?{] Cosmic energy expressed as breath.

[}pneuma?{] A second gloss should also be fine.

[}bloating{] what happens if doubling?

[}subject to … bloating{] what you get if you have too much lunch.

    A second paragraph only indented.

A third paragraph

  </xsl:variable>
 <!-- <xsl:include href="https://raw.githubusercontent.com/ilyakharlamov/xslt_base64/master/base64.xsl"/>-->
 <!-- <xsl:output indent="true"/>-->
  
  <xsl:variable name="gloss-regex" select="'^\[\}(.*\S.*)\{\]'"/>
  
  <xsl:template match="/">
    <!-- to debug -->
    <xsl:sequence select="eve:run-pipeline( $try-me )"/>
    
    <!-- to run -->
    <!--<xsl:sequence select="eve:engineer-verse( $try-me )"/>-->
    
  </xsl:template>

  <!-- function call executes a pipeline  -->
  <xsl:function name="eve:run-pipeline" as="document-node()">
    <xsl:param name="evetext" as="xs:string"/>
    <xsl:variable name="lines" select="$evetext => tokenize('&#xD;?&#xA;')"/>
    <xsl:variable name="sectioned">
      <xsl:call-template name="eve:see-sections">
        <xsl:with-param name="lines" select="$lines"/>  
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="structured">
      <xsl:apply-templates select="$sectioned" mode="eve:nest-insets"/>
    </xsl:variable>
    <xsl:variable name="regrouped">
      <xsl:apply-templates select="$structured" mode="eve:split-line-groups"/>
    </xsl:variable>
    <xsl:variable name="with-notes-and-glosses">
      <xsl:apply-templates select="$regrouped" mode="eve:pull-snips"/>
    </xsl:variable>
    <xsl:variable name="with-verse">
      <xsl:apply-templates select="$with-notes-and-glosses" mode="eve:read-line-groups"/>
    </xsl:variable>
    <xsl:variable name="all-marked-up">
      <xsl:apply-templates select="$with-verse" mode="eve:render-markup"/>
    </xsl:variable>
    <xsl:variable name="scrubbed">
      <xsl:apply-templates select="$all-marked-up" mode="eve:scrub"/>
    </xsl:variable>
    <xsl:variable name="polished">
      <xsl:apply-templates select="$scrubbed" mode="eve:polish"/>
    </xsl:variable>
    
    <xsl:document>
      <EVE>
        <msg>Running eve-recognizer in a debug mode</msg>
        <!--<xsl:sequence select="$sectioned"/>-->
        
        <xsl:sequence select="$sectioned"/>
        <xsl:sequence select="$structured"/>
        <xsl:sequence select="$regrouped"/>
        <xsl:sequence select="$with-notes-and-glosses"/>
        <xsl:sequence select="$all-marked-up"/>
        <xsl:sequence select="$scrubbed"/>
        <xsl:sequence select="$polished"/>
        
      </EVE>
      
    </xsl:document>
  </xsl:function>
  
  <!-- function call executes a pipeline  -->
  <xsl:function name="eve:engineer-verse" as="document-node()">
    <xsl:param name="evetext" as="xs:string"/>
    <xsl:variable name="trace" select="eve:run-pipeline($evetext)"/>
    <xsl:document>
      <xsl:sequence select="$trace/*/child::*[last()]"/>
    </xsl:document>
  </xsl:function>
  
  <!-- section divides at any line of hyphens min 3 max 80 in length-->
  <xsl:variable name="section-divider" as="xs:string">^\-{3,}\s*$</xsl:variable>
  
  <!-- XXX next - promote headers from orphan paragraph or line in previous section, when the same length as the divider. -->
  
  
  <xsl:template name="eve:see-sections">
    <xsl:param name="lines" as="xs:string*"/>
    <sectioned>
      <xsl:for-each-group select="$lines" group-starting-with=".[matches(., $section-divider)]">
        <div>
          <xsl:iterate select="current-group()">
            <line>
              <xsl:sequence select="."/>
            </line>
          </xsl:iterate>
        </div>
      </xsl:for-each-group>
    </sectioned>
  </xsl:template>
  
  <!-- nest-insets mode parses and groups lines based on leading '>' -->
  <xsl:mode name="eve:nest-insets" on-no-match="shallow-copy"/>
  
  <xsl:template mode="eve:nest-insets" match="sectioned">
    <structured>
      <xsl:apply-templates mode="#current"/>
    </structured>
  </xsl:template>
 
  <xsl:template match="div" mode="eve:nest-insets">
    <div>
      <xsl:for-each select="preceding-sibling::*[1]/self::div/line[eve:is-a-head(.)]" expand-text="true">
        <title>{ replace(.,'^\s+','') }</title>
      </xsl:for-each>
      <xsl:call-template name="eve:inset-quotes"/>
    </div>
  </xsl:template>
  
  <xsl:template name="eve:inset-quotes">
    <!--recursive template to find embedded/nested quotes -->
    <xsl:param name="us" select="child::*"/>
    <xsl:param name="matchstr" as="xs:string">^></xsl:param>
    
    <xsl:for-each-group select="$us" group-adjacent="matches(.,$matchstr)">
      <!-- $includes-more is true if there is a deeper quote to pull -->
      <xsl:variable name="includes-more" select="exists( current-group()[replace(.,$matchstr,'')][starts-with(.,'>')] )"/>
      <xsl:choose>
        <xsl:when test="current-grouping-key()">
          <inset>
            <xsl:choose>
              <xsl:when test="$includes-more">
                <xsl:call-template name="eve:inset-quotes">
                  <xsl:with-param name="us" select="current-group()"/>
                  <xsl:with-param name="matchstr" select="$matchstr || '>'"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="current-group()" mode="eve:nest-insets">
                  <xsl:with-param name="matchstr" select="$matchstr"/>
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
          </inset>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="current-group()" mode="eve:nest-insets">
            <xsl:with-param name="matchstr" select="$matchstr"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  
  <!-- line rewriter has to remove leading '>>>' string -->
  <xsl:template mode="eve:nest-insets" match="line">
    <xsl:param name="matchstr" as="xs:string" select="''"/>
    <xsl:variable name="mark" select="replace($matchstr,'^\^>','')"/>
    <line>
      <!--<xsl:value-of select="$mark"/>-->
      <xsl:value-of select="substring-after(.,$mark)"/>
    </line>
  </xsl:template>
  
  <!--dropping lines that are taken to be heading the next section - -->
  <xsl:template mode="eve:nest-insets" priority="5" match="line[eve:is-a-head(.)]"/>
  
  <xsl:function name="eve:is-a-head" as="xs:boolean">
    <xsl:param name="who" as="element(line)"/>
    <xsl:variable name="here" select="$who/parent::div"/>
    <xsl:variable name="next-div" select="$here/following-sibling::*[1]/self::div"/>
    <xsl:variable name="dashed" select="replace(string($who),'.','-')"/>
    <xsl:sequence select="not(starts-with(string($who),'>'))
      and ($who is $here/child::*[last()])
      and matches($who/preceding-sibling::*[1]/self::line,'^\s*$')
      and starts-with($next-div/line[1],$dashed)"/>
  </xsl:function>
  
<!-- group-lines mode produces line groups based on proximity of black or whitespace-only lines -->
  
  <xsl:function name="eve:ws-only" as="xs:boolean">
    <xsl:param name="n" as="node()"/>
    <xsl:sequence select="not( matches(string($n),'\S') )"/>
  </xsl:function>
  
  <xsl:mode name="eve:split-line-groups" on-no-match="shallow-copy"/>
  
  <xsl:template mode="eve:split-line-groups" match="structured">
    <regrouped>
      <xsl:apply-templates mode="#current"/>
    </regrouped>
  </xsl:template>
  
  <xsl:template mode="eve:split-line-groups" match="div | inset">
    <!-- splitting div or inset contents around blank lines - for capturing verse sequences -->
    <xsl:copy>
      <xsl:for-each-group select="*" group-adjacent="eve:ws-only(.)">
        <split>
          <xsl:apply-templates select="current-group()" mode="#current"/>
        </split>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
  <!--<xsl:template mode="regroup" match="div/line[1][starts-with(.,'-\-\-')]" expand-text="true">
    <xsl:for-each select="replace(.,'\-\\-\\-+','')[matches(.,'\S')]">
      <line>{ . }</line>
    </xsl:for-each>
  </xsl:template>-->
  
  <xsl:template mode="eve:split-line-groups" match="inset/line">
    <line>
      <xsl:variable name="indent" select="replace(., '\S.*$', '') => string-length()"/>
      <xsl:if test="$indent gt 1">
        <xsl:attribute name="ind" select="$indent - 1"/>
      </xsl:if>
      <xsl:value-of select="replace(.,'^\s+','')"/>
    </line>
  </xsl:template>
  
  
  <!-- drop empty lines now! -->
  <xsl:template priority="5" mode="eve:split-line-groups" match="line[not(matches(.,'\S'))]"/>
    
  <!-- mode read-line-groups casts verse and prose respectively while dropping the splits -->
  
  <xsl:mode name="eve:pull-snips" on-no-match="shallow-copy"/>
  
  <xsl:template mode="eve:pull-snips" match="regrouped">
    <noted-and-glossed>
      <xsl:apply-templates mode="#current"/>
    </noted-and-glossed>
  </xsl:template>
  
  <xsl:template mode="eve:pull-snips" match="split[empty(child::* except *[matches(.,$section-divider)] )]"/>
  
  <xsl:template priority="5" mode="eve:pull-snips" match="div/split[1]/line[1][matches(.,$section-divider)]"/>
  
  <xsl:function name="eve:starts-note" as="xs:boolean">
    <xsl:param name="spl" as="element(eve:split)?"/>
    <xsl:sequence select="boolean( $spl/child::line[1]/matches(.,'^\[\[\i\c*\]\]') )"/>  
  </xsl:function>
  
  <xsl:function name="eve:starts-gloss" as="xs:boolean">
    <xsl:param name="spl" as="element(eve:split)?"/>
    <xsl:sequence select="boolean( $spl/child::line[1]/matches(.,$gloss-regex) )"/>  
  </xsl:function>
  
  <xsl:template mode="eve:make-a-note" match="*">
    <main>
      <xsl:apply-templates mode="eve:pull-snips" select="current-group()"/>
    </main>
  </xsl:template>
  
  <xsl:template mode="eve:make-a-note" priority="100" match="*[eve:starts-note(.)]">
    <xsl:variable name="identifier" select="replace(.,'^\[\[(\i\c*)\]\].*$','$1')"/>
    <note id="{ $identifier }">
      <xsl:apply-templates mode="eve:pull-snips" select="current-group()">
        <xsl:with-param tunnel="true" name="lead-line" select="descendant::line[1]"/>
        <xsl:with-param tunnel="true" name="note-id"   select="'[[' || $identifier || ']]'"/>
      </xsl:apply-templates>
    </note>
  </xsl:template>
  
  <xsl:template mode="eve:make-a-note" priority="100" match="*[eve:starts-gloss(.)]">
    <xsl:variable name="term" select="replace(.,($gloss-regex || '.*$'),'$1')"/>
    <gloss text="{ $term }" regex="{ $term => eve:write-as-regex() }">
      <xsl:apply-templates mode="eve:pull-snips" select="current-group()">
        <xsl:with-param tunnel="true" name="lead-line" select="descendant::line[1]"/>
        <xsl:with-param tunnel="true" name="gloss-term" select="$term"/>
      </xsl:apply-templates>
    </gloss>
  </xsl:template>
  
  <xsl:template mode="eve:pull-snips" match="div">
    <div>
    <xsl:for-each-group select="split" group-starting-with="*[eve:starts-note(.) or eve:starts-gloss(.)]">
      <xsl:apply-templates select="current-group()[1]" mode="eve:make-a-note"/>
    </xsl:for-each-group>
    </div>
  </xsl:template>

  <xsl:template mode="eve:pull-snips" match="inset">
    <xsl:variable name="attributing-signal" select="'^(&#x2014;|\-\-)\s'"/>
    <xsl:variable name="attribution-line" select="descendant::line[last()][matches(.,$attributing-signal)]"/>
    <xsl:copy>
      <xsl:apply-templates mode="#current">
        <xsl:with-param tunnel="true" name="attribution-line" select="$attribution-line"/>
      </xsl:apply-templates>
      <xsl:for-each select="$attribution-line">
        <attrib>
          <xsl:value-of select="replace(.,$attributing-signal,'')"/>
        </attrib>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="eve:pull-snips" match="line">
    <xsl:param tunnel="true" name="lead-line" select="()"/>
    <xsl:param tunnel="true" name="attribution-line" select="()"/>
    <xsl:param tunnel="true" name="note-id"/>
    <xsl:param tunnel="true" name="gloss-term" select="false()"/>
    <xsl:if test="not(. is $attribution-line)">
      <xsl:where-populated>
        <line>
          <xsl:copy-of select="@*"/>
          <xsl:choose>
            <xsl:when test=". is $lead-line and boolean($gloss-term)">
              <xsl:variable name="leader" select="'[}' || $gloss-term || '{]'"/>
              <xsl:variable name="line" select="substring-after(., $leader)"/>
              <xsl:value-of select="replace($line, '^\s+', '')"/>
            </xsl:when>
            <xsl:when test=". is $lead-line">
              <xsl:value-of select="substring-after(., $note-id) ! replace(., '^\s+', '')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="mark-indent-attribute"/>
              <!-- marking line indents irrespective of grouping -->
              <xsl:value-of select="replace(.,'^\s+','')"/>
              
            </xsl:otherwise>
          </xsl:choose>
        </line>
      </xsl:where-populated>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="mark-indent-attribute">
    <xsl:variable name="indent" select="replace(., '\S.*$', '') => string-length()"/>
    <xsl:if test="not($indent = 0)">
      <xsl:attribute name="ind" select="$indent"/>
    </xsl:if>
  </xsl:template>
  
  <!--
    pull-notes must also: rewrite text leading with note indicators
                          rearrange <cite> lines inside inset/descendant::line[last()] -->
  
  <!--mostly, splits disappear -->
  <!--<xsl:template mode="eve:read-line-groups" match="split">
    <xsl:apply-templates mode="#current"/>
  </xsl:template> -->
  
  <!-- mode read-line-groups casts verse and prose respectively while dropping the splits -->
  
  <xsl:mode name="eve:read-line-groups" on-no-match="shallow-copy"/>
  
  <xsl:template mode="eve:read-line-groups" match="regrouped">
    <with-verse>
      <xsl:apply-templates mode="#current"/>
    </with-verse>
  </xsl:template>
  
  <xsl:template mode="eve:read-line-groups" match="main">
      <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <!-- splits that wrap more than a single group become 'verse' wrappers -->
  <xsl:template mode="eve:read-line-groups" match="split[empty(child::* except line) and count(line) gt 1]">
    <verse>
      <xsl:apply-templates mode="#current"/>
    </verse>
  </xsl:template>
  
  <!--mostly, splits disappear -->
  <xsl:template mode="eve:read-line-groups" match="split">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <!-- solitary lines with no indents become 'paragraphs' -->
  <xsl:template mode="eve:read-line-groups" match="split[count(child::*)=1]/line[empty(@ind)]">
    <p>
      <xsl:apply-templates mode="#current"/>
    </p>
  </xsl:template>
  
  <xsl:mode name="eve:render-markup" on-no-match="shallow-copy"/>
  
  <xsl:template mode="eve:render-markup" match="/with-notes | /noted-and-glossed">
    <all-marked-up>
      <xsl:apply-templates mode="#current">
        <!-- names given to notes are passed down the tree -->
        <xsl:with-param tunnel="true" name="note-names" select=".//note/@id => distinct-values()"/>
      </xsl:apply-templates>
    </all-marked-up>
  </xsl:template>
  
  <xsl:template match="line | p | attrib" mode="eve:render-markup">
    <xsl:param name="note-names" select="()" tunnel="true" as="xs:string*"/>
    <xsl:variable name="note-regex" expand-text="true">\[({ string-join($note-names,'|') })\]</xsl:variable>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
    <xsl:analyze-string select="string(.)" regex="{ $note-regex }">
      <xsl:matching-substring>
        <fnr ref="{regex-group(1)}"/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:variable name="marked-up" select=". => pb:escape-string() => pb:write-bold() => pb:write-italic()"/>
        <xsl:try select="parse-xml-fragment( $marked-up )">
          <xsl:catch>
            <xsl:sequence select="."/>
          </xsl:catch>
        </xsl:try>        
      </xsl:non-matching-substring>
    </xsl:analyze-string>
    </xsl:copy>
  </xsl:template>
  
<!-- Before inferring markup from sequences of '*', we escape '\\' and then '\*' to hide them
     from the 'star parsing' that renders out bold and italic -->
  <xsl:function name="pb:escape-string">
    <xsl:param name="s" as="xs:string"/>
    <!-- replace any escaped bracket reverse solidus '\[' with character reference for (unescaped) left square bracket
         then reverse solidus asterisk '\*' with character reference for (unescaped) asterisk
         to express '\[' use '\\[' etc. -->
    <!-- by emitting a literal character reference we get the character back for free when we parse as XML -->
    <xsl:sequence select="$s => replace('\\\[','&amp;#91;') => replace('\\\*','&amp;#42;')"/>
  </xsl:function>
  
  <xsl:function name="pb:write-bold">
    <xsl:param name="s" as="xs:string"/>
    <xsl:value-of>
      <!--note that any * characters represented escaped will not match -->
      <xsl:analyze-string select="$s" regex="\*\*([^\*]*)\*\*">
        <xsl:matching-substring>
          <xsl:text>&lt;b xmlns="http://pellucidliterature.org/VerseEngineer"></xsl:text>
          <xsl:value-of select="regex-group(1)"/>
          <xsl:text>&lt;/b></xsl:text>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="."/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:value-of>
  </xsl:function>
  
  <xsl:function name="pb:write-italic">
    <xsl:param name="s" as="xs:string"/>
    <xsl:value-of>
    <xsl:analyze-string select="$s" regex="\*([^\*]*)\*">
      <xsl:matching-substring>
        <xsl:text>&lt;i xmlns="http://pellucidliterature.org/VerseEngineer"></xsl:text>
        <xsl:value-of select="regex-group(1)"/>
        <xsl:text>&lt;/i></xsl:text>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
    </xsl:value-of>
  </xsl:function>
  
  
  <!--inline conversion - map inline markdown into XML -->
<!--  \* becomes &asterisk; \[ becomes &openbracket;
     **[^*]+** becomes <b>...</b>
     *[^*]+* becomes <i>...</i>
     \[\i\c*\] becomes <fn ref=.../>
     parse and return if it parses
  -->

  <xsl:mode name="eve:scrub" on-no-match="shallow-copy"/>
  
  <xsl:template mode="eve:scrub" match="/all-marked-up">
    <scrubbed>
      <xsl:apply-templates mode="#current">
        <xsl:with-param name="glosses" tunnel="true" select="descendant::gloss"/>
      </xsl:apply-templates>
    </scrubbed>
  </xsl:template>
 
 <xsl:function name="eve:write-as-regex" as="xs:string">
   <xsl:param name="str" as="xs:string"/>
   <xsl:sequence select="$str => functx:escape-for-regex() => replace('\s+','\\s+') => replace('…','.+')"/>
 </xsl:function>
  
  <xsl:template mode="eve:scrub" match="text()" expand-text="true">
    <xsl:param name="glosses" as="element(gloss)*" tunnel="true"/>
    <xsl:choose>
      <xsl:when test="empty($glosses)">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="index-regex" expand-text="true">({ distinct-values($glosses/@regex) => string-join('|') })</xsl:variable>
        <!--<xsl:message expand-text="true">looking for { $index-regex }</xsl:message>-->
        <xsl:analyze-string select="." regex="{ $index-regex }">
          <xsl:matching-substring>
            <!--<xsl:message>matched regex { $index-regex }</xsl:message>-->
            <xsl:variable name="me" select="."/>
            <!--<xsl:message>$me is { $me }</xsl:message>-->
            
            <xsl:variable name="matches" select="$glosses[matches($me, @regex)]"/>
            <!--<xsl:message>$matches has { count($matches) }</xsl:message>-->
            <xsl:variable name="max-length" select="$matches/string-length(@text) => max()"/>
            <xsl:variable name="first" select="$matches[string-length(@text) = $max-length][1]"/>

            <gl t="{ $first/@text }">
              <xsl:value-of select="."/>
            </gl>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="."/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:otherwise>
    </xsl:choose>    
    
  </xsl:template>

  <xsl:function name="eve:is-eve-head" as="xs:boolean">
    <xsl:param name="d" as="element(eve:div)"/>
    <xsl:sequence select="($d is ($d/../*[1])) and (every $c in ($d//line | $d//p) satisfies matches($c,'^\i\c*:'))"/>
  </xsl:function>

  <xsl:template mode="eve:scrub" match="div[eve:is-eve-head(.)]">
    <head>
      <xsl:apply-templates mode="#current"/>
    </head>
  </xsl:template>
  
  <xsl:template mode="eve:scrub" match="div">
    <section>
      <xsl:apply-templates mode="#current" select="* except (note | gloss)"/>
      <xsl:where-populated>
        <glossary>
          <xsl:apply-templates mode="#current" select="gloss"/>
        </glossary>
      </xsl:where-populated>
      <xsl:where-populated>
        <notes>
          <xsl:apply-templates mode="#current" select="note"/>
        </notes>
      </xsl:where-populated>
    </section>
  </xsl:template>
  
  <xsl:template mode="eve:scrub" match="div[eve:is-eve-head(.)]/verse">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="eve:scrub" match="@regex"/>
  
  <xsl:template mode="eve:scrub" match="div[eve:is-eve-head(.)]//line | div[eve:is-eve-head(.)]//p" expand-text="true">
    <xsl:variable name="gi" select="replace(.,'[\C^:].*','')"/>
    <xsl:analyze-string select="." regex="[\C^:]:\s*">
      <xsl:non-matching-substring>
        <xsl:element name="{ $gi }">
          <xsl:value-of select="substring-after(.,($gi || ':')) ! normalize-space(.)"/>
        </xsl:element>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>


  <xsl:mode name="eve:polish" on-no-match="shallow-copy"/>
  
  <xsl:template mode="eve:polish" match="scrubbed">
    <xsl:text>&#xA;</xsl:text>
    <EVE>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>&#xA;</xsl:text>
    </EVE>
  </xsl:template>
  
  <xsl:template mode="eve:polish" match="head | section">
    <xsl:text>&#xA;  </xsl:text>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="#current" select="*"/>
      <xsl:text>&#xA;  </xsl:text>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="eve:polish" match="section/* | note | gloss | verse | inset">
    <xsl:call-template name="drop-and-indent"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="#current"/>
      <xsl:call-template name="drop-and-indent"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template priority="5" mode="eve:polish" match="inset[empty(preceding-sibling::* except preceding-sibling::inset)]">
    <xsl:call-template name="drop-and-indent"/>
    <epigraph>
      <xsl:apply-templates mode="#current"/>
      <xsl:call-template name="drop-and-indent"/>
    </epigraph>
  </xsl:template>
  
  <xsl:template mode="eve:polish" match="p | line | section/title | head/* | attrib" priority="2">
    <xsl:call-template name="drop-and-indent"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="drop-and-indent">
    <xsl:text>&#xA;</xsl:text>
    <xsl:for-each select="ancestor::*">
      <xsl:text>  </xsl:text>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Borrowed from XSpec who borrowed from functx -->
  <xsl:function name="functx:escape-for-regex" as="xs:string">
    <xsl:param name="arg" as="xs:string?"/>
    
    <xsl:sequence
      select=" 
      replace($arg,
      '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
      "
    />
  </xsl:function>
</xsl:stylesheet>