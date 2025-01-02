#!/bin/bash

# This script uses Bowtie2 to index a reference genome and then use that index to map reads to the reference DNA. 

# load module
module load bowtie2

# Build a small index
bowtie2-build ./SKF9.fa ./SKF9

