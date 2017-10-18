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

// modeled after https://gildas-lormeau.github.io/zip.js/core-api.html#zip-reading

function loadFromZip (zippath, filepath) {
  
    // use a BlobReader to read the zip from a Blob object
    zip.createReader(new zip.BlobReader(zippath), function(reader) {
    
    // get all entries from the zip
    reader.getEntries(function(entries) {
        entries.forEach( function (entry) {
            if (entry.filename = filepath) {
                entry.getData(new zip.TextWriter(), function(text) {
                    console.log(text);
                    text } ) };
            // close the zip reader
            reader.close(function() { }); // onclose callback
            });
        },
        function(current, total) { });  // onprogress callback
    },
    function(error) { });// onerror callback
}
