#import "../src/lib.typ": *

#let geometric-scale = 0.8

#let capitalise-first-char(s) = {
  return upper(s.at(0)) + s.slice(1)
}


#for k in ("G", "F", "E") {
  for side in allowed-sides {
  
    [
      #k Chromatic (#side)
    ]

    chromatic-scale("treble", k, 4, geometric-scale: 0.6, num-octaves: 1, side: side, note-duration: "crotchet", note-sep: 0.7)
  }
  
}