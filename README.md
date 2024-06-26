# Phylogenomic analysis for megalocytiviruses 

## About 
This project aims to conduct a whole-genome, phylogenetic analyses of megalocytiviruses, a group of fish pathogens exotic to Australia, providing robust information with which to revise the taxonomy and nomenclature of this group. This is a pipeline designed to produce a phylogeny of megalocytiviruses and closely related viruses by concatonating a set of core genes present across all genomes. 

## Set up environment

Install conda via https://www.anaconda.com/download/success.

### Download the Installer Script
Get installer script URL by right-clicking on the relevant link here `[text](https://www.anaconda.com/download/success)`.

Download the installer script using wget command

```bash
wget https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-s390x.sh
```

Make script executable

```bash
chmod +x Anaconda3-2024.02-1-Linux-s390x.sh
```

Run installer script

```bash
./Anaconda3-2024.02-1-Linux-s390x.sh
```

### Set up conda environment

```bash
conda create --name mcv
conda activate mcv
conda install -c bioconda prokka 
conda install -c bioconda orthofinder
```
