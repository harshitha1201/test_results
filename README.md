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
