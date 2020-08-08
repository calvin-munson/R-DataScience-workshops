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

## Load relevant packages
library(tidyverse)

## Set working directory
setwd("~/Desktop/R-DataScience-workshops")

## Read in data
population <- read_csv("workshop6_reshaping_data/city_populations.csv")

## Explore the data
 # This is a very simple dataset, with only and handful of rows and columns. 
 # The data represents the population of each city for each year
population



# 2. Reshaping data -------------------------------------------------------

## Let's say we want to plot the population by year for each of these cities.
 # How do we get the data into the right format to do that??
 # This is where the pivoting functions come in!


# * 2.1 pivot_longer() ----------------------------------------------------


# First, in the "cols" argument, we name the columns that we want to "pivot". 
# Then, in the "values_to" argument, we give a name to the new column that will contain the values in each cell
# And lastly, in the "names_to" argument, we name the new column that will contain the old column names as new values
population %>% 
  pivot_longer(cols = c(`2020`, `2010`, `2000`, `1990`), names_to = "year", values_to = "population")

# Notice how "year" is now a new column, which contains the old column names
# This format is called "long" format since the data frame has gotten vertically longer!


# Note: For the "cols" argument, instead of naming every column that you want to pivot, 
#       you can instead name the columns that you DON'T want to pivot by using the minus sign
#       This would be way easier if we had population data for, say, 100 years.
population %>% 
  pivot_longer(cols = -city_state, values_to = "population", names_to = "year")


## When pivoting the year column, the function assumes that "year" is a character column
 # as opposed to a numeric column. We can see this by looking at the gray column descriptors
 # underneath each column name

## To change the year column to a numeric column, we can use mutate to modify it
population_long <- population %>% 
  pivot_longer(cols = -city_state, values_to = "population", names_to = "year") %>% 
  mutate(year = as.numeric(year))

# Notice now that the <chr> has changed to a <dbl> under the column title for year.
# Now we can start plotting this data!


# * 2.2 Plot tidy data ----------------------------------------------------

## With our new long dataframe (population_long) we can plot this data using year as
 # a continuous x-axis
population_long %>% 
  ggplot(aes(x = year, y = population, color = city_state)) +
  geom_line()

# And maybe we also want to add points on top of the lines
population_long %>% 
  ggplot(aes(x = year, y = population, color = city_state, shape = city_state)) +
  geom_line() +
  geom_point()


## How do we get rid of scientific notation for the y axis?
 # Google it, and use the scales package! Install it, then call it from the library
# install.packages("scales")
library(scales)

population_long %>% 
  ggplot(aes(x = year, y = population, color = city_state, shape = city_state)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = comma)




# * 2.3 pivot_wider() -----------------------------------------------------

## Now let's say we want to use R to calculate the percent population increase
 # between 1990 and 2020 for each of these cities. 
 # It would be easiest to do this using the original dataframe... How do we transform
 # it back?
## For that, we use the opposite function of pivot_longer(): pivot_wider()

## Based on the column you put into the "names_from" argument, this function automatically
 # creates as many new columns as there are unique values in that column (for "year", that is 
 # 4 values). Then you also tell the function which column contains the values using the
 # "values_from" argument.
population_wide <- population_long %>% 
  pivot_wider(names_from = "year", values_from = "population")


## Now we can use mutate to find the percent increase in population from 1990 to 2020
population_wide %>% 
  mutate(percent_change = (`2020` - `1990`)/`1990`*100)




# 3. Separate(), unite(), and rename(): additional column manipulation --------------

## Previously, we have learned how to create new columns using mutate. 
 # These new columns can be based on values that are already in different columns, 
 # such as in the previous mathematical example

## The functions separate() and unite() allow us to also manipulate character columns (i.e. no math!)


# * 3.1 separate() --------------------------------------------------------

## Say that we want to separate the city_state column into two separate columns: one
 # for city and one for state.
 # The separate function can help us do just that!

## There are three main arguments to use:
 # In the "col" argument, name the column that you want to split apart
 # In the "into" argument, supply a vector of new columns based on how many parts you 
 # are splitting the column into
 # Lastly, in the "sep" column, tell the function what value/character separates the words 
 # in the column to split by. For us, that is an underscore "_"
separated_popn <- population_wide %>% 
  separate(col = "city_state", into = c("city", "state"), sep = "_")

## For the "sep" argument, we don't have to specifically name a value, though. 
 # We can also tell the function to separate the values in the column by a certain position 
 # in the character string (for instance, split at 7 characters from the left)
population_wide %>% 
  separate(col = "city_state", into = c("city", "state"), sep = -4)




# * 3.2 unite() -----------------------------------------------------------

## Now that we have the city and state separated out, what if we want to re-unite the two columns,
 # but with a neater-looking separator instead of "_"? For instance, what if we wanted the 
 # city/state combo to look like "Miami, Florida"?
## The unite function is the opposite of separate, and can do this for us.

## For the unite function, there are three main sets of arguments
 # In the "col" argument, create a name for the new, soon-to-be united column
 # Then, write out the columns that you want to unite. For us, this is city and state. Separate them
 # by commas.
 # Lastly, in the "sep" argument, put what characters you want as the separater between column values
united_popn <- separated_popn %>% 
  unite(col = "city_state", city, state, sep = ", ")

## Nice!!


# * 3.3  rename () -------------------------------------------------------

## How do we rename columns? That's using the rename function!
 # To rename a column, add the new name on the left of the equal sign, and the old name on the right
united_popn %>% 
  rename(City_within_State = city_state)

# You can rename multiple at once by separating them with a comma
united_popn %>% 
  rename(City_State = city_state,
         pop_2020 = `2020`)




# 4. Practice with Iris ---------------------------------------------------

## Now take some time to practice what we learned using the Iris dataset


# * 4.1 Prepare -----------------------------------------------------------

## Load the data
data("iris")
iris

## Assign a number for each individual of each species
iris2 <- iris %>% 
  group_by(Species) %>% 
  mutate(individual = c(1:n())) 


# * 4.2 Pivot -------------------------------------------------------------


## Pivot this data frame so that the measurement columns, Sepal and Petal Length/Width,
 # Are new values in a column called "metric", and the measurements are in a column called "mm"
 # Store the new dataframe as an object called "iris_long"
iris_long <- iris2 %>% 
  pivot_longer(-c(Species, individual), names_to = "metric", values_to = "mm")




# * 4.3 Add and unite "genus" ---------------------------------------------

## All these flowers are in the genus "Iris". Create a new column called "genus" and 
 # unite it in front of the Species column to create a "Genus_species" column, which
 # contains the genus of the flower followed by the species, and separated by an underscore
 # or a space

iris_long %>% 
  mutate(genus = "Iris") %>% 
  unite(col = "Genus_species", genus, Species, sep = " ")
