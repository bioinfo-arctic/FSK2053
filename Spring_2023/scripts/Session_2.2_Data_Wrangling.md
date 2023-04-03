## Data wrangling on one dataset

# We will learn how to use the six main functions of dplyr to wrangle a wild dataset into a tidy tibble
# These functions are: select(), filter(), arrange(), mutate(), summarise(), and group_by().

library(tidyverse)

# Import the global tuna catches dataset from Github
url <- "https://raw.githubusercontent.com/DataScienceFishAquac/FSK2053-2021/main/datasets/global_tuna_catches_stock_2000-2010.csv"
dat <- read_csv(url)
dat

### `select`

# select() allows to select columns of a tibble based on their names or in their position (order)
# The global tuna catches dataset was downloaded from the FAO website. http://www.fao.org/fishery/statistics/tuna-catches/query/en
# These data table is not optimal in several ways.
# First, there are some columns that are completely empty.
# We are going to use the select() function to  keep only those columns that contain data values. 
# The empty columns have some common characteristic in their names
names(dat)
?select
# We can use the helpers in the select() function. e.g starts_with() to select the empty columns:
# We will also use the ! operator (NOT operator or complement operator)
data_tuna <- dat %>% select(!starts_with("S_20"))
data_tuna

# Now we will transform the wide-format of the year columns into a tidy dataset (we already know how)
data_tuna <- dat %>% select(!starts_with("S_20")) %>%
  pivot_longer(all_of(as.character(2000:2010)), names_to = "Year",values_to = "Catches")
data_tuna

# The options of select() to compare column names are really powerful. Complex operators and helpers can be used. 
# See help(select)
# For example, a range of consecutive columns can be selected using ":"

col_selection <- data_tuna %>% select(Country:Year)
col_selection

# Select can be also used for change the order of the columns. 
# We have to be careful when doing this, since all names must be specified, or the columns will be otherwise removed.
col_selection <- data_tuna %>% select(Country,Stock,`Gear Type`)
col_selection

# We can avoid this by using the everything() helper:
col_selection <- data_tuna %>% select(Country,Stock,`Gear Type`,everything())
col_selection


### `filter`

# filter() allows to select observations (rows) from a tibble based on their values
# Filter can use a complex combination of comparison operators: >, >=, <, <=, != (not equal), and == (equal).
# Logical combinations of multiple comparisons can be done using & (AND, intersection), | (OR, union) and ! (NOT, complement)
# If a series of several comparisons are given without combination operator, they are treated as joined by AND by default
# That is, every condition must be satisfied.
# You must also be careful with comparisons involving floating point numbers. For these, use the function near() better.
# You can learn a lot about filtering comparisons here: https://r4ds.had.co.nz/transform.html 

# With our dataset, a useful filter would be removing all observations with values of catches = 0.
data_tuna <- dat %>% select(!starts_with("S_20")) %>%
  pivot_longer(all_of(as.character(2000:2010)), names_to = "Year",values_to = "Catches") %>%
  filter(!near(Catches,0))
data_tuna


### `mutate`

# Mutate will add new columns as a result of vector calculations using other values of the table.
# If the name of the column is existing, it will overwrite the existing column.
# Besides the multitude of available functions in R, mutate adds some useful mutate functions.
# See help(mutate) for further reference

# Remember that transmute() is similar to mutate(), but it will remove all existing variables.

# Now, we are going to remove the "tuna Global" string from the Stock column (which adds no information).
# We will use function gsub(), and we will store the result in the same column (overwrite)
data_tuna <- dat %>% select(!starts_with("S_20")) %>%
  pivot_longer(all_of(as.character(2000:2010)), names_to = "Year",values_to = "Catches") %>%
  filter(!near(Catches,0)) %>%
  mutate(Stock = gsub(" tuna Global","",Stock))
data_tuna

# The Catch values are in Tons (1000 Kg). Now I am interested in estimating the number of caught individuals
# Using average individual weights for each species.
# We will use the following information on average weights for species:
#   Albacore:          33 Kg = 0.033 ton
#   Atlantic bluefin: 235 Kg = 0.235 ton
#   Bigeye:           120 Kg = 0.120 ton
#   Pacific bluefin:   60 Kg = 0.066 ton
#   Skipjack:          19 Kg = 0.019 ton
#   Southern bluefin: 140 Kg = 0.140 ton
#   Yellowfin:        120 Kg = 0.120 ton
# We will use mutate() combined with the case_when() operator to estimate 
# the number of individuals for every observation depending on the species (from the Stock column)

data_tuna <- dat %>% select(!starts_with("S_20")) %>%
  pivot_longer(all_of(as.character(2000:2010)), names_to = "Year",values_to = "Catches") %>%
  filter(!near(Catches,0)) %>%
  mutate(Stock = gsub(" tuna Global","",Stock))  %>%
  mutate(Individuals = Catches / case_when(
    Stock == "Albacore" ~ 0.033,
    Stock == "Atlantic bluefin" ~ 0.235,
    Stock == "Bigeye" ~ 0.120,
    Stock == "Pacific bluefin" ~ 0.066,
    Stock == "Skipjack" ~ 0.019,
    Stock == "Southern bluefin" ~ 0.140,
    Stock == "Yellowfin" ~ 0.120
  ))
data_tuna

# Since the number of individuals should be integer, we can round the column using round()
# Note that this will not change the class of the variable from double to integer

data_tuna <- dat %>% select(!starts_with("S_20")) %>%
  pivot_longer(all_of(as.character(2000:2010)), names_to = "Year",values_to = "Catches") %>%
  filter(!near(Catches,0)) %>%
  mutate(Stock = gsub(" tuna Global","",Stock))  %>%
  mutate(Individuals = round(Catches / case_when(
    Stock == "Albacore" ~ 0.033,
    Stock == "Atlantic bluefin" ~ 0.235,
    Stock == "Bigeye" ~ 0.120,
    Stock == "Pacific bluefin" ~ 0.066,
    Stock == "Skipjack" ~ 0.019,
    Stock == "Southern bluefin" ~ 0.140,
    Stock == "Yellowfin" ~ 0.120
  )))
data_tuna


### `summarise` and `group_by` 
# summarise() will create a new tibble with summarising values.
# It will have one or more rows, depending on the possible combinations of grouping variables.
# It will contain one column for each grouping variable and one column for each of the summary statistics
# That have been specified.
# When you group by multiple variables, each summary peels off one level of the grouping.
# That makes it easy to progressively roll up a dataset

# First we will create a one-row summary of the whole table

data_summaries <- data_tuna  %>% 
  summarise("Total_catch" = sum(Catches,na.rm = T),"Total_individuals" = sum(Individuals,na.rm = T))

# Now we are going to sum the catches for all values of `Gear Type`, by Country and species (Stock), keeping the Year separate
# Note that one row is created for every value of the combination Stock-Country-Year

data_summaries <- data_tuna %>% group_by(Stock, Country, Year) %>% 
  summarise("Total_catch" = sum(Catches,na.rm = T),"Total_individuals" = sum(Individuals,na.rm = T))

# In many cases, it is useful to calculate the group size (n), to track how many observations have been clustered.
data_summaries <- data_tuna %>% group_by(Stock, Country, Year) %>% 
  summarise("Total_catch" = sum(Catches,na.rm = T), "Total_individuals" = sum(Individuals,na.rm = T), N = n())

# Let's obtain another database with the total catch for all years:
global_summaries <- data_tuna %>% group_by(Stock, Country) %>% 
  summarise("Total_catch" = sum(Catches,na.rm = T),"Total_individuals" = sum(Individuals,na.rm = T), N = n())


### `arrange` 
# arrange() works similarly to filter() except that instead of selecting rows, it changes their order.
# It takes a tibble and a set of column names (or more complicated expressions) to order by.
# If you provide more than one column name, each additional column will be used to break ties in the values of preceding columns

# Now we are going to order the global_summaries dataset by Country, then by Stock
global_summaries_by_country <- global_summaries %>% arrange(Country,Stock)

# group_by() can also be used in combination with filter() and mutate() to perform complex queries.
# For example, we want to know which three countries have caught the most for each stock of tuna over the years.
# We can interrogate the global_summaries matrix, grouped by Stock, and then use the rank() function:

best_catchers <- global_summaries %>% group_by(Stock) %>% 
  filter(rank(desc(Total_catch)) <= 3) %>%
  arrange(Stock,desc(Total_catch))

# If we want to select just the best or the worst catcher, we can use functions max() and min()

best_catcher <- global_summaries %>% group_by(Stock) %>% 
  filter(Total_catch == max(Total_catch)) %>%
  arrange(Stock,desc(Total_catch))

worst_catcher <- global_summaries %>% group_by(Stock) %>% 
  filter(Total_catch == min(Total_catch)) %>%
  arrange(Stock,desc(Total_catch))

# If we want to count how many countries are fishing each Stock, we can use again the n() operator
# on the global_summaries table
countries_fishing <- global_summaries %>% group_by(Stock) %>% 
  summarise(count = n()) %>%
  arrange(desc(count))


### Additional dplyr verbs

### `count`
# count() is a quick shortcut for the common combination of group_by() and summarise() used to count the number of rows per group.
count(global_summaries,Stock)

# This is equivalent to:
global_summaries %>% group_by(Stock) %>% 
  summarise(count = n())

### `rename`
# The purpose of this function is obvious. An example:
data_tuna <- data_tuna %>% rename(Gear_type = `Gear Type`, Species = Stock)

### `distinct`
# This function removes rows that are perfect duplicates, keeping only unique rows. 
# This is useful, for example, when a table comes from a combination of two different sources. For Example
dupes <- tibble(
  id = c( 1,   2,   1,   2,   1,   2),
  dv = c("A", "B", "C", "D", "A", "B")
)
dupes
distinct(dupes)

### `slice`
# slice will select observations based in their (integer) positions
data_tuna_20_29 <- data_tuna %>% slice(20:29) 

# It comes with some useful helper functions:
data_tuna %>% slice_head(n=3) # Will select the first 3 rows
data_tuna %>% slice_tail(n=3) # Will select the last 3 rows

# slice_min() and slice_max() can be used to get the rows which have minimum values for a given variable
min_catch <- data_tuna %>% slice_min(Catches)
max_catch <- data_tuna %>% slice_max(Catches)

# slice_sample() will select some rows at random
catch_sample <- data_tuna %>% slice_sample(n=30)

### Pull 
# pull() is similar to $. It's mostly useful because it looks a little nicer in pipes.
# It also works with remote data frames, and it can optionally name the output.

data_tuna %>% slice_sample(n=15) %>% pull(Country)


