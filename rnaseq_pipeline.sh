# !/bin/bash

### To be able to execute the script : add permissions !
### chmod +x name_of_the_script.sh

RAW_DIR="/media/bioinfo/Storage_HDD/C3M/juba/RNAseq_eq2/00_RawData"
QC_DIR="/media/bioinfo/Storage_HDD/C3M/juba/RNAseq_eq2/01_QC"
TRIM_DIR="/media/bioinfo/Storage_HDD/C3M/juba/RNAseq_eq2/02_Trimmed"
QC_DIR2="/media/bioinfo/Storage_HDD/C3M/juba/RNAseq_eq2/03_QC"
ADAPTER_FWD="AGATCGGAAGAGC"
ADAPTER_REV="AGATCGGAAGAGC"


####################################
####################################
# STEP 01 : Quality Control
####################################
####################################

## 1- Running fastqc on all the raw data

fastqc --thread 32 $RAW_DIR/*.fastq -o $QC_DIR/

## 2- Running multiqc to summarise the fastqc files (getting a global overview)

multiqc $QC_DIR/ -o $QC_DIR/multiqc



####################################
####################################
# STEP 02 : Trimming the data 
####################################
####################################

## 1- Running cutadapt

# To run the tool on every sample, we need to make a loop to pass the instruction for every R1-R2 paire

cd /media/bioinfo/Storage_HDD/C3M/juba/RNAseq_eq2/
echo 'Starting trimming the data : using cutadapt'

for R1 in ${RAW_DIR}/*_R1.fastq; do 
    
    R2=${R1/_R1.fastq/_R2.fastq}
    SAMPLE=$(basename "$R1" | sed 's/_R1.fastq//')
    echo "Now processing : $SAMPLE"

    cutadapt \
        -a "$ADAPTER_FWD" -A "$ADAPTER_REV" \
        -a "A{10}" -A "G{10}" \
        -m 36 \
        -o "$TRIM_DIR/${SAMPLE}_R1_trimmed.fastq.gz" \
        -p "$TRIM_DIR/${SAMPLE}_R2_trimmed.fastq.gz" \
        "$R1" "$R2"
    
    echo "Finished trimming : $SAMPLE"
done


## 2- Running QC again with fastqc and multiqc

fastqc -t 32 $TRIM_DIR/* -o $QC_DIR2/
multiqc $QC_DIR2/ -o $QC_DIR2/multiqc



####################################
####################################
# STEP 03 : Mapping 
####################################
####################################

# 1- First indexing the genome 

# 1-1 : downloading the FASTA for the genome sequence and the GTF file for the genome annotation prior analysis

cd /media/bioinfo/Storage_HDD/C3M/juba/RNAseq_eq2/04_Mapping

STAR --runThreadN 32 \
    --runMode genomeGenerate \
    --genomeDir STAR_index/ \
    --genomeFastaFiles ./GRCh38.primary_assembly.genome.fa \
    --sjdbGTFfile ./gencode.v47.annotation.gtf \
    --sjdbOverhang 100


# 2- Mapping

GENOME_DIR="/media/bioinfo/Storage_HDD/C3M/juba/RNAseq_eq2/04_Mapping/STAR_index"
OUT_MAPPING="/media/bioinfo/Storage_HDD/C3M/juba/RNAseq_eq2/04_Mapping/Out_mapping"

T1=$(date +%s)

for R1 in ${TRIM_DIR}/*_R1_trimmed.fastq; do
    
    R2=${R1/_R1_trimmed.fastq/_R2_trimmed.fastq} 
    SAMPLE=$(basename "$R1" | sed 's/_R1_trimmed.fastq//') 

    echo "Processing sample: $SAMPLE"

    STAR \
        --runThreadN 32 \  
        --genomeDir "$GENOME_DIR" \  
        --readFilesIn "$R1" "$R2" \  
        --outFileNamePrefix "$OUT_MAPPING/$SAMPLE." \  
        --outSAMtype BAM SortedByCoordinate \  
        --quantMode TranscriptomeSAM \  
        --outSAMunmapped Within \ 
        --outFilterMismatchNmax 10 \  
        --outFilterMultimapNmax 20  

    echo "Finished processing: $SAMPLE"
done




T2=$(date +%s)
DURATION=$(( T2 - T1 ))

H=$(( DURATION / 3600))
R=$(( DURATION % 3600))
M=$(( R / 60))
S=$(( R % 60))

printf "Duration of the analysis : %02d:%02d:%02d\n" $H $M $S 


