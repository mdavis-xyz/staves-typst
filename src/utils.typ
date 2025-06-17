#import "data.typ": *

#let is-integer(char) = {
 let digits = ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
 char in digits
}

// key can be:
// C -> C Major
// Bb -> Bb Major
// a# -> A# Minor
// bb -> Bb Minor
// "" (empty) -> C Major
// "3b" -> 3 flats (Eb Major)
#let determine-key(key) = {
 if key == none or key == "" {
   // empty key
   (
     num-accidentals: 0,
     symbol-type: "sharp"
   )
 } else if is-integer(key.at(0)) {
   // e.g. "5#"
   let num-accidentals = int(key.at(0))
   let symbol-char = key.at(1)
   assert(symbol-char in symbol-map.keys(), message: "number-based key argument must end with " + symbol-data.keys().map(str).join(" or "))
   let symbol-type = symbol-map.at(symbol-char)
   (
     num-accidentals: num-accidentals,
     symbol-type: symbol-type
   )
 } else {
   // e.g. "Fb"
   let this-key-index
   let mid-index
   
   if key in key-data.major {
     this-key-index = key-data.major.position(k => k == key)
     mid-index = key-data.major.position(k => k == "C")
   } else if key in key-data.minor {
     this-key-index = key-data.minor.position(k => k == key)
     mid-index = key-data.minor.position(k => k == "a")
   } else {
     panic("Invalid key: " + key)
   }
   
   let num-accidentals = calc.abs(this-key-index - mid-index)
   let symbol-type = if this-key-index >= mid-index { "sharp" } else { "flat" }
   
   (
     num-accidentals: num-accidentals,
     symbol-type: symbol-type
   )
 }
}

// takes in a string
// returns a dictionary
// e.g. "Cb5" => {"letter": "C", "accidental": "b", octave: 5}
// e.g. "A6" => {"letter": "C", "accidental": "n", octave: 5}
// accidental defaults to n, for "natural"
#let parse-note-string(note) = {
  if note.len() < 2 or note.len() > 3 {
    panic("Invalid note format: " + note)
  }
  
  let letter = note.at(0)
  let octave-result = int(note.slice(-1))
  if octave-result == none {
    panic("Unable to parse octave integer from note: " + note)
  }
  let octave = octave-result
  
  let accidental = if note.len() == 3 {
    note.at(1)
  } else {
    none
  }
  
  (
    letter: letter,
    accidental: accidental,
    octave: octave
  )
}


// e.g. for clef: "treble", note-letter: "C4", height is -1
// e.g. for clef: "treble", note-letter: "F4", height is +0.5
// e.g. for clef: "treble", note-letter: "B4", height is +2
// Note that the integer changes at C, not A
// e.e.g B4, C5, D5 are consecutive
#let calc-note-height(clef, note) = {

  // find difference in letters above/below C
  // typst is zero-index based
  let notes-above-c = all-notes-from-c.position(n => n == note.letter)
  
  let c4-height = clef-data.at(clef).at("c4")

  // now calculate height
  c4-height + (note.octave - 4) * all-notes-from-c.len() * 0.5 + notes-above-c * 0.5
}


// ignore accents
// just letters and octaves
#let increment-note(letter, octave, steps: 1) = {
  if letter != upper(letter) {
    increment-note(upper(letter))
  }

  if steps == 0 {
    return (
      letter: letter,
      octave: octave
    )
  }else if steps < 0 {
    panic("Decrementing notes not supported")
  } else if steps >= 7 {
    // skip a whole octave at a time
    // for performance reasons
    return increment-note(letter, octave + 1, steps: steps - 7)
  }

  let next-note = none
  if letter == all-notes-from-c.at(-1) {
    next-note = (
      letter: all-notes-from-c.at(0),
      octave: octave + 1
    )
    
  } else{
    next-note = (
      letter: all-notes-from-c.at(all-notes-from-c.position(x => x == letter) + 1),
      octave: octave
    )
  }

  if steps > 1 {
    return increment-note(next-note.letter, next-note.octave, steps: steps - 1)
  } else {
    return next-note
  }

}


// A -> B -> C ... G -> A
#let increment-letter(letter) = {
  let start-index = all-notes-from-c.position(x => x == letter)
  let next-index = calc.rem-euclid(start-index + 1, all-notes-from-c.len())
  return all-notes-from-c.at(next-index)
}

#let add-semitones(start-letter, start-accidental, start-octave, steps: 1, side: "sharps") = {
  if steps == 0 {
    return (
      letter: start-letter,
      accidental: start-accidental,
      octave: start-octave
    )
  } else if steps >= 12 {
    // skip a whole octave at a time
    // for performance reasons
    return add-semitones(start-letter, start-accidental, start-octave + 1, steps: steps - 12, side: side)
  } else if steps < 0 {
    panic("Decrementing by semitone not supported")
  } else if start-letter == "B" {
    // increment octave number when going from B to C
    return add-semitones("C", none, start-octave + 1, steps: steps - 1, side: side)
  } else if start-accidental == "b" {
    // remove the flat
    assert(side == "flats", message: "Cannot start with flats for sharp incrementing")
    return add-semitones(start-letter, none, start-octave, steps: steps - 1, side: side)
    
  } else if start-accidental in ("n", "", none) {
    if start-letter in ("B", "E") {
        // this note has no sharp, go to next white note
        return add-semitones(increment-letter(start-letter), none, start-octave, steps: steps - 1, side: side)
    } else if side == "sharps" {
      // sharpen this note
      return add-semitones(start-letter, "s", start-octave, steps: steps - 1, side: side)
    } else { // flats
      assert(side == "flats", message: "unknown side: " + side)
      // flatten the next note
      return add-semitones(increment-letter(start-letter), "b", start-octave, steps: steps - 1, side: side)
    }
  } else {
    assert(start-accidental in ("s", "#"), message: "Unknown accidental: " + start-accidental)
    assert(side == "sharps", message: "Cannot mix sharp notes and not sharp side")

    return add-semitones(increment-letter(start-letter), none, start-octave, steps: steps - 1, side: side)
  }
}