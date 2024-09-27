# The modules to load:
module load iqtree/2.2.0.5
module load parallel

# Make a directory for the iqtree outputs
mkdir -p iqtree

# Establish files directory for input into parallel n
files=$(ls ./3_mafft_alignments_clean/*.fasta)

# Establish input and output directories
input_dir="./3_mafft_alignments_clean"
output_dir="iqtree"

# Run iqtree
#This script takes Multiple Sequence Alignment (MSA) .fa files as input and reconstructs a maximum-likelihood (ML) tree for each orthogroup. It will use ModelFinder to select the best-fit model to reconstruct the ML tree, and access branch supports using UFBoot (or 'UltraFast bootstrap').
# -s option is used to specify the input alignment file or a directory of files.
# -B to specify the number of replicates for the bootstraping
# -T is to determine the number of CPU cores to speed up the analysis.
# -m MFP option specifies to IQTREE to do an extended model selection followed by tree inference.
# -pre option specifies the output directory / prefix of the output file names. 

#Create function
run_iqtree() {
    local file=$1
    local basefile=$(basename "$file")
    iqtree2 -s "$file" -B 1000 -m MFP -T 1 -pre "$output_dir/$basefile"
}

#Export function and input and output directories to be used by parallel. 
export -f run_iqtree
export input_dir
export output_dir

# Run IQTREE2 on each file in parallel
parallel -j ${SLURM_NTASKS_PER_NODE} run_iqtree ::: "${files[@]}"