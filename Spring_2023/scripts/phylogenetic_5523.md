### Bioinformatics Practical 3. Phylogentic inferences

**Aim of the practical**

**1)** To learn the principle of phylogenetic tree construction

**2)** Constructing a phylogenetic tree in R

# 1. Principle of tree construction

We will do a fun exercise before we do a real phylogenetic tree
construction. Can you place these new organisms in order? And give your
rationale for your placement of that organism in this tree.

![](https://raw.githubusercontent.com/bioinfo-arctic/FSK2053/main/Spring_2023/figures/phylogenetics.jpg)


### Building a phylogenetic tree using some anatomical characters

Table below contains charatcters to make our tree. + indicates presence
and 0 represents absence. This data taken from Principles of biology by
Robert Bear (table from khan academy) with some modifications.

![](https://raw.githubusercontent.com/bioinfo-arctic/FSK2053/main/Spring_2023/figures/phylogenetics2.png)

One important thing we should know from above table is what forms the
ancestral trait, and which are derived traits. This is important to make
a tree based on characters. An ancestral trait is what we think was
present in the common ancestor of the species of interest. Also, if the
trait is present only in the outgroup you can call it ancestral trait. A
derived trait is a trait or character that appears somewhere on a
lineage descended from common ancestor.

We will start building a phylogenetic tree now. Lampery lacks all the traits listed
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
    absent from the antelope). Based on this data, we can draw the
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

# 2. Constructing a phylogenetic tree in R

Phylogentics in R needs various packages such as `msa` (Bonatesta et
al), `bios2mds`,(Pele et al) and `phangorn` (Schliep et al). One benefit
of using R functions to calculate the phylogentic tree is that you dont
need some other software(s) which are many times OS dependent and hence,
unpredictable. Also you may need xquartz (https://www.xquartz.org) if you use macOS.

## 1. Install or load R packages

Some of the packages (phangorn, tinytex, and bios2mds) can be directly
downloadable from R studio “packages” tab. However, **msa package**
needs to be downloaded using **Bioconductor**. Bioconducotr is repository of r libraries centered around biomolecule analysis. Type “msa r package” in
google and find relevant bioconductor package. Read relevant information
about how to download msa.

 if (!require("BiocManager", quietly = TRUE))
      install.packages("BiocManager")
    BiocManager::install(version = "3.16")
    BiocManager::install("msa")
    
    # install packages using install.packages()

    # load packages
    library(tinytex)
    library(msa) 
    library(bios2mds) 
    library(phangorn) 
    system.file("tex", "texshade.sty", package="msa") # needed for Latex/Texshade related function to work
    
## 2. Alignment of nucleotide sequences

### 2.1 read sequences in fasta format into msa

To run any analysis in R one need to make an initial object (i.e., exporting a file from thr hardisk to R)

    mysequencefile <- readDNAStringSet("phylogenetics_tree.fasta", format = "fasta") # imports/reads fasta file into object called mysequencefile 
    mysequencefile # look into what is there in this object
### 2.2 run multiple alignemnt analysis using `muscle` program

This following step can lot of time, depending on number of sequences
and length. Here it will go fast.

    alignmuscle  <- msa(mysequencefile,method = "Muscle") # running multiple sequence alignment (msa) analysis using algorithm muscle

The following step is optional. The frame of reference for aligned
sequences is static (and already defined), so manipulation of these
objects is confined to be non-destructive. This means that the aligned
sequence objects contain properties to mask ranges of rows and columns
on the original sequence. These masks are then respected by methods that
manipulate and display the objects (such as tree building algorithm),
allowing the user to remove or keep columns and rows without
invalidating the original alignment. Follwing function will do this. We
will try to mask first 10 bases of alignment.

#### mask sequences

    myMaskedAlignment <- alignmuscle #rename object alignmuscle to myMaskedAlignment
    colM <- IRanges(start=1, end=10) #select ranges to mask
    colmask(myMaskedAlignment) <- colM #rename object colM
    myMaskedAlignment # view object with masked sequences
    
   This masked sequence can be used to make tree from unmasked bases (partial data). Try this alignment file to make a tree.

If you want to see alignments look pretty with different colours for
different bases as in some GUI based programs. We try one simple script usinf function msaPrettyPrint
There are lot of options in `msaPrettyPrint` function to make it more pretty

    msaPrettyPrint(alignmuscle, output="pdf", y=c(1, 633),
                   subset=c(1:6), showNames="none", showLogo="top",
                   logoColors="rasmol", shadingMode="similar",
                   showLegend=FALSE, askForOverwrite=FALSE)
                   
 Just check in your working directory, is there any pdf file with name alignment.pdf. If it is there then you are good. 
if not, 

You might see the following error message:

> Error in texi2dvi(texfile, quiet = !verbose, pdf = identical(output, “pdf”),  
> unable to run pdflatex

If this happened, it means that your computer is missing the Latex
program, that is responsible for generating the pdf image with the
pretty alignment. To solve this you will need to follow the steps below:

------------------------------------------------------------------------

#### Download and install the Latex program from this [link](https://www.latex-project.org/get/):

At the bottom of the page, choose the version that suits your operating
system:

1.  *MacTeX* for Macs
2.  *MikTex* for Windows
3.  *LinuxTex dist* for Linux

Click the link to the version you need to install, download it and
install it. After installing your version of Latex (MikTex, MacTex or
LinuxTex), search for it using your Mac `finder` or the windows search
bar and **open it**.

You will be prompted with a text editor like window. This is your Latex.
Go back to R and run the following command:

    msaPrettyPrint(alignmuscle, output="tex", y=c(1, 633),
                   subset=c(1:6), showNames="none", showLogo="top",
                   logoColors="rasmol", shadingMode="similar",
                   showLegend=FALSE, askForOverwrite=FALSE)

Observe that the value inside the parameter `output=` was changed from
**pdf** to **tex**, if this command ran without problems, you generated
a text file called `alignmuscle.tex`. Open this file using your *Latex*
program and hit run. After doing these steps, you should be prompted
with a question about installing the package `TeXshade` to generate the
pretty alignment PDF. Just accept the installation steps and you will
see your pretty alignment.

Having done all of that, your previous `msaPrettyPrint()`, with the
parameter `output="pdf"` will likely work. Maybe you need to close your
R studio and open it again… If nothing of that works, you won’t have a
pretty alignment to show for now :/

------------------------------------------------------------------------

Once you are done with alignment, next step is making the phylogenetic
tree. Follwing function converts a multiple sequence alignment
object to formats used in other sequence analysis packages. Benefit of
this is that you can directly proceed to other packages (such as phangorn) without reading
the input again.

    alignmentfish <- msaConvert(alignmuscle, type= "phangorn::phyDat")

optional: you may want to write alignment file to hard disk use
following command and use it someother non R based programs(example MEGA 11).

    alignusclealign <- msaConvert(alignmuscle, type = "bios2mds::align" ) # convert to align (bio2mds package) object.
if you dont convert to align format, you get error that "object of class 'align' or named list of 'class' expected"
    export.fasta(alignmuscle, outfile = "test_alignment.fa", ncol = 60, open = "w") # bio2mds function to write file to hardisk

Optional: if you want to read disk written alignment file
test_alignment.fa use following command.

    alignmentfish1 <-read.phyDat("test_alignment.fa", type = "dna", format = "fasta")

Now we will try to do some phylogenetic trees based on different
methods.

## 3. Phylogenetic tree construction

### 3.1 Distance based phylogenetic tree construction

First calculate a pairwise distance matrix (like a table, if there are 3 sequences to compare, you comapre distance (which is base difference) between seq 1 and 2, seq 1 and 3)

    dm <- dist.ml(alignmentfish)  #calculate distance matrix using dist.ml from phangorn
    dm # print matrix in R studio terminal

Now use object dm to costruct two distance based phylogenetic trees

    treeUPGMA  <- upgma(dm) #calculate upgma/NJ tree using upgma nad nj function from package phangron. 
    treeNJ  <- NJ(dm)

Plot trees using generic function. You can some other options within this function to make tree prettier. 

    plot(treeUPGMA, main="UPGMA")
    plot(treeNJ, "unrooted", main="NJ")

To get statistical significance values for branch split you need to
perform bootstrapping.

### 3.1a Run bootstrapping

Bootstrapping is a test or metric that uses random sampling with
replacement and falls under the broader class of resampling methods. 
The bootstrap value is the proportion of replicate phylogenies that 
recovered a particular clade from the original phylogeny that was 
built using the original alignment. Basic idea is building same tree
leaving out some portion of evidence (few bases are randomly removed from all the sequences at particular position) and check if same clades appear
even after leaving out some data. It uses sampling with replacement to estimate the sampling distribution for
the estimator (Ojha et al 2022). 

example: 
![](https://github.com/shri1984/study-images/blob/14bd0e4e8f9226b9e749f08e431f617b94a58159/3-s2.0-B9780128096338202598-f20259-01-9780128114148.jpg)
 
 in the above image different columns are taken for diferent boostrap runs with replacements. Colums are shuffled and tree is calculated. Here 2/3 times A|BC branching.
 
from Mariadossou et al 2019
 
First we need to write a function

    fun <- function(x) upgma(dist.ml(x)) ## function calculates distance first and then tree is calculated from distance matrix. function fun performs tree building on the input x (i.e alignemtn) using the upgma algorithm after calculating the pairwise distance between elements using dist.ml.

Then need to calculate boot strap values through bootstrap.phyDat
function from phangron.

    bs_upgma <- bootstrap.phyDat(alignmentfish, fun)

plot the bootstrap values on tree branches

    plotBS(treeUPGMA, bs_upgma, main="UPGMA") #plot bootstrap values

### 3.2 Parsimony based trees

Now we will caluclate parsimony score, which is the minimum number of
changes ncecessary to describe the data for a given tree type.

    parsimony(treeUPGMA, alignmentfish)

    parsimony(treeNJ, alignmentfish) #parsimony returns the parsimony score of a tree

#### Calculate parsimony tree

    treeRatchet  <- pratchet(alignmentfish, trace = 0, minit=100, maxit = 1000) # pratchet is an algorithm to calculate parsimony scores. lower number of iterations (maxit) for the example (to run less than 5 seconds), keep default values (maxit, minit, k) or increase them for real life analyses.
    parsimony(treeRatchet, alignmentfish)

    #assign edge length (number of substitutions)
    treeRatchet  <- acctran(treeRatchet,alignmentfish) 

    #remove edges of length 0 (0 substititutions)
    treeRatchet <- di2multi(treeRatchet) # deletes all branches smaller than branch length tolerance

    #### remove duplicate trees
    if(inherits(treeRatchet, "multiPhylo")){
      treeRatchet <- unique(treeRatchet)
    }

##### Root tree with option midpoint, a method to root the tree.

Midpoint rooting method calculates tip to tip distances and then places
the root point halfway between two longest tips.It assumes rate of
evolution is constant (equal substitution rates throught he branch) in the tree. It is an
ideal method if you lack a proper outgtoup (absence or lack of
knowledge), like in virus phylogenomics.

    plotBS(midpoint(treeRatchet), type="phylogram")
    add.scale.bar()

Outgroup rooting method assumes that one or more of the tax aee
divergent from the rest of the ingroup tax. The btanch linking the
ingroup and outgroup becoems the starting point and all the evolutionary
changes defined from here. One important thing is that you need to have
priori knowledge about the outgroup, when it is confusing,people either
choose close or very distant species as ourgroup. if you want to root a
tree with specific species (need prior knowledge) then you need to use
functions from package àpe\`.

    rooted_tree <- root(treeRatchet, outgroup = "KM224857_Esox_lucius", resolve.root = TRUE,
                           edgelabel = TRUE) # outgroup = look at the fasta header. you need exact name.
    add.scale.bar()

### 3.3 Maximum Likelihood

#### compare different nucleotide substitution models

    mt <- modelTest(alignmentfish, control=pml.control(trace=0))

As a first step, we will try to find the best fitting substition model.
For this we use the function `modelTest` to compare different nucleotide
or protein models with the AIC, AICc or BIC,

    fit <- as.pml(mt, "BIC") #choose best model based on BIC criteria

#### make a ml tree

Or let the program to choose best model based on the criteria (without you specifiying anything) and pass
it to tree building algorithm.

    fit_mt <- pml_bb(mt, control = pml.control(trace = 0))
    fit_mt

    bs <- bootstrap.pml(fit_mt, bs=100, optNni=TRUE, control = pml.control(trace = 0)) #do a standard bootstrapping 

    plotBS(midpoint(fit_mt$tree), bs, p = 50, type="p", main="Standard bootstrap") # plot trees with midpoint rooting 

    tree_stdbs <- plotBS(midpoint(fit_mt$tree), bs, p = 50, type="n", main="Standard bootstrap")
    ##assigning standard bootstrap values to our tree; this is the default method

#### exporting trees tree with standard bootstrap values in `newick` format.

    write.tree(tree_stdbs, "fish.tree")

Extra information: ’Beauti’fication of phylogenetic trees can be done
using `ggplot`and its associated package called `ggtree` can be used to
make trees more beautiful.

######## Reference: some scripts are taken from tutorial: estimating phylogenetic trees with phangorn
