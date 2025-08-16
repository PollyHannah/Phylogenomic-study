#!/usr/bin/env Rscript

# Load libraries
library(tidyverse)
library(optparse)

option_list <- list(
  make_option(c("-o", "--orthogroups"), type = "character", 
              help = "Path to Orthogroups file (TSV format) [required]"),
  make_option(c("-t", "--taxonomy"), type = "character", 
              help = "Path to Taxonomy file (CSV format) [required]")
)

# Parse arguments
opt_parser <- OptionParser(option_list = option_list, 
                           description = "A script to analyze orthogroups completeness by occupancy, from Orthofinder output.\n\n    E.g. usage:\n\n    Rscript orthogroup_analysis.R -o Orthogroups.tsv -t taxonomy.csv")
args <- parse_args(opt_parser)

# Input validation
if (is.null(args$orthogroups) || is.null(args$taxonomy)) {
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


# Calculate occupancy
orthogroups <- orthogroups %>%
  rowwise() %>%
  mutate(occupancy = sum(!is.na(c_across(-Orthogroup)) & c_across(-Orthogroup) != "") / (ncol(.) - 1) * 100)

# Write the output table
output_table_file <- paste0("orthogroups_occpancy.tsv")

# Write to file
write_tsv(orthogroups, output_table_file)

cat("Output table written to:", output_table_file, "\n")

# Prepare faceted histogram data
thresholds <- seq(0, 100, by = 5)

faceted_histogram_data <-
  tibble(threshold = thresholds) %>%
    rowwise() %>%
    mutate(
      rows_retained = sum(orthogroups$occupancy >= threshold),
    )

# Plot the faceted histogram
output_plot_file <- paste0("orthogroups_occpancy_histogram.pdf")

pdf(NULL)


# Create the faceted histogram plot
ggplot(faceted_histogram_data, aes(x = threshold, y = rows_retained)) +
  geom_col() +
  labs(
    title = paste("Number of Orthogroups Retained at Each Occupancy Threshold"),
    x = "Occupancy Threshold (%)",
    y = "Number of Orthogroups Retained"
  ) +
  theme_minimal()

dev.off()


# Save the plot
ggsave(output_plot_file, width = 12, height = 8)
cat("Faceted histogram saved to:", output_plot_file, "\n")
