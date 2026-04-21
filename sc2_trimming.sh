# !/bin/bash

cd /mnt/ssd/projects/RNAseq-chloe/

raw_dir="rawdata"
trim_dir="02-trimmed"
fastp_report_dir="02-trimmed/fastp-reports"
fastqc_dir="03-fastqc"

mkdir -p "$fastp_report_dir"

## =============================
## Step 02 : Trimming 
## =============================

declare -A done_samples

for f in "$trim_dir"/*_R1_trim.fastq.gz; do
    base=$(basename "$f" _R1_trim.fastq.gz)
    done_samples["$base"]=1
done

start_time=$(date +%s)

for r1 in "$raw_dir"/*_R1_*.fastq.gz; do
    base=$(basename "$r1" _R1_001.fastq.gz)

    if [[ -n "${done_samples[$base]}" ]]; then
        echo "Skipping already processed: $base"
        continue
    fi
    
    r2="$raw_dir/${base}_R2_001.fastq.gz"

    out_r1="$trim_dir/${base}_R1_trim.fastq.gz"
    out_r2="$trim_dir/${base}_R2_trim.fastq.gz"

    html="$fastp_report_dir/${base}_fastp.html"
    json="$fastp_report_dir/${base}_fastp.json"

    now=$(date)
    echo $now
    echo "Processing: $base"

    ./fastp \
      -i "$r1" \
      -I "$r2" \
      -o "$out_r1" \
      -O "$out_r2" \
      --detect_adapter_for_pe \
      --cut_tail \
      --cut_mean_quality 20 \
      --length_required 30 \
      --thread 32 \
      --html "$html" \
      --json "$json"

    
done

end_trimming_time=$(date +%s)

## ===========================================
## Step 03 : Quality Control after trimming
## ===========================================

echo "==============================="
echo "Starting QC"
echo "==============================="

## 01/ Running fastqc on all rawdata
fastqc -t 16 $trim_dir/*.fastq.gz -o $fastqc_dir/

## 02/ multiqc on everything alltogether
multiqc $fastqc_dir/ -n multiqc_all.html -o $fastqc_dir/multiqc_all -p -fp

end_qc_time=$(date +%s)

## Durations /
## ==========
trimming_duration=$((end_trimming_time - start_time))
qc_duration=$((end_qc_time - end_trimming_time))
duration=$((end_qc_time - start_time))

printf "Trimming execution time: %02d:%02d:%02d\n" \
  $((trimming_duration/3600)) $(( (trimming_duration%3600)/60 )) $((trimming_duration%60))

printf "Quality control execution time: %02d:%02d:%02d\n" \
  $((qc_duration/3600)) $(( (qc_duration%3600)/60 )) $((qc_duration%60))

printf "Total execution time: %02d:%02d:%02d\n" \
  $((duration/3600)) $(( (duration%3600)/60 )) $((duration%60))