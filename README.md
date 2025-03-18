# GSOC Test Results - Ecotourism

## EASY TASK

### Objective

Download and visualize platypus occurrence data in Australia for 2024.  
Generate a map displaying the spatial locations of sightings using two approaches: CSV-based and API-based (using **galah**).

### What We Did

#### CSV-Based Approach
- **Data Reading:**  Read data from `platypus_2024.csv` using **readr**.
- **Data Cleaning:**  Removed duplicate rows and filtered for platypus records using **dplyr**.
- **Data Conversion:**  Converted the cleaned data into a spatial format (SF object) using **sf**.
- **Mapping:**  Mapped sightings with **ggplot2**, adding state boundaries, a north arrow, and a scale bar.

#### API-Based Approach (galah-Based Approach)
- **Data Fetching:**  Fetched platypus occurrence data for 2024 directly from the Atlas of Living Australia using the **galah** package.
- **Data Filtering:**  Selected and filtered key columns, handling any missing coordinate data.
- **Data Conversion:**  Converted the data into an SF object for spatial mapping.
- **Mapping:**  Created a map similar to the CSV approach with **ggplot2** enhancements.

### Run it using

```r
source("easy/easy_using_csv.r")

## Medium Task

### Objective  

Analyze and visualize **platypus occurrence data** in Victoria, Australia, for 2024.  
Perform **DBSCAN clustering** to identify hotspots and retrieve **weather data** from the nearest station.  

### What We Did  

#### **Platypus Data Retrieval**  

- **API-Based Approach**  
  - Used the **galah** package to fetch occurrence data for *Ornithorhynchus anatinus* (platypus) in Victoria.  
- **Data Cleaning**  
  - Removed records with missing latitude/longitude values.  

#### **DBSCAN Clustering**  

- **Clustering Analysis**  
  - Converted occurrence data into a coordinate matrix.  
  - Tested multiple `eps` values (`0.01, 0.03, 0.05, 0.07, 0.1`) to find optimal clustering.  
  - Visualized clustering results using **ggplot2**.  
- **Densest Cluster Identification**  
  - Determined the cluster with the highest occurrence count.  
  - Highlighted the densest cluster on the map.  

#### **Weather Data Retrieval**  

- **Identified Nearest Weather Station**  
  - Used **GSODR** to list Australian weather stations.  
  - Computed distances between the platypus hotspot and nearby stations using **geosphere**.  
  - Retrieved 2024 weather data from the nearest available station.  
- **Weather Summary**  
  - Extracted key parameters: **Temperature (TEMP), Sea Level Pressure (SLP), and Station Pressure (STP)**.  
  - Saved the data to `station_data.csv`.  

### Dependencies  

Ensure the following R packages are installed:  

```r
install.packages(c("galah", "GSODR", "geosphere", "MASS", "dplyr", "ggplot2", 
                   "ggthemes", "viridis", "sf", "dbscan", "rnaturalearth", 
                   "rnaturalearthdata"))

