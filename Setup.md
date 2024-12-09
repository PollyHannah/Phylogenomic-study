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
### How to save genomes to a directory
You can do this by using software such as Cyberduck which you can download here 
https://cyberduck.io/download/.

Iridovirid genomes in Genomes folder follow the naming convention: genera_species_GenBank-organism-name_accession-number.

To transfer files follow the instructions here
https://www.exavault.com/docs/cyberduck-connecting. If using Cyberduck, make sure you are using SFTP 'SSH File Transfer Protocol'.


### General bugs 
#### Reformat to Unix 
If at any time you get an error indicating a command is not recognised in any of the scipts above, try this command:
```bash
dos2unix file_name
```

### Prokka bugs
If you get an error from prokka saying that you need a later version of blast, here's a fix for that:
```bash
conda install -c conda-forge libgcc-ng
conda install -c bioconda blast=2.9.0
```
If you've used the fix above, delete `prokka_outputs` directory before running script again.
```bash
rm -r prokka_outputs
```
Then retry the prokka script. If run successfully, the `prokka_outputs` directory created in the mcv directory will contain multiple outputs.

### Orthofinder bugs 
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

### Geneious bugs

Not able to visualise multiple sequence alignments in Geneious Prime? 

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
