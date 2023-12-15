#let fontsize = state("fontsize", 0pt)
#let doublespace = 1.7em

#let authorHasOrcid(authors) = authors.map(author =>
  // if type(author) == dictionary and dictHasKey(author, "orcid") {
  if type(author) == dictionary and "orcid" in author {
    true
  } else {
    false
  }
).contains(true)

#let differentAffiliations(authors) = authors.map(author =>
  if type(author) == dictionary and "affiliations" in authors {
    true
  } else {
    false
  }
).contains(true)

#let apa7(
  title: "",
  running-head: none,
  date: datetime.today(),
  authors: ("",),
  affiliations: none,
  keywords: none,
  abstract: none,
  titlepage-type: "professional",
  authornote: none,
  footnotepage: false,
  body
) = {
  let warning = text.with(red, weight: "bold")
  show par: set block(spacing: doublespace) // §2.24

  // §2.18
  let header = upper({
    let rh = if running-head != none {
      running-head
    } else {
      title
    }
    if rh.len() > 50 {
      warning[running-head too long]
    } else {
      rh
    }
    h(1fr)
    counter(page).display()
  })

  let authorNames = authors.map(it =>
    if type(it) == str {
      it
    } else {
      it.name
    }
  )

  set document(
    author: authorNames,
    title: title,
    date: date
  )
  set text(
    hyphenate: false // §2.23
  )
  set page(
    numbering: "1",
    paper: "a4",
    header: header,
    header-ascent: 3em,
    footer: "",
    margin: (top: 1in + doublespace, rest: 1in), // §2.22
  )
  set par(first-line-indent: 0.5in, leading: doublespace) // §2.21

  // set font size, used for headings
  style(styles => {
    fontsize.update(measure(v(1em), styles).height)
  })

  // §2.27
  show heading: it => {
    block(below: 0em, text(fontsize.at(it.location()), weight: "bold")[#it.body])
    par(text(size:0.35em, h(0.0em)))
  }

  show heading.where(level: 1): align.with(center)
  show heading.where(level: 3): text.with(style: "italic")

  show heading.where(level: 4): it => {
    box(it.body + [.])
  }
  show heading.where(level: 5): it => {
    set text(style: "italic")
    box(it.body + [.])
  }

  show footnote.entry: it => if not footnotepage { it }
  set footnote.entry(separator: if not footnotepage { line(length: 30%, stroke: 0.5pt) })

  show figure: it => {
    block({
      // TODO: sans-serif font
      text(weight: "bold")[
        #it.supplement
        #counter(figure.where(kind: it.kind)).display()
      ]
      block(emph(it.caption.body))
      it.body
    })
  }

  show table: set par(hanging-indent: 0.15in)

  set bibliography(title: "References")
  show bibliography: it => {
    set par(hanging-indent: 0.5in)
    pagebreak(weak: true)
    it
  }

  // §8.26-27
  show quote: it => {
    if it.body.has("text") and it.body.text.split().len() <= 40 {
      it
    } else {
      pad(left: 0.5in, {
        // for para in it.body.children {
        //   par(first-line-indent: 0.5in, para)
        // }
        it.body
      })
    }
  }


  // title page
  page({
    set align(center)
    v(4 * doublespace)
    block(spacing: 2em,
      text(weight: "bold", [
        #title
      ]
    ))
    hide(par[empty line])

    // §2.6
    let showAuthors = authors.map(it => {
      if type(it) == dictionary {
        it.name + super(it.at("affiliations", default: ()).sorted().map(str).join(","))
      } else {
        it
      }
    })

    // §2.5
    if authors.len() == 1 {
      showAuthors.first()
    } else if authors.len() == 2 {
      showAuthors.join(" and ")
    } else {
      showAuthors.join(", ", last: ", and ")
    }

    // §2.6
    if affiliations != none {
      parbreak()
      // include marks if authors have different affiliations
      let affiliationsWithMark = if differentAffiliations(authors) {
        affiliations.enumerate(start: 1).map(it =>
          [#super([#it.first()]) #it.last()]
        )
      } else {
        affiliations
      }
      for affiliation in affiliationsWithMark {
        par(affiliation)
      }
    }

    v(1fr)

    // §2.7
    if authorHasOrcid(authors) {
      par(text(weight: "bold")[Author Note])
      set align(left)
      for author in authors {
        if "orcid" in author {
          let url = "https://orcid.org/" + author.orcid
          par[
            #author.name
            #box(image("orcid-logo.svg", height: 0.8em))
            #url
          ]
        }
      }
    }
  })


  if abstract != none {
    show heading: it => {
      align(center, block(above: doublespace, below: doublespace, {
        text(fontsize.at(it.location()), weight: "bold")[#it.body]
      }))
    }
    heading(level: 1, supplement: [Abstract], "Abstract")
    abstract
    parbreak()
    if keywords != none {
      text(style: "italic")[Keywords: ]
      keywords.join(", ")
    }
    pagebreak()
  }

  heading(level: 1, title)
  body

}

// 2.13
#let showfootnotes = {
  pagebreak(weak: true)
  [= Footnotes]
  set par(first-line-indent: 0.5in)
  locate(loc => {
    for (i, note) in query(footnote, loc).enumerate(start: 1) {
      par[#super[#i] #note.body #lorem(20)]
    }
  })
}

#let appendix(body) = {
  pagebreak()

  show heading.where(supplement: [Appendix], level: 1): it => {
    pagebreak(weak: true)
    align(center, block(above: doublespace, below: doublespace, {
      text(fontsize.at(it.location()), weight: "bold")[
        #it.supplement
        #if it.numbering != none [
          #counter(heading).display()\
          #it.body
        ]
      ]
    }))
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(math.equation).update(0)
  }

  set heading(supplement: "Appendix", numbering: "A1")
  locate(loc => {
    let appendixSectionCount = query(selector(
      heading.where(supplement: [Appendix])
    ).after(loc), loc).len()
    if appendixSectionCount == 0 {
      heading(supplement: [Appendix], numbering: none, "")
    }
  })


  let numberByChapter(obj) = locate(loc => {
    let chapter = numbering("A", ..counter(heading).at(loc))
    [#chapter#numbering("1", obj)]
  })

  set figure(numbering: n => numberByChapter(n))
  set math.equation(numbering: n => numberByChapter(n))
  body
}
