## Crabs example of building a reference database
## Technical consideration: We need to get a crabs installation up and running on the Azure server.

### Introduction

This exercise is split into two components; the pre-curation and the post-curation
Go through file format of CRABS.txt files. Note that there are many different formats, I just like personally the CRABS software.
Imagine Norway has a total of e.g. 50 fish species present in territorial waters.
We only work with 12S barcodes. This is classicly the best short genetic marker for genetic identification of fishes.

### Exercise instructions

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

Some of you may have more data entries that others, so we could maybe think about summarizing the content in a more ordered manner.
You may recall from the structure of the CRABS-file format that we can find the species information of each record in the 10th column. You could also try to summarize across other taxonomic levels.

**NOTE**: As we here use "sort -n", we sort the species entries numerically (alphabetically), and then we use "uniq -c" to only have unique entries while counting the amount of times each of them are encountered in your file.
```
cut -f10 References_unfiltered_Rajidae.txt | sort -n | uniq -c | less -S
```

<mark>**Question 1**</mark>: Do you see any potential issues here? Do the species names make sense to you?

<mark>**Question 2**</mark>: Are some species overrepresented compared to others?

### Synonyms

In the bottom of this document, I've included a table of all the fishes (from your nine groups) that exist in Nordic countries. You can search (CTRL + F or COMMAND + F) for your group to see what species would be relevant for your chosen group. 

A common problem that we face when creating databases is related to synonyms. Synonyms occur when different terms or identifiers are used to refer to the same entity or concept. In bioinformatics, this can lead to inconsistencies and errors when integrating or querying data from multiple sources. For example, a single species might be referred to by multiple names across or even within different databases. If these synonyms are not properly accounted for, it can result in incorrect inferences, ultimately compromising the reliability and accuracy of the database. Addressing this issue requires careful curation, standardization, and the use of controlled vocabularies to ensure consistency. For fishes, we rely on [Escmeyer's Catalog of Fishes](https://researcharchive.calacademy.org/research/ichthyology/catalog/fishcatmain.asp) (Fricke et al., 2025) for taxonomic authority.

Compare the species names present in your file with the table below. Do you find any synonyms that we would need to deal with for species occurring in Nordic waters?

**NOTE**: We run the same command again to enable comparison
```
cut -f10 References_unfiltered_Rajidae.txt | sort -n | uniq -c | less -S
```
<mark>**Question 3**</mark>: Did you encounter any problematic synonyms in your file?

### Misidentifications vs. taxonomic resolution

The next common problem encountered in these databases is that those people who deposit reference sequences may not have identified their specimens correctly. This problem can take many shapes and forms, such as accidental mislabeling of tubes in the lab, confusion between morphologically similar organisms, and it can even arise from dealing with organism groups in need of taxonomic revision. As a result, incorrect reference sequences can propagate through analyses, leading to misidentifications, flawed phylogenetic trees, or inaccurate biodiversity assessments. This issue is particularly problematic when it comes to DNA barcoding or metabarcoding, where the accuracy of the reference database is critical. To mitigate this, rigorous validation of specimen identification, cross-referencing with multiple data sources, and expert curation are essential to maintain the integrity of reference databases. We will unfortunately not have the time during this exercise to go in great detail with the integrity of the sequences, but it is important to understand this from a conceptual standpoint. Take a look at the example below.

[INSERT EXAMPLE FROM GENIOUS]

<mark>**Question 4**</mark>: What do you think happened here? Do you suspect any of these were misidentified?

Sometimes we have enough "circumstantial evidence" to choose to disregard ("blacklist") specific sequences. However, in other instances, we might not have enough material available to fully decide on the best approach forward. In such instances, it is best to remain conservative until more reference data becomes available (which is why this work is always "ongoing"). See the example below.

[INSERT EXAMPLE OF TOO FEW SPECIMENS TO DECIDE]

<mark>**Question 5**</mark>: Would you claim that any of these appear to be misidentified? If so, would you blacklist any of the data entries?

To make matters worse, for some species, there simply isn't enough taxonomic resolution in a short genetic marker to differentiate between the species. This is often referred to as "barcode overlap" or lack of a "barcode gap". In the example below, you'll see that it is problematic to differentiate between the three species of wolffish which occur in Nordic waters. Had we chosen to work with another genetic marker, this would potentially have been more feasible.

[INSERT WOLFFISH EXAMPLE]

<mark>**Question 6**</mark>: Based on what you see above, can we discriminate between these species with this genetic marker?

### Hybrids and subspecies

Another problematic scenario is the case of hybrids. For the most part, we are looking at short mitochondrial DNA fragments. You may remember that mitochondrial DNA is maternally inherited (you get you mother's mitochondrial DNA, not your father's). Here, it quickly becomes complex and our possible inferences will naturally be dependent on whether the offspring is viable and can reproduce, as well as whether the hybridization occurs naturally or is human induced etc. Regardless, it means that species that are able to hybridize can share mitochondrial DNA and limit our inferences. When depositing reference sequences from known hybrid specimens, people often describe the species as "Species A x Species B". However, it is not always obvious whether you're dealing with a hybrid specimen, and as a result, these can also be deposited under a single species' name. 

Similarly, some people deposit sequences under "subspecies" names (e.g. *Salmo trutta trutta* (sea trout) and *Salmo trutta fario* (brown trout) are both *Salmo trutta*). In [NCBI's nt database](https://www.ncbi.nlm.nih.gov/nucleotide/) (one of the most common databases for storing your reference sequences), each unique taxon is given a unique "TaxID", so you can refer back to what taxonomic entity was from the original data entry. This number is found in the third column of your files, and if you want extra knowledge, you can look up these numbers in [NCBI's taxonomy database](https://www.ncbi.nlm.nih.gov/taxonomy/). In the CRABS format you've been given, I've already manipulated the files to not include hybrid sequences. However, there might still be cases where multiple TaxIDs may exist for a single species. Let's first select the columns of interest (TaxID + Species), sort them and include only unique instances, and then move on to count

**Note**: 
```
cut -f3,10 References_unfiltered_Salmonidae.txt | sort | uniq | cut -f2 | sort -n | uniq -c | sort -n | less -S
```
<mark>**Question 7**</mark>: Did you find any species with multiple TaxIDs present in your group? If you have the enough time, you can try to write your own code to isolate the TaxIDs of a species with multiple TaxIDs and look them up in the [NCBI's taxonomy database](https://www.ncbi.nlm.nih.gov/taxonomy/).

### Ambiguous basepairs in reference sequences
<mark>**Write description**</mark>:

**NOTE**: We run this on the original, complete reference file, as there aren't that many records with ambiguous basepairs.
awk -F '\t' '{ if ($11 ~ /[RYSWKMBDHVN]/) print NR, $0 }' References_unfiltered.txt | less -S

<mark>**Question 8**</mark>: How would you deal with ambiguous basepairs in your reference sequences? Should those records be deleted, or can they still be informative?




#### Include count of unique sequences per species?
#### Include examples of perfect taxonomic resolution (sometimes it works really well)

#### Build the database!

### Post-curation checks
#### Include examples of species missing barcodes (which we cannot fix bioinformatically)
#### Fill in a premade sheet of species characteristics in terms of the database (exercise for students)
#### Follow up questions with some information about primer mismatches and likelihoods of detection?
#### Provide some sequence data and ask what species are present in the eDNA samples (ask students to discuss our limitations here after the exercise)
#### Some people go the extra mile during their taxonomic assignment. Imagine you get a hit to species A (living in Norway) and an equally good hit to species B (only known from Greenland). Is it fair to assume your hit comes from the Norwegian species? 
#### Similarly, if we get hits to three wolffish species (*Anarhichas lupus* - more coastal, *Anarhichas minor* and *Anarhichas denticulatus* both known to live further offshore). Is it fair to decide which of the species we found using the barcode, assuming our sample was from the coastal zone?

### Further reflection and critical thinking

<mark>**Question x**</mark>: What should we do about data entries that aren't known to occur in Nordic waters?

<mark>**Question x**</mark>: How should we deal with data entries where specimens aren't identified to specices level?

<mark>**Question x**</mark>: How should we deal with data entries where specimens aren't identified to specices level?

<mark>**Question x**</mark>: Did knowing what species exist in Nordic countries change your perception of how good the database was for your target group?

<mark>**Question x**</mark>: What would be your criteria for blacklisting (removing) certain entries? When do we "know enough" to throw out a sequence from the reference database?

## Examples of groups of fishes present in Nordic countries
#### Table of ..

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
| Actinopteri    | Gadiformes         | Gadidae              |                   | *Gadus chalcogrammus*             | Norwegian pollock             | *Gadus finnmarchicus*, *Theragra chalcogramma*, *Theragra finnmarchica* |
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
