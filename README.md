# Phylogenomic analysis for megalocytiviruses 

## About 
This project aims to conduct a whole-genome, phylogenetic analyses of megalocytiviruses, a group of fish pathogens exotic to Australia, providing robust information with which to revise the taxonomy and nomenclature of this group. This is a pipeline designed to produce a phylogeny of megalocytiviruses and closely related viruses by concatonating a set of core genes present across all genomes. 

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

### Set up conda environment

```bash
conda create --name mcv
conda activate mcv
conda install -c bioconda prokka 
conda install -c bioconda orthofinder
```
### Annotate genomes using Prokka 

```bash
bash script_one_prokka.sh
```

### Save proteome files to a central folder.
This step is done in preparation for running Orthofinder, a program which uses proteomes files.

```bash
bash script_two_collect_proteome_files.sh
```

### Run Orthofinder 

Orthifinder is a program which identifies orthogroups and orthologs between genomes. It also infers rooted gene trees for all orthogroups and a rooted species tree for the species included in the analysis.

```bash
bash script_three_orthofinder.sh
```
