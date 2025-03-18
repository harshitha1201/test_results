install.packages(c("galah", "GSODR", "geosphere", "MASS", "dplyr", "ggplot2", "ggthemes", "viridis", "sf", "dbscan", "rnaturalearth", "rnaturalearthdata"))

library(galah)
library(GSODR)
library(geosphere)
library(MASS)     
library(dplyr)    
library(ggplot2) 
library(ggthemes)
library(viridis)
library(sf)       
library(dbscan)   
library(rnaturalearth)
library(rnaturalearthdata)

galah_config(email = "harshithadiddige24@gmail.com")

platypus_data <- galah_call() |>
  galah_identify("Ornithorhynchus anatinus") |>
  galah_filter(stateProvince == "Victoria") |>
  galah_select(eventDate, decimalLatitude, decimalLongitude) |>
  atlas_occurrences()

# Remove missing values
platypus_data <- platypus_data %>% 
  filter(!is.na(decimalLatitude) & !is.na(decimalLongitude))  

coords <- as.matrix(platypus_data[, c("decimalLongitude", "decimalLatitude")])

# Define different eps values to test
eps_values <- c(0.01, 0.03, 0.05, 0.07, 0.1)

for (eps in eps_values) {
  dbscan_result <- dbscan(coords, eps = eps, minPts = 5)
  platypus_data$cluster <- dbscan_result$cluster
  cluster_count <- length(unique(platypus_data$cluster)) - 1  # Exclude noise (0)
  
  cat("\n", eps, "\n")
  cat("Number of clusters:", cluster_count, "\n")
  cat("Noise points:", sum(platypus_data$cluster == 0), "\n")
  
  # Visualize the clustering
  ggplot(platypus_data, aes(x = decimalLongitude, y = decimalLatitude, color = as.factor(cluster))) +
    geom_point(size = 2) +
    theme_minimal() +
    labs(title = paste("DBSCAN Clustering (eps =", eps, ")"),
         color = "Cluster ID") +
    scale_color_manual(values = c("grey", rainbow(cluster_count))) # Noise in grey
}


kNNdistplot(coords, k = 5)
abline(h = 0.07, col = "red", lty = 2)  # Adjust chosen_eps based on the plot

# Run DBSCAN with the chosen eps (adjust as needed)
db <- dbscan(coords, eps = 0.07, minPts = 5)

# Check the number of clusters
table(db$cluster)

# Define the base map
ggplot() +
  # Add Australia map as background
  borders("world", regions = "Australia", fill = "gray90", colour = "black") +
  
  # Plot clusters with better colors and aesthetics
  geom_point(data = coords_df, 
             aes(x = decimalLongitude, y = decimalLatitude, color = cluster), 
             size = 0.5, alpha = 0.8) +
  
  # Highlight the densest cluster in red
  geom_point(data = coords_df %>% filter(cluster == densest_cluster), 
             aes(x = decimalLongitude, y = decimalLatitude), 
             color = "red", size = 1, shape = 8) +
  
  # Improve color scale
  scale_color_viridis_d(option = "plasma", name = "Cluster ID") +
  
  # Improve map aesthetics
  theme_minimal(base_size = 1) +
  theme(panel.background = element_rect(fill = "aliceblue"), 
        panel.grid.major = element_line(color = "gray80", linetype = "dashed")) +
  
  # Labels and title
  labs(title = "DBSCAN Clustering of Platypus Occurrences",
       subtitle = "Red Star: Densest Cluster",
       x = "Longitude", y = "Latitude")


# Convert results into a dataframe
coords_df <- as.data.frame(coords)
coords_df$cluster <- as.factor(db$cluster)  # Convert cluster IDs to a factor for coloring

# Find the most frequent cluster (excluding noise)
densest_cluster <- coords_df %>%
  filter(cluster != 0) %>%
  count(cluster, sort = TRUE) %>%
  slice(1) %>%
  pull(cluster)

# Get the central point of the densest cluster
hotspot_location <- coords_df %>%
  filter(cluster == densest_cluster) %>%
  summarise(
    target_lat = mean(decimalLatitude),
    target_lon = mean(decimalLongitude)
  )

print(hotspot_location)  # This is the main platypus hotspot


# Get all available Australian stations
australian_stations <- isd_history %>%
  filter(ISO2C == "AU") 

# Compute distance from the hotspot to all Australian stations
nearest_stations <- australian_stations %>%
  mutate(distance = distHaversine(matrix(c(LON, LAT), ncol = 2),
                                  matrix(c(hotspot_location$target_lon, hotspot_location$target_lat), ncol = 2))) %>%
  arrange(distance) %>%
  head(10)  # Get 10 closest stations

# Get the closest station to the hotspot location with valid data
station_data <- NULL  # Initialize storage

for (i in nearest_stations$STNID) {
    temp_data <- get_GSOD(years = 2024, station = i)

    if (nrow(temp_data) != 0) {
        print(paste("Found data for station:", i, "Rows:", nrow(temp_data)))
        station_data <- temp_data  # Save station data
        break  # Stop after finding the first station with data
    }
}

# Check if we found any station data
if (!is.null(station_data)) {
    write.csv(station_data, "station_data.csv")
    print("Weather data saved to station_data.csv")
} else {
    print("No GSOD data found for the nearest Victoria stations in 2024.")
}


weather_summary <- weather_data %>%
  select(STNID, YEARMODA, TEMP, SLP, STP)  # Including station pressure (STP)

# Print summary
summary(weather_summary)



