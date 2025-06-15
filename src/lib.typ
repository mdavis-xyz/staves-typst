#import "@preview/cetz:0.3.4"

// y height is defined as 0 = bottom line
// y=1, second-bottom line
// y=1.5 between 2nd-bottom and middle line

// reference for key order:
// sharps: https://music-theory-practice.com/images/order-of-sharps-staves.png
// flats: https://music-theory-practice.com/images/order-of-flats-staves.jpeg

#let clef-data = (
  treble: (
    clef: (
      image: "/assets/clefs/treble.svg",
      y-offset: 2,
      y-span: 2,
    ),
    c4: -1, // where is middle C?
    accidentals: (
      sharp: (4, 2.5, 3.5, 2, 3, 1.5, 2.5),
      flat: (2, 3.5, 1.5, 3, 1, 2.5, 0.5)
    )
  ),
  bass: (
    clef: (
      image: "/assets/clefs/bass.svg",
      y-offset: 2.4,
      y-span: 1,
    ),
    c4: 5, // where is middle C?
    accidentals: (
      sharp: (3, 1.5, 3.5, 2, 4, 2.5, 4.5),
      flat: (1, 2.5, 0.5, 2, 0, 1.5, -0.5)
    )
  ),
  alto: (
    clef: (
      image: "/assets/clefs/alto.svg",
      y-offset: 2,
      y-span: 1.2,
    ),
    c4: 2,
    accidentals: (
      sharp: (3.5, 2, 4, 2.5, 1, 3, 1.5),
      flat: (1.5, 3, 1, 2.5, 0.5, 2, 0)
    )
  ),
  tenor: (
    clef: (
      image: "/assets/clefs/alto.svg",
      y-offset: 3,
      y-span: 1.2,
    ),
    c4: 3,
    accidentals: (
      sharp: (1, 3, 1.5, 3.5, 2, 4, 2.5),
      flat: (2.5, 4, 2, 3.5, 1.5, 3, 1)
    )
  ),
)

#let symbol-data = (
  sharp: (
    image: "/assets/accidental/sharp.svg",
    y-offset: 0,
    y-span: 0.8
  ),
  flat: (
    image: "/assets/accidental/flat.svg",
    y-offset: 0.4,
    y-span: 0.6
  ),
  natural: (
    image: "/assets/accidental/natural.svg",
    y-offset: 0,
    y-span: 0.8
  )
)

#let key-data = (
  // write out the circle of fifths
  // from 7 flats, to C (nothing) to 7 sharps
  // correctness reference:
  // https://www.music-theory-for-musicians.com/staves.html
  major: (
    "Cb", "Gb", "Db", "Ab", "Eb", "Bb", "F",
    "C",
    "G", "D", "A", "E", "B", "F#", "C#"
  ),
  minor: (
    "ab", "eb", "bb", "f", "c", "g", "d", 
    "a",
    "e", "b", "f#", "c#", "g#", "d#", "a#"
    
  )
)

#let symbol-map = (
 "#": "sharp",
 "s": "sharp",
 "b": "flat",
 "n": "natural",
)


#let note-duration-data = (
  whole: (
    image: "/assets/notes/whole.svg",
    y-offset: 0, 
    y-span: 0.3,
    stem: false
  ),
  quarter: (
    image: "/assets/notes/crotchet-head.svg",
    y-offset: 0, 
    y-span: 0.3,
    width: 1.08,
    stem: true
  )
)

// add aliases
#note-duration-data.insert("semibreve", note-duration-data.at("whole"))
#note-duration-data.insert("crotchet", note-duration-data.at("quarter"))

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

#let all-notes-from-c = ("C", "D", "E", "F", "G", "A", "B")

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

#let stave(clef, key, notes: (), geometric-scale: 1, note-duration: "semibreve") = {

  // validate arguments
  assert(clef in clef-data.keys(), 
        message: "Invalid clef argument. Must be " + clef-data.keys().map(str).join(", "))

  assert(note-duration in note-duration-data.keys(),
         message: "Invalid note-duration argument. Must be " + note-duration-data.keys().map(str).join(", "))
        
  let result = determine-key(key)
  let num-accidentals = result.num-accidentals
  let symbol-type = result.symbol-type

  
  cetz.canvas(length: geometric-scale * 0.3cm, {
    import cetz.draw: line, content, rect

    let leger-line-width = 1.8
    let accidental-offset = leger-line-width / 2 + 0.35 // accidentals are this far left of notes
    let stem-length = 3 + 0.2 // don't make it an integer, it looks bad

    
    // note that x = x + 1
    // does not work in typst
    // so we do xs = (1, 2, 1)
    // and sum that array each time
    let clef-center-x = 2
    let xs = (clef-center-x, )
    

    let y = clef-data.at(clef).at("clef").at("y-offset")
  
    // clef
    content((xs.sum(), y ), [
      #image(clef-data.at(clef).at("clef").at("image"), height: (clef-data.at(clef).at("clef").at("y-span") ) * geometric-scale * 1cm)
    ], anchor: "center")

    xs.push(3)
    
    // sharps or flats
    for i in range(num-accidentals) {
      assert(symbol-type != "natural", message: "natural in key signature? " + key + " " + str(num-accidentals) + " " + symbol-type)
      let y = clef-data.at(clef).at("accidentals").at(symbol-type).at(i)
      
      content((xs.sum() , (y + symbol-data.at(symbol-type).at("y-offset")) ), [
        #image(symbol-data.at(symbol-type).at("image"), 
               height: (symbol-data.at(symbol-type).at("y-span") ) * geometric-scale * 1cm)
      ])
      xs.push(1)
    }

    // if there were any sharps or flats, add some extra space
    if num-accidentals > 0 {
      xs.push(1)
    }

    // draw our notes
    for (i, note-str) in notes.enumerate() {
      
      let note = parse-note-string(note-str)
      let note-height = calc-note-height(clef, note)


      let image-path = note-duration-data.at(note-duration).at("image")
    
      let x = xs.sum()
      let y = note-height + note-duration-data.at(note-duration).at("y-offset")
      let y-span = note-duration-data.at(note-duration).at("y-span")


      // leger lines
      let left-x = x - leger-line-width / 2
      let right-x = left-x + leger-line-width
      if note-height <= -1 {
        // leger lines below
        let leger-start = calc.trunc(note-height)
        let leger-end = -1
        for h in range(leger-start, leger-end + 1) {
          line((left-x , h ), (right-x , h ))
        }
      } else if note-height >= 5 {
        // leger lines above
        let leger-start = 5
        let leger-end = calc.trunc(note-height)
        for h in range(leger-start, leger-end + 1) {
          line((left-x , h ), (right-x , h ))
        }
      }

      // note head
      content((x , y ), [
        #image(image-path, 
               height: (y-span ) * geometric-scale * 1cm)
      ])

      // stem
      if note-duration-data.at(note-duration).at("stem") {
        let head-width = note-duration-data.at(note-duration).at("width")
        if y < 2 {
          // stem up on right
          line(
            (
              (x + head-width * 0.5) , 
              y 
            ), 
            (
              (x + head-width * 0.5)  , 
              (y + stem-length) 
            )
          )
        } else {
          // stem down on left
          line(
            (
              (x - head-width * 0.5) , 
              y 
            ), 
            (
              (x - head-width * 0.5)  , 
              (y - stem-length) 
            )
          )
        }
        
      }

      // accidentals
      if note.accidental != none {
        let accidental = symbol-data.at(symbol-map.at(note.accidental))
        let a-x = x - accidental-offset

        content(((x - accidental-offset) , (y + accidental.y-offset) ), [
            #image(accidental.image, 
                   height: (accidental.y-span ) * geometric-scale * 1cm)
        ])
        
      }

      xs.push(3) // space between notes
      
    }

    
    
    if notes.len() > 0 {
      // double bar at end
      let double-bar-sep = 0.5
      let double-bar-thick = 0.15
      let x = xs.sum()
      line((x, 0), (x, 4 ))
      xs.push(double-bar-sep + double-bar-thick)
      let x = xs.sum()
      rect((x, 0), (x - double-bar-thick, 4 ), fill: black)
    }

    // draw the 5 stave lines
    // left until last because only now do we know the total width
    let x = xs.sum()
    for i in range(5) {
      line((0, i ), (x, i ))
    }
    
  })
}

#let increment-note(letter, octave, steps: 1) = {
  if letter != upper(letter) {
    increment-note(upper(letter))
  }
  
  if letter == all-notes-from-c.at(-1) {
    let next-note = (
      letter: all-notes-from-c.at(0),
      octave: octave + 1
    )
    if steps > 1 {
      return increment-note(next-note.letter, next-note.octave, steps: steps - 1)
    } else {
      return next-note
    }
  } else{
    let next-note = (
      letter: all-notes-from-c.at(all-notes-from-c.position(x => x == letter) + 1),
      octave: octave
    )
    if steps > 1 {
      return increment-note(next-note.letter, next-note.octave, steps: steps - 1)
    } else {
      return next-note
    }
  }

  // typst is strange. It doesn't seem to understand when variables are defined in different branches of if statements
  // so copy-paste this part instead of factoring it out
  // if steps > 1 {
  //   return increment-note(next-note.letter, next-note.octave, steps: steps - 1)
  // } else {
  //   return next-note
  // }
}

#let arpeggio(clef, key, start-octave, num-octaves: 1, ..kwargs) = {
  // remove flat/sharp from key, append octave number
  let notes = ()
  let root-letter = upper(key.at(0))

  // ascent
  for ov in range(start-octave, start-octave + num-octaves) {
    // root
    notes.push(
      root-letter + str(ov)
    )
    // third
    let third-note = increment-note(root-letter, ov, steps: 2)
    notes.push(third-note.letter + str(third-note.octave))

    // fifth
    let fifth-note = increment-note(root-letter, ov, steps: 4)
    notes.push(fifth-note.letter + str(fifth-note.octave))
  }

  // peak
  notes.push(
   root-letter + str(start-octave + num-octaves)
  )

  // descent
  for ov in range(start-octave + num-octaves - 1, start-octave - 1, step: -1) {
   
    // fifth
    let fifth-note = increment-note(root-letter, ov, steps: 4)
    notes.push(fifth-note.letter + str(fifth-note.octave))

    // third
    let third-note = increment-note(root-letter, ov, steps: 2)
    notes.push(third-note.letter + str(third-note.octave))

    // root
    notes.push(
      root-letter + str(ov)
    )
    
  }
  
  let start-note = key.at(0) + str(start-octave)
  let end-note = key.at(0) + str(start-octave + num-octaves)
  stave(clef, key, notes: notes, ..kwargs)
}