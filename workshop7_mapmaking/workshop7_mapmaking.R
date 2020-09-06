##
##    Workshop #7: Map-making with COVID data
##
##    Objective:   Become familiar with how to create basic maps using ggplot2
##                 and how to add data onto maps
##                
##    Authors:     Calvin J. Munson
##
##    Date:        Sept. 6th, 2020
##
##    Note:        Section 0 "Prepare raw data" is how I prepared the raw data for this 
##                 workshop. The data came from multiple different sources, including 
##                 census data and COVID data from the New York Times. I bound it all 
##                 together and cleaned it so that it would be easier to work with in 
##                 session. Feel free to look through section 0, but the workshop should 
##                 be started with section 1 "Set up"
##
##

## Brief intro:

# There are some incredible spatial analyses you can do using R! I personally am not too
# experienced at it, so we will stick with making some relatively simple maps today and 
# adjusting various aesthetic components to make them look pretty.

# If you are interested in branching out further with spatial data, I highly recommend 
# taking a GIS course or looking through some open source R tutorials.



# 0. Prepare raw data ---------------------------------------------------------------

## This section is where I manipulate and bind together a bunch of the raw data used to 
 # creat this assignment. 
 # I then export the nice clean data, which is what I have the students work with for 
 # the course:

## SKIP this section and begin in section 1


# * 0.1 Load packages and data --------------------------------------------

## Load relevant packages
library(tidyverse)
library(maps)
library(mapproj)
library(shadowtext)

## Set working directory
setwd("~/Desktop/R-DataScience-workshops")

## Read in data

# Load United States state map data
US_state_polygons <- map_data("state")

# Load state names and coordinates from the built-in datasets package
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
  dplyr::select(fips, long = pclon10, lat = pclat10)



## Explore the data
US_state_polygons

## Unique FIPS
COVID_counties$fips %>% unique()

COVID_counties$date %>% max()

COVID_counties %>% 
  filter(state == "New York")


# * 0.2 Bind COVID and lat/long data --------------------------------------

COVID_spatial <- COVID_counties %>% 
  merge(county_centers, all.x = TRUE) %>% 
  as_tibble() %>% 
  filter(state != "Alaska",
         state != "Hawaii",
         long %>% is.na() == FALSE,
         lat %>% is.na() == FALSE)



# * 0.3 Export the clean data for the students ----------------------------

## Export COVID/county data
write_csv(COVID_spatial, "workshop7_mapmaking/COVID_spatial.csv")

## Export state names data
write_csv(state_names, "workshop7_mapmaking/state_names.csv")




# 1. Set up ---------------------------------------------------------------


## Load relevant packages
library(tidyverse)
library(mapproj)
library(shadowtext)

## Set working directory
setwd("~/Desktop/R-DataScience-workshops")

## Read in data

# Load United States state map data
US_state_polygons <- map_data("state")

# Load spatial COVID county case data
COVID_spatial <- read_csv("workshop7_mapmaking/COVID_spatial.csv")

# Load spatial data for each state's geographic center
state_names <- read_csv("workshop7_mapmaking/state_names.csv")




# 2. Start by making a basic map of the United States ---------------------------------

## The data to make a map is in a funky format called a polygon. A similar common format is
 # called a "shapefile". Through methods that I do not know, plotting programs use the polygon 
 # data to draw the boundaries of each object (in this example those objects are states). In 
 # ggplot, we use the geom_polygon() function to do this.

## We will be overlaying data from multiple different sources on this plot, so instead of putting
 # the data and aes() arguments within the ggplot() function, put them directly within the geom_polygon()
 # function. Putting data and aesthetics in the ggplot() function forces all other functions (e.g. 
 # geom_polygon(), geom_point(), geom_text()) to inherit that same data, which we do not want here.



# * 2.1 geom_polygon() ----------------------------------------------------


## Use geom_polygon to plot the data from US_state_polygons
 # In the aesthetics, we aso put group = group (the second group is a column in our dataframe which 
 # corresponds to a specific state). This tells ggplot to connect all borders properly for each state
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               color = "black", fill = "gray")




# * 2.2 Add a projection --------------------------------------------------


## The Earth is a sphere, yet when we make maps, we take this 3-dimensional structure
 # and try to fit it on a 2-dimensional surface (e.g. our computer screen, a sheet of paper).
 # This process inherently causes there to be errors in how we perceive various areas on the 
 # globe. See https://en.wikipedia.org/wiki/Map_projection for way more.

## Based on what portion of the world we want to look at, and what aspects of that area we
 # want to make look most accurate, we use various different projections. Using the coord_map()
 # function, we can tell ggplot that this is a map (rather than a normal plot), as well as what 
 # projection we want. 

## See coord_map() and mapproject() help pages for a wide array of projections to use.
?coord_map()
?mapproject()

## Play around with various projections here

# Mercator projection
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               color = "black", fill = "gray") +
  coord_map(projection = "mercator")

# Orthographic projection
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               color = "black", fill = "gray") +
  coord_map(projection = "orthographic")

# Lambert projection with specific latitudinal parameters that fit the range
 # of our data (this is the projection we will stick with)
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               color = "black", fill = "gray") +
  coord_map(projection = "lambert", parameters = c("25", "49"))




# 3. Add on the COVID data per county -------------------------------------

## Now that we have the basemap set up, we can add on various other features to our map!
 # This is an excellent way to visualize how ggplot works: Even with a normal graph, each
 # set of points, lines, barcharts, etc. is simply another layer on our figure.




# * 3.1 Add the points onto the graph -------------------------------------

## Check out the first handful of rows for the COVID data:
COVID_spatial
# For each county, the dataframe has that county's latitude and longitude (lat/long),
# as well as the total number of cases and deaths as of this past Sunday (Sept. 5th, 2020).

## I want you to think of adding on these points just like if this were a scatterplot:
 # The x-axis is the longitude value and the y-axis is the latitude value, and we will add 
 # a point at each of those coordinates. Then, we want to scale the size of each of those 
 # points by the number of cases.

ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               color = "black", 
               fill = "gray") +
  geom_point(data = COVID_spatial,
             aes(x = long, y = lat, size = cases)) +
  coord_map(projection = "lambert", parameters = c("25", "49"))



# * 3.2 Change some colors to reflect the NYT graph -----------------------

## This graph is a total mess: let's adjust the fill of the states, the color of the outlines, 
 # and the color, fill, shape, and transparancy of the points
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               color = "white", 
               fill = "gray92") +
  geom_point(data = COVID_spatial,
             aes(x = long, y = lat, size = cases),
             color = "red4",
             fill = "red",
             shape = 21, 
             alpha = .3) +
  coord_map(projection = "lambert", parameters = c("25", "49"))



# * 3.3 Change the size scaling of the points -----------------------------


## Next, let's add some scaling so that the point sizes and the legends 
 # are a bit more pleasing to look at. We do this using the scale_size_continuous() 
 # function.
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               color = "white", 
               fill = "gray92") +
  geom_point(data = COVID_spatial,
             aes(x = long, y = lat, size = cases),
             color = "red4",
             fill = "red",
             shape = 21, 
             alpha = .3) +
  # "breaks" tells ggplot which numbers to include in the legend
  # labels tells ggplot how to label these breaks (for us, include the comma)
  # Lastly, range tells ggplot what the range of point sizes should be for the 
    # min. and max. size values. The default is 1 to 6
  scale_size_continuous(breaks = c(10, 10000, 100000),
                        labels = c("10", "10,000", "100,000"),
                        range = c(.1, 20)) +
  coord_map(projection = "lambert", parameters = c("25", "49"))




# * 3.4 Add some theme elements -------------------------------------------

## Next, let's change some more theme elements in order to make the graph look
 # better - and more similar to the NYT graph. theme_void() removes practically 
 # all axis, title, and background stuff. Let's also remove the legend title and
 # move the legend underneath California/Arizona
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               color = "white", 
               fill = "gray92") +
  geom_point(data = COVID_spatial,
             aes(x = long, y = lat, size = cases),
             color = "red4",
             fill = "red",
             shape = 21, 
             alpha = .3) +
  scale_size_continuous(breaks = c(10, 10000, 100000),
                        labels = c("10", "10,000", "100,000"),
                        range = c(.1, 20)) +
  coord_map(projection = "lambert", parameters = c("25", "49")) +
  theme_void() +
  theme(legend.position = c(0.15, 0.15),
        legend.title = element_blank())



# 4. Add state names on top -----------------------------------------------



# * 4.1 geom_text() -------------------------------------------------------

## Again, we are adding a new layer to this graph. This time we will use geom_text()
 # to display data from the state_names dataframe. Just like with the points, we will
 # tell geom_text to use long as the x-axis values, lat as the y-axis, and then the label
 # will come from the column called "state"
ggplot() +
  geom_polygon(data = US_state_polygons,
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


# * 4.2 geom_shadowtext() --------------------------------------------------

## While making these graphs initially, I noticed that the state names in the
 # Eastern US were hard to read because they were so dark - the NYT graph has a
 # white shadow surrounding the letters. After a quick Google search, I found a new
 # package called "shadowtext", which is the exact same as geom_text(), but allows
 # you to create a "shadow" around your points using the bg.color argument!
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               color = "white", 
               fill = "gray92") +
  geom_point(data = COVID_spatial,
             aes(x = long, y = lat, size = cases),
             color = "red4",
             fill = "red",
             shape = 21, 
             alpha = .3) +
  geom_shadowtext(data = state_names,
                  aes(x = long, y = lat, label = state),
                  color = "gray35",
                  bg.color = "white",
                  size = 2) +
  scale_size_continuous(breaks = c(10, 10000, 100000),
                        labels = c("10", "10,000", "100,000"),
                        range = c(.1, 20)) +
  coord_map(projection = "lambert", parameters = c("25", "49")) +
  theme_void() +
  theme(legend.position = c(0.15, 0.15),
        legend.title = element_blank())


## It's much easier to read the state names now!



# * 4.3 Final map! --------------------------------------------------------

## Lastly, let's add a plot title and subtitle to our final map, and export it
 # to our folder!


## Full map
ggplot() +
  geom_polygon(data = US_state_polygons,
               aes(x = long, y = lat, group = group),
               color = "white", 
               fill = "gray92") +
  geom_point(data = COVID_spatial,
             aes(x = long, y = lat, size = cases),
             color = "red4",
             fill = "red",
             shape = 21, 
             alpha = .3) +
  geom_shadowtext(data = state_names,
                  aes(x = long, y = lat, label = state),
                  color = "gray35",
                  bg.color = "white",
                  size = 2) +
  scale_size_continuous(breaks = c(10, 10000, 100000),
                        labels = c("10", "10,000", "100,000"),
                        range = c(.1, 20)) +
  coord_map(projection = "lambert", parameters = c("25", "49")) +
  ggtitle("Cumulative COVID-19 cases in the United States per county",
          # This paste0() function allows you to take a number from elsewhere and add it into a title
          # You don't have to included the "Date updated" part if you don't want to
          subtitle = paste0("Data updated ", max(COVID_spatial$date), " from the New York Times COVID-19 tracker (https://github.com/nytimes/covid-19-data)")) +
  theme_void() +
  theme(legend.position = c(0.15, 0.15),
        plot.title = element_text(size = 12,
                                  hjust = 0.5,
                                  color = "gray30",
                                  margin = margin(b = 5, unit = "pt")),
        plot.subtitle = element_text(size = 9,
                                  hjust = 0.5,
                                  color = "gray30"),
        legend.title = element_blank())


## Export the map
 # This saves the very last plot that was created in your "plot window". Just like when 
 # reading in a file, write the full file name/path, as well as the file type (e.g. .png, .pdf, .jpeg),
 # height, width, and pixel density
ggsave("workshop7_mapmaking/COVID_cumulative.png",
       width = 9,
       height = 5.5,
       dpi = 480)

