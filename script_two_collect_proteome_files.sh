#If working from Desktop, start at home directory. For exmaple, users/polly. 

#Make a Directory called proteome into which you can save all annotated proteomes. The '-p' option stands for "parent" and it allows you to create a directory hierarchy (a tree of directories) in one step. 

#The following path can be used if you have cloned my github repository to your home directory.

mkdir -p ~/prokka_outputs/proteome

#Copy all proteome file outputs (which end in .faa) from Prokka program for each genome, found in each of the Prokka output folders for each genome, into the newly created directory 'Proteome'.

#The following path can be used if you have cloned my github repository to your home directory.
cp ~/prokka_outputs/*/*.faa ~/prokka_outputs/proteome 
