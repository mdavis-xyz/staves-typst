#import "@preview/cetz:0.3.4"

// reference for key order:
// sharps: https://music-theory-practice.com/images/order-of-sharps-key-signatures.png
// flats: https://music-theory-practice.com/images/order-of-flats-key-signatures.jpeg

#let clef-data = (
  treble: (
    clef: (
      image: "/assets/clefs/treble.svg",
      y-offset: 2,
      y-span: 50
      
    ),
    accidentals: (
      sharp: (4, 2.5, 3.5, 2, 3, 1.5, 2.5),
      flat: (2, 3.5, 1.5, 3, 1, 2.5, 0.5)
    )
  ),
  bass: (
    clef: (
      image: "/assets/clefs/bass.svg",
      y-offset: 2.4,
      y-span: 25
      
    ),
    accidentals: (
      sharp: (3, 1.5, 3.5, 2, 4, 2.5, 4.5),
      flat: (1, 2.5, 0.5, 2, 0, 1.5, -0.5)
    )
  ),
  alto: (
    clef: (
      image: "/assets/clefs/alto.svg",
      y-offset: 2,
      y-span: 31
      
    ),
    accidentals: (
      sharp: (3.5, 2, 4, 2.5, 1, 3, 1.5),
      flat: (1.5, 3, 1, 2.5, 0.5, 2, 0)
    )
  ),
  tenor: (
    clef: (
      image: "/assets/clefs/alto.svg",
      y-offset: 3,
      y-span: 31
      
    ),
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
    y-span: 20
  ),
  flat: (
    image: "/assets/accidental/flat.svg",
    y-offset: 0.4,
    y-span: 15
  )
)

#let key-data = (
  // write out the circle of fifths
  // from 7 flats, to C (nothing) to 7 sharps
  // correctness reference:
  // https://www.music-theory-for-musicians.com/key-signatures.html
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
 "b": "flat"
)


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
     num-symbols: 0,
     symbol-type: "sharp"
   )
 } else if is-integer(key.at(0)) {
   // e.g. "5#"
   let num-symbols = int(key.at(0))
   let symbol-char = key.at(1)
   assert(symbol-char in symbol-map.keys(), message: "number-based key argument must end with " + symbol-data.keys().map(str).join(" or "))
   let symbol-type = symbol-map.at(symbol-char)
   (
     num-symbols: num-symbols,
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
   
   let num-symbols = calc.abs(this-key-index - mid-index)
   let symbol-type = if this-key-index >= mid-index { "sharp" } else { "flat" }
   
   (
     num-symbols: num-symbols,
     symbol-type: symbol-type
   )
 }
}


#let key-signature(clef, key, scale: 1, fixed-width: false) = {

  // validate arguments
  assert(clef in clef-data.keys(), 
        message: "Invalid clef argument. Must be " + clef-data.keys().map(str).join(", "))

  let result = determine-key(key)
  let num-symbols = result.num-symbols
  let symbol-type = result.symbol-type
  
  cetz.canvas(length: 3cm, {
    import cetz.draw: line, content

    let line-sep = 0.1  * scale
    
    let width = 1.2 * scale  
    if not fixed-width {
      width = 0.4 * scale
      if num-symbols > 0 {
        width = 0.4 * scale + (num-symbols + 1) * line-sep
      }
    }
    
    
    // draw the 5 stave lines
    for i in range(5) {
      line((0, i * line-sep), (width, i * line-sep))
    }
  
    // clef
    content((2 * line-sep, clef-data.at(clef).at("clef").at("y-offset") * line-sep), [
      #image(clef-data.at(clef).at("clef").at("image"), height: (clef-data.at(clef).at("clef").at("y-span") * line-sep) * 1em)
    ], anchor: "center")
  
    // sharps or flats
    for i in range(num-symbols) {
      let y = clef-data.at(clef).at("accidentals").at(symbol-type).at(i)
      content(((5 + i) * line-sep, (y + symbol-data.at(symbol-type).at("y-offset")) * line-sep), [
        #image(symbol-data.at(symbol-type).at("image"), 
               height: (symbol-data.at(symbol-type).at("y-span") * line-sep) * 1em)
      ])
    }
  
    
  })
}