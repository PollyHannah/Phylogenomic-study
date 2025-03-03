#!/usr/bin/env bash

BASE_INPUT_DIR="/scratch3/han394/mcv/"
BASE_OUTPUT_DIR="/scratch3/han394/mcv/"

for category in family genus species; do
  INPUT_DIR="${BASE_INPUT_DIR}alignments_${category}/"
  OUTPUT_DIR="${BASE_OUTPUT_DIR}alignments_${category}_corrected_taper/"
  OUTPUT_LIST="files2run_${category}.txt"

  rm -f "$OUTPUT_LIST"  # Remove existing file to start fresh
  mkdir -p "$OUTPUT_DIR"  # Ensure the output directory exists

  # Loop over all files in the input directory
  for file in "$INPUT_DIR"*; do
    if [[ -f "$file" ]]; then
      echo "$file" >> "$OUTPUT_LIST"
      output_file="$OUTPUT_DIR$(basename "$file")"
      echo "$output_file" >> "$OUTPUT_LIST"
    fi
  done

  echo "Created $OUTPUT_LIST with $(wc -l < "$OUTPUT_LIST") lines."
done
