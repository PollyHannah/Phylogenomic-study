#OrthoFinder will look for input fasta files with any of the following filename extensions: .fa, .faa, .fasta, .fas or .pep.

#OrthoFinder already knows how to call modules mafft, muscle, iqtree, raxml, raxml-ng, fasttree

#Trees can be inferred using multiple sequence alignments (MSA) by using the option '-M msa' option. MAFFT is used to generate the MSAs as default and FastTree is used to generate the gene trees.
#OrthoFinder infers orthologs from rooted gene trees. However, tree interence methods create unrooted gene trees/ OrthoFinder requires a rooted species tree to root the gene trees before ortholog inference can begin. The default species tree method is STAG.
# '-p' option houses the temporary 'pickles files' into an allocated directory.
#'M msa' option asks Orthofinder to make multiple sequence alignments. The default program OrthoFinder uses is MAFFT.
# '-T option allows the user to choose the tree inference program used to make gene trees'
#'-ot' option asks Orthofinder to Stop the program running after gene trees have been inferred.
#'-f' option allows the user to indicate which directory of FASTA files Orthfinder should start the analysis from
# '-o' option allows the user to indicate the directory the results files should be saved to.

#Do not re-create a Directory for the Orthofinder results. Orthofinder creates the output folder as part of the script below.
#Below is for running on Mac desktop
orthofinder -p /users/polly/desktop/mcv_pipeline/tempdir -M msa -T iqtree -ot -f /users/polly/desktop/mcv_pipeline/prokka_outputs/proteome -o /users/polly/desktop/mcv_pipeline/orthofinder


#If running on Rob's server using 14 CPUs change to: orthofinder -t 14 -a 14 -p /data/polly/megalocytivirus-project/tempdir -M msa -T iqtree -ot -f /data/polly/megalocytivirus-project/Proteome -o /data/polly/megalocytivirus-project/Orthofinder
# '-t' option is number of threads for sequence search, MSA & tree inference [Default is number of cores on machine]
# '-a' option is number of parallel analysis threads for internal, RAM intensive tasks [Default = 1]
