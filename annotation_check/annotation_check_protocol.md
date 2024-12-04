# How did I make decisions? 
To decide whether to keep, edit, or delete annotations, I compared the prokka-annotated genome with the reference genome, and made decisions as to whether to keep the prokka-annotations 'as-is', or edit them, based on whether the prokka annotations matched the annotations in the reference genome.
1. I downloaded the General Feature File (.gff) produced by Prokka (version 1. 14. 5) for every genome and pairwise aligned the file in Genenious Prime (version 2020.2.5) with the GenBank (.gb) file from National Centre for Biotechnology Information (NCBI) GenBank Database for the corresponding genome. 
2. Where the Prokka and GenBank annotations matched, I kept the annotation as-is. Where the annotations did not match, I did a A BLASTp search of both annotations on the the NCBI GenBank Database. I favoured annotations with a higher number of matches, % identity to matches, and % query cover.
3. I then checked whether stop codons were present in the annotation. If a 'favoured annotation' (as described above) had ≤3 stop codons I kept the annotation and removed the stop codons. Yet if a 'favoured annotation' had >3 stop codons I kept the less-favoured annotation (if there was one). If the annotation had >3 stop codons and there was no 'favored annotation' (i.e. there was no alternative annotation option in the .gff file or .gb file) I deleted the annotation all together. 
4. I exported a list of the annotations (amino acid sequences) for each genome from Geneious Prime (version 2020.2.5). 
5. I then exported the list as a .csv file and converted it to a .txt file. I used this text file to input into the next Orthofinder run. 

At each stage of the analysis, I removed genomes if I thought there were sequencing or assemby errors in those genomes. 

## Where are your results? 
Most of the files used/generated for each stage of the process above can be found in this repository.
1. The **45** General Feature Files can be found in the prokka_outputs_1 directory. The NCBI GenBank files (.gb) were downloaded directory from NCBI. 
   * One genome (OL310752) was removed at this stage (OL310752).
2. The **44** GenBank (.gb) files before the stop codon check can be found in this repository at annotation_check_results/1_genomes_before_stop_codon_check.
   * Three genomes were removed as part of the stop codon check step (AY532606, AY779031 and NC_027778). 
3. The **41** Genbank (.gb) files post stop codon check can be found in this repository at annotation_check_results/1_genomes_post_stop_codon_check.
4. The **41** Genbank (.gb) files as lists of annotations post stop codon check can be found in this repository at annotation_check_results/3_annotations_post_stop_codon_check.
5. The **41** Genbank (.txt) files as lists of annotations post stop codon check can be found in this repository at annotation_check_results/3_annotations_post_stop_codon_check.
   * Sometimes, I found pesky stop codons after I'd converted the file to a .txt file. I removed the stop codons where there were ≤3 and removed the annotation where there were >3 stop codons (as done previously). 

All edits made for each annotations are can be found in the file annotation_check_results/YYYY_annotations_manual_file.xlsx. 

## Megalocytivirus genomes - which annotations did I manually check?
I completed this process for one genome from each megalocytivirus genotype and species, as well as for every one of the megalocytivirus 'Unclassified' genomes (genomes entered into NCBI GenBank Taxonomy Browser under the genus 'megalocytivirus' as 'Unclassified'). 

For the megalocytivirus genomes for which i did not complete this process, I transferred the manually curated annotations with 85% similarity from the relevant genotype. I did this using the 'Annotate From' option in the'Live Annotate and Predict tab' in Geneious Prime (Version 2020.2.5). I then manually curated the transfered annotations checking for stop codons following the same decision-making process as described above. 

Listed below are the genotypes i transferred annotations from (in **bold**), and beneathe them, the genomes the annotations from that genotype were tranferred to. 

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

## Iridoviridae genomes (other than megalocytivirus) - which annotations did I manually check?
For every iridoviridae genome from genera other than *Megalocytivirus*, I completed the manual curation process as described above, but only for a small set of highly conserved genes. This was done to save time. The genes I chose to manually curate were identified through the OrthoFinder run above. For each of these genomes, I manually curated the genes assigned to orthogroups containing orthologs from 100% of genomes part of the analysis. 

The genes I chose for manual curation for each genome, was based on different OrthoFinder runs. The results for each OrthoFinder run can be found in the directory 'orthofinder_1'. The OrthoFinder run, from which the set of highly conserved genes were chosen for manual curation, is provided for each genome in the file annotation_check_results/YYYY_annotations_manual_file.xlsx in this repository.

## How did you process the files? 
The freshly re-annotated sequences are used to identify core genes as part of Part Two: core gene analysis. To do this, you have to get the annotations out of Geneious Prime and into a format which OrthoFinder recognises. Below is how i achieved this:
1. Go to the annotations tab in Genenious Prime for the freshly re-annotated genome. Format the table - go to columns and sort them by clicking th smallest 'min' to largest 'min' to make sure the locus tags are all in order. Move the columns around to ensure they're in the following order: 1, Locus tag 2, Product Name 3, Product sequence.  

2. The go ‘Export Table’. Save it to desktop. It will be a .csv file. 

3. Open up the .csv file on your desktop and delete the first row of column titles. Delete any columns that shouldn’t be there. Have the three columns in the right order as per step 1. Highlight the sequence column and go Find and Replace and replace all ‘…’ with nothing. For sequences without any locus tags, create one that makes sense and be consistent with the naming convention between genomes. Pull the names of the genes brought over from reference genomes into the locus tag colum and chuck the ending _refgen on them. Click save. Close the .csv file.

4. Change the file type to .txt file.

5. Open up the .txt file and Ctrl F ‘*’ which indicates a stop codon.  

6. Follow the rules with regard to which genes you remove and those which you delete the stop codons from (as per above in the lab book). Record changes. This file is the file which you will transform to be input into Orthofinder.

7. Run the script script_reformat_proteome' to get the .txt file into a format which OrthoFinder recognises. 
