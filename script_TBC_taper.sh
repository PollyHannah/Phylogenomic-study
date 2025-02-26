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
#SBATCH --job-name="YYYY-MM-DD_<job_name>"

# Only if you need internet access, will run from data mover node if you use.  
# Allow pre-approved internet access
#SBATCH --partition io

# SMP processes must run as one task on one node
# Do not request multiple nodes unless appropriate and necessary
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1

#Lachlan has designated maximum allocations below. Ensure you revise these allocations prior to submitting a job. 
# Maximum number of CPU cores to be used by the job:
#SBATCH --cpus-per-task=64
# Maximum memory to be used by the job:
#SBATCH --mem-per-cpu=512G
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
#SBATCH --time=00-01:30:00


# job command 


./julia-1.11.3/bin/julia correction_multi.jl -l files2run_family.txt files2run_genus.txt files2run_species.txt