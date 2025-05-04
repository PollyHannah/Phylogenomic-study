#!/bin/bash

# Load IQ-TREE2
module load iqtree/2.2.0.5

# Define the model set
models=(
    "Blosum62" "cpREV" "Dayhoff" "DCMut" "FLAVI" "FLU" "HIVb" "HIVw"
    "JTT" "JTTDCMut" "LG" "mtART" "mtMAM" "mtREV" "mtZOA" "mtMet"
    "mtVer" "mtInv" "PMB" "Q.bird" "Q.insect" "Q.mammal" "Q.pfam"
    "Q.plant" "Q.yeast" "rtREV" "VT" "WAG" "Q.iridoviridae" "Q.mcv"
)
mset=$(IFS=, ; echo "${models[*]}")

# Define input -> output directory mapping
declare -A alignments=(
    ["concatenated_alignment_family.fasta"]="iqtree_family_concatenated"
    ["concatenated_alignment_genus.fasta"]="iqtree_genus_concatenated"
    ["concatenated_alignment_species.fasta"]="iqtree_species_concatenated"
)

# Run IQ-TREE2 on each file
for file in "${!alignments[@]}"; do
    outdir="${alignments[$file]}"
    mkdir -p "$outdir"

    prefix="$outdir/$(basename "$file" .fasta)"

    echo "Running IQ-TREE2 on $file -> $prefix"
    iqtree2 -s "$file" -B 1000 -mset "$mset" -T 4 -pre "$prefix"
done
