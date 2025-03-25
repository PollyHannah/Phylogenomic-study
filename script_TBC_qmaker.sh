#!/bin/bash

threads=31

# we try to build models for both the entire iridoviridae, and for mcv itself
# we don't try for pagrus1, since there are likely too few substiuttions, and/or it is likely to be very similar to mcv as a whole
alignment_folders=("alignments_family_muscle5_edited_trimmed" "alignments_genus_muscle5_edited_trimmed")
prefixes=("iridoviridae" "mcv")

mkdir qmaker

for folder in "${alignment_folders[@]}"; do
	cp -r $folder "qmaker/$folder"
done

cd qmaker

# remove the ' modified' part of the alignment names (IQ-TREE doesn't like it)
for folder in "${alignment_folders[@]}"; do
	cd $folder
	rename 's/ \(modified\)//' *.fa
	cd ..
done

# make the models - one from each folder of alignments... it's feasible some won't work well if there are too few substitutions
for i in "${!alignment_folders[@]}"; do
    folder="${alignment_folders[i]}"
    prefix="${prefixes[i]}"
    echo "Folder: $folder, Prefix: $prefix"

	# get the best model and tree for each alignment
	iqtree2 -seed 1 -T $threads -S $folder -cmax 10 -pre $prefix"_step1"

	# get the GTR20 model
	iqtree2 -seed 1 -T $threads -S $prefix"_step1.best_model.nex" -te $prefix"_step1.treefile" --model-joint GTR20+FO --init-model LG -pre $prefix"_step2"

	# extract the GTR20 model
	grep -A 21 "can be used as input for IQ-TREE" $prefix"_step2.iqtree" | tail -n20 > "Q."$prefix

done

models=("Blosum62" "cpREV" "Dayhoff" "DCMut" "FLAVI" "FLU" "HIVb" "HIVw" "JTT" "JTTDCMut" "LG" "mtART" "mtMAM" "mtREV" "mtZOA" "mtMet" "mtVer" "mtInv" "PMB" "Q.bird" "Q.insect" "Q.mammal" "Q.pfam" "Q.plant" "Q.yeast" "rtREV" "VT" "WAG")

# Add the Q.$prefix models:
for prefix in "${prefixes[@]}"; do
    models+=("Q.$prefix")
done

# Join array into comma-separated string:
mset=$(IFS=, ; echo "${models[*]}")

# Final command:
echo "-mset $mset"

# get the gene trees, allowing for all three new models to be used
# this is just to test whether the models fit the data best - they should since this is the data they were trained on!
for i in "${!alignment_folders[@]}"; do
    folder="${alignment_folders[i]}"
    prefix="${prefixes[i]}"

	iqtree2 -seed 1 -T $threads -S $folder -cmax 10 -pre $prefix"_final" -mset $mset 

done