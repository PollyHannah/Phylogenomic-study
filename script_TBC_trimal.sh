#!/bin/bash

# load module 
module load trimal
module load seqkit

# Directories
input_dirs=("alignments_family_muscle5_edited" "alignments_genus_muscle5_edited" "alignments_species_muscle5_edited")
output_dirs=("alignments_family_muscle5_edited_trimmed" "alignments_genus_muscle5_edited_trimmed" "alignments_species_muscle5_edited_trimmed")

threshold=0.05  # Minimum proportion of non-gap characters required (5%)

# Ensure seqkit is installed
if ! command -v seqkit &> /dev/null; then
    echo "Error: seqkit is not installed. Install it with 'conda install -c bioconda seqkit' or 'brew install seqkit'."
    exit 1
fi

# Process each directory
for index in "${!input_dirs[@]}"; do
    input_dir="${input_dirs[$index]}"
    output_dir="${output_dirs[$index]}"
    
    # Create output directory if it doesn't exist
    mkdir -p "$output_dir"
    
    # Process each .fa file in the input directory
    for input_file in "$input_dir"/*.fa; do
        [ -e "$input_file" ] || continue  # Skip if no .fa files exist

        output_file="$output_dir/$(basename "$input_file")"

        # Convert FASTA to tabular format (name \t sequence)
        seqkit fx2tab "$input_file" | awk -v threshold="$threshold" '
        {
            headers[NR] = $1;  # Store sequence names
            seqs[NR] = $2;     # Store sequences
            len = length($2);
        }
        END {
            for (i = 1; i <= len; i++) {
                count = 0;
                for (j = 1; j <= NR; j++) {
                    char = substr(seqs[j], i, 1);
                    if (char != "-") { count++ }
                }
                if (count / NR >= threshold) {
                    keep[i] = 1;
                }
            }
            for (j = 1; j <= NR; j++) {
                new_seq = "";
                for (i = 1; i <= len; i++) {
                    if (keep[i]) {
                        new_seq = new_seq substr(seqs[j], i, 1);
                    }
                }
                print ">" headers[j] "\n" new_seq;  # Preserve original sequence names
            }
        }' > "$output_file"

        echo "Processed: $input_file -> $output_file"
    done
done

echo "All alignments trimmed and saved in respective directories."
