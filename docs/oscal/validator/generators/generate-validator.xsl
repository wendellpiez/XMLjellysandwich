<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:XSLT="http://www.w3.org/1999/XSL/Transform/alias"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
  xmlns="http://www.w3.org/1999/xhtml"
  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
  version="3.0">
  
  <xsl:output indent="yes"/>
  
  
  <!--
    still to do
  
    x choice
    x order
    x recursion e.g. part//part ?
 
 group-as/@in-xml=WITH_WRAPPER
   AFFECTS
     x required element check w/in parent assembly
     o order check 'test-occurrence' - move to parent
       x off child
       x on parent
     x match pattern for inline reference
     x match (grouping) parent in 'test' mode (to silence)
     x (not) cardinality check
 
    TEST
    o aliasing e.g. assessment-parts (context?) - expand matches to all occurrences
      not only refs but parent's refs to one degree (parents only at top level)
    o @in-xml=unwrapped (on markup-multine)
    o @in-xml=with-wrapper (grouped)
    o markup-line
    o markup-multiline (element content) especially unwrapped
      o examine for 'prose' element
  
  -->
  
  <xsl:namespace-alias stylesheet-prefix="XSLT" result-prefix="xsl"/>
  
  <xsl:template match="/*">
    <XSLT:transform  version="3.0" xpath-default-namespace="{ /METASCHEMA/namespace }" exclude-result-prefixes="#all">
      <XSLT:mode name="test" on-no-match="shallow-skip"/>
      
      <xsl:comment expand-text="true"> Generated { current-dateTime() } </xsl:comment>
      
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head"> Root </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates select="define-assembly[exists(root-name)]" mode="require-of"/>
      
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head"> Occurrences - templates in mode 'test' </xsl:with-param>
      </xsl:call-template>
      <!-- assembly references -->
      <xsl:apply-templates select="//assembly" mode="require-of"/>
      <!-- inline assembly definitions (i.e. references to themselves) -->
      <xsl:apply-templates select="//model//define-assembly" mode="require-of"/>
      <!-- field references -->
      <xsl:apply-templates select="//field" mode="require-of"/>
      <!-- inline field definitions (i.e. references to themselves) -->
      <xsl:apply-templates select="//model//define-field" mode="require-of"/>
      <!-- flag references -->
      <xsl:apply-templates select="//flag" mode="require-of"/>
      <!-- inline flag definitions (i.e. references to themselves) -->
      <xsl:apply-templates select="/*/define-assembly//define-flag | /*/define-field//define-flag" mode="require-of"/>
      
      <!-- We provide fallbacks for known elements matched out of context, because we cannot reliably match such elements to their definitions. -->
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head"> Fallbacks for occurrences of known elements and attributes, except out of context </xsl:with-param>
      </xsl:call-template>
      <xsl:variable name="known-elements"   select="(/*/*/root-name/parent::define-assembly | //model//define-assembly | //model//define-field | //assembly | //field)[not(@in-xml='UNWRAPPED')]/pb:use-name(.) => distinct-values()" />
      <XSLT:template mode="test" match="{ string-join($known-elements,' | ') }">
        <XSLT:call-template name="notice">
          <XSLT:with-param name="cat">context</XSLT:with-param>
          <XSLT:with-param name="msg" expand-text="true"><code>{ name() }</code> is not expected here.</XSLT:with-param>
        </XSLT:call-template>
      </XSLT:template>
      <xsl:variable name="known-attributes" select="((//flag | //define-assembly/define-flag | define-field/define-flag)/pb:use-name(.) => distinct-values()) ! ('@' || .)" />
      <XSLT:template mode="test" match="{ string-join($known-attributes,' | ') }">
        <XSLT:call-template name="notice">
          <XSLT:with-param name="cat">context</XSLT:with-param>
          <XSLT:with-param name="msg" expand-text="true"><code>@{ name() }</code> is not expected here.</XSLT:with-param>
        </XSLT:call-template>
      </XSLT:template>
      
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head"> Definitions - a named template for each </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates select="//define-assembly | //define-field | //define-flag" mode="require-for"/>
      
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head"> Datatypes - a named template for each occurring </xsl:with-param>
      </xsl:call-template>
      <xsl:for-each-group select="//@as-type[not(.= ('markup-line','markup-multiline') )]/.." group-by="string(@as-type)" expand-text="true">
        <XSLT:template name="check-{ current-grouping-key() }-datatype">
          <!--<XSLT:param tunnel="true" name="matching" as="xs:string" required="true"/>-->
          <XSLT:call-template name="notice">
            <XSLT:with-param name="cat">datatype</XSLT:with-param>
            <XSLT:with-param name="condition"
              select="not( pb:datatype-validate(.,'{ current-grouping-key() }') )"/>
            <XSLT:with-param name="msg" expand-text="true"><code>{{ name() }}</code> does not conform to <em>{ current-grouping-key() }</em> datatype.</XSLT:with-param>
          </XSLT:call-template>
        </XSLT:template>
      </xsl:for-each-group>


      <!-- Finally we have to generate these instead of keeping them in the static host file,
      so they will match namespaces. -->
      <XSLT:template match="ul | ol" mode="validate-markup-multiline">
        <XSLT:apply-templates select="li" mode="validate-markup-multiline"/>
        <XSLT:for-each select="* except li">
          <!-- 'notice-multiline' is in the calling XSLT -->
          <XSLT:call-template name="notice-multiline"/>
        </XSLT:for-each>
      </XSLT:template>
      
      <XSLT:template match="table" mode="validate-markup-multiline">
        <XSLT:apply-templates select="tr" mode="validate-markup-multiline"/>
        <XSLT:for-each select="* except tr">
          <XSLT:call-template name="notice-multiline"/>
        </XSLT:for-each>
      </XSLT:template>
      
      <XSLT:template match="tr" mode="validate-markup-multiline">
        <XSLT:apply-templates select="td" mode="validate-markup-multiline"/>
        <XSLT:for-each select="* except td">
          <XSLT:call-template name="notice-multiline"/>
        </XSLT:for-each>
      </XSLT:template>
      
      <XSLT:template match="p | li | h1 | h2 | h3 | h4 | h5 | h6" mode="validate-markup-multiline">
        <XSLT:apply-templates mode="validate-markup-multiline" select="@*"/>
        <XSLT:apply-templates mode="validate-markup-line"/>
      </XSLT:template>
      
      <XSLT:template match="em | i | strong | b | u | q | code | img | insert" mode="validate-markup-line">
        <XSLT:apply-templates mode="validate-markup-line" select="@*"/>
        <XSLT:apply-templates mode="validate-markup-line"/>
      </XSLT:template>
      
      <XSLT:template match="a/@href | img/@src | img/@title | insert/@type | insert/@id-ref" mode="validate-markup-line"/>
      
      <XSLT:template match="p/text() | li/text() | h1/text() | h2/text() | h3/text() | h4/text() | h5/text() | h6/text()"   mode="test"/>
      <XSLT:template match="em/text() | i/text() | strong/text() | b/text() | u/text() | q/text() | code/text() | a/text()" mode="test"/>
      
    </XSLT:transform>
  </xsl:template>
  
  <xsl:template match="/*/*" priority="0.25"/>
  
<!-- Assuming composed Metaschema input with disambiguated keys -->
  <xsl:key name="assembly-definitions" match="/METASCHEMA/define-assembly" use="@_key-name"/>
  <xsl:key name="field-definitions"    match="/METASCHEMA/define-field"    use="@_key-name"/>
  <xsl:key name="flag-definitions"     match="/METASCHEMA/define-flag"     use="@_key-name"/>
  
  <xsl:key name="flag-references"     match="flag"     use="@_key-ref"/>
  <xsl:key name="field-references"    match="field"    use="@_key-ref"/>
  <xsl:key name="assembly-references" match="assembly" use="@_key-ref"/>
  
  <xsl:key name="using-name" match="flag | field | assembly | define-flag | define-field | define-assembly" use="pb:use-name(.)"/>
  
  <!-- 'require-of' mode encapsulates tests on any occurrence of any node, as represented by its reference or inline definition -->
  
  <xsl:template mode="require-of" match="define-assembly[exists(root-name)]" expand-text="true">
    <xsl:variable name="matching" select="pb:use-name(.)"/>
    <XSLT:template match="/{ $matching }" mode="test">
      <!-- nothing to test for cardinality or order -->

      <XSLT:apply-templates select="@*" mode="test"/>
      <XSLT:call-template name="require-for-{ pb:definition-name(.) }-assembly"/>
      
    </XSLT:template>
  </xsl:template>
  
<!-- nothing required for unwrapped fields... -->
  <xsl:template mode="require-of" priority="10"
    match="field[@in-xml='UNWRAPPED'] | model//define-field[@in-xml='UNWRAPPED']"/>
    
  
  <xsl:template mode="require-of" expand-text="true"
    match="assembly | model//define-assembly | field | model//define-field">
    <xsl:variable name="metaschema-type" select="if (ends-with(local-name(),'assembly')) then 'assembly' else 'field'"/>
    <xsl:variable name="using-name" select="pb:use-name(.)"/>
    
    <!--<xsl:variable name="match-path" select="(ancestor::define-assembly[exists(ancestor::model)] | .)/pb:match-name(.) => string-join('/')"/>-->
    <xsl:variable name="match-path" select="pb:match-name-with-parent(.)"/>
    
    <!-- when in-xml='WITH_WRAPPER' we need to extend to pb:path-step not just pb:use-name   -->
    <xsl:for-each select="self::field | self::define-field">
      <XSLT:template match="{ $match-path }/text()" mode="test"/>
    </xsl:for-each>
    
    <!-- test ordering with respect to parent when grouped   -->
    <xsl:if test="group-as/@in-xml='GROUPED'">
      <XSLT:template match="{ $match-path => replace('/[^/]*$','') }" mode="test">
        <xsl:call-template name="test-order"/>
      </XSLT:template>
    </xsl:if>
    
    <XSLT:template priority="5" match="{ $match-path }" mode="test">
      <!-- 'test-occurrence' template produces only tests needed to check this occurrence -->
      <xsl:call-template name="test-occurrence">
          <xsl:with-param name="using-name" select="$using-name"/>
        </xsl:call-template>
      <!-- while the containment, modeling or datatyping rule is held in a template for the applicable definition -->
      <XSLT:call-template name="require-for-{ pb:definition-name(.) }-{ $metaschema-type }">
        <!--<xsl:if test="exists(use-name)">
          <XSLT:with-param as="xs:string" tunnel="true" name="matching">{ $using-name }</XSLT:with-param>
        </xsl:if>-->
      </XSLT:call-template>
    </XSLT:template>
  </xsl:template>
  <!--</xsl:template>-->

  <xsl:template mode="require-of" expand-text="true"
    match="flag | /*/define-field/define-flag | /*/define-assembly//define-flag">
    <xsl:variable name="using-name" select="pb:use-name(.)"/>
    <!-- have to extend pattern generation to handle extra @in-xml wrapping or dynamic renaming e.g. of module-local definitions? -->
    <xsl:variable name="ancestry" select="(ancestor::define-field| ancestor::define-assembly)/pb:use-name(.) => string-join('/')"/>
    <XSLT:template match="{ $ancestry[matches(.,'\S')] ! (. || '/') }@{ pb:use-name(.)}"
      mode="test">
      <!-- no occurrence testing for flags -->
      <!-- datatyping rule -->
      <XSLT:call-template name="require-for-{ pb:definition-name(.) }-flag">
        <!--<xsl:if test="exists(use-name)">
          <XSLT:with-param as="xs:string" tunnel="true" name="matching">{ $using-name }</XSLT:with-param>
        </xsl:if>-->
      </XSLT:call-template>
    </XSLT:template>
  </xsl:template>
  
  <xsl:template name="test-occurrence" expand-text="true">
    <xsl:param name="using-name"/>
    <!-- test for cardinality -->
    <xsl:if test="number(@min-occurs) gt 1">
      <xsl:variable name="min" select="(@min-occurs, 1)[1]"/>
      <XSLT:call-template name="notice">
        <XSLT:with-param name="cat">cardinality</XSLT:with-param>
        <XSLT:with-param name="condition"
          select="exists(following-sibling::{ $using-name }) or (count(. | preceding-sibling::{ $using-name }) lt { $min })"/>
        <XSLT:with-param name="msg"><code>{ pb:use-name(.) }</code> appears too few times: { $min } minimum are required.</XSLT:with-param>
      </XSLT:call-template>
    </xsl:if>
    <xsl:if test="not(@max-occurs = 'unbounded')">
      <xsl:variable name="max" select="(@max-occurs ! number(), 1)[1]"/>
      <XSLT:call-template name="notice">
        <XSLT:with-param name="cat">cardinality</XSLT:with-param>
        <XSLT:with-param name="condition"
          select="count(. | preceding-sibling::{ $using-name }) gt { $max }"/>
        <XSLT:with-param name="msg"><code>{ pb:use-name(.) }</code> appears too many times: { $max } maximum { if ($max eq 1) then 'is' else 'are' } permitted.</XSLT:with-param>
      </XSLT:call-template>
    </xsl:if>
    
    <!-- TBD: test for order (check preceding sibling types) keeping in mind 'choice' perturbations etc. -->
    
    <xsl:if test="exists(parent::choice)">
        <xsl:variable name="alternatives" select="(parent::choice/child::* except .)"/>
      <XSLT:call-template name="notice">
          <XSLT:with-param name="condition"
            select="exists(../({ ($alternatives ! pb:use-name(.)) => string-join(' | ') }))"/>
        <XSLT:with-param name="cat">choice</XSLT:with-param>
        <XSLT:with-param name="msg">
            <code>{ pb:use-name(.) }</code>
            <xsl:text>is not expected along with </xsl:text> 
            <xsl:call-template name="punctuate-or-code-sequence">
              <xsl:with-param name="items" select="$alternatives"/>
            </xsl:call-template>
            <xsl:text>.</xsl:text>
          </XSLT:with-param>
        </XSLT:call-template>
      </xsl:if>
  
    <xsl:if test="not(group-as/@in-xml='GROUPED')">
      <xsl:call-template name="test-order"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="test-order">
    
    <xsl:variable name="followers"
      select="following-sibling::field | following-sibling::assembly |
        following-sibling::define-field | following-sibling::define-assembly | following-sibling::choice/child::*"/>
    <xsl:if test="exists($followers)" expand-text="true">
      <!--<XSLT:variable name="interlopers" select="{ ($followers ! pb:use-name(.)) ! ('preceding-sibling::' || .) => string-join(' | ') }"/>-->
      <XSLT:call-template name="notice">
        <XSLT:with-param name="cat">ordering</XSLT:with-param>
        <XSLT:with-param name="condition"
          select="exists( { ($followers ! pb:match-name(.)) ! ('preceding-sibling::' || .) => string-join(' | ') } )"/>
        <XSLT:with-param name="msg">
          <code>{ pb:use-name(.) }</code>
          <xsl:text> is not expected to follow </xsl:text>
          <xsl:call-template name="punctuate-or-code-sequence">
            <xsl:with-param name="items" select="$followers"/>
          </xsl:call-template>
          <xsl:text>.</xsl:text>
        </XSLT:with-param>
      </XSLT:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="punctuate-or-code-sequence">
    <xsl:param name="items"/>
    <xsl:for-each select="$items" expand-text="true">
      <xsl:call-template name="punctuate-or-item"/>
      <code>{ pb:match-name(.) }</code>
    </xsl:for-each>
  </xsl:template>
  
  
  
  
<!-- 'require-for' encapsulates tests on assembly, field or flag types as expressed per object: 
     - attribute requirements for assemblies and fields
     - content model requirements for assemblies
     - datatype requirements for fields (values) and flags -->
  
  <xsl:template mode="require-for" match="define-assembly" expand-text="true">
    <xsl:variable name="has-unwrapped-markup-multiline" select="exists( (model/field | model/define-field | model/choice/field | model/choice/define-field)[@as-type='markup-multiline'][@in-xml='UNWRAPPED'] )"/>
    <XSLT:template name="require-for-{ pb:definition-name(.) }-assembly">
      <!--<XSLT:param tunnel="true" name="matching" as="xs:string">{ (use-name,root-name,@name)[1] }</XSLT:param>-->
      <xsl:call-template name="require-attributes"/>
      <!-- for each required element ... -->
      <xsl:for-each select="model/(* | choice/*)[@min-occurs ! (number() ge 1)][not(@in-xml='UNWRAPPED')]" expand-text="true">
        <xsl:variable name="requiring" select="pb:match-name(.)"/>
        <XSLT:call-template name="notice">
          <XSLT:with-param name="cat">required contents</XSLT:with-param>
          <XSLT:with-param name="condition" select="empty({ $requiring })"/>
          <XSLT:with-param name="msg" expand-text="true"><code>{{ name() }}</code> requires <code>{ $requiring }</code>.</XSLT:with-param>
        </XSLT:call-template>
      </xsl:for-each>
      <xsl:if test="$has-unwrapped-markup-multiline">
        <XSLT:apply-templates mode="validate-markup-multiline"/>
      </xsl:if>
    </XSLT:template>
    <xsl:if test="$has-unwrapped-markup-multiline">
      <xsl:variable name="matches" select="pb:contextualized-matches(.)" as="xs:string+"/>
      <!--<xsl:variable name="children" select="model/(.|choice)/(assembly | define-assembly | field | define-field )/pb:use-name(.)"/>-->
      <!--<XSLT:template match="{ $children ! ( $context || . ) => string-join(' | ') }" mode="validate-markup-multiline"/>-->
      <xsl:variable name="matched-markup" as="xs:string*">
        <xsl:for-each select="tokenize($markup-elements,' \| ')">
          <xsl:variable name="e" select="."/>
          <xsl:for-each select="$matches" expand-text="true">{ . || '/' || $e }</xsl:for-each>
        </xsl:for-each>
      </xsl:variable>
      <XSLT:template match="{ $matched-markup => string-join(' | ') }" mode="validate"/>
      
    </xsl:if>
  </xsl:template>
  
  <xsl:variable name="markup-elements" select="'p | ul | ol | table | pre | h1 | h2 | h3 | h4 | h5 | h6'"/>
  
  <xsl:template mode="require-for" match="define-field" expand-text="true">
    <!-- intercept markup descendants of these fields -->
    <xsl:if test="@as-type = ('markup-line','markup-multiline')">
      <XSLT:template match="{ ancestor::model[1]/parent::*/(pb:match-name(.) || '/' )}{ pb:match-name(.) }/*" priority="{ if (@scope='global') then 5 else 7 }" mode="validate">
        <XSLT:apply-templates mode="value-only"/>
      </XSLT:template>
    </xsl:if>
    <XSLT:template name="require-for-{ pb:definition-name(.) }-field">
      <!-- parameter is called by instructions in `require-attributes` logic -->
      <!--<XSLT:param tunnel="true" name="matching" as="xs:string">{ (use-name,@name)[1] }</XSLT:param>-->
      <xsl:call-template name="require-attributes"/>
      <xsl:for-each select="@as-type[. != 'string']">
        <XSLT:call-template name="check-{ . }-datatype"/>
      </xsl:for-each>
    </XSLT:template>
  </xsl:template>
  
<!-- For an inline or global definition, the name captures the ancestry;
     for references, the definition will be at the top level (only) -->
  <xsl:function name="pb:definition-name" as="xs:string">
    <xsl:param name="def" as="node()"/>
    <xsl:sequence select="($def/@ref/string(.), $def/(ancestor::define-assembly | ancestor::define-field | .)/@name => string-join('_..._'))[1]"/>
  </xsl:function>
  
  <xsl:template mode="require-for" match="define-flag" expand-text="true">
    <XSLT:template name="require-for-{ pb:definition-name(.) }-flag">
      <!--<XSLT:param tunnel="true" name="matching" as="xs:string">{ (use-name,@name)[1] }</XSLT:param>-->
      
      <xsl:for-each select="@as-type[. != 'string']">
        <XSLT:call-template name="check-{ . }-datatype"/>
      </xsl:for-each>
    </XSLT:template>
  </xsl:template>
  
  <xsl:template name="require-attributes">
    <!-- for each required attribute ... -->
    <xsl:for-each select="(flag | define-flag)[@required = 'yes']" expand-text="true">
      <xsl:variable name="requiring" select="pb:use-name(.)"/>
      <XSLT:call-template name="notice">
        <XSLT:with-param name="cat">required flag</XSLT:with-param>
        <XSLT:with-param name="condition" select="empty(@{ $requiring })"/>
        <XSLT:with-param name="msg" expand-text="true"><code>{{ name() }}</code> requires <code>@{ $requiring }</code>.</XSLT:with-param>
      </XSLT:call-template>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:function name="pb:or" as="item()*">
    <xsl:param name="items" as="item()*"/>
    <xsl:for-each select="$items">
      <xsl:call-template name="punctuate-or-item"/>
      <xsl:sequence select="."/>
    </xsl:for-each>
  </xsl:function>
  
  <xsl:template name="punctuate-or-item">
    <xsl:if test="position() gt 1">
      <xsl:if test="last() gt 2">, </xsl:if>
      <xsl:if test="position() eq last()"> or </xsl:if>
    </xsl:if>
  </xsl:template>
  
  <xsl:function name="pb:tag" as="element()" expand-text="true">
    <xsl:param name="n" as="xs:string"/>
    <code>{ $n }</code>
  </xsl:function>
  
<!-- contextualized match name resolves assembly field and flag
     definitions to their names in context (including parents) whereever referenced -->
  <xsl:function name="pb:contextualized-matches" as="xs:string*">
    
    <xsl:param name="who" as="element()"/>
<!-- for a reference, return the use-name and the use-name of the parent   -->
<!-- for an inline definition, the same   -->
<!-- for a global definition, find its points of reference -->    
    <xsl:apply-templates select="$who" mode="name-used"/>
  </xsl:function>
  
  <xsl:template mode="name-used" match="model//*" as="xs:string">
    <xsl:text expand-text="true">{ pb:match-name(ancestor::model[1]/..) }/{ pb:match-name(.) }</xsl:text>
  </xsl:template>
  
  <xsl:template mode="name-used" match="METASCHEMA/define-assembly" as="xs:string*">
    <xsl:apply-templates mode="#current" select="key('assembly-references',@_key-name)"/>
  </xsl:template>
  
  <xsl:template mode="name-used" match="METASCHEMA/define-field" as="xs:string*">
    <xsl:apply-templates mode="#current" select="key('field-references',@_key-name)"/>
  </xsl:template>
  
  <xsl:template mode="name-used" match="METASCHEMA/define-flag" as="xs:string*">
    <xsl:apply-templates mode="#current" select="key('flag-references',@_key-name)"/>
  </xsl:template>
  
  <xsl:function name="pb:match-name" as="xs:string?">
    <xsl:param name="who" as="element()"/>
    <xsl:text expand-text="true">{ $who/group-as[@in-xml='GROUPED']/@name ! (. || '/') }{ pb:use-name($who) }</xsl:text>
  </xsl:function>
  
  <xsl:function name="pb:match-name-with-parent" as="xs:string?">
    <xsl:param name="who" as="element()"/>
    <xsl:text expand-text="true">{ $who/ancestor::model[1]/parent::*/(pb:match-name(.) || '/') }{ pb:match-name($who) }</xsl:text>
  </xsl:function>
  
  <xsl:function name="pb:use-name" as="xs:string?">
    <xsl:param name="who" as="element()"/>
    <xsl:variable name="definition" select="$who/self::assembly/key('assembly-definitions', @_key-ref) |
      $who/self::field/key('field-definitions', @_key-ref) | $who/self::flag/key('flag-definitions',@_key-ref)"/>
    <xsl:sequence
      select="($who/root-name, $who/use-name, $definition/root-name, $definition/use-name, $definition/@name, $who/@name)[1]"/>  
  </xsl:function>
  
  <xsl:template name="comment-xsl">
    <xsl:param name="head"/>
    <xsl:comment> -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- </xsl:comment>
    <xsl:comment> -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#-</xsl:comment>
    <xsl:for-each select="$head">
      <xsl:comment>
        <xsl:text>    </xsl:text>
        <xsl:value-of select="."/>
      </xsl:comment>
      <xsl:comment> -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- </xsl:comment>
      
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>