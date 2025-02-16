#!/usr/bin/env bash

OUTPUT_LIST="files2run.txt"
rm -f "$OUTPUT_LIST"  # Remove existing file to start fresh

INPUT_DIR="/scratch3/han394/mcv/msa_filtered_orthogroups_Genus_50pct_5retained/"
OUTPUT_DIR="/scratch3/han394/mcv/msa_filtered_orthogroups_Genus_50pct_5retained_corrected/"

mkdir -p "$OUTPUT_DIR"  # Ensure the output directory exists

# Loop over all files in the input directory
for file in "$INPUT_DIR"*; do
  # Check if it's a file (not a directory)
  if [[ -f "$file" ]]; then
    # Print the input file path
    echo "$file" >> "$OUTPUT_LIST"
  
    # Generate the output file path (same name, but in OUTPUT_DIR)
    output_file="$OUTPUT_DIR$(basename "$file")"
  
    # Print the output file path
    echo "$output_file" >> "$OUTPUT_LIST"
  fi
done

echo "Created $OUTPUT_LIST with $(wc -l < "$OUTPUT_LIST") lines."
