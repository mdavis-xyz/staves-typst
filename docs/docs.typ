#import "/src/lib.typ": key-signature, clef-data, symbol-data


= Staves

Author: Matthew Davis

This Typst package is used to draw musical key signatures.
For now, it cannot be used to write any notes.

#let examples = ()
#examples.push(
 key-signature("treble", "Eb", fixed-width: false)
)
#examples.push(
 key-signature("alto", "b", fixed-width: false)
)

#examples.push(
 key-signature("bass", "7#", fixed-width: false)
)
 


#grid(
  columns: (1fr, 1fr, 1fr),
  align: center,
  column-gutter: 1em,
  row-gutter: 1em,
  ..examples
)

== Usage

The main function is called `key-signature`.

The arguments are:

/ clef: "#clef-data.keys().map(str).join("\", \"")"
/ key: Two possible forms. 
  - Letter based: Uppercase for major, lowercase for minor, with `#` or `b` appended. e.g. `"C"`, `"Db"`, `"f#"`
  - Number based, with a symbol: "5#" for 5 sharps, "2b" for 2 flats
/ symbol-name: "#symbol-data.keys().map(str).join("\", \"")"
/ num-symbols: 0 to 7
/ fixed-width: (optional) `true` or `false` (default)
/ scale: (optional) Number e.g. 0.5 or 2 to draw the content at half or double the size

Note that usage is based on the number of sharps/flats, not the key name.
For example, D major, in the Treble clef, has 2 sharps (F♯, C♯), so this is created with:

```typst
#import "./lib.typ": key-signature

#figure(
  key-signature("treble", "D"),
  caption: [D Major]
)
```

#figure(
  key-signature("treble", "D"),
  caption: [D Major]
)

Drawing a treble clef above a bass clef, linked as a double-stave (like for a piano) is not yet supported.

The argument `fixed-width` is an optional argument, defaulting to `false`. If `false` (default), the stave lines will shrink/expand based on the number of sharps/flats.


#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: center,
  figure(
    key-signature("bass", "G", fixed-width: true),
    caption: [`fixed-width: true`]
  ),
  figure(
    key-signature("bass", "G", fixed-width: false),
    caption: [`fixed-width: false`]
  )
)

The `scale` argument can be used to adjust the size:


#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: horizon,
  figure(
    key-signature("bass", "F", scale: 2),
    caption: [`scale: 2`]
  ),
  figure(
    key-signature("bass", "F"),
    caption: [default (omitted `scale`)]
  ),
  figure(
    key-signature("bass", "F", scale: 0.5),
    caption: [`scale: 0.5`]
  )
)
