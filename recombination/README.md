
# Recombination detection with RDP4
This is where I ran the program RDP4 to detect recombination amoung the species *Megalocytivirus pagrus1*, the only group for which a whole genome alignment was feasible (which is required to run the program RDP4). 

I followed the [RDP4 Instruction Manual](https://web.cbio.uct.ac.za/~darren/RDP4Manual.pdf) to complete the analysis. RDP4 detects recombination using five different methods; RDP, GENECONV, Maxchi, Chimaera, and 3Seq. 
You will need the following software:
* RDP4 (version RDP4.101) (Martin et al. 2015)
* Geneious Prime (version 2020.2.5)
* Mauve (version 20150226)

## Step 1: Generate whole genome alignment
I generated a whole genome alignment for all *M. pagrus1* genomes part of my analysis, using the program Mauve with default parameters. The alignment can be found  in this repository called `mauve_whole_genome_alignment.xmfa`.

### Transform alignment from .xfma to .fas
Oddly the .xfma file did not show the whole alignment when uploaded in Geneious Prime. I needed to see the whole alignment so I uploaded it to RDP4. It uploaded the whole alignment so I could look at it. 

Although, I wanted to analyse it in Geneious Prime because It’s much easier to see similarities / differences in sequences in Geneious. I exported the alignment in RDP by going: Save > Save entire alignment. This exported the alignment in .fas format. I saved this file and dragged and dropped it into Geneious Prime which worked. The file is saved in this repository as `whole_genome_alignment_mpagrus1.fas`. 

## Step 2: Run RDP4
I opened RDP and followed the instructions for ‘Step-by-Step-guide to using RDP’ (page 38) for the RDP4 instruction manual [here](http://web.cbio.uct.ac.za/~darren/RDP5Manual.pdf). I used the whole genome alignment generated above as input. 

Program options:
· I specified the sequences as being linear.
· I ran the program with ‘disentangle overlapping events’ not selected.

## Results 
The RDP program found 136 recombination events, with some events occurring in more than one sequence. The results can be found in this document `recombination_results.rdp`.

#### Refine results
I followed the instructions in the RDP manual Section 10.4 ‘Testing and Refining Preliminary Recombination Hypothesis’ (see manual [here](http://web.cbio.uct.ac.za/~darren/RDP5Manual.pdf.)) to analyse the results and decide which recombination events I would consider true recombination events, and those which I would not. 

I progressively refined the recombination event results but rejecting some events and not others as follows:
* All events not detected by all five methods were rejected.
* Where the trees did not make sense, or the recombination signal in 2/3 of the detection methods was weak (as outlined in the RDP4 instruction manual) I rejected the event.
* I rejected recombination events I could not see in the multiple sequence alignment by-eye. I did this by checking the whole genome alignment file `Whole_genome_alignment_mauve_rdp.fasta` (provided here in this repository).

## Step 3: Annotate recombination events
A file containing the details of the recombination events which I retained can be found here `recombination_results_refined.xlsx`. 


# Reference:
Martin DP, Murrell B, Golden M, Khoosal A, Muhire B. RDP4: Detection and analysis of recombination patterns in virus genomes. Virus Evol. 2015 May 26;1(1):vev003. doi: 10.1093/ve/vev003. PMID: 27774277; PMCID: PMC5014473.

