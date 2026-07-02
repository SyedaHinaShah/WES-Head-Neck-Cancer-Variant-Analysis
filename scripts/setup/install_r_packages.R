#!/usr/bin/env Rscript

cran_packages <- c("ggplot2", "dplyr", "pheatmap", "vcfR", "viridis", "tidyr")
bioc_packages <- c("VariantAnnotation", "SNPRelate", "gdsfmt", "biomaRt", "GenomicRanges")

missing_cran <- cran_packages[!vapply(cran_packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_cran)) install.packages(missing_cran, repos = "https://cloud.r-project.org")

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = "https://cloud.r-project.org")
}
missing_bioc <- bioc_packages[!vapply(bioc_packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_bioc)) BiocManager::install(missing_bioc, ask = FALSE, update = FALSE)

message("R package setup complete.")
