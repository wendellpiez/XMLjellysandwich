# Electronic Verse Engineer (EVE)

EVE notation (sometimes 'eve dot text', eve.txt) is a cousin of Markdown, designed specifically for the capture of shorter poems and snippets of verse, in a form conducive to their collection and further publication.

EVE doesn't do much but what it does, it does well, and nothing else does it. It is also easy to use.

The idea is: enter your EVE text into the box, and push the button.

Coming soon is another page where you can do things with the EVE XML you can save on the Verse Engineer page.

EVE supports:

- basic metadata
  - author / title / date
- interpolating verse lineation and indenting from plain text (tabs or spaces)
  - '---' demarcates sections
  - verse and prose are interpolated from line breaks and indents 
- bold and italics in a familiar way (to Markdown users)
- simple footnotes? displayed with symbols, not numerated
  - [fn1] means a footnote link or text
  - continues to [fn2] or the end of the section
  - [note] is for free form notes
  - lflf for paragraph, lf for verse line boundary

## tbd

upcoming

  - CSS for standalone EVE XML / authoring?
  - Enhanced EVE HTML with self-contained `<script>` 

## Persistent Link Capture

Persistent link capture works by rewriting your Eve text as an opaquely encoded string that can be passed as a link.

So for example here is a short bit of Eve to try:

https://wendellpiez.github.io/XMLjellysandwich/VerseEngineer?eve=YXV0aG9yOiBFbWlseSBEaWNraW5zb24KLS0tCgpBbXBsZSBtYWtlIHRoaXMgYmVkCiAgTWFrZSB0aGlzIGJlZCB3aXRoIGF3ZToKTGllIGluIGl0IHRpbGwganVkZ2VtZW50IGJyZWFrCiAgRXhjZWxsZW50IGFuZCBmYWlyLgoKQmUgaXRzIG1hdHRyZXNzIHN0cmFpZ2h0LgogIEJlIGl0cyBwaWxsb3cgcm91bmQuCkxldCBubyBzdW5yaXNlIHllbGxvdyBub2lzZQogIEludGVycnVwdCB0aGlzIGdyb3VuZC4K