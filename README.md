# Phylogenomic analysis 

## About 
This project aims to conduct a phylogenetic analyses of megalocytiviruses, a group of fish pathogens exotic to Australia, providing robust information with which to propose a clear and simple nomenclature of this group. This is a pipeline designed to produce a Maximum Liklihood species tree for megalocytiviruses and closely related viruses by concatonating a set of core genes present across all genomes. 

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
Then retry the prokka script. If run successfully, the prokka_outputs folder created in script_one_prokka.sh in the mcv directory will contain multiple outputs.

### Save proteome files to a central folder.
This step is done in preparation for running Orthofinder, a program which uses proteomes files.

```bash
bash script_two_collect_proteome_files.sh
```

### Run Orthofinder 

Orthofinder is a program which identifies orthogroups and orthologs between genomes. It also infers rooted gene trees for all orthogroups and a rooted species tree for the species included in the analysis.

Open 'script_three_orthofinder.sh' and nominate values for options -t (-t number_of_threads) and -a (-a number_of_orthofinder_threads). These options control the parallelisation of OrthoFinder to decrease the runtime. For -t, choose the  number of cores on your computer. For -a, put 1/4 of the value of -t. 

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

If you get an error that one of the installed Orthofinder dependencies (i.e. modules) cannot be located, load the module yourself. For example

```module load blast+
```

### Remove trailing spaces in .fa files 
To visualise Multiple Sequence Alignment (MSA) outputs from Orthofinder in Geneious, the trailing spaces at the end of the MSA need to be removed. Otherwise, Geneious will report an error 'some sequences contain gaps, but not all sequences are of the same length'. 

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

### Generate gene trees
To generate gene trees for each MSA using iqtree, first remove MSAs for orthgroups for which you do not want to genertae a gene tree for (i.e. orthogroups not containing core genes of interest). Then, open the script attached to this repository titled 'script_four_iqtree.sh' and insert the file path to your MSA directory in the relevant sections (as indicated in the script). Then, run updated script:

```bash
script_four_iqtree.sh
```

### Sort output files 
iqtree will generate several outputs for each input file with a variety of extensions. All outputs will be saved in the one output directory. You will need to please sort the output files into seperate directories based on orthogroup. Open the script saved to this repository 'script_five_sort_files.sh'and update the file path to where the outputs are saved. Then, run the updated script.

```bash
script_five_sort_files.sh
```
