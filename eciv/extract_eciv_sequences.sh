#!/bin/bash

# Function to extract and rename MK637631 sequence
extract_sequence() {
    input_dir="$1"
    output_dir="$2"
    mkdir -p "$output_dir"

    for fa_file in "$input_dir"/*.fa; do
        [ -e "$fa_file" ] || continue  # skip if no .fa files
        base_name=$(basename "$fa_file")
        output_file="$output_dir/$base_name"

        awk -v id="MK637631" '
        BEGIN { found=0; seq="" }
        /^>/ {
            if (found) {
                print ">MK637631_European_chub_iridovirus_ECIV"
                print seq
                exit
            }
            if ($1 ~ "^>" id) {
                found=1
                seq=""
            }
        }
        {
            if (found && $0 !~ /^>/) {
                seq = seq $0
            }
        }
        END {
            if (found) {
                print ">MK637631_European_chub_iridovirus_ECIV" > "'$output_file'"
                print seq >> "'$output_file'"
            }
        }
        ' "$fa_file"
    done
}

# Run for family level
extract_sequence "./orthofinder_2_family/Results_May09/Orthogroup_Sequences" \
                 "./orthofinder_2_family/Results_May09/Orthogroup_Sequences_ECIV"

# Run for genus level
extract_sequence "./orthofinder_2_genus/Results_May09/Orthogroup_Sequences" \
                 "./orthofinder_2_genus/Results_May09/Orthogroup_Sequences_ECIV"
