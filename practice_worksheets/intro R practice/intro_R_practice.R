##
##
##    Worksheet #1: Practice with data navigation
##
##    Objective:  Become familiar with how to use packages in R and 
##                learn how R deals with data tables. In this lesson, 
##                we will begin using dplyr for data manipulation.
##                
##    Authors:    Calvin J. Munson
##
##    Date:       Aug. 22nd, 2023
##
##
##


# 1. Set up ---------------------------------------------------------------

# * Q1: Set your working directory to the folder where the data and this R script are --------

# * Q2: Load in the tidyverse packages ------------------------------------

library(tidyverse)

# * Q3: Read the "apple growth" csv file into R -----------------------------


apples <- read_csv("~/Desktop/R-DataScience-workshops/practice_worksheets/intro R practice/apple_growth.csv")




# 2. Explore the data -----------------------------------------------------


# * Q4: What are the column names for this data frame? ----------------------
# Write code to return a vector of the column names (rather than visually inspecting)

colnames(apples)

# * Q5: What are the different unique values for the date, treatment, and apple variety columns? --------
# Write code to figure this out rather than just visually inspecting the data. 
# Hint: Putting a dollar sign ($) immediately after a dataframe name will allow you to turn columns into vectors

unique(apples$apple_variety)

unique(apples$date_planted)

unique(apples$treatment)


# * Q6: What are the smallest and largest values of apple growth in this dataset? ---------
# Write code to return the answer
# Hint: Your solution might be very similar to how you found the unique values for the other columns...




# 3. Clean the data -------------------------------------------------------



# * Q7: Remove the date_sampled and apple_variety columns -------------------
# Hint: Use the select() function


# * Q8: Create a new column that converts the apple growth to centimeters per day instead of inches --------

apples %>% 
  select(treatment, apple_radius_in_per_day) %>% 
  mutate(apple_radius_cm_per_day = apple_radius_in_per_day*2.54)



# 4. Plot the data! -------------------------------------------------------


# * Q9: Challenge! Plot the apple growth data using boxplots --------------
# Look up how to plot a boxplot using ggplot online.
# What is your x-axis (independent variable)? What is your y-axis (dependent variable)? 
# Use that knowledge to adapt code that you find online.


# * Q10: Double challenge! Change the fill color of the boxplot to red --------
# Again, use your online resources.










