<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="3.0">

  <!--
  Purpose: read PerseusDL Treebank Iliad in
  Produce a clean XML result - legible, reasonably compact, TEIish

  so far: produces ILIAD in lines with word-level markup
    -->

  <p:input port="source" href="PerseusDL/tlg0012.tlg001.perseus-grc1.tb.xml"/>
  
  <!--<p:output port="result" serialization="map { 'indent': true() }"/>-->
  
  <p:xslt>
    <p:with-input port="stylesheet" href="src/treebank-to-teiish.xsl"/>
  </p:xslt>
  
  <p:xslt>
    <p:with-input port="stylesheet" href="src/treebank-tei-fixup.xsl"/>
  </p:xslt>
  
  <p:store href="../../docs/Iliad/ILIAD_lexica.xml"  serialization="map { 'indent': true() }"
    message="STORING ../../docs/Iliad/ILIAD_lexica.xml"/>
  
  <!--<p:xslt> use this logic in display instead
      look up *all* terms that have cunliffe lexentries not just the cited ones
      passing the cited term ID in from the type for highlighting
      
    <p:with-input port="stylesheet" href="src/treebank/annotate-cunliffe.xsl"/>
  </p:xslt>
  
  <p:store href="data/ILIAD_pos-linked.xml"  serialization="map { 'indent': true() }"
    message="STORING data/ILIAD_pos-linked.xml"/>-->
  
</p:declare-step>