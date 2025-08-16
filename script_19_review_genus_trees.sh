#!/bin/bash

# Directory containing your Newick gene trees
dir="iqtree_genus_trees"

# Loop over each file in the directory
for file in "$dir"/*; do
    if grep -q 'TSIV' "$file" || grep -q 'SDDV' "$file" || grep -q 'ECIV' "$file"; then
        echo "$(basename "$file") FALSE"
    else
        echo "$(basename "$file") TRUE"
    fi
done
