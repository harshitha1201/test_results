install.packages("tidygeocoder")
install.packages("dplyr")
install.packages("readr")
install.packages("tidyr")
install.packages("tidyverse")

library(tidygeocoder)
library(dplyr)
library(readr)
library(tidyr)
library(tidyverse)

# Not disclosing my opencage key
Sys.setenv(OPENCAGE_KEY = "my_api_key")

# to read trip data
df <- read.csv("trip_data.csv", stringsAsFactors = FALSE)

# skip first 8 rows to remove unnecessary headers
df <- read.csv("trip_data.csv", skip = 8, stringsAsFactors = FALSE)

# selecting only the SA2 column
df <- df %>% select(Stopover.state.region.SA2)

colnames(df)

# renaming the column to SA2
names(df) <- c("SA2")

# only distinct entries
df <- df %>% distinct(SA2)

# count of distinct entries
nrow(df)

# Places like Colo are also present in the USA
# appending Australia to each location, so that we get coordinates of places of Australia
df <- df %>% mutate(address = paste(SA2, ", Australia"))

# geocoding using 'osm' - openstreetmap
df <- df %>%
  geocode(address, method = "osm", lat = latitude, long = longitude)

# saved data for future use
write.csv(df, "geocoded_trip_data.csv", row.names = FALSE)
df <- read.csv("geocoded_trip_data.csv")

# rows with lat/lon as NA
df_failed <- df %>% filter(is.na(latitude) | is.na(longitude))


# Read CSV file
data <- read_csv("geocoded_trip_data.csv")

# Keep only rows with missing lat/lon and which are distinct
data <- data %>%
  filter(is.na(latitude) | is.na(longitude)) %>%
  select(SA2) %>%
  distinct() 

# fixing '-' in directions, so that osm can recognize the locations
data <- data %>%
  mutate(SA2 = str_replace_all(SA2, " - East", " East")) %>%
  mutate(SA2 = str_replace_all(SA2, " - West", " West")) %>%
  mutate(SA2 = str_replace_all(SA2, " - North", " North")) %>%
  mutate(SA2 = str_replace_all(SA2, " - South", " South")) %>%
  mutate(row_id = row_number())  # for groupby

head(data)

# Expand suburbs into separate rows (for centroid calculation & individual geocoding)
data_expanded <- data %>%
  separate_rows(SA2, sep = "- ") %>%
  mutate(SA2 = str_trim(SA2)) %>%
  mutate(SA2 = paste(SA2, "Australia"))

head(data_expanded)


# Geocode each suburb using OpenCage
geo_data <- data_expanded %>%
  geocode(SA2, method = "opencage", lat = "latitude", long = "longitude")

geo_data

# Compute centroid for each original row_id, keeping the full SA2 name
centroids <- geo_data %>%
  group_by(row_id) %>%
  summarise(SA2 = first(data$SA2[row_id]),  # Keep the full original SA2 name
            lat = mean(latitude, na.rm = TRUE),
            lon = mean(longitude, na.rm = TRUE),
            .groups = "drop")

# renaming columns
centroids <- centroids %>%
  rename(latitude = lat, longitude = lon)

# Filter df to remove rows with NA in latitude or longitude
df_filter <- df %>%
  filter(!is.na(latitude) & !is.na(longitude))


# show columns where latitude,longitude is not NA
centroids_filter <- centroids %>%
  filter(!is.na(latitude) & !is.na(longitude))


# show columns where latitude,longitude is not NA
combined_df <- bind_rows(
  df_filter %>% select(SA2, latitude, longitude),
  centroids_filter %>% select(SA2, latitude, longitude)
)

# to format the order of columns, same as they were in the input
new_df <- df %>%
  full_join(combined_df, by = "SA2") %>%
  select(SA2, latitude.y, longitude.y)  # Keep only these columns


new_df


