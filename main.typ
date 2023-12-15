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
  footnotepage: true
)

#lorem(40)

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
    lorem(10), [aa], [bb],
  ),
  caption: "helloo"
)<fig-table>
_Note._ Factor


In text reference @fig-table and @fig-image.

= Conclusion

#lorem(100)
In-text quotes #quote[are normal].

#pagebreak()
#lorem(10)
#quote[
  #lorem(20) 

  #lorem(20) 

  #lorem(20) 
]

= Discussion

#lorem(100)

#showfootnotes

#show: appendix

// = Test
//
// test
//
// = Test
//
// = Test
//
// test
