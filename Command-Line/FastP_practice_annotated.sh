#!/bin/bash
#BSUB -P acc_NGSCRC 		   # Zamarin Lab allocation account
#BSUB -n 1	    		   # total number of compute cores
#BSUB -W 00:10	    		   # walltime in HH:MM
#BSUB -q premium    		   # queue 
#BSUB -R "rusage[mem=32GB]"        # 32 GB of memory (32 GB per core)
#BSUB -J "NAME ME!"                # Job name
#BSUB -o out.%J.%Im		   # output file name (%I=job array index, %J=jobID)
#BSUB -e err.%J.%I  		   # error file name (same nomenclature as above)
#BSUB -L /bin/bash		   # Initialize the execution environment


# COPY this file to your scripts folder before you make edits. 
    # It's a good idea to rename it (e.g. add your name) to not get it mixed up with the original

# Review the header
    ## I've updated the parameters for this job for all but one step
    ## Which step do you need to update?

module load fastp/0.23.2
# This tells the script to load the module needed to run this command

# The first step is to define the variables we will call later in the script
    # We do this to minimize the amount of "hard coding" in our script 
    # By creating a variable for each part of the script that can change, we make our scripts more reproducible and easier to modify

# Update this to your name 
MY_NAME=Kelsey
    # This will keep all our subsequent files separate from each other

# First, we define the overall directory in the Work folder for the output from this script
OUT_DIR="/sc/arion/projects/NGSCRC/Work/Umbrella_Academy/trimmed_reads_practice"
    # "OUT_DIR" = "Output Directory"
    # We will get more specific with subfolders later, but this is the "parent" directory for all the output

# Then we tell the script where to look for the raw sample files
SAMPLE_LIST=FastP_practice_samplelist_${MY_NAME}.txt
    # Check your sample list in your scripts folder -- does its name match the above file name?
    # The way this script is written, this step will only work if you run your script in the same folder as the location of the sample list
# **Extra credit** can you think of a way to revise this line so that the script knows where to look for the sample list? 

SAMPLE_DIR=$(head -n "${LSB_JOBINDEX}" "${SAMPLE_LIST}" | tail -n 1)
    # This line iteratively pulls each line of the sample list, corresponding to the path for each sample .fastq
    # This only works because we are running this as an array job, using the "bsub -J MyArrayJob[xx-xx]" command
    # The ${LSB_JOBINDEX} term tells it to pull the line corresponding to the span of numbers we input in the array job request

SAMPLE_ID=$(basename ${SAMPLE_DIR})
    # This line pulls just the name of the base directory (the final folder) for each sample directory
    # Since each pair of .fastq files are in their own subdirectory, named for the sample ID, this pulls the sample ID

# Here we define the .fastq file names of the forward (read 1) and reverse (read 2) reads
FWD_READ=${SAMPLE_DIR}/${SAMPLE_ID}_1.fastq.gz
REV_READ=${SAMPLE_DIR}/${SAMPLE_ID}_2.fastq.gz
    # These files are gzipped to save space (hence ".fastq.gz")
    # FastP can read and trim zipped files, but not all tools can

# Now we are creating our own subfolders for each sample 
mkdir -p ${OUT_DIR}/${MY_NAME}/${SAMPLE_ID}

# Here we define what our output will be called and where it will go
FWD_PAIRED_OUT=${OUT_DIR}/${MY_NAME}/${SAMPLE_ID}/${SAMPLE_ID}_R1_paired.fastq.gz
REV_PAIRED_OUT=${OUT_DIR}/${MY_NAME}/${SAMPLE_ID}/${SAMPLE_ID}_R2_paired.fastq.gz
    # We're putting the output in our own work folders for this project, and creating a subfolder for each sample 


# Finally! We are done defining things, on to the main event...

# This chunk is optional, but it will print the following sample information to the output file:
echo `date`
echo "Starting fastp trimming ${SAMPLE_ID}"
echo "Forward read: ${FWD_READ}"
echo "Reverse read: ${REV_READ}"

# Here it is, actual FastP command! (All this for one line of code)
fastp -i ${FWD_READ} -I ${REV_READ} -o ${FWD_PAIRED_OUT} -O ${REV_PAIRED_OUT}
    # -i and -I tell it the forward and reverse inputs (the raw .fastq files)
    # -o and -O tell it the forward and reverse outputs (the trimmed .fastq files)
# And that's it!

mv fastp.* ${OUT_DIR}/${MY_NAME}/${SAMPLE_ID}
    # FastP creates a nice HTML/json file with quality statistics
    # This line moves those files into the output folder

# This chunk is also optional for the same reason as above
echo "Finished fastp trimming ${SAMPLE_ID}"
echo `date`

# And we are finished! 
