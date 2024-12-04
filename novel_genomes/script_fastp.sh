#!/bin/bash

# FastQC is a program which you can use assess the quality of basecalls from raw sequence reads for a sample, before attempting to assemble a genome.

# Load module
module load fastp 

# Fastp is a program which trims the ends of raw reads according to quality. 

# '-i' designates the read1 input file name. The input file will be the raw sequencing reads for read 1 (fastq.gz file)
# '-I' designates the read2 input file name. The input file will be the raw sequencing reads for read 2 (fastq.gz file)
# '-o' designtaes the read1 output file name. Choose an output name for read 1.
# '-O' designates the read2 output file name. Choose an output name for read 2
# The option '--detect_adapter_for_pe' ensures the adapter sequences are trimmed. Adapter sequences are made of synthetic DNA which is added to the ends of DNA fragments during library preparation.
# The option '-t' trimms how many bases in tail for read1. I've set this at 1 to remove the terminal base from all reads because this base lacks phasing information. By default Fastp does the same for read2. 
# the option '-e' means if one read's average quality score <avg_qual, then this read/pair is discarded. I've set this at 20.
# The option '-3' will move a sliding window from tail (3') to front and drop the bases in the window if its mean quality is below a certain level of quality.
# The option '-l' means that reads shorter than a specified length will be discarded. I've set this at 100bp.

# Run Fastp
fastp -i  -I -o  -O --detect_adapter_for_pe -t 1 -e 20 -3 -l 100