#!/bin/bash

# bash-novel-compiler
# Compile an organized collection of Markdown files to various formats
# appropriate for sharing.
#
# Copyright (C) 2024  Nate Fodge
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>

# Information about the book
readonly  BOOK_TITLE="Book Title"
readonly  BOOK_AUTHOR_FIRST="First"
readonly  BOOK_AUTHOR_LAST="Last"

# Formatting options
readonly SCENE_SEPARATOR="* * *"

# Set desired output format (will be reworked later)
output_format="pdf"

# File locations
readonly BOOK_DIR="$(pwd)"
readonly OUTPUT_DIR="$BOOK_DIR/exports"
readonly TYPST_FILE="$OUTPUT_DIR/book.typ"

# Create the output directory if it doesn't exist.
if [[ ! -d "$OUTPUT_DIR" ]]; then
  mkdir -p "$OUTPUT_DIR"
fi

# Remove the old TYPST_FILE if it exists.
rm -f $TYPST_FILE

# Make sure a template file (.bnct) was provided
if [[ -z "$1" ]]; then
  echo "ERROR:  No template file was provided."
  echo "        Please provide a template file as the first argument."
  echo "        Example: bnc.sh manuscript.bnct"
  exit 1
fi

readonly TEMPLATE="$1"

# Set up the header in the $TYPST_FILE
echo "#let first_name=\"$BOOK_AUTHOR_FIRST\"" >> $TYPST_FILE
echo "#let last_name=\"$BOOK_AUTHOR_LAST\"" >> $TYPST_FILE
echo "#let title=\"$BOOK_TITLE\"" >> $TYPST_FILE
echo "#let scene_break=\"$SCENE_SEPARATOR\"" >> $TYPST_FILE
echo "#let show_ch_nums = false" >> $TYPST_FILE # Note: Not yet implemented

# Add the template, which provides all necessary Typist functions,
# and page / paragraph formatting.
cat "$TEMPLATE" >> $TYPST_FILE

# Process the chapters (folders), combining the individual Markdown files
# (which represent scenes) into one chapter in Typst.

for chapter_dir in "$BOOK_DIR"/*/; do
  chapter_name=$(basename "$chapter_dir")
  if [[ "$chapter_name" != "exports" ]]; then
    echo "#make_chapter_head(\"$chapter_name\")" >> $TYPST_FILE
    scene_count=0
    for scene_file in "$chapter_dir"/*.md; do
      cat "$scene_file" >> $TYPST_FILE
      scene_count=$((scene_count + 1))
      if [[ $scene_count -lt $(ls "$chapter_dir"/*.md | wc -l) ]]; then
        echo "#make_scene_break" >> $TYPST_FILE
      fi
    done

    echo "#pagebreak()" >> $TYPST_FILE
  fi
done

# Generate the PDF
output_filename="book_$(date +"%Y-%m-%d_%H-%M-%S").pdf"
typst compile --format pdf "$TYPST_FILE" "$OUTPUT_DIR/$output_filename" || exit 1
echo "Output generated: $OUTPUT_DIR/$output_filename"

# Remove the temporary typst file
rm -f "$OUTPUT_DIR/book.typ"







