# Load required libraries
library(Biostrings)
library(stringr)
library(readr)

# Define input directories and corresponding output directories
dirs <- c("alignments_family_corrected_taper", 
          "alignments_genus_corrected_taper", 
          "alignments_species_corrected_taper")

output_dirs <- c("alignments_family_taper_sequence_updated", 
                 "alignments_genus_taper_sequence_updated", 
                 "alignments_species_taper_sequence_updated")

# Load the taxonomy CSV file (make sure it's in the correct path)
taxonomy_file <- "taxonomy.csv"  # Path to the taxonomy file
taxonomy <- read_csv(taxonomy_file)

# Create a lookup table for accessions
accession_lookup <- setNames(paste(gsub(" ", "_", taxonomy$Species), 
                                   gsub(" ", "_", taxonomy$Genotype), sep = "_"), 
                             taxonomy$Accession)

# Function to update sequence names based on taxonomy
update_sequence_names <- function(file_path, output_file_path, accession_lookup) {
  # Read the fasta file
  seqs <- readAAStringSet(file_path)
  
  # Update sequence names
  new_names <- sapply(names(seqs), function(name) {
    parts <- str_split(name, "_")[[1]]
    accession1 <- parts[1]  # Extract Accession1
    
    # Check if Accession1 exists in the lookup table
    if (accession1 %in% names(accession_lookup)) {
      # Get Species and Genotype from the lookup table
      species_genotype <- accession_lookup[accession1]
      
      # Replace spaces with underscores
      species_genotype <- gsub(" ", "_", species_genotype)
      
      # Construct the new sequence name while keeping all original parts
      new_name <- paste(accession1, species_genotype, paste(parts[-1], collapse = "_"), sep = "_")
      return(new_name)
    } else {
      # If no match found, return the original name
      return(name)
    }
  })
  
  # Set new names to the sequences
  names(seqs) <- new_names
  
  # Write updated sequences to the output file
  writeXStringSet(seqs, output_file_path)
}

# Function to process all .fa files in the given directories and save them in corresponding output directories
process_files_in_dirs <- function(dirs, output_dirs, accession_lookup) {
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
      update_sequence_names(file, output_file, accession_lookup)
    }
  }
}

# Process the files
process_files_in_dirs(dirs, output_dirs, accession_lookup)

cat("Processing complete! Updated files saved in respective output directories.\n")