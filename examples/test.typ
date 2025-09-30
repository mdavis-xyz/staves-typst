#import "../src/lib.typ": *
#import "../src/utils.typ": *
#import "../src/core.typ": *



#for (mode-index, (mode-name, root-letter)) in zip(mode-names, all-letters-from-c).enumerate(start: 1) {
  [
    == #root-letter #mode-name: Mode #mode-index of C

    #mode-by-name("treble", root-letter, mode-name, 4)

  ]
} 

// #for key in key-data.major {
//   [= Key #key]
//   for (mode-index, (mode-name, root-letter)) in zip(mode-names, major-scale-notes(key)).enumerate(start: 1) {
    
//     [
//       == #root-letter #mode-name: Mode #mode-index of key #key

//       #mode-by-name("treble", root-letter, mode-name, 4)

//     ]
    
//   }
// }


