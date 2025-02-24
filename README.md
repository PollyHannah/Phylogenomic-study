# Phylogenomic analysis 

## About 
This repository houses the details of my bioinformatic pipeline for my phylogenetic analyses of megalocytiviruses, a group of fish pathogens exotic to Australia, and other members of the family *Iridoviridae*. A set of core genes are first identified followed by phylogenetic analysis of the core genes. 

Go to the file `setup.md` in this repository, for information about how to set-up a conda environment. The same file houses information on how to complete basic tasks like transfering files and fixing errors you might receive while completeing this analysis. You will need the following software:
* [Prokka](https://github.com/tseemann/prokka) (version 1.14.5)
* [OrthoFinder](https://github.com/davidemms/OrthoFinder) (version 2.5.4)
* [IQ-TREE2](https://github.com/iqtree/iqtree2) (version 2.2.0.5)
* [TAPER](https://github.com/chaoszhang/TAPER) (version 1.0.0)

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
I included all megalocytivirus genomes saved as 'complete' genomes under the genus *Megalocytivirus* in the NCBI GenBank the Taxonomy Browser, which were the expected length. This included genomes entered into NCBI Genbank as 'unclassified' at the species level. Genomes which were not the expected length meant genomes which were half or twice the length of other *Megalocytivirus* genomes. One megalocytivirus genome was not included given it was smaller than the expected length (accession KC138895). KC138895 is was 903 base pairs (bp) in length whereas megalocytiviruses are between 110,000 and 140,000 bp in length. 

I also included ten representative genomes from each of the six other iridovirid genera including two genomes from each genus where multiple genomes are available (two each from of the genera *Ranavirus*, *Lymphocystivirus*, *Iridovirus*, and *Chloriridovirus*; one each from of the genera *Decapodiridovirus* and *Daphniairidovirus*). I also ensured these genomes were the expected length. Genomes which were not the expected length meant genomes which were half or twice the length of other genomes in the same genus. 

These genomes were chosen to span the deepest node of the given clade shown in Zhao et al. (2022) except for the genus *Lymphocystivirus*. One of the lymphocystivirus genomes initally chosen for inclusion, L63545, was half the expected length at 102,653 bp long. Lymphocystivirus genomes are typically around 200,000 bp in length. I replaced L63545 with another genome from the same genus (KX643370) which was the expected length (208,501 bp). 

The information for KX643370 and L63545 can be found in the `taxonomy.csv` file in this repository.

##### Novel genomes
I've sequenced, assembled and annotated two novel genomes for inclusion in this study, as tabulated below. The GitHub repository [`novel_genomes`](https://github.com/PollyHannah/novel_genomes) houses data associated with the assembly and annotation of these genomes, including the script and software I used. 

| Genome | Accession |Identification number  | Collection date | Host |
|--------|-----------|-----------------------|-----------------|------|
| 1 | Not yet created | 23-04361-0003 | 2 November 2023 | Swordtail ornamental fish (*Xiphophorus helleri*) |
| 2 | Not yet created | 23-04361-0005 | 2 November |  Platys (*Xiphophorus maculatus*) 

### Run Prokka on genomes
Now we've collected and have checked the length of the genomes, we re-annotate them using Prokka using the below script. This script will save the output files to a directory `prokka_outputs_1`. This directory (including the outputs) can be found in this repository. As I added new genomes to my analysis I re-ran Prokka. That's why there are multiple results files in the `prokka_outputs_1` directory.
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
First we analyse the Orthofinder output to help us make a decision about which genes we consider to be 'core genes'. To do this, move the files `taxonomy.csv`and `Orthogroups.tsv` (an output file from Orthofinder), and scripts `orthogroup_analysis.R` and `filter_orthogroups.R` into a directory. 

Before we do this analysis, set up three directories to store the results at each taxonomic level:
```bash
mkdir -p r_analysis_results/{family,genus,species}
```

The load R:
Load R module 
```bash
module load R
```
Run the first R script in this repository. To do this, you will need the `Orthogroups.tsv` file in the directory from which you run the script. I reccomend running it from the mcv directory. Use the cp (copy) command to copy the .tsv file from the relevant directory (either the `orthofinder_2_family`, `orthofinder_2_genus`, or `orthofinder_2_species` directory) to the mcv directory. 

For example, if you were doing the analysis at the family level:
``` bash
cp ./orthofinder_2_family/Results_*/Orthogroups/Orthogroups.tsv .
```

Now that's done, you need to specify the taxonomic level you want to analyse with the first R script using option -l. The option can be either Genus, Species, or Genotype. If you want analyse data at the genus level specify the option Genus (as is shown in below). If want to analyse the data at the species level, specify 'Species', and so on.
```bash
Rscript script_TBC_orthogroup_analysis.R -o Orthogroups.tsv -t taxonomy.csv -l Genus
```

Two output files should now be saved in your current directory. Each filename will be specific to the input variables. For example, if you did a Genus-level analysis they will be called `faceted_histogram_by_Genus.pdf` and `orthogroups_with_Genus_completeness.tsv`. 

Each time you run the script, use the mv (move) command to save your .pdf and .tsv files into the relevant directory in the newly created `r_analysis_results` directory. For exmaple, if you have just ran the first R script using family level data, go:
```bash
mv *.pdf *.tsv ./r_analysis_results/family
```

Saved in the directory `r_analysis_results` you'll find my results for each taxonomic level. 

##### Output file: Histogram 
The `faceted_histogram_by_Genus.pdf` file should look something like the image below. It contains several histograms showing the number of orthogroups on the Y axis and Occupancy Threshold (%) on the x axis. The Occupany Threhold is the proportion of genomes with orthologs in orthogroups. They Y axis corresponds to the number of orthogroups at each Occupancy Threshold. 
![Occupany threshold histogram](https://github.com/user-attachments/assets/33a36c34-78ed-4471-9aa3-c656d8c96561)

##### Output file: Orthogroup data
The `orthogroups_with_Genus_completeness.tsv` should look something like the image below. It includes the raw data used to generate the histogram along with other informative data such as the genera missing from each orthogroup.
![R script output](https://github.com/user-attachments/assets/5e71f5ee-b6c2-4b68-8a52-36acc6abe271)

Have the files as shown above? Yay! Now run the same analysis for the remaining two taxonomic levels (specifying the options as described above), and decide on a core gene criteria based on your results. 

##### Decide on core gene criteria
Based on the output files from the 'analyse' step above, you can decide on a couple of parameters for your 'core genes'. The first parameter is the 'Occupancy Threshold' which is the minimum proprtion of genomes where a gene is present, for it to be considered a core gene. The higher the occupancy threshold (i.e. the more genomes with the gene present) the less core genes you'll have. The second parameter is the minimum number of taxa in which a gene is present for it to be considered a core gene. Once again, the higher you set this parameter, the the less core genes you will have. 

Once you've decided on those two parameters you can move on to the filtering step below to identify the genes which match your criteria. 

#### 2. Filter
Now we filter out the core genes using the second script in this repository. Run the below script specifying the relevant taxonomic level with the option -1 (Genus, Species, or Genotype), the Occupancy Threshold chosen with option -a (anywhere between 1 and 100), and the minimum number of taxa you want included in each orthogroup with the option -r .  
```bash
Rscript script_TBC_filter_orthogroups.R -o Orthogroups.tsv -t taxonomy.csv -l Genus -a 75 -r 5
```
Make a directory called `filtered_orthogroups`
```bash
mkdir filtered_orthogroups
```
Each time you filter out orthogroups using the script above, collect the.tsv file and store them in the `filtered_orthogroups` directory. 

Now we'll collevct the multiple sequence alignment files which match the shortlist we've generated in with the .tsv files. To do this, first ensure you open up each script below and change the names of the input and output files accordingly before running them (in order). 

We use R to do this, so first load the module. 
```bash
module load R
```

Run the script below to create a list of the multiple sequence alignment files (.fa files) for each orthogroup:
```bash
Rscript script_TBC_extract_orthogroups_names.R
```

Move each of the .fa files to a new directory:
```bash
bash script_TBC_move_msa.sh
```

#### 3. Trim alignments 
Now use [TAPER](https://github.com/chaoszhang/TAPER) (Zhang et al. 2021) to trim the multiple sequence alignments according to quality by running the script below. TAPER will use multiple sequence alignment files you have moved into the new directory above, as input.	

Create input file required by TAPER to trim the multiple sequence alignment files by quality. This script will produce a text file (.txt) which lists the file patho to each input file (multiple sequence alignment) and output file. All the output files will be saved in a new directory. 
```bash
bash script_TBC_make_input_taper.sh
```

The output file should look something like this:

Now, run TAPER on each file using the script below. The trimmed multiple sequence alignments will be saved in a newly created directory. 
```bash 
script_TBC_taper.sh
```

Check the output directory. You should have a bunch of .fa files saved in there (the same number of files as you had an input).

### Manually check and edit Multiple Sequence Alignments
I manually curate the OrthoFinder-generated MSA files using Geneious Prime (Version 2020.2.5). 

#### Steps to take
1. Export the MSA files generated by OrthoFinder and drag and drop it into Geneious Prime.
2. Check each file and make edits where neccessary. 
3. Create a directory in the mcv directory `3_mafft_alignments`.
4. Save all the manually curated MSA files for all genomes.

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
Zhang, C., Zhao, Y., Braun, E. L., & Mirarab, S. (2021). TAPER: Pinpointing errors in multiple sequence alignments despite varying rates of evolution. Methods in Ecology and Evolution, 00, 1– 14. https://doi.org/10.1111/2041-210X.13696
Zhao, R., Gu, C., Zou, X., Zhao, M., Xiao, W., He, M., He, L., Yang, Q., Geng, Y., & Yu, Z. (2022). Comparative genomic analysis reveals new evidence of genus boundary for family Iridoviridae and explores qualified hallmark genes. Computational and Structural Biotechnology Journal, 20, 3493–3502. https://doi.org/10.1016/j.csbj.2022.06.049
