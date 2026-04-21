# !/bin/bash

cd /mnt/ssd/projects/RNAseq-chloe/

raw_dir="rawdata"
fastqc_dir="01-fastqc"


## ===========================
## Step 01 : Quality Control
## ===========================

## 01/ Running fastqc on all rawdata
fastqc -t 16 $raw_dir/*.fastq.gz -o $fastqc_dir/

## 02/ Running multiqc to summarise fastqc files
## 02-1. multiqc on controls (C1-C5)
multiqc $fastqc_dir/ \
  -n multiqc_controls.html \
  -o $fastqc_dir/multiqc_controls \
  -x "*Creno*" \
  -x "*Gilt*" \
  -x "*Mido*" \
  -x "*Quiz*" \
  -x "*Sora*" \
  -p \
  -fp

## 02-2. multiqc on the conditions
multiqc $fastqc_dir/ \
  -n multiqc_conditions.html \
  -o $fastqc_dir/multiqc_conditions \
  -x "*C[1-5]*" \
  -p \
  -fp

## 02-3. multiqc on everything alltogether
multiqc $fastqc_dir/ -n multiqc_all.html -o $fastqc_dir/multiqc_all -p -fp

