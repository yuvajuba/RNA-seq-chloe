setwd("/mnt/ssd/projects/RNAseq-chloe/05-counts/")


library(stringr)
library(tidyverse)

## upload the featurecounts
data <- read.table("featurecounts_results.txt", header = T, skip = 1, row.names = 1)

## Extract the matrix of count
counts <- data %>% 
  select(ends_with(".bam")) %>% 
  as.matrix()

colnames(counts) <- colnames(counts) %>% 
  str_remove(".Aligned.sortedByCoord.out.bam") %>% 
  str_remove("X04.mapping.Out_mapping.") %>% 
  str_split_i("_S[1-9]", 1)


## Build the metadata
meta <- data.frame(
  row.names = colnames(counts),
  sample = str_extract(colnames(counts), "C[1-5]|Creno|Gilt|Mido|Quiz|Sora"),
  patient = str_extract(colnames(counts), "n[1-5]"),
  stringsAsFactors = TRUE
)

meta$condition <- fct_collapse(meta$sample, ctrl = c("C1","C2","C3","C4","C5"))
meta$condition <- relevel(meta$condition, ref = "ctrl")


## Extract genomic coordinates
genom_coord <- data %>% select(!ends_with(".bam")) 


## ============================================================
## SAVE — reproducing the files from the README
## ============================================================

## 1. FeatureCount_summary.csv — summary bien formaté
summary_fc <- read.table("featurecounts_results.txt.summary",
                         header = T, row.names = 1)
colnames(summary_fc) <- colnames(summary_fc) %>%
  str_remove(".Aligned.sortedByCoord.out.bam") %>%
  str_remove("X04.mapping.Out_mapping.") %>%
  str_split_i("_S[1-9]", 1)
write.csv(summary_fc, "FeatureCount_summary.csv")

## 2. Genomic_coordinates.csv
write.csv(genom_coord, "Genomic_coordinates.csv")

## 3. Raw_counts.csv — table de compte complète
write.csv(counts, "Raw_counts.csv")

## 4. Raw_counts_prefiltered.csv — retirer les gènes à 0 partout
counts_prefiltered <- counts[rowSums(counts) > 5, ]
write.csv(counts_prefiltered, "Raw_counts_prefiltered.csv")

## Vérification rapide
cat("Gènes total         :", nrow(counts), "\n")
cat("Gènes après filtre  :", nrow(counts_prefiltered), "\n")
cat("Échantillons        :", ncol(counts), "\n")