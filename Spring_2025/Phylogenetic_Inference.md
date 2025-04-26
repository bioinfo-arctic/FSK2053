# Phylogenetic inferences

**Aim of the practical**

**1)** To learn the principles of phylogenetic tree construction

**2)** To build a basic phylogenetic tree from morphological characters

**3)** To build phylogenetic trees using representative DNA sequences in R

# Principles of phylogenetic tree construction

We will do a fun group exercise before we construct a real phylogenetic tree (20 minutes in groups). Start drawing on a piece of paper or in Paint on your PC - whatever works for you. How would you place these organisms in a phylogenetic tree? Give your rationale for why you would design your tree that way.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2024/images/q1.jpeg)

## Building a phylogenetic tree using a set of morphological characters

Using the same groups as before, we will now explore an evolutionary scenario with morphological characters as our traits. The table below contains the characters we need to make our tree. A "+" indicates presence of a character, whereas "0" represents absence. This data does not necessarily reflect the true evolutionary history of these organisms, but is simply a subset of characters that we here use to build a tree.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2024/images/q2.png)

A key feature to learn here is the difference between **ancestral traits** and **derived traits**. These concepts are important when making a tree based on morphological characters. An ancestral trait is what we believe was present in the common ancestor of the species of interest. If the trait is only present in the outgroup, we also assume that it is an ancestral trait. A derived trait is a trait that appears somewhere on a lineage descended from a recent common ancestor.

In your groups, we will start building a tree based on these characters. Start drawing on a piece of paper or in Paint on your PC - whatever works for you. Note how the lamprey lacks all the traits listed in the table? We can assume that ancestors for the lamprey lacked all these listed traits. Presence of any or all features therefore indicates that they are derived traits.

1.  Which of these characters are shared by the most organisms? Jaws. Jaws are present in all of them, except lampreys. So start off with drawing lamprey branching off from the rest.

2.  What’s the next character shared by most of the species? Here, we are looking for the derived trait shared by the next-largest group of organisms. This would be lungs, shared by the antelope, bald eagle, and alligator, but not by the sea bass. Based on this pattern, we can draw the lineage of the sea bass branching off, and we can place the appearance of lungs on the lineage leading to the antelope, bald eagle, and alligator.

3.  Following the same pattern, we again look for the derived trait shared by the next-largest number of organisms. That would be the gizzard, which is shared by the alligator and the bald eagle (and absent in antelope). Based on this data, we can draw the antelope lineage branching off from the alligator and bald eagle lineage, and place the appearance of the gizzard on the latter.

4.  What about our remaining traits of fur and feathers? These traits are derived, but they are not shared, since each is found only in a single species. Derived traits that aren’t shared by multiple organisms do not help us when building a tree, but we can still place these traits on the tree in their most likely location of origin. For feathers, this is on the lineage leading to the bald eagle (after divergence from the alligator). For fur, this is on the antelope lineage, after its divergence from the alligator and bald eagle.

# Constructing a phylogenetic tree in R

Phylogenetics in R can be performed with various packages such as `msa` (Bodenhofer et al., 2015), `bios2mds` (Pele et al., 2012), and `phangorn` (Schliep et al., 2011). One benefit of using R functions to create phylogentic trees is that you don't need other software(s) which are often OS dependent and hence, unpredictable. R is where we do most of our statistical analyses, models and visual representations anyway, so why not do phylogenetic trees here too?

## 1. Install or load R packages

Some of the packages (***phangorn***, ***ape***, ***ggplot2*** and ***bios2mds***) can be directly downloaded from R studio as packages (remember ***install.packages()***?). ggplot2 is likely already installed from the Data Science part of the course. However, the **msa** and **ggmsa** packages need to be downloaded using **Bioconductor**. If you have issues, type ***“msa r package”*** in Google and find the relevant bioconductor package. Read through the relevant information about how to download msa. First you may need to download the package downloader called **bioconductor**. If you have issues with ***bios2mds*** package installation, then download the .tar.gz file from here: https://cran.r-project.org/web/packages/bios2mds/index.html and find the ***export_fasta.R*** function. Then you can load it into R and run the function that way.

```
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("msa")

BiocManager::install("ggmsa")
```
```
# Load packages
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
mysequencefile <- readDNAStringSet("phylogenetic_tree_data_FSK2053.fasta", format = "fasta")
```

### Run the multiple alignment analysis using `ClustalOmega` program with msa

The following step can take lot of time, depending on the number of sequences being analysed and their lengths. Here it will go fast.

```
alignomega  <- msa(mysequencefile, method = "ClustalOmega")
align <- msaConvert(alignomega, type = "bios2mds::align")
align_phydata <- msaConvert(alignomega, type = "phangorn::phyDat")
```

You can write the alignment data to a file instead of keeping it in an R object, use:

```
export.fasta(align, outfile = "myAlignment.fasta", ncol = 60, open = "w")
```

Now open the file myAlignment.fasta in bbedit, notepad++, or notepad, and check the contents. You see there is string of NAs at the end of each sequence. This is a bug from the package, which we can't figure out why is happening. Instead, we will remove the NA's manually and save the file.

If you want to visualise and see the annotation of multiple sequence alignments such as myAlignment.fasta in, you can use the function ggmsa from the ggmsa package. 

```
ggmsafile<- "C:/Users/marei5443/OneDrive - UiT Office 365/Dokumenter/Scientist, UiT/Teaching/FSK-2053_Data_Science_and_Bioinformatics/2025/myAlignment.fasta"
ggmsa(ggmsafile, 300, 350, color = "Chemistry_NT", font = "TimesNewRoman", char_width = 0.5, seq_name = TRUE) +
    geom_seqlogo() +
    geom_msaBar()  # see alignment in a neat, colorful format.
```

Once you are done preparing the alignment, the next step is to make the phylogenetic tree from the alignment. The following function converts a multiple sequence alignment object to formats used in other sequence analysis packages. The benefit of this is that you can directly proceed to other packages without reading the input again. Here, we will convert an msa object into a DNAbin object as required by the ***ape*** package.

```
alignment_dnabin <- msaConvert(alignomega, type= "ape::DNAbin")
align_phydata <- msaConvert(alignomega, type= "phangorn::phyDat")
```

Now we will try to do some phylogenetic trees based on different methods.

## Phylogenetic tree construction

Distance-based trees are produced by calculating the genetic distances between pairs of taxa/species/measurements, followed by hierarchical clustering that creates the actual “tree” topography. Two popular clustering methods that are frequently used for distance based clustering are UPGMA ("unweighted pair group method with arithmetic mean") and NJ ("Neighbour-joining") algorithms.

UPGMA: This is the simplest method for constructing trees. It assumes the same evolutionary rate or speed for all lineages (which is good for simplicity, but likely doesn't reflect reality). All terminal nodes/tips/leaves have the same distance from the root (also called an ***ultrametric tree***). Ultrametric trees have the same distance from the root to every single tip/leaf in the tree. This tree is  often used to represent hierarchical clustering of sequences and species, showcasing the evolutionary time from the last common ancestor. UPGMA is one such type of tree.

Neighbor-joining: Takes the two closest nodes of the tree and defines them as being neighbors. We essentially keep doing this until all of the nodes have been paired together. This forms the example for an additive type of tree, also known as ***metric trees***. In this type of trees, branch lengths represent the genetic distance or evolutionary change between species or sequences.

### Distance based phylogenetic tree construction

First, we calculate a distance matrix using the dist.dna function from the ***ape*** package.

```
D <- dist.dna(alignment_dnabin, model = "TN93")  # TN93 is an evolutionary model, allowing for different transition rates, heterogenous base frequencies, and variation of substitution rate at the same site
length(D) # Corresponds to the number of pairwise distances, computed as n(n-1)/2
```
Now we use the object D, which is distance matrix, to costruct two distance based phylogenetic trees. There are lots of functions in R to build distance based phylogenetic trees. Here, we will focus only on a few of them from the ***ape*** package.

Here we make NJ and UPGMA trees.

```
treeNJ <- nj(D)
class(treeNJ) # all trees created using the ape package functions will be of the class "phylo"
treeNJ # tells us what the tree will look like but doesn't show the actual construction
treeUPGMA <- upgma(D, "centroid") # this tree is called an ultrametric tree
treeUPGMA
```
Next, we plot the trees using the generic plot function.

```
treeUPGMA <- ladderize(treeUPGMA) # this function reorganizes the internal structure of the tree to get the ladderized effect when plotted
plot(treeUPGMA, main = "A simple UPGMA tree")
add.scale.bar()
treeNJ <- ladderize(treeNJ) # same ladderize effect as above
plot(treeNJ, type = "phylogram", main="A simple NJ tree", show.tip=FALSE)
add.scale.bar()
```
If you want to make a rooted NJ tree, then you need to define what is your outgroup. This is one of the few ways you can root a tree. Another method is midpoint rooting, which we will not do here. 

```
treeNJroot <- root(treeNJ, outgroup = "Esox_lucius", resolve.root = TRUE, edgelabel = TRUE)
treeNJroot <- ladderize(treeNJroot) # same ladderize effect as above
plot(treeNJroot, show.tip=TRUE, edge.width=2, main="Rooted NJ tree")
add.scale.bar()
```
We have a lot of options when making phylogenetic trees, but we should make sure that the algorithm we choose to make the tree is in fact the right one to explain the sequence data. We therefore need to test what type of algorithm explains the data best (NJ or UPGMA?)

### Choosing the 'right' algorithm 

We will use correlation analysis between the calculated distance between the taxa and the ***cophenetic distance*** to choose the right tree. The two observations that have been clustered are defined to be the intergroup dissimilarity at which the two observations are first combined into a single cluster. 

```
x <- as.vector(D) # convert D as vector.
y <- as.vector(as.dist(cophenetic(treeNJ))) # calculate cophenetic distance from treeNJ and convert it to a vector. The cophenetic function computes distances between the tips of the trees.
plot(x, y, xlab="original pairwise distances", ylab="pairwise distances on the tree", main="Is NJ appropriate?", pch=20, col="red", cex=3)
abline(lm(y~x), col="red")
cor(x,y)^2

#### UPGMA tree
y <- as.vector(as.dist(cophenetic(treeUPGMA)))
plot(x, y, xlab="original pairwise distances", ylab="pairwise distances on the tree", main="Is UPGMA appropriate?", pch=20, col="red", cex=3)
abline(lm(y~x), col="red")
cor(x,y)^2
```

Which tree was the most appropriate? Choose the right tree and proceed to bootstrapping.

### Run bootstrapping

Bootstrapping is an approach that uses random sampling with replacement and falls under the broader class of resampling methods. It uses sampling with replacement to estimate confidence for the different branches in the estimated tree topology. The basic idea is to build the tree iteratively, each time leaving out some portion of evidence (i.e. some bases from a sequence), and to check if the same clades consistently appear even when leaving out some of the data.

![](https://github.com/bioinfo-arctic/FSK2053/blob/main/Spring_2024/images/boot.jpeg)

First, we will need to write a function. boot.phylo needs this function to resample and rebuild the phylogenetic tree to obtain the bootstrap values.

```
fun <- function(x) root(nj(dist.dna(x, model = "TN93")),1) ## the function calculates the distance first, and then the tree is calculated from the alignment. The function performs tree building on the input x using the upgma algorithm after calculating the pairwise distance between elements using dist.dna. It constructs a neighbor-joining (NJ) phylogenetic tree based on the Tamura-Nei 93 (TN93) distance model, and then roots the resulting tree using the first taxon (or sequence) in the dataset as the outgroup.
```
Then we need to calculate bootstrap values through the bootstrap.phyDat function from phangorn.

```
bs_nj <- boot.phylo(treeNJroot, alignment_dnabin, fun) # performs the bootstrap automatically for us
bs_nj
```

plot the bootstrap values on tree branches like below 

```
plot(treeNJroot, show.tip=TRUE, edge.width=2, main = "NJ tree + bootstrap values") #plot bootstrap values
add.scale.bar()
nodelabels(bs_nj, cex=.6) # adds labels to or near the nodes
```
How does node support looks? the numbers shown by nodelabels() show how many times each node appreared in the bootstrapped trees. If the numbers by each node are pretty low, meaning there’s not a huge overlap between the nodes in our original tree and the nodes in the bootstrapped tree. Tt means that some of the nodes aren’t supported.


### Parsimony based trees

Now we will caluclate parsimony score, which is the minimum number of changes ncecessary to describe the data for a given tree type. Parsimony returns the parsimony score of a tree. Parsimony analysis needs a base tree. We will use treeNJ from first part of the analysis as base tree.

```
align_phydata <- msaConvert(alignomega, type= "phangorn::phyDat")
parsimony(treeNJroot, align_phydata)
tre.pars.nj <- optim.parsimony(treeNJ, align_phydata) # it used whole sequences to make a tree, unlike distance based trees such as nj or upgma. 
tre.pars.nj
parsimony(tre.pars.nj, align_phydata)
plot(tre.pars.nj, type="unr", show.tip=FALSE, edge.width=2, main = "Maximum-parsimony tree") # it has lower parsimonious score compare to the original tree. try other type 
```

if you want to download or write the file in newick or nexus format then use following command.

```
write.tree(tre.pars.nj, file="tree_example.tree")
```
You can open this tree file using a program called figtree (http://tree.bio.ed.ac.uk/software/figtree/).

Extra information: ’Beauti’fication of phylogenetic trees can be done using `ggplot`and its associated package called `ggtree` can be used to make trees more beautiful.
If you are interested, you can play around with and make colourful trees using different functions and packages at home. For example using the package "ggtree", which has a lot of really cool features. You can see more here: https://yulab-smu.top/treedata-book/.

### References:

    Bodenhofer U, Bonatesta E, Horejs-Kainrath C, Hochreiter S (2015). “msa: an R package for multiple sequence alignment.” Bioinformatics, 31(24), 3997–3999. doi:10.1093/bioinformatics/btv494.

    Pelé J, Bécu JM, Abdi H, Chabbert M. Bios2mds: an R package for comparing orthologous protein families by metric multidimensional scaling. BMC Bioinformatics. 2012 Jun 15;13:133. doi: 10.1186/1471-2105-13-133. PMID: 22702410; PMCID: PMC3403911.

    Klaus Peter Schliep, phangorn: phylogenetic analysis in R, Bioinformatics, Volume 27, Issue 4, February 2011, Pages 592–593, https://doi.org/10.1093/bioinformatics/btq706

Furthermore, inspiration for this practical was found from the tutorial called: "estimating phylogenetic trees with phangorn": https://cran.r-project.org/web/packages/phangorn/vignettes/Trees.html
