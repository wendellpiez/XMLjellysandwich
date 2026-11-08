<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xsl:template match="@postag | @data-postag" mode="expand-pos">
    <xsl:variable name="tagging" as="map(*)">
      <xsl:map>
        <xsl:map-entry key="'POS'"    select="substring(., 1, 1) => $POS()"/>
        <xsl:map-entry key="'person'" select="substring(., 2, 1) => $person()"/>
        <xsl:map-entry key="'number'" select="substring(., 3, 1) => $number()"/>
        <xsl:map-entry key="'tense'"  select="substring(., 4, 1) => $tense()"/>
        <xsl:map-entry key="'mood'"   select="substring(., 5, 1) => $mood()"/>
        <xsl:map-entry key="'voice'"  select="substring(., 6, 1) => $voice()"/>
        <xsl:map-entry key="'gender'" select="substring(., 7, 1) => $gender()"/>
        <xsl:map-entry key="'case'"   select="substring(., 8, 1) => $case()"/>
        <xsl:map-entry key="'degree'" select="substring(., 9, 1) => $degree()"/>
      </xsl:map>
    </xsl:variable>
    <!-- enumerating them constrains their order -->
    <xsl:text expand-text="true">{ ( ('person', 'gender', 'case', 'number', 'tense', 'voice', 'mood', 'degree')[boolean($tagging(.))] ! $tagging(.) ) => string-join(' ') }</xsl:text>
  </xsl:template>
 
  <!--If abbreviated forms are wanted -->
  <xsl:template name="hideme">
    <xsl:variable name="POS" as="map(*)" select="
        map {
          'n': 'noun',
          'v': 'verb',
          'a': 'adj',
          'd': 'adv',
          'l': 'art',
          'g': 'particle',
          'c': 'conj',
          'r': 'prep',
          'p': 'pron',
          'm': 'num',
          'i': 'interj',
          'u': 'punct'
        }"/>

    <xsl:variable name="person" as="map(*)" select="
        map {
          '1': '1st',
          '2': '2nd',
          '3': '3rd'
        }"/>

    <xsl:variable name="number" as="map(*)" select="
        map {
          's': 'sg',
          'p': 'pl',
          'd': 'du'
        }"/>

    <xsl:variable name="tense" as="map(*)" select="
        map {
          'p': 'pres',
          'i': 'imperf',
          'r': 'perf',
          'l': 'pluperf',
          't': 'fut perf',
          'f': 'fut',
          'a': 'aor'
        }"/>

    <xsl:variable name="mood" as="map(*)" select="
        map {
          'i': 'ind',
          's': 'subj',
          'o': 'opt',
          'n': 'inf',
          'm': 'imper',
          'p': 'participle'
        }"/>

    <xsl:variable name="voice" as="map(*)" select="
        map {
          'a': 'act',
          'p': 'pass',
          'm': 'med',
          'e': 'med-pass'
        }"/>

    <xsl:variable name="gender" as="map(*)" select="
        map {
          'm': 'masc',
          'f': 'fem',
          'n': 'neut'
        }"/>

    <xsl:variable name="case" as="map(*)" select="
        map {
          'n': 'nom',
          'g': 'gen',
          'd': 'dat',
          'a': 'acc',
          'v': 'voc',
          'l': 'loc'
        }"/>

    <xsl:variable name="degree" as="map(*)" select="
        map {
          'c': 'comp',
          's': 'superl'
        }"/>
    <xsl:text/>
  </xsl:template>
 
  <xsl:variable name="POS" as="map(*)" select="map {
    'n': 'noun',
    'v': 'verb',
    'a': 'adjective',
    'd': 'adverb',
    'l': 'article',
    'g': 'particle',
    'c': 'conjunction',
    'r': 'preposition',
    'p': 'pronoun',
    'm': 'numeral',
    'i': 'interjection',
    'u': 'punctuation' }"/>
  
  <xsl:variable name="person" as="map(*)" select="map {  
    '1': '1st person',
    '2': '2nd person',
    '3': '3rd person' }"/>
  
  <xsl:variable name="number" as="map(*)" select="map {
    's': 'singular',
    'p': 'plural',
    'd': 'dual'  }"/>

  <xsl:variable name="tense" as="map(*)" select="map {
    'p': 'present',
    'i': 'imperfect',
    'r': 'perfect',
    'l': 'pluperfect',
    't': 'future perfect',
    'f': 'future',
    'a': 'aorist'  
    }"/>
  
  <xsl:variable name="mood" as="map(*)" select="map {
    'i': 'indicative',
    's': 'subjunctive',
    'o': 'optative',
    'n': 'infinitive',
    'm': 'imperative',
    'p': 'participle'  
    }"/>

  <xsl:variable name="voice" as="map(*)" select="map {
    'a': 'active',
    'p': 'passive',
    'm': 'middle',
    'e': 'medio-passive' }"/>

  <xsl:variable name="gender" as="map(*)" select="map {
    'm': 'masculine',
    'f': 'feminine',
    'n': 'neuter' }"/>

  <xsl:variable name="case" as="map(*)" select="map {
    'n': 'nominative',
    'g': 'genitive',
    'd': 'dative',
    'a': 'accusative',
    'v': 'vocative',
    'l': 'locative'  
    }"/>
  
  <xsl:variable name="degree" as="map(*)" select="map {
    'c': 'comparative',
    's': 'superlative'
    }"/>

  
</xsl:stylesheet>