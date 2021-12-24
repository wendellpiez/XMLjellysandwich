<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math pb eve"
  xmlns="http://pellucidliterature.org/VerseEngineer"
  xpath-default-namespace="http://pellucidliterature.org/VerseEngineer"
  xmlns:eve="http://pellucidliterature.org/VerseEngineer"
  version="3.0">
  
<!--  Test this XSLT by running it on itself -->
  
  <xsl:output indent="true"/>
  
  <xsl:param name="lines" select="unparsed-text-lines('example.eve')"/>
  
 <!-- <xsl:include href="https://raw.githubusercontent.com/ilyakharlamov/xslt_base64/master/base64.xsl"/>-->
 <!-- <xsl:output indent="true"/>-->
  
  <xsl:template match="/">
    <xsl:sequence select="eve:engineer-verse( unparsed-text('example.eve') )"/>
  </xsl:template>

  <!-- function call executes a pipeline  -->
  <xsl:function name="eve:engineer-verse" as="document-node()">
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
    <xsl:variable name="with-notes">
      <xsl:apply-templates select="$regrouped" mode="eve:pull-notes"/>
    </xsl:variable>
    <xsl:variable name="with-verse">
      <xsl:apply-templates select="$with-notes" mode="eve:read-line-groups"/>
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
      <!--<xsl:sequence select="$sectioned"/>-->
      <!--<xsl:sequence select="$structured"/>-->
      <!--<xsl:sequence select="$regrouped"/>-->
      <!--<xsl:sequence select="$with-notes"/>-->
      <!--<xsl:sequence select="$all-marked-up"/>-->
      <!--<xsl:sequence select="$scrubbed"/>-->
      <xsl:sequence select="$polished"/>
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
      <xsl:value-of select="replace(.,'^\s+','')"/>
    </line>
  </xsl:template>
  
  
  <!-- drop empty lines now! -->
  <xsl:template priority="5" mode="eve:split-line-groups" match="line[not(matches(.,'\S'))]"/>
    
  <!-- mode read-line-groups casts verse and prose respectively while dropping the splits -->
  
  <xsl:mode name="eve:pull-notes" on-no-match="shallow-copy"/>
  
  <xsl:template mode="eve:pull-notes" match="split[empty(child::* except *[matches(.,$section-divider)] )]"/>
  
  <xsl:template priority="5" mode="eve:pull-notes" match="div/split[1]/line[1][matches(.,$section-divider)]"/>
  
  <xsl:function name="eve:starts-note" as="xs:boolean">
    <xsl:param name="spl" as="element(eve:split)?"/>
    <xsl:sequence select="boolean( $spl/child::line[1]/matches(.,'^\[\[\i\c*\]\]') )"/>  
  </xsl:function>
  
  <xsl:template mode="eve:pull-notes" match="div">
    <div>
    <xsl:for-each-group select="split" group-starting-with="*[eve:starts-note(.)]">
      <note id=".main.">
        <xsl:variable name="identifier" select="current-group()[1][eve:starts-note(.)]/replace(.,'^\[\[(\i\c*)\]\].*$','$1')"/>
        <xsl:if test="current-group()[1]/eve:starts-note(.)">
          <xsl:attribute name="id" select="$identifier"/>
        </xsl:if>
        <xsl:apply-templates mode="#current" select="current-group()">
          <xsl:with-param tunnel="true" name="lead-line" select="current-group()[eve:starts-note(.)]/descendant::line[1]"/>
          <xsl:with-param tunnel="true" name="note-id"   select="'[[' || $identifier || ']]'"/>
        </xsl:apply-templates>
      </note>
    </xsl:for-each-group>
    </div>
  </xsl:template>

  <xsl:template mode="eve:pull-notes" match="inset">
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

  <xsl:template mode="eve:pull-notes" match="line">
    <xsl:param tunnel="true" name="lead-line" select="()"/>
    <xsl:param tunnel="true" name="attribution-line" select="()"/>
    <xsl:param tunnel="true" name="note-id"/>
    <xsl:if test="not(. is $attribution-line)">
      <xsl:where-populated>
        <line>
          <xsl:choose>
            <xsl:when test=". is $lead-line">
              
              <xsl:value-of select="substring-after(., $note-id) ! replace(., '^\s+', '')"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- marking line indents irrespective of grouping -->
              <xsl:variable name="indent" select="replace(., '\S.*$', '') => string-length()"/>
              <xsl:if test="not($indent = 0)">
                <xsl:attribute name="ind" select="$indent"/>
              </xsl:if>
              <xsl:analyze-string select="." regex="\S.*$">
                <xsl:matching-substring>
                  <xsl:value-of select="."/>
                </xsl:matching-substring>
              </xsl:analyze-string>
            </xsl:otherwise>
          </xsl:choose>
        </line>
      </xsl:where-populated>
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
  
  <xsl:template mode="eve:read-line-groups" match="note[@id='.main.']">
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
  
  <xsl:template mode="eve:render-markup" match="/with-verse">
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
      <xsl:apply-templates mode="#current"/>
    </scrubbed>
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
      <xsl:apply-templates mode="#current" select="* except note"/>
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
  
  <xsl:template mode="eve:polish" match="section/* | note | verse | inset">
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
  
</xsl:stylesheet>