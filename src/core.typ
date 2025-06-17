#import "@preview/cetz:0.3.4"

#import "data.typ": *
#import "utils.typ": *


#let stave(clef, key, notes: (), geometric-scale: 1, note-duration: "semibreve", note-sep: 1) = {

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


      // extra space if this is the first note and has an accidental
      if (note.accidental != none) and (i == 0) {
        xs.push(1)
      }
      
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

      if (i <= notes.len() - 2) {
        xs.push(note-sep * 3) // space between notes
      }

    }

    xs.push(2)

    
    
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

#let major-scale(clef, key, start-octave, num-octaves: 1, ..kwargs) = {
  // remove flat/sharp from key, append octave number
  let notes = ()
  let root-letter = upper(key.at(0))

  // ascent
  for steps in range(7 * num-octaves + 1) {
    let note = increment-note(root-letter, start-octave, steps: steps)
    notes.push(note.letter + str(note.octave))
  }

  // descent
  for steps in range(7 * num-octaves - 1, 0 - 1, step: -1) {
    let note = increment-note(root-letter, start-octave, steps: steps)
    notes.push(note.letter + str(note.octave))
  }


  let start-note = key.at(0) + str(start-octave)
  let end-note = key.at(0) + str(start-octave + num-octaves)

  stave(clef, key, notes: notes, ..kwargs)
}

#let chromatic-scale(clef, start-note, num-octaves: 1, side: "sharps", ..kwargs) = {
  if side == "sharp" {
    return chromatic-scale(clef, start-note, num-octaves: num-octaves, side: "sharps", ..kwargs)
  } else if side == "flat" {
    return chromatic-scale(clef, start-note, num-octaves: num-octaves, side: "flats", ..kwargs)
  }
  assert(side in ("sharps", "flats"), message: "side argument must be either sharps or flats")
  let start-note-parsed = parse-note-string(start-note)
  let notes = ()

  // ascent
  for i in range(12 * num-octaves + 1) {
    let note = add-semitones(start-note-parsed.letter, start-note-parsed.accidental, start-note-parsed.octave, steps: i, side: side)
    let a = if note.accidental == none {
      ""
    } else {
      note.accidental
    }
    notes.push(
      note.letter + a + str(note.octave)
    )
  }

  // descent
  for i in range(12 * num-octaves - 1 , 0 - 1, step: -1) {
    let note = add-semitones(start-note-parsed.letter, start-note-parsed.accidental, start-note-parsed.octave, steps: i, side: side)
    let a = if note.accidental == none {
      ""
    } else {
      note.accidental
    }
    notes.push(
      note.letter + a + str(note.octave)
    )
  }
  
  stave(clef, "C", notes: notes, ..kwargs)
}