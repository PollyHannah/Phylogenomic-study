#!/bin/bash

#Make a Directory called proteome into which you can save all annotated proteomes. The '-p' option stands for "parent" and it allows you to create a directory hierarchy (a tree of directories) in one step. 

mkdir -p ./proteome_1

#Copy all proteome file outputs (which end in .faa) from Prokka for each genome, found in each of the Prokka output folders for each genome, into the newly created directory.

cp ./prokka_outputs_1/*/*.faa ./proteome_1
