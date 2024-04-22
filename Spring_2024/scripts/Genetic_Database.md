## GENETIC DATABASES

#### Learning outcome from this exercise

1. What are genetic databases?
2.	To know what different genetic databases are there and how to access them (NCBI , BOLD, KEGG etc)
3.	To know how to download the nucleotide/protein data from databases
4.	What is the format of nucleotide or protein data?
5.	How to identify unknown sequences through similarity search tools (BLAST like tools)
 
Genetic database is one or more sets of genetic data stored together with a software to retrieve, supplement and extract information from them. In this exercise, we will mainly focus on NCBI (National Center for Biotechnology Information). We will quickly browse couple of databases such as KEGG and NCBI. We will dive deep into NCBI in a while.

Let´s start using the NCBI browser to retrieve information. First go to the website: https://www.ncbi.nlm.nih.gov. Look at the home page. Home page has lot of  information, and it is comprehensive: submitting, downloading different databases (nucleotide, protein, etc…), different software, literature information.  We will spend some time on browsing.

#### Downloading the sequence information

The NCBI is very user-friendly database and genetic data search platform. All the basic operations are meant for traditional biologists, who are not very sauvy with coding and other advanced computation skills. So, anyone with minimum biology knowledge can go in there and retrieve information. The only condition is that as a user you need to know what you want, which is depend on the question. We will retrieve COI (cytochrome c oxidase subunit I) sequences of some salmonids or gadidae (family Salmonidae), or you can choose the species you want. We can use these sequences to make phylogenetics trees. 

On top of the web page there is a search bar to search information about the species of your interest. If you select 'all databases' in the search menu and type the scientific name (common name do work sometimes), if you are interested in a single species. But to address the question like above, you may need to write 'salmonidae COI'. You will be directed to a page where the information about your species of interest is available from all possible databases (including peer reviewed literatures). This is one way to find desired information for your species.

Another way is by choosing specific database. 
Use genus species or family or any other taxonomic classification information along with the gene name (COI) to find the sequences. Now you choose nucleotide instead of all the database example: search term could be 'salmonidae coi'

1. Go through the result table and choose few sequences belong to different species from Salmonidae family
2. Download by clicking right corner send to >complete record>file>fasta>download.
Now sequences are downloaded in the fasta format to your local system (your laptop). Generally, it downloads to folder Downloads (depending on your browser setting). 
 
Now Open downloaded file using a text editor. In windows there is default text editor called notepad. But it is not a best text editor. Rather you can download notepad++ (https://notepad-plus-plus.org/downloads/). macOS users can download BBedit (https://www.barebones.com/products/bbedit/). Just check how fasta file looks. Now you have COI sequences belong to different genus of salmonids/your species or family of interest.  As I said earlier, you can search anything in NCBI. try gene names : example p53

#### Using BLAST (basic local alignment search tool) (online version)

The BLAST is the most famous and powerful application of NCBI. As the name suggests, it is a match searching tool. Locate the tab in NCBI webpage where the blast application is shown. Please look into various blast modules. We will go one by one and discuss. 
This is how whole thing works:  Just feed a “unknown” nucleotide or protein sequence to the blast search box and do blast’ing (important: choose right blast module, based on search molecule type and your expectation). It will give you possible hit to your sequence with statistical support (E-VALUE and query coverage). It finds the similarities between sequences you provided (which is 'query'), and sequences stored in the database (which is 'subject'). Blast also calculates the statistical significance of that comparison (E-value, which is like p-value, tells how random the query matches with the subject).  
Let’s try few unknown sequences in blast and try to find the possible identity of those unknown sequences. I have stored that file in folder called 'nucelotides-student.fasta'. 

You get a table as output. Now we see what’s there on that table. 

##### Tips for search sequences: 
1.	Choose right blast module based on the type of sequence input and importantly, your objective
2.	Try to set the parameters if needed. Generally, default settings work better in most of the situations. So, leave them alone if you don’t have any compelling reason to change them or you know what you are doing. 
One disadvantage with online **BLASTing** is waiting time. Longer (and in large numbers) the sequence (s) and larger the database you are comparing against, more it takes to finish the search operation. Time taken to finish a search job is proportional to size of the database you are seraching against. It also depends on the time of the day and nature of the job you are using the BLAST. So, what is the solution if you have lot of sequences? Because of these reasons it is convenient to use a local blast when you have lot of sequences to process. We will use a local blast application in our system. Using **local blast**, we can speed up the BLAST analysis and get more customised result table too. We can make our own blast commands according to our desired filtering parameters. 

 #### Linux based command line BLAST (Standalone BLAST)

This simulates exactly what you get in online version. 

What do you need,
1.	NCBI BLAST+ command line tool installed
2.	Data base to search against (nucleotide or protein)
3.	Query sequence(s)

**You don’t do installation and database generation in this practical. I have done installation part for you***

###### Install NCBI BLAST+: 
In linux OS:  apt-get ncbi-blast+ or conda install 
It will download the precompiled latest version of blast+ tools to your system. 
Or 
https://www.ncbi.nlm.nih.gov/books/NBK52640/
go to this link to install in Linux. 

###### Prepare database

Don’t do this either (if you want to try, go to blast manual on how to make blast database). Database is the one you blast your query against. I made this for you. I choose database which is 'teleost' specific. Nucleotide database at NCBI doesnt exist species wise. Hence database is huge and runs upto 100-200s Gigabytes. So we need to filter databases to restrict to our group of interest. 

Go to FTP server of the NCBI and look for premade blast database. 
https://ftp.ncbi.nlm.nih.gov/blast/db/
 or 
download nucleotide or protein (nr) database in fasta format to your system and build database locally using this command : ***makeblastdb*** to make your own database in future. Or you cna download premade database from above link and then filter the dataabse for your study group.

Tip:
1.	Basis to download premade database is to filter the sequences for desired family or genus or so on. You may not need full database. Full database is very huge in disk size.
2.	Filtering is not easy if you download just the sequences in fasta instead of premade database.

Just type ****blastn -h****  in the command line. if it is all good then you should see help message for ***blastn***

We know how the command line system works in a Linux OS from our previous practicals. We will utilise that knowledge here to run a local blast. We can get exactly same output (like one from web based) in this method. Only difference beyween web and command line based application of blast is local blast output lacks lacks graphical features. In the help dipsay of above command shos you what ****parameters**** one should use inroder to use ***blastn***. ***Parameters*** (also called command line arguments) in a command line application are instructions: specify information that the command needs in order to run. example ls is command name and -a flag (parameter), if you use this -a along with 'ls' then it lists the files within that folder.

Before we running script, try to see the conent of the fasta file you are trying to run as query. 

We will write the blastn script together (NB! there are spaces between the different parameters)

```
blastn  -query name of the query file -db  path_to_database/nt_teleost_16112020 -max_target_seqs 1 -outfmt 6 -out results2.txt -num_threads 1 -evalue 0.001 #findout what each parameters do in this command.

-outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore" # this way you can customise the output file

```
Also try ***blastp -h*** and run ***blastp*** related analysis. Just download some protein related data from protein database and try blastp in the web. 

Default column names (-outfmt 6) (look into online help or terminal help:

-outfmt "6 qseqid qlen qaccver sseqid slen saccver sacc stitle salltitles length pident nident mismatch gapopen qstart qend sstart send evalue bitscore qcovs qcovhsp"

BLASTn tabular output format 6
Column headers:
qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore
1. qseqid query or source (e.g., gene) sequence id
2. sseqid subject or target (e.g., reference genome) sequence id
3. pident percentage of identical matches
4. length alignment length (sequence overlap)
5. mismatch number of mismatches
6. gapopen number of gap openings
7. qstart start of alignment in query
8. qend end of alignment in query
9. sstart start of alignment in subject
10. send end of alignment in subject
11. evalue expect value
12. bitscore bit score

#### Field application of BLAST'ing

1. Identification of species
2. Comaparative genomics : comparing the sequences for commonality and divergence
3. Barcoding of an organism
   
COI from mitochondria is used as a genetic marker to barcode the species. Barcode is the same thing you see on a packet or box in the shop. more detail about the barcode projects here: ***https://phe.rockefeller.edu/barcode/index.php***

<img width="565" alt="LAKES_ART_02_Environmental_DNA_Barcoding" src="https://github.com/shri1984/study-images/assets/58723191/3e68c8d1-17cd-4211-8915-0c12cd50e251">

Once you do the barcoding of that species that remains with that species for ever. In future if you sequence COI region from a source DNA, you can always try to identify the compostion of your DNA collection using the barcode database, such as https://boldsystems.org. 
 
Let’s say you have DNA from an unknown sample (fish or plants or DNA extracted from water or soil or gut etc), and you want to find out what species this DNA belongs. Simple way is to amplify COI region, sequence it and do a database search such as ***https://boldsystems.org***. You “may” find the answer by matching your 'unknown' sequence to the exisiting database. You can also submit the sequences to the databases, so that other people can use the information. However https://boldsystems.org is curated database and here sequence submitter need to first taxonomically identify the species and amplify 500bp (minimum) COI region and submit the sequences with metadata for curation of barcode sequences. If accepted, it will remain as permanent barcode for that species. This collection of sequences will be used as database to identify unknown COI sequences.

4. Inspecting Food safety and quality of the food using DNA barcoding technology  They play an important role in public opinion especially when food alterations or food adulterations get media publicity. There is an increasing demand for the improve food quality by identifying the commercial frauds. DNA barcoding is one of the few means to identify fish/meat sold in retail both due to insufficient labeling requirements or rampant mislabeling of the product or willful mixing of meat from other animals. However, success of 
 the DNA barcode depends on the presence of highly curated sequence database. BOLDSYSTEMS (https://www.boldsystems.org) is one of them. COI is the standard genetic marker used in DNA barcoding technique.

 
 ![Some-of-the-foods-most-susceptible-to-food-fraud](https://github.com/shri1984/study-images/assets/58723191/5c14145d-bdfa-46fc-ba99-40076ab70927)

(image courtesy: https://www.researchgate.net/figure/Some-of-the-foods-most-susceptible-to-food-fraud_fig1_349573973)

#### Exploration of BOLD system 
Go to ***https://www.boldsystems.org/index.php***
What is the largest group of animals having barcode information and from where they are reported the most?  
How much of these barcode records come from Norway? 
To get that information go to taxonomy tab and start looking into different groups animals and numbers of available records are in brackets. Press the links associated with group and you will get lot of metadata about the group. 

Now we will try to use BOLD systems
The sequences (databasesearch.fasta) come from a publication where the authors studied whether sushi restaurant goers in NYC eat any IUCN red listed (https://www.iucnredlist.org) tuna species, as many times fish species (not only tuna) are either mislabelled purposefully or lack of taxonomical knowledge. We will identify the species of Tuna and deliberate the status of these species in IUCN red list (https://www.iucnredlist.org) using BOLD system and if time permits, we can also try them in NCBI web. 
We need to select ‘identification’ tab to do blast like search (https://www.boldsystems.org/index.php/IDS_OpenIdEngine). Copy and paste (one by one or whole sequence set, it needs login account)). Choose species level barcode information in database. Discuss the result from BOLD identification analysis.
