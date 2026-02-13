## Building a reference database

## Before the session
Before we start the class, I would like you all to ensure that you are able to log in to your individual virtual machines. In this session, we will be using something called a "conda environment". Conda is a powerful way to manage software and dependencies. It allows you to easily install, update, and organize bioinformatics tools and libraries without worrying about compatibility issues. Conda also lets you create isolated environments, so you can work on different projects with specific software versions without conflicts. This exercise begins with normal Linux commands, but towards the end relies on the [crabs software](https://github.com/gjeunen/reference_database_creator) for filtering and building your own reference database. 

The CRABS file format that you will work with in this exercise constitutes a single tab-delimited line per sequence containing all information, including (i) sequence accession number, (ii) taxonomic name parsed from the initial download, (iii) NCBI taxon ID number, (iv) taxonomic lineage according to NCBI taxonomy, and (v) the sequence itself. 

We've made a conda environment for you that has the crabs software installed, but you should check that this works on your virtual machines before we start the class. Log in to your own virtual machine, and write the following commands.

<mark>**MADS INSERT PATH**</mark>:

First, we ensure that you are in the right directory, and then copy the reference file you will need for the exercise to your current directory.

```
cd
cp PATH_TO_REFERENCE_FILE .
```

Next, we need to check that you can initialize the preinstalled conda environment:

```
/home/adminfsk2053/miniconda3/bin/conda init bash
```

Once the above command has completed, it should now state "(base)" at the beginning of your prompt.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2026/images/CondaBase.png)

If this worked, you should now be able to activate your conda environment by typing:

```
conda activate crabs
```

It should now state "(crabs") at the beginning of your prompt. If this worked, you are ready for the exercise.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2026/images/CondaCrabs.png)

**Note**: This conda environment needs to be loaded for every new session you start, where you plan on using the crabs commands from this exercise - *i.e.*, if you plan on testing it out further at home, you will need to write only the last command (it should state "(base)" everytime you log in to a new session now).

You can also check out the help command for crabs. We will only be using "crabs --subset" and "crabs --export" in this exercise, but there are a lot more functions and parameters available in the software.

```
crabs -h
```

## Introduction and objectives

This exercise is designed to enhance your understanding of the many factors involved in creating and relying on genetic reference databases. Throughout the session, you will be challenged to apply critical thinking skills to evaluate and curate data effectively.

The exercise is divided into two components: pre-curation and post-curation reflections. While the examples here focus on fish species, the principles can be applied to any organism group.

We will work exclusively with short 12S barcodes, widely regarded as the best short genetic marker for identifying fish species from environmental samples. 

I want you to imagine starting with a fish sample of unknown origin or a sequence obtained from a water sample, with no prior knowledge of its origin. Your task will be to build a reference database to solve this mystery.

There are 20 questions dispersed throughout the exercise, which are natural stopping points for reflecting critically about your next move.

By the end of this exercise, I hope you will have a deeper appreciation for the complexities of reference databases and be able to critically evaluate reference database reliability and accuracy.

## Paths that might come in handy during the exercise

Shripathi's reference database

  `/home/adminfsk2053/database_new_2025/`

## Exercise instructions

In this exercise, each group (2-4 working together) will choose one of the following fish groups as their target for database scrutiny.

1) Rajidae (skates)
2) Holocephali (chimaeras)
3) Oneirodidae (dreamers)
4) Zoarcidae (eelpouts)
5) Liparidae (snailfishes)
6) Psychrolutidae ("blobfishes" - marine sculpins)
7) Myctophidae (lanternfishes)
8) Gadidae (codfishes)
9) Salmonidae (salmonids - *warning: this one is the most difficult*)

Once you have chosen your group, you can filter the reference database to include only your target. All the below examples are done with Rajidae, so if you chose another group, you will have to change the name accordingly throughout the guide:

Here we make a new file that includes only references from Rajidae.

```
cat References_unfiltered.txt | grep 'Rajidae' > References_unfiltered_Rajidae.txt
```

## Pre-database curation

Your new file "References_unfiltered_Rajidae.txt" will be the starting point for this exercise. Let's have a look and see what it contains.

**NOTE**: The less command below is good for visualizing without printing to the screen. You can use "cat" instead of "less -S" if you would rather print to screen. To exit the less command, simply click the "Q" button.

```
less -S References_unfiltered_Rajidae.txt
```

Some of you may have more data entries than others, so we could maybe think about summarizing the content in a more ordered manner.
You may recall from the structure of the CRABS-file format that we can find the species information of each record in the 10th column. You could also try to summarize across other taxonomic levels.

**NOTE**: As we here use "sort -n", we sort the species entries numerically (alphabetically), and then we use "uniq -c" to only have unique entries while counting the amount of times each of them are encountered in your file.
```
cut -f10 References_unfiltered_Rajidae.txt | sort -n | uniq -c | less -S
```

<mark>**Question 1**</mark>: Do you see any potential issues here? Do the species names make sense to you?

<mark>**Question 2**</mark>: Are some species overrepresented compared to others?

### Synonyms

In the bottom of this document, I've included a [table](https://github.com/MadsRJ/FSK2053/edit/main/Spring_2026/Practical_Building_a_reference_database.md#all-fishes-present-in-nordic-countries-from-your-nine-taxonomically-limited-groups)
 of all the fishes (from your nine groups) that exist in Nordic countries. You can search (CTRL + F or COMMAND + F) for your group to see what species would be relevant for your chosen group. 

A common problem that we face when creating databases is related to synonyms. Synonyms occur when different terms or identifiers are used to refer to the same entity or concept. In bioinformatics, this can lead to inconsistencies and errors when integrating or querying data from multiple sources. For example, a single species might be referred to by multiple names across or even within databases. If these synonyms are not properly accounted for, it can result in incorrect inferences, ultimately compromising the reliability and accuracy of the database. Addressing this issue requires careful curation, standardization, and the use of controlled vocabularies to ensure consistency. For fishes, we rely on [Eschmeyer's Catalog of Fishes](https://researcharchive.calacademy.org/research/ichthyology/catalog/fishcatmain.asp) (Fricke et al., 2025) for taxonomic authority.

Compare the species names present in your file with the table below. Do you find any synonyms that we would need to deal with for species occurring in Nordic waters?

**NOTE**: We run the same command again to enable comparison
```
cut -f10 References_unfiltered_Rajidae.txt | sort -n | uniq -c | less -S
```
<mark>**Question 3**</mark>: Did you encounter any problematic synonyms in your file?

### Misidentifications vs. taxonomic resolution

The next common problem encountered in these databases is that those people who deposit reference sequences may not have identified their specimens correctly. This problem can take many shapes and forms, such as accidental mislabeling of tubes in the lab, confusion between morphologically similar organisms, or it could even arise from dealing with organism groups in need of taxonomic revision. As a result, incorrect reference sequences can propagate through analyses, leading to misidentifications, flawed phylogenetic trees, or inaccurate biodiversity assessments. This issue is particularly problematic when it comes to DNA barcoding or metabarcoding, where the accuracy of the reference database is critical. To mitigate this, rigorous validation of specimen identification, cross-referencing with multiple data sources, and expert curation are essential to maintain the integrity of reference databases. We will unfortunately not have the time during this exercise to go in great detail with the integrity of the sequences, but it is important to understand this from a conceptual standpoint. Take a look at the example below.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2026/images/MisID1_yes.png)

<mark>**Question 4**</mark>: What do you think happened here? Do you suspect any of these were misidentified?

Sometimes we have enough "circumstantial evidence" to choose to disregard ("blacklist") specific sequences. However, in other instances, we might not have enough material available to fully decide on the best approach forward. In such instances, it is best to remain conservative until more reference data becomes available (which is why this work is always "ongoing"). See the example below.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2026/images/MisID2_maybe.png)

<mark>**Question 5**</mark>: Would you claim that any of these appear to be misidentified? If so, would you blacklist any of the data entries?

To make matters worse, for some closely related species, there simply isn't enough taxonomic resolution in a short genetic marker to differentiate between the species in question. This is often referred to as "barcode overlap" or lack of a "barcode gap". In the example below, you'll see that it is problematic to differentiate between the three species of wolffish which occur in Nordic waters. Had we chosen to work with another genetic marker, this would potentially have been more feasible.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2026/images/MisID3_resolution.png)

<mark>**Question 6**</mark>: Based on what you see above, can we discriminate between these species with this genetic marker?

**Note**: If we had a longer reference sequence to inspect, the wolffish species would actually be possible to distinguish.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2026/images/MisID4_higherresolution.png)

### Hybrids and subspecies

Another problematic scenario is the case of hybrids. For the most part, we are looking at short mitochondrial DNA fragments. You may remember that mitochondrial DNA is maternally inherited (you get you mother's mitochondrial DNA, not your father's). Here, it quickly becomes complex and our possible inferences will naturally be dependent on whether the offspring is viable and can reproduce, as well as whether the hybridization occurs naturally or is human induced etc. Regardless, it means that species that are able to hybridize can share mitochondrial DNA and limit our inferences. When depositing reference sequences from known hybrid specimens, people often describe the species as "Species A x Species B". However, it is not always obvious whether you're dealing with a hybrid specimen, and as a result, these can also be deposited under a single species' name. I normally always remove sequences derived from hybrid specimens, as they are simply a source of eternal frustration.

Similarly, some people deposit sequences under "subspecies" names (e.g. *Salmo trutta trutta* (sea trout) and *Salmo trutta fario* (brown trout) are both *Salmo trutta*). In [NCBI's nt database](https://www.ncbi.nlm.nih.gov/nucleotide/) (one of the most common databases for storing your reference sequences), each unique taxon is given a unique "TaxID", so you can refer back to what taxonomic entity was from the original data entry. This "TaxID" number is found in the third column of your files, and if you want extra knowledge, you can look up these numbers in [NCBI's taxonomy database](https://www.ncbi.nlm.nih.gov/taxonomy/). In the CRABS format you've been given, I've already manipulated the files to not include hybrid sequences. However, there might still be cases where multiple TaxIDs may exist for a single species. Let's first select the columns of interest (TaxID + Species), sort them and include only unique instances, take only the species column, and then move on to another round of sorting and counting, ending by ranking them by from lowest to highest number of TaxIDs per species.

```
cut -f3,10 References_unfiltered_Rajidae.txt | sort | uniq | cut -f2 | sort -n | uniq -c | sort -n | less -S
```

**Note**: You can try to do this step by step to understand the process fully (and to appreciate the power of the pipe!)

```
cut -f3,10 References_unfiltered_Rajidae.txt | less -S
cut -f3,10 References_unfiltered_Rajidae.txt | sort | less -S
cut -f3,10 References_unfiltered_Rajidae.txt | sort | uniq | less -S
cut -f3,10 References_unfiltered_Rajidae.txt | sort | uniq | cut -f2 | less -S
cut -f3,10 References_unfiltered_Rajidae.txt | sort | uniq | cut -f2 | sort -n | less -S
cut -f3,10 References_unfiltered_Rajidae.txt | sort | uniq | cut -f2 | sort -n | uniq -c | less -S
cut -f3,10 References_unfiltered_Rajidae.txt | sort | uniq | cut -f2 | sort -n | uniq -c | sort -n | less -S
```

<mark>**Question 7**</mark>: Did you find any species with multiple TaxIDs present in your group? If you have the enough time, you can try to write your own code to isolate the TaxIDs of a species with multiple TaxIDs and look them up in the [NCBI's taxonomy database](https://www.ncbi.nlm.nih.gov/taxonomy/).

### Ambiguous basepairs in reference sequences

Ambiguous base pairs can arise during the sequencing of reference samples due to various factors, such as sequencing errors or sample impurity. During the sequencing process, the machine may misread a base, leading to uncertainty. For instance, instead of confidently identifying a base as "A" or "G," the sequencer may assign an ambiguous code like "R" (A or G). If the reference sample contains DNA from multiple closely related organisms (e.g., due to contamination), the sequencer may detect multiple bases at the same position. For example, a position might show both "C" and "T," resulting in the ambiguous code "Y" (C or T). For many Sanger sequencing products (an "older" technology), which form the basis of many sequences in your files, individual researchers have evaluated chromatograms by eye to determine their confidence in assigning a single base pair. When uncertain, they often choose to report sequences with ambiguities rather than making definitive but potentially incorrect assignments. However, there has never been a consistent system in place for when to assign ambiguous basepairs, and it has thus been up to the individual researcher to scrutinize their individual data. These ambiguities are commonly represented using IUPAC codes in the sequence data, which can complicate downstream analyses if not properly accounted for.

Here you see a list of IUPAC codes and how to interpret them.

| IUPAC nucl. code | Base        |
|------------------|-------------|
| A                | Adenine     |
| C                | Cytosine    |
| G                | Guanine     |
| T                | Thymine     |
| R                | A or G      |
| Y                | C or T      |
| S                | G or C      |
| W                | A or T      |
| K                | G or T      |
| M                | A or C      |
| B                | C or G or T |
| D                | A or G or T |
| H                | A or C or T |
| V                | A or C or G |
| N                | Any base    |

We will now inspect whether any of the sequences found in our original, complete reference file contained ambiguous basepairs. We use the original file here, as there aren't that many records with ambiguous basepairs (I have prefiltered your file a little bit).

**NOTE**: This code snippet using awk may be a bit difficult to interpret. All it does is to look for any of the ambiguous IUPAC codes occurring in any of the sequences. It prints the whole line in instances where it finds a line that matches the condition.

```
awk -F '\t' '{ if ($11 ~ /[RYSWKMBDHVN]/) print NR, $0 }' References_unfiltered.txt | less -S
```

<mark>**Question 8**</mark>: How would you deal with ambiguous basepairs when curating your reference database? Should those records be deleted, or can they still be informative?

### Unique sequences per species - what does it tell us?
We already looked at the amount of sequences for each species in your respective files. However, it could also be informative to look at the number of unique sequences for each species. It is completely normal and natural to observe multiple unique sequences within a species for a given genetic barcode region. However, in some cases, this variation may indicate that one or more individuals of the species were misidentified. For example, if most specimens of a species share a dominant sequence, but a less abundant sequence is also present—and that sequence matches one found in another species in your reference database—this could be a strong clue of a misidentified specimen. This is particularly likely if the sequences are highly divergent. Let's have a look at the unique sequences per species in your file.

**NOTE**: The actual sequence is found in column 11. Here we rely on the species name and the sequence, sort them numerically (alphabetically) by species, and count the unique sequence entries per unique species.
```
cut -f10,11 References_unfiltered_Rajidae.txt | sort -n | uniq -c | less -S
```

<mark>**Question 9**</mark>: Do you have any species with multiple unique sequences present?

<mark>**Question 10**</mark>: Is it enough to sequence one specimen per species, or do we need more?

<mark>**Question 11**</mark>: Do you think that species with a disproportionately high amount of specimens sequenced might be biasing your reference database in any way?

### Filtration of data entries: Subset your database to include/exclude taxa that are relevant to you
Here you have the option to include or exclude specific taxa. Many people chose to limit their reference databases to only include species that are known to occur in the local region of interest. You could find some examples of exotic species (*i.e.*, not in the Nordic species list) that you'd like to remove, or you could include only the species that exist in Nordic countries. Below are two examples with "--exclude" and "--include". More species can be added by using the semicolon (;).

```
crabs --subset --input References_unfiltered_Rajidae.txt --output References_filtered_Rajidae.txt --exclude 'Amblyraja georgiana;Okamejei kenojei'
```

```
crabs --subset --input References_unfiltered_Rajidae.txt --output References_filtered_Rajidae.txt --include 'Amblyraja radiata;Dipturus oxyrinchus'
```

<mark>**Question 12**</mark>: What are the pros and cons of limiting your reference database to a specific local region? Is it a good idea?

**NOTE**: If you wanted to eliminate specific entries (accession numbers) rather than taxa, you'd have to do this in a separate way, e.g. using grep.

Below is an example removing only the entry "EF100184"

```
cat References_unfiltered_Rajidae.txt | grep -v 'EF100184' > References_AccNofiltered_Rajidae.txt
```

### Building the database
Now you've had a chance to clean the data, and to have a glimpse into what actually goes into your reference database. All that's left is to build the database itself.

**NOTE**: We make a new folder called BLAST_Rajidae, and we make create the database inside this folder.

```
mkdir -p BLAST_Rajidae
crabs --export --input References_filtered_Rajidae.txt --output BLAST_Rajidae/BLAST_Rajidae --export-format 'blast-tax' 
```

The database has now been created, and it is possible to use this database in the exact same way that you used the predownloaded database in the previous exercise, you just have to modify your path. You can try to make this work at home if you would like to test further.

### Post-curation checks (in plenum)

The post-curation check is all about thinking critically about the reference database once it has been built. Now that you know what species went into your reference database, and you known what species of fishes occur in Nordic waters, you can begin to evaluate how good your database actually is. Knowing the limits and biases of your reference database is equally important to the efforts going into building it. When working with organisms where we have a good understanding of what *should* exist in Nordic waters, we can compare the species going into the database with the species we know could exist here, as we have done in this exercise. However, sometimes we do not know the origin of e.g. a fish product, or we have limited knowledge of what species could exist in a given environment from which a sample was taken. And with climate change, ballast waters, and all the other human-induced impacts, non-native or invasive species are more likely to establish in new areas. It is therefore important to consider what it is you want to use your database for, when choosing how to design it. Here you have some questions to reflect on during class if we have time, otherwise to think about at home.

<mark>**Question 13**</mark>: What should we do about data entries that aren't known to occur in Nordic waters? How do these affect our inference if included?

<mark>**Question 14**</mark>: How should we deal with data entries where specimens aren't identified to species level? Are these problematic or informative?

<mark>**Question 15**</mark>: What would be your criteria for blacklisting (removing) certain entries? When do we "know enough" to throw out a sequence from the reference database?

<mark>**Question 16**</mark>: Are any species from your taxonomically limited group missing in your reference database? If so, is this a problem when you try to identify a sequence of unknown origin?

<mark>**Question 17**</mark>: Did knowing what species exist in Nordic countries change your perception of how good the database was for your target group?

<mark>**Question 18**</mark>: Is your database designed to detect invasive species? What would you do differently if you wanted to have early detection mechanisms for detecting invasive species?

<mark>**Question 19**</mark>: If you get an equally good hit to a species only known from Greenland to a species known to occur in Norway, is it fair to assume that the sequence originated the Norwegian species, if your sample is from Norway?

<mark>**Question 20**</mark>: In the case of the three wolffish species (*Anarhichas lupus*, *Anarhichas minor* and *Anarhichas denticulatus*), *A. lupus* is known to be more coastal, whereas the other two are usually found further off shore. Is it fair to decide which of the species we found using the barcode, assuming our sample was from the coastal zone? 

## All fishes present in Nordic countries from your nine taxonomically limited groups

#### Table of all the 178 species belonging to the nine taxonomically limited groups that you are working with in this session. All of these are known to occur in waters of Nordic countries.

| Class          | Order              | Family               | Subfamily         | Species                           | Common name                   | Known synonyms                                            |
|----------------|--------------------|----------------------|-------------------|-----------------------------------|-------------------------------|-----------------------------------------------------------|
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Amblyraja hyperborea*            | Arctic skate                  |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Amblyraja jenseni*               | Shorttail skate               |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Amblyraja radiata*               | Starry ray                    |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Dipturus batis*                  | Blue skate                    |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Dipturus intermedius*            |                               |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Dipturus nidarosiensis*          | Norwegian skate               |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Dipturus oxyrinchus*             | Longnosed skate               |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Leucoraja circularis*            | Sandy ray                     |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Leucoraja fullonica*             | Shagreen ray                  |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Leucoraja naevus*                | Cuckoo ray                    |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Malacoraja kreffti*              | Krefft's ray                  |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Malacoraja spinacidermis*        | Soft skate                    |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Neoraja caerulea*                | Blue ray                      |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Raja brachyura*                  | Blonde ray                    |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Raja clavata*                    | Thornback ray                 |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Raja montagui*                   | Spotted ray                   |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Rajella bathyphila*              | Deep-water ray                |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Rajella bigelowi*                | Bigelow's ray                 |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Rajella fyllae*                  | Round ray                     |                                                           |
| Elasmobranchii | Rajiformes         | Rajidae              |                   | *Rajella lintea*                  | Sailray                       | *Dipturus linteus*                                        |
| Holocephali    | Chimaeriformes     | Chimaeridae          |                   | *Chimaera monstrosa*              | Rabbit fish                   |                                                           |
| Holocephali    | Chimaeriformes     | Chimaeridae          |                   | *Chimaera opalescens*             | Opal chimaera                 |                                                           |
| Holocephali    | Chimaeriformes     | Chimaeridae          |                   | *Hydrolagus affinis*              | Smalleyed rabbitfish          |                                                           |
| Holocephali    | Chimaeriformes     | Chimaeridae          |                   | *Hydrolagus mirabilis*            | Large-eyed rabbitfish         |                                                           |
| Holocephali    | Chimaeriformes     | Chimaeridae          |                   | *Hydrolagus pallidus*             |                               |                                                           |
| Holocephali    | Chimaeriformes     | Rhinochimaeridae     |                   | *Harriotta raleighana*            | Pacific longnose chimaera     | *Harriotta haeckeli*                                      |
| Holocephali    | Chimaeriformes     | Rhinochimaeridae     |                   | *Rhinochimaera atlantica*         | Straightnose rabbitfish       |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Barbantus curvifrons*            | Palebelly searsid             |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Holtbyrnia anomala*              | Bighead searsid               |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Holtbyrnia macrops*              | Bigeye searsid                |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Maulisia mauli*                  | Maul's searsid                |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Maulisia microlepis*             | Smallscale searsid            |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Normichthys operosus*            | Multipore searsid             | *Normichthys operosa*                                     |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Platytroctes apus*               | Legless searsid               |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Platytroctes mirus*              | Leaf searsid                  |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Sagamichthys schnakenbecki*      | Schnakenbeck's searsid        |                                                           |
| Actinopteri    | Alepocephaliformes | Platytroctidae       |                   | *Searsia koefoedi*                | Koefoed's searsid             |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus albula*                | Vendace                       |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus artedi*                | Cisco                         |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus clupeaformis*          | Lake whitefish                |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus lavaretus*             | European whitefish            |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus maraena*               | Maraena whitefish             |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus maxillaris*            |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus megalops*              | Lacustrine fluvial whitefish  |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus nilssoni*              |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus oxyrinchus*            | Houting                       |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus pallasii*              |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus peled*                 | Peled                         |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus pidschian*             | Humpback whitefish            |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus trybomi*               |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Coregoninae       | *Coregonus widegreni*             | Valaam whitefish              |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Thymallinae       | *Thymallus thymallus*             | Grayling                      |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus clarkii*            | Cutthroat trout               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus gorbuscha*          | Pink salmon                   |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus keta*               | Chum salmon                   |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus kisutch*            | Coho salmon                   |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus mykiss*             | Rainbow trout                 |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Oncorhynchus nerka*              | Sockeye salmon                |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salmo salar*                     | Atlantic salmon               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salmo trutta*                    | Sea trout                     |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus alpinus*              | Arctic char                   | *Salvelinus umbla*                                        |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus faroensis*            |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus fontinalis*           | Brook trout                   |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus lepechini*            |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus murta*                |                               |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus namaycush*            | Lake trout                    |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus salvelinoinsularis*   | Bear Island charr             |                                                           |
| Actinopteri    | Salmoniformes      | Salmonidae           | Salmoninae        | *Salvelinus thingvallensis*       |                               |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Gymnoscopelinae   | *Notoscopelus kroyeri*            | Lancet fish                   |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Ceratoscopelus maderensis*       | Madeira lantern fish          |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Lampadena speculigera*           | Mirror lanternfish            |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Lampanyctus ater*                | Dusky lanternfish             | *Nannobrachium atrum*                                     |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Lampanyctus crocodilus*          | Jewel lanternfish             |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Lampanyctus intricarius*         | Diamondcheek lanternfish      |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Lampanyctinae     | *Lampanyctus macdonaldi*          | Rakery beaconlamp             |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Diaphinae         | *Diaphus rafinesquii*             | White-spotted lantern fish    |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Myctophinae       | *Benthosema glaciale*             | Glacier lantern fish          |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Myctophinae       | *Myctophum punctatum*             | Spotted lanternfish           |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Myctophinae       | *Protomyctophum arcticum*         | Arctic telescope              |                                                           |
| Actinopteri    | Myctophiformes     | Myctophidae          | Myctophinae       | *Symbolophorus veranyi*           | Large-scale lantern fish      |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Arctogadus glacialis*            | Arctic cod                    |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Boreogadus saida*                | Polar cod                     |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Eleginus nawaga*                 | Navaga                        |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Gadiculus argenteus*             | Silvery pout                  | *Gadiculus thori*                                         |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Gadus chalcogrammus*             | Walleye pollock               | *Gadus finnmarchicus*, *Theragra chalcogramma*, *Theragra finnmarchica* |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Gadus macrocephalus*             | Pacific cod                   | *Gadus ogac*, despite Eschmeyer not listing it            |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Gadus morhua*                    | Atlantic cod                  |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Melanogrammus aeglefinus*        | Haddock                       |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Merlangius merlangus*            | Whiting                       |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Micromesistius poutassou*        | Blue whiting                  |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Pollachius pollachius*           | Pollack                       |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Pollachius virens*               | Saithe                        |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Trisopterus esmarkii*            | Norway pout                   |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Trisopterus luscus*              | Pouting                       |                                                           |
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Trisopterus minutus*             | Poor cod                      |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Artediellus atlanticus*          | Atlantic hookear sculpin      |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Artediellus scaber*              | Hamecon                       |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Artediellus uncinatus*           | Arctic hookear sculpin        |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Cottunculus microps*             | Polar sculpin                 |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Cottunculus subspinosus*         |                               | *Psychrolutes subspinosus*                                |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Cottunculus thomsonii*           | Pallid sculpin                |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Gymnocanthus tricuspis*          | Arctic staghorn sculpin       |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Icelus bicornis*                 | Twohorn sculpin               |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Icelus spatula*                  | Spatulate sculpin             |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Micrenophrys lilljeborgii*       | Norway bullhead               |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Myoxocephalus quadricornis*      | Fourhorn sculpin              |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Myoxocephalus scorpioides*       | Arctic sculpin                |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Myoxocephalus scorpius*          | Shorthorn sculpin             |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Taurulus bubalis*                | Longspined bullhead           |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Triglops murrayi*                | Moustache sculpin             |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Triglops nybelini*               | Bigeye sculpin                |                                                           |
| Actinopteri    | Perciformes        | Psychrolutidae       |                   | *Triglops pingelii*               | Ribbed sculpin                |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Careproctus kidoi*               | Kido's snailfish              |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Careproctus micropus*            | Small-eye tadpole             | *Careproctus latiosus*, *Careproctus moskalevi*, *Careproctus mica* |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Careproctus reinhardti*          | Sea tadpole                   | *Careproctus longipinnis*, *Careproctus solidus*, *Careproctus dubius* |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis bathyarcticus*           |                               |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis fabricii*                | Gelatinous snailfish          |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis gibbus*                  | Variegated snailfish          |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis liparis*                 | Striped seasnail              |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis montagui*                | Montagus seasnail             |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Liparis tunicatus*               | Kelp snailfish                |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Paraliparis bathybius*           | Black seasnail                |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Paraliparis copei*               | Blacksnout seasnail           |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Paraliparis garmani*             | Pouty seasnail                |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Paraliparis hystrix*             |                               |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos christinae*              | European dwarf snailfish      |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos gelatinosus*             | Gelatinous dwarf snailfish    |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos groenlandicus*           | Greenland dwarf snailfish     |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos islandicus*              |                               |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos melanocephalus*          |                               |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Psednos micruroides*             | Multipore dwarf snailfish     |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Rhodichthys melanocephalus*      | Blackhead strainer snailfish  |                                                           |
| Actinopteri    | Perciformes        | Liparidae            |                   | *Rhodichthys regina*              | Threadfin seasnail            |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys alba*                |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys kolthoffi*           | Checkered wolf eel            |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys muraena*             | Moray wolf eel                |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys paxillus*            | Common wolf eel               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys platyrhina*          |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycenchelys sarsii*              | Sar's wolf eel                |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes adolfi*                  | Adolf's eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes esmarkii*                | Greater eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes eudipleurostictus*       | Doubleline eelpout            |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes frigidus*                | Glacial eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes gracilis*                |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes luetkenii*               | Lütken's eelpout              |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes mcallisteri*             | McAllister's eelpout          |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes mucosus*                 | Saddled eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes paamiuti*                | Paamiut eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes pallidus*                | Pale eelpout                  |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes polaris*                 | Canadian eelpout              |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes reticulatus*             | Arctic eelpout                |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes rossi*                   | Threespot eelpout             |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes seminudus*               | Longear eelpout               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes squamiventer*            | Scalebelly eelpout            |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes terraenovae*             |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes turneri*                 | Polar eelpout                 |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodes vahlii*                  | Vahl's eelpout                |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodonus flagellicauda*         |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Lycodonus mirabilis*             | Chevron scutepout             |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Lycodinae         | *Pachycara microcephalum*         |                               |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Zoarcinae         | *Zoarces viviparus*               | Eelpout                       |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Gymnelinae        | *Gymnelus retrodorsalis*          | Aurora unernak                |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Gymnelinae        | *Gymnelus viridis*                | Fish doctor                   |                                                           |
| Actinopteri    | Perciformes        | Zoarcidae            | Gymnelinae        | *Melanostigma atlanticum*         | Atlantic soft pout            |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Chaenophryne draco*              | Smooth dreamer                |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Chaenophryne longiceps*          | Can-opener smoothdream        |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Danaphryne nigrifilis*           |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Dolopichthys longicornis*        |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Leptacanthichthys gracilispinis* | Plainchin dreamarm            |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Lophodolos acanthognathus*       | Whalehead dreamer             |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Oneirodes anisacanthus*          |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Oneirodes carlsbergi*            |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Oneirodes eschrichtii*           | Bulbous dreamer               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Oneirodes macrosteus*            |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Oneirodes myrionemus*            |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Phyllorhinichthys balushkini*    |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Phyllorhinichthys micractis*     |                               |                                                           |
| Actinopteri    | Lophiiformes       | Oneirodidae          |                   | *Spiniphryne gladisfenae*         | Prickly dreamer               |                                                           |
