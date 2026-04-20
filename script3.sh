# !/bin/bash

cd /mnt/ssd/projects/RNAseq-chloe/

trim_dir="02-trimmed"
fastqc_dir="03-fastqc"


## ===========================================
## Step 03 : Quality Control after trimming
## ===========================================

## 01/ Running fastqc on all rawdata
fastqc -t 16 $trim_dir/*.fastq.gz -o $fastqc_dir/

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

