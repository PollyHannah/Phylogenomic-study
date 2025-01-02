# Classification protocol
Not all *Megalocytivirus* genomes entered into the National Centre for Biotechnology Information (NCBI) GenBank database are classified as one of the currenrly recognised species / genotypes

There are currently two species of megalocytivirus recognised by the International Committe for the Taxonomy of Viruses. The two recognised species are *Megalocytivirus pagrus1* and *M. lates1*. *Megalocytivirus pagrus1* is further divided into three genotypes which are:
* red sea bream iridovirus (RSIV), 
* infectious spleen and kidney necrosis virus (ISKNV), 
* and turbot reddish body iridovirs (TRBIV).

You need to classify *M. pagrus1* genomes to the genotype level to complete this study. This classification is important for Part one: re-annotation and quality check, as well as Part Two: Core gene analysis. 

## How did i classify megalocytivirus genomes?
I classified *Megalocytivirus* genomes down to the species / genotype level based on sequence similarity. To do this, I chose a reference genome from each of the three *M. pagrus1* genotypes and one for the *M. lates1* species (tabulated below). I chose these genomes given they were published in a peer reviewed journals and were available on NCBI Genbank as fully annotated genomes.

| Genotype or species | Accession | Publication DOI |
|--------------------|-----------|-----------------|
| ISKNV | AF371960 | https://doi.org/10.1006/viro.2001.1208 |
| RSIV | MK689686 | https://doi.org/10.3354/dao03499 |
| TRBIV | GQ273492 | 10.1186/1743-422X-7-159 |
| SDDV | OM037668 | https://doi.org/10.3390/v13081617 |

### FastANI
I then used FastANI (version 1.34) to compute the sequence similarity between all the genomes included in my study and each of the reference genomes tabulated above. 

FastANI computes whole-genome Average Nucleotide Identity (ANI) which is the mean nucleotide identity of orthologous gene pairs shared between two genomes.

The script I used is saved to this directory. To run it, you will need:
* the reference genomes as .fasta files (see `reference_genomes` in this directory). 
* the query genomes as .fasta files (see `query_genomes` in this dircetory) 
* a text file with the paths to each reference genome (see `reference_list.txt` in this directory)
* a text tile with the paths to each query genome (see `query_list.txt` in th is directory)

First up, load the module
```bash
module load fastani
```

Second up, upload the above files to your mcv directory and from the mcv directory run:
```bash
fastANI --ql query_list.txt --rl reference_list.txt -o fastani.out
```

### FastANI Output
Fast ANI will output a file `fastani.out`. The output file will contain tab delimited rows with query genome, reference genome, ANI value, count of bidirectional fragment mappings, and total query fragments.The ANI value is the ratio of mappings and total fragments. 
Importantly, no output is reported for a genome pair if ANI value is much below 80%. Such case should be computed at amino acid level.

### Classification 
I classified genomes based on the alignment fraction percentage. Genomes were classified as the genotype which returned the highest percentage. The alignment fraction percentage scores for each genome are provided in `taxonomy.csv` in this repository as 'sequence similarity' scores. 


# References
Jain, C., Rodriguez-R, L.M., Phillippy, A.M. et al. High throughput ANI analysis of 90K prokaryotic genomes reveals clear species boundaries. Nat Commun 9, 5114 (2018). https://doi.org/10.1038/s41467-018-07641-9
