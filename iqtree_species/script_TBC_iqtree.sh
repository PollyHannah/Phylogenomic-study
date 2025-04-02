#!/bin/bash

# The modules to load:

# Load required modules
module load iqtree/2.2.0.5
module load parallel

# Define input directories and corresponding output directories
declare -A directories=(
    ["alignments_family_muscle5_edited_trimmed"]="iqtree_family"
    ["alignments_genus_muscle5_edited_trimmed"]="iqtree_genus"
    ["alignments_species_muscle5_edited_trimmed"]="iqtree_species"
)

# Ensure the custom models are available
custom_models=("Q.iridoviridae" "Q.mcv")   

# Define model set including new models
models=("Blosum62" "cpREV" "Dayhoff" "DCMut" "FLAVI" "FLU" "HIVb" "HIVw" "JTT" "JTTDCMut" "LG" "mtART" "mtMAM" "mtREV" "mtZOA" "mtMet" "mtVer" "mtInv" "PMB" "Q.bird" "Q.insect" "Q.mammal" "Q.pfam" "Q.plant" "Q.yeast" "rtREV" "VT" "WAG" "Q.iridoviridae" "Q.mcv")

# Join array into comma-separated string
mset=$(IFS=, ; echo "${models[*]}")

# Function to run IQ-TREE2
run_iqtree() {
    local file=$1
    local output_dir=$2
    local basefile=$(basename "$file")
    echo "Processing: $basefile"
    iqtree2 -s "$file" -B 1000 -mset $mset -T 1 -pre "$output_dir/$basefile"
}

export -f run_iqtree
export mset

# Loop through each directory pair and process files in parallel
for input_dir in "${!directories[@]}"; do
    output_dir="${directories[$input_dir]}"
    mkdir -p "$output_dir"  # Create output directory if it doesn't exist
    
    files=("$input_dir"/*.fa)
    if [[ -f "${files[0]}" ]]; then  # Check if directory contains .fa files
        parallel -j $(nproc) run_iqtree {} "$output_dir" ::: "${files[@]}"
    else
        echo "Warning: No .fa files found in $input_dir"
    fi
done