#Start at User directory Users/polly

#Make a Directory called Proteome into which you can save all annotated proteomes. The '-p' option stands for "parent" and it allows you to create a directory hierarchy (a tree of directories) in one step. 

mkdir -p /Users/Polly/Desktop/MCV_pipeline/Prokka_outputs/Proteome

#Copy all proteome file outputs (which end in .faa) from Prokka program for each genome, found in each of the Prokka output folders for each genome, into the newly created directory 'Proteome'.
cp /Users/Polly/Desktop/MCV_pipeline/Prokka_outputs/*/*.faa /Users/Polly/Desktop/MCV_pipeline/Prokka_outputs/Proteome 
