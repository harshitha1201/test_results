install.packages("readr", dependencies = TRUE)
install.packages("dplyr", dependencies = TRUE)
install.packages("ggplot2", dependencies = TRUE)
install.packages("sf", dependencies = TRUE)
install.packages("rnaturalearth", dependencies = TRUE)
install.packages("rnaturalearthdata", dependencies = TRUE)
install.packages("ggrepel", dependencies = TRUE)
install.packages("ggspatial", dependencies = TRUE)

# loading libraries
library(readr)
library(dplyr)
library(ggplot2)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggrepel)
library(ggspatial)

# reading data from csv file
platypus_data <- read_csv("platypus_2024.csv")
head(platypus_data)

# removing any duplicate rows
platypus_data_clean <- platypus_data %>% distinct()

# checking for duplicate rows
any(duplicated(platypus_data_clean))

# platypus sightings
platypus_data_filtered <- platypus_data_clean %>%
  filter(scientificName == "Ornithorhynchus anatinus" | 
         vernacularName == "Duck-billed Platypus")

# to see column names
colnames(platypus_data_filtered)

# converting to spatial format - SF object
platypus_sf <- st_as_sf(platypus_data_filtered, coords = c("decimalLongitude", "decimalLatitude"), remove = FALSE, crs = 4326)

# for Australia map
australia <- ne_countries(country = "Australia", scale = "medium", returnclass = "sf")
australia_states <- ne_states(country = "Australia", returnclass = "sf")



ggplot() +
  # map of australia
  geom_sf(data = australia, fill = "lightgray", color = "black") +
  
  # state boundaries
  geom_sf(data = australia_states, fill = NA, color = "darkgray", linetype = "dashed") +
  
  # platypus sightings
  geom_sf(data = platypus_sf, aes(color = "Platypus Sightings"), size = 2, alpha = 0.7) +
  
  # state names
  geom_text_repel(data = australia_states, aes(label = name, geometry = geometry), 
                  stat = "sf_coordinates", size = 3, color = "darkblue", force = 1) +
  
# arrow
  annotation_north_arrow(location = "tr", style = north_arrow_fancy_orienteering(), 
                         pad_x = unit(0.5, "cm"), pad_y = unit(0.5, "cm")) +
  
# scale
  annotation_scale(location = "bl", width_hint = 0.5) +

# legend
  scale_color_manual(name = "Legend", values = c("Platypus Sightings" = "blue")) +

# title
  labs(title = "Platypus Sightings in Australia (2024)",
       subtitle = "Data from Atlas of Living Australia",
       caption = "Map by Harshitha") +
  
  theme_minimal()



