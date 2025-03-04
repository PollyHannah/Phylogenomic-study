#!/bin/bash

# Load required libraries
library(Biostrings)
library(stringr)
library(readr)

# Define directories
dirs <- c("alignments_family_corrected_taper_trimal", 
          "alignments_genus_corrected_taper_trimal", 
          "alignments_species_corrected_taper_trimal")

# Load the taxonomy CSV file (make sure it's in the correct path)
taxonomy_file <- "taxonomy.csv"  # Path to the taxonomy file
taxonomy <- read_csv(taxonomy_file)

# Create a lookup table for accessions
accession_lookup <- setNames(paste(taxonomy$Species, taxonomy$Genotype, sep = "_"), taxonomy$Accession)

# Function to update sequence names based on taxonomy
update_sequence_names <- function(file_path, accession_lookup) {
  # Read the fasta file
  seqs <- readDNAStringSet(file_path)
  
  # Update sequence names
  new_names <- sapply(names(seqs), function(name) {
    parts <- str_split(name, "_")[[1]]
    accession1 <- parts[1]  # Extract Accession1
    
    # Check if Accession1 exists in the lookup table
    if (accession1 %in% names(accession_lookup)) {
      # Get Species and Genotype from the lookup table
      species_genotype <- accession_lookup[accession1]
      
      # Construct the new sequence name
      new_name <- paste(accession1, species_genotype, parts[2], parts[3], sep = "_")
      return(new_name)
    } else {
      # If no match found, return the original name (can log this if necessary)
      return(name)
    }
  })
  
  # Set new names to the sequences
  names(seqs) <- new_names
  
  # Write updated sequences to file
  writeXStringSet(seqs, file_path)
}

# Function to process all .fa files in the given directories
process_files_in_dirs <- function(dirs, accession_lookup) {
  for (dir in dirs) {
    # Get all .fa files in the directory
    fa_files <- list.files(dir, pattern = "\\.fa$", full.names = TRUE)
    
    # Loop over each file and update sequence names
    for (file in fa_files) {
      cat("Processing file:", file, "\n")
      update_sequence_names(file, accession_lookup)
    }
  }
}

# Process the files
process_files_in_dirs(dirs, accession_lookup)

cat("Processing complete!\n")
