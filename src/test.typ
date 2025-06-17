#import "utils.typ": *

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

  assert(determine-key("C").num-accidentals == 0)
  assert(determine-key("").num-accidentals == 0)
  assert(determine-key(none).num-accidentals == 0)
  assert(determine-key("Bb") == (num-accidentals: 2, symbol-type: "flat"))
  assert(determine-key("a#") == (num-accidentals: 7, symbol-type: "sharp"))
  assert(determine-key("3b") == (num-accidentals: 3, symbol-type: "flat"))
}

#let test-parse-note-string() = {
  assert(parse-note-string("Cb5") == letter-note("C", 5, accidental: "b"))
  assert(parse-note-string("A6") == letter-note("A", 6))
}

#let test-serialise-note() = {
  assert(serialise-note(letter-note("C", 5, accidental: "b")) == "Cb5")
  assert(serialise-note(letter-note("C", 5, accidental: "n"), suppress-natural: true) == "C5")
  assert(serialise-note(letter-note("C", 5, accidental: "n"), suppress-natural: false) == "Cn5")
}

#let test-accidental-string() = {
  assert(accidental-string("A", none) == "A")
  assert(accidental-string("B", "#") == "B#")
  assert(accidental-string("C", "n", suppress-natural: false) == "Cn")
  assert(accidental-string("D", "n", suppress-natural: true) == "D")
}

#let test-letter-to-index() = {
  assert(letter-to-index(letter-note("C", 4, accidental: none), "sharp").index == middle-c-index)
  assert(letter-to-index(letter-note("C", 5, accidental: none), "sharp").index == middle-c-index + semitones-per-octave)
  assert(letter-to-index(letter-note("C", 3, accidental: none), "sharp").index == middle-c-index - semitones-per-octave)
  assert(letter-to-index(letter-note("C", 4, accidental: "s"), "sharp").index == middle-c-index + 1)
  assert(letter-to-index(letter-note("B", 3, accidental: "n"), "sharp").index == middle-c-index - 1)
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

#let test-increment-note() = {
  // ignore accents
// just letters and octaves
  assert(increment-note("A", 4) == (letter: "B", octave: 4))
  assert(increment-note("B", 4) == (letter: "C", octave: 5))
  assert(increment-note("C", 5) == (letter: "D", octave: 5))
  assert(increment-note("G", 5) == (letter: "A", octave: 5))
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
  assert(actual.accidental == "#", message: "Got " + actual.accidental + "expected #")
  assert(actual.octave == 4)
}

#let unit-test() = {
  test-is-integer()
  test-determine-key()
  test-parse-note-string() 
  test-accidental-string()
  test-letter-to-index()
  test-serialise-note()
  test-index-to-letter()
  test-calc-note-height()
  test-increment-note()
  test-increment-letter()
  test-add-semitones()
}

