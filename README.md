# Staves Typst Package

This Typst package is used to draw musical scales. (`@preview/staves`)

For now this is restricted to only one stave (set of lines).
This package can be used to write arbitrary notes, but is not intended to be used for entire songs.

<!-- Absolute path, so it will render on Typst's Universe website -->
![D Major Scale](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/master/examples/for-readme-1.png)

![G Minor Arpeggio](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/master/examples/for-readme-2.png)

![Custom Notes](https://raw.githubusercontent.com/mdavis-xyz/staves-typst/master/examples/for-readme-2.png)

## Usage

See [the `./docs` folder](docs).

## Contributing

The code of the library is within `src`. (See [`src/README.md`](src/README.md) for implementation details.)

Documentation is written in `docs/docs.typ`, which is compiled to PDF and markdown by `build-docs.sh`.

SVGs of notes and clefs are in `assets`.

## License Details

This library uses SVG images for clefs, accidentals etc.
These files came from Wikipedia, and are in the public domain.
They are not covered by the same license as the rest of the package.
Source URLs for these SVGs are listed in #link("https://github.com/mdavis-xyz/staves-typst/tree/master/assets", `/assets/README.md`)
