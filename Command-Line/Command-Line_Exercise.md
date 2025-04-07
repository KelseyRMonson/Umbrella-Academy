# Hands-on "Getting Started with The Command Line" Exercise

This is an exercise to get people familiar with common bioinformatics command line activities on a High Performance Computing (HPC) cluster.

These include
- navigating the command line
- creating and editing simple scripts
- executing array jobs (using the LSF job scheduler) on Minerva, Mount Sinai's HPC. 

We will run [fastp](https://github.com/OpenGene/fastp), a "tool designed to provide ultrafast all-in-one preprocessing and quality control for FastQ data," on four .fastq files.

**fastp citation**
>Shifu Chen. 2023. Ultrafast one-pass FASTQ data preprocessing, quality control, and deduplication using fastp. iMeta 2: e107. [DOI](https://doi.org/10.1002/imt2.107)

## Step 1
Navigate to the `master_data` folder on Minerva containing the raw .fastq files we will use in the exercise:
```
cd /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy
```
*If you are following along on GitHub, these files can be found in the `master_data` folder within this directory.*

These .fastqs are truncated test data adapted from the [NF-core test data repository](https://github.com/nf-core/test-datasets/tree/rnaseq).  
Samples are S. cerevisiae 101bp paired-end strand-specific RNA-seq, sub-sampled to 50000 reads.

<details>
<summary> Sample details </summary>  
  
### Sample info:
  
| run_accession | experiment_alias | read_count | sample_title |
|---------------|------------------|------------|--------------|
| SRR6357070 | GSM2879618 | 47629288 | Wild-type total RNA-Seq biological replicate 1 |
| SRR6357071 | GSM2879619 | 68628914 | Wild-type total RNA-Seq biological replicate 2 |
| SRR6357072 | GSM2879620 | 54771596 | Wild-type total RNA-Seq biological replicate 3 |
| SRR6357073 | GSM2879621 | 56006930 | Rap1-AID degron no induction total RNA-Seq biological replicate 1 |

### Sample citation:
>Andrew C K Wu, Harshil Patel, Minghao Chia, Fabien Moretto, David Frith, Ambrosius P Snijders, Folkert J van Werven. Repression of Divergent Noncoding Transcription by a Sequence-Specific Transcription Factor. Mol Cell. 2018 Dec 20;72(6):942-954.e7. doi: 10.1016/j.molcel.2018.10.018.
>[Pubmed](https://pubmed.ncbi.nlm.nih.gov/30576656/) [GEO](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE110004)
</details>

## Step 2
Create a sample list to be used in the array job script.

To do this, we will run the command `printf '%s\n' "$PWD"/* >FastP_practice_samplelist_${MY_NAME}.txt`, replacing `${MY_NAME}` with, you guessed it, your name. So mine will look like: 
```
printf '%s\n' "$PWD"/* >FastP_practice_samplelist_Kelsey.txt
```
For simplicity, for the rest of the exercise, I will just refer to this file as `"samplelist.txt"`

**Explanation of the command:**
- `printf '%s\n':`
        This is the `printf` command, which is used to format and print text. The format string `'%s\n'` specifies that it should print a string (`%s`) followed by a newline (`\n`).    
- `"$PWD"/*:`
        This is the path to the current working directory (`$PWD`) followed by an asterisk (`*`). The asterisk is a wildcard character that matches any file or directory within the current directory. Because we navigated to the `/sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy` folder, this is the working directory that will be printed, followed by the contents of the directory, which are the subfolders containing the .fastq files for each sample.
- `>samplelist.txt:`
        The `>` is the "output redirection operator" which sends the output of a command to a file instead of printing it in the terminal. You decide the name and file extension of the file; here we chose to create a text file named "samplelist.txt." ⚠️<ins>**Important**</ins>⚠️ If the file does not exist, defining the name and the file extension in the command will create a new file. **But this command will overwrite the contents of an existing file**. Be careful when using `>`.  
            
    **So, putting it all together, this command will:**
    
    - **Expand the wildcard:**
        The `*` wildcard will be expanded to match all files and directories in the current working directory.
        
    - **Print the paths:**
        For each file or directory matched, the `printf` command will print its full path, followed by a newline.
      
    - **Save to a text file:**
        Instead of displaying the output of the command in the terminal, `>` will redirect the output to a new file, `"samplelist.txt"`.

**The sample list should look like this:**

|  | 
|---------------|
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/README.txt |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357070 |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357071 |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357072 |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357073 |


<details>
  <summary>Remove the README file from the Sample List using nano</summary>

You will note that the first line contains a `README.txt` file. This is a file in the `/sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy` folder that includes sample information (the "Sample details" in Step 1).

It is good practice to have README files in your master data folders so you and current/future lab members know what the files are, where the data comes from, what species it is, the sequencing depth, etc. 

But leaving this row in our sample list will generate an error if we try to run an array job using this file (because the array job will look for subdirectories containing .fastq files, not text files in the main directory).  

There are many ways to modify the file to remove the line; this is one way to do it quickly using the Command Line.

Nano is one of many Linux text editors you can use to modify files on the Command Line. This will open the file interactively:
```
nano samplelist.txt
```
This is a great time to try out "Tab to complete"!
 - Since your file will be named something like `FastP_practice_samplelist_Kelsey.txt`, start typing `nano Fa` and then hit Tab.
 - It should auto-complete the file name until `FastP_practice_samplelist_`
 - Then enter the first letter of your name and hit Tab again, entering letters and hitting Tab until you have completed your file's name.  

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
</details>

## Step 3
Navigate to the `Scripts` directory and create your own subdirectory using the `mkdir` (make directory) command:
```
cd /sc/arion/projects/NGSCRC/Scripts/Umbrella_Academy

mkdir Kelsey
```
We will need our sample list file to be in the same folder as our script. Use `mv` to move your sample list to the directory you just created. 

Because we have navigated to our `Scripts` directory, we need to append the file path to the location of our sample list in order to locate it.
The command will look like `${path}/FastP_practice_samplelist_${MY_NAME}.txt ${MY_NAME}`:
```
mv /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/FastP_practice_samplelist_Kelsey.txt Kelsey
```
Now, make a copy of the `FastP_practice_annotated.sh` document using `cp`. 

*If you are following along on GitHub, follow [this link](FastP_practice_annotated.sh) to access the script.*

In one step, you can also append your name to the end of the file and move it into the subdirectory that you just created. The command will look like `cp FastP_practice_annotated.sh ${MY_NAME}/FastP_practice_${MY_NAME}.sh` (remember to replace `${MY_NAME}` with your name):
```
cp FastP_practice_annotated.sh Kelsey/FastP_practice_Kelsey.sh
```
## Step 4
Now you have your own sample list and your own shell script that you can modify to run fastp yourself. 

Navigate to your folder and open the script for editing using `nano`: 
```
cd Kelsey
nano FastP_practice_Kelsey.sh
```

and revise according to the instructions contained in the file. 

When the file is ready to be executed, run the following LSF command to submit an array job. 
```

```
