#import "@preview/cetz:0.3.4"

// reference for key order:
// sharps: https://music-theory-practice.com/images/order-of-sharps-key-signatures.png
// flats: https://music-theory-practice.com/images/order-of-flats-key-signatures.jpeg

#let clef_data = (
  treble: (
    clef: (
      image: "assets/clefs/treble.svg",
      y_offset: 2,
      y_span: 50
      
    ),
    accidentals: (
      sharp: (4, 2.5, 3.5, 2, 3, 1.5, 2.5),
      flat: (2, 3.5, 1.5, 3, 1, 2.5, 0.5)
    )
  ),
  bass: (
    clef: (
      image: "assets/clefs/bass.svg",
      y_offset: 2.4,
      y_span: 25
      
    ),
    accidentals: (
      sharp: (3, 1.5, 3.5, 2, 4, 2.5, 4.5),
      flat: (1, 2.5, 0.5, 2, 0, 1.5, -0.5)
    )
  ),
  alto: (
    clef: (
      image: "assets/clefs/alto.svg",
      y_offset: 2,
      y_span: 31
      
    ),
    accidentals: (
      sharp: (3.5, 2, 4, 2.5, 1, 3, 1.5),
      flat: (1.5, 3, 1, 2.5, 0.5, 2, 0)
    )
  ),
  tenor: (
    clef: (
      image: "assets/clefs/alto.svg",
      y_offset: 3,
      y_span: 31
      
    ),
    accidentals: (
      sharp: (1, 3, 1.5, 3.5, 2, 4, 2.5),
      flat: (2.5, 4, 2, 3.5, 1.5, 3, 1)
    )
  ),
)

#let symbol_data = (
  sharp: (
    image: "assets/accidental/sharp.svg",
    y_offset: 0,
    y_span: 20
  ),
  flat: (
    image: "assets/accidental/flat.svg",
    y_offset: 0.4,
    y_span: 15
  )
)

// clef is treble, bass, alto or teonr
// symbol_type is sharp or flat
// num_symbols is an integer 0 to 7: how many sharps/flats
// scale is an optional float, e.g. 0.5 to halve the size compared to default
// fixed_width: 
//    true means the length of the stave will be constant regardless of the number of sharps/flats
//    false means it is shorter for fewer sharps/flats (no wasted space)
#let key_signature(clef, symbol_type, num_symbols, scale: 1, fixed_width: false) = {

  // validate arguments
  assert(clef in clef_data.keys(), 
        message: "Invalid clef argument. Must be " + clef_data.keys().map(str).join(", "))
  assert(symbol_type in symbol_data.keys(), 
        message: "Invalid symbol_type argument. Must be " + symbol_data.keys().map(str).join(", "))
  assert(type(num_symbols) == int, 
         message: "num_symbols must be an integer")
  assert(num_symbols >= 0 and num_symbols <= 7, 
         message: "num_symbols must be between 0 and 7")
    
  cetz.canvas(length: 3cm, {
    import cetz.draw: line, content

    let line_sep = 0.1  * scale
    
    let width = 1.2 * scale  
    if not fixed_width {
      width = 0.4 * scale
      if num_symbols > 0 {
        width = 0.4 * scale + (num_symbols + 1) * line_sep
      }
    }
    
    
    // draw the 5 stave lines
    for i in range(5) {
      line((0, i * line_sep), (width, i * line_sep))
    }
  
    // clef
    content((2 * line_sep, clef_data.at(clef).at("clef").at("y_offset") * line_sep), [
      #image(clef_data.at(clef).at("clef").at("image"), height: (clef_data.at(clef).at("clef").at("y_span") * line_sep) * 1em)
    ], anchor: "center")
  
    // sharps or flats
    for i in range(num_symbols) {
      let y = clef_data.at(clef).at("accidentals").at(symbol_type).at(i)
      content(((5 + i) * line_sep, (y + symbol_data.at(symbol_type).at("y_offset")) * line_sep), [
        #image(symbol_data.at(symbol_type).at("image"), 
               height: (symbol_data.at(symbol_type).at("y_span") * line_sep) * 1em)
      ])
    }
  
    
  })
}
  