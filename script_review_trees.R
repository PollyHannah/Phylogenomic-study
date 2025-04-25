# compute the ratio fo the longest internal branch to the second longest internal branch

library(ape)
library(tibble)


# Set your folder path
folder_path <- "./iqtree_species_trees/"

# List all tree files
tree_files <- list.files(folder_path, pattern = "*", full.names = TRUE)

# Function to compute the ratio for one tree
ratio_longest_to_second <- function(f) {
  tr <- read.tree(f)
  
  # edge indices that end at internal nodes
  int_nodes   <- (Ntip(tr) + 1):(Ntip(tr) + Nnode(tr))
  int_edges   <- which(tr$edge[, 2] %in% int_nodes)
  int_lengths <- tr$edge.length[int_edges]
  
  if (length(int_lengths) < 2) return(NA_real_)   # not enough internals
  
  top_two <- sort(int_lengths, decreasing = TRUE)[1:2]  # longest, 2nd longest
  if (top_two[2] == 0) return(Inf)
  
  top_two[1] / top_two[2]
}

ratios <- setNames(vapply(tree_files, ratio_longest_to_second, numeric(1)),
                   basename(tree_files))

ratios  


tab <- tibble(
  filename      = names(ratios),
  ratio         = as.numeric(ratios),
  ratio_greater_than_10   = ratio > 10          # TRUE / FALSE
)

print(tab)


# plain text for slack!
tab_to_print <- tab
tab_to_print$ratio <- formatC(tab_to_print$ratio, format = "f", digits = 3)

write.table(tab_to_print,
            sep       = "\t",   # tab‑separated; change to " " for spaces
            row.names = FALSE,
            quote     = FALSE)