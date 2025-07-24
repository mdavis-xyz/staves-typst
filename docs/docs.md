# Staves Typst Package

Author: Matthew Davis

This Typst package is used to draw musical scales.

For now this is restricted to only one stave (set of 5 lines). This
package can be used to write arbitrary notes, but is not intended to be
used for entire songs.

``` typ
#import "@preview/staves:0.1.0": major-scale
#major-scale("treble", "D", 4)
```

![D Major
Scale](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/D-major.png)

``` typ
#import "@preview/staves:0.1.0": arpeggio
#arpeggio("bass", "g", 2, note-duration: "crotchet")
```

![G Minor
Arpeggio](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/G-minor-arpeggio.png)

``` typ
#import "@preview/staves:0.1.0": stave
#stave("alto", "c", notes: ("C3", "D#4", "F3"))
```

![Custom
Notes](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/custom-notes.png)

## Stave

The foundational function is called `stave`. This is for writing just
clefs, clefs and key signatures, or clefs, key signatures and custom
notes.

### Usage

The arguments are:

`clef`: (Required) Allowed values are “treble", "bass", "alto", "tenor”. Drawing
a treble clef above a bass clef, linked as a double-stave (like for a
piano) is not yet supported.

`key`: (Required) Two possible forms.

- Letter based: Uppercase for major, lowercase for minor, with `#` or
  `b` appended. e.g. `"C"`, `"Db"`, `"f#"`

- Number based, with a symbol: “5#” (or “5s”) for 5 sharps, “2b” for 2
  flats

`notes`: An (optional) array of strings representing notes to play sequentially.
Chords are not supported. e.g.

- “C4” is middle C

- “C5” is the C an octave above middle C.

- “Db4” or “C#4” is a semitone above middle C

- “B3” is a semitone below middle C

- “Bn3” has an explicit natural accidental ♮ infront of it

- “Fx3” is an F3 with a double sharp, drawn as an 𝄪

  (Formats such as “F##3” to show ♯♯ are not supported yet.)

- double flats are not yet supported.


`geometric-scale`: (optional) Number e.g. 0.5 or 2 to draw the content at half or double
the size. This is about visual scale, not musical scales.


`note-duration`: (optional) Allowed values are “whole", "quarter", "semibreve",
"crotchet”. Default is “whole” note. All notes are the same duration.


`note-sep`: (optional) Used to adjust the horizontal spacing between notes. If you
shrink below `note-sep: 0.7`, leger lines will overlap. At that point if
it’s still too big, use `geometric-scale` as well.


`equal-note-head-space`: `true` or `false`. Defaults to `true`. If true, note heads will be
equally spaced. Some of this space will be taken up with accidentals. If
`false`, adding an accidental to a note will shift the note head further
right. `true` looks better (in my opinion), but `false` is useful in
combination with the other spacing arguments, to avoid accidentals
overlapping with previous note heads.

### Examples

To draw just a key signature, omit the `notes` argument

``` typ
#import "@preview/staves:0.1.0": stave
#stave("treble", "D")
```

![D Major Key
Signature](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/D-major-key.png)

Here is an example of including `notes`. Legerlines are supported.

``` typ
#stave("treble", "F", notes: ("F4",  "C5", "F5", "C6", "F6", "C6", "F5", "C5", "F4"))
```

![F Major
Fifths](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/F-major-notes.png)

Note that accidentals are independent of the key signature. For the
example of F major, the key contains B flat. A “B” note will be drawn
with no accidental, so it is flattenned by the key signature. A “Bb”
will have a redundant flat accidental drawn. “Bn” will have an explicit
natural accidental. This behavior may change in future versions.

``` typ
#stave("bass", "F", notes: ("C2", "B2", "Bb2", "B2", "Bn2"))
```

![Lack of interaction between accidentals and key
signature](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/accidentals-and-key.png)

The `note-duration` argument can be used to change the note symbol.

|  |  |
|----|----|
| ![\`note-duration\`: whole](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/note-durations-whole.png) | ![\`note-duration\`: quarter](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/note-durations-quarter.png) |
| ![\`note-duration\`: semibreve](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/note-durations-semibreve.png) | ![\`note-duration\`: crotchet](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/note-durations-crotchet.png) |

### Spacing and Sizing

The `geometric-scale` argument can be used to adjust the overall size:

|  |  |  |
|----|----|----|
| ![\`geometric-scale\`: 2](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/geometric-scale-2.png) | ![default (omitted \`geometric-scale\`)](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/geometric-scale-omitted.png) | ![\`geometric-scale\`: 0.5](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/geometric-scale-0-5.png) |

`note-sep` can be used to adjust the horizontal separation between
notes, whilst keeping the height of the stave the same:

|  |  |
|----|----|
| ![default (omitted \`note-sep\`)](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/note-sep-omitted.png) | ![\`note-sep\`: 0.6](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/note-sep-0-6.png) |

`equal-note-head-space` is used to adjust the spacing based on whether
there are accidentals.

|  |  |
|----|----|
| ![\`equal-note-head-space\` = true](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/equal-note-head-space-true.png) | ![\`equal-note-head-space\` = false](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/equal-note-head-space-false.png) |

## Major Scales

The `major-scale` function is for writing major scales.

### Usage

`clef`: (Required) Allowed values are “treble", "bass", "alto", "tenor”. (Same
as for `stave`.)

`key`: (Required) e.g. “A”, “Bb”, “C#”. Uppercase only.

`start-octave`: (Required) integer. e.g. 4 is the octave starting from middle C. 5 is
the octave above that.

`num-octaves`: Optional, defaults to 1.


`geometric-scale`: (optional) Number e.g. 0.5 or 2 to draw the content at half or double
the size. This is about visual scale, not musical scales.


`note-duration`: (optional) Allowed values are “whole", "quarter", "semibreve",
"crotchet”. Default is “whole” note. All notes are the same duration.


`note-sep`: (optional) Used to adjust the horizontal spacing between notes. If you
shrink below `note-sep: 0.7`, leger lines will overlap. At that point if
it’s still too big, use `geometric-scale` as well.


`equal-note-head-space`: `true` or `false`. Defaults to `true`. If true, note heads will be
equally spaced. Some of this space will be taken up with accidentals. If
`false`, adding an accidental to a note will shift the note head further
right. `true` looks better (in my opinion), but `false` is useful in
combination with the other spacing arguments, to avoid accidentals
overlapping with previous note heads.

### Examples

``` typ
#import "@preview/staves:0.1.0": major-scale
#major-scale("treble", "D", 4)
```

![D Major
Scale](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/D-major.png)

You can write a 2 octave scale with `num-octaves: 2`. This is probably
too wide for your page. Shrink it horizontally with `note-sep`, or
shrink in both dimensions with `geometric-scale`.

``` typ
#major-scale("bass", "F", 2, num-octaves: 2, note-sep: 0.7, geometric-scale: 0.7)
```

![F Major Scale, shrunken to fit the
page](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/F-major-shrunk.png)

## Minor Scale

The `minor-scale` function is for writing natural and harmonic minor
scales. The usage is the same as for `major-scale`, plus an additional
`minor-type` argument.

### Usage

`clef`: (Required) Allowed values are “treble", "bass", "alto", "tenor”. (Same
as for `stave`.)

`key`: (Required) e.g. “A”, “Bb”, “c#”. Uppercase or lowercase.

`start-octave`: (Required) integer. e.g. 4 is the octave starting from middle C. 5 is
the octave above that.

`num-octaves`: Optional, defaults to 1.

`minor-type`: Defaults to “harmonic”. Allowed values are “natural", "harmonic”.
Melodic minor scales are not yet supported.

`seventh`: Where the raised seventh would be a double sharp, configure how it is
shown. Allowed values are “n", "x”. See examples below.


`geometric-scale`: (optional) Number e.g. 0.5 or 2 to draw the content at half or double
the size. This is about visual scale, not musical scales.


`note-duration`: (optional) Allowed values are “whole", "quarter", "semibreve",
"crotchet”. Default is “whole” note. All notes are the same duration.


`note-sep`: (optional) Used to adjust the horizontal spacing between notes. If you
shrink below `note-sep: 0.7`, leger lines will overlap. At that point if
it’s still too big, use `geometric-scale` as well.


`equal-note-head-space`: `true` or `false`. Defaults to `true`. If true, note heads will be
equally spaced. Some of this space will be taken up with accidentals. If
`false`, adding an accidental to a note will shift the note head further
right. `true` looks better (in my opinion), but `false` is useful in
combination with the other spacing arguments, to avoid accidentals
overlapping with previous note heads.

### Examples

``` typ
#import "@preview/staves:0.1.0": minor-scale
#minor-scale("treble", "D", 4)
```

![D Harmonic Minor
Scale](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/D-harmonic-minor.png)

``` typ
#minor-scale("bass", "Bb", 2, minor-type: "natural")
```

![Bb Natural Minor
Scale](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/Bb-natural-minor.png)

Note that for keys with a sharp, the raised 7th can be written as a
double sharp, or a natural of the next note.

``` typ
#minor-scale("treble", "F#", 4, seventh: "n")
```

![F# Harmonic Minor scale with 7th written as F
natural](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/Fs-harmonic-minor-n.png)

``` typ
#minor-scale("treble", "F#", 4, seventh: "x")
```

![F# Harmonic Minor scale with 7th written as E double
sharp](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/Fs-harmonic-minor-x.png)

## Arpeggio

The `arpeggio` function is for writing arpeggios.

### Usage

The arguments are the same as for `major-scale`.

`clef`: (Required) Allowed values are “treble", "bass", "alto", "tenor”. (Same
as for `stave`.)

`key`: (Required) e.g. “A”, “Bb”, “C#”. Uppercase for major, lowercase for
minor. Do not include a number for the octave.

`start-octave`: (Required) integer. e.g. 4 is the octave starting from middle C. 5 is
the octave above that.

`num-octaves`: Optional, defaults to 1.


`geometric-scale`: (optional) Number e.g. 0.5 or 2 to draw the content at half or double
the size. This is about visual scale, not musical scales.


`note-duration`: (optional) Allowed values are “whole", "quarter", "semibreve",
"crotchet”. Default is “whole” note. All notes are the same duration.


`note-sep`: (optional) Used to adjust the horizontal spacing between notes. If you
shrink below `note-sep: 0.7`, leger lines will overlap. At that point if
it’s still too big, use `geometric-scale` as well.


`equal-note-head-space`: `true` or `false`. Defaults to `true`. If true, note heads will be
equally spaced. Some of this space will be taken up with accidentals. If
`false`, adding an accidental to a note will shift the note head further
right. `true` looks better (in my opinion), but `false` is useful in
combination with the other spacing arguments, to avoid accidentals
overlapping with previous note heads.

### Example

``` typ
#arpeggio("bass", "F", 2, num-octaves: 2)
```

![F Major
Arpeggio](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/F-major-arpeggio.png)

## Chromatic Scales

`chromatic-scale` is used to write chromatic scales (every semitone
between two notes). The arguments are:

### Usage

`clef`: (Required) Allowed values are “treble", "bass", "alto", "tenor”. (Same
as for `stave`.)

`key`: (Required) e.g. “A”, “Bb”, “C#”. Uppercase for major, lowercase for
minor. Do not include a number for the octave.

`start-octave`: (Required) integer. e.g. 4 is the octave starting from middle C. 5 is
the

`num-octaves`: Optional, defaults to 1.

`side`: ”sharp", "flat”


`geometric-scale`: (optional) Number e.g. 0.5 or 2 to draw the content at half or double
the size. This is about visual scale, not musical scales.


`note-duration`: (optional) Allowed values are “whole", "quarter", "semibreve",
"crotchet”. Default is “whole” note. All notes are the same duration.


`note-sep`: (optional) Used to adjust the horizontal spacing between notes. If you
shrink below `note-sep: 0.7`, leger lines will overlap. At that point if
it’s still too big, use `geometric-scale` as well.


`equal-note-head-space`: `true` or `false`. Defaults to `true`. If true, note heads will be
equally spaced. Some of this space will be taken up with accidentals. If
`false`, adding an accidental to a note will shift the note head further
right. `true` looks better (in my opinion), but `false` is useful in
combination with the other spacing arguments, to avoid accidentals
overlapping with previous note heads.

These scales tend to be quite long, so you probably want to use
`note-sep` and `geometric-scale`, and perhaps a landscape page.

### Examples

``` typ
#chromatic-scale("treble", "D", 4, note-sep: 0.8, geometric-scale: 0.7)
```

![D Chromatic
Scale](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/D-chromatic.png)

``` typ
#chromatic-scale("bass", "G", 2, side: "flat", geometric-scale: 0.6, note-duration: "crotchet")
```

![G Chromatic
Scale](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/examples/G-chromatic.png)

## Constants

There are some constants which are exposed by the library. The
structure, value and presence of these should be considered unstable,
and is likely to change in fugure versions.

`all-clefs`: ("treble", "bass", "alto", "tenor")

`key-data`: (major: ("Cb", "Gb", "Db", "Ab", "Eb", "Bb", "F", "C", "G",
"D", "A", "E", "B", "F#", "C#"), minor: ("ab", "eb", "bb", "f", "c",
"g", "d", "a", "e", "b", "f#", "c#", "g#", "d#", "a#"))

`all-notes-from-c`: (sharp: ("C", "C#", "D", "D#", "E", "F", "F#", "G",
"G#", "A", "A#", "B"), flat: ("C", "Db", "D", "Eb", "E", "F", "Gb", "G",
"Ab", "A", "Bb", "B"))

`semitones-per-octave`: 12

`middle-c-octave`: 4

`all-letters-from-c`: ("C", "D", "E", "F", "G", "A", "B")

`num-letters-per-octave`: 7

## Setting Defaults

To set a default, such as the same `note-duration` for your whole
document, use [the with
approach](https://forum.typst.app/t/how-to-apply-set-rules-to-custom-functions/1657/2?u=mdavis_xyz)
(for each different scale type):

``` typ
#let major-scale = major-scale.with(note-duration: "crotchet")
#let minor-scale = minor-scale.with(note-duration: "crotchet")
```

## Implementation Details

This package uses a `canvas` from the
[CeTZ](https://typst.app/universe/package/cetz) package.

## License Details

This library uses SVG images for clefs, accidentals etc. These files
came from Wikipedia, and are in the public domain. They are not covered
by the same license as the rest of the package. Source URLs for these
SVGs are listed in
[`/assets/README.md`](https://github.com/mdavis-xyz/staves-typst/tree/master/assets)
