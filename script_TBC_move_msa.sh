#!/bin/bash

# Step a: Create a directory named "msa_" + the name of the *retained.tsv file in the current directory
tsv_file=$(ls *retained.tsv)
directory_name="msa_$(basename "$tsv_file" .tsv)"
mkdir -p "$directory_name"

# Step b: Copy files matching the names in column_names_with_extension.txt to the new directory
while IFS= read -r file_name; do
    # Find and copy matching files
    find ./orthofinder_2_family/Results_Feb13/MultipleSequenceAlignments/ -type f -name "$file_name" -exec cp {} "$directory_name" \;
done < column_names_with_extension.txt

rm column_names_with_extension.txt

echo "Files copied to $directory_name."