##
##
##    Workshop #5: Data visualization via ggplot2 (part 2)
##
##    Objective:  Become familiar with the variety of ways ggplot2
##                can be used to create graphs
##                
##    Authors:    Calvin J. Munson
##
##    Date:       May 29th, 2020
##
##
##




# 1. Set up ---------------------------------------------------------------

## Load packages
library(tidyverse)

## Read in data
data(mpg)


# 2. Explore the data -----------------------------------------------------

mpg

head(mpg)


## Since mtcars is a built-in dataset, run the below line of code to read more about it
?mpg




# 3. Explore new plotting aesthetics ------------------------------------------

## So far in the workshops, we have explored how to change the colors and shapes
## of points when using geom_point()

## For instance, let's look at a graph of engine displacement vs highway miles per gallon
## we can color the points by the class of car
mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point()


## But what if we want to use an aesthetic to display information about the points 
## using a continuous variable, like displ?
mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = displ)) +
  geom_point()

# Note that the x-axis scale and the color scale have the same values! 

## Colors and shapes aren't the only aesthetics we can use though!

# Let's assign the size of the points to displ
mpg %>% 
  ggplot(aes(x = displ, y = hwy, size = displ)) +
  geom_point()


# You can even make the points vary in transparency using the alpha aesthetic
mpg %>% 
  ggplot(aes(x = displ, y = hwy, alpha = displ)) +
  geom_point()

# Or you could go CRAZY and throw in a bunch of scales
mpg %>% 
  ggplot(aes(x = displ, y = hwy, size = displ, alpha = displ)) +
  geom_point()

## Notice that the legend is smart, and incorporates both alpha and size into the legend



## What happens when these features (size, alpha, color) are used OUTSIDE of the 
## aes() function?
## That tells ggplot that you want to assign a constant size, alpha, color etc
## WITHOUT respect to the data itself

mpg %>% 
  ggplot(aes(x = displ, y = hwy)) +
  geom_point(size = 5, alpha = .4)

## You will notice that when the alpha is reduced, some points remain fairly opaque - 
## This is because there are overlapping points! With some datasets, this could create a problem
## by misrepresenting the presence of data. Another way to reveal hidden data is to use
## position = position_jitter() within the geom_point layer
## Read the position_jitter() function help page to learn more
?position_jitter()

mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2,
             position = position_jitter())

## Notice that now, you can see more points that were otherwise hidden!


# 4. Scales ---------------------------------------------------------------


## So what do we do when we don't want to use the default color pallets, shapes, sizes, etc?
## That is where we get into scales.
## Scales tell ggplot how you want the aesthetics of the data to be represented.

mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2) +
  scale_color_brewer(palette = "Dark2")

## Show color palette cheatsheet from powerpoint (and on shared Google Drive!)

## You don't have to rely on the predetermined palettes - you can set colors manually

## Scale manual to highlight the 2seater points
mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2) +
  scale_color_manual(values = c("red", "black", "black", "black", "black", "black", "black"))


## You can also specify colors when color is assigned to a continuous variable, like displacement
## scale_color_gradient allows you to specify and high and a low value, while 
## scale_color_gradient2 allows you to specificy a midpoint as well
mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = displ)) +
  geom_point(size = 2) +
  scale_color_gradient2(low = "red", mid = "gray50", midpoint = 4, high = "blue")




# 5. Adding extra geoms ---------------------------------------------------

## When we assign columns to the aes() arguement within ggplot(), all geoms adopt those aesthetics by default
## Notice that there are trendlines for each class, as specified by color!
mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  geom_smooth(method = "lm",
              alpha = 0.25) +
  theme_bw()

## If we remove class as a separate aesthetic, then the trendline becomes a trendline for the whole
## dataset - not specific to class
mpg %>% 
  ggplot(aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(method = "lm",
              alpha = 0.25) +
  theme_bw()

## If we still want the points to have the color aesthetic assigned to class, but not have geom_smooth 
## adopt it, then we can specify color = class in geom_point()'s aesthetic only!
mpg %>% 
  ggplot(aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(method = "lm",
              alpha = 0.25) +
  theme_bw()
## With this code, both geom_point and geom_smooth are still adopting the x = displ and y = hwy aesthetics,
## since those were specified in ggplot(), but ONLY geom_point() adopts the color = class aesthetic


## What do we do if we want to create a trendline, but ONLY for one "class" of car?
## The function subset() will help us out!
## With subset, we tell geom_smooth() to only use data for a particular condition - a particular class of car. We do this by subsetting the data that goes into the geom_smooth function
# By default, geom_smooth() (and geom_point) inherits both 1) the data that we fed into ggplot(), and 2) the aesthetics that we chose within the ggplot() function.
# By changing the data argument of geom_smooth(), we make it so that the only data geom_smooth sees is what we subsetted - only rows from mpg that have "compact" in the "class" column
mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  geom_smooth(data = subset(mpg, class == "compact"),
              method = "lm",
              alpha = 0.25) +
  theme_bw()


# 6. Theme() --------------------------------------------------------------

## With scales and aesthetics, we are directly changing how data is represented in the graph,
## and that can have very serious implications for how that data is interpreted.
## Themes, in contrast, don't modify the data at all. It just changes how the plot looks
## This includes things like font type, font size, plot lines, legend position, etc

## ggplot has built in themes. Let's try some with a previous graph:

mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2) +
  scale_color_brewer(palette = "Dark2") +
  theme_classic()


## Notice how the plot lines, fonts, etc vary with each preset theme
## Each of these components can be individual changed too!
## Let's experiment: First, we add the theme() layer to our ggplot

## Use the following line to visit the help page and see the many, many 
## plot components that you can modify!
?theme()

## Let's change the x-axis text size
mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2) +
  scale_color_brewer(palette = "Dark2") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 14))


## The title is still small, so we can change that too, and make it a little bigger
mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2) +
  scale_color_brewer(palette = "Dark2") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 14),
        axis.title.x = element_text(size = 16))

## And then we can do the same for the y axis: we add the same code, 
## but instead of specifying x-axis with .x, we write .y
mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2) +
  scale_color_brewer(palette = "Dark2") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 14),
        axis.title.x = element_text(size = 16),
        axis.text.y = element_text(size = 14),
        axis.title.y = element_text(size = 16))


## There are lines for each x-axis label, but also lines halfway between labels.
## If we want to remove those, we can change the panel.grid.minor argument. 
## (the lines at each label are controlled by panel.grid.major)
## Notice, when we modified the axis title/text, we specified the size within
## the element_text() function.
## When we want to totally remove a component, we use element_blank()

mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2.5) +
  scale_color_brewer(palette = "Dark2") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 14),
        axis.title.x = element_text(size = 16),
        axis.text.y = element_text(size = 14),
        axis.title.y = element_text(size = 16),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank())


## When we modify a component of the plot that is a line, rather than remove it,
## we use the element_line() function
mpg %>% 
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point(size = 2.5) +
  scale_color_brewer(palette = "Dark2") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 14),
        axis.title.x = element_text(size = 16),
        axis.text.y = element_text(size = 14),
        axis.title.y = element_text(size = 16),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major = element_line(color = "lightblue")
        )

## Check out the ggplot2 theme elements cheatsheet on the google drive to see what 
## arguments/functions correspond to which components of the plot!




# 7. Exporting plots ------------------------------------------------------

ggsave(filename = "~/Desktop/FIU_R_Workshop/workshop5_data_visualization_pt2/mpg_plot_2.pdf",
       width = 6,
       height = 5,
       dpi = 320)

