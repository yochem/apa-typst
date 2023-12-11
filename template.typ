#let dictHasKey(dict, key) = {
  dict.at(key, default: none) != none
}

#let authorHasOrcid(authors) = authors.map(author =>
  if type(author) == dictionary and dictHasKey(author, "orcid") {
    true
  } else {
    false
  }
).contains(true)

#let differentAffiliations(authors) = authors.map(author =>
  if type(author) == dictionary and dictHasKey(author, "affiliations") {
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
  author-note: none,
  affiliations: none,
  keywords: none,
  abstract: none,
  titlepage-type: "professional",
  textsize: 12pt,
  authornote: none,
  body
) = {
  let warning = text.with(red, weight: "bold")
  let doublespace = 1.7em
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
    font: "Computer Modern",
    lang: "en",
    size: textsize,
    hyphenate: false // §2.23
  )
  set page(
    numbering: "1",
    paper: "a4",
    header: header,
    header-ascent: doublespace,
    footer: "",
    margin: (top: 1in + doublespace, rest: 1in), // §2.22
  )

  // §2.27
  show heading: text.with(textsize, weight: "bold")
  show heading: set block(above: doublespace, below: doublespace)

  show heading.where(level: 1): align.with(center)
  show heading.where(level: 3): text.with(style: "italic")

  show heading.where(level: 4): it => {
    box(it.body + [.])
  }
  show heading.where(level: 5): it => {
    set text(style: "italic")
    box(it.body + [.])
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
    v(doublespace)

    let showAuthors = if differentAffiliations(authors) {
      authors.map(it =>
        if type(it) == dictionary {
          it.name + super(it.affiliations.sorted().map(str).join(","))
        } else {
          it
        }
      )
    } else {
      authors
    }
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

    set par(first-line-indent: 0.5in, leading: doublespace) // §2.21
    // §2.7
    if authorHasOrcid(authors) {
      par(text(weight: "bold")[Author Note])
      set align(left)
      for author in authors {
        if dictHasKey(author, "orcid") {
          let url = "https://orcid.org/" + author.orcid
          par[
            #author.name
            #box(image("orcid-logo.svg", height: 0.8em))
            #url
          ]
        }
      }
    }
    // if authorHasNewAffiliation(authors) {
    //   block(text(weight: "bold")[Author Note])
    //   set align(left)
    //   for author in authors {
    //     if dictHasKey(author, "newAffiliation") {
    //       par[#h(0.5in)#author.name is now at #affiliations.at]
    //     }
    //   }
    //   [test]
    // }
  })
  set par(first-line-indent: 0.5in, leading: doublespace) // §2.21


  if abstract != none {
    heading(level: 1, "Abstract")
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
