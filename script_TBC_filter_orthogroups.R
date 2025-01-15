#!/usr/bin/env Rscript

# Load libraries
library(tidyverse)
library(optparse)

# Define command-line options
option_list <- list(
  make_option(c("-o", "--orthogroups"), type = "character", 
              help = "Path to Orthogroups file (TSV format) [required]"),
  make_option(c("-t", "--taxonomy"), type = "character", 
              help = "Path to Taxonomy file (CSV format) [required]"),
  make_option(c("-l", "--level"), type = "character", 
              help = "Taxonomic level to analyze: Genus, Species, or Genotype [required]"),
  make_option(c("-a", "--occupancy"), type = "double", 
              help = "Minimum occupancy threshold (percentage) [required]"),
  make_option(c("-r", "--retained"), type = "integer", 
              help = "Minimum number of retained genera/species/genotypes [required]")
)

# Parse arguments
opt_parser <- OptionParser(option_list = option_list, 
                           description = "A script to filter orthogroups based on occupancy and taxonomic completeness.\n\nUsage:\n  Rscript filter_orthogroups.R -o Orthogroups.tsv -t taxonomy.csv -l Genus -a 50 -r 5")
args <- parse_args(opt_parser)

# Input validation
if (is.null(args$orthogroups) || is.null(args$taxonomy) || is.null(args$level) || 
    is.null(args$occupancy) || is.null(args$retained)) {
  print_help(opt_parser)
  stop("Error: Missing required arguments. Use -h for help.")
}

# Check if input files exist
if (!file.exists(args$orthogroups)) {
  stop(paste("Error: Orthogroups file not found at", args$orthogroups))
}
if (!file.exists(args$taxonomy)) {
  stop(paste("Error: Taxonomy file not found at", args$taxonomy))
}

# Load data
orthogroups <- read_tsv(args$orthogroups)
taxonomy <- read_csv(args$taxonomy)

# Verify the specified level exists in taxonomy
if (!(args$level %in% colnames(taxonomy))) {
  stop(paste("Error: The specified level", args$level, "is not in the taxonomy file. Check column names."))
}

# Prepare a set of all unique values for the specified level
all_values <- unique(taxonomy[[args$level]])

# Add occupancy, completeness, and number of level-specific values
orthogroups <- orthogroups %>%
  rowwise() %>%
  mutate(
    # Step 1.1: Calculate occupancy
    occupancy = sum(!is.na(c_across(-Orthogroup)) & c_across(-Orthogroup) != "") / (ncol(.) - 1) * 100,
    
    # Step 1.2: Get column names of non-NA rows
    non_na_columns = list(names(.)[which(!is.na(c_across(-c(Orthogroup, occupancy))))]),
    
    # Step 1.3: Convert column names to the specified level names
    represented_values = list(unique(taxonomy[[args$level]][taxonomy$Accession %in% unlist(non_na_columns)])),
    
    # Step 1.4: Count the number of represented values
    num_values_present = length(represented_values)
  ) %>%
  ungroup() %>%
  select(-non_na_columns, -represented_values) # Clean up intermediate columns

# Filter based on occupancy and the number of values present
filtered_orthogroups <- orthogroups %>%
  filter(occupancy >= args$occupancy, num_values_present >= args$retained)

# Write the filtered orthogroups to a new file
output_file <- paste0("filtered_orthogroups_", args$level, "_", args$occupancy, "pct_", args$retained, "retained.tsv")
write_tsv(filtered_orthogroups, output_file)

# Confirm success
cat("Filtered orthogroups written to:", output_file, "\n")
