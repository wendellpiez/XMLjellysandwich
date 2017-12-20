# Conway's Game of Life in XSLT

*By Wendell Piez - wapiez (at) wendellpiez.com, Dec 2017* 

See the game in action at https://wendellpiez.github.io/XMLjellysandwich/GameofLife/

Tickle a search engine to learn about Conway's Game of Life, a simple cellular automaton.

This one plays by the rules -- and also implements the logic in XSLT. Not for the first time -- but now, in SaxonJS, we can actually make it work in your browser.

It aims to be as simple as possible while still functioning. A later version might add form controls for features such as:

* User can calibrate 'pulse' (slow it down)
  * when SaxonJS supports dynamic `xsi:schedule-event/@wait`
* User can set a grid size (setting `$dim`)
* User can pseudo-randomly auto-populate the grid

-----
