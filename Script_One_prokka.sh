#!/bin/Bash

# Navigate to the directory where you want to store prokka outputs 
Cd Desktop/MCV_pipeline

# Create a directory to store the Prokka outputs
Mkdir prokka_outputs

# Navigate to the directory with the pork input .fasta files
Cd genomes/

#Set up loop to go through each FASTA file and run prokka 
For file in *.fasta; do

#Script to run prokkka on all megalocytivirus and iridovirus genomes 
% prokka --kingdom viruses --outdir /Desktop/MCV_pipeline/Prokka_outputs
