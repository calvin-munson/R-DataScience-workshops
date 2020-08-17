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
               names_to = "energy_source",
               values_to = "production") %>% 
  separate(YYYYMM, into = c("year", "month"), sep = -2) %>% 
  filter(month == "13") %>% 
  mutate(year = as.numeric(year)) %>% 
  ggplot(aes(year, value, color = energy_source)) +
  geom_line()



# 3. Script for students to follow ----------------------------------------


# Load packages
library(tidyverse)

# Set wd
setwd("~/Desktop/R-DataScience-workshops")

# Read in data
US_energy.wide <- read_csv("practice_worksheets/US_energy_production/US_energy.wide.csv")


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
  filter(month == "13") %>% 
  mutate(year = as.numeric(year))

# Display the data as output
US_energy.yearly


# 4c) The total energy production per year was already calculated for us, but what could have been another way for us to get the yearly sums of energy production for each energy type? What problems with the data may this have created for us, though?
# 
# Alternatively, we could have 1) first filtered the data frame to NOT include month 13, 2) grouped the dataframe by year, and 3) used the summarise function to sum up all the energy type columns within each year.

# Problems:
# 1. It appears that from 1949 - 1972, the energy production data was measured only as yearly totals (i.e. only data for month 13). If we filtered out year 13 first, then we would be losing data for these two decades, since there are no month-level data to add together.
# 2. The most recent year of measurement, 2020, only has data up until April (month 4). If we summarized the data by year, 2020 would appear to have significantly lower energy production than in previous years, since all the months have not passed yet. This COULD be fixed by filtered out 2020, however.
# 3. It is a pain to name every single one of the 13 energy columns in a summarise function, however... You know what would be super helpful? If we could pivot the dataframe to make "energy type" a single column!!! Then we could group by "energy type" and summarise the "production column.

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
  


## 5. Separate dataframe into two

specific_prod <- US_energy.yearly %>% 
  dplyr::select(1, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14)


broad_prod <- US_energy.yearly %>% 
  dplyr::select(1, 3, 8, 15, 16)


## 6. Pivot

specific_prod.long <- specific_prod %>% 
  pivot_longer(cols = c(-year, -Unit),
               names_to = "energy_source", 
               values_to = "production")

specific_prod.long


broad_prod.long <- broad_prod %>% 
  pivot_longer(cols = c(-year, -Unit),
               names_to = "energy_source", 
               values_to = "production")

broad_prod.long



## 7. Graph broad prod!

broad_prod.long %>% 
  ggplot(aes(x = year, y = production, color = energy_source)) +
  geom_line()

## Graph replication challenge 
broad_prod.long %>% 
  ggplot(aes(x = year, y = production, color = energy_source)) +
  # Make the line a little bit thicker (default is 0.5)
  geom_line(size = 0.75) +
  # Add x and y labels, as well as a label for the legend (for the color)
  labs(x = "Year",
       y = "Energy Production (Quadrillion Btu)",
       color = "Energy Source") +
  # Add a title!
  ggtitle("Energy production by broad source in the U.S. from 1949 to 2019") +
  # Start by changing to minimal theme
  theme_minimal() +
  # Add additional theme elements
  # Change the position of the legend using legend.position. The default is for the 
  # legend to be outside and to the right of the plot, but by specifying a vector in 
  # c(x, y) format, you can tell it where to put the legend ((0,0) is the bottom left
  # corner, while (1,1) is the top right)
  theme(legend.position = c(0.25, 0.80), 
        # Change the size of the axis titles
        axis.title.x =  element_text(size = 12,
                                     # Also add 0.5 cm of space on top of the x title
                                     margin = margin(t = 0.5, unit = "cm")),
        axis.title.y =  element_text(size = 12,
                                     # This one adds 0.5 cm of space to the RIGHT of the y title
                                     margin = margin(r = 0.5, unit = "cm")),
        axis.text = element_text(size = 11),
        # Add 0.5 cm of space surrounding all edges of the plot (looks less cramped)
        plot.margin = margin(t = 0.5, b = 0.5, r = 0.5, l = 0.5, unit = "cm"),
        # Remove minor panel lines (panel.grid.major are the lines that intersect with the axis
         # numbers, which panel.grid.minor are the ones at the halfway point)
        panel.grid.minor = element_blank())

## For reference, I exported this graph with width = 6.5 and height = 4.5. 
# The size of your plot changes how certain aspects look! 
# For instance, a font of 12 will look HUGE if your plot is only 2x3 inches, 
# whereas it will look tiny if your plot is 10x14 inches



## 8. Graph specific prod!

broad_prod.long

## a
specific_prod.long %>% 
  ggplot(aes(x = year, y = production, color = energy_source)) +
  geom_line() +
  scale_color_brewer(palette = "Paired")


## b (facet)
specific_prod.long %>% 
  ggplot(aes(x = year, y = production, color = energy_source)) +
  geom_line() +
  scale_color_brewer(palette = "Paired") +
  facet_wrap(~ energy_source)

## c facet freey
 # what sources look like they are increasing fastest? decreasing? Which are most variable from year-to-year?
specific_prod.long %>% 
  ggplot(aes(x = year, y = production, color = energy_source)) +
  geom_line() +
  scale_color_brewer(palette = "Paired") +
  scale_y_continuous(limits = c(0, NA)) +
  facet_wrap(~ energy_source,
             scales = "free_y")



## challenge! new geom!
specific_prod.long %>% 
  ggplot(aes(x = year, y = production, fill = energy_source)) +
  # Use geom_area! This requires a "fill" aesthetic rather than a "color" aesthetic like geom_line()
  geom_area() +
  # Change the frequency of x-axis breaks to every 10 years instead of every 20
  scale_x_continuous(breaks = c(1950, 1960, 1970, 1980, 1990, 2000, 2010, 2020)) +
  scale_fill_brewer(palette = "Paired") +
  # Add x and y labels, as well as a label for the legend (for the color)
  labs(x = "Year",
       y = "Energy Production (Quadrillion Btu)",
       # Note that since the aesthetic for energy_source changed to fill, your label has to change to fill as well!
       fill = "Energy Source") +
  # Add a title!
  ggtitle("Energy production by source in the U.S. from 1949 to 2019") +
  theme_minimal() +
  theme(# Change the size of the axis titles
        axis.title.x =  element_text(size = 12,
                                     # Also add 0.5 cm of space on top of the x title
                                     margin = margin(t = 0.5, unit = "cm")),
        axis.title.y =  element_text(size = 12,
                                     # This one adds 0.5 cm of space to the RIGHT of the y title
                                     margin = margin(r = 0.5, unit = "cm")),
        axis.text = element_text(size = 11),
        # Add 0.5 cm of space surrounding all edges of the plot (looks less cramped)
        plot.margin = margin(t = 0.5, b = 0.5, r = 0.5, l = 0.5, unit = "cm"),
        # Remove minor panel lines (panel.grid.major are the lines that intersect with the axis
        # numbers, which panel.grid.minor are the ones at the halfway point)
        panel.grid.minor = element_blank())




## Look at percent use
specific_prod.perc <- specific_prod.long %>% 
  group_by(year) %>% 
  mutate(tot.production = sum(production, na.rm = TRUE),
         perc.production = production/tot.production*100)


## Graph percent use (line)
specific_prod.perc %>% 
  ggplot(aes(x = year, y = perc.production, color = energy_source)) +
  geom_line() +
  facet_wrap(~ energy_source,
             scales = "free_y") +
  scale_y_continuous(limits = c(0,NA)) +
  scale_fill_brewer(palette = "Paired")



## Graph percent use (area)
specific_prod.perc %>% 
  ggplot(aes(x = year, y = perc.production, fill = energy_source)) +
  geom_area() +
  scale_fill_brewer(palette = "Paired")
