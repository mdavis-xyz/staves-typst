#import "/src/lib.typ": stave, major-scale, arpeggio, chromatic-scale

#set page(width: auto, height: auto, margin: 1pt)

#chromatic-scale("treble", "C#4", side: "sharp", num-octaves: 2)

Normal scale:

#major-scale("treble", "C", 4, num-octaves: 3, note-sep: 0.8, geometric-scale: 0.5)

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
