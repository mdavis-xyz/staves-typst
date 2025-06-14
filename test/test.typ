#import "/src/lib.typ": key-signature, clef-data, symbol-data, symbol-map, key-data

= Staves Tests

Generate some staves of each type

No symbols
#key-signature("treble", "C")
#key-signature("treble", "")
#key-signature("treble", none)

Major vs minor
#key-signature("treble", "F")
#key-signature("treble", "f")

All symbols
#for clef in clef-data.keys() {
  key-signature(clef, "C#")
  key-signature(clef, "Cb")
}

Using numbers

#key-signature("treble", "1#")
#key-signature("treble", "1b")
#key-signature("treble", "7#")
#key-signature("treble", "7b")

== Full Reference

== Numbers

#let canvases = ()
#for clef in clef-data.keys() {
  for num-symbols in range(0, 7) {
    for symbol-char in symbol-map.keys() {
      let key = str(num-symbols) + symbol-char
      canvases.push(key-signature(clef, key))
    }
  }
}

#grid(
  columns: 4,
  column-gutter: 1em,
  row-gutter: 1em,
  ..canvases
)


== Letters

#let canvases = ()
#for clef in clef-data.keys() {
  for tonality in ("major", "minor") {
    for key in key-data.at(tonality) {
        canvases.push([
          #key-signature(clef, key)
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