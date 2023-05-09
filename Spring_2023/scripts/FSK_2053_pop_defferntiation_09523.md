# Bioinformatics Practical 4. Population differentiation

The genotype data for individuals appear in various formats, depending
on the analysis and software. The standard formats are gene pop (Raymond
and Rousset), structure (Pritchard et al.), and some specially made CSV
files (from genotyping machines). Various stand-alone (for Windows, Mac
and Linux) population genetics analysis tools exist. One limitation of
these stand-alone tools is that they may not calculate all the
population genetics measures in their platforms. Hence you need to
switch between the programs. Also, they may not get updated after a few
releases. Using R, we can bring together various packages that perform
similar anaysis. On top of that, these packages are free and available
for tons of tutorials. In this practical, we will use only R and learn
how to calculate some population genetics parameters. We will use a SNP
(single nucleotide polymorphism) data from European lobsters from
(Jenkins et al 2019).

Jenkins TL, Ellis CD, Triantafyllidis A, Stevens JR (2019). \[Single
nucleotide polymorphisms reveal a genetic cline across the north‐east
Atlantic and enable powerful population assignment in the European
lobster\]. Evolutionary Applications\_ 12, 1881--1899.

### Load or install packages

All the packages below can be downloaded from packages tab in R studio.
However you need to download a bioconductor package called "SNPRelate".
BiocManager::install("SNPRelate")

    Library(SNPRelate)
    library(adegenet)
    library(hierfstat)
    library(dplyr)
    library(reshape2)
    library(ggplot2)
    library(poppr)
    library(RColorBrewer)
    library(StAMPP)
    library(dartR)
    library(scales)

Read genepop formatted file to make a genind object (for `adegenet`
package Jombart et al).

#### read genepop formatted file

    lobster_gen <- read.genepop("lobster.gen", ncode = 2) # creates genind object. 
    lobster_gen #print contents of the object

#### print summary statistics from genind object

some examples:

     summary(lobster_gen$pop) ### sample size per population 
     
     summary(lobster_gen$loc.fac) ## number of alleles

#### Calculate basic stats

We will use functions from package `hierfstat`.

     basic_lobster = basic.stats(lobster_gen, diploid = TRUE)
     basic_lobster

#### Mean observed heterozygosity (Ho) per location (i.e., site)

    Ho_lobster = apply(basic_lobster$Ho, MARGIN = 2, FUN = mean, na.rm = TRUE) %>% round(digits = 2) #use of apply function to treat the columns to extract mean values. 
    Ho_lobster # print output

#### Mean expected heterozygosity (He) per location

    He_lobster = apply(basic_lobster$Hs, MARGIN = 2, FUN = mean, na.rm = TRUE) %>% round(digits = 2) #use of apply function to treat the columns to extract mean values.
    He_lobster

## Visualise heterozygosity per location

Before we make figure, we need to modify the Ho and He per location data
to feed to ggplot function.

#### Create a data.frame of site names, Ho and He and then convert to long format using 'melt' function from reshape2

    Het_lobster_df = data.frame(Site = names(Ho_lobster), Ho = Ho_lobster, He = He_lobster) %>% melt(id.vars = "Site")

#### Custom theme for ggplot2 and axis titles

Create ggplot object with customised theme.Themes are a powerful way to
customize the non-data components of your plots like figure title,
background, lable etc... Themes can be used to give plots a consistent
customized look.

     custom_theme = theme(
       axis.text.x = element_text(size = 10, angle = 90, vjust = 0.5, face = "bold"),
       axis.text.y = element_text(size = 10),
       axis.title.y = element_text(size = 12),
       axis.title.x = element_blank(),
       axis.line.y = element_line(size = 0.5),
       legend.title = element_blank(),
       legend.text = element_text(size = 12),
       panel.grid = element_blank(),
       panel.background = element_blank(),
       plot.title = element_text(hjust = 0.5, size = 15, face="bold")
     )
     
     hetlab.o = expression(italic("H")[o]) # create itlaics axis title 
     hetlab.e = expression(italic("H")[e]) # create italics axis title

#### plot lobster heterozygosity as a barplot

    ggplot(data = Het_lobster_df, aes(x = Site, y = value, fill = variable))+
      geom_bar(stat = "identity", position = position_dodge(width = 0.6), colour = "black")+
      scale_y_continuous(expand = c(0,0), limits = c(0,0.50))+
      scale_fill_manual(values = c("royalblue", "#bdbdbd"), labels = c(hetlab.o, hetlab.e))+
      ylab("Heterozygosity")+
      ggtitle("European lobster")+
      custom_theme

## calculating inbreeding coefficent (F~is~)

    apply (basic_lobster$Fis, MARGIN = 2, FUN = mean, na.rm = TRUE) %>% round(digits = 3)

# Computing pairwise Fst with probability values

F~st~ calculation is computation intensive, depending on the size of
dataset (i.e., populations, individuals and number of loci). We will
downsize the data to run the analysis faster. So in our case we need to
downsize main data using function called `popsub` from package `poppr`
by removing some populations.

#### reduce the population number to speed up computation

    lobster_gen_sub = popsub(lobster_gen, sublist = c("Ale","Ber","Brd","Pad","Sar17","Vig")) #subsamplign data by keeping only 6 population

#### Calculate Fst using stampp package

    lobster.gl<-gi2gl(lobster_gen_sub, parallel = TRUE) #converting data to genlight object from genind.
    lobster.stampp<-stamppConvert(lobster.gl, type = "genlight")
    lobster.pairwise.fst<-stamppFst(lobster.stampp, nboots = 500, percent = 95, nclusters = 14)
    lobster.pairwise.fst 

#### calculating pairwise F~st~ and associated confidence intervals using heirfstat package

We will use `genet.dist` function from package `heirfstat`.

    lobster_fst = genet.dist (lobster_gen_sub, method = "WC84") %>% round(digits = 3)
    lobster_fst
    boot.ppfst (lobster_gen_sub) # calculating bootstrap values/ confidence intervals

## visualise pairwise F~st~

first order the labels accordingly as you wish.

#### Desired order of labels

    lab_order = c("Ber","Brd","Pad","Vig","Sar17","Ale")

#### Change order of rows and cols

    fst.mat = as.matrix(lobster_fst)
    fst.mat1 = fst.mat[lab_order, ] # used to subset a matrix fst.mat based on a specific order once with rows and once with columns specified by lab_order.
    fst.mat2 = fst.mat1[, lab_order]

#### Create a data.frame

    ind = which(upper.tri(fst.mat2), arr.ind = TRUE) #is used to identify the indices of the upper triangle elements in a matrix fst.mat2

    fst.df = data.frame(Site1 = dimnames(fst.mat2) [[2]][ind[,2]],
                        Site2 = dimnames(fst.mat2)[[1]][ind[,1]],
                        Fst = fst.mat2[ ind ])

#### Keep the order of the levels in the data.frame for plotting

    fst.df$Site1 = factor(fst.df$Site1, levels = unique(fst.df$Site1))
    fst.df$Site2 = factor(fst.df$Site2, levels = unique(fst.df$Site2))

#### Convert minus F~st~ values to zero

Negative F~st~ has no meaning. F~st~ should be between 0 to 1. However
some time F~st~ can be negative because of the caluculation related
issues.

    fst.df$Fst[fst.df$Fst < 0] = 0 

#### Print data.frame summary

     fst.df %>% str

#### Extract middle Fst value for gradient argument

    mid = max(fst.df$Fst) / 2

#### Plot heatmap for pairwise F~st~

    ggplot(data = fst.df, aes(x = Site1, y = Site2, fill = Fst))+
    geom_tile(colour = "black")+
    geom_text(aes(label = Fst), color="black", size = 3)+
    scale_fill_gradient2(low = "blue", mid = "pink", high = "red", midpoint = mid, name = fst.label, limits = c(0, max(fst.df$Fst)), breaks = c(0, 0.05, 0.10, 0.15))+
    scale_x_discrete(expand = c(0,0))+
    scale_y_discrete(expand = c(0,0), position = "right")+
    theme(axis.text = element_text(colour = "black", size = 10, face = "bold"),
            axis.title = element_blank(),
            panel.grid = element_blank(),
            panel.background = element_blank(),
            legend.position = "right",
            legend.title = element_text(size = 14, face = "bold"),
            legend.text = element_text(size = 10)
      )

    fst.label = expression(italic("F")[ST]) #F~st~ italic label

## Principal Component Analysis (PCA) analysis of subsampled data

Principal components analysis (PCA) is one of the most useful and easy
and appealing techniques to visualise genetic diversity in a dataset.
PCA methodology is not restricted to genetic data and can be used for
morphological data too. In general, it is a useful analytical tool to
reduce the high-dimensional datasets (such as millions of SNP gentoype
per indidual(s)) to two or more dimensions for visualisation in a
two-dimensional space. PCA can be also used as exploraroty tool to
explore the quality of the data and to get the feel of the data. We will
use `dudi.pca` from `adegenet`.

PCA methods cannot handle missing data (NAs). So it is important to
either remove, or impute (mean) the missing values (here genotype).

#### Replace missing data with the mean allele frequencies

    x = tab(lobster_gen_sub, NA.method = "mean") #tab is function to impute missing genotype

#### Perform PCA on imupted genind object

    pca1 = dudi.pca(x, scannf = FALSE, scale = FALSE, nf = 3)
    pca1

#### Analyse how much percent of genetic variance is explained by each axis

    percent = pca1$eig/sum(pca1$eig)*100
    barplot(percent, ylab = "Genetic variance explained by eigenvectors (%)", ylim = c(0,12),
            names.arg = round(percent, 1))

#### Create a data.frame containing individual coordinates

    ind_coords = as.data.frame(pca1$li)

#### Rename columns of dataframe

    colnames(ind_coords) = c("Axis1","Axis2","Axis3")

#### Add a column containing individuals

    ind_coords$Ind = indNames(lobster_gen_sub)

#### Add a column with the site IDs

    ind_coords$Site = lobster_gen_sub$pop

#### Calculate centroid (average) position for each population

    centroid = aggregate(cbind(Axis1, Axis2, Axis3) ~ Site, data = ind_coords, FUN = mean)

#### Add centroid coordinates to ind_coords dataframe

    ind_coords = left_join(ind_coords, centroid, by = "Site", suffix = c("",".cen"))

#### Define colour palette

    cols = brewer.pal(nPop(lobster_gen_sub), "Set1") #from library(RColorBrewer)

#### Customise x and y labels

    xlab = paste("Axis 1 (", format(round(percent[1], 1), nsmall=1)," %)", sep="")
    ylab = paste("Axis 2 (", format(round(percent[2], 1), nsmall=1)," %)", sep="")

#### Customised theme for ggplot2

    ggtheme = theme(axis.text.y = element_text(colour="black", size=12),
                    axis.text.x = element_text(colour="black", size=12),
                    axis.title = element_text(colour="black", size=12),
                    panel.border = element_rect(colour="black", fill=NA, size=1),
                    panel.background = element_blank(),
                    plot.title = element_text(hjust=0.5, size=15) 
    )

#### Scatter plot axis 1 vs. axis 2

    ggplot(data = ind_coords, aes(x = Axis1, y = Axis2))+
      geom_hline(yintercept = 0)+
      geom_vline(xintercept = 0)+
      # spider segments
      geom_segment(aes(xend = Axis1.cen, yend = Axis2.cen, colour = Site), show.legend = FALSE)+
      # points
      geom_point(aes(fill = Site), shape = 21, size = 3, show.legend = FALSE)+
      # centroids
      geom_label(data = centroid, aes(label = Site, fill = Site), size = 4, show.legend = FALSE)+
      # colouring
      scale_fill_manual(values = cols)+
      scale_colour_manual(values = cols)+
      # custom labels
      labs(x = xlab, y = ylab)+
      ggtitle("Lobster PCA")+
      # custom theme
      ggtheme

Repeat the above command with yend = Axis3.cen to make scatter plot for
axis 1 and axis 3.

###### Reference

Modified from
https://tomjenkins.netlify.app/tutorials/r-popgen-getting-started/#5.
