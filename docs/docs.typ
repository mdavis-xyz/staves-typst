
#import "../src/data.typ": all-note-durations, all-clefs, minor-types, seventh-types, allowed-sides

= Staves Typst Package

Author: Matthew Davis

This Typst package is used to draw musical scales.

For now this is restricted to only one stave (set of 5 lines).
This package can be used to write arbitrary notes, but is not intended to be used for entire songs.

#let package-version = "0.1.0"
#let github-prefix = "https://raw.githubusercontent.com/mdavis-xyz/staves-typst/refs/heads/master/docs/"
#let import-prefix = "@preview/staves:" + package-version

#let example(path, caption, include-code: true, include-import: false) = {
  
  let code = read(path)

  let search = if include-import {"#import \".*\""} else {"#import \".*"} 
  let replace = if include-import {"#import \"" + import-prefix + "\""} else {""} 

  let code = code.replace(regex(search), replace).trim(at: start, repeat: true)

  if include-code {
    raw(code, lang: "typ", block: true)
  }

  assert(path.at(0) != "/", message: "Must use relative paths for Pandoc + Github conversion")
  let image-path = github-prefix + path.split(".").slice(0, -1).join(".").trim("./", at: start, repeat: false) + ".png"
  
  if (sys.inputs.at("render", default: "0") != "1") [
    #image(image-path, alt: caption)
  ] else [
    #figure(
      include(path),
      caption: [#caption]
    )
  ]
    
}

#example("./examples/D-major.typ", "D Major Scale", include-import: true)

#example("./examples/G-minor-arpeggio.typ", "G Minor Arpeggio", include-import: true)

#example("./examples/custom-notes.typ", "Custom Notes", include-import: true)


== Stave

The foundational function is called `stave`.
This is for writing just clefs, clefs and key signatures, or clefs, key signatures and custom notes.

=== Usage

#let double-sharp-inline = {
  if (sys.inputs.at("render", default: "0") != "1") [
    𝄪
  ] else [
    #box(height: 0.7em, image("/assets/accidental/double-sharp-x.svg", alt: "double-sharp x"))
  ]
}

The arguments are:

#let kwarg_defs = (
  "geometric-scale": [(optional) Number e.g. 0.5 or 2 to draw the content at half or double the size. This is about visual scale, not musical scales.],
  "note-duration": [(optional) Allowed values are "#all-note-durations.join("\", \"")". Default is "whole" note. All notes are the same duration.],
  "note-sep": [(optional) Used to adjust the horizontal spacing between notes. If you shrink below `note-sep: 0.7`, leger lines will overlap. At that point if it's still too big, use `geometric-scale` as well.],
  "equal-note-head-space": [`true` or `false`. Defaults to `true`. If true, note heads will be equally spaced. Some of this space will be taken up with accidentals. If `false`, adding an accidental to a note will shift the note head further right. `true` looks better (in my opinion), but `false` is useful in combination with the other spacing arguments, to avoid accidentals overlapping with previous note heads.]
)

/ `clef`: (Required) Allowed values are "#all-clefs.join("\", \"")". Drawing a treble clef above a bass clef, linked as a double-stave (like for a piano) is not yet supported.
/ `key`: (Required) Two possible forms. 
  - Letter based: Uppercase for major, lowercase for minor, with `#` or `b` appended. e.g. `"C"`, `"Db"`, `"f#"`
  - Number based, with a symbol: "5\#" (or "5s") for 5 sharps, "2b" for 2 flats
/ `notes`: An (optional) array of strings representing notes to play sequentially. Chords are not supported. e.g.
  - "C4" is middle C
  - "C5" is the C an octave above middle C. 
  - "Db4" or "C\#4" is a semitone above middle C
  - "B3" is a semitone below middle C
  - "Bn3" has an explicit natural accidental ♮ infront of it
  - "Fx3" is an F3 with a double sharp, drawn as an #double-sharp-inline (Formats such as "F\#\#3" to show ♯♯ are not supported yet.)
  - double flats are not yet supported.
#for (k, v) in kwarg_defs.pairs(){
  [
    / #raw(k): #v
  ]
}


=== Examples

To draw just a key signature, omit the `notes` argument

#example("./examples/D-major-key.typ", "D Major Key Signature", include-import: true)

Here is an example of including `notes`. Legerlines are supported.

#example("./examples/F-major-notes.typ", "F Major Fifths")

Note that accidentals are independent of the key signature. 
For the example of F major, the key contains B flat. A "B" note will be drawn with no accidental, so it is flattenned by the key signature. A "Bb" will have a redundant flat accidental drawn. "Bn" will have an explicit natural accidental.
This behavior may change in future versions.

#example("./examples/accidentals-and-key.typ", "Lack of interaction between accidentals and key signature")

The `note-duration` argument can be used to change the note symbol.

#let canvases = ()
#for note-duration in all-note-durations {
  canvases.push([
    #example(
      "./examples/note-durations-" + note-duration + ".typ", 
      "`note-duration`: " + note-duration,
      include-code: false)
  ])
}


#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: horizon,
  ..canvases
)


=== Spacing and Sizing

The `geometric-scale` argument can be used to adjust the overall size:


#grid(
  columns: (2fr, 1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: horizon,
  example("./examples/geometric-scale-2.typ", "`geometric-scale`: 2",
    include-code: false),
  example("./examples/geometric-scale-omitted.typ", "default (omitted `geometric-scale`)",
    include-code: false),
  example("./examples/geometric-scale-0-5.typ", "`geometric-scale`: 0.5",
    include-code: false)
)


`note-sep` can be used to adjust the horizontal separation between notes, whilst keeping the height of the stave the same:

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: horizon,
  example("./examples/note-sep-omitted.typ", "default (omitted `note-sep`)", include-code: false),
  example("./examples/note-sep-0-6.typ", "`note-sep`: 0.6", include-code: false)
)

`equal-note-head-space` is used to adjust the spacing based on whether there are accidentals.

#let canvases = ()

#let bool-to-string(b) = {
  ("false", "true").at(int(b))
}

#for e in (true, false) {
  canvases.push(
    example("./examples/equal-note-head-space-" + bool-to-string(e) + ".typ", "`equal-note-head-space` = " + bool-to-string(e),
    include-code: false
    )
  )
}


#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: horizon,
  ..canvases
)


== Major Scales

The `major-scale` function is for writing major scales.

=== Usage

/ `clef`: (Required) Allowed values are "#all-clefs.join("\", \"")". (Same as for `stave`.)
/ `key`: (Required) e.g. "A", "Bb", "C\#". Uppercase only.
/ `start-octave`: (Required) integer. e.g. 4 is the octave starting from middle C. 5 is the octave above that.
/ `num-octaves`: Optional, defaults to 1.
#for (k, v) in kwarg_defs.pairs(){
  [
    / #raw(k): #v
  ]
}

=== Examples

#example("./examples/D-major.typ", "D Major Scale", include-import: true)

You can write a 2 octave scale with `num-octaves: 2`.
This is probably too wide for your page. Shrink it horizontally with `note-sep`, or shrink in both dimensions with `geometric-scale`.

#example("./examples/F-major-shrunk.typ", "F Major Scale, shrunken to fit the page")


== Minor Scale

The `minor-scale` function is for writing natural and harmonic minor scales.
The usage is the same as for `major-scale`, plus an additional `minor-type` argument.


=== Usage

/ `clef`: (Required) Allowed values are "#all-clefs.join("\", \"")". (Same as for `stave`.)
/ `key`: (Required) e.g. "A", "Bb", "c\#". Uppercase or lowercase.
/ `start-octave`: (Required) integer. e.g. 4 is the octave starting from middle C. 5 is the octave above that.
/ `num-octaves`: Optional, defaults to 1.
/ `minor-type`: Defaults to "harmonic". Allowed values are "#minor-types.join("\", \"")". Melodic minor scales are not yet supported.
/ `seventh`: Where the raised seventh would be a double sharp, configure how it is shown. Allowed values are "#seventh-types.join("\", \"")". See examples below.
#for (k, v) in kwarg_defs.pairs(){
  [
    / #raw(k): #v
  ]
}

=== Examples

#example("./examples/D-harmonic-minor.typ", "D Harmonic Minor Scale", include-import: true)


#example("./examples/Bb-natural-minor.typ", "Bb Natural Minor Scale")

Note that for keys with a sharp, the raised 7th can be written as a double sharp, or a natural of the next note.

#example("./examples/Fs-harmonic-minor-n.typ", "F# Harmonic Minor scale with 7th written as F natural")

#example("./examples/Fs-harmonic-minor-x.typ", "F# Harmonic Minor scale with 7th written as E double sharp")


== Arpeggio

The `arpeggio` function is for writing arpeggios.

=== Usage

The arguments are the same as for `major-scale`.


/ `clef`: (Required) Allowed values are "#all-clefs.join("\", \"")". (Same as for `stave`.)
/ `key`: (Required) e.g. "A", "Bb", "C\#". Uppercase for major, lowercase for minor. Do not include a number for the octave.
/ `start-octave`: (Required) integer. e.g. 4 is the octave starting from middle C. 5 is the octave above that.
/ `num-octaves`: Optional, defaults to 1.
#for (k, v) in kwarg_defs.pairs(){
  [
    / #raw(k): #v
  ]
}

=== Example

#example("./examples/F-major-arpeggio.typ", "F Major Arpeggio")


== Chromatic Scales

`chromatic-scale` is used to write chromatic scales (every semitone between two notes).
The arguments are:

=== Usage

/ `clef`: (Required) Allowed values are "#all-clefs.join("\", \"")". (Same as for `stave`.)
/ `key`: (Required) e.g. "A", "Bb", "C\#". Uppercase for major, lowercase for minor. Do not include a number for the octave.
/ `start-octave`: (Required) integer. e.g. 4 is the octave starting from middle C. 5 is the 
/ `num-octaves`: Optional, defaults to 1.
/ `side`: "#allowed-sides.join("\", \"")"
#for (k, v) in kwarg_defs.pairs(){
  [
    / #raw(k): #v
  ]
}

These scales tend to be quite long, so you probably want to use `note-sep` and `geometric-scale`, and perhaps a landscape page.

=== Examples

#example("./examples/D-chromatic.typ", "D Chromatic Scale")

#example("./examples/F-chromatic.typ", "D Chromatic Scale")

== Implementation Details

This package uses a `canvas` from the #link("https://typst.app/universe/package/cetz", "CeTZ") package.

== License Details

This library uses SVG images for clefs, accidentals etc.
These files came from Wikipedia, and are in the public domain.
They are not covered by the same license as the rest of the package.
Source URLs for these SVGs are listed in #link("https://github.com/mdavis-xyz/staves-typst/tree/master/assets", `/assets/README.md`)
