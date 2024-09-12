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
#SBATCH --job-name="2024-09-09_prank_test"

# SMP processes must run as one task on one node
# Do not request multiple nodes unless appropriate and necessary
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2

#Lachlan has designated maximum allocations below. Ensure you revise these allocations prior to submitting a job. 

# Maximum number of CPU cores to be used by the job:
#SBATCH --cpus-per-task=10

# Maximum memory to be used by the job:
#SBATCH --mem=10G
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

# load mudule
module load prank 

# PRANK can translate nucleiotide sequences to protein-coding DNA sequences, and also align protein-coding DNA sequences using a codon model.

# Parallel runs prank on each file in parallel. The output will be saved in the specified output_dir with a _prank suffix.

# A list of possible program options is shown with command: prank -help

# input_file is the name of the file with input sequences in FASTA format.

# output_file is the name of the file (with extension .best.fas) where the resulting alignment will be written in FASTA format

# '-F' specifies that the inference of insertions should be trusted and sites appearing as insertions should not be aligned at the later stages of the process.

# '-translate' (standard code) translates protein-coding DNA nucleiotide sequences.

# '-codon' uses a codon model to align amino acid sequences

# Directories
input_dir="./3_orthofinder"
output_dir="./1_prank_alignments"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop through each .fasta file in the input directory
for input_file in "$input_dir"/*.fasta; do
  # Get the base filename without the directory path
  base_filename=$(basename "$input_file" .fasta)
  
  # Define the output filename with _prank appended
  output_file="$output_dir/${base_filename}_prank.fasta"
  
  # Run prank and save the output
  prank -d=$input_file -o=$output_file
  
  echo "Processed $input_file -> $output_file"
done
