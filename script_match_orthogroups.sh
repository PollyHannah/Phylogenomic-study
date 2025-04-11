#!/bin/bash

# Set directories with labels
species_dir="./orthofinder_2_species/Results_Feb13/Orthogroup_Sequences"
genus_dir="./orthofinder_2_genus/Results_Feb13/Orthogroup_Sequences"
family_dir="./orthofinder_2_family/Results_Feb13/Orthogroup_Sequences"

# Output file
output_file="sequence_matches.txt"
> "$output_file"  # Clear file at start

# Function to find matching sequence in a directory
find_match() {
    dir_path="$1"
    label="$2"
    query_seq="$3"
    match_file="no match"

    while IFS= read -r fa_file; do
        seqs=$(awk '/^>/{if (seq) print seq; seq=""; next} {seq=seq $0} END{if (seq) print seq}' "$fa_file")
        while IFS= read -r seq; do
            if [[ "$seq" == "$query_seq" ]]; then
                match_file=$(basename "$fa_file")
                break 2
            fi
        done <<< "$seqs"
    done < <(find "$dir_path" -maxdepth 1 -name "*.fa")

    echo "$label $match_file"
}

# Loop through all species .fa files
while IFS= read -r species_file; do
    species_filename=$(basename "$species_file")

    # Extract first sequence from species file
    first_seq=$(awk '/^>/{if (seq) exit} !/^>/{seq=seq $0} END{print seq}' "$species_file")

    {
        echo "species $species_filename"
        find_match "$genus_dir" "genus" "$first_seq"
        find_match "$family_dir" "family" "$first_seq"
        echo "---"
    } >> "$output_file"

done < <(find "$species_dir" -maxdepth 1 -name "*.fa" | sort)

echo "Results saved to $output_file"
