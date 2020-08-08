##
##
##    Workshop #TBD: Food Consumption!
##
##    Objective:  TBD
##                
##    Authors:    Calvin J. Munson
##
##    Date:       TBD
##
##
##



# 1. Read in the data -----------------------------------------------------

food_consumption <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-02-18/food_consumption.csv')



# 2. Explore the data -----------------------------------------------------

food_consumption

## What values do we have in each column?

# Country
food_consumption$country %>% unique()

# Food category
food_consumption$food_category %>% unique()

# Distribution of consumption (kg/person/year)
food_consumption %>% 
  ggplot(aes(consumption)) +
  geom_histogram(bins = 100)

# Distribution of emissions (Kg/person/year)
food_consumption %>% 
  ggplot(aes(co2_emmission)) +
  geom_histogram(bins = 100)


# 3. Calculate kg of emissions per kg of consumption ----------------------

food_emissions <- food_consumption %>% 
  mutate(co2_per_consumption = co2_emmission/consumption)


# 3. What food categories lead to the most emissions? ---------------------

food_emissions %>% 
  ggplot(aes(food_category, co2_per_consumption)) +
  geom_boxplot() +
  coord_flip()

food_emissions %>% 
  ggplot(aes(co2_per_consumption, fill = ..x..)) +
  geom_histogram() +
  facet_wrap(food_category ~., scales = "free")


# 4. Consumption vs emissions ---------------------------------------------

## Is there a relationship between the consumption of an item and its emissions for a given country?

# First, only x and y
food_consumption %>% 
  ggplot(aes(consumption, co2_emmission)) +
  geom_point() 

# What could be driving these very specific changes?? 
# Add color to food category!
food_consumption %>% 
  ggplot(aes(consumption, co2_emmission, color = food_category)) +
  geom_point()

# Introduce facet_wrap
food_consumption %>% 
  ggplot(aes(consumption, co2_emmission, color = food_category)) +
  geom_point() +
  facet_wrap(food_category ~.)

# Introduce freeing the scales
food_consumption %>% 
  ggplot(aes(consumption, co2_emmission, color = food_category)) +
  geom_point() +
  facet_wrap(food_category ~., scales = "free")



# X. Fancy graph exploration ----------------------------------------------

food_consumption %>% 
  ggplot(aes(x = food_category, y = consumption, fill = consumption)) +
  geom_jitter(width = .15, size = 3, shape = 21, alpha = .6) +
  coord_flip() +
  scale_fill_gradient2(low = "red4", mid = "white",
                       high = "blue3", midpoint = 50) +
  theme_minimal() +
  theme(panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        axis.title.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        legend.position = "none") 
