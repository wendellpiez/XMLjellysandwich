# Conway's Game of Life in XSLT

*By Wendell Piez - wapiez (at) wendellpiez.com, Dec 2017* 

See the game in action at https://wendellpiez.github.io/XMLjellysandwich/GameofLife/

Tickle a search engine to learn about Conway's Game of Life, a simple cellular automaton.

This one plays by the rules -- and also implements the logic in XSLT. Not for the first time -- but now, in SaxonJS, we can actually make it work in your browser.

(Admittedly a 4GL designed for tree transformations may not be your first choice for performance, if only because the stack is so high. But look how sweet is the code: take out all the UI stuff and the game itself is hardly there at all.)

As for the interface, it was almost as simple as I could make it, and then it wasn't. But it does aim for (a) utility while (b) showing off a little event handling in Saxon's extensions to XSLT. A later version might add form controls for features such as:

* User can adjust 'pulse' (slow it down)
  * when SaxonJS supports dynamic `xsi:schedule-event/@wait` (right now 1000ms)
* User can set a grid size (setting `$dim`)
* User can pseudo-randomly auto-populate the grid
* Generation ticker since (re)start

-----

