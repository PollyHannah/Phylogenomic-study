# Assembly steps 
I first assessed the quality of the basecalls for the raw Illumina reads using FastQC. To run FastQC on the command line you have to specify a list of files to process. You can specify multiple files to process in a single run.

```bash
fastqc somefile.fastq.gz someotherfile.fastq.txt
```

FastQC will create an HTML report for each file, with embedded graphs detailing the quality of various aspects of the data.
