# Intro

# Set up the environment

You can set up your conda environment as follows:

```bash
conda create --name mcv
conda activate mcv
conda install -c bioconda prokka 
conda install -c bioconda orthofinder
```

Alternatively, you can set it up with the YAML file in this repository as follows:

```bash
conda env create -f mcv_environment.yml
conda activate mcv
```
