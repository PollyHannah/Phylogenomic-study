# Phylogenomic analysis 

## About 
This repository houses the details of my bioinformatic pipeline for my phylogenetic analyses of megalocytiviruses, a group of fish pathogens exotic to Australia, and other members of the family *Iridoviridae*. A set of core genes are first identified followed by phylogenetic analysis of the core genes. 

Go to the file `setup.md` in this repository, for information about how to set-up a conda environment. The same file houses information on how to complete basic tasks like transfering files and fixing errors you might receive while completeing this analysis. You will need the following software:
* [Prokka](https://github.com/tseemann/prokka) (version 1.14.5)
* [OrthoFinder](https://github.com/davidemms/OrthoFinder) (version 2.5.4)
* [IQ-TREE2](https://github.com/iqtree/iqtree2) (version 2.2.0.5)
* [TAPER](https://github.com/chaoszhang/TAPER) (version 1.0.0)
* GNU Paralell 

To identify the genetic sequence information for inclusion in this study i generated a database of available sequence data for the genus *Megalocytivirus* and other members of the family *Iridoviridae*. That data base can be found in this repository named `megalocytivirus_sequence_data.xlsx`.

## Part one: re-annotation and quality check
Part one is where we collect, quality check, and re-annotate genomes for input into Part two: core gene analysis. The genomes in NCBI Genbank have annotations, but they are of differing quality, and done using various methods. This part aims to check and update annotations to maximise the quality of the data for phylogenetic inference.

### Create a directory for this work
```bash
mkdir mcv
cd mcv
```
### Save genomes to mcv directory
Download `genomes_1` directory and its contents from this repository and save the folder and contents to the mcv directory. This folder contains 66 megalocytivirus and 10 iridoviridae genomes in FASTA format (76 genomes total). 

Details about each genome can be found in the `taxonomy.csv` file in this repository. There is information for 78 genomes in `taxonomy.csv` given genomes L63545 and KC138895 are included which are not included in the `genomes_1` directory due to them not being the expected length. You can read more about this in the next section. Please read my [`Classification protocol`](https://github.com/PollyHannah/Phylogenomic-study/blob/main/classification/classification%20protocol.md) to understand how i classified megalocytivirus genomes included in this study.

#### Which genomes are included and exluded from the `genomes_1` directory?
I included all megalocytivirus genomes saved as 'complete' genomes under the genus *Megalocytivirus* in the NCBI GenBank the Taxonomy Browser, which were the expected length. This included genomes entered into NCBI Genbank as 'unclassified' at the species level. 

I also included ten representative genomes from each of the six other iridovirid genera including two genomes from each genus where multiple genomes are available (two each from of the genera *Ranavirus*, *Lymphocystivirus*, *Iridovirus*, and *Chloriridovirus*; one each from of the genera *Decapodiridovirus* and *Daphniairidovirus*). These genomes were chosen to span the deepest node of the given clade shown in Zhao et al. (2022).  

Genomes which I considered to be not the expected length, meant genomes which were half or twice the length of other genomes within the same genus. This goes for all genomes considered for inclusion in the `genomes_1` directory. There were two genomes which were not included in the `genomes_1` directory given they were not the expected length (as below):
* One of the lymphocystivirus genomes initally chosen for inclusion, L63545, was half the expected length at 102,653 bp long. Lymphocystivirus genomes are typically around 200,000 bp in length. I replaced L63545 with another genome from the same genus (KX643370) which was the expected length (208,501 bp).
* One megalocytivirus genome was not included given it was smaller than the expected length (accession KC138895). KC138895 was 903 base pairs (bp) in length whereas megalocytiviruses are between 110,000 and 140,000 bp in length. 

##### Novel genomes
I've sequenced, assembled and annotated two novel genomes for inclusion in this study, as tabulated below. The GitHub repository [`novel_genomes`](https://github.com/PollyHannah/novel_genomes) houses data associated with the assembly and annotation of these genomes, including the script and software I used. 

| Genome | Accession |Identification number  | Collection date | Host |
|--------|-----------|-----------------------|-----------------|------|
| 1 | Not yet created | 23-04361-0003 | 2 November 2023 | Swordtail ornamental fish (*Xiphophorus helleri*) |
| 2 | Not yet created | 23-04361-0005 | 2 November |  Platys (*Xiphophorus maculatus*) |

### Run Prokka on genomes
Now we've collected and have checked the length of the genomes, we re-annotate them using Prokka using the below script. This script will save the output files to a directory `prokka_outputs_1`. This directory (including the outputs) can be found in this repository. The directory contains 76 Prokka output directories for for 76 genomes.
```bash
bash script_one_prokka.sh
```

### Save proteome files to a central folder.
Collect the proteome files from the `prokka_outputs_1` directory and save them to `proteome_1` directory. This step is done in preparation for running OrthoFinder, a program which uses the proteome files as inputs.
```bash
bash script_two_collect_proteome_files.sh
```

### Manual check of annotations and identification of sequencing or assembly errors
Computers are great but they're not perfect. This is why I manually curate the prokka-assigned annotations using Geneious Prime. This process will also reveal possible sequencing or assembly errors in genomes, allowing you to remove such genomes from the analysis to avoid them impacting the results of the study. 

#### Steps to follow
1. Export the .gff file generated by prokka and drag and drop it into Geneious Prime (Version 2020.2.5).
2. Pairwise align the file with the .gb (Genbank Full) file in GenBank, for the same genome.
3. Check each prokka annotation and decide to either keep it as-is, edit it or remove it.
4. Create a directory `proteome_2_family`.
5. Save all the manually curated proteome files for all genomes as .faa files into the `proteome_2_family` directory.
6. If at any stage you spy something you think is an assembly or sequencing error in a genome - remove it from the analysis all-together. 

To save time, I didn't manually check every annotation for every genome. Head to the directory [`annotation_check`](https://github.com/PollyHannah/Phylogenomic-study/tree/main/annotation_check) for information including; the annotations I manually checked for each genomes, how i decided which annotations I kept, edited or removed, a list of the annotations which I edited or removed, the genomes removed from my analysis due to assumed sequencing or assembly errors (and why), and how I processed proteome files to get them into a format ready for the next step of the pipeline. 

## Part Two: Core gene analysis
This is where we take the freshly re-annotated sequences and identify a set of core genes with the help of OrthoFinder.

### Sort proteome files by taxonomic level
We run Orthofinder three times - once each with genomes at the family, genus and species level. To do this we need to sort the proteomes we generated as part of 'Part One: re-annotation and quality check' into three sperate directories. 

To do this, run the below script which will copy the proteomes in the directory `proteome_2_family` and save the the species proteomes to the `proteome_2_species` and the genus proteomes to `proteome_2_genus`. 
The script uses the text files `file_list_genus.txt` and `file_list_species.txt` to do this.  
```bash
script_TBC_sort_proteome_files.sh
```
You should have:
* 72 files in the directory `proteome_2_family`, and
* 62 files in a directory `proteome_2_genus`, and
* 58 files in a directory `proteome_2_species`.

### Run OrthoFinder (again)
Now, using one script, we run Orthofinder three times (once each on the proteome files in the directories). 
* `proteome_2_family`,
* `proteome_2_genus`, and
* `proteome_2_species`.
  
The output files will be saved (respectively) into three new directories 
* `orthofinder_2_family`,
* `orthofinder_2_genus`, and
* `orthofinder_2_species`.
```bash
script_TBC_orthofinder.sh
```
### Identify core genes 
We now use R (version 4.0.5) to identify a set of core genes using the Orthofinder output. First we analyse using the script `orthogroup_analysis.R`. Then, we filter out set of core genes using the script `filter_orthogroups.R`. 

#### 1. Analyse
First we analyse the Orthofinder output to help us make a decision about which genes we consider to be 'core genes'. To do this, move the files `taxonomy.csv`and `Orthogroups.tsv` (an output file from Orthofinder), and script `script_TBC_r_analysis.R` into a directory. 

Before we do this analysis, set up three directories to store the results at each taxonomic level:
```bash
mkdir -p r_analysis_results/{family,genus,species}
```

The load R:
Load R module 
```bash
module load R
```

Run the R script in this repository. To do this, you will need the `Orthogroups.tsv` file in the directory from which you run the script. I reccomend running it from the mcv directory. Use the cp (copy) command to copy the .tsv file from the relevant directory (either the `orthofinder_2_family`, `orthofinder_2_genus`, or `orthofinder_2_species` directory) to the mcv directory. 

For example, if you were doing the analysis at the family level:
``` bash
cp ./orthofinder_2_family/Results_*/Orthogroups/Orthogroups.tsv .
```

Now that's done, run the script as so:
```bash
Rscript script_TBC_r_analysis.R -o Orthogroups.tsv -t taxonomy.csv
```

An output file should now be saved in your current directory. The file will be `orthogroups_occpancy.tsv`. This .tsv file contains the Orthofinder output for the relevant taxonomic level (family, genus or species) as well as a column on the far right which provided the 'Occupancy' for each Orthogroup. The Occupancy is provided for each orthogroup, and is the percentage of genomes with an ortholog assigned to the orthogroup. 

Each time you run the script, use the mv (move) command to save your output files into the relevant directory in the newly created `r_analysis_results` directory. For exmaple, if you have just ran the first R script using family level data, go:
```bash
mv *.tsv ./r_analysis_results/family
```

Saved in the directory `r_analysis_results` you'll find my results for each taxonomic level. 

##### Output file: Histogram 
The `orthogroups_occpancy_histogram.pdf` file should look something like the image below. It contains a histogram showing the number of orthogroups on the Y axis and Occupancy (%) on the x axis. The Y axis corresponds to the number of orthogroups at each level of Occupancy. 
![Histogram exmaple for Github](https://github.com/user-attachments/assets/e87b1aad-b5a6-4c4d-b6ad-0691eb8f90b0)


##### Output file: Orthogroup data
The `orthogroups_occpancy.tsv` should look something like the image below. It includes the raw data used to generate the histogram along with the 'Occupancy' for each orthogroup.
![R script output](https://github.com/user-attachments/assets/5e71f5ee-b6c2-4b68-8a52-36acc6abe271)

Have the files as shown above? Great! Now run the same analysis for the remaining two taxonomic levels (specifying the options as described above), and decide on a core gene criteria based on your results. 

##### Decide on a core gene criteria (occupancy threshold)
Based on the output files from the 'analyse' step above, you can decide on which orthogroups you would like to retain for further analysis. I did this based on the 'Occupancy Threshold' which is the minimum proprtion of genomes where a gene is present, for it to be retained for further analysis. The higher the occupancy threshold (i.e. the more genomes with the gene present) the less genes you'll retain. 

Once you've decided on the occupancy threshold you can move on to next step.

#### 2. Collect multiple sequence alignments
Now collect the multiple sequence alignment files for each orthogroup based on occupancy. 

First make three directories:
```bash
mkdir alignments_family alignments_genus alignments_species
```
You will now have three new directories containing multiple sequence alignment files (`.fa` files) as outlined below. 
* [alignments_family](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_family) (contains 114 files)
* [alignments_genus](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_genus) (contains 155 files)
* [alignments_species](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_species) (contains 155 files)

Then, look at the `orthogroups_occpancy.tsv` for each taxonomic level and check out the occupany of each orthogroup. If the occupancy of an orthogroup is above or equal to the occupancy threshold you chose, them move it into the newly created directory for the relevant taxonomic level.  

#### 3. Re-align alignments 
I used [MUSCLE5](https://github.com/rcedgar/muscle) (version 5.0.1428) to re-align the mafft alignments to imporve the accuracy of the alignments. The script to do this is in this repository which saved the re-aligned files into three new directories. Run it like this:
```bash
bash script_TBC_muscle.sh
```
You will now have three new directories containing re-aligned multiple sequence alignment files (`.fa` files) as outlined below. 
* [alignments_family_muscle](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_family__muscle) (contains 114 files)
* [alignments_genus_muscle](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_genus_muscle) (contains 155 files)
* [alignments_species_muscle](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_species_muscle) (contains 155 files)

#### 4. Editing alignments (by eye)
I then uploaded the re-aligned multiple sequence alignments to Geneious Prime (version 2020.2.5) and edited them by eye. The changes I made and the reasons why can be found in [`alignment_manual_changes.xlsx`](https://github.com/PollyHannah/Phylogenomic-study/blob/main/alignment_manual_changes.xlsx).

Where there was a low level of sequence conservation in one sequence compared to other closely related seuqneces (sequences of the same genotype) and increases in the alignment quality was not able to be achieved, I deleted these sequences.

I saved the hand-edited alignments in the following directories in this repository.
* [alignments_family_muscle_edited](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_family_muscle_edited) (contains 114 files)
* [alignments_genus_muscle_edited](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_genus_muscle_edited) (contains 155 files)
* [alignments_species_muscle_edited](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_species_muscle_edited) (contains 155 files)

#### 5. Trim alignments 
Now use [TrimAL ](https://github.com/inab/trimal) (version 1.4.1r22) to trim the multiple sequence alignments by removing columns where fewer than 25% of sequences contain an amino acid. The script I wrote to complete this trimming is saved in this repository. To run it, go:
```bash
script_TBC_trimal.sh
```
You will now have three new directories containing trimmed multiple sequence alignment files (`.fa` files) as outlined below. 
* [alignments_family_muscle_edited_trimmed](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_family_muscle_edited_trimmed_25) (contains 114 files)
* [alignments_genus_muscle_edited_trimmed](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_genus_muscle_edited_trimmed_25) (contains 155 files)
* [alignments_species_muscle_edited_trimmed](https://github.com/PollyHannah/Phylogenomic-study/tree/main/alignments_species_muscle_edited_trimmed_25) (contains 155 files)

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
Tange, O. (2021, March 22). GNU Parallel 20210322 ('2002-01-06').
  Zenodo. https://doi.org/10.5281/zenodo.4628277

Zhang, C., Zhao, Y., Braun, E. L., & Mirarab, S. (2021). TAPER: Pinpointing errors in multiple sequence alignments despite varying rates of evolution. Methods in Ecology and Evolution, 00, 1– 14. https://doi.org/10.1111/2041-210X.13696
Zhao, R., Gu, C., Zou, X., Zhao, M., Xiao, W., He, M., He, L., Yang, Q., Geng, Y., & Yu, Z. (2022). Comparative genomic analysis reveals new evidence of genus boundary for family Iridoviridae and explores qualified hallmark genes. Computational and Structural Biotechnology Journal, 20, 3493–3502. https://doi.org/10.1016/j.csbj.2022.06.049
