#import "/src/lib.typ": stave, clef-data, symbol-data


= Staves

Author: Matthew Davis

This Typst package is used to draw musical key signatures and notes.
For now this is restricted to only one stave (set of lines).
This is useful mostly for writing scales.
This package cannot (easily) be used for writing whole songs, which require multiple staves.

#figure(
  stave("treble", "c", notes: ("C5", "D5", "E5", "F5", "G5", "An5", "Bn5", "C6", "Bb5", "Ab5", "G5", "F5", "E5", "D5", 
  "C5"), scale: 0.8),
  caption: [C Minor]
)


== Usage

The main function is called `stave`.

The arguments are:

/ clef: Allowed values are "#clef-data.keys().map(str).join("\", \"")". Drawing a treble clef above a bass clef, linked as a double-stave (like for a piano) is not yet supported.

/ key: Two possible forms. 
  - Letter based: Uppercase for major, lowercase for minor, with `#` or `b` appended. e.g. `"C"`, `"Db"`, `"f#"`
  - Number based, with a symbol: "5\#" (or "5s") for 5 sharps, "2b" for 2 flats
/ notes: An (optional) array of strings representing notes to play sequentially. Chords are not supported. e.g.
  - "C4" is middle C
  - "C5" is the C an octave above middle C. 
  - "Db4" or "C\#4" is a semitone above middle C
  - "B3" is a semitone below middle C
  - "Bn3" has an explicit natural accidental infront of it
  
  Notes will be drawn as semibreves (whole notes). Other forms, such as crotchets (quarter notes) are not yet supported.
  
/ scale: (optional) Number e.g. 0.5 or 2 to draw the content at half or double the size. This is about visual scale, not musical scales.

== Examples

To draw just a key signature, omit the `notes` argument

```typst
#import "./lib.typ": stave

#figure(
  stave("treble", "D"),
  caption: [D Major Key Signature]
)
```

#figure(
  stave("treble", "D"),
  caption: [D Major Key Signature]
)


Here is an example of including `notes`. Legerlines are supported.

```typst
#figure(
  stave("treble", "F", notes: ("F4", "A4", "C5", "F5", "C5", "A4", "F4")),
  caption: [F Major Arpegio]
)
```

#figure(
  stave("treble", "F", notes: ("F4", "A4", "C5", "F5", "A5", "C6", "F6", "C6", "A5", "F5", "C5", "A4", "F4")),
  caption: [F Major Arpegio]
)

Note that accidentals are independent of the key signature. 
For the example of F major, the key contains B flat. A "B" note will be drawn with no accidental, so it is flattenned by the key signature. A "Bb" will have a redundant flat accidental drawn. "Bn" will have a natural accidental.


#figure(
  stave("bass", "F", notes: ("C2", "B2", "Bb2", "Bn2")),
  caption: [Lack of interaction between accidentals and key signature]
)


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
