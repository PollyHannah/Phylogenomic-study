#!/bin/bash

# Define input directories and corresponding output directories
declare -A directories=(
    ["alignments_family_muscle5_edited_trimmed"]="orthogroup_sequence_family"
    ["alignments_genus_muscle5_edited_trimmed"]="orthogroup_sequence_genus"
    ["alignments_species_muscle5_edited_trimmed"]="orthogroup_sequence_species"
)

# Loop through each input directory
for input_dir in "${!directories[@]}"; do
    output_dir="${directories[$input_dir]}"

    # Create the output directory if it doesn't exist
    mkdir -p "$output_dir"

    # Process each .fa file in the input directory
    for file in "$input_dir"/*.fa; do
        # Extract filename without path and extension
        filename=$(basename "$file" .fa)

        # Extract the first sequence from the .fa file
        awk '/^>/{if (seq) exit; print; seq=1; next} seq {print}' "$file" > "$output_dir/$filename.fasta"

        # Rename the sequence header to match the filename
        sed -i "1s/.*/>$filename/" "$output_dir/$filename.fasta"
    done

    echo "Processing complete for $input_dir. Files saved in $output_dir"
done
