# Electronic Verse Engineer (EVE)

EVE notation (sometimes 'eve dot text', eve.txt) is a kind of cousin of Markdown, designed specifically for the capture of shorter poems and snippets of verse, in a form conducive to their collection and further publication.

EVE doesn't do much but what it does, it does well, and nothing else does it. It is also easy to use.

The idea is: enter your EVE text into the box, and push the button.

Coming soon is another page where you can do things with the EVE XML you can save on the Verse Engineer page.

EVE supports:

- basic metadata
  - author / title / date / links
- interpolating verse lineation and indenting from plain text (tabs or spaces)
  - after the first '---' we assume verse
  - but start any verse or prose segment with `[[verse]]` or `[[prose]]` keycodes 
- bold and italics in a familiar way (to Markdown users)
- simple footnotes? displayed with symbols, not numerated
  - [fn1] means a footnote link or text
  - continues to [fn2] or the end
  - [note] is for free form notes
  - lflf for paragraph, lf for verse line boundary

## Verse and prose in Eve

Verse is assumed until you say it is not.

Verse and prose are parsed differently with respect to lines and indenting. Prose lines are collapsed together. Verse lines are broken out, while their indentation levels are collapsed and captured.

When you are not typing verse, you are either just typing (prose), or typing a note. Notes follow the prose rules with respect to lines.

There are two kinds of notes: side notes and reference notes.

Reference notes are presented as footnotes. Side notes are presented as boxes or callouts (in relative position).

Everything inside a note is prose unless it says `[[verse]]`.

Use `[[note]]` to indicate a side note. Use `[[nnn]]` to indicate a reference note, where `nnn` is the code you wish to use for referencing.

BTW these values will not be used in display! typically these notes will be numbered or provided with reference marks (asterisks, daggers etc.) and the tag is used only in back.

Reference a note inline using `[nnn]` where `nnn` is the code. (The parser will only recognize this if `nnn` is used to delimit a note somewhere.)

Thus, you create distinct notes by using distinct values of `nnn`. Tags such as `fn1` for footnote 1, `fn2` for footnote 2 work well enough, but you can use your own scheme (and overload it if you like).

## Persistent Link Capture

Persistent link capture works by rewriting your Eve text as an opaquely encoded string that can be passed as a link.

So for example here is a short bit of Eve to try:

https://wendellpiez.github.io/XMLjellysandwich/VerseEngineer?eve=YXV0aG9yOiBFbWlseSBEaWNraW5zb24KLS0tCgpBbXBsZSBtYWtlIHRoaXMgYmVkCiAgTWFrZSB0aGlzIGJlZCB3aXRoIGF3ZToKTGllIGluIGl0IHRpbGwganVkZ2VtZW50IGJyZWFrCiAgRXhjZWxsZW50IGFuZCBmYWlyLgoKQmUgaXRzIG1hdHRyZXNzIHN0cmFpZ2h0LgogIEJlIGl0cyBwaWxsb3cgcm91bmQuCkxldCBubyBzdW5yaXNlIHllbGxvdyBub2lzZQogIEludGVycnVwdCB0aGlzIGdyb3VuZC4K