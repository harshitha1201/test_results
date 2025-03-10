install.packages("galah") 
install.packages("sf") 
install.packages("rnaturalearth")
install.packages("ggplot2")
install.packages("ggspatial")
install.packages("ggrepel")

library(galah)
library(sf)
library(rnaturalearth)
library(ggplot2)
library(ggspatial)
library(ggrepel)

# platypus occurrences in 2024
platypus_data <- galah_call() |>
  galah_identify("Ornithorhynchus anatinus") |>  # Platypus scientific name
  galah_filter(year == 2024) |>                  # year - 2024
  atlas_occurrences()                            # occurrence data

# column names
colnames(platypus_data)

# mentioning the correct column names
platypus_data <- galah_call() |>
  galah_identify("Ornithorhynchus anatinus") |> 
  galah_filter(year == 2024) |>                 
  galah_select(decimalLatitude, decimalLongitude, eventDate) |> 
  atlas_occurrences()  

head(platypus_data)


# to see if there are any missing records
missing_coords <- platypus_data |>
  filter(is.na(decimalLatitude) | is.na(decimalLongitude))


# view rows with missing coordinates
print(missing_coords)

# remove rows with missing coordinates
platypus_clean <- platypus_data |>
  filter(!is.na(decimalLatitude) & !is.na(decimalLongitude))

print(platypus_clean)

# Verify no missing coordinates in the cleaned data
missing_coords_clean <- platypus_clean |>
  filter(is.na(decimalLatitude) | is.na(decimalLongitude))

print(missing_coords_clean)
# data is clean - basically, there were no missing records

# converting dataframe to an SF object
platypus_sf <- st_as_sf(platypus_clean, coords = c("decimalLongitude", "decimalLatitude"), crs = 4326)

# to load a map of Australia
australia <- st_as_sf(maps::map("world", region = "Australia", plot = FALSE, fill = TRUE))
australia_states <- ne_states(country = "Australia", returnclass = "sf")

ggplot() +
  # for Australia map
  geom_sf(data = australia, fill = "lightgray", color = "black") +
  
  # for state boundaries
  geom_sf(data = australia_states, fill = NA, color = "darkgray", linetype = "dashed") +
  
  # for platypus sightings
  geom_sf(data = platypus_sf, aes(color = "Platypus Sightings"), size = 2, alpha = 0.7) +
  
  # for state names
  geom_text_repel( data = australia_states, aes(label = name, geometry = geometry),stat = "sf_coordinates",size = 3,color = "darkblue",force = 1) +
  
  # for a north arrow
  annotation_north_arrow(location = "tr", style = north_arrow_fancy_orienteering(),pad_x = unit(0.5, "cm"),pad_y = unit(0.5, "cm")) +
  
  # for a scale bar
  annotation_scale(location = "bl",width_hint = 0.5) +
  
  scale_color_manual(name = "Legend",values = c("Platypus Sightings" = "blue")) +
  
  # Add titles and labels
  labs(title = "Platypus Sightings in Australia (2024)",subtitle = "Data from Atlas of Living Australia",caption = "Map by Harshitha") +
  
  theme_minimal()
