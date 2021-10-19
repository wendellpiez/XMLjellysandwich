# Electronic Verse Engineering (EVE)

Metadata file in XML points to .eve file instances

these are 'electronic verse engineering' format, a kind of cousin of Markdown, except for verse.

It supports:

- basic metadata
  - author / title / date / links
- interpolating verse lineation and indenting from plain text (tabs or spaces)
- bold and italics in the usual way
- simple footnotes? displayed with symbols not numerated
  - [fn1] means a footnote link or text
  - continues to [fn2] or the end
  - [note] is for free form notes
  - lflf for paragraph, lf for verse line boundary

Then we also have a SaxonJS viewer that reads and parses these (reusing Versifier code for the parsing) and aggregates them into an anthology.

We can also build an XSLT- or XProc-based pipeline to produce a static XML archive version for enhancement i.e. with richer markup.

# Verse and prose

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
