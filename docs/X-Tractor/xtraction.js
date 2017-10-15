var doc_string = new String("<document>Whoa <i>isn't this fun?</i></document>");
      
window.onload = function() {
  SaxonJS.transform({
    sourceText:         doc_string,
    stylesheetLocation: "plain.sef",
    initialTemplate:    "xmljellysandwich_pack"
  });
}

/*function loadFromZip (file, path) {
    return path
}
*/


function loadFromZip (zippath, filepath) {
   var zip = new JSZip()
   zip.loadAsync(zippath)
   .then(function (zip) {
        console.log(zip.files);
        
        var filecontents = zip.file(filepath).async("string")
        console.log(filecontents); // Promise { <state>: "pending" }
        return filecontents
   } )
   .then(
     function success(text) {                    // 5) display the result
       console.log(text);
       document.getElementById("locus").innerHTML = text;
       return text
      },
     function error(e) { "ERROR: " + e } )
}
