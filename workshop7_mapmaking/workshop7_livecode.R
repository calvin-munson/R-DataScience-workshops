##
##
##    Workshop #7: Map-making with COVID data
##
##    Objective:   Become familiar with how to create basic maps using ggplot2
##                 and how to add data onto maps
##                
##    Authors:     Calvin J. Munson
##
##    Date:        Sept. 11th, 2020
##
##
##
##


# 1. Set up ---------------------------------------------------------------


## Load relevant packages
library(tidyverse)
library(mapproj)
library(shadowtext)

## Set working directory
setwd("~/Desktop/R-DataScience-workshops")


## Load COVID spatial county data
COVID_spatial <- read_csv("workshop7_mapmaking/COVID_spatial.csv")

## Load COVID spatial county data
state_names <- read_csv("workshop7_mapmaking/state_names.csv")

## Load US State map data
US_state_polygons <- map_data("state")



# 2. Start by making a basic map of the US --------------------------------

## Basic map
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               fill = "gray",
               color = "black")

## Add a projection
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               fill = "gray",
               color = "black") +
  ylim(25,28) +
  xlim(-83, -79) +
  coord_map()
  

# Help page
?coord_map()


# 3. Add COVID data per county --------------------------------------------

COVID_spatial

## Add COVID data as points
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               fill = "gray92",
               color = "white") +
  geom_point(data = COVID_spatial,
             aes(x = long, y = lat, size = cases),
             shape = 21,
             color = "red4",
             fill = "red",
             alpha = 0.3) +
  scale_size_continuous(range = c(0.1, 20),
                        breaks = c(100, 10000, 100000),
                        labels = c("100", "10,000", "100,000")) +
  coord_map(projection = "lambert", parameters = c("25", "49")) +
  theme_void() +
  theme(legend.position = c(0.15, 0.15),
        legend.title = element_blank())



# 4. Add state names on top -----------------------------------------------

ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               fill = "gray92",
               color = "white") +
  geom_point(data = COVID_spatial,
             aes(x = long, y = lat, size = cases),
             shape = 21,
             color = "red4",
             fill = "red",
             alpha = 0.3) +
  geom_shadowtext(data = state_names,
            aes(x = long, y = lat, label = state),
            size = 2,
            color = "gray35",
            bg.color = "white") +
  scale_size_continuous(range = c(0.1, 20),
                        breaks = c(100, 10000, 100000),
                        labels = c("100", "10,000", "100,000")) +
  ggtitle("Cumulative COVID-19 cases in the United States per county",
          subtitle = "Data from the New York Times COVID tracker") +
  coord_map(projection = "lambert", parameters = c("25", "49")) +
  theme_void() +
  theme(legend.position = c(0.15, 0.15),
        legend.title = element_blank(),
        plot.title = element_text(size = 12,
                                  hjust = 0.5,
                                  color = "gray30"),
        plot.subtitle = element_text(size = 9,
                                     hjust = 0.5,
                                     color = "gray30"))


?map_data()



