#import "../../src/lib.typ": stave, all-note-durations

#let canvases = ()
#for note-duration in all-note-durations {
  canvases.push([
    #figure(
      stave("treble", "C", notes: ("C5", "B4", "A4"), note-duration: note-duration),
      caption: [`note-duration`: #note-duration]
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