#import "/src/lib.typ": stave, arpeggio, all-clefs, _all-symbols, _key-data, _unit-test

#_unit-test()

= Key Signature Tests

Generate some staves of each type

No symbols
#stave("treble", "C")
#stave("treble", "")
#stave("treble", none)

Major vs minor
#stave("treble", "F")
#stave("treble", "f")

All symbols
#for clef in all-clefs {
  stave(clef, "C#")
  stave(clef, "Cb")
}

Using numbers

#stave("treble", "1#")
#stave("treble", "1b")
#stave("treble", "7#")
#stave("treble", "7b")

== Full Reference

=== Numbers

#let canvases = ()
#for clef in all-clefs {
  for num-symbols in range(0, 7) {
    for symbol-char in _all-symbols {
      if symbol-char != "n" {
        let key = str(num-symbols) + symbol-char
        canvases.push([
          stave(#clef,#key)
          #stave(clef, key)
        ])
      }
    }
  }
}

#grid(
  columns: 4,
  column-gutter: 1em,
  row-gutter: 1em,
  ..canvases
)


=== Letters

#let canvases = ()
#for clef in all-clefs {
  for tonality in ("major", "minor") {
    for key in _key-data.at(tonality) {
        canvases.push([
          #stave(clef, key)
          #clef #key #tonality
        ])
    }    
  }
}

#grid(
  columns: 4,
  column-gutter: 1em,
  row-gutter: 1em,
  ..canvases
)

= Notes too

#stave("treble", "C", notes: ("C4", "Ds4", "E4", "F4", "G4", "A4", "B4", "C5"))

#let canvases = ()

#for clef in all-clefs {
  stave(clef, "C", notes: ("C2", "C3", "C4", "C5", "C6"))
}

= Arpeggios

#arpeggio(
  "treble",
  "D",
  5
)


#arpeggio(
  "treble",
  "D",
  5,
  geometric-scale: 1.2,
  note-duration: "crotchet"
)