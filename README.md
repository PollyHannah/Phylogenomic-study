# Phylogenomic analysis 

## About 
This repository houses the details of my bioinformatic pipeline for my phylogenetic analyses of megalocytiviruses, a group of fish pathogens exotic to Australia, and other members of the family *Iridoviridae*. A set of core genes are first identified followed by phylogenetic analysis of the core genes. 

Go to the file 'setup.md' in this repository, for information about how to set-up a conda environment. The same file houses information on how to complete basic tasks like transfering files and fixing errors you might receive while completeing this analysis.

## Part One
Part one is where we quality check and re-annotate genomes for inout into Part two: Core gene analysis. 

### Create a directory for this work
```bash
mkdir mcv
cd mcv
```

### Save genomes to mcv directory
Download 'genomes' folder and its contents from this repository to use as input files. Save the folder 'genomes' and contents to mcv directory.