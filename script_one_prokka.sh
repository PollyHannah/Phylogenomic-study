#!/bin/bash

# Load Prokka
module load prokka

# Create a directory to store the Prokka outputs
mkdir prokka_outputs

#Define Genomes as an array
GENOMES=(`ls ./genomes_1/*.fasta`) 

#Set up 'For-Do' loop to go through each FASTA file and run Prokka program on each. 
#Variable 'GENOMES' is all the files which matched with GENOMES array, and [@] means each of them one at a time. If did {GENOMES[*]} it would do all of the inputs in the array at one time. 
#For-Do loops automatically make a definition for the entry for 'for' (in this case, 'INPUT').  
#Define 'File' as an array which is the base name of each INPUT file with the .fasta removed (so here, the accession number)
#this was done using the 'basename' command used to strip information from a filename.
#Specified viruses as the kingdom for Prokka to use to annotate the genomes. 
#Specified the outdirectory, prefix and locus tag. 
#If an out directory using --outdir isn't specified Prokka will put the out directory in the same directory as the input files. 
for INPUT in ${GENOMES[@]} ; do 
	File=(`basename ${INPUT} .fasta`) 
	prokka ${INPUT} --kingdom viruses --outdir ./prokka_outputs/${File} --prefix ${File} --locustag ${File}
done