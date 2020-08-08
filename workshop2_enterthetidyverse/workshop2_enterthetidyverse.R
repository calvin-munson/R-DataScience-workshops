##
##
##    Workshop #2: Enter the tidyverse!
##
##    Objective:  Become familiar with how to use packages in R and 
##                learn how R deals with data tables. In this lesson, 
##                we will begin using dplyr for data manipulation and 
##                ggplot2 for making graphs.
##                
##    Authors:    Calvin J. Munson
##
##    Date:       Feb. 17th-21st, 2020
##
##
##



# 1. How to install and load packages in R -------------------------------------
#
#

# In last week's workshop, we learned a few basic functions that are built-in to R.
# These included mean(), length(), c()
# However, there are entire packages of functions in R that can make our lives way easier than if we had to rely on the built in ones!
# This suite of packages is called the "tidyverse". If you think of R as a language, the tidyverse is a very strong dialect. Things are very different in some ways. The goal of the tidyverse is to making coding easier and more accessible to beginners.

## Let's install all the packages in the tidyverse, including dplyr and ggplot
# "Comment out" these lines of code once you have installed the packages. Once the are installed, all you need to do is load them from your R "library"
install.packages("tidyverse")


# From here on how, once you have installed them, this is how you can load the packages
library(dplyr)
library(ggplot2)

library(tidyverse)

# Visit: https://cran.r-project.org/ and navigate to the "packages" page to see just how many available packages there are to load! As of last week there were 15,393 packages.

# So now that we have these packages loaded, what can we do with them??


# 2. How to deal with data frames -----------------------------------------
#
#

# * 2.1 Import a data frame into R ---------------------------------------

# Importing a dataset into R can be tricky. Let's learn how to set our "working directory" and import a .csv file.

# Create a folder on your Desktop called "FIU_R_workshop"
# In that folder, create another folder called "data". Save the cereal.csv file (on the Google Drive I shared with you all) into that folder

# Set working directory with this line of code
setwd("~/Desktop/FIU_R_Workshop/data")

# This essentially tells R where to look for your data. Once you do this, we can read in data.

# Read in data, store it as a data object (just like the numbers and vectors from last week!)
data_cereal <- read.csv("cereal.csv")

# Alternately, you could write out the full file name:
data_cereal <- read.csv("~/Desktop/FIU_R_Workshop/data/cereal.csv")



# * 2.2 Explore the data frame! -------------------------------------------

## First, highlight the data object and run that line of code
data_cereal

# Notice that it shows you most of the data, but that 15 rows are cut off

## We also have the data from in out global environment (top right). Click on the name of the data frame and see what happens
# We can view it, just like a normal spreadsheet.
# But sometimes data frames can be extremely large, and just scrolling through is inefficient. Thankfully, R has functions to investigate the data without doing this!

## What does the data look like? The head() function shows the first 6 rows of a data frame
head(data_cereal)

## How many columns? How many rows? What are the column names?
# Note the type of output that each function creates: do they output a number? a vector?
nrow(data_cereal) # Number of rows
ncol(data_cereal) # Number of columns
colnames(data_cereal) # Names of the columns

## The $
# place a $ after a data frame, and a selection of columns will show up. If you run this line, it will show you the order of values in this column!
# Using the unique function can show you the unique values in a single column

data_cereal$mfr
unique(data_cereal$mfr)







# 3. Introducing the %>% operator -----------------------------------------

## So let's say that we want to string together multiple functions at once. This can be particularly useful when dealing with lots of data, and if we don't want to keep creating new data frames.
## The %>% operator, also known as a "pipeline", can help us with this!
## To demonstrate, let's go back to the last workshop, where we looked at a string of names

names <- c("Calvin", "Olivia", "Justin", "Calvin")

# Our goal is to get the number of unique names in this vector. We can tell that it is 3, but with larger and larger strings of data, this can be quite challenging!

# As we did last week, we can look at the unique names

length(names)

unique(names)

names.2 <- unique(names)
length(names.2)

# This is one option. However with data frames, where there are multiple different arguments, this can get very very messy. 
# So instead, we can use the %>% operator, which takes the data object and "pipes" it into the function that follows
# See powerpoint here

# for instance:
names %>% unique()
# is that same as:
unique(names)


# Here is the way to do it with two different pipes. They take the "names" object and 1) feed it into the unique() function. This produces an output, which the second pipe takes and feeds into the length() function. It saves us a step!

names %>% unique() %>% length()

# This method can also be done neatly while spread across multiple lines:

names %>% 
  unique() %>% 
  length()

data_cereal %>% 
  colnames() %>% 
  length()

# I will use the pipe operator to teach how to incorporate dataframes into functions from here on out

# You can read more about the pipe operator here: https://r4ds.had.co.nz/pipes.html



# 4. Introducting select() ---------------------------------------------

## Select is a function from the dplyr package in the tidyverse, and allows us to "select" specific columns. Easy as pie! Just tell it the name of the columns you want. 
# The first "argument" to the function will be the dataframe in question, so use this format:
# select(data, column1, column2, etc...)
# With %>% , this format becomes:
# data %>% select(column1, column2, etc...)

data_cereal %>% 
  select(name, calories, fiber)

## You can also rename this as a new data frame!
cereal.2 <- data_cereal %>% 
  select(name, calories, fiber)

# This new frame has only the name of the cereal and the amount of sugar it has.
# Importantly, notice that the original data frame, data_cereal, is completely unmodified! 
# We can go back and use this data frame as we please

# Create a new data frame that has the name, manufacturer, and amount of sugar,
# Name the data frame something

cereal_sugar <- data_cereal %>% 
  select(name, mfr, sugars)




# 5. Introducing filter() -------------------------------------------------

## We can use the filter function in two different ways: To filter numbers or to filter characters. For instance, the manufacturer column is filled with characters, while the nutritional columns are numeric.

## Let's use the dataframe we created with name, manufacturer, and sugars
# Which cereals have greater than 12 grams of sugar?
cereal_sugars %>% 
  filter(sugars > 12)

# You could also do:
# Greater than or equal to: >=
# Less than: <
# Less than or equal to: <=
# Exactly equal to: ==
# NOTE: Exactly equal to is NOT just one single "=", because that operator is used to asign variables

# Which cereals are manufactured by Kelloggs?
cereal_sugars %>% 
  filter(mfr == "Kelloggs")

# NOTE: Remember the quotation marks, since it's a character!


## Now we will look at how the %>% operator can be particularly helpful.
## Let's go back to working with the cereal dataset
# Say we want to select certain columns and THEN filter that data

# We COULD do it this way:

cereal.2 <- data_cereal %>% 
  select(name, sugars, protein)

cereal.3 <- cereal.2 %>% 
  filter(sugars > 12)

## But this clutters up our working environment, added uneccessarily many data frames. So instead, let's try it with piping:

data_cereal %>% 
  select(name, sugars, protein) %>% 
  filter(sugars > 12)

## This is a nice and TIDY way to run these functions, as it progressively shows the steps we took, and we don't have to keep writing the name of the dataframe over and over again

## Challenge: starting with data_cereal, create a dataframe that has the name of the cereal and the amount of fiber, fat, and sodium per serving, but only for cereals that have more than 120 calories

# This is tricky! Think about the order in which you do things here.

data_cereal %>% 
  filter(calories > 120) %>% 
  select(name, fiber, fat, sodium) 

# You have to end up using the filter function BEFORE the select function, since select() gets rid of the calories column
# You can't filter something that isn't there!



# 6. Introducing mutate() ----------------------------------------------------

## The mutate() function adds a new column based upon calculations you provide
## It applies these calculations to each row
## Let's select only a couple columns to make this easier

cereal_carbs <- data_cereal %>% 
  select(name, carbo, sugars)

# Multiply every value in the sugars column by two
cereal_carbs %>% 
  mutate(sugars_total = sugars*2)

# If you give the new variable the same name as an existing variable, mutate() will OVERRIDE that old variable!
cereal_carbs %>% 
  mutate(sugars = sugars*2)

# Say you always eat cereal with milk, which has 5 grams of sugar per serving
cereal_carbs %>% 
  mutate(sugars_with_milk = sugars + 5)

# Add two columns together
cereal_carbs %>% 
  mutate(total_carbs = carbo + sugars)


