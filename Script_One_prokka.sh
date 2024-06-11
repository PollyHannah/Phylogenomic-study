#!/bin/Bash

# Navigate to the directory where you want to store prokka outputs 
Cd Desktop/MCV_pipeline

# Create a directory to store the Prokka outputs
Mkdir prokka_outputs

# Navigate to the directory with the input .fasta files. Prokka automatically uses the files contained in the directory you run thr program from, as input.
Cd genomes/

#Define Genomes as an array (had success with the following on Mac from /Users/polly)
GENOMES=(`ls Documents/Github/Phylogenomic-study/Genomes/*.fasta`) 

#Set up loop to go through each FASTA file and run prokka. 
#Variable genomes is all the files which matched with GENOMES [@] equals each of them one at a time. If did [*] it would do all of the inputs in the array at one time. 
#Define 'file' as an array.
#basename is a command used to strip suffix information from a filename, which leaves only the file name itself.
#If an out directory using --outdir isn't specified Prokka will put the out directory in the same directory as the input files 
for INPUT in ${GENOMES[@]} ; do 
	File=(`basename ${INPUT} .fasta`) 
	prokka --kingdom viruses --outdir /Desktop/MCV_pipeline/Prokka_outputs/${File} --prefix ${File} --locustag ${File}
done
