#import "../src/lib.typ": *

#import "@preview/suiji:0.4.0": shuffle-f, gen-rng-f


#let geometric-scale = 0.8

#let capitalise-first-char(s) = {
  return upper(s.at(0)) + s.slice(1)
}

= Random Flute Scales

Playing C Major, C\# Major, then D Major etc is boring.
Here we generate a random list of scales, across keys and scale types.

#let scales = ()

#for start-octave in (4, 5) {
  for k in key-data.at("major") {
    scales.push([
      == #k Major (octave #start-octave)
      #major-scale("treble", k, start-octave, geometric-scale: geometric-scale, note-duration: "crotchet")
    ])
  }

  for k in key-data.at("minor") {
    scales.push([
      == #capitalise-first-char(k) Harmonic Minor (octave #start-octave)
      #minor-scale("treble", k, start-octave, minor-type: "harmonic", geometric-scale: geometric-scale, equal-note-head-space: true, note-duration: "crotchet")
    ])
  }
}

#for k in key-data.at("major") {
  scales.push([
    == #k Major Arpeggio
    #arpeggio("treble", k, 4, geometric-scale: geometric-scale, num-octaves: 2,note-duration: "crotchet")
  ])
}

#for k in key-data.at("minor") {
  scales.push([
    == #capitalise-first-char(k) Minor Arpeggio

    #arpeggio("treble", k, 4, geometric-scale: geometric-scale, num-octaves: 2, note-duration: "crotchet")
  ])
}

#for start-octave in (4, 5) {
  for side in allowed-sides {
    for k in all-notes-from-c.at(side) {
      scales.push([
        == #k Chromatic (octave #start-octave)
        #chromatic-scale("treble", k, start-octave, geometric-scale: 0.6, num-octaves: 1, side: side, note-duration: "crotchet", note-sep: 0.7)
      ])
    }
  }
}


#let rng = gen-rng-f(1902)
#let (rng, scales) = shuffle-f(rng, scales)

#let num-scales = 20

#for scale in scales.slice(0, num-scales) {
  scale
}
