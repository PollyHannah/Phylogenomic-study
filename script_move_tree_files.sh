#!/bin/bash

# Define source directories
dirs=("iqtree_family" "iqtree_genus" "iqtree_species")

# Base directory (script execution directory)
BASE_DIR=$(pwd)

# Define destination directories
declare -A tree_dirs=(
  ["iqtree_family"]="iqtree_family_trees"
  ["iqtree_genus"]="iqtree_genus_trees"
  ["iqtree_species"]="iqtree_species_trees"
)

# Create destination directories
for dest in "${tree_dirs[@]}"; do
  mkdir -p "$BASE_DIR/$dest"
done

# Loop through each directory
for dir in "${dirs[@]}"; do
  tree_dest="$BASE_DIR/${tree_dirs[$dir]}"
  
  # Find and copy all .fa.treefile files from OG* subdirectories
  find "$BASE_DIR/$dir" -type d -name "OG*" | while read -r og_dir; do
    treefile=$(find "$og_dir" -maxdepth 1 -type f -name "*.fa.treefile")
    if [ -n "$treefile" ]; then
      cp "$treefile" "$tree_dest/"
    fi
  done
done
