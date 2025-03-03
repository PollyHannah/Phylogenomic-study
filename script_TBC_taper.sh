#!/bin/bash

# job commands
./julia-1.11.3/bin/julia correction_multi.jl -l files2run_family.txt 
./julia-1.11.3/bin/julia correction_multi.jl -l files2run_genus.txt 
./julia-1.11.3/bin/julia correction_multi.jl -l files2run_species.txt