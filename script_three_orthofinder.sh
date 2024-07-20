#!/bin/Bash

#OrthoFinder will look for input fasta files with any of the following filename extensions: .fa, .faa, .fasta, .fas or .pep.

#OrthoFinder already knows how to call modules mafft, muscle, iqtree, raxml, raxml-ng, fasttree etc.

# Trees can be inferred using multiple sequence alignments (MSA) by using the option '-M msa' option. MAFFT is used to generate the MSAs as default.
# OrthoFinder infers orthologs from rooted gene trees. However, tree interence methods create unrooted gene trees/ OrthoFinder requires a rooted species tree to root the gene trees before ortholog inference can begin. The default species tree method is STAG.
# '-p' option houses the temporary 'pickles files' into an allocated directory.
#'-M msa' option asks Orthofinder to make multiple sequence alignments. The default program OrthoFinder uses is MAFFT.
#'-oa' option asks Orthofinder to Stop the program running after MSAs have been generated.
# -z OrthoFinder automatically trims alignments. This option stops the trimming in order to 'sanity check' the alignment before the gene trees are produced based on the alignments.
# -t Specifies the number of processes which are done in parallel for the BLAST/DIAMOND searches and tree inference steps. It is advised that you use as many threads as there are cores available on your computer, which is the default if another value is not specified (as in here).
# -a Specified the number of threads for the BLAST/DIAMOND steps. If the '-a' parameter is not specified (as is not done here) it will default to 16 or one eighth of the '-t' parameter (whichever is smaller), which is reccomended by the Orthofinder developer.
#'-f' option allows the user to indicate which directory of FASTA files Orthfinder should start the analysis from
# '-o' option allows the user to indicate the directory the results files should be saved to.

#Do not re-create a Directory for the Orthofinder results. Orthofinder creates the output folder as part of the script below.

#Run Orthofinder on proteomes
orthofinder -p ./tempdir -M msa -oa -z -t 24 -a 6 -f ./prokka_outputs/proteome -o ./orthofinder

