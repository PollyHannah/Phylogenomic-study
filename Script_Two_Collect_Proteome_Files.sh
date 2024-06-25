#Start at User directory Users/polly

#Make a Directory called Proteome into which you can save all annotated proteomes. The '-p' option stands for "parent" and it allows you to create a directory hierarchy (a tree of directories) in one step. 

mkdir -p /users/polly/desktop/mcv_pipeline/prokka_outputs/proteome

#Copy all proteome file outputs (which end in .faa) from Prokka program for each genome, found in each of the Prokka output folders for each genome, into the newly created directory 'Proteome'.
cp /users/polly/desktop/mcv_pipeline/prokka_outputs/*/*.faa /users/polly/desktop/mcv_pipeline/prokka_outputs/proteome 
