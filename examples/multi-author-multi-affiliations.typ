#import "../template.typ": apa7

#show: apa7.with(
  title: "Example of APA7 Document in Typst",
  authors: (
    (name: "Savannah C. St. John", affiliations: (1,)),
    (name: "Fen-Lei Chang", affiliations: (2, 3)),
    (name: "Carlos O. Vásquez", affiliations: (1,)),
  ),
  affiliations: (
    "Educational Testing Service, Princeton, New Jersey, United States",
    "MRC Cognition and Brain Sciences Unit, Cambridge, England",
    "Department of Psychology, University of Cambridge",
  ),
)

#lorem(40)

