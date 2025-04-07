# "Getting Started with The Command Line" Exercise

This is an exercise to get people familiar with common bioinformatics command line activities on a High Performance Computing (HPC) cluster.

These activities include:
- 🗺️navigating the command line
- 📝creating and editing simple scripts
- ☑️executing array jobs (using the LSF job scheduler) on Minerva, Mount Sinai's HPC. 

By the end of this exercise, we will be prepared to run [fastp](https://github.com/OpenGene/fastp), a "tool designed to provide ultrafast all-in-one preprocessing and quality control for FastQ data," on four .fastq files.

**fastp citation**
>Shifu Chen. 2023. Ultrafast one-pass FASTQ data preprocessing, quality control, and deduplication using fastp. iMeta 2: e107. [DOI](https://doi.org/10.1002/imt2.107)

## Step 1
### Locate the Data
Using `cd` (change directory), navigate to the `master_data` folder on Minerva containing the raw .fastq files we will use in the exercise:
```
cd /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy
```
*If you are following along on GitHub, these files can be found in the `master_data` folder within this directory.*

These .fastqs are truncated test data adapted from the [NF-core test data repository](https://github.com/nf-core/test-datasets/tree/rnaseq). Samples are from S. cerevisiae (yeast), and are 101bp paired-end strand-specific RNA-seq files, sub-sampled to 50,000 reads.

<details>
<summary> Sample details </summary>  
  
**Sample info:**
  
| run_accession | experiment_alias | read_count | sample_title |
|---------------|------------------|------------|--------------|
| SRR6357070 | GSM2879618 | 47629288 | Wild-type total RNA-Seq biological replicate 1 |
| SRR6357071 | GSM2879619 | 68628914 | Wild-type total RNA-Seq biological replicate 2 |
| SRR6357072 | GSM2879620 | 54771596 | Wild-type total RNA-Seq biological replicate 3 |
| SRR6357073 | GSM2879621 | 56006930 | Rap1-AID degron no induction total RNA-Seq biological replicate 1 |

**Sample citation:**
>Andrew C K Wu, Harshil Patel, Minghao Chia, Fabien Moretto, David Frith, Ambrosius P Snijders, Folkert J van Werven. Repression of Divergent Noncoding Transcription by a Sequence-Specific Transcription Factor. Mol Cell. 2018 Dec 20;72(6):942-954.e7. doi: 10.1016/j.molcel.2018.10.018.
>[Pubmed](https://pubmed.ncbi.nlm.nih.gov/30576656/) [GEO](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE110004)
</details>

Each subfolder within the `/sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy` directory contains the .fastq files for each of the four samples we are using for this example. 

>💡**Tip**: As you move throughout your directories, creating and modifying files, it can become confusing.
> - If you ever get lost or disoriented in your file structure, just type `pwd` (for "print working directory"). This will output the full path of your current directory.
> - You can also type `ls` to list all the files in your current directory. Try it out now!*

Let's look inside one of the subfolders:
```
cd SRR6357070
ls
```
You'll notice there are actually two .fastq files for each sample. These files come from paired-end, strand-specific RNA-seq, so read 1 is the forward read and read 2 is the reverse read. 

Let's go back to the main data folder. This command moves us one folder up in the file hierarchy:
```
cd ../
```

## Step 2
### Create a Sample List
Next we create a sample list pointing to the names and locations of the raw .fastq files. This will tell your script what files to look for and where they are stored.

To do this, we will run the command `printf '%s\n' "$PWD"/* >FastP_practice_samplelist_${MY_NAME}.txt`, replacing `${MY_NAME}` with, you guessed it, your name. 

So mine will look like: 
```
printf '%s\n' "$PWD"/* >FastP_practice_samplelist_Kelsey.txt
```
For simplicity, for the rest of the exercise, I will just refer to this file as `"samplelist.txt"`

Let's break down the command:
- `printf '%s\n':`
        The `printf` command is used to format and print text. The format string `'%s\n'` specifies that it should print a string (`%s`) followed by a newline (`\n`).    
- `"$PWD"/*:`
        This is the path to the current working directory (`$PWD`) followed by an asterisk (`*`). The asterisk is a wildcard character that matches any file or directory within the current directory. Because we navigated to the `/sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy` folder, this is the working directory that will be printed, followed by the contents of the directory, which are the subfolders containing the .fastq files for each sample.
- `>samplelist.txt:`
        The "output redirection operator" (`>`) sends the output of a command to a file instead of printing it in the terminal. You decide the file's name and extension. Here we are creating a .txt file. 
>⚠️<ins>**Important**</ins>⚠️ If the file does not exist, defining the name and the file extension in the command will create a new file. **But this command will overwrite the contents of an existing file if it has the same name**. Be careful when using `>`.  
            
- So, putting it all together, this command will:
    
    - *Expand the wildcard:*
        The `*` wildcard will be expanded to match all files and directories in the current working directory.
        
    - *Print the paths:*
        For each file or directory matched, the `printf` command will print its full path, followed by a newline.
      
    - *Save to a text file:*
        Instead of displaying the output of the command in the terminal, `>` will redirect the output to a new file, `samplelist.txt`.

## Step 3
### Modify your Sample List
The sample list you just created will look like this:

|  | 
|---------------|
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/README.txt |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357070 |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357071 |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357072 |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357073 |

You will note that the first line contains a `README.txt` file. This is a file in the `/sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy` folder that includes some sample information (the "Sample details" in Step 1).

It is good practice to have README files in your master data folders so you and current/future lab members know what the files are, where the data comes from, what species it is, the read length, etc. 

But it will generate an error if we try to run an array job using this file (because the array job will look for subdirectories containing .fastq files, not text files in the main directory).  

There are many ways to modify the file to remove the line; this is one way to do it quickly using the command line:

`Nano` is one of many Linux text editors you can use to modify files on the command line. This will open the file interactively:
```
nano samplelist.txt
```
>💡**Tip:** This is a great time to try out "Tab to complete"!
> - Since your file will be named something like `FastP_practice_samplelist_Kelsey.txt`, start typing `nano Fa` and then hit Tab.
> - It should auto-complete the file name until `FastP_practice_samplelist_`
> - Then enter the first letter of your name and hit Tab again, entering letters and hitting Tab until you have completed your file's name.  

Once the file is open, use the arrow keys to navigate to the line we wish to remove, then delete the line with `ctrl + k`.

To save and quit: `ctrl + o` ("Write Out" the file, saving the output), `Enter` (when prompted to provide the file name to be written, we hit Enter to keep the same name), and `ctrl + x` (exit nano).

## Step 4
### Create the Script
Navigate to the `Scripts` directory and create your own subdirectory using the `mkdir` (make directory) command:
```
cd /sc/arion/projects/NGSCRC/Scripts/Umbrella_Academy

mkdir Kelsey
```
We need the sample list to be in the same folder as your script, but it's currently still in the `master_data` folder where it was made. We will use `mv` to move your sample list to the directory you just created. 

Because we have navigated to the `Scripts` directory, we need to append the location of the sample list to this command in order to locate it.
The command will look like `${path to sample list}/FastP_practice_samplelist_${MY_NAME}.txt ${MY_NAME}`:
```
mv /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/FastP_practice_samplelist_Kelsey.txt Kelsey
```
>💡**Tip:** The basic syntax for most UNIX commands is essentially:
> - "What are you doing?" (*action*)
> - "What are you doing it to?" (*input*)
> - "What is the desired result?" (*output*)
>  
> Applying this here:
> - "What are you doing?" *moving a file*
> - "What are you doing it to?" *the sample list*
> - "What is the desired result?" *file is moved to my directory*

Now, make a copy of the `FastP_practice_annotated.sh` script using `cp`. 

In one step, you can also append your name to the end of the file and move it into the subdirectory that you just created. The command will look like `cp FastP_practice_annotated.sh ${MY_NAME}/FastP_practice_${MY_NAME}.sh`:
```
cp FastP_practice_annotated.sh Kelsey/FastP_practice_Kelsey.sh
```
Do you see the UNIX syntax in action here?

*If you are following along on GitHub, follow [this link](FastP_practice_annotated.sh) to access the script.*

## Step 5
### Modify the Script
Now you have your own sample list and your own shell script that you can modify to run fastp yourself! 

Navigate to your folder and open the script for editing using `nano`:
```
cd Kelsey
nano FastP_practice_Kelsey.sh
```
Revise according to the instructions contained in the file.

Don't forget to save and exit (`ctrl + o`, `Enter`, and `ctrl + x`).

## Step 6
### Submit the Job
When the file is ready to be executed, we will use LSF syntax to submit the job. 

LSF (Load Sharing Facility) is the Minerva job scheduling platform, which determines your job's priority, available resources, elapsed time, etc. Such schedulers are essential for HPC environments, where massive amounts of computing power must be shared across many individuals. LSF is the one used on Minerva, but there are others (e.g. Slurm).

>💡**Tip:** Because array jobs run the same script over multiple samples, it is good practice to test your script on a single sample first. Debug your script until it works on one sample, and then scale up.

We will first test the LSF batch job on a single sample:
```
bsub -J MyArrayJob[1] < FastP_practice_Kelsey.sh
```
Let's break down the command:
- `bsub:` The syntax to submit a job using LSF is `bsub`.
- `-J MyArrayJob[1]:` We specify the job type (`-J`) as an array job (`MyArrayJob`) and specify the samples included in the array.  
  Typical array syntax would have you specify the span of samples in the array (e.g. `[1-2]` over samples 1 and 2). We *could* tell it to run it from sample 1 to sample 1 (`[1-1]`), but it understands that when we specify `[1]`, we want it to run for a single sample.
- `< FastP_practice_Kelsey.sh:` This is how we tell it to submit (`<`) your script (`FastP_practice_Kelsey.sh`) to the LSF batch job we just described. 

Because we have written the script to run as an array job, we must still submit it as an array, even when testing on a single sample. 

To check on the progress of the job (whether it is pending or running, how long it has been running, if it has finished), we can use `bjobs`. To continually check on the progress, we use `watch bjobs`. 

## Step 7
### Debug (as Needed)
Once the job has finished, we can check to see whether it was successful. 

We can look at the log and error files that have now been generated in your `Scripts` folder. If we just want to look at a file and not edit it, we can use `less` to open it, and `ctrl + z` to close it.

**Were your jobs successful? How do you know?**

You can also check the actual output in the `Work` directory. We haven't been to this folder yet, but we created a new output folder in the `Work` directory in the array job script. 

The command to access it will look like `cd /sc/arion/projects/NGSCRC/Work/Umbrella_Academy/trimmed_reads_practice/${MY_NAME}`. 

Is there output in the folder?

> 🐞 **Did your job fail?** Here are a few troubleshooting ideas:
> - Check that you updated all the sections of the script that needed to be updated. Make sure you remembered to change the `${MY_NAME}` variable to your name.
> - Check that the variables you are calling point to real files. For example, if you named your sample list `FastP_practice_samplelist_JohnnyCoolGuy.txt` but defined the `${MY_NAME}` variable in your script as `John`, your script won't find your sample list.
> - Make sure your sample list contains only 4 rows, one for each sample, and points to the correct sample directories for the raw .fastq files.
> - Make sure you typed your `bsub` command correctly, including the name of your script. Make sure you are launching the job from the `Scripts` folder that contains your script. 

## Step 8
### Run the Final Array Job
Once you are satisfied that your job works for one sample, you can submit your array job for the remaining samples:
```
bsub -J MyArrayJob[2-4] < FastP_practice_Kelsey.sh
```
> 💡**Tip:** Note that you don't have to restart the array from 1 (e.g. `MyArrayJob[1-4]`) since we've already successfully finished the first sample.
> If you do run from `[1-4]`, note that it will overwrite your output for sample 1 from your previous job. 

Check on your jobs using `bjobs` or `watch bjobs`. Now that we submitted an actual array job, you can now monitor multiple jobs at once. Are some running and some still pending? 

Once they have finished running, check the output and error files for each sample and check the output in the `Work` folder to make sure they completed successfully.

### 🎉Congratulations! 
You successfully ran fastp on the HPC on 4 samples using an array job! Pat yourself on the back! 👋

### Resources
- Clean example script [here](FastP_practice_clean.sh).
  - This gives you an example of what an actual script might look like.
  - This script is ultimately very simple because we ran fastp using only the default settings, and specified only input and output files.
  - For more complex scripts, I highly suggest keeping in the definition of what each variable in the program command does, and why. This is helpful to jog your memory when you return to a script after some time, as well as for writing the methods sections of your papers and proposals, and justifying your choices to reviewers.

- Command line cheat sheet [here].
  - This is a cheat sheet with all the commands we learned today while completing this exercise.
  - Keep this handy to refer to when you're navigating the command line yourself!
