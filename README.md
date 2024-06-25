Create Conda environment and install program to environment 
#Create Conda environment and install programs
conda create --name <name of your environment>

#When conda asks you proceed (y/n)
y

#install program into newly created environment
conda install <name of program> 

#When asks if you want to proceed (y/n) 
y

#Check installation was successful, ask for the version of the program installed
<name of program> --version 

#To export conda environment to a file, first activate your environment if not done already.
conda activate <insert name of environment>

#Export the environment
conda env export > environment.yml

#The 'environment.yml' file will have all the programs and versions required for each of the modules you have added (i.e. Prokka, Orthifinder etc.) in order to recreate the same environment used to run scripts and share it with others.  
#Conda will export the environment file to the directory you are in at the time of export. 
