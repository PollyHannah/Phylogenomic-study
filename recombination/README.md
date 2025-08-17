
# Recombination detection with RDP4

This is where I ran the program RDP4 to detect recombination amoung the species *Megalocytivirus pagrus1*, the only group for which a whole genome alignment was feasible (which is required to run the program RDP4). I followed the [RDP4 Instruction Manual](https://web.cbio.uct.ac.za/~darren/RDP4Manual.pdf) to complete the analysis.
You will need the following software:
* RDP4 (version RDP4.101) (Martin et al. 2015)
* Geneious Prime (version 2020.2.5)
* Mauve (version 20150226)

## Step 1: Generate whole genome alignment
I generated a whole genome alignment for all *M. pagrus1* genomes part of my analysis, using the program Mauve with default parameters. The alignment can be found  in this repository called `mauve_whole_genome_alignment.xmfa`.

### Transform alignment from .xfma to .fas
Oddly the .xfma file did not show the whole alignment when uploaded in Geneious Prime. I needed to see the whole alignment so I uploaded it to RDP4. It uploaded the whole alignment so I could look at it. 

Although, I wanted to analyse it in Geneious Prime because It’s much easier to see similarities / differences in sequences in Geneious. I exported the alignment in RDP by going: Save > Save entire alignment. This exported the alignment in .fas format. I saved this file and dragged and dropped it into Geneious Prime which worked. The file is saved in this repository as `alignment_mpagrus1.fas`. 

## Step 2: Run RDP4
I opened RDP and followed the instructions for ‘Step-by-Step-guide to using RDP’ (page 38) for the RDP4 instruction manual [here](http://web.cbio.uct.ac.za/~darren/RDP5Manual.pdf). I used the whole genome alignment generated above as input. 

Program options:
· I specified the sequences as being linear.
· I ran the program with ‘disentangle overlapping events’ not selected.
· At first, I ran the program with this option selected (as recommended in the manual) but it took an extended period of time to finish.
· I ran the program with only RDP, GENCONV, MAXCHI recombination detection methods only (as advised in Manual for larger datasets (>50 sequences)


# Reference:
Martin DP, Murrell B, Golden M, Khoosal A, Muhire B. RDP4: Detection and analysis of recombination patterns in virus genomes. Virus Evol. 2015 May 26;1(1):vev003. doi: 10.1093/ve/vev003. PMID: 27774277; PMCID: PMC5014473.

