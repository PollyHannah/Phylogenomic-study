#!/bin/bash

module load iqtree

models=(
    "Blosum62" "cpREV" "Dayhoff" "DCMut" "FLAVI" "FLU" "HIVb" "HIVw"
    "JTT" "JTTDCMut" "LG" "mtART" "mtMAM" "mtREV" "mtZOA" "mtMet"
    "mtVer" "mtInv" "PMB" "Q.bird" "Q.insect" "Q.mammal" "Q.pfam"
    "Q.plant" "Q.yeast" "rtREV" "VT" "WAG" "Q.iridoviridae" "Q.mcv"
)
mset=$(IFS=, ; echo "${models[*]}")



# Family analysis virus1
mkdir -p iqtree_family_concatenated

cd iqtree_family_concatenated
cp ../qmaker/Q.iridoviridae .
cp ../qmaker/Q.mcv .

iqtree -p ../alignments_family_muscle_edited_trimmed_concatenation -m MFP+MERGE -mset "$mset" --prefix concat -B 1000 -T 28
iqtree -S ../alignments_family_muscle_edited_trimmed_concatenation -mset "$mset" -m MFP --prefix loci -T 28
iqtree -t concat.treefile --gcf loci.treefile --prefix concord


# Genus analysis virus2
cd ..

mkdir -p iqtree_genus_concatenated

cd iqtree_genus_concatenated
cp ../qmaker/Q.iridoviridae .
cp ../qmaker/Q.mcv .

iqtree -p ../alignments_genus_muscle_edited_trimmed_concatenation -m MFP+MERGE -mset "$mset" --prefix concat -B 1000 -T 64
iqtree -S ../alignments_genus_muscle_edited_trimmed_concatenation -mset "$mset" -m MFP --prefix loci -T 28
iqtree -t concat.treefile --gcf loci.treefile --prefix concord



# Species analysis virus3
cd ..

mkdir -p iqtree_species_concatenated

cd iqtree_species_concatenated
cp ../qmaker/Q.iridoviridae .
cp ../qmaker/Q.mcv .

iqtree -p ../alignments_species_muscle_edited_trimmed_concatenation -m MFP+MERGE -mset "$mset" --prefix concat -B 1000 -T 64
iqtree -S ../alignments_species_muscle_edited_trimmed_concatenation -mset "$mset" -m MFP --prefix loci -T 28
iqtree -t concat.treefile --gcf loci.treefile --prefix concord



iqtree2 -s "$file" -B 1000 -mset "$mset" -T AUTO -pre "$prefix"


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
