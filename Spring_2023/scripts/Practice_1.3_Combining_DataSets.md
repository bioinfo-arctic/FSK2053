## Handling multiple datasets

Load the dataset from the _Github_ repository and we will tidy it following the instructions from Lecture 2
```
url <- "https://raw.githubusercontent.com/DataScienceFishAquac/FSK2053-2021/main/datasets/GFW-fishing-vessels-v2.csv"
dat_vessels <- read_csv(url)
```

Now we will select the variables we want to keep and stored it in a wide table format
```
wide_data_vessels <- dat_vessels %>% 
  select(mmsi,flag_gfw,vessel_class_gfw,tonnage_gt_gfw,paste0("fishing_hours_",2012:2020))
wide_data_vessels
```
We will tidy up this table, and will remove all observations with _NA_
```
tidy_data_vessels <- wide_data_vessels %>% 
  pivot_longer(names_to = "year",values_to = "fishing_hours", paste0("fishing_hours_",2012:2020)) %>%
  mutate(year = gsub("fishing_hours_","",year)) %>%
  drop_na()
tidy_data_vessels
```

We will now calculate the fishing effort for all vessels, as the product of tonnage X fishing hours
```
tidy_data_vessels <- tidy_data_vessels %>%
	mutate(Effort = tonnage_gt_gfw * fishing_hours)
tidy_data_vessels
```

We will summarise the total fishing effort by country (integrating all ships, all types of gears, and all years)
```
summary_vessels <- tidy_data_vessels %>% 
	group_by(flag_gfw) %>% 
	summarise(Total_effort = sum(Effort, na.rm=T), N = n())
summary_vessels
```

On the other hand, we have the summary table of tuna catches from Session 2.2

```
url <- "https://raw.githubusercontent.com/DataScienceFishAquac/FSK2053-2021/main/datasets/global_tuna_catches_stock_2000-2010.csv"
dat <- read_csv(url)
data_tuna <- dat %>% 
	select(!starts_with("S_20")) %>%
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
global_summaries_by_country <- data_tuna %>% 
	group_by(Stock, Country) %>% 
	summarise("Total_catch" = sum(Catches,na.rm = T),"Total_individuals" = sum(Individuals,na.rm = T), N = n()) %>% 
	arrange(Country,Stock)

global_summaries_by_country
```

We will combine the catches for all species of tuna into a single measure for each country:
```
summary_tuna <- global_summaries_by_country %>% 
	group_by(Country) %>% 
	summarise(Catch = sum(Total_catch), Individuals=sum(Total_individuals))
summary_tuna
```

Now we have the table of tuna catches with the column "Country".
We have to relate this variable with the codes in the _flag_GFW_ column in the _summary_vessels_ table.
This will be apparently difficult. 
However, in R there is almost always am open-source solution shared by some other person who had the same problem before.

Looking in Google for "country codes in R" we will know of package countrycode
```
install.packages("countrycode")
library(countrycode)
```

Let us see how this new library works for standardizing country names
```
summary_tuna$Country
countrycode(countryname(summary_tuna$Country),origin="country.name",destination="iso3c")
summary_vessels$flag_gfw
```

Now we can mutate the country column in the summary_tuna table:
```
summary_tuna <- summary_tuna %>% mutate(Country_code = countrycode(countryname(Country),origin="country.name",destination="iso3c"))
summary_tuna
```
Finally, we have two datasets with a valid unique key (Country_code and flag_gfw)
We are going to left-join the table of fishing efforts to the table of tuna catches
```
merged_table <- left_join(summary_tuna,summary_vessels, by = c("Country_code" = "flag_gfw"))
merged_table
```
What would have happened had we applied right_join?
```
merged_right <- right_join(summary_tuna,summary_vessels, by = c("Country_code" = "flag_gfw"))
```
Now we can represent the data and explore the relationships
We will learn more about how to use ggplot2 to improve our visualizations in Session 3
```
install.packages("ggrepel")
library(ggrepel) # This library allows to add nice labels to the points in a plot

merged_table %>% 
	rename(`Fishing effort (ton-hours)` = Total_effort, `Total tuna catch (ton)` = Catch) %>%
	ggplot(aes(x=`Fishing effort (ton-hours)`, y=`Total tuna catch (ton)`)) +
	geom_point(aes(color=`Total tuna catch (ton)`,size=`Fishing effort (ton-hours)`)) +
	geom_label_repel(aes(label=Country_code),box.padding=0.35,point.padding = 0.5)
```

Since the X axis is clearly skewed towards China, we can add a logarithmic transformation of this axis
```
merged_table %>% rename(`Fishing effort (ton-hours)` = Total_effort, `Total tuna catch (ton)` = Catch) %>%
  ggplot(aes(x=`Fishing effort (ton-hours)`, y=`Total tuna catch (ton)`)) +
  geom_point(aes(color=`Total tuna catch (ton)`,size=`Fishing effort (ton-hours)`)) +
  geom_label_repel(aes(label=Country_code), box.padding = 0.35, point.padding = 0.5) +
  scale_x_log10(
    breaks = scales::trans_breaks("log10", function(x) 10^x),
    labels = scales::trans_format("log10", scales::math_format(10^.x)))
```
