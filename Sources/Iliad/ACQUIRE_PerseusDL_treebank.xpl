<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  version="3.0" xmlns:xhtml="http://www.w3.org/1999/xhtml">


<!-- Purpose: download and save PerseusDL Treebank data for Homer's Iliad, with corrections.
    
    THIS PIPELINE SAVES THE Morphological Treebank file for the Iliad - 20MB -
    Take care you really want it
-->

  <p:input port="source" sequence="true">
      <p:empty/>
  </p:input>

  <!--<p:output port="result"/>-->
  
  <!-- Iliad:   tlg0012.tlg001.perseus-grc1.tb.xml
       Odyssey: tlg0012.tlg002.perseus-grc1.tb.xml -->
  
  <p:variable name="filename" select="'tlg0012.tlg001.perseus-grc1.tb.xml'"/>
  
  <p:variable name="repo"     select="'PerseusDL'"/>
  <p:variable name="filepath"
    select="('https://github.com', $repo, 'treebank_data/raw/refs/heads/master/v2.1/Greek/texts', $filename ) => string-join('/')"/>

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
      
      <!-- Some corrections to make -->
      <p:group>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2274183']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:1.154 urn:cts:greekLit:tlg0012.tlg001:1.155'][@id=((7 to 10)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:1.154"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2274183']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:1.154 urn:cts:greekLit:tlg0012.tlg001:1.155'][@id=('12','13')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:1.155"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2274402']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:1.526 urn:cts:greekLit:tlg0012.tlg001:1.527'][@id=('5','6','7')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:1.526"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2274402']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:1.526 urn:cts:greekLit:tlg0012.tlg001:1.527'][@id=('8','9')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:1.527"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2274712']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:2.488 urn:cts:greekLit:tlg0012.tlg001:2.489'][@id=('7','8','9')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:2.488"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2274712']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:2.488 urn:cts:greekLit:tlg0012.tlg001:2.489'][@id=('11','12')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:2.489"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2275287']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:4.302 urn:cts:greekLit:tlg0012.tlg001:4.303']"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:4.302"/>
        
        <p:add-attribute match="/treebank/body/sentence[@id='2275287']" attribute-name="subdoc"
          attribute-value="4.301-4.302"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2275288']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:4.302 urn:cts:greekLit:tlg0012.tlg001:4.303']"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:4.303"/>
        
        <p:add-attribute match="/treebank/body/sentence[@id='2275288']" attribute-name="subdoc"
          attribute-value="4.303-4.305"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2276119']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:6.383 urn:cts:greekLit:tlg0012.tlg001:6.384'][@id=((12 to 15)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:6.383"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2276119']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:6.383 urn:cts:greekLit:tlg0012.tlg001:6.384'][@id=('16','17')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:6.384"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2276151']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:6.451 urn:cts:greekLit:tlg0012.tlg001:6.452'][@id=((10 to 17)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:6.451"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2276151']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:6.451 urn:cts:greekLit:tlg0012.tlg001:6.452'][@id=('18','19')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:6.452"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2276499']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:8.78 urn:cts:greekLit:tlg0012.tlg001:8.79'][@id=((7 to 9)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:8.78"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2276499']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:8.78 urn:cts:greekLit:tlg0012.tlg001:8.79'][@id=('11','12')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:8.79"/>
        
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2278883']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:15.98 urn:cts:greekLit:tlg0012.tlg001:15.99'][@id=('10','11','12')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:15.98"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2278883']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:15.98 urn:cts:greekLit:tlg0012.tlg001:15.99'][@id=('13','14')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:15.99"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2279342']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:16.225 urn:cts:greekLit:tlg0012.tlg001:16.226'][@id=((8 to 11)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:16.225"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2279342']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:16.225 urn:cts:greekLit:tlg0012.tlg001:16.226'][@id=('12','13')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:16.226"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2279693']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:17.20 urn:cts:greekLit:tlg0012.tlg001:17.21'][@id=((7 to 9)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:17.20"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2279693']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:17.20 urn:cts:greekLit:tlg0012.tlg001:17.21'][@id=('10','11')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:17.21"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2280802']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:20.266 urn:cts:greekLit:tlg0012.tlg001:20.267'][@id=((30 to 32)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:20.266"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2280803']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:20.266 urn:cts:greekLit:tlg0012.tlg001:20.267'][@id=('1','2')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:20.267"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2281444']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:22.300 urn:cts:greekLit:tlg0012.tlg001:22.301'][@id=((9 to 12)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:22.300"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2281444']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:22.300 urn:cts:greekLit:tlg0012.tlg001:22.301'][@id=('14','15')]"
          attribute-name="cite"
          attribute-value="urn:cts:greekLit:tlg0012.tlg001:22.300 urn:cts:greekLit:tlg0012.tlg001:22.301"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2281741']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:23.345 urn:cts:greekLit:tlg0012.tlg001:23.346'][@id=((17 to 19)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:23.345"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2281741']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:23.345 urn:cts:greekLit:tlg0012.tlg001:23.346'][@id=('21','22')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:23.346"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2281917']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:23.621 urn:cts:greekLit:tlg0012.tlg001:23.622'][@id=((7 to 9)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:23.621"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2281917']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:23.621 urn:cts:greekLit:tlg0012.tlg001:23.622'][@id=('11','12')]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:23.622"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2281924']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:23.632 urn:cts:greekLit:tlg0012.tlg001:23.633'][@id=((9 to 12)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:23.632"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2281924']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:23.632 urn:cts:greekLit:tlg0012.tlg001:23.633'][@id=((13 to 18)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:23.633"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2282101']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:24.25 urn:cts:greekLit:tlg0012.tlg001:24.26'][@id=((7 to 10)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:24.25"/>
        
        <p:add-attribute
          match="/treebank/body/sentence[@id='2282101']/word[@cite='urn:cts:greekLit:tlg0012.tlg001:24.25 urn:cts:greekLit:tlg0012.tlg001:24.26'][@id=((11 to 15)!string(.))]"
          attribute-name="cite" attribute-value="urn:cts:greekLit:tlg0012.tlg001:24.26"/>
        
      </p:group>
      
      <p:store name="saving" message="... Saving { $already-got-one }" href="{ $already-got-one }"/>

      <p:file-info depends="saving" href="{ $already-got-one }" message="Okay got it"/>
      
    </p:otherwise>
  
  </p:choose>

</p:declare-step>
