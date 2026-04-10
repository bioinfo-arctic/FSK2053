# Genetic data and databases

By the end of this session, students will be able to:
1.	Navigate and explore the NCBI database to understand its structure and access information
2.	Search for and download nucleotide and protein sequence data (e.g., COI sequences) and related metadata from NCBI
3.	Use BLAST tools (online and standalone) to perform sequence similarity searches and interpret the results
4.	Apply sequence analysis techniques to investigate real-life cases, such as identifying mislabeled seafood using DNA data

#### Files needed
"sushisamples.fasta" and "sushisamples_metadata.xls" are the files we will be using and they are uploaded to Canvas.

## Introduction
Imagine you are a researcher investigating seafood fraud in sushi restaurants. Many sushi restaurants substitute cheaper, overfished, or endangered species for more desirable ones, thereby misleading consumers. These fish are often sold under incorrect names, and some belong to species listed on the IUCN Red List of Threatened Species. This mislabeling deceives customers and complicates efforts to manage marine populations effectively. Accurate species identification is essential for proper conservation and fishery management, as mislabeling undermines stock assessments and can lead to the continued overexploitation of vulnerable species.

How can we detect such fraudulent practices? What are the ways to solve it? Let’s discuss.

We will explore an alternative approach to addressing this issue by applying genetics and bioinformatics. Specifically, we will use nucleotide sequences, sequence search tools, and databases to investigate cases of seafood fraud. Our goal is to learn how to retrieve genetic information from databases, analyze it using bioinformatics tools, and interpret the results to verify species identities. We will focus on the National Center for Biotechnology Information (NCBI) database, one of the most widely used resources for genetic data.

## Part I: Exploring genetic databases

### Step 1. Navigating NCBI website

We already spent some time navigating this website during the lecture, but if you did not attend the lecture, I'd suggest you play around for half an hour at home. First go to the website: https://www.ncbi.nlm.nih.gov. Look at the home page. Hopefully you also find it to be very comprehensive and at least somewhat self-explanatory: It includes various databases, browsing windows, tools for submitting and downloading sequences (nucleotide, protein, etc.), different applications, and access to literature information.

### Step 2. Retrieving sequence data and associated information from NCBI
The NCBI is a very user-friendly database and search platform for genetic data. All the basic operations are meant for traditional biologists, who are not very savvy with advanced computation skills or search skills. So, anyone with minimum biology knowledge can go in there and retrieve information. The only condition is that as a user you need to know what you want, which is dependent on the question. We will download a few sequences from NCBI for demonstration purposes. We download COI (cytochrome c oxidase subunit I) sequences related to the family Scombridae (mackerel, tuna and bonito family). This is an important step in the series of steps to address the problem.

>Mitochondrial COI sequences (around 658 bp) are used as a genetic marker for "DNA barcoding" of animals. A barcode is the same concept as you see on a carton of milk in the shop, when paying at the counter. The concept of animal barcoding all began with [this paper](https://royalsocietypublishing.org/rspb/article/270/1512/313/71759/Biological-identifications-through-DNA-barcodes).
>Once a specimen has been barcoded and the sequence deposited in a database, we can always refer back to that particular individual's DNA. It therefore serves as a "reference".
>
![Alt Text](https://raw.githubusercontent.com/shri1984/study-images/main/DNA_Barcoding.png)

As we are working with a large number of possible fish species (meaning that the database is big) for this exercise, we may need to download a lot of sequences (close to 500 GB nucleotide data). We've already downloaded a relevant database for you, which you will have access to on your virtual machines. However, we will still explore how to search and download data. 

On top of the web page there is a search bar to search information about the species of your interest. Select 'all databases' in the search menu and type a scientific name followed by "COI" (we will use "Scombridae" here). You will be directed to a page where the information about your taxon of interest is available from all possible databases (including peer reviewed literature). This is one way to find the desired information for your species. Now choose "nucleotide" and it will take you to nucleotide database. Add a filter for "Sequence length" — set it to 650-660 to limit the hits to our desired fragment length. Go through the result table and select a few sequences belonging to different species from this family. Download these by clicking "send to" in the right corner. Choose "complete record", "file", "fasta" and click create file. Now the sequences will be downloaded in fasta format to your local system. Open the downloaded file using a text editor. I suggest Notepad++ for Windows and Sublime text for macOS.

We need to include relevant sequences when making a reference database. However, downloading individual sequences in this manner is tedious. Instead, we have downloaded the data from NCBI's ftp server and built a database for you. A big advantage is that we can work with this database locally and on our virtual machines, so once we have it downloaded, we don't need to rely on NCBI's servers anymore (which could experience downtime or slow request handling).

> We have already downloaded the necessary sequences from NCBI as a pre-made database. If you were to do so yourselves, this is where you would access their FTP storage server: https://ftp.ncbi.nlm.nih.gov/blast/db/. 

## Part II: Identifying sequences
Next up, we will try to investigate whether sushi restaurants actually used the species they claim to use for preparing the sushi. We will use BLAST to compare DNA sequences obtained from sushi products against known sequences from the database. We will use both online and offline (standalone) BLAST to get you better acquainted with these tools.

### Using online version of BLAST 
First, locate the tab on the NCBI webpage where the BLAST application is displayed. Take some time to explore the various BLAST modules, each of which accepts different types of input sequences (nucleotide or protein) and searches them against different types of databases (nucleotide or protein sequences).

Here’s how the process works: Simply input an "unknown" nucleotide or protein sequence into the BLAST search box and run the BLAST analysis. (Important: Make sure to select the appropriate BLAST module based on the type of molecule you are searching with and your specific expectations.) BLAST identifies similarities between the sequence you provide (referred to as the "query") and the sequences stored in the database (referred to as the "subject"). Additionally, BLAST calculates the statistical significance of the comparison, such as the E-value. The E-value, similar to a p-value, indicates the likelihood that the query matches the subject by random chance. A lower E-value signifies greater confidence in the match. Other metrics, such as query coverage, are also provided to help interpret the results. 

>You may be wondering how we got our sequences in the first place. For that you need to do some lab work, just like most of you did in your genetics class. 

![Alt Text](https://raw.githubusercontent.com/shri1984/study-images/refs/heads/main/foods-12-02420-ag.webp)

> ## Tips to blast sequences
> 1. Choose the correct blast module based on the type of sequence input and, importantly, your objective
> 2. Generally speaking, default settings work well in most situations. Use default settings unless you have a good reason to change them.

Now that we have retrieved the sequences for different sushi samples, it’s time to determine their identities. Does the declared species name match the identified species name?

Let’s find out using the online BLAST tool.

One drawback of using online BLAST is the potential waiting time. The duration of a search depends on several factors: the length and number of input sequences, the size of the database being searched, and the specific BLAST program and parameters used. Additionally, during peak usage times, the NCBI servers may experience heavy traffic, which can lead to further delays.

If you need to process a large number of sequences efficiently, a better alternative is to use local BLAST. By installing BLAST on your local machine, you can avoid server queues, customize search parameters to suit your specific requirements, and generate output in formats tailored to your needs. This makes local BLAST particularly advantageous for large-scale or repetitive analyses.

### Using the standalone version of BLAST
The standalone version of BLAST works in the same way as the online version. It requires three components: the NCBI BLAST module, the sequence to be identified, and a database to search against. Additionally, you will need a laptop, server, or virtual machine (VM) to run the analysis.
For this session, you do not need to install the NCBI module or generate the database on the Linux virtual machine — we have already completed the installation for you.
> ### EXTRA: Tip for installing BLAST modules on a Linux-based machine
>
> #### Install NCBI BLAST+
> Use one of the following commands to install BLAST+ tools:
> ```bash
> sudo apt-get install ncbi-blast+
> ```
> or
> ```bash
> conda install -c bioconda blast
> ```
> This will download the precompiled latest version of BLAST+ tools to your system.
> Alternatively, visit the [NCBI BLAST+ page](https://www.ncbi.nlm.nih.gov/books/NBK52640/) to download the software manually.
>
> #### Prepare a database
> Our database consists of nucleotide sequences associated with the group "teleost".
> If you need the full nucleotide database (approximately 200 GB), you can download it from the NCBI FTP server.
> Alternatively, download a nucleotide or protein (nr) database in FASTA format to your system and build the database locally using the following command:
> ```bash
> makeblastdb -in <input_file> -dbtype <nucleotide|protein> -out <output_database_name>
> ```
> This command allows you to create your own database for future use.
---
### Running Standalone BLAST on the Virtual Machine
Connect to the virtual machine (VM). We are now ready to explore the standalone version of BLAST.
To verify that BLAST is installed, run the following command:

```bash
blastn -h
```

We will run the BLAST analysis in the background on the VM, allowing you to use the terminal for other tasks while waiting for the analysis to complete. To do this, we will use an inbuilt application called `screen`.

We will need to modify this command to match our query file and our database path. Let's do it together.

```bash
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
