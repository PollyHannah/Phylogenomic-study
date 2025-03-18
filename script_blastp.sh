#!/bin/bash

# The modules to load:
blast+

# Job commands:

# Define input directories and corresponding output directories
declare -A directories=(
    ["orthogroup_sequence_family"]="orthogroup_blastp_family"
    ["orthogroup_sequence_genus"]="orthogroup_blastp_genus"
    ["orthogroup_sequence_species"]="orthogroup_blastp_species"
)

# Loop through each input directory
for input_dir in "${!directories[@]}"; do
    output_dir="${directories[$input_dir]}"

    # Create the output directory if it doesn't exist
    mkdir -p "$output_dir"

    # Loop through each .fasta file in the input directory
    for file in "$input_dir"/*.fasta; do
        # Extract filename without path and remove .fasta extension
        filename=$(basename "$file" .fasta)

        # Run BLASTP and save the output
        blastp -query "$file" -db swissprot -out "$output_dir/$filename.txt"
    done

    echo "BLASTP searches complete for $input_dir. Results saved in $output_dir"
done
