<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  version="3.0" xmlns:xhtml="http://www.w3.org/1999/xhtml">


<!-- Purpose: download and save the TEI encoded Cunliffe Lexicon
     from Gregory Crane Github repository
    
     It is a sizable file
-->

  <p:input port="source" sequence="true">
      <p:empty/>
  </p:input>

  <!--<p:output port="result"/>-->
  
  <p:variable name="filename" select="'cunliffe.lexentries.unicode.xml'"/>
  
  <p:variable name="repo"     select="'gregorycrane'"/>
  <p:variable name="filepath"
    select="('https://github.com', $repo, 'Homerica/raw/refs/heads/master', $filename ) => string-join('/')"/>

  <!-- The location of the file to be acquired -->
  <p:variable name="already-got-one" select="string(.)">
      <p:inline>{ ($repo,$filename) => string-join('/') }</p:inline>
  </p:variable>

  <p:file-info href="{ $already-got-one}" message="Looking for { $already-got-one }" fail-on-error="false"/>
  
  <p:choose>
    <p:when test="empty(/c:error)">
      <p:identity message="SEEING A FILE { $already-got-one }"/>
    </p:when>
  
    <p:otherwise>
      <p:load href="{ $filepath }" message="DOWNLOADING { $filename } from { $repo } ..." content-type="application/xml"/>
      
      <p:delete match="/processing-instruction()"/>
      
      <p:store name="saving" message="... Saving { $already-got-one }" href="{ $already-got-one }"/>

      <p:file-info depends="saving" href="{ $already-got-one }" message="Okay got it"/>
      
    </p:otherwise>
  
  </p:choose>

</p:declare-step>
