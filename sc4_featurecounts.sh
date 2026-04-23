#!/bin/bash

cd /mnt/ssd/projects/RNAseq-chloe

mkdir -p 05-counts

out_counts="05-counts"
bam_dir="04-mapping/Out_mapping"

## Running featurecount 
## ====================
featureCounts -p -O -s 2 -T 32 \
  -a 04-mapping/genome/gencode.v47.annotation.gtf \
  -o "$out_counts/featurecounts_results.txt" \
  ${bam_dir}/*Aligned.sortedByCoord.out.bam