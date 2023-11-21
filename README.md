# Cyclistic Bike-Share: Case Study

_This document is created as part of the capstone project of the Google Data Analytics Professional Certificate._
## Introduction and Scenario
You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.
### About the Company
In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geo-tracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime

The project follows the six step data analysis process: **ask, prepare, process, analyze, share, and act.**

## PHASE 1: Ask
Three questions will guide the future marketing program:

1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?

The director of marketing has assigned you the first question to answer: **How do annual members and casual riders use Cyclistic bikes differently?**

#### Summary of Business Task

The goal of this case study is to identify how do annual members and casual riders use Cyclistic bikes differently.

This comparison along with other tasks will later be used by marketing department for developing strategies aimed at converting casual riders into members

#### Stakeholders:

* **Primary stakeholders**: The director of marketing and Cyclistic executive team

* **Secondary stakeholders**: Cyclistic marketing analytics team

## PHASE 2: Data Preparation
The data that we will be using is Cyclistic’s historical trip data from last 12 months (May-2020 to Apr-2021). The data has been made available by Motivate International Inc. on this [link](https://divvy-tripdata.s3.amazonaws.com/index.html) under this [license](https://divvybikes.com/data-license-agreement).

The dataset consists of 12 CSV files (each for a month) with 13 columns and more than 4 million rows.

ROCCC approach is used to determine the credibility of the data

* **R**eliable – It is complete and accurate and it represents all bike rides taken in the city of Chicago for the selected duration of our analysis.
* **O**riginal - The data is made available by Motivate International Inc. which operates the city of Chicago’s Divvy bicycle sharing service which is powered by Lyft.
* **C**omprehensive - the data includes all information about ride details including starting time, ending time, station name, station ID, type of membership and many more.
* **C**urrent – It is up-to-date as it includes data until end of May 2021
* **C**ited - The data is cited and is available under Data License Agreement.

#### Data Limitation

A quick filtering and checking data for completeness shows that “start station name and ID” and “end station name and ID” for some rides are missing. Further observations suggest that the most missing data about “start station name” belongs to “electric bikes” as 201,975 out of 888,490 electric ride shares have missing data and it accounts for 22% of total electric-bike ride shares.

This limitation could slightly affect our analysis for finding stations where most electric-bikes are taken but we can use “end station names” to locate our customers and this can be used for further analysis and potential marketing campaigns. 
## PHASE 3: Process

Before we start analyzing, it is necessary to make sure data is clean, free of error and in the right format.

### Tasks:
**1. Tools:** R Programming is used for its ability to handle huge datasets efficiently.

```r
#Installing the packages
install.packages('tidyverse')
install.packages('janitor')
install.packages('lubridate')
#Loading the packages
library(tidyverse)
library(janitor)
library(lubridate)
```
**2. Upload** : Uploading Divvy datasets (csv files)
```r
May_2021_divvy_tripdata <- read_csv("data/May 2021-divvy-tripdata.csv")
Jun_2021_divvy_tripdata <- read_csv("data/Jun 2021-divvy-tripdata.csv")
Jul_2021_divvy_tripdata <- read_csv("data/Jul 2021-divvy-tripdata.csv")
Aug_2021_divvy_tripdata <- read_csv("data/Aug 2021-divvy-tripdata.csv")
sep_2021_divvy_tripdata <- read_csv("data/Sep 2021-divvy-tripdata.csv")
Oct_2021_divvy_tripdata <- read_csv("data/Oct 2021-divvy-tripdata.csv")
Nov_2021_divvy_tripdata <- read_csv("data/Nov 2021-divvy-tripdata.csv")
Dec_2021_divvy_tripdata <- read_csv("data/Dec 2021-divvy-tripdata.csv")
Jan_2022_divvy_tripdata <- read_csv("data/Jan 2022-divvy-tripdata.csv")
Feb_2022_divvy_tripdata <- read_csv("data/Feb 2022-divvy-tripdata.csv")
Mar_2022_divvy_tripdata <- read_csv("data/Mar 2022-divvy-tripdata.csv")
Apr_2022_divvy_tripdata <- read_csv("data/Apr 2022-divvy-tripdata.csv")
```
**3. Readability**: add a new name for the imported csv’s to help with readability.

**4. Verfiy** : Verifying if the data is stored
```r
#str(dataset_name)
str(Jan2021)
str(Feb2021)
str(Mar2021)
str(Apr2021)
str(May2021)
str(Jun2021)
str(Jul2021)
str(Aug2021)
str(Sep2021)
str(Oct2021)
str(Nov2021)
str(Dec2021)
``` 
**5. Merge**: Merging all the data in single variable
```r
#Creating new dataset name <- binding rows(all_your_datasets)
merged_df <- bind_rows(Jan2021, Feb2021, Mar2021, Apr2021, May2021, Jun2021, Jul2021, Aug2021, Sep2021, Oct2021, Nov2021, Dec2021
#Cleaning & removing any spaces, parentheses, etc.
merged_df <- clean_names(merged_df)
```
**6. Clean**: We should also remove any empty columns and rows in our dataframe, we can do so by using remove_empty().
```r
#removing_empty(dataset_name, by leaving c() empty, it selects rows & columns)
remove_empty(merged_df, which = c())
```
**7. Preparing for analysis**: 
* Day of the week — By using wday()
```r
#df_name$your_new_column_name <- wday(df_name$select_column, label = T/F, abbr = T/F)
merged_df$day_of_week <- wday(merged_df$started_at, label = T, abbr = T)
```
* Start hour — By using format(as.POSIXct))
```r
#df_name$your_new_column_name <- format(as.POSIXct(df_name$select_column, '%time_format')
merged_df$starting_hour <- format(as.POSIXct(merged_df$started_at), '%H')
```
* Month — By using format(as.Date))
```r
#df_name$your_new_column_name <- format(as.Date(df_name$select_column), '%date_format')
merged_df$month <- format(as.Date(merged_df$started_at), '%m')
```
* Trip Duration — By using difftime()
```r
#df_name$your_new_column_name <- difftime(df_name$usually_end_time_column, df_name$usually_start_time_column, units = 'your_desired_unit')
merged_df$trip_duration <- difftime(merged_df$ended_at, merged_df$started_at, units ='sec')
```
**8. Final Cleaning** : After processing and cleaning our data, it is essential to clean one last time, as our added columns may have errors within them.
```r
cleaned_df <- merged_df[!(merged_df$trip_duration<=0),]
```
## PHASE 4: Analyzing Data
* Performed data aggregation using R Programming. Click [here](https://github.com/SrushtiGaidhane/Google-Data-Analytics-Case-Study/blob/main/app.R) to view the R script and the summary of complete analysis process.
Further analysis were carried out to perform calculations, identify trends and relationships using RStudio. A visualization using dashboard was also created using Shiny Dashboard.
* In order to carry out our plotting, we will be using ggplot() in RStudio.
```r
options(scipen = 999)
ggplot(data = cleaned_df) +
  aes(x = day_of_week, fill = member_casual) +
  geom_bar(position = 'dodge') +
  labs(x = 'Day of week', y = 'Number of rides', fill = 'Member type', title = 'Number of rides by member type')
ggsave("number_of_rides_by_member_type.png")

```

```r
ggplot(data = cleaned_df) +
  aes(x = month, fill = member_casual) +
  geom_bar(position = 'dodge') +
  labs(x = 'Month', y = 'Number of rides', fill = 'Member type', title = 'Number of rides per month')
ggsave("number_of_rides_per_month.png")
```

```r
ggplot(data = cleaned_df) +
  aes(x = starting_hour, fill = member_casual) +
  facet_wrap(~day_of_week) +
  geom_bar() +
  labs(x = 'Starting hour', y = 'Number of rides', fill = 'Member type', title = 'Hourly use of bikes throughout the week') +
  theme(axis.text = element_text(size = 5))
ggsave("Hourly_use_of_bikes_throughout_the_week.png", dpi = 1000)
```
![image](https://github.com/SrushtiGaidhane/Google-Data-Analytics-Case-Study/assets/103986230/1c851761-265d-4070-8cf7-92e9375fcf8a)

## PHASE 5: Share
* Shiny Dashboard is used for visualization using RStudio
   ![here](https://github.com/SrushtiGaidhane/Google-Data-Analytics-Case-Study/assets/103986230/0c0ccf8c-4f43-45bf-9ed0-27c754793bea)

## PHASE 6: Act
After analyzing, we reached to the following conclusion:

* Casual riders take less number of rides but for longer durations.
* Casual Riders are most active on weekends, and the months of June and July.
* Casual riders mostly use bikes for recreational purposes.

Here are my top 3 recommendations based on above key findings:

1. Design riding packages by keeping recreational activities, weekend contests, and summer events in mind and offer special discounts and coupons on such events to encourage casual riders get annual membership.

2. Design seasonal packages, It allows flexibility and encourages casual riders to get membership for specific periods if they are not willing to pay for annual subscription.

3. Effective and efficient promotions by targeting casual riders at the busiest times and stations:

     * Days: Weekends
     * Months: February, June, and July
     * Stations: Streeter Dr & Grand Ave, Lake 
     * Shore Dr & Monroe St, Millennium Park


