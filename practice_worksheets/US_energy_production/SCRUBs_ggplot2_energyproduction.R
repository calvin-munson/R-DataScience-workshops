##
##
##    Practice problems: Visualize energy production in the US using ggplot2
##                
##    Authors:    Calvin J. Munson
##
##
##

library(tidyverse)
setwd("~/Desktop/R-DataScience-workshops/practice_worksheets/US_energy_production")


energy <- read_csv("US_EnergyProduction_broad.csv")


energy


energy.long <- pivot_longer(data = energy,
             col = c(3:5),
             names_to = "energy_type",
             values_to = "value")

pivot_longer(data = energy,
             col = -c(year, Unit),
             names_to = "energy_type",
             values_to = "value")

energy.long



## Graph replication challenge 
energy.long %>% 
  ggplot(aes(x = year, y = value, color = energy_type)) +
  # Make the line a little bit thicker (default is 0.5)
  geom_line(size = 0.75)

## Graph replication challenge 
energy.long %>% 
  ggplot(aes(x = year, y = value, color = energy_type)) +
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
                                     margin = margin(t = 0.5, unit = "cm"),
                                     family = "Times"),
        axis.title.y =  element_text(size = 12,
                                     # This one adds 0.5 cm of space to the RIGHT of the y title
                                     margin = margin(r = 0.5, unit = "cm")),
        axis.text = element_text(size = 11),
        text = element_text(family = "Times"),
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

specific_prod.perc %>% 
  ggplot(aes(x = year, y = perc.production, fill = energy_source)) +
  geom_boxplot()

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
