# Genetic data and databases

By the end of this session, students will be able to:
1.	Access NCBI like database and explore the general features of such databases
2.	Know how to search and download nucleotide/protein sequence data and other sequence associated information from NCBI database
3.	How to use sequence similarity search tools like BLAST in online and standalone mode
4.	How to use these learnings in solving a real-life problem

## Introduction
Imagine you are a researcher investigating seafood fraud at sushi restaurants. Many sushi restaurants substitute cheaper, overfished, or endangered species for more desirable ones, misleading consumers. These fish are often sold under incorrect names, and some belong to species listed on the IUCN Red List of Threatened Species. This mislabeling deceives customers and complicates efforts to manage marine populations effectively. Accurate species identification is essential for proper conservation and fishery management, as mislabeling undermines stock assessments and can lead to the continued overexploitation of vulnerable species.

How can we detect fraudulent practices? What are the ways to solve it? Let’s discuss.

We will explore an alternative approach to addressing this issue by applying genetics and bioinformatics. Specifically, we will use nucleotide sequences, sequence search tools, and databases to investigate cases of seafood fraud. Our goal is to learn how to retrieve genetic information from databases, analyze it using bioinformatics tools, and interpret the results to verify species identity. We will focus on the National Center for Biotechnology Information (NCBI) database, one of the most widely used resources for genetic data.

## Part I: Exploring Genetic database

### Step1. Navigating NCBI website

First go to the website: https://www.ncbi.nlm.nih.gov. Look at the home page. Home page has much information, very comprehensive and self-explanatory: various databases, browsing windows, sequence (nucleotide, protein etc) submitting and downloading different databases etc…), different applications, literature information. We will spend some to explore the structure of NCBI database.

### Step2.  Retrieving sequence data and associated information from NCBI
The NCBI is very user-friendly database and genetic data search platform. All the basic operations are meant for traditional biologists, who are not very savvy with advanced computation skills or search skills. So, anyone with minimum biology knowledge can go in there and retrieve information. The only condition is that as a user you need to know what you want, which is dependent on the question. We will download few sequences from NCBI for demonstration purpose. Just download COI (cytochrome c oxidase subunit I) sequences related to family Scombridae (mainly contains mackerel related group). This is an important step in series of steps to solve the problem. 

>COI from mitochondria is used as a genetic marker to barcode the species. Barcode is the same thing you see on a packet or box in the shop. More detail about the barcode projects here: https://phe.rockefeller.edu/barcode/index.php.
>Once you do the barcoding of a species that remains with that species forever and becomes part of the database.
![Alt Text](https://raw.githubusercontent.com/shri1984/study-images/refs/heads/main/testedna.jpg?token=GHSAT0AAAAAAC5BYHQBF2XNJYV4XJWKR4LIZ7VI4YQ)

As we are working with large number of possible fish species in this question (sushi), we may need to download lot of sequences (close to 500 GB nucleotide data). I downloaded that data for you (see below ). However we still explore how to search and download data. 
On top of the web page there is a search bar to search information about the species of your interest. If you select 'all databases' in the search menu and type the scientific name (common name do work sometimes), if you are interested in a single species. But to address the question like above, you may need to write 'name of your species COI'. You will be directed to a page where the information about your species of interest is available from all possible databases (including peer reviewed literatures). This is one way to find desired information for your species. Choose nucleotide and it will take you to nucleotide database. Go through the result table and choose few sequences belong to different species from Scombridae family. Download clicking right corner send to: > complete record > file > fasta > download. Now sequences are downloaded in the fasta format to your local system (your laptop). Generally, it downloads to folder Downloads (depending on your browser setting). Open downloaded file using a text editor. Open the downloaded file using a text editor (e.g., Notepad++ for Windows, Sublime text for macOS). As I said earlier, you can search anything in NCBI. try gene names: example p53. 
The previous exercise it is important to develop a sequence database to store the sequences of different species and organisms (as nt, nucleotide database). You download the sequences and build a database. However, downloading individual sequences is tedious and requires good internet speed, and required permission to access to NCBI. Alternatively, we will download data from ftp server and build database in our own way instead of following standard way like above. You made this database only if you want work with NCBI in offline mode (in your local or VMs). This time I have made that job for you. 

> As I said earlier, I downloaded required sequence which act as database are downloaded from NCBI. This is how you access FTP storage server: https://ftp.ncbi.nlm.nih.gov/blast/db/. Database is ready to use. 

## Part II: Identifying sequences
Now we will try to find out whether sushi restaurants used the species they are claiming. 
We will use BLAST (Basic Local Alignment Search Tool) 'a find and match' (google for sequence data) application from NCBI to compare DNA sequences against known sequences to find matches from databases. BLAST in NCBI is like using Google’s image search, but instead of pictures, you input a DNA or protein sequence. In this course we will use both online and offline (standalone) version of this tool. 

### Using online version of BLAST 
First locate the tab in NCBI webpage where the blast application is shown. Please explore various blast modules which takes different inputs sequences (nucleotide or protein) and search them against different type of databases (nucleotide or protein sequences).  
This is how whole thing works:  Just feed a “unknown” nucleotide or protein sequence to the blast search box and do blast’ing (important: choose right blast module, based on search molecule type and your expectation). It finds the similarities between sequences you provided (which is 'query'), and sequences stored in the database (which is 'subject'). Blast also calculates the statistical significance of that comparison (E-value, which is like p-value, tells how random the query matches with the subject, lesser the E-value, more confidence in the hit is). 

You may just wonder how did you get sequences in these kind of experiments. For that you need to do some lab work. Remember your lab work for genetics (genetics class). 

![Alt Text](https://raw.githubusercontent.com/shri1984/study-images/refs/heads/main/foods-12-02420-ag.webp?token=GHSAT0AAAAAAC5BYHQAFTMJDKWRN472RTWWZ7VP2MA)

> ## Tips to blast sequences
> 1. Choose right blast module based on the type of sequence input type and importantly, your objective
> 2. Try to set the parameters if needed. Generally, default settings work better in most of the situations. So, leave them alone if you don’t have any compelling reason to change them or know what you are doing. 

Now let’s say we got our sequences back for different sushi samples and now it is time to find out what they are made of. Is declared species name matched with the identified species name? 

Let’s find out in online BLAST. 

One disadvantage of using online BLAST is the potential waiting time. The longer and more numerous your input sequences, and the larger the database you are searching against, the longer the search operation may take. Additionally, during peak usage times, the NCBI servers may experience higher traffic, leading to further delays. The time required for a BLAST search generally increases with the size of the input sequences, the number of sequences, and the size of the database. It is also influenced by the specific BLAST program and parameters used. If you need to process many sequences efficiently, a practical solution is to use local BLAST. Installing BLAST locally allows you to bypass server queues, tailor the search parameters to your specific needs, and generate customized output formats. This makes local BLAST especially useful for large-scale or repetitive analyses.

### Using standalone version of BLAST
Standalone blast works same way as online version. It needs 3 things, NCBI module, sequence to be identified and database to search against and laptop or server or VMs. 

This time around you no need to install the NCBI module and generate database in linux virtual machine. I have done installation part for you. 
> ### EXTRA: Here is tip to install BLAST modules in a Linux based machine. 

>## install NCBI BLAST+ ##
> sudo apt-get ncbi-blast+ or conda install # It will download the precompiled latest version of blast+ tools to your system. 
> Or go to page : https://www.ncbi.nlm.nih.gov/books/NBK52640/ and download BLAST+
> ## prepare database ##
> Our database is nucleotide sequences associated with group ‘teleost’.  If you need full nucleotide database (arouns 200 GB) go here: Our database is nucleotide sequences associated with group ‘teleost’.  If you need full nucleotide database (around 200 GB) go here:
or 
>download nucleotide or protein (nr) database in fasta format to your system and build database locally using this command:  “makeblastdb” to make your own database in future.

Connect to the VMs. We are ready to explore the standalone BLAST.
We will run blast analysis in background of VMs, so that you can use terminal for some other tasks, while you are waiting to finish. We use a inbuilt application called ‘screen’. 
To check if BLAST is installed by running: blastn -h
If it is good, then you should see help message with parameters (arguments to change the behaviour of a command). 
We will write the blastn script together (NB! there are spaces between the different parameters) as below:

```
blastn -query name_of_the_query_file -db  path_to_database  -max_target_seqs 1 -outfmt 6 -out results2.txt -num_threads 1 -evalue 0.000001 -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore" 
```
Generally, it will take 5-10 minutes to finish. 

> EXTRA Default column names (-outfmt 6) (look into online help or terminal help)

> -outfmt "6 qseqid qlen qaccver sseqid slen saccver sacc stitle salltitles length pident nident mismatch gapopen qstart qend sstart send evalue bitscore qcovs qcovhsp"

>BLASTn tabular output format 6

> Column headers:
qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore
> 1. qseqid query or source (e.g., gene) sequence id
> 2. sseqid subject or target (e.g., reference genome) sequence id
> 3. pident percentage of identical matches
> 4. length alignment length (sequence overlap)
> 5. mismatch number of mismatches
> 6. gapopen number of gap openings
> 7. qstart start of alignment in query
> 8. qend end of alignment in query
> 9. sstart start of alignment in subject
> 10. send end of alignment in subject
> 11. evalue expect value
> 12. bitscore bit score

Now you run the command and wait for it finish. Mean time you prepare a table in MS excel (metadata) with what species you found in online blast version. 

Now we have output and let’s interpret the table output of BLAST. 

Add species names identified through standalone blast to the excel sheet. Compare it with the declared species name. How many (or in percentage) of the species match with the declared species name? At the same please visit: https://www.iucnredlist.org to find out the conservation status of the species you identified. Add that information to the table. Now we have all the necessary information to make a meaningful conclusion about the problem and possible solutions. 

Part III: Discussion 
 Questions to discuss: 
- How confident are you in your species identification based on the BLAST results? What factors determine the quality of identification?
- What challenges did you face in retrieving or analysing data? 
- How can these tools be used in research, conservation, and industry? Where else do you think this technique be used?
