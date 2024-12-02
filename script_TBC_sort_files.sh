#!/bin/bash

# Navigate to the target directory
cd /scratch3/han394/mcv/iqtree

# Loop through each file in the directory
for file in *; do
  # Extract the base name (filename without extensions)
  base_name=$(echo "$file" | cut -d'.' -f1)

  # Create a directory for the base name if it doesn't exist
  mkdir -p "$base_name"

  # Move the file into the corresponding directory
  mv "$file" "$base_name/"
done