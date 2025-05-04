#!/bin/bash

# CSIRO Petrichor
# Login with Nexus username and password
# Do not run jobs directly from the login node
# Use an interactive node: sinteractive -A <O2D_code> -t hh:mm:ss -c 1 -m 1G
# cd $SCRATCH3DIR
# Check job status: squeue -u username
# Kill job: scancel <job_ID>
# Check job efficiency: seff <job_ID>
# Check job accounting data: sacct (CPU efficiency=TotalCPU/(AllocCPUS*Elapsed), memory efficiency=MaxRSS/ReqMem)

# CSIRO project code
#SBATCH --account=OD-220983

# The name of the job:
#SBATCH --job-name="2025-05-04_iqtree"

# Only if you need internet access, will run from data mover node if you use.  
# Allow pre-approved internet access
#SBATCH --partition io

# SMP processes must run as one task on one node
# Do not request multiple nodes unless appropriate and necessary
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

#Lachlan has designated maximum allocations below. Ensure you revise these allocations prior to submitting a job. 
# Maximum number of CPU cores to be used by the job:
#SBATCH --cpus-per-task=16
# Maximum memory to be used by the job:
#SBATCH --mem-per-cpu=1G
# Default memory units are megabytes - specify [K|M|G|T]

# Send an email when the job:
# aborts abnormally (fails)
#SBATCH --mail-type=FAIL
# begins
#SBATCH --mail-type=BEGIN
# ends successfully
#SBATCH --mail-type=END

# Use this email address:
#SBATCH --mail-user=polly.hannaford@csiro.au

# The maximum running time of the job in DD-hh:mm:ss
#SBATCH --time=01-0:00:00


# The modules to load:
module load iqtree/2.2.0.5

# Define the model set
models=(
    "Blosum62" "cpREV" "Dayhoff" "DCMut" "FLAVI" "FLU" "HIVb" "HIVw"
    "JTT" "JTTDCMut" "LG" "mtART" "mtMAM" "mtREV" "mtZOA" "mtMet"
    "mtVer" "mtInv" "PMB" "Q.bird" "Q.insect" "Q.mammal" "Q.pfam"
    "Q.plant" "Q.yeast" "rtREV" "VT" "WAG" "Q.iridoviridae" "Q.mcv"
)
mset=$(IFS=, ; echo "${models[*]}")

# Define input -> output directory mapping
declare -A alignments=(
    ["concatenated_alignment_family.fasta"]="iqtree_family_concatenated"
    ["concatenated_alignment_genus.fasta"]="iqtree_genus_concatenated"
    ["concatenated_alignment_species.fasta"]="iqtree_species_concatenated"
)

# Run IQ-TREE2 on each file
for file in "${!alignments[@]}"; do
    outdir="${alignments[$file]}"
    mkdir -p "$outdir"

    prefix="$outdir/$(basename "$file" .fasta)"

    echo "Running IQ-TREE2 on $file -> $prefix"
    iqtree2 -s "$file" -B 1000 -mset "$mset" -T 4 -pre "$prefix"
done
