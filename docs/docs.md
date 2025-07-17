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

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/D-major.png" /></p>
<figcaption><p>D Major Scale</p></figcaption>
</figure>

``` typ
#import "@preview/staves:0.1.0": arpeggio
#arpeggio("bass", "g", 2, note-duration: "crotchet")
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/G-minor-arpeggio.png" /></p>
<figcaption><p>G Minor Arpeggio</p></figcaption>
</figure>

``` typ
#import "@preview/staves:0.1.0": stave
#stave("alto", "c", notes: ("C3", "D#4", "F3"))
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/custom-notes.png" /></p>
<figcaption><p>Custom Notes</p></figcaption>
</figure>

## Stave

The foundational function is called `stave`. This is for writing just
clefs, clefs and key signatures, or clefs, key signatures and custom
notes.

### Usage

The arguments are:

`clef`

:   Allowed values are "treble\", \"bass\", \"alto\", \"tenor". Drawing
    a treble clef above a bass clef, linked as a double-stave (like for
    a piano) is not yet supported.

`key`

:   Two possible forms.

    - Letter based: Uppercase for major, lowercase for minor, with `#`
      or `b` appended. e.g. `"C"`, `"Db"`, `"f#"`

    - Number based, with a symbol: "5#" (or "5s") for 5 sharps, "2b" for
      2 flats

`notes`

:   An (optional) array of strings representing notes to play
    sequentially. Chords are not supported. e.g.

    - "C4" is middle C

    - "C5" is the C an octave above middle C.

    - "Db4" or "C#4" is a semitone above middle C

    - "B3" is a semitone below middle C

    - "Bn3" has an explicit natural accidental ♮ infront of it

    - "Fx3" is an F3 with a double sharp, drawn as an
      [![](/assets/accidental/double-sharp-x.svg)]{.box} (Formats such
      as "F##3" to show ♯♯ are not supported yet.)

    - double flats are not yet supported.

<!-- -->

`geometric-scale`

:   (optional) Number e.g. 0.5 or 2 to draw the content at half or
    double the size. This is about visual scale, not musical scales.

<!-- -->

`note-duration`

:   (optional) Allowed values are "whole\", \"quarter\", \"semibreve\",
    \"crotchet". Default is "whole" note. All notes are the same
    duration.

<!-- -->

`note-sep`

:   (optional) Used to adjust the horizontal spacing between notes. If
    you shrink below `note-sep: 0.7`, leger lines will overlap. At that
    point if it's still too big, use `geometric-scale` as well.

<!-- -->

`equal-note-head-space`

:   `true` or `false`. Defaults to `true`. If true, note heads will be
    equally spaced. Some of this space will be taken up with
    accidentals. If `false`, adding an accidental to a note will shift
    the note head further right. `true` looks better (in my opinion),
    but `false` is useful in combination with the other spacing
    arguments, to avoid accidentals overlapping with previous note
    heads.

### Examples

To draw just a key signature, omit the `notes` argument

``` typ
#import "@preview/staves:0.1.0": stave
#stave("treble", "D")
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/D-major-key.png" /></p>
<figcaption><p>D Major Key Signature</p></figcaption>
</figure>

Here is an example of including `notes`. Legerlines are supported.

``` typ
#stave("treble", "F", notes: ("F4",  "C5", "F5", "C6", "F6", "C6", "F5", "C5", "F4"))
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/F-major-notes.png" /></p>
<figcaption><p>F Major Fifths</p></figcaption>
</figure>

Note that accidentals are independent of the key signature. For the
example of F major, the key contains B flat. A "B" note will be drawn
with no accidental, so it is flattenned by the key signature. A "Bb"
will have a redundant flat accidental drawn. "Bn" will have an explicit
natural accidental. This behavior may change in future versions.

``` typ
#stave("bass", "F", notes: ("C2", "B2", "Bb2", "B2", "Bn2"))
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/accidentals-and-key.png" /></p>
<figcaption><p>Lack of interaction between accidentals and key
signature</p></figcaption>
</figure>

The `note-duration` argument can be used to change the note symbol.

+----------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------+
| <figure>                                                                                                                         | <figure>                                                                                                                        |
| <p><img                                                                                                                          | <p><img                                                                                                                         |
| src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/note-durations-whole.png" /></p>     | src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/note-durations-quarter.png" /></p>  |
| <figcaption><p>`note-duration`: whole</p></figcaption>                                                                           | <figcaption><p>`note-duration`: quarter</p></figcaption>                                                                        |
| </figure>                                                                                                                        | </figure>                                                                                                                       |
+----------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------+
| <figure>                                                                                                                         | <figure>                                                                                                                        |
| <p><img                                                                                                                          | <p><img                                                                                                                         |
| src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/note-durations-semibreve.png" /></p> | src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/note-durations-crotchet.png" /></p> |
| <figcaption><p>`note-duration`: semibreve</p></figcaption>                                                                       | <figcaption><p>`note-duration`: crotchet</p></figcaption>                                                                       |
| </figure>                                                                                                                        | </figure>                                                                                                                       |
+----------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------+

### Spacing and Sizing

The `geometric-scale` argument can be used to adjust the overall size:

+---------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------+
| <figure>                                                                                                                  | <figure>                                                                                                                        | <figure>                                                                                                                    |
| <p><img                                                                                                                   | <p><img                                                                                                                         | <p><img                                                                                                                     |
| src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/geometric-scale-2.png" /></p> | src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/geometric-scale-omitted.png" /></p> | src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/geometric-scale-0-5.png" /></p> |
| <figcaption><p>`geometric-scale`: 2</p></figcaption>                                                                      | <figcaption><p>default (omitted `geometric-scale`)</p></figcaption>                                                             | <figcaption><p>`geometric-scale`: 0.5</p></figcaption>                                                                      |
| </figure>                                                                                                                 | </figure>                                                                                                                       | </figure>                                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------+

`note-sep` can be used to adjust the horizontal separation between
notes, whilst keeping the height of the stave the same:

+--------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``` typ                                                                                                                  | ``` typ                                                                                                              |
| #stave("bass", "G", notes: ("C3", "D3", "C3"))                                                                           | #stave("bass", "G", notes: ("C3", "D3", "C3"), note-sep: 0.6)                                                        |
| ```                                                                                                                      | ```                                                                                                                  |
|                                                                                                                          |                                                                                                                      |
| <figure>                                                                                                                 | <figure>                                                                                                             |
| <p><img                                                                                                                  | <p><img                                                                                                              |
| src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/note-sep-omitted.png" /></p> | src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/note-sep-0-6.png" /></p> |
| <figcaption><p>default (omitted `note-sep`)</p></figcaption>                                                             | <figcaption><p>`note-sep`: 0.6</p></figcaption>                                                                      |
| </figure>                                                                                                                | </figure>                                                                                                            |
+--------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+

`equal-note-head-space` is used to adjust the spacing based on whether
there are accidentals.

+------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| ``` typ                                                                                                                            | ``` typ                                                                                                                             |
| #stave("treble", "C", notes: ("C5", "C#5", "D5", "D#5"), equal-note-head-space: true)                                              | #stave("treble", "C", notes: ("C5", "C#5", "D5", "D#5"), equal-note-head-space: false)                                              |
| ```                                                                                                                                | ```                                                                                                                                 |
|                                                                                                                                    |                                                                                                                                     |
| <figure>                                                                                                                           | <figure>                                                                                                                            |
| <p><img                                                                                                                            | <p><img                                                                                                                             |
| src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/equal-note-head-space-true.png" /></p> | src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/equal-note-head-space-false.png" /></p> |
| <figcaption><p>`equal-note-head-space` = true</p></figcaption>                                                                     | <figcaption><p>`equal-note-head-space` = false</p></figcaption>                                                                     |
| </figure>                                                                                                                          | </figure>                                                                                                                           |
+------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+

## Major Scales

The `major-scale` function is for writing major scales.

### Usage

`clef`

:   Allowed values are "treble\", \"bass\", \"alto\", \"tenor". (Same as
    for `stave`.)

`key`

:   e.g. "A", "Bb", "C#". Uppercase only.

`start-octave`

:   integer. e.g. 4 is the octave starting from middle C. 5 is the
    octave above that.

`num-octaves`

:   Optional, defaults to 1.

<!-- -->

`geometric-scale`

:   (optional) Number e.g. 0.5 or 2 to draw the content at half or
    double the size. This is about visual scale, not musical scales.

<!-- -->

`note-duration`

:   (optional) Allowed values are "whole\", \"quarter\", \"semibreve\",
    \"crotchet". Default is "whole" note. All notes are the same
    duration.

<!-- -->

`note-sep`

:   (optional) Used to adjust the horizontal spacing between notes. If
    you shrink below `note-sep: 0.7`, leger lines will overlap. At that
    point if it's still too big, use `geometric-scale` as well.

<!-- -->

`equal-note-head-space`

:   `true` or `false`. Defaults to `true`. If true, note heads will be
    equally spaced. Some of this space will be taken up with
    accidentals. If `false`, adding an accidental to a note will shift
    the note head further right. `true` looks better (in my opinion),
    but `false` is useful in combination with the other spacing
    arguments, to avoid accidentals overlapping with previous note
    heads.

### Examples

``` typ
#import "@preview/staves:0.1.0": major-scale
#major-scale("treble", "D", 4)
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/D-major.png" /></p>
<figcaption><p>D Major Scale</p></figcaption>
</figure>

You can write a 2 octave scale with `num-octaves: 2`. This is probably
too wide for your page. Shrink it horizontally with `note-sep`, or
shrink in both dimensions with `geometric-scale`.

``` typ
#major-scale("bass", "F", 2, num-octaves: 2, note-sep: 0.7, geometric-scale: 0.7)
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/F-major-shrunk.png" /></p>
<figcaption><p>F Major Scale, shrunken to fit the page</p></figcaption>
</figure>

## Minor Scale

The `minor-scale` function is for writing natural and harmonic minor
scales. The usage is the same as for `major-scale`, plus an additional
`minor-type` argument.

### Usage

`clef`

:   Allowed values are "treble\", \"bass\", \"alto\", \"tenor". (Same as
    for `stave`.)

`key`

:   e.g. "A", "Bb", "c#". Uppercase or lowercase.

`start-octave`

:   integer. e.g. 4 is the octave starting from middle C. 5 is the
    octave above that.

`num-octaves`

:   Optional, defaults to 1.

`minor-type`

:   Defaults to "harmonic". Allowed values are "natural\", \"harmonic".
    Melodic minor scales are not yet supported.

`seventh`

:   Where the raised seventh would be a double sharp, configure how it
    is shown. Allowed values are "n\", \"x". See examples below.

<!-- -->

`geometric-scale`

:   (optional) Number e.g. 0.5 or 2 to draw the content at half or
    double the size. This is about visual scale, not musical scales.

<!-- -->

`note-duration`

:   (optional) Allowed values are "whole\", \"quarter\", \"semibreve\",
    \"crotchet". Default is "whole" note. All notes are the same
    duration.

<!-- -->

`note-sep`

:   (optional) Used to adjust the horizontal spacing between notes. If
    you shrink below `note-sep: 0.7`, leger lines will overlap. At that
    point if it's still too big, use `geometric-scale` as well.

<!-- -->

`equal-note-head-space`

:   `true` or `false`. Defaults to `true`. If true, note heads will be
    equally spaced. Some of this space will be taken up with
    accidentals. If `false`, adding an accidental to a note will shift
    the note head further right. `true` looks better (in my opinion),
    but `false` is useful in combination with the other spacing
    arguments, to avoid accidentals overlapping with previous note
    heads.

### Examples

``` typ
#import "@preview/staves:0.1.0": minor-scale
#minor-scale("treble", "D", 4)
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/D-harmonic-minor.png" /></p>
<figcaption><p>D Harmonic Minor Scale</p></figcaption>
</figure>

``` typ
#minor-scale("bass", "Bb", 2, minor-type: "natural")
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/Bb-natural-minor.png" /></p>
<figcaption><p>Bb Natural Minor Scale</p></figcaption>
</figure>

Note that for keys with a sharp, the raised 7th can be written as a
double sharp, or a natural of the next note.

``` typ
#minor-scale("treble", "F#", 4, seventh: "n")
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/Fs-harmonic-minor-n.png" /></p>
<figcaption><p>F# Harmonic Minor scale with 7th written as F
natural</p></figcaption>
</figure>

``` typ
#minor-scale("treble", "F#", 4, seventh: "x")
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/Fs-harmonic-minor-x.png" /></p>
<figcaption><p>F# Harmonic Minor scale with 7th written as E double
sharp</p></figcaption>
</figure>

## Arpeggio

The `arpeggio` function is for writing arpeggios.

### Usage

The arguments are the same as for `major-scale`.

`clef`

:   Allowed values are "treble\", \"bass\", \"alto\", \"tenor". (Same as
    for `stave`.)

`key`

:   e.g. "A", "Bb", "C#". Uppercase for major, lowercase for minor. Do
    not include a number for the octave.

`start-octave`

:   integer. e.g. 4 is the octave starting from middle C. 5 is the
    octave above that.

`num-octaves`

:   Optional, defaults to 1.

<!-- -->

`geometric-scale`

:   (optional) Number e.g. 0.5 or 2 to draw the content at half or
    double the size. This is about visual scale, not musical scales.

<!-- -->

`note-duration`

:   (optional) Allowed values are "whole\", \"quarter\", \"semibreve\",
    \"crotchet". Default is "whole" note. All notes are the same
    duration.

<!-- -->

`note-sep`

:   (optional) Used to adjust the horizontal spacing between notes. If
    you shrink below `note-sep: 0.7`, leger lines will overlap. At that
    point if it's still too big, use `geometric-scale` as well.

<!-- -->

`equal-note-head-space`

:   `true` or `false`. Defaults to `true`. If true, note heads will be
    equally spaced. Some of this space will be taken up with
    accidentals. If `false`, adding an accidental to a note will shift
    the note head further right. `true` looks better (in my opinion),
    but `false` is useful in combination with the other spacing
    arguments, to avoid accidentals overlapping with previous note
    heads.

### Example

``` typ
#arpeggio("bass", "F", 2, num-octaves: 2)
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/F-major-arpeggio.png" /></p>
<figcaption><p>F Major Arpeggio</p></figcaption>
</figure>

## Chromatic Scales

`chromatic-scale` is used to write chromatic scales (every semitone
between two notes). The arguments are:

### Usage

`clef`

:   Allowed values are "treble\", \"bass\", \"alto\", \"tenor". (Same as
    for `stave`.)

`start-note`

:   e.g. "C4" for middle C, "C5" for the C above that, "Db4" for a
    semitone above middle C

`num-octaves`

:   Optional, defaults to 1.

`side`

:   "sharp\", \"flat"

<!-- -->

`geometric-scale`

:   (optional) Number e.g. 0.5 or 2 to draw the content at half or
    double the size. This is about visual scale, not musical scales.

<!-- -->

`note-duration`

:   (optional) Allowed values are "whole\", \"quarter\", \"semibreve\",
    \"crotchet". Default is "whole" note. All notes are the same
    duration.

<!-- -->

`note-sep`

:   (optional) Used to adjust the horizontal spacing between notes. If
    you shrink below `note-sep: 0.7`, leger lines will overlap. At that
    point if it's still too big, use `geometric-scale` as well.

<!-- -->

`equal-note-head-space`

:   `true` or `false`. Defaults to `true`. If true, note heads will be
    equally spaced. Some of this space will be taken up with
    accidentals. If `false`, adding an accidental to a note will shift
    the note head further right. `true` looks better (in my opinion),
    but `false` is useful in combination with the other spacing
    arguments, to avoid accidentals overlapping with previous note
    heads.

These scales tend to be quite long, so you probably want to use
`note-sep` and `geometric-scale`, and perhaps a landscape page.

### Examples

``` typ
#chromatic-scale("treble", "D4", note-sep: 0.8, geometric-scale: 0.7)
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/D-chromatic.png" /></p>
<figcaption><p>D Chromatic Scale</p></figcaption>
</figure>

``` typ
#chromatic-scale("bass", "F2", side: "flat", geometric-scale: 0.6, note-duration: "crotchet")
```

<figure>
<p><img
src="https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/./examples/F-chromatic.png" /></p>
<figcaption><p>D Chromatic Scale</p></figcaption>
</figure>

## Implementation Details

This package uses a `canvas` from the
[CeTZ](https://typst.app/universe/package/cetz) package.

## License Details

This library uses SVG images for clefs, accidentals etc. These files
came from Wikipedia, and are in the public domain. They are not covered
by the same license as the rest of the package. Source URLs for these
SVGs are listed in
[`/assets/README.md`](https://github.com/mdavis-xyz/staves-typst/tree/master/assets)
