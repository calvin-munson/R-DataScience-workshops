##
##
## Workshop who knows
##
## Plastic waste
##

rm(list = ls())

library(GGally)



# 1. Read in data from Github website -------------------------------------

coast_vs_waste <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-21/coastal-population-vs-mismanaged-plastic.csv") %>% 
  rename(country = "Entity",
         country_code = "Code",
         year = "Year",
         mismanaged_plastic_tonnes = "Mismanaged plastic waste (tonnes)",
         coastal_population = "Coastal population",
         total_population = "Total population (Gapminder)") %>% 
  filter(year == 2010)

mismanaged_vs_gdp <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-21/per-capita-mismanaged-plastic-waste-vs-gdp-per-capita.csv") %>% 
  rename(country = "Entity",
         country_code = "Code",
         year = "Year",
         per_capita_mismanaged_plastic_kgperperson = "Per capita mismanaged plastic waste (kilograms per person per day)",
         GDP_per_capita = "GDP per capita, PPP (constant 2011 international $) (Rate)",
         total_population = "Total population (Gapminder)")

waste_vs_gdp <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-21/per-capita-plastic-waste-vs-gdp-per-capita.csv") %>% 
  rename(country = "Entity",
         country_code = "Code",
         year = "Year",
         per_capita_plastic_kgperperson = "Per capita plastic waste (kilograms per person per day)",
         GDP_per_capita = "GDP per capita, PPP (constant 2011 international $) (constant 2011 international $)",
         total_population = "Total population (Gapminder)")




# 2. Explore the data -----------------------------------------------------

coast_vs_waste %>% colnames()

mismanaged_vs_gdp %>% colnames()

waste_vs_gdp %>% colnames()


waste_vs_gdp$year %>% unique()


## Coast vs waste only has data for 2010
coast_vs_waste %>% 
  filter(coastal_population %>% is.na() == FALSE) %>% 
  select(year) %>% unique()


coast_vs_waste %>% 
  filter(coastal_population %>% is.na() == TRUE & mismanaged_plastic_tonnes %>% is.na() == FALSE)

## Remove countries with no data
clean_waste <- coast_vs_waste %>% 
  mutate(percent_coastal = coastal_population/total_population*100) %>% 
  filter(mismanaged_plastic_tonnes %>% is.na() == FALSE)

clean_waste %>% 
  ggplot(aes(total_population, mismanaged_plastic_tonnes)) +
  geom_point() +
  geom_text(aes(label = country)) +
  ylim(0, 3000000)




# * 2.1 Merge the data ----------------------------------------------------

merged_data <- merge(coast_vs_waste, mismanaged_vs_gdp, all = TRUE) %>% 
  merge(waste_vs_gdp, all = TRUE)

GDP_data <- merged_data %>% 
  select(country, country_code, year, total_population, GDP_per_capita)

plastic_data <- merged_data %>% 
  filter(year == 2010)

plastic.2 <- plastic_data %>% 
  mutate(percent_mismanaged = per_capita_mismanaged_plastic_kgperperson/per_capita_plastic_kgperperson*100)

plastic.2 %>% 
  ggplot(aes(total_population, mismanaged_plastic_tonnes, color = log(GDP_per_capita))) +
  geom_point() +
  scale_color_gradient2(low = "red", mid = "gray50", high = "blue", midpoint = mean(log(plastic.2$GDP_per_capita), na.rm = TRUE)) +
  scale_x_log10() +
  scale_y_log10()

plastic.2 %>% 
  select(-country, -country_code, -year) %>% 
  ggpairs() +
  theme_bw() 
