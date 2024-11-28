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
