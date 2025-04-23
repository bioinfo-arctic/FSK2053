# Phylogentic inferences

**Aim of the practical**

**1)** To learn the principles of phylogenetic tree construction

**2)** To build a basic phylogenetic tree from morphological characters

**3)** To build phylogenetic trees using representative DNA sequences in R

# Principle of tree construction

We will do a fun group exercise before we construct a real phylogenetic tree (20 minutes in groups). How would you place these organisms in a phylogenetic tree? Give your rationale for why you would design your tree that way.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2024/images/q1.jpeg)

## Building a phylogenetic tree using a set of morphological characters

The table below contains the characters we need to make our tree. A "+" indicates presence of a character, whereas "0" represents absence. This data does not necessarily reflect the true evolutionary history of these organisms, but is simply a subset of characters used to build a tree.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2024/images/q2.png)

A key feature to learn here is what forms the "ancestral trait", and which reflect "derived traits". These concepts are important when making a tree based on morphological characters. An ancestral trait is what we believe was present in the common ancestor of the species of interest. Also, if the trait is present only in the outgroup you can call it an ancestral trait. A derived trait is a trait or character that appears somewhere on a lineage descended from a recent common ancestor.

We will start building a tree now. Lampery lacks all the traits listed
in the table. Hence we can assume that ancestors for these group of
organisms lacked these listed traits. Presence of any or all features
indicates they are derived traits.

1.  Which of these characters are mostly shared by ? Jaws. Present in
    all except lampreys. So start off with drawing lamprey branching off
    from the rest.

2.  What’s the next character shared by most of the species? Next, we
    can look for the derived trait shared by the next-largest group of
    organisms. This would be lungs, shared by the antelope, bald eagle,
    and alligator, but not by the sea bass. Based on this pattern, we
    can draw the lineage of the sea bass branching off, and we can place
    the appearance of lungs on the lineage leading to the antelope, bald
    eagle, and alligator.

3.  Following the same pattern, we can now look for the derived trait
    shared by the next-largest number of organisms. That would be the
    gizzard, which is shared by the alligator and the bald eagle (and
    absent in antelope). Based on this data, we can draw the
    antelope lineage branching off from the alligator and bald eagle
    lineage, and place the appearance of the gizzard on the latter.

4.  What about our remaining traits of fur and feathers? These traits
    are derived, but they are not shared, since each is found only in a
    single species. Derived traits that aren’t shared by many don’t help
    us build a tree, but we can still place them on the tree in their
    most likely location. For feathers, this is on the lineage leading
    to the bald eagle (after divergence from the alligator). For fur,
    this is on the antelope lineage, after its divergence from the
    alligator and bald eagle.

# Constructing a phylogenetic tree in R

Phylogentics in R needs various packages such as `msa` (Bonatesta et
al), `bios2mds`,(Pele et al) and `phangorn` (Schliep et al). One benefit
of using R functions to calculate the phylogentic tree is that you dont
need some other software(s) which are many times OS dependent and hence,
unpredictable.

## 1. Install or load R packages

Some of the packages (***phangorn***, ***ape***, ***ggplot2*** and ***bios2mds***) can be directly
downloadable from R studio “packages” tab. ggplot2 might have been already there from data science part. However, **msa package** and **ggmsa**
needs to be downloaded using **Bioconductor**. Type ***“msa r package”*** in
google and find relevant bioconductor package. Read relevant information
about how to download msa. First you may need to download package downloader called **bioconductor**. If you have issues with ***bios2mds*** package installation, then download .tar.gz file from here: https://cran.r-project.org/web/packages/bios2mds/index.html and untar it. Then upload the file export_fast.R into and run the fucion. Ir will be avilable for use. 

```
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("msa")

BiocManager::install("ggmsa")

```
```
#load packages
library(msa) 
library(bios2mds) 
library(phangorn) 
library(ape)
library(stats)
library(ggplot2)
library(ggmsa)

```

## Alignment of nucleotide sequences

### Read sequences in fasta format into msa (Multiple Sequence Alignment) algorithm

```
mysequencefile <- readDNAStringSet("phylogenetics_tree_final_24424.fasta", format = "fasta")

```

### Run multiple alignemnt analysis using `ClustalOmega` program in msa

This following step can lot of time, depending on number of sequences
and length. Here it will go fast.

```
alignomega  <- msa(mysequencefile, method = "ClustalOmega")

align <- msaConvert(alignomega, type= "bios2mds::align")

align_phydata <- msaConvert(alignomega, type= "phangorn::phyDat")

```

you can write alignment data to a file instead of keeping it in an R object, use

```
export.fasta(align, outfile = "myAlignment.fasta", ncol = 60, open = "w")

```

Now open the file myAlignment.fasta in bbedit and see the content. You see there is string of NAs at the end of each fasta sequence. It is a bug from the package.I cant figureout what is happening. We will remove them manually. 

If ypu want to visualise and annotation of multiple sequence alignment such as myAlignment.fasta in, use function ggmsa from ggmsa package. 

```
ggmsafile<- "/Users/sbh001/Library/CloudStorage/OneDrive-UiTOffice365/course-FSK2053/lecture3_phylogenetics/myAlignment.fasta"

ggmsa(ggmsafile, 300, 350, color = "Chemistry_NT", font = "TimesNewRoman", char_width = 0.5, seq_name = TRUE ) + geom_seqlogo() + geom_msaBar()  # see alignment in colurful format.

```

Once you are done with alignment, next step is making the phylogenetic
tree from those alignment. This follwing function converts a multiple sequence alignment
object to formats used in other sequence analysis packages. Benefit of
this is that you can directly proceed to other packages without reading
the input again. Here we will convert msa object into DNAbin object reqired by paclakge ***ape***.

```
alignment_dnabin <- msaConvert(alignomega, type= "ape::DNAbin")

align_phydata <- msaConvert(alignomega, type= "phangorn::phyDat")

```

Now we will try to do some phylogenetic trees based on different
methods.

## Phylogenetic tree construction

Distance-based trees are produced by calculating the genetic distances between pairs of taxa/species/measurements, followed by hierarchical clustering that creates the actual “tree” look. Two popular clustering methods that are used most frequenctly for distance based clustering method are UPGMA and NJ algorithms.

UPGMA- this is the simplest method for constructing trees, assumes the same evolutionary speed for all lineages (which can be a disadvantage); all leaves have the same distance from the root (creates ultrametric tree). Ultrametric tree is the one where distance from root to every type tip are equal. This tree is  often used to represent hierarchical clustering of sequences and species, showcasing the evolutionary time from the last common ancestor. UPGMA is one such type of tree.

Neighbor-joining- taking the two closest nodes of the tree and defines them as neighbors; you keep doing this until all of the nodes have been paired together. This forms the example for addtive type of tree, also known as metric trees. In this type branch lengths accurately represent the genetic distance or evolutionary change between species or sequences. 


### Distance based phylogenetic tree construction

First calculate a distance matrix from ***ape** package using dist.dna function.  

```
D <- dist.dna(alignment_dnabin, model = "TN93")  #just the type of evolutionary model we’re using, this particular one allows for different transition rates, heterogenous base frequencies, and variation of substitution rate at the same site

length(D) #number of pairwise distances, computed as n(n-1)/2

```
Now use object D, which is distance matrix to costruct two distance based phylogenetic trees. There are lot of functions in R to build distance based phylogenetic tree. But we will use few of them here mainly from ***ape*** package

```
treeNJ <- nj(D)

class(treeNJ) #all trees created using ape package will be of class phylo

treeNJ # tells us what the tree will look like but doesn't show the actual construction

treeUPGMA <- upgma(D, "centroid") #This tree is called an ultrametric tree, 

treeUPGMA


```
Plot trees using generic function. But you can play around and make colourful trees using different functions and packages. 

```
treeUPGMA <- ladderize(treeUPGMA) #This function reorganizes the internal structure of the tree to get the ladderized effect when plotted

plot(treeUPGMA, main="A Simple UPGMA Tree")

add.scale.bar()

treeNJ <- ladderize(treeNJ) #This function reorganizes the internal structure of the tree to get the ladderized effect when plotted

plot(treeNJ, type = "phylogram", main="A Simple NJ Tree", show.tip=FALSE)

add.scale.bar()

```
if you want make rooted NJ treee, then you need mention outgroup to which root your tree. This is one of the few ways you can root a tree. Other method is midpoint rooting. 

```
treeNJroot <- root(treeNJ, outgroup = "Esox_lucius", resolve.root = TRUE, edgelabel = TRUE)

treeNJroot <- ladderize(treeNJroot) #This function reorganizes the internal structure of the tree to get the ladderized effect when plotted

plot(treeNJroot, show.tip=FALSE, edge.width=2, main="Rooted NJ tree")

add.scale.bar()

```
As we have lot of options to make a phylogenetics trees, we have to make sure that the alogrithm we chose to make tree is the right one to explain the sequence data. We need to test what type of algorithm explains the data well (NJ or UPGMA?)

### choosing 'right' algorithm 

We will use correlation analysis between the calculated distance between the taxa and ***cophenetic distance*** to choose the the right tree. The two observations that have been clustered is defined to be the intergroup dissimilarity at which the two observations are first combined into a single cluster. 

```
x <- as.vector(D) # convert D as vector
y <- as.vector(as.dist(cophenetic(tre2))) # caluclate cophentic distance from tre2 and convert it to vector. Cophenetic function computes distances between the tips of the trees
plot(x, y, xlab="original pairwise distances", ylab="pairwise distances on the tree", main="Is UPGMA appropriate?", pch=20, col="red", cex=3)
abline(lm(y~x), col="red")
cor(x,y)^2

#### UPGMA tree
y <- as.vector(as.dist(cophenetic(treeUPGMA)))
plot(x, y, xlab="original pairwise distances", ylab="pairwise distances on the tree", main="Is UPGMA appropriate?", pch=20, col="red", cex=3)
abline(lm(y~x), col="red")
cor(x,y)^2

```
choose right tree and proceed to bootstrapping.

### Run bootstrapping

Bootstrapping is a test or metric that uses random sampling withreplacement and falls under the broader class of resampling methods. It
uses sampling with replacement to estimate the sampling distribution for
the estimator (Ojha et al 2022). Basic idea is building same tree
leaving out some portion of evidence (some bases from a sequence) and check if same clades appear
even after leaving out some data.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2024/images/boot.jpeg)

First we need to write a function. boot.phylo needs FUN because, it uses this function to build the resample phylogenetic tree for bootstrap purpose. 

```
fun <- function(x) root(nj(dist.dna(x, model = "TN93")),1) ## function calculates distance first and then tree is calculated from alignment. Function fun performs tree building on the input x using the upgma algorithm after calculating the pairwise distance between elements using dist.dna. It construct a neighbor-joining (NJ) phylogenetic tree based on the Tamura-Nei 93 (TN93) distance model, and then root the resulting tree using the first taxon (or sequence) in the dataset as the outgroup

```
Then need to calculate boot strap values through bootstrap.phyDat function from phangron.

```
bs_nj <- boot.phylo(treeNJroot, alignment_dnabin, fun) # performs the bootstrap automatically for us

bs_nj
```

plot the bootstrap values on tree branches like below 

```
plot(treeNJroot, show.tip=FALSE, edge.width=2, main = "NJ tree + bootstrap values") #plot bootstrap values

add.scale.bar()

nodelabels(bs_nj, cex=.6) # adds labels to or near the nodes

```
How does node support looks? the numbers shown by nodelabels() show how many times each node appreared in the bootstrapped trees. If the numbers by each node are pretty low, meaning there’s not a huge overlap between the nodes in our original tree and the nodes in the bootstrapped tree. Tt means that some of the nodes aren’t supported.


### Parsimony based trees

Now we will caluclate parsimony score, which is the minimum number of changes ncecessary to describe the data for a given tree type. Parsimony returns the parsimony score of a tree. Parsimony analysis needs a base tree. We will use treeNJ from first part of the analysis as base tree.

```
align_phydata <- msaConvert(alignomega, type= "phangorn::phyDat")

parsimony(treeNJroot, align_phydata)  

tre.pars.nj <- optim.parsimony(treNJ, align_phydata) # it used whole sequences to make a tree, unlike distance based trees such as nj or upgma. 

tre.pars.nj

parsimony(tre.pars.nj, align_phydata)

plot(tre.pars.nj, type="unr", show.tip=FALSE, edge.width=2, main = "Maximum-parsimony tree") #it has lower parsimonious score compare to the original tree. try other type 

```

if you want to download or write the file in newick or nexus format then use following command.

```
write.tree(tre4, file="tre.tree") 

```
You can open this tree file using a program called figtree (http://tree.bio.ed.ac.uk/software/figtree/).


Extra information: ’Beauti’fication of phylogenetic trees can be done
using `ggplot`and its associated package called `ggtree` can be used to
make trees more beautiful.

######## Reference: some scripts are taken from tutorial: estimating phylogenetic trees with phangorn
