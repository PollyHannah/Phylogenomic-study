# Phylogenomic analysis 

## About 
This repository houses the details of my bioinformatic pipeline for my phylogenetic analyses of megalocytiviruses, a group of fish pathogens exotic to Australia, and other members of the family *Iridoviridae*. A set of core genes are first identified followed by phylogenetic analysis of the core genes. 

Go to the file `setup.md` in this repository, for information about how to set-up a conda environment. The same file houses information on how to complete basic tasks like transfering files and fixing errors you might receive while completeing this analysis. You will need the following software:
* Prokka (version 1.14.5)
* OrthoFinder (version 2.5.4)
* IQ-TREE2 (version 2.2.0.5)
* CIAlign (available in python/3.12.3)

To identify the genetic sequence information for inclusion in this study i generated a database of available sequence data for the genus *Megalocytivirus* and other members of the family *Iridoviridae*. That data base can be found in this repository named `megalocytivirus_sequence_data.xlsx`.

## Part one: re-annotation and quality check
Part one is where we collect, quality check, and re-annotate genomes for input into Part two: core gene analysis. The genomes in NCBI Genbank have annotations, but they are of differing quality, and done using various methods. This part aims to check and update annotations to maximise the quality of the data for phylogenetic inference.

### Create a directory for this work
```bash
mkdir mcv
cd mcv
```
### Save genomes to mcv directory
Download `genomes_1` directory and its contents from this repository and save the folder and contents to the mcv directory. This folder contains 35 megalocytivirus and 10 iridoviridae genomes in FASTA format. Details about each genome can be found in the `taxonomy.csv` file in this repository.

#### Which genomes are included and exluded from the genomes_1 directory?
I included all megalocytivirus genomes saved as 'complete' genomes under the genus *Megalocytivirus* in the NCBI GenBank the Taxonomy Browser, which were the expected length. Genomes which were not the expected length meant genomes which were half or twice the length of other *Megalocytivirus* genomes. This included genomes entered into NCBI Genbank as 'unclassified' at the species level. One megalocytivirus genome was not included given it was smaller than the expected length (accession KC138895). KC138895 is was 903 base pairs (bp) in length whereas megalocytiviruses are between 110,000 and 140,000 bp in length. 

I also included ten representative genomes from each of the six other iridovirid genera including two genomes from each genus where multiple genomes are available (two each from of the genera *Ranavirus*, *Lymphocystivirus*, *Iridovirus*, and *Chloriridovirus*; one each from of the genera *Decapodiridovirus* and *Daphniairidovirus*). I also ensured these genomes were the expected length. Genomes which were not the expected length meant genomes which were half or twice the length of other genomes in the same genus. 

These genomes were chosen to span the deepest node of the given clade shown in Zhao et al. (2022) except for the genus *Lymphocystivirus*. One of the lymphocystivirus genomes initally chosen for inclusion, L63545, was half the expected length at 102,653 bp long. Lymphocystivirus genomes are typically around 200,000 bp in length. I replaced L63545 with another genome from the same genus (KX643370) which was the expected length (208,501 bp). 

##### Novel genomes
I've sequenced and am currently assembling and annotating novel genomes for inclusion in this study, as tabulated below. The directory in this repository `novel_genomes` houses data associated with the assembly and annotation of these genomes, including the software I'm using. The raw reads are not stored in this repository as they are too large. These genomes are not yet included in the analysis.
| Genome | Accession |Identification number  | Collection date | Host |
|--------|-----------|-----------------------|-----------------|------|
| 1 | Not yet created | 23-04361-0003 | 2 November 2023 | Swordtail ornamental fish (*Xiphophorus helleri*) |
| 2 | Not yet created | 23-04361-0005 | 2 November |  Platys (*Xiphophorus maculatus*) 

### Run Prokka on genomes
```bash
bash script_one_prokka.sh
```
### Save proteome files to a central folder.
Collect the proteome files from the `prokka_outputs_1` directory and save them to `proteome_1` directory. This step is done in preparation for running OrthoFinder, a program which uses the proteome files as inputs.
```bash
bash script_two_collect_proteome_files.sh
```
### Run OrthoFinder
OrthoFinder is a program which identifies genes highly conserved between genomes. I manually check and edit (where necessary) the prokka-assigned annotations.

We run this program later in the analysis to identify a final set of 'core genes' at the species, genus and family level. Right now, we're just running it to identify a set of highly conserved genes to target for checking and editing (as explained a bit later on). 

#### Nominate values for OrthoFinder options
Open `script_three_orthofinder.sh` and nominate values for options `-t` (`-t` number_of_threads) and `-a` (`-a` number_of_orthofinder_threads). These options control the parallelisation of OrthoFinder to decrease the runtime. For `-t`, choose the  number of cores on your computer. For `-a`, put 1/4 of the value of `-t`. 

This script will take the proteome files from the directory `proteome_1` and store the output files in a directory using the naming convention Results_MONTHDAY. This folder will be saved in a directory called `orthofinder_1`. 

Run updated script.
```bash
bash script_three_orthofinder.sh
```

### Manually check and edit annotations 
Computers are great but they're not perfect. This is why, in theis pipeline, I manually curate the prokka-assigned annotations using Geneious Prime. I recorded all changes i made in the spreadsheet 'Manual Check_Nucleotide alignment Annotations' in the `prokka_outputs_1` directory in this repository.

#### Steps to follow
1. Export the .gff file generated by prokka and drag and drop it into Geneious Prime (Version 2020.2.5).
2. Pairwise align the file with the .gb (Genbank Full) file in GenBank, for the same genome.
3. Check each annotation and decide to either keep it as-is or edit it.
4. Create a directory `proteome_2`.
5. Save all the manually curated proteome files for all genomes as .faa files into the `proteome_2` directory.

To understand how I made decisions as part of step 3 above, which annotations i checked and edited for which genomes, and my results, see directory `annotation_check` in this repository. 

## Part Two: Core gene analysis
This is where we take the freshly re-annotated sequences and identify a set of core genes using OrthoFinder (again).  

### Run OrthoFinder again
Now, run Orthofinder on the manually curated annotation files. The input files will be take from the `proteome_2` directory. The output files will be saved into a directory `orthofinder_2`. 
```bash
script_TBC_orthofinder.sh
```

### Manually check and edit Multiple Sequence Alignments
I manually curate the OrthoFinder-generated MSA files using Geneious Prime (Version 2020.2.5). 

#### Steps to take
1. Export the MSA files generated by OrthoFinder and drag and drop it into Geneious Prime.
2. Check each file and make edits where neccessary. 
3. Create a directory in the mcv directory `3_mafft_alignments`.
4. Save all the manually curated MSA files for all genomes.

### Clean MSA files
Clean each MSA file using CIAlign.
```bash
script_TBC_cialign.sh
```

### Generate gene trees
To generate gene trees for each MSA using iqtree, first remove MSAs for orthogroups for which you do not want to generate a gene tree (i.e. orthogroups not containing core genes of interest). 

Then, open the script `script_four_iqtree.sh` and insert the file path to your MSA directory in the relevant sections (as indicated in the script). 

Activate your conda environment 
```bash
conda activate mcv
```

Run updated script:
```bash
script_TBC_iqtree.sh
```

### Sort output files 
iqtree will generate several outputs for each input file with a variety of extensions. All outputs will be saved in the one output directory. You will need to please sort the output files into seperate directories based on orthogroup. Open the script saved to this repository `script_five_sort_files.sh` and update the file path to where the outputs are saved. Then, run the updated script.
```bash
script_TBC_sort_files.sh
```
## References
Zhao, R., Gu, C., Zou, X., Zhao, M., Xiao, W., He, M., He, L., Yang, Q., Geng, Y., & Yu, Z. (2022). Comparative genomic analysis reveals new evidence of genus boundary for family Iridoviridae and explores qualified hallmark genes. Computational and Structural Biotechnology Journal, 20, 3493–3502. https://doi.org/10.1016/j.csbj.2022.06.049
