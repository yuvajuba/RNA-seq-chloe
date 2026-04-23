#!/bin/bash

# cd /mnt/ssd/projects/RNAseq-chloe/04-mapping || exit 1

## ===========================================
## Step 04 : Mapping
## ===========================================


## 1- Indexing the genome
## ======================
# echo "Starting the analysis"
# echo "====================="
# echo "1- Indexing the genome"

# if [ ! -f STAR_index/SA ]; then
#     STAR --runThreadN 32 \
#         --runMode genomeGenerate \
#         --genomeDir STAR_index/ \
#         --genomeFastaFiles genome/GRCh38.primary_assembly.genome.fa \
#         --sjdbGTFfile genome/gencode.v47.annotation.gtf \
#         --sjdbOverhang 100
# else
#     echo "STAR index already exists, skipping indexing"
# fi


## 2- Mapping
## ==========
echo "Start mapping"
echo "============="

cd /mnt/ssd/projects/RNAseq-chloe/

TRIM_DIR="02-trimmed"
MAP_DIR="04-mapping"
GENOME_DIR="$MAP_DIR/STAR_index"
OUT_MAPPING="$MAP_DIR/Out_mapping"

mkdir -p "$OUT_MAPPING" 

T1=$(date +%s)

for R1 in "$TRIM_DIR"/*_R1_trim.fastq.gz; do

    SAMPLE=$(basename "$R1" _R1_trim.fastq.gz)
    R2="$TRIM_DIR/${SAMPLE}_R2_trim.fastq.gz"
    

    echo "======================================="
    echo "Processing sample: $SAMPLE"
    echo "R1 = $R1"
    echo "R2 = $R2"
    echo "Start: $(date)"


    STAR \
        --runThreadN 32 \
        --genomeDir "$GENOME_DIR" \
        --readFilesIn "$R1" "$R2" \
        --readFilesCommand zcat \
        --outFileNamePrefix "$OUT_MAPPING/$SAMPLE." \
        --outSAMtype BAM SortedByCoordinate \
        --quantMode TranscriptomeSAM \
        --outSAMunmapped Within \
        --outFilterMismatchNmax 10 \
        --outFilterMultimapNmax 20


    echo "Finished processing: $SAMPLE"
    echo "End: $(date)"
done

T2=$(date +%s)
D=$(( T2 - T1 ))

echo "Finished !!"
echo "Analysis runtime : $((D / 60)) min $((D % 60)) sec"
