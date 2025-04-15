# Command Line Cheat Sheet
This is a cheat sheet for the codes learned during the [Command Line Exercise](Command_Line_Exercise.md).

>💡**Tip:** You can navigate quickly through this document by using the table of contents in the upper right-hand corner.
><details>
>    <summary> Help, where is the table of contents? </summary>
>    
> ![ToC Image](https://docs.github.com/assets/cb-142339/mw-1440/images/help/repository/headings-toc.webp) 
> </details>

## 🌳HPC File Structure
As a refresher, this is an example of the HPC file structure: 
```
└── Zamarin Lab Home Base (/sc/arion/projects/NGSCRC)/
    ├── master_data (Raw data, organized by project)/
    │   ├── Project 1
    │   └── Project 2
    ├── Scripts (Scripts, organized by project and by pipeline step)/
    │   ├── Project 1/
    │   │   ├── fastp Script
    │   │   └── Genome Alignment Script
    │   └── Project 2/
    │       ├── fastp Script
    │       └── Genome Alignment Script
    ├── Work (Output from scripts, organized by project and by pipeline step)/
    │   ├── Project 1/
    │   │   ├── Trimmed Reads (fastp output)
    │   │   └── Aligned Files (Genome Alignment output)
    │   └── Project 2/
    │       ├── Trimmed Reads
    │       └── Aligned Files
    ├── Tools (Shared modules for specialty projects not already available on Minerva)/
    │   ├── MultiQC
    │   └── MiXCR
    └── Resources (Shared resources such as reference genomes)/
        ├── Reference Genome (WGS)
        └── Reference Genome (WES)
```
This structure becomes particularly useful as projects become more complex.

<details>
<summary>Expand for a more detailed example to illustrate this complexity:</summary>
  
### Complex file structures

In this example, we have `Project 1` with two samples (`Sample 1` and `Sample 2`), and `Project 2` with 1 sample (`Sample A`). 

```
.
└── Zamarin Lab Home Base (/sc/arion/projects/NGSCRC)/
    ├── master_data/
    │   ├── Project 1/
    │   │   ├── Sample 1/
    │   │   │   ├── Sample_1_raw_read_1.fasq
    │   │   │   └── Sample_1_raw_read_2.fasq
    │   │   └── Sample 2/
    │   │       ├── Sample_2_raw_read_1.fasq
    │   │       └── Sample_2_raw_read_2.fasq
    │   └── Project 2/
    │       └── Sample A/
    │           ├── Sample_A_raw_read_1.fasq
    │           └── Sample_A_raw_read_2.fasq
    ├── Scripts/
    │   ├── Project 1/
    │   │   ├── fastp Script/
    │   │   │   ├── project_1_sample_list.txt
    │   │   │   └── project_1_fastp.sh
    │   │   └── Genome Alignment Script/
    │   │       ├── project_1_trimmed_sample_list.txt
    │   │       └── project_1_align.sh
    │   └── Project 2/
    │       ├── fastp Script/
    │       │   ├── project_2_sample_list.txt
    │       │   └── project_2_fastp.sh
    │       └── Genome Alignment Script/
    │           ├── project_2_trimmed_sample_list.txt
    │           └── project_2_align.sh
    ├── Work/
    │   ├── Project 1/
    │   │   ├── Trimmed Reads/
    │   │   │   ├── Sample 1/
    │   │   │   │   ├── Sample_1_trimmed_1.fastq
    │   │   │   │   └── Sample_1_trimmed_2.fastq
    │   │   │   └── Sample 2/
    │   │   │       ├── Sample_2_trimmed_1.fastq
    │   │   │       └── Sample_2_trimmed_2.fastq
    │   │   └── Aligned Files/
    │   │       ├── Sample 1/
    │   │       │   └── Sample_1_aligned.bam
    │   │       └── Sample 2/
    │   │           └── Sample_2_aligned.bam
    │   └── Project 2/
    │       ├── Trimmed Reads/
    │       │   └── Sample A/
    │       │       ├── Sample_A_trimmed_1.fastq
    │       │       └── Sample_A_trimmed_2.fastq
    │       └── Aligned Files/
    │           └── Sample A/
    │               └── Sample_A_aligned.bam
    ├── Tools/
    │   ├── MultiQC
    │   └── MiXCR
    └── Resources/
        ├── Reference Genome (WGS)
        └── Reference Genome (WES)

```
</details>

Visualizing the structure of your directories can be useful when thinking about navigating the command line.

*File trees🌲created using [this cool tool](https://tree.nathanfriend.com/)*

## 🗺️Navigating the Command Line
These are the codes we learned for basic navigation around the command line environment:

### Change directory: `cd`
Use this code to move from your current directory to another directory.

For example, this code brings us to the `master_data` folder where the raw .fastqs for the [Command Line Exercise](Command_Line_Exercise.md) are stored:
``` Shell
cd /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy
```
If you don't specify a destination (as we did when we included the path to the `master_data` above), typing just `cd` will send you to your login directory.

Let's say you want to move up two folders to the `/sc/arion/projects/NGSCRC/master_data/` folder. 
- You could type out the whole path (`cd /sc/arion/projects/NGSCRC/master_data/`).
- But you can also use "dot dot" (`..`), which is recognized as the directory immediately above the current directory (called the "parent" directory).
- If you know how many folders up you want to travel, you can separate your dot dots with a slash to get to the desired destination.

Since we are moving up two directories, we would type
``` Shell
cd ../../
```
### Print working directory: `pwd`
Use this to display the full path of your current directory.

This is useful to verify where you are in your file structures, particularly if you are using `..` and not absolute paths to travel.

In the example above, it would be best to run `cd ../../` followed by `pwd` to verify that you are in the directory you intended to reach. 

As we learned in the exercise when we generated the sample list, `pwd` can also be useful when combined with other commands (like `printf '%s\n'`, to capture full paths to files).

### List contents: `ls`
Use this to list the contents of your current directory. 

For example, If we were in the "Zamarin Lab Home Base" directory (`/sc/arion/projects/NGSCRC`) and we typed `ls`, we would see:
```
/sc/arion/projects/NGSCRC/
├── master_data
├── Scripts
├── Work
├── Tools
└── Resources
```
In this case, the Zamarin Lab parent directory only contains subdirectories, but `ls` will also show you files within a directory if they are present.

Let's say we go into the `Project 1` folder within `master_data`, where we have subdirectories containing raw data for `Sample 1` and `Sample 2`, as well as a README text file describing the data. Typing `ls` would show us this:
```
Project 1/
├── README.txt
├── Sample 1
└── Sample 2
```
> 🧠 **Extra Credit:** If you want to see additional information, you can type `ls -l`. This will show you file and directory details like permissions, number of links, owner, group, size, and time of last modification.  
>
> `ls -l` gives you file size in bytes, which quickly becomes difficult to parse with large files stored on the cluster. To give the size in KB or GB you can type `ls -lh` (for "human readable").

### Make a directory: `mkdir`
Use this to create a new directory in your current working directory. 

## 📝Creating and Manipulating Files
These are the codes we learned to open, edit, move, and create files:

### Edit and create new files: `nano`
This is one of many Linux text editors, but it is my favorite (I find it powerful yet user-friendly). Other popular editors are `vim`, `vi`, and `Emacs`.

Just type `nano` and your file name to open the file interactively for editing, or `nano` and a new file name + extension to create a blank file.

### View file contents: `less`
Use this if you only want to read the contents of a file, not edit it. This is often the safer option because you don't risk accidentally modifying a file you don't intend to change. 

As with `nano`, simply type `less` and the name of the file you wish to view. 

> 🧠 **Extra Credit:** Typing `head` and your file name will print just the top 10 lines of your file. Typing `tail` will show you the bottom 10. These are good for quick peeks at your files.

### Move files: `mv`
Use this to move a file to a new location. Type `mv`, the file name, and the path to the desired destination. 

### Copy files: `cp`
Use this to make a new copy of a file. Type `cp`, the original file name, and the name of the copy. 

You cannot copy two files with the same name in the same directory. Your options are to:
1. Copy a file in the same directory and give it a new name, e.g. `cp file.sh file_1.sh`
2. Copy the file into a new directory, e.g. `cp file.sh different_folder/file.sh`

### Create a sample list
Navigate to the directory with your target files and run this code to create a sample list:
```  Shell
printf '%s\n' "$PWD"/* > samplelist.txt
```
We learned how to do this for the raw .fastq files used in this exercise, but sample lists are also used as input for downstream applications like aligning files to the genome. 

In fact, the output from our fastp job, where we filtered out low-quality reads and trimmed the sequencing adapters, will be the input for the next step in the RNA-seq processing pipeline (aligning the reads to the genome). Instead of using the raw .fastq files as the input, we would create a sample list pointing to the trimmed reads. To do so, we just navigate to our output folder from our fastp job and run this code.  

### ⚠️ An Important Warning
You might have noticed that I've only taught you how to create files and directories, not remove them.

This is because it is **VERY DANGEROUS** to remove files from the HPC because it is not backed up and, **once they are deleted, they are gone forever**. The only exception is if the files have been archived, but this must be specifically requested.

If I need to delete files or directories, I will often do it manually through my FTP client (I use 🪟WinSCP for Windows) because it gives me a popup message asking me to confirm the deletion. This way I can triple-check that I'm removing the file I intend to remove.  

## ☑️Launching Jobs using LSF
These are the codes we learned to launch array jobs and interactive jobs using the [LSF (Load Sharing Facility)](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=overview-lsf-introduction) job scheduler:

### Shell Script Header
The header of each script you run will look something like this:
``` Shell
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
```
### Array Job Execution
Once you have written your array job script, use the below command to execute it:
``` Shell
bsub -J MyArrayJob[x-xx] < Array_Script.sh
```
The numbers within the `MyArrayJob` brackets will depend on the number of samples included in your array job; if you need to run it over 50 samples, it will be `-J MyArrayJob[1-50]`.

>🧠**Extra Credit:** What we learned in the lesson, however, is that you should always test your array job scripts on a single sample first.
>
>So if you have 50 total samples, you would really run `-J MyArrayJob[1]` on the first sample until you are satisfied your code works, and then `-J MyArrayJob[2-50]` on the remaining 49 samples.

### Shell Script Execution
You'll notice that I named the first heading in this section **"Shell Script Header."** In this exercise, we learned how to run an array job, but sometimes you want to run a script for a single sample (and only ever a single sample). 

In that case, the header of the script file will look the same as it does for an array job, but you only need to run this to execute it:
``` Shell
bsub < Shell_Script.sh
```
### Launch an Interactive Shell
When we want to launch an interactive shell, where we input commands in the terminal instead of using a shell script, we need to request HPC resources. 

>⚠️**Important:** We learned that, unless we are doing very basic things like navigating the command line and creating or editing small files, we need to specifically request an interactive shell. 

This is the code to request an interactive shell:
``` Shell
bsub -Is -n 1 -R "rusage[mem=10000]" -P acc_NGSCRC -W 60 /bin/bash
```
The parameters you will alter, depending on your task, are:
- `-n`: If you want to parallelize your job, you can request more cores. This would be unusual, however, as most jobs requiring parallelization will be complex and should be written in a script.
- `-R "rusage[mem=xxxxx]"`: Depending on the size of your task, you will request different amounts of memory. It's always better to start small and scale up your requests. Remember that LSF memory requests are in megabytes (MB). If you want to request 10 gigabytes (GB), for example, multiply by 1,000.
- `-W`: Depending on how long your task will take, you can request different amounts of wall time. As with memory, start small and scale up as needed. You can request in minutes (`MM`) or hours (`HH:MM`).

### Monitor your Jobs: `bjobs`
You can view the status of your jobs using `bjobs`.

To continuously monitor the status of your jobs (refreshed every 2 seconds) use `watch bjobs`.

>🧠**Extra Credit:** `bjobs` has many options -- check out [this page](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=bjobs-options) to see them all.

## ⚒️Modules
These are the commands we used to view and load modules. "Modules" just means all the software available on the HPC.

### Load a module: `module load`
If you just type the module name (e.g. `module load python`), you will load the most recent version of the module. You can also type the specific version of the module (e.g. `module load python/3.12.5`).

It also accepts the shorthand `ml` (e.g. `ml python`).

### Find available modules: `module avail`
If you just type `module avail`, it will show you all available modules on the HPC. (This is a lot of software, so it takes a while to load).

If you want to see if a certain package is available, you can type e.g. `module avail python` and it will show you all version(s) available (if any). 

If you want to search more generally, you can type e.g. `module avail py` and it will show you all modules that contain "py" in their name. 

### Show your loaded modules: `module list`
Typing `module list` will show you all the modules you currently have loaded. 

Confusingly, this will also accept the shorthand `ml`. So `ml` followed by a module name loads a module, and `ml` alone shows you the modules you have loaded. 

### Running a module
Typically, to run commands using a specific module, you just need to type the module name followed by the commands. 

For example, we ran `fastp -i ${FWD_READ} -I ${REV_READ} -o ${FWD_PAIRED_OUT} -O ${REV_PAIRED_OUT}` after loading fastp in our array job, and `python -m multiqc ${path}` after loading Python in our interactive shell. 
