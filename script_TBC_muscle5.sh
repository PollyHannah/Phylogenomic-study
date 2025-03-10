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
#SBATCH --job-name="2025-03-07_muscle5"

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
#SBATCH --time=03-00:00:00

#load module
module load muscle

# Define input and output directories
declare -A DIRS=(
    ["alignments_family"]="alignments_family_corrected_muscle5"
    ["alignments_genus"]="alignments_genus_corrected_muscle5"
    ["alignments_species"]="alignments_species_corrected_muscle5"
)

# Create output directories if they don't exist
for INPUT_DIR in "${!DIRS[@]}"; do
    OUTPUT_DIR="${DIRS[$INPUT_DIR]}"
    mkdir -p "$OUTPUT_DIR"  # Ensure the output directory exists

    # Loop through all fasta files in the input directory
    for FILE in "$INPUT_DIR"/*.fa; do
        if [[ -f "$FILE" ]]; then
            BASENAME=$(basename "$FILE")  # Get filename without path
            OUTPUT_FILE="$OUTPUT_DIR/$BASENAME"

            echo "Processing $FILE -> $OUTPUT_FILE"
            muscle5 -align "$FILE" -output "$OUTPUT_FILE"
        fi
    done
done

echo "MUSCLE5 batch alignment completed!"
