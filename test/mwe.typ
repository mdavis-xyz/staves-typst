#import "/src/lib.typ": stave, arpeggio, clef-data

#set page(width: auto, height: auto, margin: 1pt)

Normal scale:


#stave("bass", "D", notes: ("C3", "D#3", "C3"), note-duration: "whole")
#stave("treble", "D", notes: ("C4", "C#4", "C5"), note-duration: "whole")
#stave("alto", "d", notes: ("C4", "D#4", "C5"), note-duration: "quarter")
#stave("tenor", "d", notes: ("Cn4", "C#4", "Cn5"), note-duration: "quarter")

#stave("treble", "D", notes: ("C4", "C#4", "Cn5"), note-duration: "quarter")

#stave("treble", "D", notes: ("C4", "C#4", "Cn5"), note-duration: "quarter", geometric-scale: 2)


Double scale:
#stave("treble", "4#", notes: ("C4", "E4", "F#4", "Cn5", "Cb6"), note-duration: "quarter", geometric-scale: 2)


Normal scale:
#stave("treble", "3#", notes: ("C4", "E4", "F#4", "Cn5", "Cb6"))

Double scale:
#stave("treble", "4#", notes: ("C4", "E4", "F#4", "Cn5", "Cb6"), note-duration: "quarter", geometric-scale: 2)
