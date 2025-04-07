# Hands-on "Getting Started with The Command Line" Exercise

This is an exercise to get people familiar with common bioinformatics command line activities on a High Performance Computing (HPC) cluster.

These include
- navigating the command line
- creating and editing simple scripts
- executing array jobs (using the LSF job scheduler) on Minerva, Mount Sinai's HPC. 

By the end of this exercise, we will run [fastp](https://github.com/OpenGene/fastp), a "tool designed to provide ultrafast all-in-one preprocessing and quality control for FastQ data," on four .fastq files.

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
Next we create a sample list pointing to the names and locations of the raw .fastq files. This will tell our script what files to look for and where they are stored.

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
>⚠️<ins>**Important**</ins>⚠️ If the file does not exist, defining the name and the file extension in the command will create a new file. **But this command will overwrite the contents of an existing file**. Be careful when using `>`.  
            
- So, putting it all together, this command will:
    
    - *Expand the wildcard:*
        The `*` wildcard will be expanded to match all files and directories in the current working directory.
        
    - *Print the paths:*
        For each file or directory matched, the `printf` command will print its full path, followed by a newline.
      
    - *Save to a text file:*
        Instead of displaying the output of the command in the terminal, `>` will redirect the output to a new file, `samplelist.txt`.

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

Once the file is open, navigate to the line we wish to remove using the arrow keys, then delete the line with: 
```
ctrl + k
```
To save and quit:
```
ctrl + o
  # "write Out" the file, saving the output
Enter
  # When prompted to provide the file name to be written, we hit Enter to keep the same name.
ctrl + x
  # Exit nano
```

## Step 3
### Create the Script
Navigate to the `Scripts` directory and create your own subdirectory using the `mkdir` (make directory) command:
```
cd /sc/arion/projects/NGSCRC/Scripts/Umbrella_Academy

mkdir Kelsey
```
We need our sample list to be in the same folder as our script, but it's currently still in the `master_data` folder where it was made. We will use `mv` to move your sample list to the directory you just created. 

Because we have navigated to our `Scripts` directory, we need to append the file path to the location of our sample list in order to locate it.
The command will look like `${path to sample list}/FastP_practice_samplelist_${MY_NAME}.txt ${MY_NAME}`:
```
mv /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/FastP_practice_samplelist_Kelsey.txt Kelsey
```
>💡**Tip:** The basic syntax for most UNIX commands is essentially:
> - "what are you doing?" (*action*)
> - "what are you doing it to?" (*input*)
> - "what is the desired result?" (*output*)
>  
> Applying this here:
> - "what are you doing?" *moving a file*
> - "what are you doing it to?" *the sample list*
> - "what is the desired result?" *file is moved to my directory*

Now, make a copy of the `FastP_practice_annotated.sh` script using `cp`. 

*If you are following along on GitHub, follow [this link](FastP_practice_annotated.sh) to access the script.*

In one step, you can also append your name to the end of the file and move it into the subdirectory that you just created. The command will look like `cp FastP_practice_annotated.sh ${MY_NAME}/FastP_practice_${MY_NAME}.sh`:
```
cp FastP_practice_annotated.sh Kelsey/FastP_practice_Kelsey.sh
```
Do you see the UNIX syntax in action here?

## Step 4
### Modify the Script
Now you have your own sample list and your own shell script that you can modify to run fastp yourself! 

Navigate to your folder and open the script for editing using `nano` to revise it according to the instructions contained in the file:
```
cd Kelsey
nano FastP_practice_Kelsey.sh
```
When the file is ready to be executed, run the following LSF command to submit an array job. 
```

```
