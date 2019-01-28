<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns="http://wendellpiez.com/iching"
    xpath-default-namespace="http://wendellpiez.com/iching"
    exclude-result-prefixes="xs math"
    version="3.0">
    
<!-- Run just once or repeatedly, over a binary bagua document like bagua.xml  -->
    
<!-- This stylesheet knows how to interpret the 'bare' bagua and map it to trigrams and hexagrams -->
    
    <!--NB the base (root) of the Bagua tree is the *bottom* not top of the hex-->
  <xsl:mode on-no-match="shallow-copy"/>


  <xsl:template match="bagua/*/*/* | bagua/*/*/*/*/*/*">
      <xsl:variable name="glyph">
          <xsl:apply-templates select="." mode="trigram"/>
      </xsl:variable>
      
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <xsl:attribute name="g3" select="$glyph"/>
            <xsl:apply-templates/>
        </xsl:copy>
  </xsl:template>
    
    <xsl:variable name="trigrams">
        <trigram zh="乾" tr="Qián" glyph="☰"/>
        <trigram zh="坤" tr="Kūn"  glyph="☷"/>
        <trigram zh="震" tr="Zhèn" glyph="☳"/>
        <trigram zh="坎" tr="Kǎn"  glyph="☵"/>
        <trigram zh="艮" tr="Gèn"  glyph="☶"/>
        <trigram zh="巽" tr="Xùn"  glyph="☴"/>
        <trigram zh="離" tr="Lí"   glyph="☲"/>
        <trigram zh="兌" tr="Duì"  glyph="☱"/>
    </xsl:variable>
        
    <xsl:template match="日/日/日" mode="trigram">☰</xsl:template>
    <xsl:template match="月/月/月" mode="trigram">☷</xsl:template>
    <xsl:template match="日/月/月" mode="trigram">☳</xsl:template>
    <xsl:template match="月/日/月" mode="trigram">☵</xsl:template>
    <xsl:template match="月/月/日" mode="trigram">☶</xsl:template>
    <xsl:template match="月/日/日" mode="trigram">☴</xsl:template>
    <xsl:template match="日/月/日" mode="trigram">☲</xsl:template>
    <xsl:template match="日/日/月" mode="trigram">☱</xsl:template>
    
    <xsl:template match="月/月/月/日/日/日" mode="hexagram">䷀</xsl:template>
    <xsl:template match="月/月/月/月/月/月" mode="hexagram">䷁</xsl:template>
    <xsl:template match="日/月/月/月/日/月" mode="hexagram">䷂</xsl:template>
    <xsl:template match="月/日/月/月/月/日" mode="hexagram">䷃</xsl:template>
    <xsl:template match="日/日/日/月/日/月" mode="hexagram">䷄</xsl:template>
    <xsl:template match="月/日/月/日/日/日" mode="hexagram">䷅</xsl:template>
    <xsl:template match="月/日/月/月/月/月" mode="hexagram">䷆</xsl:template>
    <xsl:template match="月/月/月/月/日/月" mode="hexagram">䷇</xsl:template>
    <xsl:template match="日/日/日/月/日/日" mode="hexagram">䷈</xsl:template>
    <xsl:template match="日/日/月/日/日/日" mode="hexagram">䷉</xsl:template>
    <xsl:template match="日/日/日/月/月/月" mode="hexagram">䷊</xsl:template>
    <xsl:template match="月/月/月/日/日/日" mode="hexagram">䷋</xsl:template>
    <xsl:template match="日/月/日/日/日/日" mode="hexagram">䷌</xsl:template>
    <xsl:template match="日/日/日/日/月/日" mode="hexagram">䷍</xsl:template>
    <xsl:template match="月/月/日/月/月/月" mode="hexagram">䷎</xsl:template>
    <xsl:template match="月/月/月/日/月/月" mode="hexagram">䷏</xsl:template>
    <xsl:template match="日/月/月/日/日/月" mode="hexagram">䷐</xsl:template>
    <xsl:template match="月/日/日/月/月/日" mode="hexagram">䷑</xsl:template>
    <xsl:template match="日/日/月/月/月/月" mode="hexagram">䷒</xsl:template>
    <xsl:template match="月/月/月/月/日/日" mode="hexagram">䷓</xsl:template>
    <xsl:template match="日/月/月/日/月/日" mode="hexagram">䷔</xsl:template>
    <xsl:template match="日/月/日/月/月/日" mode="hexagram">䷕</xsl:template>
    <xsl:template match="月/月/月/月/月/日" mode="hexagram">䷖</xsl:template>
    <xsl:template match="日/月/月/月/月/月" mode="hexagram">䷗</xsl:template>
    <xsl:template match="日/月/月/日/日/日" mode="hexagram">䷘</xsl:template>
    <xsl:template match="日/日/日/月/月/日" mode="hexagram">䷙</xsl:template>
    <xsl:template match="日/月/月/月/月/日" mode="hexagram">䷚</xsl:template>
    <xsl:template match="月/日/日/日/日/月" mode="hexagram">䷛</xsl:template>
    <xsl:template match="月/日/月/月/日/月" mode="hexagram">䷜</xsl:template>
    <xsl:template match="日/月/日/日/月/日" mode="hexagram">䷝</xsl:template>
    <xsl:template match="月/月/日/日/日/月" mode="hexagram">䷞</xsl:template>
    <xsl:template match="月/日/日/日/月/月" mode="hexagram">䷟</xsl:template>
    <xsl:template match="月/月/日/日/日/日" mode="hexagram">䷠</xsl:template>
    <xsl:template match="日/日/日/日/月/月" mode="hexagram">䷡</xsl:template>
    <xsl:template match="月/月/月/日/月/日" mode="hexagram">䷢</xsl:template>
    <xsl:template match="日/月/日/月/月/月" mode="hexagram">䷣</xsl:template>
    <xsl:template match="日/月/日/月/日/日" mode="hexagram">䷤</xsl:template>
    <xsl:template match="日/日/月/日/月/日" mode="hexagram">䷥</xsl:template>
    <xsl:template match="月/月/日/月/日/月" mode="hexagram">䷦</xsl:template>
    <xsl:template match="月/日/月/日/月/月" mode="hexagram">䷧</xsl:template>
    <xsl:template match="日/日/月/月/月/日" mode="hexagram">䷨</xsl:template>
    <xsl:template match="日/月/月/月/日/日" mode="hexagram">䷩</xsl:template>
    <xsl:template match="日/日/日/日/日/月" mode="hexagram">䷪</xsl:template>
    <xsl:template match="月/日/日/日/日/日" mode="hexagram">䷫</xsl:template>
    <xsl:template match="月/月/月/日/日/月" mode="hexagram">䷬</xsl:template>
    <xsl:template match="月/日/日/月/月/月" mode="hexagram">䷭</xsl:template>
    <xsl:template match="月/日/月/日/日/月" mode="hexagram">䷮</xsl:template>
    <xsl:template match="月/日/日/月/日/月" mode="hexagram">䷯</xsl:template>
    <xsl:template match="日/月/日/日/日/月" mode="hexagram">䷰</xsl:template>
    <xsl:template match="月/日/日/日/月/日" mode="hexagram">䷱</xsl:template>
    <xsl:template match="日/月/月/日/月/月" mode="hexagram">䷲</xsl:template>
    <xsl:template match="月/月/日/月/月/日" mode="hexagram">䷳</xsl:template>
    <xsl:template match="月/月/日/月/日/日" mode="hexagram">䷴</xsl:template>
    <xsl:template match="日/日/月/日/月/月" mode="hexagram">䷵</xsl:template>
    <xsl:template match="日/月/日/日/月/月" mode="hexagram">䷶</xsl:template>
    <xsl:template match="月/月/日/日/月/日" mode="hexagram">䷷</xsl:template>
    <xsl:template match="月/日/日/月/日/日" mode="hexagram">䷸</xsl:template>
    <xsl:template match="日/日/月/日/日/月" mode="hexagram">䷹</xsl:template>
    <xsl:template match="月/日/月/月/日/日" mode="hexagram">䷺</xsl:template>
    <xsl:template match="日/日/月/月/日/月" mode="hexagram">䷻</xsl:template>
    <xsl:template match="日/日/月/月/日/日" mode="hexagram">䷼</xsl:template>
    <xsl:template match="月/月/日/日/月/月" mode="hexagram">䷽</xsl:template>
    <xsl:template match="日/月/日/月/日/月" mode="hexagram">䷾</xsl:template>
    <xsl:template match="月/日/月/日/月/日" mode="hexagram">䷿</xsl:template>
    
</xsl:stylesheet>