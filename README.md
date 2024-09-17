# Phylogenomic analysis 

## About 
This project aims to conduct a phylogenetic analyses of megalocytiviruses, a group of fish pathogens exotic to Australia, providing robust information with which to propose a clear and simple nomenclature of this group. This is a pipeline designed to produce a Maximum Likelihood species tree for megalocytiviruses and closely related viruses by concatonating a set of core genes present across all genomes. 

Megalocytivirus is a genus of fish pathogens belonging to the family of viruses the Iridoviridae.
## Set up environment

Install conda via https://www.anaconda.com/download/success.

### Download the Installer Script
Download the installer script using wget command. You can find the installer script URL by right-clicking on the relevant link from the Anaconda website linked above.
```bash
wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
```
Make script executable
```bash
chmod +x Anaconda3-2024.06-1-Linux-x86_64.sh
```
Run installer script
```bash
./Anaconda3-2024.06-1-Linux-x86_64.sh
```

### Ensure you can write to .condarc file
The .condarc is an optional configuration file that stores custom conda settings, which you will need to write to. 

Locate the .condarc file. 
```bash
find -name *.condarc
```
Navigate to the directory the file is located in.
```bash
cd /path/to/file
```
Change permissions on the file.

```bash
chmod 777 condarc
```

### Set up conda environment
```bash
conda create --name mcv
conda activate mcv
conda install -c bioconda prokka 
conda install -c bioconda orthofinder
conda install conda-forge::parallel
conda install -c bioconda iqtree
```

### Set up directory for this work
```bash
mkdir mcv
cd mcv
```

### Save genomes to mcv directory
Download 'Genomes' folder and its contents from this repository, to use as input files. Save the folder 'Genomes' and contents to mcv directory. You can do this by using software such as Cyberduck which you can download here 
https://cyberduck.io/download/.

Iridovirid genomes in Genomes folder follow the naming convention: genera_species_GenBank-organism-name_accession-number.

To transfer files follow the instructions here
https://www.exavault.com/docs/cyberduck-connecting. If using Cyberduck, make sure you are using SFTP 'SSH File Transfer Protocol'.

### Reformat to Unix 
If at any time you get an error indicating a command is not recognised in any of the scipts above, try this command:
```bash
dos2unix file_name
```

### Annotate genomes using Prokka 
```bash
bash script_one_prokka.sh
```

If you get an error from prokka saying that you need a later version of blast, here's a fix for that:
```bash
conda install -c conda-forge libgcc-ng
conda install -c bioconda blast=2.9.0
```
If you've used the fix above, delete prokka_outputs folder before running script again.
```bash
rm -r prokka_outputs
```
Then retry the prokka script. If run successfully, the prokka_outputs folder created in the mcv directory will contain multiple outputs.

### Save proteome files to a central folder.
Collect the proteome files from the prokka_outputs directory and save them to 1_prokka directory. This step is done in preparation for running OrthoFinder, a program which uses proteomes files.

```bash
bash script_two_collect_proteome_files.sh
```

### Run OrthoFinder 

OrthoFinder is a program which identifies orthogroups containing a set of orthologs (genes) from various genomes. For the purpose of this analysis, orthogroups which contain an orthologs from every Megalocytivirus genome are considered core megalocytivirus genes, and orthogroups containing an ortholog from every genome across the Iridoviridae family are considered Iridoviridae core genes. 

OrthoFinder also infers rooted gene trees for all orthogroups and a rooted species tree for the species included in the analysis. For this analysis, we're only interested in the Orthogroups, Orthologues and gene trees produced.

#### Nominate values for OrthoFinder options
Open 'script_three_orthofinder.sh' and nominate values for options -t (-t number_of_threads) and -a (-a number_of_orthofinder_threads). These options control the parallelisation of OrthoFinder to decrease the runtime. For -t, choose the  number of cores on your computer. For -a, put 1/4 of the value of -t. 

This script will take the proteome files from the directory '1_prokka' and store the output files in a directory '1_orthofinder'.

Run updated script.
```bash
bash script_three_orthofinder.sh
```

If you get an error indicating a problem with a dependency (for example, DIAMOND), manually install the lastest version of the dependency. 

Find the location of the dependency in the system path.
```bash
which diamond

```
Copy the file path to your clipboard and download the latest version of the dependency.
```bash
wget https://github.com/bbuchfink/diamond/releases/latest/download/diamond-linux64.tar.gz
```

Extract the contents of a compressed file (a tarbell file in this instance).
```bash
tar xzf diamond-linux64.tar.gz
```

Copy the executable to the relevant directory in your system path
```bash
sudo cp diamond /file/path/saved/to/clipboard
```

If you get an error that one of the installed OrthoFinder dependencies (i.e. modules, like DIAMOND or blast+) cannot be located, load the module yourself. For example
```bash
module load blast+
```

### Manually check and edit annotations 
Computers are great but they're not perfect. This is why, in theis pipeline, I manually curate the prokka-assigned annotations using Geneious Prime. I recorded all changes in the spreadsheet 'Manual Check_Nucleotide alignment Annotations' in the 'prokka_outputs' directory in this repository.

#### Steps to follow
1. Export the .gff file generated by prokka and drag and drop it into Geneious Prime (Version 2020.2.5).
2. Pairwise align the file with the .gb (Genbank Full) file in GenBank, for the same genome.
3. Check each annotation and decide to either keep it as-is or edit it.
4. Create a directory in the prokka_outputs directory named 2_prokka_manual.
5. Save all the manually curated proteome files for all genomes as .faa files into the 2_prokka_manual directory.

##### How did I make decisions? 
I compared the prokka-annotated genome with the reference genome, and made decisions to keep it edit the prokka-annotated genome based on whether it matched the annotations in the reference genome. Where the annotations did not match, I reviewed both options and decided on the best annotation to keep based on:
* A BLASTp search of annotations on the the National Centre for Biotechnology Information (NCBI) GenBank Database. I favoured annotations with a higher number of matches, % identity to matches, and % query cover.
* I also checked whether stop codons were present in the annotation. If a 'favoured annotation' (as described above) had ≤3 stop codons i kept the annotation and removed the stop codons. Yet if a 'favoured annotation' had >3 stop codons i kept the less-favoured annotation if there was one. If there was no 'favored annotation' (i.e. there was no alternative annotaion option in the .gff file or .gb file) I deleted the annotation all together. 

###### Megalocytivirus genomes
I completed this process for one genome from each Megalocytivirus genotype and species, as well as for every one of the Megalocytivirus 'Unclassified' genomes. 

For the Megalocytivirus genomes for which i did not complete this process I transferred the manually curated annotations with 85% similarity from the relevant genotype. I did this using the 'Annotate From' option in the'Live Annotate and Predict tab' in Geneious Prime (Version 2020.2.5). I then manually curated the transfered annotations checking for stop codons following the same decision-making process as described above. 

Listed below are the genotypes i transferred annotation from (in **bold**), and beneathe them, the genomes the annotations from that genotype were tranferred to. 

**Scale drop disease virus**

**OM037668**
* MN562489 
* MT521409 

**Infectious spleen and kidney necrosis virus**

**AF371960** 
* MK689685 
* MN432490 
* MT926123 
* MT986830 
* OP009387 

**Red sea bream iridovirus**

**MK689686**
* AY894343 
* BD143114 
* KC244182 
* KT804738 
* MK098187 
* MK098185 
* MK098186 
* MW139932 
* OK042108 
* OK042109 
* ON075463 
* ON740976 
* ON743042 
* OL774653 
* OL774654 
* OL774655 
* MT798582 

 **Turbot reddish bodied iridovirus** 

 **GQ273492**
*  None (only one complete genome).

###### Iridoviridae genomes
For every iridoviridae genome from genera other than Megalocytivirus, I completed the manual curation process as described above, but only for the iridoviridae core genes (i.e. genes with have an ortholoug present in every Iridoviridae genome included in the analysis).

### Run OrthoFinder again
Now, run Orthofinder on the manually curated annotation files. The input files will be take from the 2_prokka_manual directory. The output files will be saved into a directory '2_orthofinder'. 
```bash
script_four_orthofinder.sh
```

### Remove trailing spaces in .fa files 
To visualise Multiple Sequence Alignment (MSA) outputs from OrthoFinder in Geneious, the trailing spaces at the end of the MSA need to be removed. Otherwise, Geneious will report an error 'some sequences contain gaps, but not all sequences are of the same length'. Try and drag and drop the MSA files into Geneious, if it rejects them and returns the error states (i.e. 'some sequences contain gaps...'), use the script below to remove the trailing spaces from all MSAs. 

**Note** Before runnning this script you will need to update the directory file path to match your file path. This path will change with every OrthoFinder run due to the naming convention for the 'Results_date' file. 

Remove trailing spaces from MSAs
```bash
#!/bin/bash

# Directory containing .fa files
directory="Path/To/Directory/MultipleSequenceAlignments"

# Loop through files in the directory
for filename in "$directory"/*.fa; do
    # Check if filename ends with .fa
    if [ -f "$filename" ]; then
        # Read file contents
        content=$(<"$filename")

        # Check and remove trailing space if present
        if [[ "$content" == *' '* ]]; then
            content=$(echo "$content" | sed 's/[[:space:]]*$//')

            # Write modified content back to file
            echo "$content" > "$filename"

            echo "Trailing space removed from: $(basename "$filename")"
        else
            echo "No trailing space found in: $(basename "$filename")"
        fi
    fi
done
```
### Manually check and edit Multiple Sequence Alignments
I manually curate the OrthoFinder-generated MSA files using Geneious Prime (Version 2020.2.5). 

#### Steps to take
1. Export the MSA files generated by OrthoFinder and drag and drop it into Geneious Prime.
2. Check each file and make edits where neccessary. 
3. Create a directory in the mcv directory named 3_mafft_alignments.
4. Save all the manually curated MSA files for all genomes.

#### INERT HERE POLLY INSTRUCTIONS FOR CLEANING MSAs
3_mafft alignments > 3_mafft_alignments_clean

### Generate gene trees
To generate gene trees for each MSA using iqtree, first remove MSAs for orthogroups for which you do not want to generate a gene tree (i.e. orthogroups not containing core genes of interest). 

Then, open the script attached to this repository titled 'script_four_iqtree.sh' and insert the file path to your MSA directory in the relevant sections (as indicated in the script). 

Activate your conda environment 
```bash
conda activate mcv
```

Run updated script:
```bash
script_four_iqtree.sh
```

### Sort output files 
iqtree will generate several outputs for each input file with a variety of extensions. All outputs will be saved in the one output directory. You will need to please sort the output files into seperate directories based on orthogroup. Open the script saved to this repository 'script_five_sort_files.sh'and update the file path to where the outputs are saved. Then, run the updated script.
```bash
script_five_sort_files.sh
```
