# GSOC test results - ecotourism
## EASY TASK

## Objective:

Download and visualize platypus occurrence data in Australia for 2024.
Generate a map displaying the spatial locations of sightings using two approaches: CSV-based and API-based (using galah).

## What We Did:

CSV-Based Approach:
Read data from platypus_2024.csv using readr.
Removed duplicate rows and filtered for platypus records with dplyr.
Converted the cleaned data into a spatial format (SF object) using sf.
Mapped sightings with ggplot2, adding state boundaries, a north arrow, and a scale bar.
galah-Based Approach:

API-based Approach:
Fetched platypus occurrence data for 2024 directly from the Atlas of Living Australia using the galah package.
Selected and filtered key columns, handling any missing coordinate data.
Converted the data into an SF object for spatial mapping.
Created a map similar to the CSV approach with ggplot2 enhancements.

## Run it using
source("easy/easy_using_csv.r")


### Data Sources
Atlas of Living Australia (ALA): The data for platypus occurrences is sourced from ALA. For the CSV approach, the data should be saved as platypus_2024.csv. In the API approach, data is fetched directly using the galah package.
Natural Earth Data: Used to obtain geographic boundaries for Australia and its states.


