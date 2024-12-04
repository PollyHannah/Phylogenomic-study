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
#SBATCH --job-name="2024-09-09_reformat_annotations"

# SMP processes must run as one task on one node
# Do not request multiple nodes unless appropriate and necessary
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

#Lachlan has designated maximum allocations below. Ensure you revise these allocations prior to submitting a job. 

# Maximum number of CPU cores to be used by the job:
#SBATCH --cpus-per-task=5

# Maximum memory to be used by the job:
#SBATCH --mem=1M
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
#SBATCH --time=00-10:00:00


#Make a directory to house re-formatted annotations.

mkdir -p /scratch3/han394/mcv/prokka_outputs/annotations

# Output directory
output_dir="/scratch3/han394/mcv/prokka_outputs/annotations"

# Loop through all .txt files in the current directory
for input_file in *.fasta; do
    # Generate the output filename by replacing .txt with .faa
        output_file="$output_dir/${input_file}"

    # Initialize the output file
    > "$output_file"

    # Read the input file line by line
    while IFS=, read -r locus_tag product sequence; do
        # Trim leading/trailing spaces
        locus_tag=$(echo "$locus_tag" | xargs)
        product=$(echo "$product" | xargs)
        sequence=$(echo "$sequence" | xargs)

        # Append the FASTA formatted string to the output file
        echo ">$locus_tag $product" >> "$output_file"

        # Wrap the sequence to 80 characters per line
        echo "$sequence" | fold -w 80 >> "$output_file"
    done < "$input_file"

    echo "Processed $input_file into $output_file"
done