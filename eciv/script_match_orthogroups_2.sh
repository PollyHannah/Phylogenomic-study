#!/bin/bash

# Define directories with labels
declare -A directories
directories["family_1"]="./orthofinder_2_family/Results_Feb13/Orthogroup_Sequences"
directories["genus_1"]="./orthofinder_2_genus/Results_Feb13/Orthogroup_Sequences"
directories["family_2"]="./orthofinder_2_family/Results_May09/Orthogroup_Sequences"
directories["genus_2"]="./orthofinder_2_genus/Results_May09/Orthogroup_Sequences"

# Reference directory (e.g., the first one to search from)
reference_dir="./orthofinder_2_family/Results_Feb13/Orthogroup_Sequences"

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

# Loop through all .fa files in the reference directory
while IFS= read -r ref_file; do
    ref_filename=$(basename "$ref_file")

    # Extract first sequence from reference file
    first_seq=$(awk '/^>/{if (seq) exit} !/^>/{seq=seq $0} END{print seq}' "$ref_file")

    {
        echo "reference $ref_filename"
        for label in "${!directories[@]}"; do
            dir="${directories[$label]}"
            match=$(find_match "$dir" "$label" "$first_seq")
            echo "$match"
        done
        echo "---"
    } >> "$output_file"

done < <(find "$reference_dir" -maxdepth 1 -name "*.fa" | sort)

echo "Results saved to $output_file"
