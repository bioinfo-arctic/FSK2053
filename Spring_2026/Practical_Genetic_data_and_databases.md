# Genetic data and databases

By the end of this session, students will be able to:
1.	Navigate and explore the NCBI database to understand its structure and access information
2.	Search for and download nucleotide and protein sequence data (e.g., COI sequences) and related metadata from NCBI
3.	Use BLAST tools (online and standalone) to perform sequence similarity searches and interpret the results
4.	Apply sequence analysis techniques to investigate real-life cases, such as identifying mislabeled seafood using DNA data

#### Files needed
"sushisamples.fasta" and "sushisamples_metadata.xls" are the files we will be using and they are uploaded to Canvas.

## Introduction
Imagine you are a researcher investigating seafood fraud at sushi restaurants. Many sushi restaurants substitute cheaper, overfished, or endangered species for more desirable ones, thereby misleading consumers. These fish are often sold under incorrect names, and some belong to species listed on the IUCN Red List of Threatened Species. This mislabeling deceives customers and complicates efforts to manage marine populations effectively. Accurate species identification is essential for proper conservation and fishery management, as mislabeling undermines stock assessments and can lead to the continued overexploitation of vulnerable species.

How can we detect such fraudulent practices? What are the ways to solve it? Let’s discuss.

We will explore an alternative approach to addressing this issue by applying genetics and bioinformatics. Specifically, we will use nucleotide sequences, sequence search tools, and databases to investigate cases of seafood fraud. Our goal is to learn how to retrieve genetic information from databases, analyze it using bioinformatics tools, and interpret the results to verify species identities. We will focus on the National Center for Biotechnology Information (NCBI) database, one of the most widely used resources for genetic data.

## Part I: Exploring genetic databases

### Step 1. Navigating NCBI website

We already spent some time navigating this website during the lecture, but if you did not attend the lecture, I'd suggest you play around for half an hour at home. First go to the website: https://www.ncbi.nlm.nih.gov. Look at the home page. Hopefully you also find it to be very comprehensive and at least somewhat self-explanatory: Various databases, browsing windows, sequence (nucleotide, protein etc) submitting and downloading different databases, different applications, literature information.

### Step 2. Retrieving sequence data and associated information from NCBI
The NCBI is a very user-friendly database and search platform for genetic data. All the basic operations are meant for traditional biologists, who are not very savvy with advanced computation skills or search skills. So, anyone with minimum biology knowledge can go in there and retrieve information. The only condition is that as a user you need to know what you want, which is dependent on the question. We will download a few sequences from NCBI for demonstration purpose. We download COI (cytochrome c oxidase subunit I) sequences related to the family Scombridae (mainly contains mackerels related group). This is an important step in series of steps to solve the problem.

>Mitochondrial COI sequences (around 658 bp) are used as a genetic marker for "DNA barcoding" of animals. A barcode is the same concept as you see on a carton of milk in the shop, when paying at the counter. The concept of animal barcoding all began with [this paper](https://royalsocietypublishing.org/rspb/article/270/1512/313/71759/Biological-identifications-through-DNA-barcodes).
>Once a specimen has been barcoded and the sequence deposited in a database, we can always refer back to that particular individual's DNA. It therefore serves as a "reference".
>
![Alt Text](https://raw.githubusercontent.com/shri1984/study-images/main/DNA_Barcoding.png)

As we are working with a large number of possible fish species (meaning that the database is big) for this exercise, we may need to download lot of sequences (close to 500 GB nucleotide data). We've already downloaded a relevant database for you, which you will have access to on your virtual machines. However, we will still explore how to search and download data. 

On top of the web page there is a search bar to search information about the species of your interest. Select 'all databases' in the search menu and type a scientific name followed by "COI" (we will use "Scombridae" here). You will be directed to a page where the information about your taxon of interest is available from all possible databases (including peer reviewed literature). This is one way to find the desired information for your species. Now choose "nucleotide" and it will take you to nucleotide database. Add a filter for "Sequence length" - set it to 650-660 to limit the hits to our desired fragment length. Go through the result table and select a few sequences belonging to different species from this family. Download these by clicking "send to" in the right corner. Choose "complete record", "file", "fasta" and click create file. Now the sequences will be downloaded in fasta format to your local system. Open the downloaded file using a text editor. I suggest Notepad++ for Windows and Sublime text for macOS.

We need to include relevant sequences when making a reference database. However, downloading individual sequences in this manner is tedious. Instead, we have downloaded the data from NCBI's ftp server and built a database for you. A big advantage is that we can work with this database locally and on our virtual machines, so once we have it downloaded, we don't need to rely on NCBI's servers any more (which could experience downtime or slow request handling).

> We downloaded the necessary sequences from NCBI as a premade database. If you were to do so yourselves, this is where you would access their FTP storage server: https://ftp.ncbi.nlm.nih.gov/blast/db/. 

## Part II: Identifying sequences
Now we will try to find out whether sushi restaurants used the species they are claiming in their preparations. 
We will use BLAST (Basic Local Alignment Search Tool) 'a find and match' (google for sequence data) application from NCBI to compare DNA sequences against known sequences to find matches from databases. BLAST in NCBI is like using Google’s image search, but instead of pictures, you input a DNA or protein sequence. In this course we will use both online and offline (standalone) version of this tool. 

### Using online version of BLAST 
First locate the tab in NCBI webpage where the blast application is shown. Please explore various blast modules which takes different inputs sequences (nucleotide or protein) and search them against different type of databases (nucleotide or protein sequences).
This is how whole thing works: Just feed a “unknown” nucleotide or protein sequence to the blast search box and do blast’ing (important: choose right blast module, based on search molecule type and your expectation). It finds the similarities between sequences you provided (which is 'query'), and sequences stored in the database (which is 'subject'). Blast also calculates the statistical significance of that comparison (E-value, which is like p-value, tells how random the query matches with the subject, lesser the E-value, more confidence in the hit is, query coverage etc..). 

>You may just wonder how did you get sequences in these kind of experiments. For that you need to do some lab work. Remember your lab work for genetics (genetics class). 

![Alt Text](https://raw.githubusercontent.com/shri1984/study-images/refs/heads/main/foods-12-02420-ag.webp)

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

>### Install NCBI BLAST+ ##
> sudo apt-get ncbi-blast+ or conda install # It will download the precompiled latest version of blast+ tools to your system. 
> Or go to page : https://www.ncbi.nlm.nih.gov/books/NBK52640/ and download BLAST+
>
> ### Prepare database ##
> Our database is nucleotide sequences associated with group ‘teleost’. If you need full nucleotide database (arouns 200 GB) go here: Our database is nucleotide sequences associated with group ‘teleost’. If you need full nucleotide database (around 200 GB) go here:
or 
>download nucleotide or protein (nr) database in fasta format to your system and build database locally using this command: “makeblastdb” to make your own database in future.

Connect to the VMs. We are ready to explore the standalone BLAST.
We will run blast analysis in background of VMs, so that you can use terminal for some other tasks, while you are waiting to finish. We use a inbuilt application called ‘screen’. 

To check if BLAST is installed by running: blastn -h

If it is good, then you should see help message with parameters (arguments to change the behaviour of a command). 

We will write the blastn script together (NB! there are spaces between the different parameters) as below:

```
blastn -query name_of_the_query_file -db path_to_database -max_target_seqs 5 -out results2.txt -num_threads 1 -evalue 0.000001 -outfmt 6
```
Generally, it will take 5-10 minutes to finish. 

> EXTRA: Default column names (-outfmt 6) (look into online help or terminal help)

> try this: -outfmt "6 qseqid qlen qaccver sseqid slen saccver sacc stitle salltitles length pident nident mismatch gapopen qstart qend sstart send evalue bitscore qcovs"

>blastn tabular output format 6

> Column headers (default):
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

Now you run the command and wait for it to finish. In the mean time look into a table in MS excel (sushisamples_metadata.xls) with what species you found in online blast version. 

Now we have output and let’s interpret the table output of BLAST. 

Add species names identified through standalone blast to the excel sheet. Compare it with the declared species name. How many (or in percentage) of the species match with the declared species name? At the same please visit: https://www.iucnredlist.org to find out the conservation status of the species you identified. Add that information to the table. 

Now we have all the necessary information to make a meaningful conclusion about the problem and possible solutions. 

## Part III: Discussion 
- Did any of your samples come from endangered or overfished species? How did that affect your interpretation of the restaurant’s claims?
- What factors make you confident in your species identification based on BLAST results?
- What are some real-world applications of these tools beyond seafood fraud?
- What are some shortcomings of BLAST or barcoding techniques?
- How could these tools be integrated into food regulation or restaurant inspections?
