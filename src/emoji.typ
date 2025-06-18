#import "data.typ": symbol-map, symbol-data

#let print-accidental(accidental) = {
  let symbol-name = symbol-map.at(accidental)
  let path = symbol-data.at(symbol-name).image
  return box(height: 0.8em, image(path))
}

#let sharp = print-accidental("#")
#let flat = print-accidental("b")
#let natural = print-accidental("n")
#let double-sharp = print-accidental("x")