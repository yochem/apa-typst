#import "template.typ": apa7, showfootnotes, appendix

#set text(12pt)

#show: apa7.with(
  title: "Example of APA7 Document in Typst",
  authors: (
    (name: "Andrew K. Jones-Willoughby", orcid: "test", affiliations: (1, 2)),
    (name: "Andrew K. Jones-Willoughby", affiliations: (1,)),
    (name: "Andrew K. Jones-Willoughby", affiliations: (2,)),
  ),
  affiliations: (
    "School of Psychology, University of Sydney",
    "Center for Behavioral Neuroscience, American University"
  ),
  abstract: [
    #lorem(20)
  ],
  footnotepage: false
)

#lorem(40)

#pagebreak()

= Section (lvl 1)

== Sub Section (lvl 2)

#lorem(20)

=== Sub Section (lvl 3)
#lorem(20)

==== Sub Section (lvl 4)
#lorem(20)

===== Sub Section (lvl 5)
#lorem(20)

= Related Work

#lorem(100)#footnote[test]

#figure(
  image("./orcid-logo.svg", height: 10%),
  caption: "helloo"
)<fig-image>
_Note._ For figure notes, just use: `_Note._ Here is a note`.

= Methodology

#lorem(100)#footnote(lorem(20))

#figure(
  table(
    columns: (3cm, auto, auto),
    [Long text in tables is wrapped and indented by 0.15 inch.], [aa], [bb],
  ),
  caption: "This is an example table"
)<fig-table>
_Note._ These tables can also have notes.


In text reference @fig-table and @fig-image.

= Conclusion

#lorem(100)
In-text quotes #quote[are normal].
#quote[
  While quotes longer than 40 words are in indented paragraphs. Like this one.

  It can also have multiple paragraphs, which are also indented on their first
  line. So nice!
]

= Discussion

#lorem(100)

#showfootnotes

#show: appendix

= Test

== test

test

= Test

= Test

test

$
"test"
$

#figure(table(), caption: "")

$
"test"
$
