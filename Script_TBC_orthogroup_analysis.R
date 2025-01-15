#!/usr/bin/env Rscript

# Load libraries
library(tidyverse)
library(optparse)

option_list <- list(
  make_option(c("-o", "--orthogroups"), type = "character", 
              help = "Path to Orthogroups file (TSV format) [required]"),
  make_option(c("-t", "--taxonomy"), type = "character", 
              help = "Path to Taxonomy file (CSV format) [required]"),
  make_option(c("-l", "--level"), type = "character", 
              help = "Taxonomic level to analyze: Genus, Species, or Genotype [required]")
)

# Parse arguments
opt_parser <- OptionParser(option_list = option_list, 
                           description = "A script to analyze orthogroups completeness by occupancy thresholds and taxonomic level.\n\n    E.g. usage:\n\n    Rscript orthogroup_analysis.R -o Orthogroups.tsv -t taxonomy.csv -l Genus")
args <- parse_args(opt_parser)

# Input validation
if (is.null(args$orthogroups) || is.null(args$taxonomy) || is.null(args$level)) {
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

level = args$level

# Verify that the specified level exists in taxonomy
if (!(level %in% colnames(taxonomy))) {
  stop(paste("Error: The specified level", level, "is not in the taxonomy file. Check column names."))
}

# Calculate occupancy
orthogroups <- orthogroups %>%
  rowwise() %>%
  mutate(occupancy = sum(!is.na(c_across(-Orthogroup)) & c_across(-Orthogroup) != "") / (ncol(.) - 1) * 100)

# Prepare a set of all unique values for the specified level
all_values <- unique(taxonomy[[level]])

# Add completeness columns
orthogroups <- orthogroups %>%
  rowwise() %>%
  mutate(
    # Step 1.1: Get column names of non-NA rows
    non_na_columns = list(names(.)[which(!is.na(c_across(-c(Orthogroup, occupancy))))]),
    
    # Step 1.2: Convert column names to level names
    represented_values = list(unique(taxonomy[[level]][taxonomy$Accession %in% unlist(non_na_columns)])),
    
    # Step 1.3: Check completeness
    complete_level = setequal(represented_values, all_values),
    
    # Step 1.4: Count the number of represented values
    num_values_present = length(represented_values),
    
    # Step 1.5: List missing values
    missing_values = list(setdiff(all_values, represented_values))
  ) %>%
  ungroup() %>%
  select(-non_na_columns, -represented_values)

# Write the output table
output_table_file <- paste0("orthogroups_with_", level, "_completeness.tsv")


# Flatten the 'missing_values' list-column into a comma-separated string
orthogroups_export <- orthogroups %>%
  mutate(missing_values = sapply(missing_values, function(x) paste(x, collapse = ", ")))

# Write to file
write_tsv(orthogroups_export, output_table_file)

cat("Output table written to:", output_table_file, "\n")

# Prepare faceted histogram data
thresholds <- seq(0, 100, by = 5)
max_values <- max(orthogroups$num_values_present)

faceted_histogram_data <- map_dfr(1:max_values, function(value_threshold) {
  tibble(threshold = thresholds) %>%
    rowwise() %>%
    mutate(
      rows_retained = sum(orthogroups$occupancy >= threshold & orthogroups$num_values_present >= value_threshold),
      value_threshold_label = paste(level, "retained is at least", value_threshold),
      value_threshold = value_threshold # Store numeric threshold for ordering
    )
}) %>%
  mutate(value_threshold_label = factor(value_threshold_label, 
                                        levels = paste(level, "retained is at least", 1:max_values)))

# Plot the faceted histogram
output_plot_file <- paste0("faceted_histogram_by_", level, ".pdf")

pdf(NULL)


# Create the faceted histogram plot
ggplot(faceted_histogram_data, aes(x = threshold, y = rows_retained)) +
  geom_col() +
  facet_wrap(~ value_threshold_label, ncol = 3) +
  labs(
    title = paste("Number of Orthogroups Retained at Each Occupancy Threshold by", level, "Threshold"),
    x = "Occupancy Threshold (%)",
    y = "Number of Orthogroups Retained"
  ) +
  theme_minimal()

dev.off()


# Save the plot
ggsave(output_plot_file, width = 12, height = 8)
cat("Faceted histogram saved to:", output_plot_file, "\n")

