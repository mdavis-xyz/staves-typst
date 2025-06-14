#import "/src/lib.typ": stave, clef-data, symbol-data


= Staves

Author: Matthew Davis

This Typst package is used to draw musical key signatures and notes.
For now this is restricted to only one stave (set of lines).
This is useful mostly for writing scales.
This package cannot (easily) be used for writing whole songs, which require multiple staves.

#stave("treble", "Eb", notes: ("E4", "G4", "B4", "E5", "G5", "B5", "E6", "B5", "G5", "E5", "B4", "G4", "E4"))

#let examples = ()
#examples.push(
 stave("treble", "Eb")
)
#examples.push(
 stave("alto", "b")
)

#examples.push(
 stave("bass", "7#")
)
 


#grid(
  columns: (1fr, 1fr, 1fr),
  align: center,
  column-gutter: 1em,
  row-gutter: 1em,
  ..examples
)

== Usage

The main function is called `stave`.

The arguments are:

/ clef: "#clef-data.keys().map(str).join("\", \"")"
/ key: Two possible forms. 
  - Letter based: Uppercase for major, lowercase for minor, with `#` or `b` appended. e.g. `"C"`, `"Db"`, `"f#"`
  - Number based, with a symbol: "5#" for 5 sharps, "2b" for 2 flats
/ scale: (optional) Number e.g. 0.5 or 2 to draw the content at half or double the size

Note that usage is based on the number of sharps/flats, not the key name.
For example, D major, in the Treble clef, has 2 sharps (F♯, C♯), so this is created with:

```typst
#import "./lib.typ": stave

#figure(
  stave("treble", "D"),
  caption: [D Major]
)
```

#figure(
  stave("treble", "D"),
  caption: [D Major]
)

Drawing a treble clef above a bass clef, linked as a double-stave (like for a piano) is not yet supported.

The `scale` argument can be used to adjust the size:


#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: horizon,
  figure(
    stave("bass", "F", scale: 2),
    caption: [`scale: 2`]
  ),
  figure(
    stave("bass", "F"),
    caption: [default (omitted `scale`)]
  ),
  figure(
    stave("bass", "F", scale: 0.5),
    caption: [`scale: 0.5`]
  )
)
