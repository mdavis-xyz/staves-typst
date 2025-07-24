#import "../src/lib.typ": *

#let geometric-scale = 0.8

#let capitalise-first-char(s) = {
  return upper(s.at(0)) + s.slice(1)
}

= Flute Scales

== Major Scales


#for k in key-data.at("major") {
  [#k Major]
  major-scale("treble", k, 4, geometric-scale: geometric-scale, note-duration: "crotchet")
}

== Harmonic Minor Scales

#for k in key-data.at("minor") {
  [=== #capitalise-first-char(k) Harmonic Minor]
  minor-scale("treble", k, 4, minor-type: "harmonic", geometric-scale: geometric-scale, equal-note-head-space: true, note-duration: "crotchet")
}


== Major Arpeggios

#for k in key-data.at("major") {
  [#k Major Arpeggio]
  arpeggio("treble", k, 4, geometric-scale: geometric-scale, num-octaves: 2, note-duration: "crotchet")
}

== Harmonic Arpeggios

#for k in key-data.at("minor") {
  [=== #capitalise-first-char(k) Minor Arpeggio]
  arpeggio("treble", k, 4, geometric-scale: geometric-scale, num-octaves: 2, note-duration: "crotchet")
}


== Chromatic Scales

#for side in allowed-sides {
  [=== Chromatic Scales (#side)]
  for k in all-notes-from-c.at(side) {
    [
      #k Chromatic
    ]
    chromatic-scale("treble", k, 4, geometric-scale: 0.6, num-octaves: 1, side: side, note-duration: "crotchet", note-sep: 0.7)
  }
}