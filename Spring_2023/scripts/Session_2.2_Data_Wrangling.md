## Data wrangling on one dataset

### We will learn how to use the six main _verbs_ of the `dplyr` package to wrangle a wild dataset into a tidy _tibble_.

> The functions in `dplyr` are called here verbs because it is used as "Grammar" for data manipulation. Tidyverse has a strong philosophy on using a defined set of structural rules to help you express how do you want to manipulate your data. The package name itself comes from the words "Data" + "Pliers".

The functions are: select(), filter(), arrange(), mutate(), summarise(), and group_by().

```
library(tidyverse)
#### Import the global tuna catches dataset from Github

url <- "https://raw.githubusercontent.com/DataScienceFishAquac/FSK2053-2021/main/datasets/global_tuna_catches_stock_2000-2010.csv"
dat <- read_csv(url)
dat
```
---
### The function `select()`
`select()` allows to select columns of a _tibble_ based on their names or based on their position/order.
The global tuna catches dataset was downloaded from the FAO website. http://www.fao.org/fishery/statistics/tuna-catches/query/en.
These data table are not optimal in several ways.
1) First, there are some columns that are completely empty.
   - We are going to use the `select()` function to  keep only those columns that contain data values. 
2) The empty columns have some common characteristic in their names.
```
names(dat)
?select
```
We can use the helpers in the `select()` function. e.g `starts_with()` to select the empty columns:
We will also use the "!" operator (NOT operator or complement operator)
```
data_tuna <- dat %>% select(!starts_with("S_20"))
data_tuna
```
Now we will transform the wide-format of the year columns into a tidy dataset (we already know how)
```
data_tuna <- dat %>% select(!starts_with("S_20")) %>%
  pivot_longer(all_of(as.character(2000:2010)), names_to = "Year",values_to = "Catches")
data_tuna
```
The options of `select()` to compare column names are really powerful. Complex operators and helpers can be used. 
See `help(select)`:
For example, a range of consecutive columns can be selected using ":"
```
col_selection <- data_tuna %>% select(Country:Year)
col_selection
```
`select()` can be also used to change the order of the columns. 
We have to be careful when doing this, since all names must be specified, or the columns will be otherwise removed.
```
col_selection <- data_tuna %>% 
	select(Country,Stock,`Gear Type`)
col_selection
```
We can avoid this by using the everything() helper:
```
col_selection <- data_tuna %>% select(Country,Stock,`Gear Type`,everything())
col_selection
```
---
#### The function `filter()`

`filter()` allows to select observations (rows) from a _tibble_ based on their values.
It can use a complex combination of comparison operators: >, >=, <, <=, != (not equal), and == (equal).
Logical combinations of multiple comparisons can be done using & (AND, intersection), | (OR, union) and ! (NOT, complement).
If a series of comparisons are given without a combination operator, they are treated as joined by an **AND** by default.
That is, every condition in the filter must be satisfied.
Be careful with comparisons involving floating point numbers (decimals). For these, use the function `near()` better.
You can learn a lot about filtering comparisons here: https://r4ds.had.co.nz/transform.html 

With our dataset, a useful filter would be removing all observations with values of catches = 0.
```
data_tuna <- dat %>% select(!starts_with("S_20")) %>%
  pivot_longer(all_of(as.character(2000:2010)), names_to = "Year",values_to = "Catches") %>%
  filter(!near(Catches,0))
data_tuna
```
---
#### The function `mutate()`

Mutate will add new columns as a result of vector calculations using other values of the table.
If the name of the column is existing, it will overwrite the existing column.
Besides the multitude of available functions in R, mutate adds some useful mutate functions.
See `help(mutate)` for further reference.

Remember that `transmute()` is similar to `mutate()`, but it will remove all existing variables.
Now, we are going to remove the **"tuna Global"** string from the Stock column (which adds no information).
We will use function `gsub()`, and we will store the result in the same column (overwrite)
```
data_tuna <- dat %>% select(!starts_with("S_20")) %>%
  pivot_longer(all_of(as.character(2000:2010)), names_to = "Year",values_to = "Catches") %>%
  filter(!near(Catches,0)) %>%
  mutate(Stock = gsub(" tuna Global","",Stock))
data_tuna
```
The Catch values are in Tons (1000 Kg). Now I am interested in estimating the number of caught individuals.
Using average individual weights for each species.
We will use the following information on average weights for species:
| Species| Weight (Kg) | Weight (ton)|
|---|---|---|
| Albacore| 33 Kg | 0.033 ton|
| Atlantic bluefin| 235 Kg | 0.235 ton|
| Bigeye| 120 Kg | 0.120 ton|
| Pacific bluefin| 66 Kg | 0.066 ton|
| Skipjack| 19 Kg | 0.019 ton|
| Southern bluefin| 140 Kg | 0.140 ton|
| Yellowfin| 120 Kg | 0.120 ton|

We will use `mutate()` combined with the `case_when()` operator to estimate the number of individuals for every observation depending on the species (from the Stock column)
```
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
```
Since the number of individuals should be integer, we can round the column using `round()`
Note that this will not change the class of the variable from double to integer
```
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
```
---
#### Functions `summarise()` and `group_by()` 
`summarise()` will create a new _tibble_ summarising values.
It will have one or more rows, depending on the possible combinations of grouping variables.
It will contain one column for each grouping variable and one column for each of the summary statistics that have been specified.
When you `group_by()` multiple variables, each summary peels off one level of the grouping.
That makes it easy to progressively roll up a dataset.
First we will create a one-row summary of the whole table.
```
data_summaries <- data_tuna  %>% 
  summarise("Total_catch" = sum(Catches,na.rm = T),"Total_individuals" = sum(Individuals,na.rm = T))
```
Now we are going to sum the catches for all values of `Gear Type`, by _country_  and _species_ (Stock), keeping the _Year_ separate.
Note that one row is created for every value of the combination Stock-Country-Year
```
data_summaries <- data_tuna %>% group_by(Stock, Country, Year) %>% 
  summarise("Total_catch" = sum(Catches,na.rm = T),"Total_individuals" = sum(Individuals,na.rm = T))
```
In many cases, it is useful to calculate the group size (n), to track how many observations have been clustered.
```
data_summaries <- data_tuna %>% group_by(Stock, Country, Year) %>% 
  summarise("Total_catch" = sum(Catches,na.rm = T), "Total_individuals" = sum(Individuals,na.rm = T), N = n())
```
Let's obtain another database with the total catch for all years:
```
global_summaries <- data_tuna %>% group_by(Stock, Country) %>% 
  summarise("Total_catch" = sum(Catches,na.rm = T),"Total_individuals" = sum(Individuals,na.rm = T), N = n())
```
---
#### The function `arrange()` 
`arrange()` works similarly to `filter()` except that instead of selecting rows, it changes their order.
It takes a _tibble_ and a set of column names (or more complicated expressions) to order by.
If you provide more than one column name, each additional column will be used to break ties in the values of preceding columns.

Now we are going to order the **"global_summaries"** dataset by _Country_, then by _Stock_
```
global_summaries_by_country <- global_summaries %>%
	arrange(Country,Stock)
```
`group_by()` can also be used in combination with filter() and mutate() to perform complex queries.
For example, we want to know which three countries have caught the most for each stock of tuna over the years.
We can interrogate the **"global_summaries"** matrix, grouped by _Stock_, and then use the `rank()` function:
```
best_catchers <- global_summaries %>% 
group_by(Stock) %>% 
  filter(rank(desc(Total_catch)) <= 3) %>%
  arrange(Stock,desc(Total_catch))
```
If we want to select just the best or the worst catcher, we can use functions `max()` and `min()`
```
best_catcher <- global_summaries %>% 
	group_by(Stock) %>%
	filter(Total_catch == max(Total_catch)) %>%
	arrange(Stock,desc(Total_catch))

worst_catcher <- global_summaries %>%
	group_by(Stock) %>% 
	filter(Total_catch == min(Total_catch)) %>%
	arrange(Stock,desc(Total_catch))
```
If we want to count how many countries are fishing each _Stock_, we can use again the `n()` operator on the **"global_summaries"** table.
```
countries_fishing <- global_summaries %>% 
	group_by(Stock) %>% 
	summarise(count = n()) %>%
	arrange(desc(count))
```
---
### Additional `dplyr` verbs
#### The verb `count()`
count() is a quick shortcut for the common combination of group_by() and summarise() used to count the number of rows per group.
```
count(global_summaries,Stock)
```
This is equivalent to:
```
global_summaries %>% 
	group_by(Stock) %>% 
	summarise(count = n())
```

#### The verb `rename()`
The purpose of this function is obvious. 
An example:
```
data_tuna <- data_tuna %>% 
	rename(Gear_type = `Gear Type`, Species = Stock)
```
#### The verb `distinct()`
This function removes rows that are perfect duplicates, keeping only the unique ones. 
This is useful, for example, when a table comes from a combination of two different sources.
```
dupes <- tibble(
  id = c( 1,   2,   1,   2,   1,   2),
  dv = c("A", "B", "C", "D", "A", "B")
)
dupes
distinct(dupes)
```
### The function `slice()`
`slice()` will select observations (rows) based in their (integer) positions:
```
data_tuna_20_29 <- data_tuna %>%
	slice(20:29) 
```
It comes with some useful helper functions:
```
data_tuna %>% 
	slice_head(n=3) # Will select the first 3 rows
data_tuna %>% 
	slice_tail(n=3) # Will select the last 3 rows
```
The helper functions `slice_min()` and `slice_max()` can be used to get the rows which have minimum values for a given variable:
```
min_catch <- data_tuna %>% 
	slice_min(Catches)
max_catch <- data_tuna %>% 
	slice_max(Catches)
```
The function `slice_sample()` will select some rows at random:
```
catch_sample <- data_tuna %>% 
	slice_sample(n=30)
```
#### The function  `pull()` 
`pull()` is similar to the `$` sign. It's mostly useful because it looks a little nicer in pipes.
It also works with remote data frames, and it can optionally name the output.
```
data_tuna %>% 
	slice_sample(n=15) %>%
	pull(Country)
```

