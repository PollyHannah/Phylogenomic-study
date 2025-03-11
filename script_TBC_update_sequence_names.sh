# Load required libraries
library(Biostrings)
library(stringr)
library(readr)

# Define input directories and corresponding output directories
dirs <- c("alignments_family", 
          "alignments_genus", 
          "alignments_species")

output_dirs <- c("alignments_family_sequence_updated_2", 
                 "alignments_genus_sequence_updated_2", 
                 "alignments_species_sequence_updated_2")

# Load the taxonomy CSV file (make sure it's in the correct path)
taxonomy_file <- "taxonomy.csv"  # Path to the taxonomy file
taxonomy <- read_csv(taxonomy_file)

# Create a lookup table for accessions
accession_lookup <- setNames(paste(gsub(" ", "_", taxonomy$Species), 
                                   gsub(" ", "_", taxonomy$Genotype), sep = "_"), 
                             taxonomy$Accession)

# Define manual replacements for specific sequence prefixes
manual_replacements <- list(
  "PQ335173_PQ335174" = "PQ335173_PQ335174_Threespine_stickleback_iridovirus_TSIV",
  "NC_005946" = "NC_005946_Ranavirus_rana1_n/a",
  "NC_003494" = "NC_003494_Megalocytivirus_pagrus1_ISKNV"
)

# Function to update sequence names
update_sequence_names <- function(file_path, output_file_path, accession_lookup, manual_replacements) {
  # Read the fasta file
  seqs <- readAAStringSet(file_path)
  
  # Update sequence names
  new_names <- sapply(names(seqs), function(name) {
    for (prefix in names(manual_replacements)) {
      if (startsWith(name, prefix)) {
        return(manual_replacements[[prefix]])  # Replace with the predefined name
      }
    }
    
    # Standard case: Remove locus tag at the end
    parts <- str_split(name, "_")[[1]]
    accession1 <- parts[1]
    
    if (accession1 %in% names(accession_lookup)) {
      species_genotype <- accession_lookup[accession1]
      return(paste(accession1, species_genotype, sep = "_"))
    } else {
      return(paste(parts[-length(parts)], collapse = "_"))  # Remove last part (locus tag)
    }
  })
  
  # Set new names to the sequences
  names(seqs) <- new_names
  
  # Write updated sequences to the output file
  writeXStringSet(seqs, output_file_path)
}

# Function to process all .fa files in the given directories and save them in corresponding output directories
process_files_in_dirs <- function(dirs, output_dirs, accession_lookup, manual_replacements) {
  for (i in seq_along(dirs)) {
    input_dir <- dirs[i]
    output_dir <- output_dirs[i]
    
    # Create the output directory if it doesn't exist
    if (!dir.exists(output_dir)) {
      dir.create(output_dir, recursive = TRUE)
    }
    
    # Get all .fa files in the input directory
    fa_files <- list.files(input_dir, pattern = "\\.fa$", full.names = TRUE)
    
    # Loop over each file and update sequence names, saving to output directory
    for (file in fa_files) {
      output_file <- file.path(output_dir, basename(file))
      cat("Processing file:", file, "->", output_file, "\n")
      update_sequence_names(file, output_file, accession_lookup, manual_replacements)
    }
  }
}

# Process the files
process_files_in_dirs(dirs, output_dirs, accession_lookup, manual_replacements)

cat("Processing complete! Updated files saved in respective output directories.\n")