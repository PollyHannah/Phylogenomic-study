#!/bin/bash

module load iqtree

models=(
    "Blosum62" "cpREV" "Dayhoff" "DCMut" "FLAVI" "FLU" "HIVb" "HIVw"
    "JTT" "JTTDCMut" "LG" "mtART" "mtMAM" "mtREV" "mtZOA" "mtMet"
    "mtVer" "mtInv" "PMB" "Q.bird" "Q.insect" "Q.mammal" "Q.pfam"
    "Q.plant" "Q.yeast" "rtREV" "VT" "WAG" "Q.iridoviridae" "Q.mcv"
)
mset=$(IFS=, ; echo "${models[*]}")



# Family analysis 
mkdir -p iqtree_family_concatenated

cd iqtree_family_concatenated
cp ../qmaker/Q.iridoviridae .
cp ../qmaker/Q.mcv .

iqtree -p ../alignments_family_muscle_edited_trimmed_concatenation -m MFP+MERGE -mset "$mset" --prefix concat -B 1000 -T 28
iqtree -S ../alignments_family_muscle_edited_trimmed_concatenation -mset "$mset" -m MFP --prefix loci -T 28
iqtree -t concat.treefile --gcf loci.treefile --prefix concord


# Genus analysis 
cd ..

mkdir -p iqtree_genus_concatenated

cd iqtree_genus_concatenated
cp ../qmaker/Q.iridoviridae .
cp ../qmaker/Q.mcv .

iqtree -p ../alignments_genus_muscle_edited_trimmed_concatenation -m MFP+MERGE -mset "$mset" --prefix concat -B 1000 -T 64
iqtree -S ../alignments_genus_muscle_edited_trimmed_concatenation -mset "$mset" -m MFP --prefix loci -T 28
iqtree -t concat.treefile --gcf loci.treefile --prefix concord



# Species analysis 
cd ..

mkdir -p iqtree_species_concatenated

cd iqtree_species_concatenated
cp ../qmaker/Q.iridoviridae .
cp ../qmaker/Q.mcv .

iqtree -p ../alignments_species_muscle_edited_trimmed_concatenation -m MFP+MERGE -mset "$mset" --prefix concat -B 1000 -T 64
iqtree -S ../alignments_species_muscle_edited_trimmed_concatenation -mset "$mset" -m MFP --prefix loci -T 28
iqtree -t concat.treefile --gcf loci.treefile --prefix concord

