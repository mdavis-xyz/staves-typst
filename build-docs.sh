#!/bin/bash

set -e
set -x

ROOT_DIR=$(pwd)

cd docs/examples

TEMP_SRC=$(pwd)/tmp.typ

for SRC in *.typ
do
    if [ "$SRC" != "$(basename "$TEMP_SRC")" ]; then
        echo Preparing $SRC
        # prepend the page settings
        echo "#set page(width: auto, height: auto, margin: 1pt)" > $TEMP_SRC
        echo "" >> $TEMP_SRC
        cat $SRC >> $TEMP_SRC

        for EXT in png #svg
        do
            DEST="${SRC%.typ}.$EXT"
            echo Converting $SRC to $DEST
            typst compile $TEMP_SRC $DEST --root $ROOT_DIR
        done
    fi
  
done

rm $TEMP_SRC

cd $ROOT_DIR
DOC_TYP_PATH="docs/docs.typ"
TOML_PATH="typst.toml"
PDF_PATH="docs/docs.pdf"
MD_PATH="docs/docs.md"

TYP_VERSION=$(grep '#let package-version = "' $DOC_TYP_PATH | sed 's/.*"\(.*\)".*/\1/')

# Extract version from typst.toml
TOML_VERSION=$(grep 'version = "' $TOML_PATH | sed 's/.*"\(.*\)".*/\1/')

if [ "$TYP_VERSION" = "$TOML_VERSION" ]; then
    echo "✓ Versions match: $TYP_VERSION"
else
    echo "✗ Version mismatch! In $DOC_TYP_PATH, version is $TYP_VERSION, but in $TOML_PATH it is $TOML_VERSION"
    exit 1
fi

# compile to PDF and MD

typst compile $DOC_TYP_PATH $PDF_PATH \
  --root $ROOT_DIR \
  --input render=1

pandoc $DOC_TYP_PATH \
	-o $MD_PATH \
	--resource-path=$ROOT_DIR \
    -f typst \
    -t gfm

# Pandoc doesn't compile perfectly
# e.g.
# / `something`: text
# converts with undesired newlines before the :
# Fix it manually with regex
# perl handles multiline regex better than sed

# if github flavoured markdown output from pandoc
perl -i -pe 'BEGIN{undef $/;} s/`([^`]+)`  \n/`$1`: /g' $MD_PATH
# if vanilla markdown
# perl -i -pe 'BEGIN{undef $/;} s/`([^`]+)`\s*\n\s*:\s*/- `$1`: /g' $MD_PATH

sed -i '/<!-- -->/d' $MD_PATH