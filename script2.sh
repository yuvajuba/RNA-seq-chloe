# !/bin/bash

cd /mnt/ssd/projects/RNAseq-chloe/

raw_dir="rawdata"
trim_dir="02-trimmed"
fastp_report_dir="02-trimmed/fastp-reports"

mkdir -p "$fastp_report_dir"

## =============================
## Step 02 : Trimming 
## =============================

for r1 in "$raw_dir"/*_R1_*.fastq.gz; do
    base=$(basename "$r1" _R1_001.fastq.gz)
    r2="$raw_dir/${base}_R2_001.fastq.gz"

    out_r1="$trim_dir/${base}_R1_trim.fastq.gz"
    out_r2="$trim_dir/${base}_R2_trim.fastq.gz"

    html="$fastp_report_dir/${base}_fastp.html"
    json="$fastp_report_dir/${base}_fastp.json"

    fastp \
      -i "$r1" \
      -I "$r2" \
      -o "$out_r1" \
      -O "$out_r2" \
      --detect_adapter_for_pe \
      --cut_tail \
      --cut_mean_quality 20 \
      --length_required 30 \
      --thread 8 \
      --html "$html" \
      --json "$json"

    
done