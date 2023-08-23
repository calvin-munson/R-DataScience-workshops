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
##    Date:       Aug. 23rd, 2023
##
##
##


# 0. Create fake data -----------------------------------------------------

# Load in packages
library(tidyverse)

# Set seed for replicability
set.seed(1)

# Assign number of reps
n <- 10

# Generate data
treatment = c(rep("Control", n),
              rep("Water", n),
              rep("Fertilizer", n),
              rep("Water + Fertilizer", n))

apple_radius_in_per_day = c(rnorm(n, mean = 0.02, sd = 0.02),
                            rnorm(n, mean = 0.04, sd = 0.02),
                            rnorm(n, mean = 0.08, sd = 0.02),
                            rnorm(n, mean = 0.2, sd = 0.02)) %>%
  round(3)

apple_growth <- tibble(treatment, apple_radius_in_per_day) %>% 
  # Add extra columns
  mutate(date_planted = "08_22_2023",
         apple_variety = "Granny Smith") %>% 
  relocate(date_planted, .before = everything())
apple_growth


# * 0.1 Check out data ----------------------------------------------------


# Check out data
apple_growth %>% 
  ggplot(aes(x = treatment, y = apple_radius_in_per_day)) +
  geom_point()



# * 0.2 Export data -------------------------------------------------------

write_csv(apple_growth,
          file = "~/Desktop/R-DataScience-workshops/practice_worksheets/intro R practice/apple_growth.csv")



