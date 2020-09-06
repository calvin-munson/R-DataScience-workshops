##
##    Workshop #7: Map-making with COVID data
##
##    Objective:   Become familiar with how to create basic maps using ggplot2
##                 and how to add data onto maps
##                
##    Authors:    Calvin J. Munson
##
##    Date:       Sept. 6th, 2020
##
##
##


# 1. Set up ---------------------------------------------------------------

## Load relevant packages
library(tidyverse)
library(maps)
library(mapproj)

## Set working directory
setwd("~/Desktop/R-DataScience-workshops")

## Read in data

# Load United States state map data
US_states <- map_data("state")

state_names <- tibble(state = datasets::state.name,
                      long = datasets::state.center$x,
                      lat = datasets::state.center$y) %>%
  filter(state != "Alaska",
         state != "Hawaii")


# Load COVID data
COVID_counties <- read_csv("workshop7_mapmaking/us-counties-COVID.csv") %>% 
  filter(date == max(date)) %>% 
  mutate(fips = if_else(county == "New York City", "36061", fips))

# County centers
county_centers <- read_csv("workshop7_mapmaking/county_centers.csv") %>% 
  dplyr::select(fips, long = clon10, lat = clat10)



## Explore the data
US_states

## Unique FIPS
COVID_counties$fips %>% unique()

COVID_counties$date %>% max()

COVID_counties %>% 
  filter(state == "New York")

# 2. Bind latlong and COVID data ------------------------------------------

COVID_spatial <- COVID_counties %>% 
  merge(county_centers, all.x = TRUE) %>% 
  as_tibble() %>% 
  filter(state != "Alaska",
         state != "Hawaii")


COVID_spatial %>% 
  filter(long %>% is.na(),
         state != "Puerto Rico",
         state != "Virgin Islands",
         county != "Unknown") %>% View()


# 2. Start making the map -------------------------------------------------

## Use geom_polygon
ggplot() +
  geom_polygon(data = US_states,
               aes(x = long, y = lat, group = group),
               color = "black", fill = "gray")



## Add a projection
# see coord_map() help page for more projections
ggplot() +
  geom_polygon(data = US_states,
               aes(x = long, y = lat, group = group),
               color = "black", fill = "gray") +
  coord_map(projection = "lambert", parameters = c("25", "49"))

COVID_spatial %>% 
  filter(long < -150)

## Add on county COVID data
ggplot() +
  geom_polygon(data = US_states,
               aes(x = long, y = lat, group = group),
               color = "white", 
               fill = "gray92") +
  geom_point(data = COVID_spatial,
             aes(x = long, y = lat, size = cases),
             color = "red4",
             fill = "red",
             shape = 21,
             alpha = .3) +
  geom_text(data = state_names,
            aes(x = long, y = lat, label = state),
            color = "gray35",
            size = 2) +
  scale_size_continuous(breaks = c(10, 10000, 100000),
                        labels = c("10", "10,000", "100,000"),
                        range = c(.1, 20)) +
  coord_map(projection = "lambert", parameters = c("25", "49")) +
  theme_void() +
  theme(legend.position = c(0.15, 0.15),
        legend.title = element_blank())
