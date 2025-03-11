# GSOC test results - ecotourism
## EASY TASK
### Project Overview
#### The project is structured around two methods: CSV-based Approach and API-based Approach using galah This project demonstrates how to extract and visualize occurrence data of the platypus in Australia for 2024. It includes steps for cleaning the data, converting it to a spatial format, and mapping the results over an outline of Australia with state boundaries, a north arrow, and a scale bar.

What We Did:

CSV-Based Approach:

Read data from platypus_2024.csv using readr.
Removed duplicate rows and filtered for platypus records with dplyr.
Converted the cleaned data into a spatial format (SF object) using sf.
Mapped sightings with ggplot2, adding state boundaries, a north arrow, and a scale bar.
galah-Based Approach:

Fetched platypus occurrence data for 2024 directly from the Atlas of Living Australia using the galah package.
Selected and filtered key columns, handling any missing coordinate data.
Converted the data into an SF object for spatial mapping.
Created a map similar to the CSV approach with ggplot2 enhancements.

### Data Sources
Atlas of Living Australia (ALA): The data for platypus occurrences is sourced from ALA. For the CSV approach, the data should be saved as platypus_2024.csv. In the API approach, data is fetched directly using the galah package.
Natural Earth Data: Used to obtain geographic boundaries for Australia and its states.

Usage
Approach 1: Using a CSV File
Data Preparation:

Place your platypus_2024.csv file in your working directory.
The CSV should contain columns such as decimalLatitude, decimalLongitude, scientificName, and vernacularName.
Running the Code:

The code reads the CSV file, removes duplicate rows, filters for records where either the scientific name is Ornithorhynchus anatinus or the vernacular name is "Duck-billed Platypus".
The cleaned data is then converted to an SF object.
A map is generated using ggplot2 that plots the platypus sightings on a map of Australia, with state boundaries, labels, a north arrow, and a scale bar.

Approach 2: Using the galah Package
Data Fetching:

The code uses galah_call() along with filters to identify records for Ornithorhynchus anatinus in the year 2024.
It then selects specific columns (latitude, longitude, and event date) and fetches the occurrence data directly from the Atlas of Living Australia.
The code checks for any missing coordinates and cleans the data accordingly.
Mapping:

The cleaned data is converted into an SF object.
A map is created with a similar layout to the CSV-based approach: plotting the occurrences over an outline of Australia with additional map features.
Code Explanation
Data Reading and Cleaning
CSV Approach:

Uses read_csv() from readr to load data.
Removes duplicates using distinct() from dplyr.
Filters sightings based on species names.
API Approach:

Uses a pipeline with galah functions to identify, filter, and select data.
Checks and removes any records with missing coordinates.
Spatial Conversion
Both approaches use st_as_sf() from the sf package to convert data frames to spatial (SF) objects using the longitude and latitude columns.
Map Generation
ggplot2 is used to layer the base map, state boundaries (using rnaturalearth), and the platypus sightings.
Additional layers such as geom_text_repel(), annotation_north_arrow(), and annotation_scale() enhance the map's readability.
The color scale is set using scale_color_manual() to differentiate the platypus sightings visually.
Titles, subtitles, and captions are added with labs().
Results
After running either approach, you will obtain a map displaying:

The geographical outline of Australia.
Dashed boundaries marking Australian states.
Points representing the locations of platypus sightings in 2024.
Annotated state names, a north arrow, and a scale bar for reference.
Credits
Data Source: Atlas of Living Australia
Mapping Data: Natural Earth (via rnaturalearth and rnaturalearthdata)
Map Creation & Analysis: Harshitha
License
Specify the license under which your project is distributed, for example:

This project is licensed under the MIT License - see the LICENSE file for details.
