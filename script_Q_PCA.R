library(sem)
library(ggfortify)
library(devtools)
library(ggbiplot)
library(ggrepel)
library(tidyverse)
library(factoextra)

# Detect script location
get_script_dir <- function() {
  cmdArgs <- commandArgs(trailingOnly = FALSE)
  file_arg <- "--file="
  script_path <- sub(file_arg, "", cmdArgs[grep(file_arg, cmdArgs)])
  if (length(script_path) > 0) {
    return(dirname(normalizePath(script_path)))
  } else {
    return(dirname(normalizePath(rstudioapi::getSourceEditorContext()$path)))
  }
}

script_dir <- get_script_dir()
qmatrix_dir <- file.path(script_dir, "iqtree_qmatrices")

readQ <- function(filename) {
  Q = readMoments(filename, diag = FALSE)
  pi = Q[nrow(Q), 1:(ncol(Q) - 1)]
  Q = Q[1:(nrow(Q) - 1), 1:(ncol(Q) - 1)]
  Q = (Q + t(Q))
  diag(Q) <- 0
  Q = (Q / sum(Q)) * 100.0
  R <- Q * F^-1
  return(rbind(Q, pi))
}

nuclear = c("WAG", "Dayhoff", "JTT", "LG", "VT", "PMB", "Blosum62", "Q.pfam")
mitochondrial = c("mtREV", "mtMAM", "mtART", "mtZOA", "mtMet", "mtVer", "mtInv")
chloroplast = c("cpREV")
viral = c("HIVb", "HIVw", "FLU", "rtREV")
taxon_specific = c("Q.plant", "Q.bird", "Q.mammal", "Q.insect", "Q.yeast", "Q.dros")
new = c("Q.mcv", "Q.iridoviridae")

filenames = c(nuclear, mitochondrial, chloroplast, viral, taxon_specific, new)
regions = c(
  rep("nuclear", length(nuclear)),
  rep("mitochondrial", length(mitochondrial)),
  rep("chloroplast", length(chloroplast)),
  rep("viral", length(viral)),
  rep("taxon-specific", length(taxon_specific)),
  rep("new", length(new))
)

allQ = NULL
allF = NULL

for (f in filenames) {
  file_path <- file.path(qmatrix_dir, f)
  Q_pi <- readQ(file_path)
  Q <- Q_pi[1:(nrow(Q_pi) - 1), ]
  pi <- Q_pi[nrow(Q_pi), ]
  allQ <- rbind(allQ, Q[lower.tri(Q)])
  allF <- rbind(allF, pi)
}

rownames(allQ) <- filenames
rownames(allF) <- filenames

# PCA of exchangeabilities
pcaQ <- prcomp(allQ, scale = TRUE)
pca_summary <- summary(pcaQ)
pc1_label <- sprintf("PC1 (%.2f%% Variance Explained)", pca_summary$importance[2, 1] * 100)
pc2_label <- sprintf("PC2 (%.2f%% Variance Explained)", pca_summary$importance[2, 2] * 100)

highlight <- filenames %in% new

plotQ <- ggplot(pcaQ$x, aes(x = PC1, y = PC2)) + 
  geom_point(aes(colour = regions), size = 3, stroke = 1, shape = 21, fill = "white") +
  geom_point(data = subset(pcaQ$x, highlight), aes(x = PC1, y = PC2), 
             shape = 21, fill = "red", colour = "black", size = 4, stroke = 1.5) +
  geom_text_repel(aes(label = rownames(pcaQ$x), colour = regions), size = 2) +
  xlab(pc1_label) +
  ylab(pc2_label) +
  ggtitle("PCA of existing and new exchangeability Matrices") +
  labs(colour = "Matrix type") +
  theme_minimal()

ggsave(file.path(qmatrix_dir, "PCA_exchangeabilities.png"), plotQ, width = 8, height = 6, device = "png")

# PCA of frequencies
pcaF <- prcomp(allF, scale = TRUE)
pca_summary <- summary(pcaF)
pc1_label <- sprintf("PC1 (%.2f%% Variance Explained)", pca_summary$importance[2, 1] * 100)
pc2_label <- sprintf("PC2 (%.2f%% Variance Explained)", pca_summary$importance[2, 2] * 100)

plotF <- ggplot(pcaF$x, aes(x = PC1, y = PC2)) + 
  geom_point(aes(colour = regions), size = 3, stroke = 1, shape = 21, fill = "white") +
  geom_point(data = subset(pcaF$x, highlight), aes(x = PC1, y = PC2), 
             shape = 21, fill = "red", colour = "black", size = 4, stroke = 1.5) +
  geom_text_repel(aes(label = rownames(pcaF$x), colour = regions), size = 2) +
  xlab(pc1_label) +
  ylab(pc2_label) +
  ggtitle("PCA of existing and new frequency vectors") +
  labs(colour = "Matrix type") +
  theme_minimal()

ggsave(file.path(qmatrix_dir, "PCA_frequencies.png"), plotF, width = 8, height = 6, device = "png")
