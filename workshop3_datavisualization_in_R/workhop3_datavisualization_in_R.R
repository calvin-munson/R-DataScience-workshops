##
##
##    Workshop #3: Making graphs
##
##    Objective:  In this lesson, we will begin using ggplot2 to make graphs.
##                
##    Authors:    Calvin J. Munson
##
##    Date:       Mar. 9th-13th, 2020
##
##
##



# 1. Set up ---------------------------------------------------------------

rm(list = ls())

## To set up, let's load our packages like we did last time
library(dplyr)
library(ggplot2)


## Load data

# For this workshop, we will be using data that is built into R.
# All we have to do is use the data() function to retrieve it
# This particular data is a dataset on various measurements of 3 species of iris

data("iris")
iris

?iris



# 2. Explore the data frame -----------------------------------------------

## What are the column names? What does the data look like?

colnames(iris)
head(iris)

# What species do we have?
iris$Species %>% unique()



# 3. Intro to ggplot2 -----------------------------------------------------



# * 3.1 Setting up: Scatterplots ------------------------------------------


## What are the relationships between these variables? 
## Do certain morphometric attributes scale closely?
## Are there differences in these attributes between species?

# Using data visualization, we can answer these questions!

## We do this using the ggplot() function in the ggplot2 package.
# Whenever we want to graph something, we use the function: ggplot(). This sets up our graphing space
## Let's give the ggplot function some data
ggplot(data = iris)
# What happens? A plotting window appears, but with nothing. 
## That's because we haven't told the function which columns of data to display!

# Let's remind ourselves of what the data look like in order to choose columns of data to display
head(iris)

## To tell ggplot what to plot, we need to  designate the "aesthetics" of the graph using the aes() function
# The aesthetics tell ggplot() how the graph is going to look. Most importantly, you need an x and y axis! 
# Let's try this again with the "mapping" argument. 
# Let's test if the petal length is associated with the petal width of each individual flower. 
# Our independent variable, Petal.Length, will be on the x-axis, while the dependent variable, Petal.Width, will be on the x

ggplot(data = iris, 
       mapping = aes(x = Petal.Length, y = Petal.Width))


# Now what has changed? We have axis titles and numbers! Great! But why can't we see any of the data?
# Well that's because we need to tell ggplot what kind of graph we want
# We do this by putting a "+" after the closed parenthesis of the ggplot function and then creating a new line with the function that describes the type of graph we want.
# Let's make it a scatterplot, meaning we have a point for every combination of Petal.Length and Petal.Width We can accomplish this using the geom_point() function

ggplot(data = iris, 
       aes(x = Petal.Length, y = Petal.Width)) +
  geom_point()

# Look at that! Data! It's clear that petal width and petal length are highly correlated from individual to individual.
# We can change all sorts of things about this plot, such as the shape, size, and color. We do this by changing default arguments in the geom_point() function of the points.
ggplot(data = iris, 
       aes(x = Petal.Length, y = Petal.Width)) +
  geom_point(shape = 7, color = "blue")

# A full list of various ggplot functions and point shapes is available in the ggplot2 cheat sheet on our shared Google Drive, as is a cheat sheet for different colors you can use, called colorpalette


## So let's say we want to tell this graph to display more information than just what's on the x and y axes.
# One thing we can do is color each point based on which species that point belongs to

## Two continuous variables: geom_point()

## What happens when we color the points by species?
iris %>% 
  ggplot(aes(Petal.Length, Petal.Width, color = Species)) +
  geom_point()

# Assign species to shape?
iris %>% 
  ggplot(aes(Petal.Length, Petal.Width, shape = Species)) +
  geom_point()

# What about both shape AND color??
iris %>% 
  ggplot(aes(Petal.Length, Petal.Width, shape = Species, color = Species)) +
  geom_point()


# Each species is so distict! 


# * 3.2 Boxplots ----------------------------------------------------------

## One categorical variable and one continuous variable: geom_boxplot

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


## Another challenge: Using pipelines and the filter() function from last week, produce a graph that has the Sepal measurements for ONLY Iris setosa.
# Color the points/shape them however you please

iris %>% 
  filter(Species == "setosa") %>% 
  ggplot(aes(Sepal.Length, Sepal.Width)) +
  geom_point(size = 3,
             shape = 21,
             fill = "purple")




# * 3.3 Histograms --------------------------------------------------------

## If we want to investigate the distribution of one column of data, we can produce a histogram, which shows counts in different size classes

# For histograms, we only need an x axis, since the y axis defaults to counts of each bin
ggplot(data = iris, 
       mapping = aes(x = Petal.Width)) +
  geom_histogram() +
  facet_wrap( ~ Species, scales = "free")






# 4. Fancy graph exploration ----------------------------------------------


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

library(patchwork)

p.1 + theme_minimal() + 
  p.2 + theme_minimal()





p.point <- iris %>% 
  filter(Species == "virginica") %>% 
  ggplot(aes(Species, Petal.Width)) +
  geom_jitter(width = .1,
              size = 3,
              shape = 21,
              fill = "lightgreen") +
  ylim(1.35, 2.55) +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank())

p.box <- iris %>% 
  filter(Species == "virginica") %>% 
  ggplot(aes(Species, Petal.Width)) +
  geom_boxplot(fill = "lightgreen",
               width = .25) +
  ylim(1.35, 2.55) +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank())

(p.point + p.box)



