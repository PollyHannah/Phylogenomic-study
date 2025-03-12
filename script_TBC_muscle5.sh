#!/bin/bash

#load module
module load muscle

# Define input and output directories
declare -A DIRS=(
    ["alignments_family"]="alignments_family_muscle5"
    ["alignments_genus"]="alignments_genus_muscle5"
    ["alignments_species"]="alignments_species_muscle5"
)

# Create output directories if they don't exist
for INPUT_DIR in "${!DIRS[@]}"; do
    OUTPUT_DIR="${DIRS[$INPUT_DIR]}"
    mkdir -p "$OUTPUT_DIR"  # Ensure the output directory exists

    # Loop through all fasta files in the input directory
    for FILE in "$INPUT_DIR"/*.fa; do
        if [[ -f "$FILE" ]]; then
            BASENAME=$(basename "$FILE")  # Get filename without path
            OUTPUT_FILE="$OUTPUT_DIR/$BASENAME"

            echo "Processing $FILE -> $OUTPUT_FILE"
            muscle5 -align "$FILE" -output "$OUTPUT_FILE"
        fi
    done
done

echo "MUSCLE5 batch alignment completed!"
