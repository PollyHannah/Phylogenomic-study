#!/bin/bash

# Directory containing your Newick gene trees
dir="iqtree_family_trees"

# Loop through each file in the directory
for file in "$dir"/*; do
    if grep -q -e 'Ranavirus' \
              -e 'Daphniairidovirus' \
              -e 'Decapodiridovirus' \
              -e 'Lymphocystivirus' \
              -e 'Iridovirus' \
              -e 'Chloriridovirus' "$file"; then
        echo "$(basename "$file") FALSE"
    else
        echo "$(basename "$file") TRUE"
    fi
done