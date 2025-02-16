#!/usr/bin/env Rscript

library(dplyr)

# Step A: Read the *retained.tsv file in the current directory
tsv_file <- list.files(pattern = "*retained.tsv", full.names = TRUE)[1]
df <- read.table(tsv_file, header = TRUE, sep = "\t", check.names = FALSE)

# Extract values from the first column, excluding 'column1' and 'Orthogroup'
column_names <- df[[1]]  # Extract values, not column names
column_names <- column_names[!column_names %in% c("column1", "Orthogroup")]
column_names <- as.character(column_names)  # Convert to character type

# Debugging: Print extracted column names
print("Extracted column names:")
print(column_names)

# Step B: Create a text file with column names and the .fa extension
output_file <- "column_names_with_extension.txt"
column_names_with_extension <- paste0(column_names, ".fa")

# Write the column names to a text file, each on a new line
writeLines(column_names_with_extension, output_file)

cat("Column names with .fa extension have been written to", output_file, "\n")