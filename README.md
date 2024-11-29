# Phylogenomic analysis 

## About 
This repository houses the details of my bioinformatic pipeline for my phylogenetic analyses of megalocytiviruses, a group of fish pathogens exotic to Australia, and other members of the family *Iridoviridae*. A set of core genes are first identified followed by phylogenetic analysis of the core genes. 

Go to the file 'setup.md' in this repository, for information about how to set-up a conda environment. The same file houses information on how to complete basic tasks like transfering files and fixing errors you might receive while completeing this analysis.

## Part one: re-annotation and quality check
Part one is where we quality check and re-annotate genomes for input into Part two: core gene analysis. 

### Create a directory for this work
```bash
mkdir mcv
cd mcv
```

### Save genomes to mcv directory
Download 'genomes_1' folder and its contents from this repository and save the folder and contents to the mcv directory. This folder contains 35 megalocytivirus and 10 iridoviridae genomes in FASTA format. Details about each genome can be found in the taxonomy.csv file in this repository.

#### Which genomes are included and exluded from the genomes_1 directory?
I included all megalocytivirus genomes saved as 'complete' genomes under the genus *Megalocytivirus* in the NCBI GenBank the Taxonomy Browser, which were the expected length. This included genomes entered into NCBI Genbank as ‘unclassified’ at the species level. One megalocytivirus genome was not included given it was smaller than the expected length (accession KC138895I). 

I also included ten representative genomes from each of the six other iridovirid genera including two genomes from each genus where multiple genomes are available (two each from of the genera *Ranavirus*, *Lymphocystivirus*, *Iridovirus*, and *Chloriridovirus*; one each from of the genera *Decapodiridovirus* and *Daphniairidovirus*). 

These genomes were chosen to span the deepest node of the given clade shown in Zhao et al. (2022) except for the genus *Lymphocystivirus*. One of the lymphocystivirus genomes initally chosen for inclusion, L63545, was half the expected length. I replaced L63545 with another genome from the same genus (KX643370) which was the expected length. 

### Run Prokka on genomes
```bash
bash script_one_prokka.sh
```

### Save proteome files to a central folder.
Collect the proteome files from the prokka_outputs directory and save them to proteome directory. This step is done in preparation for running OrthoFinder, a program which uses the proteome files as inputs.
```bash
bash script_two_collect_proteome_files.sh
```

### Run OrthoFinder
OrthoFinder is a program which identifies genes highly conserved between genomes. I manually check and edit (where necessary) the prokka-assigned annotations.

We run this program later in the analysis to identify a final set of 'core genes' at the species, genus and family level. Right now, we're just running it to identify a set of highly conserved genes to target for checking and editing (as explained a bit later on). 

#### Nominate values for OrthoFinder options
Open 'script_three_orthofinder.sh' and nominate values for options -t (-t number_of_threads) and -a (-a number_of_orthofinder_threads). These options control the parallelisation of OrthoFinder to decrease the runtime. For -t, choose the  number of cores on your computer. For -a, put 1/4 of the value of -t. 

This script will take the proteome files from the directory 'proteome' and store the output files in a directory 'orthofinder_1'.

Run updated script.
```bash
bash script_three_orthofinder.sh
```

## References
Zhao, R., Gu, C., Zou, X., Zhao, M., Xiao, W., He, M., He, L., Yang, Q., Geng, Y., & Yu, Z. (2022). Comparative genomic analysis reveals new evidence of genus boundary for family Iridoviridae and explores qualified hallmark genes. Computational and Structural Biotechnology Journal, 20, 3493–3502. https://doi.org/10.1016/j.csbj.2022.06.049
