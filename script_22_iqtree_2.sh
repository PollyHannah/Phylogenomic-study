#!/bin/bash

module load iqtree/2.2.0.5

# List input files and output directories
input_files=("concatenated_alignment_family.fasta" "concatenated_alignment_genus.fasta" "concatenated_alignment_species.fasta")
output_dirs=("iqtree_family_concatenated" "iqtree_genus_concatenated" "iqtree_species_concatenated")

# Select input/output based on job array index
file="${input_files[$SLURM_ARRAY_TASK_ID]}"
outdir="${output_dirs[$SLURM_ARRAY_TASK_ID]}"

# Create output directory
mkdir -p "$outdir"
prefix="$outdir/$(basename "$file" .fasta)"

# Model set (can be trimmed if needed)
models=(
    "Blosum62" "cpREV" "Dayhoff" "DCMut" "FLAVI" "FLU" "HIVb" "HIVw"
    "JTT" "JTTDCMut" "LG" "mtART" "mtMAM" "mtREV" "mtZOA" "mtMet"
    "mtVer" "mtInv" "PMB" "Q.bird" "Q.insect" "Q.mammal" "Q.pfam"
    "Q.plant" "Q.yeast" "rtREV" "VT" "WAG" "Q.iridoviridae" "Q.mcv"
)
mset=$(IFS=, ; echo "${models[*]}")

echo "[$(date)] Running IQ-TREE2 on $file -> $prefix"
iqtree2 -s "$file" -B 1000 -mset "$mset" -T AUTO -pre "$prefix"
