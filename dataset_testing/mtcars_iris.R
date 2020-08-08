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

## Let's install two packages from the tidyverse: dplyr and ggplot
# "Comment out" these two lines of code once you have installed the packages. Once the are installed, all you need to do is load them from your R "library"
install.packages("dplyr")
install.packages("ggplot2")

# From here on how, once you have installed them, this is how you can load the packages
library(dplyr)
library(ggplot2)

library(GGally)

# Visit: https://cran.r-project.org/ and navigate to the "packages" page to see just how many available packages there are to load! As of last week there were 15,393 packages.

# So now that we have these packages loaded, what can we do with them??



# 2. How to deal with data frames -----------------------------------------
#
#


# * 2.1 Import a data frame into R ---------------------------------------

# Importing a dataset into R can be tricky. Let's 



# First, we need some data. Let's load one of R's built in datasets to make this easier
# This dataset is called "mtcars". Using a built-in dataset means that it automatically stores the data frame int
data("mtcars")
?mtcars



# 3. How to make graphs ---------------------------------------------------
#
#

# Time to make some graphs!! Let's use this opportunity to try and figure out what determines the miles per gallon of a car, aka how effecient it is.
# Let's first test if the weight of the car has an effect on how many miles per gallon it gets

mtcars %>% ggpairs()

# Remind ourselves of what the data look like
head(mtcars)

# Whenever we want to graph something, we use the function: ggplot(). This sets up our graphing space
# Within this space, we designate the "aesthetics" of the graph using the aes() function

# Let's fill in the data argument of ggplot() with our dataframe mtcars and run the line of code.
ggplot(data = mtcars)

# What pops up in your plot window? Just a gray space! That's because you haven't designated the aesthetics of the plot yet.
# The aesthetics tell ggplot() how the graph is going to look. Most importantly, you need an x and y axis! 
# Let's try this again with the "mapping" argument. Again, we want to test if mpg (miles per gallon) is associated with the weight (wt) of the car. So our independent variable, mpg, will be on the y-axis, while the dependent variable, wt, will be on the x

ggplot(data = mtcars, aes(x = wt, y = mpg))


# Now what has changed? We have axis titles and numbers! Great! But why can't we see any of the data?
# Well that's because we need to tell ggplot what kind of graph we want
# We do this by putting a "+" after the closed parenthesis of the ggplot function and then creating a new line with the function that describes the type of graph we want.
# Let's make it a scatterplot, meaning we have a point for every combination of mpg and wt. We can accomplish this using the geom_point() function

ggplot(data = mtcars, aes(x = wt, y = mpg)) +
  geom_point()

# Look at that! Data! It's clear that the heavier cars in our dataset get worse and worse gas mileage. We can change all sorts of things about this plot, such as the shape, size, and color. We do this by changing default arguments in the geom_point() function of the points.
# A full list of various ggplot functions and point shapes is available in the ggplot2 cheat sheet on our shared Google Drive, as is a cheat sheet for different colors you can use, called colorpalette

ggplot(data = mtcars, aes(x = wt, y = mpg)) +
  geom_point(shape = 17, color = "blue", size = 2.5)



ggplot(mtcars %>% mutate(cyl = as.character(cyl)), aes(wt, mpg, color = cyl, shape = cyl, size = hp)) +
  geom_point()




data("iris")
iris


## Two continuous variables: geom_point() 

## What happens when we color the points by species?
iris %>% 
  ggplot(aes(Petal.Length, Petal.Width, color = Species)) +
  geom_point()

## One categorical variable and one continuous variable: geom_boxplot

# Each species is so distict! We can represent this even better using boxplots
# geom_point used color = ____ in order to color the points. However with box plots and bar charts, color adds color to the outline. We can use that, or we can use fill = ____ to fill in the boxplots with a certain color. This is a good way to show differences between categorical variables and continuous variables
iris %>% 
  ggplot(aes(Species, Petal.Length, fill = Species)) +
  geom_boxplot() 


## So now a challenge for you: What is the relationship between sepal length and sepal width?
# Doesn't look like there's much of a relationship.......or is there?
iris %>% 
  ggplot(aes(Sepal.Length, Sepal.Width)) +
  geom_point()


# Hint: incorporate some color!


iris %>% 
  ggplot(aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point()

## Aha! So it looks clearer now - it's now that there is no relationship between sepal length and sepal width, it just seems to be species-specific
# But it seem kinda hard to distinguish between points, even with color. Here's where a new function comes in!
# facet_wrap creates separate pains for unique categorical variables. In this case, Species. Let's add facet_wrap to the plot, and tell it to make Species the facet variable

iris %>% 
  ggplot(aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point() +
  facet_wrap(Species ~ .)


p.1 <- iris %>% 
  ggplot(aes(Petal.Length, Petal.Width, shape = Species, fill = Species)) +
  geom_point(size = 2.5, alpha = .8, position = "jitter") + 
  theme_classic() +
  scale_shape_manual(values = c(21, 22, 23)) +
  scale_fill_brewer(palette = "Set2")

p.2 <- iris %>% 
  ggplot(aes(Species, Petal.Width, shape = Species, fill = Species)) +
  geom_boxplot() + 
  theme_classic() +
  scale_shape_manual(values = c(21, 22, 23)) +
  scale_fill_brewer(palette = "Set2")

p.1 + theme_minimal() + 
  p.2 + theme_minimal()



iris %>% ggpairs()

