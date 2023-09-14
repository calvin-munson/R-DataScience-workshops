##
##
##    Workshop #3: Making graphs
##
##    Objective:  In this lesson, we will begin using ggplot2 to make graphs.
##                
##    Authors:    Calvin J. Munson
##
##    Date:       Aug. 29th, 2023
##
##
##


# 1. Set up ---------------------------------------------------------------

# Load in packages
library(tidyverse)
library(palmerpenguins)

# Checkout the data!
penguins

# Using the ? before this dataset (like we can do with a function) brings up a help page
?penguins

# What are the column names in this dataset?
colnames(penguins)

# What are the unique species in this dataset?
penguins$species %>% unique()

## What are some relationships we can explore?
# For one species, body mass vs sex
# Flipper length vs body mass
# Body mass vs species


# 2. Body mass as a function of species -----------------------------------

# Use geom_jitter (which is the same as geom_point, but with random "jitter" added to each point's x and y locations)
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_jitter()


# * 2.1 Adjust the y axis limits of the plot ------------------------------

# Include 0 in the ylimit
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_jitter() +
  # The first argument in ylim() is the y minimum, the second value is the maximum. 
  # We can replace either value with NA to revert to the default, which adds just a bit of extra space above or below the max or min data point
  ylim(0, NA) 


# 3. Body mass as a function of sex ---------------------------------------

# Changethe color and shape of the points to reflect the sex of that penguin 
# (remember, each point is an individual penguin that has a unique value for species, sex, bodymass, etc)
ggplot(penguins, aes(x = species, y = body_mass_g, color = sex, shape = sex)) +
  geom_jitter() +
  ylim(0, NA)



# 4. Flipper length vs body mass ------------------------------------------

# Now let's color the points by species
ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm, color = species)) +
  geom_point()


# * 4.1 Add regression line using geom_smooth -----------------------------

# geom_smooth() is a geom that calculates a regression relationship between the x and y variables you specify
# If you include a categorical group in the ggplot (e.g. you change the color or shape of the points to reflect the species (or sex)),
# then geom_smooth will calculate separate regressions for each species
ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm, color = species)) +
  geom_point() +
  # Use method = "lm" within geom_smooth to get the linear model output (aka regression). Default is a funky thing called loess. Check it out if you're curious.
  geom_smooth(method = "lm")



# 5. Changing axis and legend titles and lots of other things --------------------------------------

# Now let's have some fun modifying various components of the plot!

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm, color = species, shape = species)) +
  geom_point() +
  geom_smooth(method = "lm") +
  # the labs() function allows you to change the labels on the axes, legends, titles, etc.
  labs(x = "Body mass (g)",
       y = "Flipper length (mm)",
       title = "Flipper length to body mass relationships for three penguin species",
       shape = "Species",
       color = "Species") +
  # The scale_x_x family of functions allows us to set either preset or manual color schemes, shape schemes, etc
  scale_color_brewer(palette = "Set1") +
  scale_shape_manual(values = c(1, 2, 3)) +
  # Themes allow us to change the non-data-related aspects of our plots, like font size, axis tick marks, etc
  # built in themes, like theme_classic() or theme_minimal() are a good first step to get away from the default
  theme_classic() +
  # You can also manually change all of the components in the theme() function
  # Depending on what you are modifying (whether it's something with text, a line), specific functions like element_text() and element_rect() need to be used
  # Google is a huge help when modifying theme elements.
  theme(legend.box.background = element_rect(color = "black"),
        legend.position = c(0.85, 0.25),
        axis.text.y = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        legend.text = element_text(size = 12))




