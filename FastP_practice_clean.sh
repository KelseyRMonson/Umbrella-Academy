#!/bin/bash
#BSUB -P acc_NGSCRC 		   # Zamarin Lab allocation account
#BSUB -n 1	    		   # total number of compute cores
#BSUB -W 00:10	    		   # walltime in HH:MM
#BSUB -q premium    		   # queue 
#BSUB -R "rusage[mem=32GB]"        # 32 GB of memory (32 GB per core)
#BSUB -J "FastPpractice"           # Job name
#BSUB -o out.%J.%Im		   # output file name (%I=job array index, %J=jobID)
#BSUB -e err.%J.%I  		   # error file name (same nomenclature as above)
#BSUB -L /bin/bash		   # Initialize the execution environment

# Load FastP
module load fastp/0.23.2

# Define your paths and input variables
MY_NAME=Kelsey
OUT_DIR="/sc/arion/projects/NGSCRC/Work/Umbrella_Academy/trimmed_reads_practice"
SAMPLE_LIST=FastP_practice_samplelist_${MY_NAME}.txt
SAMPLE_DIR=$(head -n "${LSB_JOBINDEX}" "${SAMPLE_LIST}" | tail -n 1)
SAMPLE_ID=$(basename ${SAMPLE_DIR})
FWD_READ=${SAMPLE_DIR}/${SAMPLE_ID}_1.fastq.gz
REV_READ=${SAMPLE_DIR}/${SAMPLE_ID}_2.fastq.gz

# Create the sample subfolder
mkdir -p ${OUT_DIR}/${MY_NAME}/${SAMPLE_ID}

# Define output files
FWD_PAIRED_OUT=${OUT_DIR}/${MY_NAME}/${SAMPLE_ID}/${SAMPLE_ID}_R1_paired.fastq.gz
REV_PAIRED_OUT=${OUT_DIR}/${MY_NAME}/${SAMPLE_ID}/${SAMPLE_ID}_R2_paired.fastq.gz

# Run FastP 
echo `date`
echo "Starting fastp trimming ${SAMPLE_ID}"
echo "Forward read: ${FWD_READ}"
echo "Reverse read: ${REV_READ}"

fastp -i ${FWD_READ} -I ${REV_READ} -o ${FWD_PAIRED_OUT} -O ${REV_PAIRED_OUT}

mv fastp.* ${OUT_DIR}/${MY_NAME}/${SAMPLE_ID}

echo "Finished fastp trimming ${SAMPLE_ID}"
echo `date`

