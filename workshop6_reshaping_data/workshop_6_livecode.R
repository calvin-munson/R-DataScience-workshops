##
##    Workshop #6: Reshaping data and tidy data
##
##    Objective:  Become familiar with how the fundamentals of reshaping
##                data frames and tidy data
##                
##    Authors:    Calvin J. Munson
##
##    Date:       July 24th, 2020
##
##
##


# 1. Set up ---------------------------------------------------------------

## Load packages
library(tidyverse)

## Set working directory
setwd("~/Desktop/FIU_R_Workshop/data")

## read in the data
population <- read_csv("city_populations.csv")

## Explore
population



# 2. Reshaping data -------------------------------------------------------


# * 2.1 pivot_longer() ----------------------------------------------------

?pivot_longer

## cols argument - the columns we want to pivot

population %>% 
  pivot_longer(cols = c(`2020`, `2010`, `2000`, `1990`), names_to = "year", values_to = "population")

population %>% 
  pivot_longer(cols = c(-city_state), names_to = "year", values_to = "population")

population_long <- population %>% 
  pivot_longer(cols = c(-city_state), names_to = "year", values_to = "population") %>% 
  mutate(year = as.numeric(year))



# * 2.2 Plotting the tidy data --------------------------------------------

# Install the "scales" package and call it from the library
install.package("scales")
library(scales)

population_long %>% 
  ggplot(aes(x = year, y = population, color = city_state)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = comma)


# * 2.3 pivot_wider() -----------------------------------------------------

population_wide <- population_long %>% 
  pivot_wider(names_from = "year", values_from = "population")

# calculate change in number of people
population_wide %>% 
  mutate(pop_increase = `2020` - `1990`)



# 3. Separate(), unite(), and rename() ------------------------------------


# * 3.1 Separate() --------------------------------------------------------

separated_popn <- population_wide %>% 
  separate(col = "city_state", into = c("city", "state"), sep = "_")

population_wide %>% 
  separate(col = "city_state", into = c("city", "state"), sep = -4)


# * 3.2 unite() -----------------------------------------------------------

## Miami, Florida
united_popn <- separated_popn %>% 
  unite(col = "city_state", city, state, sep = ", ")



# * 3.3 rename() -----------------------------------------------------------

united_popn %>% 
  rename(City_within_State = city_state,
         pop_2020 = `2020`,
         pop_2010 = `2010`)



population_long %>% 
  pivot_wider(names_from = "year", values_from = "population", names_prefix = "pop_")
  


# 4. Practice with Iris dataset

## Load in the data
data("iris")
iris

iris2 <- iris %>% 
  group_by(Species) %>% 
  mutate(individual = c(1:n()))

## 1) Using this dataframe (iris2), pivot the measument columns into a new colum
 # called "metric", and pivot the values into a column called "cm"
 # and store that as a new dataframe called "iris_long"

iris_long <- iris2 %>% 
  pivot_longer(cols = c(-Species, -individual), 
               names_to = "metric",
               values_to = "cm")

iris_long <- iris2 %>% 
  pivot_longer(cols = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), names_to = "metric", values_to = "cm")

## 2) Take the iris_long dataframe, and add the Genus ("Iris") to the front of the species name
 # by creating a new column called "Genus_species"

united <- iris_long %>% 
  mutate(Genus = "Iris") %>% 
  unite(col = "Genus_species_ind", Genus, Species, individual, sep = "_")

united %>% 
  separate(col = "Genus_species_ind", into = c("Genus", "Species", "individual"), sep = c("_"))



