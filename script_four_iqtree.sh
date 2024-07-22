# Make a directory for the iqtree outputs
mkdir -p iqtree

# The modules to load:
module load iqtree/2.2.0.5

#This script takes Multiple Sequence Alignment (MSA) .fa files as input and reconstructs a maximum-likelihood (ML) tree for each orthogroup. It will use ModelFinder to select the best-fit model to reconstruct the ML tree, and access branch supports using UFBoot (or 'UltraFast bootstrap').

# -s option is used to specify the input alignment file or a directory of files.
# -B to specify the number of replicates for the bootstraping
# -T is to determine the number of CPU cores to speed up the analysis.
# -m MFP option specifies to IQTREE to do an extended model selection followed by tree inference.
# -pre option specifies the output directory. 

iqtree2 -s orthofinder_iqtreetest/Results_Jul15/MultipleSequenceAlignments -m MFP -B 1000 -T AUTO -pre iqtree/