# Hands-on "Getting Started with The Command Line" Exercise

## Step 1
Navigate to the `master_data` folder on Minerva containing the raw .fastq files we will use in the exercise:
```
cd /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy
```
These .fastqs are truncated test data adapted from https://github.com/nf-core/test-datasets/tree/rnaseq  
Samples are S. cerevisiae 101bp paired-end strand-specific RNA-seq, sub-sampled to 50000 reads

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
Create a sample list to be used in the array job script

To do this, we will run the command `printf '%s\n' "$PWD"/* >FastP_practice_samplelist_${MY_NAME}.txt`, replacing `${MY_NAME}` with your name.  

So mine will look like: 
```
printf '%s\n' "$PWD"/* >FastP_practice_samplelist_Kelsey.txt
```
For simplicity, for the rest of the exercise, I will just refer to this file as `"samplelist.txt"`

### Explanation of the command:
- `printf '%s\n':`
        This is the `printf` command, which is used to format and print text. The format string `'%s\n'` specifies that it should print a string (`%s`) followed by a newline (`\n`).    
- `"$PWD"/*:`
        This is the path to the current working directory (`$PWD`) followed by a slash (`/`) and an asterisk (`*`). The asterisk is a wildcard character that matches any file or directory within the current directory. Because we navigated to the `/sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy` folder, this is the working directory that will be printed, followed by the contents of the directory, which are the subfolders for each sample.
- `>samplelist.txt:`
        The `>` is the "output redirection operator" which sends the output of a command to a file instead of printing it in the terminal. You decide the name and file extension of the file; here we chose to create a text file named "samplelist.txt." **❗Important Note❗** If the file does not exist, defining the name and the file extension in the command will create a new file. But if the file already exists, **this will overwrite the contents of an existing file**. Be careful when using `>`.  
            
    **So, putting it all together, this command will:**
    
    - **Expand the wildcard:**
        The `*` wildcard will be expanded to match all files and directories in the current working directory.
        
    - **Print the paths:**
        For each file or directory matched, the `printf` command will print its full path, followed by a newline.
      
    - **Save to a text file:**
        Instead of displaying the output of the command in the terminal, `>` will redirect the output to a new file, `"samplelist.txt"`.

### The sample list should look like this:

|  | 
|---------------|
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/README.txt |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357070 |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357071 |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357072 |
| /sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy/SRR6357073 |

You will note that the first line contains a README.txt file. This is a file in the `/sc/arion/projects/NGSCRC/master_data/test/Umbrella_Academy` folder that includes the same sample information as in Step 1 above. It is good practice to have README files in your master data folders so you and future lab members know what the files are. But leaving this row in our file will generate an error if we try to run an array job using this sample list.  

There are many ways to modify the file to remove the line; this is one way to do it quickly using the Command Line:
```
## Enter the below commands in your terminal (don't copy this code block)

nano samplelist.txt
  # Nano is one of many Linux text editors. This will open the file interactively.
  # Note that this is a great time to try out "Tab to complete":
    # Since your file will be named something like "FastP_practice_samplelist_Kelsey.txt" start typing "nano Fa" and then hit Tab.
    # It should auto-complete the file name until "FastP_practice_samplelist_"
    # Then enter the first letter of your name and hit Tab again, entering letters and hitting Tab until you have completed your file's name. 

## Once the file is open, navigate to the line we wish to remove using the arrow keys, then delete the line with
ctrl + k

## To save and quit:
ctrl + o
Enter
ctrl + x
  # This is the command to "Write Out" the file, saving the output.
  # We don't want to change the file name, so when prompted to provide the file name to be written, we hit Enter to keep the same name.
  # Then exit Nano using ctrl + x

```
