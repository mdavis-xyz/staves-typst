#import "../src/lib.typ": *

#import "@preview/suiji:0.4.0": shuffle-f, gen-rng-f

#let line-sep = 0.2cm
#let major-scale = major-scale.with(line-sep: line-sep)
#let minor-scale = minor-scale.with(line-sep: line-sep)
#let arpeggio = arpeggio.with(line-sep: line-sep)
#let chromatic-scale = chromatic-scale.with(line-sep: line-sep)


#let capitalise-first-char(s) = {
  return upper(s.at(0)) + s.slice(1)
}

= Random Flute Scales

Playing C Major, C\# Major, then D Major etc is boring.
Here we generate a random list of scales, across keys and scale types.

// good for flute's range
#let start-octave = 4

#let scales = ()

#for k in key-data.at("major") {
  scales.push([
    == #k Major
    #major-scale("treble", k, start-octave, note-duration: "crotchet", notes-per-stave: 2 * num-letters-per-octave + 1, num-octaves: 2)
  ])
}

#for k in key-data.at("minor") {
  scales.push([
    == #capitalise-first-char(k) Harmonic Minor
    #minor-scale("treble", k, start-octave, minor-type: "harmonic", equal-note-head-space: true, note-duration: "crotchet", notes-per-stave: 2 * num-letters-per-octave + 1, num-octaves: 2)
  ])
}

#for k in key-data.at("major") {
  scales.push([
    == #k Major Arpeggio
    #arpeggio("treble", k, 4, num-octaves: 2, note-duration: "crotchet")
  ])
}

#for k in key-data.at("minor") {
  scales.push([
    == #capitalise-first-char(k) Minor Arpeggio

    #arpeggio("treble", k, 4, num-octaves: 2, note-duration: "crotchet")
  ])
}

#for side in allowed-sides {
  for k in all-notes-from-c.at(side) {
    scales.push([
      == #k Chromatic
      #chromatic-scale("treble", k, start-octave, num-octaves: 2, side: side, note-duration: "crotchet", notes-per-stave: semitones-per-octave + 1)
    ])
  }
}


#let rng = gen-rng-f(1902)
#let (rng, scales) = shuffle-f(rng, scales)

#let num-scales = 20

#for scale in scales.slice(0, num-scales) {
  scale
}
