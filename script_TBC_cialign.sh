#!/bin/bash

#This script uses CAlign to process (clean) Multiple Sequence Alignment Files. 
#The program removes columns containing only gaps. This function is run by default, to not run this function specify.
# --infile is the path to the input file being a multiple sequence alignment file in fasta format (.fasta). 
# -outfile_stem is a prefix for the output files.
# --crop_ends crops the ends of individual sequences if they contain a high proportion of gaps relative to the rest of the alignment.
# --insertion_min_perc are removes insertions which are not present in the majority of sequences (or regions which are deleted in the majority of sequences).
# CIAlign --help give you help with your options for functions.

# Create a directory to store CIAign output files
mkdir -p 3_mafft_alignments_clean_output

# Create directory for storing all cleaned fasta files (which is one file from the CIAalign output for each genome)
cleaned_fasta_dir="3_mafft_alignments_clean"
mkdir -p $cleaned_fasta_dir

# Loop through all .fasta files in the '3_mafft_alignments' directory
for infile in 3_mafft_alignments/*.fasta; do
    # Extract the base name of the file (e.g., G0000000)
    base_name=$(basename $infile _manual.fasta)

    # Create a separate directory for each output file in the '3_mafft_alignments_clean_output' directory
    output_dir="3_mafft_alignments_clean_output/${base_name}_output" 
    mkdir -p $output_dir

    # Define the cleaned output file name with "_clean" before the extension
    output_file="${output_dir}/${base_name}.fasta"

    # Run CIAlign for each file, storing output with the updated file name
    CIAlign --infile "$infile" --outfile_stem "${output_file%.fasta}" --crop_ends --remove_insertions --insertion_min_perc 0.7

    # Move all cleaned fasta files to the 3_mafft_alignments_clean directory
    mv "${output_dir}"/*_cleaned.fasta "$cleaned_fasta_dir/"
done

