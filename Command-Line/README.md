# Getting started with the command line
This is the directory for the "Getting started with the command line" class. 

Below are the files contained in this directory, and their usage.

### 1. [Command_Line_Exercise.md](Command_Line_Exercise.md) 
The step-by-step exercise for the "Getting started with the command line" class.

### 2. [master_data](master_data) folder 
Raw .fastq data for the exercise. Contains one subdirectory for each of the four samples. 

These subdirectories contain the raw .fastq files for both forward and reverse reads (`SampleID_1.fastq.gz` and `SampleID_2.fastq.gz`). 

These reads are gzipped to save space (hence `.fastq.gz`).

### 3. Scripts for the exercise
- **[FastP_practice_annotated.sh](FastP_practice_annotated.sh): Highly annotated shell script for running fastp**
  - This is the script used in the exercise.
  - Each line is commented and explained.
  - It includes sections to be updated so the exercise is tailored to the individual completing it.
- **[FastP_practice_clean.sh](FastP_practice_clean.sh): Clean shell script for running fastp**
  - This script is for reference and is not used in the exercise.
  - Includes minimal comments and annotations.
  - This emulates what a real script for running fastp would look like.

### 4. [command_line_cheat_sheet.md](command_line_cheat_sheet.md)
A cheat sheet including the commands used in the exercise, with full explanations and use cases. 

### 5. README.md
The markdown (.md) file to generate this summary! 
