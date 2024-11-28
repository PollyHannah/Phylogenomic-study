# Phylogenomic analysis 

## About 
This repository houses the details of my bioinformatic pipeline for my phylogenetic analyses of megalocytiviruses, a group of fish pathogens exotic to Australia, and other members of the family *Iridoviridae*. A set of core genes are first identified followed by phylogenetic analysis of the core genes. 

Go to the file 'setup.md' in this repository, for information about how to set-up a conda environment. The same file houses information on how to complete basic tasks like transfering files and fixing errors you might receive while completeing this analysis.

## Part one: quality check and annotation
Part one is where we quality check and re-annotate genomes for input into Part two: core gene analysis. 

### Create a directory for this work
```bash
mkdir mcv
cd mcv
```

### Save genomes to mcv directory
Download 'genomes_1' folder and its contents from this repository and save the folder and contents to the mcv directory. This folder contains 35 megalocytivirus and 10 iridoviridae genomes in FASTA format downloaded directly from GenBank. Details about each genome can be found in the taxonomy.csv file in this repository. 