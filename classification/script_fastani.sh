# FastANI to compare the sequence similarity between a set of reference and set of query genomes.
# load module 
module load fastANI
# Run FastANI 
fastANI --ql query_list.txt --rl reference_list.txt -o fastani.out