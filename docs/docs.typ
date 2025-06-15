#import "/src/lib.typ": stave, arpeggio, clef-data, symbol-data, note-duration-data


= Staves

Author: Matthew Davis

This Typst package is used to draw musical key signatures and notes.
For now this is restricted to only one stave (set of lines).
This is useful mostly for writing scales.
This package cannot (easily) be used for writing whole songs, which require multiple staves.

#figure(
  stave("treble", "c", notes: ("C5", "D5", "E5", "F5", "G5", "An5", "Bn5", "C6", "Bb5", "Ab5", "G5", "F5", "E5", "D5", 
  "C5"), geometric-scale: 0.8),
  caption: [C Minor]
)

#figure(
  arpeggio("bass", "g", 2, note-duration: "crotchet", geometric-scale: 0.8),
  caption: [G Minor Arpeggio]
)


== Stave

=== Usage

The foundational function is called `stave`.

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
  
/ geometric-scale: (optional) Number e.g. 0.5 or 2 to draw the content at half or double the size. This is about visual scale, not musical scales.
/ note-duration: Allowed values are "#note-duration-data.keys().map(str).join("\", \"")". Default is "whole" note. All notes are the same duration.


=== Examples

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
  caption: [F Major Arpeggio]
)
```

#figure(
  stave("treble", "F", notes: ("F4", "A4", "C5", "F5", "A5", "C6", "F6", "C6", "A5", "F5", "C5", "A4", "F4")),
  caption: [F Major Arpeggio]
)

Note that accidentals are independent of the key signature. 
For the example of F major, the key contains B flat. A "B" note will be drawn with no accidental, so it is flattenned by the key signature. A "Bb" will have a redundant flat accidental drawn. "Bn" will have a natural accidental.


```typst
#figure(
  stave("bass", "F", notes: ("C2", "B2", "Bb2", "Bn2")),
  caption: [Lack of interaction between accidentals and key signature]
)
```

#figure(
  stave("bass", "F", notes: ("C2", "B2", "Bb2", "Bn2")),
  caption: [Lack of interaction between accidentals and key signature]
)


The `geometric-scale` argument can be used to adjust the size:


#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: horizon,
  figure(
    stave("bass", "F", notes: ("C#3",), geometric-scale: 2),
    caption: [`geometric-scale: 2`]
  ),
  figure(
    stave("bass", "F", notes: ("C#3",)),
    caption: [default (omitted `geometric-scale`)]
  ),
  figure(
    stave("bass", "F", notes: ("C#3",), geometric-scale: 0.5),
    caption: [`geometric-scale: 0.5`]
  )
)

The `note-duration` can be used to change the note symbol.

#let canvases = ()
#for note-duration in note-duration-data.keys() {
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

== Arpeggio

The `arpeggio` function is for writing arpeggios.

=== Usage

The arguments are:


/ clef: Allowed values are "#clef-data.keys().map(str).join("\", \"")". (Same as for `stave`.)
/ key: e.g. "A", "Bb", "C\#". Uppercase for major, lowercase for minor. Do not include a number for the octave.
/ start-octave: integer. e.g. 4 is the octave starting from middle C. 5 is the octave above that.
/ num-octaves: Optional, defaults to 1.
/ geometric-scale: Same as for `stave`.
/ note-duration: Same as for `stave`.

=== Example

```typst
#figure(
  arpeggio("bass", "F", 2, num-octaves: 2),
  caption: [F Major Arpeggio]
)
```
#figure(
  arpeggio("bass", "F", 2, num-octaves: 2),
  caption: [F Major Arpeggio]
)

== Implementation Details

This package uses a `canvas` from the #link("https://typst.app/universe/package/cetz", "CeTZ") package.