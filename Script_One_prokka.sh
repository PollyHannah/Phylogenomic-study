#!/bin/Bash

# Navigate to the directory where you want to store prokka outputs 
Cd Desktop/MCV_pipeline

# Create a directory to store the Prokka outputs
Mkdir prokka_outputs

# Navigate to the directory with the input .fasta files. Prokka automatically uses the files contained in the directory you run thr program from, as input.
Cd genomes/

#Define 'file' as an array
#basename is a command used to strip suffix information from a filename, which leaves only the file name itself.
File= (`basename ${input} .fasta`) 

#Set up loop to go through each FASTA file and run prokka 
For File in *.fasta; do

#Script to run prokkka on all megalocytivirus and iridovirus genomes
#If an out directory using --outdir isn't specified Prokka will put the out directory in the same directory as the input files 
% prokka --kingdom viruses --outdir /Desktop/MCV_pipeline/Prokka_outputs/${File[@]} --prefix ${File[@]} --locustag ${file[@]};${GENOMES}
