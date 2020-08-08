##
##
##    Practice problems: Energy production!
##
##    Objective:  TBD
##                
##    Authors:    Calvin J. Munson
##
##    Note:       This worksheet is best completed after reviewing the 
##                content from Workshop 6: Reshaping Data
##
##
##



# 1. Set up ---------------------------------------------------------------

# Load packages
library(tidyverse)

# Set wd
setwd("~/Desktop/R-DataScience-workshops")

# Read in data
US_energy_raw <- read_csv("practice_worksheets/US_energy_production/US_energy_raw.csv")



# 2. Explore --------------------------------------------------------------

US_energy_raw

US_energy_raw$Description %>% unique()

US_energy_raw$Unit %>% unique()

sep_filt <- US_energy_raw %>% 
  separate(YYYYMM, into = c("year", "month"), sep = -2) %>% 
  filter(month == "13") %>% 
  mutate(year = as.numeric(year))


sep_filt %>% 
  dplyr::select(MSN, Description) %>% 
  distinct() %>% 
  arrange(MSN)


sep_filt %>% 
  ggplot(aes(x = year, y = Value, color = Description)) +
  geom_line() +
  ylim(0, NA) +
  facet_wrap(Description ~ .,
             scales = "free_y")




## Manipulate and export for students
US_energy.wide <- US_energy_raw %>% 
  dplyr::select(-c(MSN, Column_Order)) %>% 
  pivot_wider(names_from = "Description",
              values_from = "Value")

write_csv(US_energy.wide, "US_energy.wide.csv")

US_energy.wide %>% colnames()

US_energy.wide %>% 
  dplyr::select(YYYYMM, `Total Fossil Fuels Production`, `Total Renewable Energy Production`, `Total Primary Energy Production`) %>% 
  pivot_longer(cols = -YYYYMM,
               names_to = "energy_type",
               values_to = "value") %>% 
  separate(YYYYMM, into = c("year", "month"), sep = -2) %>% 
  filter(month == "13") %>% 
  mutate(year = as.numeric(year)) %>% 
  ggplot(aes(year, value, color = energy_type)) +
  geom_line()



# 3. Script for students to follow ----------------------------------------


# Load packages
library(tidyverse)

# Set wd
setwd("~/Desktop/R-DataScience-workshops")

# Read in data
US_energy_raw <- read_csv("practice_worksheets/US_energy_production/US_energy_wide.csv")


colnames(US_energy.wide)

unique(US_energy.wide$YYYYMM)

unique(US_energy.wide$Unit)

#### 3. Separate the YYYYMM column
#   Based on the column name, the first four digits of each value are the year, while the last two digits are the month. Using the separate() function, create two new columns from the YYYYMM column: one with the year values, and one with the month values. Store the new dataframe as "US_energy.sep"
# Hint: Remember the two different ways you can separate a column using the "sep" argument. See the separate() help page for more info.
# 

# Remember: For the "sep" argument, you can separate either by a character string (e.g. " " or "_") OR by a position (e.g. 2 characters from the right or left)!
US_energy.sep <- US_energy.wide %>% 
  separate(YYYYMM, into = c("year", "month"), sep = -2)

# Display the data as output
US_energy.sep

#### 4. Filtering for proper months
  
  # 4a) Check out the unique values for "month" in this dataframe. What do you think month 13 represents? Would it be useful to us? You can scroll through the entire dataframe by clicking on the data object (US_energy.sep) in the Global Environment panel in the top right.

# It appears that the row labelled "month 13" represents the total production throughout that corresponding year (aka the sum of months 1-12)
unique(US_energy.sep$month)


US_energy.yearly <- US_energy.sep %>% 
  filter(month == "13")

# Display the data as output
US_energy.yearly


# 4c) The total energy production per year was already calculated for us, but what could have been another way for us to get the yearly sums of energy production for each energy type? What problems with the data may this have created for us, though?
# 
# Alternatively, we could have 1) first filtered the data frame to NOT include month 13, 2) grouped the dataframe by year, and 3) used the summarise function to sum up all the energy type columns within each year.

# Problems:
# 1. It appears that from 1949 - 1972, the energy production data was measured only as yearly totals (i.e. only data for month 13). If we filtered out year 13 first, then we would be losing data for these two decades, since there are no month-level data to add together.
# 2. The most recent year of measurement, 2020, only has data up until April (month 4). If we summarized the data by year, 2020 would appear to have significantly lower energy production than in previous years, since all the months have not passed yet. This COULD be fixed by filtered out 2020, however.
# 3. It is a pain to name every single one of the 13 energy columns in a summarise function, however... You know what would be super helpful? If we could pivot the dataframe to make "energy type" a single column!!! Then we could group by "energy type" and summarise the "value" column.

US_energy.sep %>% 
  # filter to REMOVE rows that have 13 in the month column
  filter(month != "13") %>% 
  group_by(year) %>% 
  summarise(`Coal Production` = sum(`Coal Production`, na.rm = TRUE),
            `Natural Gas (Dry) Production` = sum(`Natural Gas (Dry) Production`, na.rm = TRUE),
            `Crude Oil Production` = sum(`Crude Oil Production`, na.rm = TRUE),
            `Natural Gas Plant Liquids Production` = sum(`Natural Gas Plant Liquids Production`, na.rm = TRUE),
            `Total Fossil Fuels Production` = sum(`Total Fossil Fuels Production`, na.rm = TRUE),
            `Nuclear Electric Power Production` = sum(`Nuclear Electric Power Production`, na.rm = TRUE),
            `Hydroelectric Power Production` = sum(`Hydroelectric Power Production`, na.rm = TRUE),
            `Geothermal Energy Production` = sum(`Geothermal Energy Production`, na.rm = TRUE),
            `Solar Energy Production` = sum(`Solar Energy Production`, na.rm = TRUE),
            `Wind Energy Production` = sum(`Wind Energy Production`, na.rm = TRUE),
            `Biomass Energy Production` = sum(`Biomass Energy Production`, na.rm = TRUE),
            `Total Renewable Energy Production` = sum(`Total Renewable Energy Production`, na.rm = TRUE),
            `Total Primary Energy Production` = sum(`Total Primary Energy Production`, na.rm = TRUE))



US_energy.yearly
  
