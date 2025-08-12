#import "../../src/lib.typ": stave

#let canvases = ()
#for line-sep in (0.2cm, 0.5cm) {
  canvases.push([
    #figure(
      stave("bass", "D", notes: ("D3", "G3", "A3"), line-sep: line-sep),
      caption: [`line-sep`: #line-sep.cm() cm]
    )
  ])
}


#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: horizon,
  ..canvases
)