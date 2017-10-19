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
        },
        function (err) { "ERROR: " + err } )
    .then(function (text) {
        console.log(text);
        document.getElementById("XTractor").innerHTML = text;
        /*var oParser = new DOMParser();
        var xmltree = oParser.parseFromString(text, "text/xml");*/
        
        /*SaxonJS.transform({
            sourceNode:         xmltree,
            stylesheetLocation: "plain.sef",
            initialTemplate:    "XTractor-acquire" });*/
        /*console.log(xmltree);*/
    },
function (err) { "ERROR: " + err } )
}
