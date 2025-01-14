#!/bin/bash
# Make output directories
mkdir  ./proteome_2_species
mkdir ./proteome_2_genus

# Copy Megalocytivirus pagrus1 files to new directory 
while read file; do
    cp "./proteome_2_family/$file" "./proteome_2_species/"
done < file_list_species.txt

# Copy Megalocytivirus files to new directory 
while read file; do
    cp "./proteome_2_family/$file" "./proteome_2_genus/"
done < file_list_genus.txt