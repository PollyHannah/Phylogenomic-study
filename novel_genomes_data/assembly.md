# Assembly steps 
I first assessed the quality of the basecalls for the raw Illumina reads using FastQC (version 0.12.1). To run FastQC on the command line you have to specify a list of files to process. You can specify multiple files to process in a single run.

```bash
fastqc somefile.fastq.gz someotherfile.fastq.txt
```

FastQC will create an HTML report for each file, with embedded graphs detailing the quality of various aspects of the data.

## References
Andrews, S. (2010). FastQC:  A Quality Control Tool for High Throughput Sequence Data [Online]. Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/.
Shifu Chen. 2023. Ultrafast one-pass FASTQ data preprocessing, quality control, and deduplication using fastp. iMeta 2: e107. https://doi.org/10.1002/imt2.107
