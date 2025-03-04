#!/bin/bash

# Load module
module load trimal 

# Define input and output directories
declare -A directories=(
    ["alignments_family_corrected_taper"]="alignments_family_corrected_taper_trimal"
    ["alignments_genus_corrected_taper"]="alignments_genus_corrected_taper_trimal"
    ["alignments_species_corrected_taper"]="alignments_species_corrected_taper_trimal"
)

# Ensure trimal is available
if ! command -v trimal &> /dev/null; then
    echo "Error: trimal is not installed or not in PATH."
    exit 1
fi

# Loop through each directory pair
for input_dir in "${!directories[@]}"; do
    output_dir="${directories[$input_dir]}"

    # Create output directory if it does not exist
    mkdir -p "$output_dir"

    # Process each alignment file
    for file in "$input_dir"/*.fa; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            trimal -in "$file" -out "$output_dir/$filename" -automated1
        fi
    done
done

echo "Trimming complete!"
