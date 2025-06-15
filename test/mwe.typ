#import "/src/lib.typ": stave, arpeggio

#set page(width: auto, height: auto, margin: 1pt)

#stave("treble", "3#", notes: ("C4", "E4", "F#4", "Cn5", "Cb6"))

#stave("treble", "4#", notes: ("C4", "E4", "F#4", "Cn5", "Cb6"), note-duration: "quarter", geometric-scale: 2)

#arpeggio("treble", "F", 4, num-octaves: 2)
#arpeggio("treble", "G", 4, num-octaves: 2)
#arpeggio("treble", "A", 4, num-octaves: 2)
#arpeggio("treble", "b", 4, num-octaves: 2)

