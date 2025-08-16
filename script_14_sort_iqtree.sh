#!/bin/bash

# Define directories to process
dirs=("iqtree_family" "iqtree_genus" "iqtree_species")

# Base directory (script execution directory)
BASE_DIR=$(pwd)

# Loop through each directory
for dir in "${dirs[@]}"; do
  
  # Navigate to the directory
  cd "$BASE_DIR/$dir" || { echo "Directory $BASE_DIR/$dir not found!"; continue; }
  
  # Create a temporary directory to store sorted files
  temp_dir="$BASE_DIR/${dir}_temp"
  mkdir -p "$temp_dir"
  
  # Loop through each file in the directory
  for file in *; do
    # Skip if no files are found
    [ -e "$file" ] || continue
    
    # Extract the base name (filename without extensions)
    base_name=$(echo "$file" | cut -d'.' -f1)
    
    # Create a directory for the base name in the temporary directory
    mkdir -p "$temp_dir/$base_name"
    
    # Move the file into the corresponding directory in the temporary directory
    mv "$file" "$temp_dir/$base_name/"
  done
  
  # Remove the original directory and replace it with the sorted version
  rm -rf "$BASE_DIR/$dir"
  mv "$temp_dir" "$BASE_DIR/$dir"

done

