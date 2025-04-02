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
#SBATCH --job-name="2024-04-02_iqtree"

# Only if you need internet access, will run from data mover node if you use.  
# Allow pre-approved internet access
#SBATCH --partition io

# SMP processes must run as one task on one node
# Do not request multiple nodes unless appropriate and necessary
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32

#Lachlan has designated maximum allocations below. Ensure you revise these allocations prior to submitting a job. 
# Maximum number of CPU cores to be used by the job:
#SBATCH --cpus-per-task=1
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

# Load required modules
module load iqtree/2.2.0.5
module load parallel

# Define input directories and corresponding output directories
declare -A directories=(
    ["alignments_family_muscle5_edited_trimmed"]="iqtree_family"
    ["alignments_genus_muscle5_edited_trimmed"]="iqtree_genus"
    ["alignments_species_muscle5_edited_trimmed"]="iqtree_species"
)

# Ensure the custom models are available
custom_models=("Q.iridoviridae" "Q.mcv")   

# Define model set including new models
models=("Blosum62" "cpREV" "Dayhoff" "DCMut" "FLAVI" "FLU" "HIVb" "HIVw" "JTT" "JTTDCMut" "LG" "mtART" "mtMAM" "mtREV" "mtZOA" "mtMet" "mtVer" "mtInv" "PMB" "Q.bird" "Q.insect" "Q.mammal" "Q.pfam" "Q.plant" "Q.yeast" "rtREV" "VT" "WAG" "Q.iridoviridae" "Q.mcv")

# Join array into comma-separated string
mset=$(IFS=, ; echo "${models[*]}")

# Function to run IQ-TREE2
run_iqtree() {
    local file=$1
    local output_dir=$2
    local basefile=$(basename "$file")
    echo "Processing: $basefile"
    iqtree2 -s "$file" -B 1000 -mset $mset -T 1 -pre "$output_dir/$basefile"
}

export -f run_iqtree
export mset

# Loop through each directory pair and process files in parallel
for input_dir in "${!directories[@]}"; do
    output_dir="${directories[$input_dir]}"
    mkdir -p "$output_dir"  # Create output directory if it doesn't exist
    
    files=("$input_dir"/*.fa)
    if [[ -f "${files[0]}" ]]; then  # Check if directory contains .fa files
        parallel -j $(nproc) run_iqtree {} "$output_dir" ::: "${files[@]}"
    else
        echo "Warning: No .fa files found in $input_dir"
    fi
done