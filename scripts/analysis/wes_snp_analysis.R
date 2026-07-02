#!/usr/bin/env Rscript
# Reproducible WES SNP summary and visualization workflow
# Author: Syeda Hina Shah

suppressPackageStartupMessages({
  library(VariantAnnotation)
  library(ggplot2)
  library(dplyr)
})

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) stop("Usage: Rscript wes_snp_analysis.R /path/to/filtered_snps.vcf [output_dir]")
vcf_file <- args[[1]]
out_dir <- if (length(args) >= 2) args[[2]] else "results/generated"
fig_dir <- file.path(out_dir, "figures")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

if (!file.exists(vcf_file)) stop("VCF file not found: ", vcf_file)

vcf <- readVcf(vcf_file, genome = "hg38")
rr <- rowRanges(vcf)
fx <- as.data.frame(fixed(vcf))

variant_data <- data.frame(
  CHROM = as.character(seqnames(rr)),
  POS = start(rr),
  ID = names(rr),
  REF = as.character(ref(vcf)),
  ALT = vapply(alt(vcf), function(x) paste(as.character(x), collapse = ","), character(1)),
  QUAL = as.numeric(fx$QUAL),
  FILTER = as.character(fx$FILTER),
  stringsAsFactors = FALSE
)

pass_variants <- variant_data %>% filter(FILTER == "PASS")

summary_table <- data.frame(
  metric = c(
    "total_variants", "pass_variants", "filtered_variants", "pass_rate_percent",
    "mean_qual", "median_qual", "maximum_qual"
  ),
  value = c(
    nrow(variant_data),
    nrow(pass_variants),
    sum(variant_data$FILTER != "PASS"),
    round(100 * nrow(pass_variants) / nrow(variant_data), 2),
    round(mean(variant_data$QUAL, na.rm = TRUE), 2),
    round(median(variant_data$QUAL, na.rm = TRUE), 2),
    round(max(variant_data$QUAL, na.rm = TRUE), 2)
  )
)
write.csv(summary_table, file.path(out_dir, "summary_table.csv"), row.names = FALSE)
write.csv(pass_variants, file.path(out_dir, "pass_variants.csv"), row.names = FALSE)

region_counts <- variant_data %>% count(CHROM, name = "variant_count") %>% arrange(desc(variant_count))
write.csv(region_counts, file.path(out_dir, "variant_counts_by_region.csv"), row.names = FALSE)

single_alt <- !grepl(",", variant_data$ALT)
snv <- variant_data %>% filter(nchar(REF) == 1, nchar(ALT) == 1, single_alt)
transition_pairs <- c("A>G", "G>A", "C>T", "T>C")
snv <- snv %>% mutate(
  substitution = paste0(REF, ">", ALT),
  substitution_class = ifelse(substitution %in% transition_pairs, "Transition", "Transversion")
)
write.csv(snv %>% count(substitution, name = "count"),
          file.path(out_dir, "substitution_counts.csv"), row.names = FALSE)
write.csv(snv %>% count(substitution_class, name = "count"),
          file.path(out_dir, "substitution_class_counts.csv"), row.names = FALSE)

p_qual <- ggplot(variant_data, aes(x = QUAL)) +
  geom_histogram(bins = 50, boundary = 0) +
  theme_minimal(base_size = 12) +
  labs(title = "Distribution of Variant Quality Scores", x = "QUAL", y = "Variant count")
ggsave(file.path(fig_dir, "qual_distribution.png"), p_qual, width = 8, height = 5, dpi = 300)

p_pass <- ggplot(pass_variants, aes(x = QUAL)) +
  geom_histogram(bins = 50, boundary = 0) +
  theme_minimal(base_size = 12) +
  labs(title = "Quality Distribution of PASS Variants", x = "QUAL", y = "PASS variant count")
ggsave(file.path(fig_dir, "pass_qual_distribution.png"), p_pass, width = 8, height = 5, dpi = 300)

p_regions <- region_counts %>%
  slice_head(n = 20) %>%
  ggplot(aes(x = reorder(CHROM, variant_count), y = variant_count)) +
  geom_col() +
  coord_flip() +
  theme_minimal(base_size = 11) +
  labs(title = "Top 20 Regions by Variant Count", x = "Region", y = "Variant count")
ggsave(file.path(fig_dir, "top_regions_variant_counts.png"), p_regions, width = 8, height = 7, dpi = 300)

p_titv <- snv %>%
  count(substitution_class, name = "count") %>%
  ggplot(aes(x = substitution_class, y = count)) +
  geom_col() +
  theme_minimal(base_size = 12) +
  labs(title = "Transition and Transversion Counts", x = NULL, y = "SNP count")
ggsave(file.path(fig_dir, "transition_transversion.png"), p_titv, width = 6, height = 5, dpi = 300)

message("Analysis complete. Outputs written to: ", normalizePath(out_dir))
