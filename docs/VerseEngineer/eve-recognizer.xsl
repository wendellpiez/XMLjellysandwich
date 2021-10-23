<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math pb"
  xmlns="http://pellucidliterature.org/VerseEngineer"
  xpath-default-namespace="http://pellucidliterature.org/VerseEngineer"
  version="3.0">
  
<!--  Test this XSLT by running it on itself -->
  
  <xsl:param name="lines" select="unparsed-text-lines('example.eve')"/>
  
 <!-- <xsl:include href="https://raw.githubusercontent.com/ilyakharlamov/xslt_base64/master/base64.xsl"/>-->
 <!-- <xsl:output indent="true"/>-->
  
  <xsl:template match="/">
    <!--<xsl:call-template name="extract">
      <xsl:with-param name="lines" select="$lines"/>
    </xsl:call-template>
    <xsl:sequence select="$structured"/>
    <xsl:sequence select="$cleaned-up"/>
    <xsl:sequence select="$rendered"/>
    <xsl:sequence select="$scrubbed"/>-->
    <!--<xsl:sequence select="$EVE-xml"/>-->
    <xsl:sequence select="pb:engineer-verse($lines => string-join('&#xA;'))"/>
    <!--<xsl:call-template name="b64:encode">
      <xsl:with-param name="asciiString" select="$strxml"/>
    </xsl:call-template>-->
  </xsl:template>

<!-- function call executes the same pipeline as calling from the top
     (for debugging) -->
  <xsl:function name="pb:engineer-verse" as="document-node()">
    <xsl:param name="evetext" as="xs:string"/>
    <xsl:variable name="lines" select="$evetext => tokenize('&#xA;')"/>
    <xsl:variable name="extracted">
      <xsl:call-template name="extract">
        <xsl:with-param name="lines" select="$lines"/>  
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="structured">
      <xsl:apply-templates select="$extracted" mode="structure"/>
    </xsl:variable>
    <xsl:variable name="cleaned-up">    
      <xsl:apply-templates select="$structured" mode="cleanup"/>
    </xsl:variable>
    <xsl:variable name="rendered">    
      <xsl:apply-templates select="$cleaned-up" mode="render"/>
    </xsl:variable>
    <xsl:variable name="scrubbed">    
      <xsl:apply-templates select="$rendered" mode="scrub"/>
    </xsl:variable>
    <xsl:variable name="EVE-xml">    
      <xsl:apply-templates select="$scrubbed" mode="polish"/>
    </xsl:variable>
    <xsl:sequence select="$EVE-xml"/>
  </xsl:function>

  <xsl:variable name="EVE-xml">    
    <xsl:apply-templates select="$scrubbed" mode="polish"/>
  </xsl:variable>
  
  <xsl:variable name="scrubbed">    
    <xsl:apply-templates select="$rendered" mode="scrub"/>
  </xsl:variable>
  
  <xsl:variable name="rendered">    
    <xsl:apply-templates select="$cleaned-up" mode="render"/>
  </xsl:variable>
  
  <xsl:variable name="cleaned-up">    
    <xsl:apply-templates select="$structured" mode="cleanup"/>
  </xsl:variable>
  
  <xsl:variable name="structured">
    <xsl:variable name="extracted">
      <xsl:call-template name="extract">
        <xsl:with-param name="lines" select="$lines"/>  
      </xsl:call-template>
    </xsl:variable>
    <xsl:apply-templates select="$extracted" mode="structure"/>
  </xsl:variable>
  
  <xsl:template name="extract">
    <xsl:param name="lines" as="xs:string*"/>
    <extracted>
      <xsl:for-each-group select="$lines" group-ending-with=".[matches(., '^\-\-\-+')]">
        <xsl:choose>
          <!-- skip groups with only hyphen runs  -->
          <xsl:when test="empty(current-group()[not(matches(., '^\-\-\-+$'))])"/>
          <!-- the last group is treated as text -->
          <xsl:when test="position() eq last()">
            <!--we have text and notes
            text is everything up to the first non-prose or non-verse
            notes is everything else
              they require 'folding' (each note including non-note siblings up to the next note-->
            <text>
              <xsl:for-each-group select="current-group()"
                group-starting-with=".[matches(., '^\[\[\i\c*\]\]')]">
                <xsl:variable name="gis" as="xs:string*">
                  <xsl:analyze-string
                    select="(current-group()[1][matches(., '^\[\[\i\c*\]\]')], '[[verse]]')[1]"
                    regex="\i\c*">
                    <xsl:matching-substring>
                      <xsl:value-of select="."/>
                    </xsl:matching-substring>
                  </xsl:analyze-string>
                </xsl:variable>
                <xsl:element name="{$gis[1]}" namespace="http://pellucidliterature.org/VerseEngineer">
                  <xsl:call-template name="make-lines"/>
                </xsl:element>
              </xsl:for-each-group>
            </text>
          </xsl:when>
          <xsl:otherwise>
            <!-- anything but all-hyphen-runs and the last group will be treated as a header -->
            <head>
              <xsl:call-template name="make-lines"/>
            </head>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </extracted>
  </xsl:template>
  
  <xsl:template name="make-lines">
    <xsl:for-each select="current-group()">
      <line>
        <xsl:sequence select="."/>
      </line>
    </xsl:for-each>
  </xsl:template>
    
  <xsl:mode name="structure" on-no-match="shallow-copy"/>
  
  <xsl:template mode="structure" match="extracted">
    <structured>
      <xsl:apply-templates mode="#current"/>
    </structured>
  </xsl:template>
  
  <xsl:template mode="structure" match="head">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template mode="structure" priority="101" match="verse">
    <verse>
    <xsl:for-each-group select="line" group-ending-with="line[not(matches(.,'\S'))]">
        <xsl:where-populated>
          <group>
            <xsl:sequence select="current-group()[matches(., '\S') and not(. = '[[verse]]')]"/>
          </group>
        </xsl:where-populated>
    </xsl:for-each-group>
    </verse>
  </xsl:template>
  
  <xsl:template mode="structure" match="text/*">
    <xsl:copy>
      <xsl:for-each-group select="line" group-ending-with="line[not(matches(.,'\S'))]">
        <xsl:where-populated>
          <p>
            <xsl:value-of select="current-group()[matches(.,'\S')]"/>
          </p>
        </xsl:where-populated>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
  <xsl:mode name="cleanup" on-no-match="shallow-copy"/>
  
  <xsl:template mode="cleanup" match="structured">
    <cleaned-up>
      <xsl:apply-templates mode="#current"/>
    </cleaned-up>
  </xsl:template>
  
  <xsl:template mode="cleanup" match="verse/group[1][empty(following-sibling::group)]">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
<!-- cleans up '[[wap1]]' paragraph from new <wap1> section -->
  <xsl:template match="p" mode="cleanup">
    <xsl:variable name="signal" expand-text="true">^\[\[{ local-name(..) }\]\]\s*</xsl:variable>
    <xsl:where-populated>
      <p>
        <xsl:analyze-string select="." regex="{$signal}">
          <xsl:non-matching-substring>
            <xsl:value-of select="."/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </p>
    </xsl:where-populated>
  </xsl:template>
  
  <xsl:template match="verse//line" mode="cleanup">
    <!-- tabs and spaces are each counted as one -->
    <xsl:variable name="indent" select="replace(.,'\S.*$','') => string-length()"/>
     <line>
       <xsl:if test="not($indent=0)">
         <xsl:attribute name="ind" select="$indent"/>
       </xsl:if>
        <xsl:analyze-string select="." regex="\S.*$">
          <xsl:matching-substring>
            <xsl:value-of select="."/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </line>
  </xsl:template>
  
  <xsl:mode name="render" on-no-match="shallow-copy"/>
  
  <xsl:template mode="render" match="cleaned-up">
    <rendered>
      <xsl:apply-templates mode="#current">
        <!-- names given to notes are passed down the tree -->
        <xsl:with-param name="note-names" tunnel="true" select="/*/text/(* except (verse|prose|note))/local-name() => distinct-values()"/>
      </xsl:apply-templates>
    </rendered>
  </xsl:template>
  
  <xsl:template match="text/verse | text/prose | text/note" mode="render">
    <xsl:copy>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="text/*" priority="0.4" mode="render">
    <note id="{local-name()}">
      <xsl:apply-templates mode="#current"/>
    </note>
  </xsl:template>

  <xsl:template match="line | p" mode="render">
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
    <xsl:sequence select="$s => replace('\\\[','&amp;91;') => replace('\\\*','&amp;42;')"/>
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

  <xsl:mode name="scrub" on-no-match="shallow-copy"/>
  
  <xsl:key name="element-for-note" match="text/*[empty(self::note)]" use="generate-id(preceding-sibling::note[1])"/>
  
  
  <xsl:template mode="scrub" match="rendered">
    <scrubbed>
      <xsl:apply-templates mode="#current"/>
    </scrubbed>
  </xsl:template>
  
  <xsl:template mode="scrub" match="head/line[starts-with(.,'author:')]" expand-text="true">
    <author>{ substring-after(.,'author:') => normalize-space() }</author>
  </xsl:template>
  
  <xsl:template mode="scrub" match="head/line[starts-with(.,'date:')]" expand-text="true">
    <date>{ substring-after(.,'date:') => normalize-space() }</date>
  </xsl:template>
  
  <xsl:template mode="scrub" match="head/line[starts-with(.,'title:')]" expand-text="true">
    <title>{ substring-after(.,'title:') => normalize-space() }</title>
  </xsl:template>
  
  <!-- drop a line of hyphens only -->
  <xsl:template mode="scrub" match="head/line[matches(.,'^\-{3,}$')]" />
    
  <xsl:template mode="scrub" match="text">
    <text>
      <!-- two selections so no extra mode is needed -->
      <xsl:apply-templates mode="#current" select="child::*[empty(self::note[exists(@id)])][empty(preceding-sibling::note[exists(@id)])]"/>
    </text>
    <xsl:where-populated>
    <notes>
      <xsl:apply-templates mode="#current" select="note[exists(@id)]"/>
    </notes>
    </xsl:where-populated>
  </xsl:template>
  
  <xsl:template mode="scrub" match="note">
    <note>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="#current"/>
      <xsl:apply-templates mode="#current" select="key('element-for-note',generate-id())"/>
    </note>
  </xsl:template>
  
  <xsl:template mode="scrub" match="prose">
      <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:mode name="polish" on-no-match="shallow-copy"/>
  
  <xsl:template mode="polish" match="scrubbed">
    <EVE>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>&#xA;</xsl:text>
    </EVE>
  </xsl:template>
  
  <xsl:template mode="polish" match="head">
    <xsl:text>&#xA;  </xsl:text>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="#current" select="title, author, date"/>
      <xsl:text>&#xA;  </xsl:text>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="polish" match="text | notes">
    <xsl:text>&#xA;  </xsl:text>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>&#xA;  </xsl:text>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="polish" match="text/* | notes/* | group | verse">
    <xsl:text>&#xA;</xsl:text>
    <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>&#xA;</xsl:text>
      <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="polish" match="p | line | head/*" priority="2">
    <xsl:text>&#xA;</xsl:text>
    <xsl:for-each select="ancestor::*"><xsl:text>  </xsl:text></xsl:for-each>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  
</xsl:stylesheet>