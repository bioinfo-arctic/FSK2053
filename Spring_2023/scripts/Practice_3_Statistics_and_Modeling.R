###############################################################################################################
### In this hands-on session we will see examples of basic hypothesis testing for different types of variables
### and we will see how to perform simple linear models in R
###############################################################################################################

############ Install and load packages FSAdata and FSA with different datasets related to fisheries
# install.packages("FSA")
# install.packages("FSAdata")

if (!require('devtools')) install.packages('devtools'); require('devtools')
devtools::install_github('droglenc/FSAmisc')

library(tidyverse)
library(FSA)
library(FSAdata)
# FSAdata: Data to Support Fish Stock Assessment ('FSA') Package


# Load data from Greens Creek Mine
dat_greens <- as_tibble(GreensCreekMine)
# See info in: http://derekogle.com/fishR/data/data-html/GreensCreekMine.html 

# Transform the data to tidy format
dat_green_tidy <- dat_greens %>% pivot_longer(c(set1,set2,set3),names_to = "set",values_to = "catch")
dat_green_tidy

# Explore the data (load the library RColorBrewer first):

library("RColorBrewer")

display.brewer.all(colorblindFriendly = TRUE)

dat_green_tidy %>% ggplot(aes(x=species,y=catch)) +
  geom_boxplot(aes(fill=species)) +
  geom_jitter(aes(color=species),width = 0.25, alpha = 0.8) +
  scale_color_brewer(palette="Dark2") +
  scale_fill_brewer(palette="Set2")

dat_green_tidy %>%  ggplot(aes(x=species,y=catch)) +
  geom_jitter(aes(color=species),width = 0.25, alpha = 0.8) +
  scale_color_brewer(palette="Dark2") 

dat_green_tidy %>%  ggplot(aes(x=species,y=catch)) +
  geom_boxplot(aes(fill=species)) +
  scale_fill_brewer(palette="Set2")


#####################################################################################
#### TEST for differences between two numerical variables (or two independent samples)
#####################################################################################
# We will test if there are significant differences between the catches of both species
# First we will check the distribution of the catch for both species
dat_green_tidy %>%  ggplot(aes(x=catch)) +
  geom_histogram(aes(group=species,fill=species)) +
  scale_fill_brewer(palette="Set2")
dat_green_tidy %>%  ggplot(aes(x=catch)) +
  geom_density(aes(group=species,fill=species), alpha=.5) +
  scale_fill_brewer(palette="Set2")

#### NORMALITY TEST
# They do not look to follow normal distributions. We can check this using the QQ-plot and the Shapiro-Wilk test
# install.packages("ggpubr")
library(ggpubr) # This is for function ggqqplot()


# Get the data for both species as separate vectors
catch_coho <- dat_green_tidy %>% filter(species=="Coho.Salmon") %>% pull(catch) 
catch_dolly <- dat_green_tidy %>% filter(species=="Dolly.Varden") %>% pull(catch)
ggqqplot(catch_coho)
shapiro.test(catch_coho)
ggqqplot(catch_dolly)
shapiro.test(catch_dolly)
# The p value of the Shapiro-Wilk test is < 0.05 
# So there are significant differences between the normal distribution and the experimental values.

##### HOMOSCEDASTICITY TEST
library(car)
bartlett.test(dat_green_tidy$catch,dat_green_tidy$species)
leveneTest(catch ~ species, data = dat_green_tidy)
# The variances are not homogeneous either

# So we cannot use any parametric test. But we still can use the Wilcoxon ranks test (non-parametric)
wilcox.test(catch_coho,catch_dolly)
# The p-value is < 0.05 so the differences between both species are significant
### If both variables were normally distributed, we could have used Student's t.test
t.test(catch_coho,catch_dolly)
# However this is not correct with our data

###################################################################################
### Test for differences among two or more groups of numerical variables
###################################################################################

# Actually, the catch data for these two fishes come from three sequential catches (sets 1, 2 & 3) 
dat_green_tidy %>%  
  ggplot(aes(x=set,y=catch)) +
  geom_boxplot(aes(fill=species)) +
  geom_jitter(aes(color=species),width = 0.25, alpha = 0.8) +
  scale_color_brewer(palette="Dark2") +
  scale_fill_brewer(palette="Set2") +
  facet_wrap(~ species)

#### We are going to check for differences among the three sets for a single species (Coho salmon)
### If we want to use an ANOVA, we need to check for homoscedasticity and for normality of the residuals.
dat_coho <- dat_green_tidy %>% filter(species=="Coho.Salmon") 
anova_test_coho <- aov(catch ~ set, data=dat_coho)
summary(anova_test_coho)
plot(anova_test_coho)
# Check for normality of residuals:
residuals_coho <- anova_test_coho$residuals
ggplot(as_tibble(residuals_coho),aes(residuals_coho)) + geom_histogram()
shapiro.test(residuals_coho)
ggqqplot(residuals_coho)
# Check for homoscedasticity:
leveneTest(catch ~ set, data = dat_coho)
leveneTest(catch ~ as.factor(set), data = dat_coho) # having set as a factor won't give a warning
bartlett.test(dat_coho$catch,dat_coho$set)
# So, the ANOVA assumptions are not met (residuals are not normal and variances are not homogeneous)

# We cannot do parametric ANOVA. But we can still use the Kruskal-Wallis rank sum test (non-parametric 1-way ANOVA) 
kruskal.test(catch ~ set, data = dat_coho)
# There are significant differences between the sets, but just marginally significant
# Kruskal-Wallis test is non-parametric, so we do not need to check any assumptions.
# When an ANOVA or Kruskal-Wallis test is significant, we have to perform pairwise post-hoc tests
# For Kruskal-Wallis test, the suitable non-parametric is the pairwise Mann-Whitney-Wilcoxon test:
pairwise.wilcox.test(dat_coho$catch, dat_coho$set)

pairwise.t.test(dat_coho$catch, dat_coho$set)
# We see that the only significant difference is Set 1 from Set 3.

# The same test for the Dolly Varden charr is as follows:
dat_dolly <- dat_green_tidy %>% filter(species=="Dolly.Varden") 
anova_test_dolly <- aov(catch ~ set, data=dat_dolly)
summary(anova_test_dolly)
plot(anova_test_dolly)
residuals_dolly <- anova_test_dolly$residuals
ggplot(as_tibble(residuals_dolly),aes(residuals_dolly)) + geom_histogram()
shapiro.test(residuals_dolly)

ggqqplot(residuals_dolly)
# Check for homoscedasticity:
# leveneTest(catch ~ set, data = dat_dolly)
bartlett.test(dat_dolly$catch,dat_dolly$set)
# Again, we have to perform Kruskal-Wallis test
kruskal.test(catch ~ set, data = dat_dolly)
# This time, the test is very significant
pairwise.wilcox.test(dat_dolly$catch, dat_dolly$set)
# Now Set 1 is very different from Set 2 and Set 3.


#################################################################
### Correlation between two numerical variables
#################################################################

# Load data from HalibutPAC
# See info in: http://derekogle.com/fishR/data/data-html/HalibutPAC.html 
dat_halibut <- as_tibble(HalibutPAC) %>% drop_na()

######## Some exploratory plots of Halibut data
######## Using function grid.arrange() from package gridExtra
######## to arrange multiple plots in the same page
library(gridExtra)

# Define the ggplots and store them in individual objects
plot1 <- dat_halibut %>% ggplot(aes(x=year)) +
  geom_line(aes(y=land),color="blue")
plot2 <- dat_halibut %>% ggplot(aes(x=year)) +
  geom_line(aes(y=ssb),color="red")
plot3 <- dat_halibut %>% ggplot(aes(x=year)) +
  geom_line(aes(y=rec),color="green")
plot4 <- dat_halibut %>% ggplot(aes(x=year)) +
  geom_line(aes(y=fmort),color="purple")

# Now plot the four of them together using grid.arrange
grid.arrange(plot1,plot2,plot3,plot4,ncol=2,nrow=2)

# We can get a matrix of correlation plots for all numerical variables in the dataset
# Using function ggpairs() from package GGally
install.packages("GGally")
library(GGally)

dat_halibut %>% 
  select_if(is.numeric) %>%
  ggpairs()

#! scale of geom_density and diagonal graph of GGpairs() function
# dat_halibut %>% ggplot(aes(x=year)) +
#   geom_density()
# 
# dat_halibut %>% ggplot(aes(x=year)) +
#   geom_histogram()

# Let's explore the relationship between landings and mortality:
dat_halibut %>% ggplot(aes(x=land,y=fmort)) +
  geom_point(aes(color=year))

# Add a linear model
dat_halibut %>% ggplot(aes(x=land,y=fmort)) +
  geom_point(aes(color=year)) +
  geom_smooth(method="lm")

# Perform the correlation test
cor.test(dat_halibut$land, dat_halibut$fmort, method="pearson")
# Apparently, the correlation is significant:
# Pearson's r = 0.4583; p = 0.001196
# However, let's check the equivalent non-parametric test
# Non-parametric Spearman's rho correlation coeeficient:
cor.test(dat_halibut$land, dat_halibut$fmort, method="spearman")
# Now, the correlation is non-significant: p = 0.137
# By the scatter plot, we can appreciate that the data are probably heteroscedastic (variances are not homogeneous)

# To calculate the residuals, we need to use the linear model function lm():
regression_halibut <- lm(fmort ~ land, data = dat_halibut)
summary(regression_halibut)
residuals_halibut <- regression_halibut$residuals
ggplot(as_tibble(residuals_halibut),aes(residuals_halibut)) + geom_histogram()
shapiro.test(residuals_halibut)
ggqqplot(residuals_halibut)
plot(regression_halibut)

# The Shapiro test shows significant departure from normal distribution
# So the Pearson correlation is not right. Spearman's correlation is more reliable.

#######################
# Note that geom_smooth also allows for other kinds of non-linear models. For example:
dat_halibut %>% ggplot(aes(x=land,y=fmort)) +
  geom_point(aes(color=year)) +
  geom_smooth(method="gam")

#################################################################
### More correlations between two numerical variables
#################################################################

####### Now we will work with a different dataset for ruffe
# Load data from RuffeSLRH92
# See info in: http://derekogle.com/fishR/data/data-html/RuffeSLRH92.html 
data_ruffe <- as_tibble(RuffeSLRH92)
data_ruffe
data_ruffe %>% ggplot(aes(x=length,y=weight)) +
  geom_point(aes(color=maturity,shape=sex))
# Create new variables with logarithms
data_ruffe %>% mutate(Lg_length=log(length),Lg_weight=log(weight)) %>%
  ggplot(aes(x=Lg_length,y=Lg_weight)) +
  geom_point(aes(color=maturity,shape=sex))
# Remove individuals with unknown sex (too small => high dispersion of the data)
data_ruffe %>% mutate(Lg_length=log(length),Lg_weight=log(weight)) %>%
  filter(sex !="unknown") %>%
  ggplot(aes(x=Lg_length,y=Lg_weight)) +
  geom_point(aes(color=maturity,shape=sex))

# Save the new database
data_ruffe <- data_ruffe %>% mutate(Lg_length=log(length),Lg_weight=log(weight)) %>%
  filter(sex !="unknown")

# We will explore the relationship between Log(weight) and Log(length)
# Get the linear model using lm()
model_ruff <- lm(Lg_weight ~ Lg_length, data=data_ruffe)
summary(model_ruff)
anova(model_ruff)
plot(model_ruff)

cor.test(data_ruffe$Lg_weight, data_ruffe$Lg_length, method = "pearson")
cor.test(data_ruffe$Lg_weight, data_ruffe$Lg_length,method = "spearman")

residuals_ruff <- model_ruff$residuals
ggplot(as_tibble(residuals_ruff),aes(residuals_ruff)) + geom_histogram()
shapiro.test(residuals_ruff)
ggqqplot(residuals_ruff)

FSAmisc::fitPlot(model_ruff)

# Solution for using fitPlot() from package FSAmisc 
# Found at : https://derekogle.com/fishR/2021-05-25-fitPlot-replacement
# pd <- position_dodge(width=0.1)
# data_ruffe %>% ggplot(aes(x=Lg_length,y=Lg_weight)) +
#   stat_summary(fun.data=mean_cl_normal,geom="errorbar",width=0.2,position=pd) + 
#   stat_summary(fun=mean,geom="line",aes(group=maturity),position=pd) +  
#   stat_summary(fun=mean,geom="point",position=pd)
# 
# data_ruffe %>% ggplot(aes(x=Lg_length,y=Lg_weight)) +
#   stat_summary(fun.data=mean_cl_normal,geom="errorbar",width=0.2,position=pd) + 
#   stat_summary(fun=mean,geom="point",position=pd)

# Even though the data points fit in a straight line, the residuals do not follow a normal distribution.

# We can get a similar plot with ggplot
data_ruffe %>% ggplot(aes(x=Lg_length,y=Lg_weight)) +
  geom_point(aes(color=maturity,shape=sex)) +
  geom_smooth(method="lm")



#################################################################################################
### Multiple correlations of a numerical variable with several variables and categorical factors
### Multiple linear models
#################################################################################################
# Now we are going to add more factors to the model
# We will check whether the sex and/or the month (of catch) have a significant effect in the weight,
# These effects will be tested independently of the length
# Thus, the length would be a confusing variable when studying the effects of sex and/or date of capture on the weight
# First, we will check the types of the variables
data_ruffe
# Change the month to a categorical factor
data_ruffe$month <- factor(data_ruffe$month) 
data_ruffe
# Get the model:
model_ruff_2 <- lm(Lg_weight ~ Lg_length + sex + month, data=data_ruffe)
summary(model_ruff_2)
anova(model_ruff_2)
fitPlot(model_ruff_2)

# Get the faceted plots
data_ruffe %>% ggplot(aes(x=Lg_length,y=Lg_weight)) +
  geom_point(aes(color=maturity,shape=sex)) +
  geom_smooth(aes(group=sex),color="black",method="lm",lwd=0.5) +
  facet_wrap(~ sex + month,nrow=2)


#################################################################
### Generalized linear models
#################################################################
#! Reading resources
#! https://timnewbold.github.io/teaching_resources/GLMs.html
#! https://timnewbold.github.io/teaching.html
#! https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003531
#! Add to canvas
#!  Multivariate data analyses
#! 


#! Refresh on anova outputs + INteractions interpretations
#! http://campus.murraystate.edu/academic/faculty/cmecklin/STA265/_book/anova-with-interaction.html#:~:text=In%20ANOVA%2C%20an%20interaction%20is,all%20levels%20of%20another%20factor.
# The catches from Greens Creek Mine are actually counts (positive integer values)
# Counts usually follow a Poisson distribution.
# Linear models can be generalized to use residual distributions different from the normal, but, for example, Poisson distribution
# Residues can be modelled as Poisson for both regressions and anovas (numerical or categorical variables)
# You can use this line to perform a simple Poisson GLM 
# glm(y ~ x, family = poisson) 
# Now we will use glm to model our data on GreensCreekMine
model_greens <- glm(catch ~ species + set, data=dat_green_tidy, family= poisson)
# model_greens <- glm(catch ~ species + set, data=dat_green_tidy)
# model_greens <- lm(catch ~ species + set, data=dat_green_tidy)
plot(model_greens)
summary(model_greens)
# anova(model_greens)
anova(model_greens, test="chi")

# Remember the plot?
dat_green_tidy %>%  
  ggplot(aes(x=set,y=catch)) +
  geom_boxplot(aes(fill=species)) +
  geom_jitter(aes(color=species),width = 0.25, alpha = 0.8) +
  scale_color_brewer(palette="Dark2") +
  scale_fill_brewer(palette="Set2") +
  facet_wrap(~ species)

####################
### Interactions
####################
model_greens_interac <- glm(catch ~ species * set, data=dat_green_tidy, family= poisson)
plot(model_greens_interac)
summary(model_greens_interac)
anova(model_greens_interac)

anova(model_greens, model_greens_interac)
model_green_simpler <- lm(catch ~ set, data = dat_green_tidy)
anova(model_greens, model_green_simpler)

# Actually, since the interaction is significant, we should produce two different models (separated for each species)

dat_coho <- dat_green_tidy %>% filter(species=="Coho.Salmon")
dat_dolly <- dat_green_tidy %>% filter(species=="Dolly.Varden")

dat_coho %>% ggplot(aes(x=set, y=catch)) +
  geom_jitter(aes(color=species),width = 0.05, height = 0.05, alpha = 0.5) +
  theme_classic2()

# Generate the model for coho salmon, with residuals fitted to Poisson
model_greens_coho <- glm(catch ~ set, data=dat_coho, family= poisson)
plot(model_greens_coho)
summary(model_greens_coho)

# We will generate the null model, for comparison
model_greens_coho_null <- glm(catch ~ 1, data=dat_coho, family= poisson)
summary(model_greens_coho_null)

# To compare both models, we can use anova()
anova(model_greens_coho_null,model_greens_coho,test = "Chisq")
# anova(model_greens_coho, test = "Chi")
# The same for Dolly Varden charr

model_greens_dolly <- glm(catch ~ set, data=dat_dolly, family= poisson)
plot(model_greens_dolly)
summary(model_greens_dolly)

model_greens_dolly_null <- glm(catch ~ 1, data=dat_dolly, family= poisson)
summary(model_greens_dolly_null)

anova(model_greens_dolly_null,model_greens_dolly,test = "Chisq")

####################################
## Binomial Regression 
####################################
# When we need to model a binary variable as a function of numerical or categorical factors,
# We will use the binomial regression (glm with family = binomial)
# We are going to model at which minimal length is possible to assign a sex to a ruffe.

data_ruffe <- as_tibble(RuffeSLRH92)
data_ruffe
data_ruffe %>% ggplot(aes(x=length,y=weight)) +
  geom_point(aes(color=sex))

# We will generate a new binary variable known_sex using mutate()
data_ruffe <- data_ruffe %>% mutate(known_sex= ifelse(sex=="unknown",0,1))

# Now we can plot this variable vs length
data_ruffe %>% ggplot(aes(x=length,y=known_sex)) +
  geom_jitter(aes(color=sex),width = 0.05, height = 0.05, alpha = 0.5)

# We can model the effect of length on the ability to assign the sex using a binomial regression:
binom_glm <- glm(known_sex ~ length, data=data_ruffe,family=binomial)
summary(binom_glm)
fitPlot(binom_glm)

# pd <- position_dodge(width=0.1)
# data_ruffe %>% ggplot(aes(x=length,y=known_sex)) +
#   stat_summary(fun.data=mean_cl_normal,geom="errorbar",width=0.2,position=pd) +
#   stat_summary(fun=mean,geom="line",aes(group=length),position=pd) +
#   stat_summary(fun=mean,geom="point",position=pd)


# if we want to know the inflection point of the model, 
# we can just divide the negative intercept estimate by the slope estimate. 
Inflection_point <- -coef(binom_glm)[1]/coef(binom_glm)[2]
Inflection_point
