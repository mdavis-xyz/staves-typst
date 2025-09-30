#import "utils.typ": *
#import "data.typ": *
#import "core.typ": *

= Code Tests (Assertions)

#let test-is-integer() = {
  assert(is-integer("0"))
  assert(not is-integer("A"))
  assert(not is-integer(""))
  assert(not is-integer(none))

}

#let test-determine-key() = {
  // key can be:
// C -> C Major
// Bb -> Bb Major
// a# -> A# Minor
// bb -> Bb Minor
// none -> C Major
// "" (empty) -> C Major
// "3b" -> 3 flats (Eb Major)

  assert(determine-key("C").num-chromatics == 0)
  assert(determine-key("").num-chromatics == 0)
  assert(determine-key(none).num-chromatics == 0)
  assert(determine-key("Bb") == (num-chromatics: 2, symbol-type: "flat"))
  assert(determine-key("a#") == (num-chromatics: 7, symbol-type: "sharp"))
  assert(determine-key("3b") == (num-chromatics: 3, symbol-type: "flat"))
}

#let test-parse-note-string() = {
  assert(parse-note-string("Cb5") == letter-note("C", 5, accidental: "b"))
  assert(parse-note-string("A6") == letter-note("A", 6))
}

#let test-serialise-note() = {
  assert(serialise-note(letter-note("C", 5, accidental: "b")) == "Cb5")
  assert(serialise-note(letter-note("C", 5, accidental: "n"), suppress-natural: true) == "C5")
  assert(serialise-note(letter-note("C", 5, accidental: "n"), suppress-natural: false) == "Cn5")

  let actual = serialise-note(letter-note("C", 5), suppress-octave: true)
  let expected = "C"
  assert(actual == expected, message: "Expected " + expected + " got " + actual)
  assert(serialise-note(letter-note("C", 5, accidental: "#"), suppress-octave: true) == "C#")
}

#let test-side-from-accidental() = {
  assert(side-from-accidental("s") == "sharp")
  assert(side-from-accidental("#") == "sharp")
  assert(side-from-accidental("b") == "flat")
}

#let test-letter-and-accidental-str() = {
  assert(letter-and-accidental-str("A", none) == "A")
  assert(letter-and-accidental-str("B", "#") == "B#")
  assert(letter-and-accidental-str("C", "n", suppress-natural: false) == "Cn")
  assert(letter-and-accidental-str("D", "n", suppress-natural: true) == "D")
}

#let test-letter-to-index() = {
  assert(letter-to-index(letter-note("C", 4, accidental: none), side: "sharp").index == middle-c-index)
  assert(letter-to-index(letter-note("C", 5, accidental: none), side: "sharp").index == middle-c-index + semitones-per-octave)
  assert(letter-to-index(letter-note("C", 3, accidental: none), side: "sharp").index == middle-c-index - semitones-per-octave)
  assert(letter-to-index(letter-note("C", 4, accidental: "s"), side: "sharp").index == middle-c-index + 1)
  assert(letter-to-index(letter-note("C", 4, accidental: "s")).index == middle-c-index + 1)
  assert(letter-to-index(letter-note("B", 3, accidental: "n"), side: "sharp").index == middle-c-index - 1)

  // Cb4 is one semitone below middle C
  // even though it's lower than Cn, it's still the 4th octave, not 3rd.
  assert(letter-to-index(letter-note("C", middle-c-octave, accidental: "b")).index == middle-c-index - 1)
}

#let test-index-to-letter() = {
  let i = index-note(middle-c-index, "sharp")
  assert(i.index == middle-c-index)
  let actual = index-to-letter(i)

  assert(actual.letter == "C")
  assert(actual.accidental == none)
  assert(actual.octave == middle-c-octave)
  
  let expected = letter-note("C", 4, accidental: none)
  assert(actual == expected, message: serialise-note(actual) + " != " + serialise-note(expected))


  let i = index-note(middle-c-index + 1, "sharp")
  let actual = index-to-letter(i)
  assert(actual.letter == "C")
  assert(actual.accidental == "#")
  assert(actual.octave == middle-c-octave)
  
  let expected = letter-note("C", 4, accidental: "#")
  assert(actual == expected, message: serialise-note(actual) + " != " + serialise-note(expected))


  let i = index-note(middle-c-index - 2, "flat")
  let actual = index-to-letter(i)
  assert(actual.letter == "B", message: "actual.letter is " + actual.letter)
  assert(actual.accidental == "b")
  assert(actual.octave == middle-c-octave - 1)
  
  let expected = letter-note("B", 3, accidental: "b")
  assert(actual == expected, message: serialise-note(actual) + " != " + serialise-note(expected))



  let i = index-note(middle-c-index + 3 + semitones-per-octave, "sharp")
  let actual = index-to-letter(i)
  assert(actual.letter == "D", message: "actual.letter is " + actual.letter)
  assert(actual.accidental == "#")
  assert(actual.octave == middle-c-octave + 1)
  
  let expected = letter-note("D", 5, accidental: "#")
  assert(actual == expected, message: serialise-note(actual) + " != " + serialise-note(expected))
  
  
}

#let test-calc-note-height() = {
  assert(calc-note-height("treble", letter-note("C", 4)) == -1)
  assert(calc-note-height("treble", letter-note("F", 4)) == 0.5)
  assert(calc-note-height("treble", letter-note("B", 4)) == 2)
}


#let test-increment-letter() = {
  assert(increment-letter("A") == "B")
  assert(increment-letter("B") == "C")
  assert(increment-letter("G") == "A")
}

#let test-add-semitones() = {
  let actual = add-semitones("C", none, 4, steps: 1, side: "sharp")
  assert(actual.letter == "C")
  assert(actual.accidental != none)
  assert(actual.accidental == "#", message: "Got " + actual.accidental + " expected #")
  assert(actual.octave == 4)

  let actual = add-semitones("B", "b", 4, steps: 1, side: "flat")
  assert(actual.letter == "B", message: "Incrementing Bb gave " + serialise-note(actual))
  assert(actual.accidental == none)
  assert(actual.octave == 4)

  let actual = add-semitones("B", "b", 4, steps: 1, side: "sharp")
  assert(actual.letter == "B", message: "Incrementing Bb gave " + serialise-note(actual))
  assert(actual.accidental == none)
  assert(actual.octave == 4)

  // decrementing
  let actual = add-semitones("D", "#", 4, steps: -1, side: "sharp")
  assert(actual.letter == "D")
  assert(actual.accidental == none)
  assert(actual.octave == 4)

  let actual = add-semitones("D", none, 4, steps: -1, side: "sharp")
  assert(actual.letter == "C")
  assert(actual.accidental == "#")
  assert(actual.octave == 4)

  let actual = add-semitones("D", none, 4, steps: -1, side: "flat")
  assert(actual.letter == "D")
  assert(actual.accidental == "b")
  assert(actual.octave == 4)

  let actual = add-semitones("C", none, 4, steps: -1, side: "sharp")
  assert(actual.letter == "B")
  assert(actual.accidental == none)
  assert(actual.octave == 3)

  let actual = add-semitones("E", none, 5, steps: -3, side: "sharp")
  assert(actual.letter == "C")
  assert(actual.accidental == "#")
  assert(actual.octave == 5)

  let actual = add-semitones("C", "#", 3, steps: -3, side: "flat")
  assert(actual.letter == "B")
  assert(actual.accidental == "b")
  assert(actual.octave == 2)

}

#let test-set-accidental() = {
  assert(set-accidental(letter-note("C", 4), "#") == letter-note("C", 4, accidental: "#"))
  assert(set-accidental(letter-note("D", 5), "b") == letter-note("D", 5, accidental: "b"))
  assert(set-accidental(letter-note("F", 6), "n") == letter-note("F", 6, accidental: "n"))
}

#let test-increment-wholenote() = {
  let n = letter-note("C", 4)
  let expected = letter-note("D", 4)
  let actual = increment-wholenote(n)
  assert(expected == actual)

  let expected = letter-note("E", 4)
  let actual = increment-wholenote(n, steps: 2)
  assert(expected == actual)

  let expected = letter-note("C", 5)
  let actual = increment-wholenote(n, steps: 7)
  assert(expected == actual)

  let expected = letter-note("D", 5)
  let actual = increment-wholenote(n, steps: 8)
  assert(expected == actual)

  let expected = letter-note("B", 4)
  let actual = increment-wholenote(n, steps: 6)
  assert(expected == actual)

  let n = letter-note("B", 6)
  let expected = letter-note("D", 7)
  let actual = increment-wholenote(n, steps: 2)
  assert(expected == actual)
}

#let test-first-last() = {
  let arr = ("a", )
  let expected = ((true, true, "a"), )
  let actual = first-last(arr)
  assert(expected == actual)

  let arr = ("a", "b")
  let expected = ((true, false, "a"), (false, true, "b"))
  let actual = first-last(arr)
  assert(expected == actual)

  let arr = ("a", "b", "c")
  let expected = ((true, false, "a"), (false, false, "b"), (false, true, "c"))
  let actual = first-last(arr)
  assert(expected == actual)
}

#let test-remove-accidental() = {
  for a in symbol-map.keys() + (none,) {
    let start = (letter: "D", accidental: a, octave: 5, type: "letter-note")
    let expected = (letter: "D", accidental: none, octave: 5, type: "letter-note")
    let actual = remove-accidental(start)
    assert(expected == actual, message: "Did not remove accidental from " + serialise-note(start) + " got " + serialise-note(actual) + " instead of " + serialise-note(expected))
  }

  let actual = remove-accidental(parse-note-string("F#5"))
  let expected = parse-note-string("F5")
  assert(actual == expected)
}

#let test-is-natural-note-in-major-scale() = {
  assert(is-natural-note-in-major-scale("C", "C"))
  assert(not is-natural-note-in-major-scale("C", "C#"))
  assert(is-natural-note-in-major-scale("C", "Db"))
}

#let test-flip-side() = {
  assert(flip-side("sharp") == "flat")
  assert(flip-side("flat") == "sharp")
}

#let test-flip-accidental() = {
  let start = letter-note("C", 5, accidental: "s")
  let expected = letter-note("D", 5, accidental: "b")
  let actual = flip-accidental(start)
  assert(expected == actual)

  let start = letter-note("C", 5, accidental: "b")
  let expected = letter-note("B", 4)
  let actual = flip-accidental(start)
  assert(expected == actual)

  let start = letter-note("B", 5, accidental: "s")
  let expected = letter-note("C", 6)
  let actual = flip-accidental(start)
  assert(expected == actual)


  let start = letter-note("F", 5, accidental: "b")
  let expected = letter-note("E", 5)
  let actual = flip-accidental(start)
  assert(expected == actual)


}

#let test-all-letters-from() = {
  assert(all-letters-from("C") == all-letters-from-c)

  let expected = ("B", "C", "D", "E", "F", "G", "A")
  assert(all-letters-from("B") == expected)

  let expected = ("D", "E", "F", "G", "A", "B", "C")
  assert(all-letters-from("D") == expected)
}

#let test-major-scale-notes() = {
  let expected = all-letters-from-c
  let actual = major-scale-notes("C")
  assert(expected == actual, message: "Expected " + expected.join(", ") + " got " + actual.join(", "))

  let expected = ("F", "G", "A", "Bb", "C", "D", "E")
  let actual = major-scale-notes("F")
  assert(expected == actual, message: "Expected " + expected.join(", ") + " got " + actual.join(", "))

  let expected = ("G", "A", "B", "C", "D", "E", "F#")
  let actual = major-scale-notes("G")
  assert(expected == actual, message: "Expected " + expected.join(", ") + " got " + actual.join(", "))
}


#let unit-test() = {
  test-is-integer()
  test-determine-key()
  test-parse-note-string() 
  test-letter-and-accidental-str()
  test-side-from-accidental()
  test-letter-to-index()
  test-serialise-note()
  test-index-to-letter()
  test-calc-note-height()
  test-increment-letter()
  test-add-semitones()
  test-increment-wholenote()
  test-set-accidental()
  test-first-last()
  test-remove-accidental()
  test-is-natural-note-in-major-scale()
  test-flip-side()
  test-flip-accidental()
  test-all-letters-from()
  test-major-scale-notes()
}



#unit-test()

= Content Tests

= Key Signature Tests

Generate some staves of each type

No symbols
#stave("treble", "C")
#stave("treble", "")
#stave("treble", none)

Major vs minor
#stave("treble", "F")
#stave("treble", "f")

All symbols
#for clef in all-clefs {
  stave(clef, "C#")
  stave(clef, "Cb")
}

Using numbers

#stave("treble", "1#")
#stave("treble", "1b")
#stave("treble", "7#")
#stave("treble", "7b")

== Full Reference

=== Numbers

#let canvases = ()
#for clef in all-clefs {
  for num-symbols in range(0, 7) {
    for symbol-char in all-symbols {
      if symbol-char not in ("n", "x") {
        let key = str(num-symbols) + symbol-char
        canvases.push([
          stave(#clef,#key)
          #stave(clef, key)
        ])
      }
    }
  }
}

#grid(
  columns: 4,
  column-gutter: 1em,
  row-gutter: 1em,
  ..canvases
)


=== Letters

#let canvases = ()
#for clef in all-clefs {
  for tonality in ("major", "minor") {
    for key in key-data.at(tonality) {
        canvases.push([
          #stave(clef, key)
          #clef #key #tonality
        ])
    }    
  }
}

#grid(
  columns: 4,
  column-gutter: 1em,
  row-gutter: 1em,
  ..canvases
)

= Notes too

#stave("treble", "C", notes: ("C4", "Ds4", "E4", "F4", "G4", "A4", "B4", "C5"))

#let canvases = ()

#for clef in all-clefs {
  stave(clef, "C", notes: ("C2", "C3", "C4", "C5", "C6"))
}

= Arpeggios

#arpeggio(
  "treble",
  "D",
  5
)


#arpeggio(
  "treble",
  "D",
  5,
  note-duration: "crotchet"
)


= Minor Scales

#for key in key-data.at("minor") {
  for minor-type in minor-types {
    for seventh in seventh-types {
      figure(
        minor-scale("treble", key, 4, minor-type: minor-type, seventh: seventh),
        caption: [#key #minor-type Minor with seventh = #seventh]
      )
    }
  }
}

= Double sharp

#stave("treble", "C", notes: ("C5", "C#5", "Cx5"))