# Annotation check
This page includes on the annotations I manually checked and for which genomes, how I decided on which annotations I would keep, edit or remove, a list of the annotations which I edited or removed, the genomes which I removed from my analysis due to assumed sequencing or assembly errors (and why), and how I processed proteome files to get them into a format ready for the next step of the pipeline.

## Which annotations did I manually check?
The annotations I chose to manually check differed depending on whether the genome was a megalocytivirus genome, an 'unclassified' megalocytivirus genome (genomes entered into National Centre for Biotechnology Information (NCBI) GenBank Taxonomy Browser under the genus 'megalocytivirus' as 'Unclassified'), or a genome from a different iridovirid genus (i.e. not a megalocytivirus). The annotations I checked for each of these groups is provided below. I didn't check every annotation for every genomes in order to save time. 

### Megalocytivirus genomes
#### Classified genomes
I collected five genomes (tabulated below) one from each of the three *Megalocytivirus pagrus1* genotypes (infectious spleen and kidney necrosis virus or 'ISKNV', red sea bream iridovirus or 'RSIV', and turbot reddish body iridovirus or 'TRBIV') and one *Megalocytivirus lates1* or 'scale drop disease syndrome' genome. I also included the only whole genome published for a three-spined stickleback virus, which is is a megalocytivirus which infects threespine stickleback (*Gasterosteus aculeatus*). TSIV has not yet been classified into one of the two existing species. Based on phylogenetic analysis of iridovirus core genes (Yoximer et al. 2023), TSIV may represent a novel species of megalocytivirus. Where there were multiple genomes published, I chose a representitive genome which was published in a peer reviewed journal and was available on NCBI Genbank as fully annotated. 

For each of these five genomes, I checked every annotation which Prokka had assigned. I used these genomes as refererece genomes to classify genomes down to the species / genotype level as desribed in the `classification` directory.


| Genotype or species | Accession | Publication DOI |
|--------------------|-----------|-----------------|
| ISKNV | AF371960 | https://doi.org/10.1006/viro.2001.1208 |
| RSIV | MK689686 | https://doi.org/10.3354/dao03499 |
| TRBIV | GQ273492 | 10.1186/1743-422X-7-159 |
| TSIV | PQ335173_PQ335174 | https://doi.org/10.3390/v16111663 |
| SDDV | OM037668 | https://doi.org/10.3390/v13081617 |

I transferred the annotations from the manually curated genomes (above) onto the remaining genomes of the same genotype if there were any (i.e. I transferred the manually curated  ISKNV annotations onto the remaining ISKNV genomes, and all the manually curated SDDV annotations onto the remaining SDDV gemomes etc.). Below is a table showing the genomes which I transferred annotations from/to. There is only one published TRBIV and TSIV genome therefore the annotations curated for these genomes were not transferred onto any other genomes.

| Genotype or species | Annotations tranferred from (accession number) | Annotations transferred to (accession number) |
|--------------------|------------------------------------------------|-----------------------------------------------|
| ISKNV | AF371960 |  MK689685, MN432490, MT926123, MT986830, OP009387 |
| RSIV | MK689686 | AY894343, BD143114, KC244182, KT804738, MK098187, MK098185, MK098186, MW139932, OK042108, OK042109, ON075463, ON740976, ON743042, OL774653, OL774654, OL774655, MT798582, AY532606*, AY779031* |
| TRBIV | GQ273492 | none |
| TSIV | PQ335173_PQ335174 | none |
| SDDV | OM037668 | MN562489, MT521409, NC_027778* |

*Genome removed due to stop codons being present in >5 annotations.

I transferred annotations using the 'Annotate From' option in the'Live Annotate and Predict tab' in Geneious Prime (Version 2020.2.5). I set the transfer threshold for percent similarity at 85%. This meant that annotated sequences which were less than 85% similar to the sequence being annotated did not transfer. 

Once the annotations were transferred, checked each transferred annotation for stop codons and ensured the annotation started with the amino acid Methionine (M). 
* If the annotation did not start with M I removed it.
* If there were ≤5 stop codons in an annotation, I removed the stop codons from the annotation. If there were >5 stop codons in an annotation, I removed the annotation all together.
* If there were >5 annotations removed in one genome i removed the genome from the analysis due to assumed sequencing or assembly errors. 

#### Unclassified genomes
I manually checked the annotations for every megalocytivirus genome entered into NCBI genbank as 'unclassified' at the species and genus level. These genomes are tabulated below. 

| Unclassified megalocytivirus genomes (accession number) |
|---------------------------------------------------------|
| MG570131 |
| MG570132 |
| OQ475017 |
| OL310752* |

*Genome removed due to assumed sequencing or assembly error.

### Iridoviridae gemomes (not from the genus *Megalocytivirus*)
For every iridoviridae genome from genera other than *Megalocytivirus*, I completed the manual curation process as described above, but only for a small set of highly conserved genes. The genes I chose to manually curate were identified through the OrthoFinder run described in the `README.md` (Part one: re-annotation and quality check). Looking at the OrthoFinder output I manually curated the genes (or orthologs) which were assigned to orthogroups containing orthologs from 100% of genomes part of the analysis. 

I have run OrthoFinder multiple times with different sets of genomes (ones added, ones removed etc.). For each run, the output has been slightly different. The OrthoFinder run, from which the set of highly conserved genes were chosen for manual curation, is provided for each genome in the file `annotation_check_results`/`annotations_manual_file.xlsx`. The results files for each run can be found in the `orthofinder_1` directory. OrthoFinder names results directories based on the date the results were produced (Results_Jul07, Results_Nov29 etc.)

## How did I decide whether to keep, edit, or delete annotations?
I started by downloading the General Feature File (.gff) produced by Prokka (version 1. 14. 5) for every genome I annotated and pairwise aligned the file in Genenious Prime (version 2020.2.5) with the GenBank (.gb) file from NCBI GenBank Database for the corresponding genome. I moved through the genome looking at each annotation and did the following:
* Where the Prokka and GenBank annotations matched, I kept the annotation as-is. Where the annotations did not match, I did a A BLASTp search of both annotations on the the NCBI GenBank Database. I favoured annotations with a higher number of matches, % identity to matches, and % query cover.
* I then checked whether stop codons were present in the annotation. If a 'favoured annotation' (as described above) had ≤5 stop codons I kept the annotation and removed the stop codons. Yet if a 'favoured annotation' had >5 stop codons I kept the less-favoured annotation (if there was one). If the annotation had >5 stop codons and there was no 'favored annotation' (i.e. there was no alternative annotation option in the .gff file or .gb file) I deleted the annotation all together. 
* I then exported out of from Geneious Prime (version 2020.2.5), a list of the annotations (amino acid sequences) for each genome. 
* I then exported the list as a .csv file and converted it to a .txt file. I used this text file to input into the next Orthofinder run described in the `README.md` file for Part Two: Core gene analysis.

## Which genomes were removed due to sequencing or assembly errors? 
Throughout this manual annotation check process, I identified four genomes which I removed from my analysis due to assumed sequencing or assembly errors. These genomes, and the reasons I removed them, are tabulated below. 

| Genome (accession number) | Genotype | Reason excluded from analysis |
|---------------------------|----------------------------|-------------------------------|
| OL310752 | Unclassified | Two genes were assigned to orthogroup G000000 in the OrthoFinder output 'Results_Jul07' which was one gene in all other genomes. I could tell this by looking at the multiple sequence alignment for this orthogroup in the OrthoFinder 'Results_Jul07' output. It appeared the gene was split in OL310752 and each section was located in two very different locations in the genome. I believe this may be indicative of a sequencing or assembly error and so i removed the genome from my analysis. | 
| AY532606 | RSIV | >5 annotations removed from the genome |
| AY779031 | RSIV | >5 annotations removed from the genome |
| NC_027778 | SDDV | >5 annotations removed from the genome |

## Where are my results? 
Most of the files used/generated for each stage of the process above can be found in this repository.
1. The **74** Genbank (.gb) files included in this analysis initially can be found in genomes_1 directory.
  * One genome (OL310752) was removed from the analysis due to assumed sequencing of assembly error. 
3. The **73** GenBank (.gb) files before the stop codon check can be found in this repository at `annotation_check_results`/`1_genomes_before_stop_codon_check`.
  * Three genomes were removed as part of this step for having too many stop codons in some annotations (AY532606, AY779031 and NC_027778). 
4. The **70** Genbank (.gb) files post stop codon check can be found in this repository at `annotation_check_results`/`1_genomes_post_stop_codon_check`.
5. The **70** Genbank (.gb) files as lists of annotations post stop codon check can be found in this repository at `annotation_check_results`/`3_annotations_post_stop_codon_check`.
6. The **70** Genbank (.txt) files as lists of annotations post stop codon check can be found in this repository at `annotation_check_results`/`3_annotations_post_stop_codon_check`.
   * Sometimes, I found pesky stop codons after I'd converted the file to a .txt file. I removed the stop codons where there were ≤5 and removed the annotation where there were >5 stop codons (as done previously). 

All edits made for each annotations are can be found in the file `annotation_check_results`/annotations_manual_file`.xlsx. 

## How did I process the files ready for the next OrthoFinder run? 
The freshly re-annotated sequences are used to identify core genes as part of Part Two: core gene analysis as described in `README.md`. To do this, you have to get the annotations out of Geneious Prime and into a format which OrthoFinder recognises. Below is how did this:
1. Go to the annotations tab in Genenious Prime for the freshly re-annotated genome. Format the table - go to columns and sort them by clicking th smallest 'min' to largest 'min' to make sure the locus tags are all in order. Move the columns around to ensure they're in the following order: 1, Locus tag 2, Product Name 3, Product sequence.  
2. The go ‘Export Table’. Save it to desktop. It will be a .csv file. 
3. Open up the .csv file on your desktop and delete the first row of column titles. Delete any columns that shouldn’t be there. Have the three columns in the right order as per step 1. Highlight the sequence column and go Find and Replace and replace all ‘…’ with nothing. For sequences without any locus tags, create one that makes sense and be consistent with the naming convention between genomes. Pull the names of the genes brought over from reference genomes into the locus tag colum and chuck the ending _refgen on them. Click save. Close the .csv file.
4. Change the file type to .txt file.
5. Open up the .txt file and Ctrl F ‘*’ which indicates a stop codon.  
6. Follow the rules with regard to which genes you remove and those which you delete the stop codons from (as per above in the lab book). Record changes. This file is the file which you will transform to be input into Orthofinder.
7. Run `script_reformat_proteome` to get the .txt file into a format which OrthoFinder recognises.

## References
Yoxsimer, A. M., Offenberg, E. G., Katzer, A. W., Bell, M. A., Massengill, R. L., & Kingsley, D. M. (2024). Genomic Sequence of the Threespine Stickleback Iridovirus (TSIV) from Wild Gasterosteus aculeatus in Stormy Lake, Alaska. Viruses, 16(11), 1663.
