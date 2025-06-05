# Real-world Debugging Example
These are three real `.out` (*output*) and/or `.err` (*error*) files that I generated while writing a script to run [MiXCR](https://mixcr.com/mixcr/about/), an algorithm to assemble and quantify TCR sequences, on **Minerva** (Mount Sinai's HPC).
![MiXCR](https://mixcr.com/mixcr/about-light.svg#only-light)

I'll walk you step-by-step through my process for identifying and fixing each of these bugs 🪲

> **ℹ️Note:** You will encounter many different kinds of errors as you write your own scripts and conduct your own analyses, so I can't cover all possible scenarios. 
>
> But these three examples serve as a good illustration of the categories of bugs you will encounter and strategies for addressing them.

## 🪲 Example 1: The fix is in the error message
These are the best kinds of errors to debug, because the error message tells you (roughly) what you need to do. 

Here is the output from the first time I ran my script:

<details>
  <summary> Full output file </summary>
  
```
Sender: LSF System <lsfadmin@lh05g17>
Subject: Job 137582052[1]: <MyArrayJob[1-1]> in cluster <chimera> Done

Job <MyArrayJob[1-1]> was submitted from host <li03c03.chimera.hpc.mssm.edu> by user <monsok03> in cluster <chimera> at Thu Aug 22 10:14:37 2024
Job was executed on host(s) <lh05g17>, in queue <premium>, as user <monsok03> in cluster <chimera> at Thu Aug 22 10:15:51 2024
</hpc/users/monsok03> was used as the home directory.
</sc/arion/projects/NGSCRC/Scripts/NRG-GY003/TCRseq> was used as the working directory.
Started at Thu Aug 22 10:15:51 2024
Terminated at Thu Aug 22 10:15:52 2024
Results reported at Thu Aug 22 10:15:52 2024

Your job looked like:

------------------------------------------------------------
# LSBATCH: User input
#!/bin/bash
#BSUB -P acc_NGSCRC 		   # Zamarin Lab allocation account
#BSUB -n 1	    		       # total number of compute cores
#BSUB -W 08:00	    		   # walltime in HH:MM
#BSUB -q premium    		   # queue 
#BSUB -R "rusage[mem=32GB]"        # 32 GB of memory (32 GB per core)
#BSUB -J "MiXCR_FC7[1-94]"         # Job name (batch job for flow cell 7 TCR-seq)
#BSUB -o out.%J.%Im		     # output file name (%I=job array index, %J=jobID)
#BSUB -e err.%J.%I  		   # error file name (same nomenclature as above)
#BSUB -L /bin/bash		     # Initialize the execution environment


export PATH=/sc/arion/projects/NGSCRC/Tools/MiXCR/mixcr-4.7.0-0/bin:$PATH

FLOW_CELL="FC07"
SAMPLE_LIST=${FLOW_CELL}_sample_list.txt
SAMPLE_DIR=$(head -n "${LSB_JOBINDEX}" "${SAMPLE_LIST}" | tail -n 1)
SAMPLE_ID=$(basename ${SAMPLE_DIR})
OUTPUT_FOLDER="/sc/arion/projects/NGSCRC/Work/NRG-GY003/TCRseq/MiXCR"

echo `date`
echo "Starting MiXCR for ${SAMPLE_ID}"

## MiXCR has a pre-set for Cellecta DNA sequencing so we will use that

mkdir -p ${OUTPUT_FOLDER}/${SAMPLE_ID}
mkdir -p ${OUTPUT_FOLDER}/${SAMPLE_ID}/figs


mixcr analyze cellecta-human-dna-xcr-umi-drivermap-air \
    ${SAMPLE_DIR}/${SAMPLE_ID}_R1_001.fastq.gz \
    ${SAMPLE_DIR}/${SAMPLE_ID}_R2_001.fastq.gz \
    ${OUTPUT_FOLDER}/${SAMPLE_ID}

mv ${SAMPLE_ID}.* ${OUTPUT_FOLDER}/${SAMPLE_ID}
cd ${OUTPUT_FOLDER}/${SAMPLE_ID}

mixcr exportQc align \
    ${SAMPLE_ID}.clns \
    figs/${SAMPLE_ID}_alignQc.pdf

mixcr exportQc chainUsage \
    ${SAMPLE_ID}.clns \
    figs/${SAMPLE_ID}_chainUsage.pdf

mixcr exportQc tags \
    ${SAMPLE_ID}.clns \
    figs/${SAMPLE_ID}_tags.pdf

(... more ...)
------------------------------------------------------------

Successfully completed.

Resource usage summary:

    CPU time :                                   0.14 sec.
    Max Memory :                                 -
    Average Memory :                             -
    Total Requested Memory :                     32768.00 MB
    Delta Memory :                               -
    Max Swap :                                   -
    Max Processes :                              -
    Max Threads :                                -
    Run time :                                   1 sec.
    Turnaround time :                            75 sec.

The output (if any) follows:

Thu Aug 22 10:15:52 EDT 2024
Starting MiXCR for P2A10_GADCIWn2_S10
Wrong version of java. Please use Java 7 or higher.
Wrong version of java. Please use Java 7 or higher.
Wrong version of java. Please use Java 7 or higher.
Wrong version of java. Please use Java 7 or higher.
Finished MiXCR for P2A10_GADCIWn2_S10
Thu Aug 22 10:15:52 EDT 2024


PS:

Read file <err.137582052.1> for stderr output of this job.

```

</details>
