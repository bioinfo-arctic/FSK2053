
## Introduction to bioinformatics
#### For this class, you need to have finished the tutorial presented in the [Lecture 7 - Bioinformatics and biological data.](https://uit.instructure.com/courses/28991/modules/items/809233)
#### Don't forget to turn on your  [virtual machine](https://labs.azure.com/register/detno9f2n)

---
### Learning about "The path" in Linux

![attention to the path](https://shilrani.files.wordpress.com/2012/05/crazylittlething-tumblr-com.gif)

#### Once you are logged in, here we introduce the ways to use paths in Linux. A path for a file or a directory (folder) is its address in the computer memory.
To visualize the path to your current directory use the `pwd` command (print working directory).

```
pwd 
```
#### Try the following commands to explore your directories.
To see what is inside your current directory, type the commands below:
```
ls
ls -l
ls -la
ls -lah
```
`ls` by itself lists all the files and directories in your current `wd`. If you give parameters to it, you can see further details about the content of your current directory.
You could also pass a path/address to the `ls` command.
```
ls /home/
```
This command will show what is inside the /home/ directory. You could also use the previous parameters to further inspect the /home/ directory.

```
ls /home/adminfsk2053/
ls -l /home/adminfsk2053/
ls -la /home/adminfsk2053/
ls -lah /home/adminfsk2053/
```
Notice that for accessing files outside your current working directory, you need to pass the **full path** or a **relative path** of the file you want to access. If the file you want to access, is in the same directory you are, you can just call the file name, right after the command.

---
### Generating sequence basic statistics
Make sure you are in your home directory. You can check it with the `pwd` command.
If you are not you can run the following:
```
cd ~
```
Lets count how many sequences we have:
Count the lines:
```
wc -l ./data/R1.fastq
wc -l ./data/R2.fastq
wc -l ./data/A4_A006_R1_FSK2053.fastq
wc -l ./data/A4_A006_R2_FSK2053.fastq
```
Look at the files:
```
less ./data/A4_A006_R1_FSK2053.fastq
less ./data/A4_A006_R2_FSK2053.fastq
```
How many sequences you have?
We know that a fastq file should have 4 lines per sequence. And a fasta file should have 2 lines per sequence. 
Lets create a fasta file from our fastq files and ignore the quality information for now:
```
mkdir fasta_files
bioawk -c '{print ">" $name "\n" $seq}' ./data/A4_A006_R1_FSK2053.fastq
bioawk -c '{print ">" $name "\n" $seq}' ./data/A4_A006_R2_FSK2053.fastq
```
In order to create a new file, we need to forward the output of the commands into a new file:
```
bioawk -c '{print ">" $name "\n" $seq}' ./data/A4_A006_R1_FSK2053.fastq > ./fasta_files/A4_R1.fasta
bioawk -c '{print ">" $name "\n" $seq}' ./data/A4_A006_R2_FSK2053.fastq > ./fasta_files/A4_R1.fasta
```
Now count the number of sequences in the fasta files
```
wc -l fasta_files/A4_R1.fasta
wc -l fasta_files/A4_R2.fasta
```
If you want a more direct count, you can use the bioawk operators:
```
bioawk -c fastx END'{print NR}' fasta_files/A4_R1.fasta 
bioawk -c fastx END'{print NR}' fasta_files/A4_R2.fasta
```

or you could still use the `wc` command:
```
bioawk -c fastx '{print $seq}' fasta_files/A4_R1.fasta
bioawk -c fastx '{print $seq}' fasta_files/A4_R1.fasta | wc -l
```
Using `bioawk`, we are able to export only the sequences of our fasta files. Using this information we can calculate nucleotide frequencies for these fragments. The homogeneity of nucleotide frequencies among taxa, which refers to the equality of the nucleotide frequency bias among species is a major assumption of many molecular phylogenetic methods. Moreover, it is an important metric in [bioinformatics](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1766-x). So lets create a counter to know how many nucleotides of each type we find in each sequence.

---
### Creating our first Linux tool/script
In the first step, we need to isolate the sequences using the `bioawk` command:
```
mkdir nucl_freq_counter
bioawk -c fastx '{print $seq}' fasta_files/A4_R1.fasta > nucl_freq_counter/sequences_R1.txt
```
Lets look inside this new file and see if our command did what we expected and lets see if we have all the sequences.
```
less nucl_freq_counter/sequences_R1.txt
wc -l nucl_freq_counter/sequences_R1.txt
```
Press "q" to exit the `less` command.
Now we need to create a way to apply the nucleotide counting in each of the sequences.
We can do that using a "*for loop*". 
> **A bash for loop is a bash programming language statement which allows code to be repeatedly executed**. A for loop is classified as an iteration statement i.e. it is the repetition of a process within a bash script. For example, you can run UNIX command or task 5 times or read and process list of files using a for loop.
> There are multiple types of loops in bash. To learn more about them, check out this great tutorial:
https://ryanstutorials.net/bash-scripting-tutorial/bash-loops.php

Here is the structure of the `for loop`:
```
for i in {1..10} ; do echo $i ; done
```
Now lets use this structure in combination with `head` and `tail` commands to choose each sequence.
`head` by default, shows the first 10 lines of a file. If we pass the parameter *-n*, we can control how many lines it will print. `tail` shows us the last 10 lines of a file and has the same *-n*  parameter. Lets try:

```
head /data/fasta_files/A4_R1.fasta
tail /data/fasta_files/A4_R1.fasta
head -n 3 /data/fasta_files/A4_R1.fasta
tail -n 3 /data/fasta_files/A4_R1.fasta
```

Now, if we combine the behavior of a `for loop` and the output of `head` and `tail` combined by a linux pipe "|", we can access line by line of our sequences: 

Let's create the command step by step:
First printing line by line:
```
for i in {1..40} ; do echo seq $1; head -n $i nucl_freq_counter/sequences_R1.txt | tail -n 1 ; done
```
Now, we need a counter, let's try the `wc -m` combined with the `head -n 1`. See what `wc -m` does using the`wc --help` parameter.

```
head -n 1 nucl_freq_counter/sequences_R1.txt | wc -m
```
Now, we need to individualize the nucleotides. Linux has a command called `tr` that is used to convert/translate characters. It has parameters like *-d* and *-c* that allow us to count each of the bases individually, in combination with `wc -m`. Check the `tr --help` for learning more about this tool.
```
head -n 1 nucl_freq_counter/sequences_R1.txt | tr -cd "A"| wc -m 
```
Now, we need to `loop` through all of the sequences and through each of the 4 nucleotides and store this information in a table format.
```
for i in {1..40} ; do head -n $i nucl_freq_counter/sequences_R1.txt | tail -n 1 | tr -cd "A"| wc -m ; done > nucl_freq_counter/A_freq_R1.txt
for i in {1..40} ; do head -n $i nucl_freq_counter/sequences_R1.txt | tail -n 1 | tr -cd "C"| wc -m ; done > nucl_freq_counter/C_freq_R1.txt
for i in {1..40} ; do head -n $i nucl_freq_counter/sequences_R1.txt | tail -n 1 | tr -cd "T"| wc -m ; done > nucl_freq_counter/T_freq_R1.txt
for i in {1..40} ; do head -n $i nucl_freq_counter/sequences_R1.txt | tail -n 1 | tr -cd "G"| wc -m ; done > nucl_freq_counter/G_freq_R1.txt
```

Now we have individual nucleotide occurrence files. We can combine them in excel or any text editor. But of course we will do it using Linux.
There is a command called `paste` in linux that works by adding text side by side, using a **tab** as the default separator.

```
paste nucl_freq_counter/A_freq_R1.txt nucl_freq_counter/C_freq_R1.txt nucl_freq_counter/T_freq_R1.txt nucl_freq_counter/G_freq_R1.txt > R1_table.txt
```
But we don't have a header still. We can add a header using `echo -e`.
```
echo -e "A_counts\tC_counts\tT_counts\tG_counts" > header.txt
``` 

We can inspect the **header.txt** file and concatenate it to the countes files using the `cat` command:

```
cat header.txt R1_table.txt > final_R1_table.txt
```

Now we have a nice table to help us compare the sequences using a alignment free algorithm. Shall we create a script that does all the steps in a workflow and apply it to the R2 file?

Lets build it in a text editor in our own computers and transfer it to the server. Remember to use the `history` command and the *up* arrow key.
