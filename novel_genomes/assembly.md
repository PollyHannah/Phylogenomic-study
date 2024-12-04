# Assembly steps 

## Check quality of raw reads
I first assessed the quality of the basecalls for the raw Illumina reads using FastQC (version 0.12.1). To run FastQC on the command line you have to specify a list of files to process. You can specify multiple files to process in a single run. FastQC will create an HTML report for each file, with embedded graphs detailing the quality of various aspects of the data.


```bash
fastqc somefile.fastq.gz someotherfile.fastq.txt
```

## Trim reads
I used Fastp to trim the reads with the following command. 

```bash
fastp -i read_one_input_file -I read_two_input_file -o read_one_output_file -O read_two_output_file --detect_adapter_for_pe -t 1 -e 20 -3 -l 100
```
A script for the above can be found in this directory called 'script_fastp.sh'. Just plug in the file names and run it. 

## References
Andrews, S. (2010). FastQC:  A Quality Control Tool for High Throughput Sequence Data [Online]. Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/.
Shifu Chen. 2023. Ultrafast one-pass FASTQ data preprocessing, quality control, and deduplication using fastp. iMeta 2: e107. https://doi.org/10.1002/imt2.107
