#import "/lib.typ": key_signature, clef_data, symbol_data


= Staves

Author: Matthew Davis

This Typst package is used to draw musical key signatures.
For now, it cannot be used to write any notes.

#let examples = ()
#examples.push(
 key_signature("treble", "flat", 3, fixed_width: false)
)
#examples.push(
 key_signature("alto", "sharp", 4, fixed_width: false)
)

#examples.push(
 key_signature("bass", "sharp", 7, fixed_width: false)
)
 


#grid(
  columns: (1fr, 1fr, 1fr),
  align: center,
  column-gutter: 1em,
  row-gutter: 1em,
  ..examples
)

== Usage

The main function is called `key_signature`.

The arguments are:

/ clef: "#clef_data.keys().map(str).join("\", \"")"
/ symbol_name: "#symbol_data.keys().map(str).join("\", \"")"
/ num_symbols: 0 to 7
/ fixed_width: (optional) `true` or `false` (default)
/ scale: (optional) Number e.g. 0.5 or 2 to draw the content at half or double the size

Note that usage is based on the number of sharps/flats, not the key name.
For example, D major, in the Treble clef, has 2 sharps (F♯, C♯), so this is created with:

```example
#import "./lib.typ": key_signature

#figure(
  key_signature("treble", "sharp", 2),
  caption: [D Major]
)
```

#figure(
  key_signature("treble", "sharp", 2),
  caption: [D Major]
)

Drawing a treble clef above a bass clef, linked as a double-stave (like for a piano) is not yet supported.

The argument `fixed_width` is an optional argument, defaulting to `false`. If `false` (default), the stave lines will shrink/expand based on the number of sharps/flats.


#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: center,
  figure(
    key_signature("bass", "sharp", 1, fixed_width: true),
    caption: [`fixed_width: true`]
  ),
  figure(
    key_signature("bass", "sharp", 1, fixed_width: false),
    caption: [`fixed_width: false`]
  )
)

The `scale` argument can be used to adjust the size:


#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: horizon,
  figure(
    key_signature("bass", "sharp", 1, scale: 2),
    caption: [`scale: 2`]
  ),
  figure(
    key_signature("bass", "sharp", 1),
    caption: [default (omitted `scale`)]
  ),
  figure(
    key_signature("bass", "sharp", 1, scale: 0.5),
    caption: [`scale: 0.5`]
  )
)

== Full Reference

#let canvases = ()
#for symbol_name in symbol_data.keys() {
  for clef in clef_data.keys() {
    for num_symbols in range(0, 7) {
      canvases.push(key_signature(clef, symbol_name, num_symbols, fixed_width: false))
    }
  }
}

#grid(
  columns: 4,
  column-gutter: 1em,
  row-gutter: 1em,
  ..canvases
)
