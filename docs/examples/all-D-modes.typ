#import "../../src/lib.typ": mode-by-index, num-letters-per-octave

#for mode-index in range(1, num-letters-per-octave + 1) {
  mode-by-index("treble", "D", 4, mode-index)
}
