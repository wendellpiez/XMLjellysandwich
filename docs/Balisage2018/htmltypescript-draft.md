# HTML Typescript: Evolution and Revolution

Small design changes can have huge consequences for publishing workflows. With the introduction of the word processor came the ability to change copy easily and consequently the author assumed more of this role and the copy editor’s role was redefined. The small change I am proposing here is what we call HTML Typescript. It is nothing fancy, nothing new, but it is a fresh look at how we can bring offline word processing workflows into the browser. It is a small change, but with larger consequences.

Docx is a type of XML. It is, laughably, called OpenXML by Miscrosoft. Laughably, because while you can unzip a docx file (a docx file is a zip file containing a simple directory structure and some files), you can open the document.xml and poke around with it but it is incomprehensible. There are two critical problems that contribute to this:

* The XML is pretty unreadable by humans. It is dense and verbose and very very messy.
* Due to the editing environment (MS Word) and its inability to constrain authors from using ‘font size 12, bold’ instead of marking the text correctly as a Heading Level 2 (for example), the resulting styles applied by the author, and described in the XML, are erratic at best.

Number 2 is the big problem, and issue number 1 helps obfuscate it.

So, when you want to transfer from docx to HTML, it is very difficult to determine the author’s strucural intent without looking at the original display version of the MS Word file. Is this indented single line marked ‘font size 16.6, bold’ a heading 1,2, or 3…or is it meant to be a block quote? Problems like this have always been seen as a blocker for this approach.

Of course, with XSLT, it is very possible to convert from docx to HTML. Nothing impossible there. You don’t end up losing content but you do end up with messy unstructured HTML. This is because the original docx is messy and unstructured. This is what people mean when they say ‘it can’t be done’ ie. you cannot infer all the structural intent of the author from the docx file, because it is a mess, and by some magic subsequently convert it to lovely clean, structured, HTML.

But, that is actually ok. Converting to ‘messy’ HTML really puts you in about the same position as having a messy docx file. They are both equivalently unstructured.

Additionally, at the time of conversion we can move from docx to HTML and make some ‘educated’ guesses as to what the author’s intent is. For example, if there is one single line text with ‘font size 24, bold’ and then 16 of ‘font size 20, bold’ and 6 of ‘font size 14, bold’ and then a bunch of sentences groups with font size 12 – then we can map these to heading 1,2,3 respectively, and the last being standard paragraphs. It is not perfect -it will not catch all structure, and the process will make incorrect inferences. However, it will get us part of the way there. So we can already start improving on the structure of the MS Word file automagically.

Arguably, we are in a better position with an initial rules-based clean up of the file structure as it passes from docx to HTML. The good thing is that we can improve these rules over time. In time, the automated conversion will produce better results.

After a conversion of this kind, we have a partially structured file. This is where file conversion specialists often leave the conversation. They don’t like partially structured anything. It is not in their DNA. That is because they are primarily concerned with conforming file A into structure X. Their metric is ‘ is it well structured?’. It is a pass/fail binary. If you are to look primarily at whether file A or B is well structured then you want well-defined schemas that describe the structure, and you want files that subscribe perfectly to that schema. Anything that falls out of this is a fail. Partially structured documents are a fail.

But with the HTML Typescript approach we see partially structured documents as a strength, not a weakness. We know it is not possible to get to perfectly formed documents in one go, so rather than consider this a fail we accept we must get there progressively. That is the fundamental principle behind what we are calling HTML Typescript. It is the use of HTML as a document format that can be progressively improved to get to the structure you desire over time using both machine and manual processes.

HTML is the perfect format for this. HTML’s lack of formal structure, along with its ability to define any kind of structure you want, enables us to progressively add any kind of structure we need to a document. One part of this process is the automated clean up at conversion time, and the next part of the process is where it starts getting interesting… this is the manual application of structure.

This is where the apparent weakness of HTML becomes a strength – we can manually add structure over time. We can progressively structure the document. For this process, we can build, and the Coko team are building, a suite of tools in the production environment so that a production editor (for example) can click on an element (eg a heading) and choose the style they wish to apply from a menu – similar to how they currently work with macros.

The advantages of adding the correct structure in the browser vs MS Word? Well, firstly, as mentioned above, we can computationally improve the structure before the manual process. This results in less work to do. Secondly, we have complete control over the tools available to the platform’s distributed users, consequently:

 * There is no need to update the (equivalent of) macros against the underlying desktop software version across many machines.
 * If I wish to update the features that enable styling, then all users can leverage these updates immediately.

So, as a publisher, I’m not stuck in the harrowing, expensive, cycle of continual software upgrades and installs against random (or planned) updates of MS Word that maybe conducted by my org. That is already a saving. More importantly, this is where a small design decision might have a large impact. Publishers that are forced to design workflows based, literally, on where the tools are (what machines the macros are installed on in this case), can now design workflows dependent on who they think would be best placed to do the work. That is pretty interesting. Such a small design decision might actually cause pretty radical changes to workflow.

