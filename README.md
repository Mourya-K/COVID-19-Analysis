# COVID-19-Analysis
### Link to Dataset: https://ourworldindata.org/covid-deaths
Have included the csv files of data that I used. It contains data uptil 03/03/2024.<br><br>
Made changes to default data types of certain columns to suit arithmetic operations performed. To avoid confusion, attached screenshots of the final data types of all the columns of both csv files for reference. Make sure you match them on your device before running the sql queries to avoid errors. You can find the screenshots [here](./Final%20Data%20Types%20of%20Columns/)

**Download the csv files and import their data into two different tables with the same names, make sure the data types match like I mentioned above, then run the sql query [file](./COVID%20Analysis%20Project.sql)
, one query at a time, following the comments written.**

## Introduction: 
This project involves exploring Covid-19 data using various SQL techniques such as Joins, CTEs, Temp Tables, Window Functions, Aggregate Functions, and creating Views.

## Overview

The SQL queries in this project analyze Covid-19 data to gain insights into factors such as total cases, total deaths, infection rates, vaccination rates, and more.

## Data Preprocessing

### Initial Dataset
The initial dataset consisted of a single CSV file containing comprehensive Covid-19 data, including information such as location, date, total cases, new cases, total deaths, population, and more. This dataset served as the foundation for our analysis and exploration of the pandemic's impact across different regions.

### Dividing the Dataset
To facilitate my analysis and streamline the processing of the data, I made the decision to divide the original CSV file into two separate parts. This division was motivated by the need for better organization and improved performance during data manipulation and analysis.

### Reasoning

1. **Organizational Purposes**: By splitting the dataset, I was able to better organize the data into distinct categories, making it easier to manage and navigate during the analysis phase.
    
2. **Simplified Analysis**: Dividing the dataset allowed me to focus on specific aspects of the data without being overwhelmed by its entirety. This simplified my analysis process and enabled me to extract meaningful insights more efficiently.

### Division Process

The original CSV file was divided into two separate files based on specific criteria:

1. **CovidDeaths.csv**: This file contains information related to Covid-19 deaths, including location, date, total cases, total deaths, population and related metrics. I extracted this subset of data to focus specifically on mortality rates and related analysis.

2. **CovidVaccinations.csv**: In contrast, this file encompasses data pertaining to Covid-19 vaccinations, such as location, date, total tests, total vaccinations and new vaccinations details. Separating this information allowed me to analyze vaccination trends and assess the progress of vaccination campaigns independently.

### Data Preprocessing Steps

During the division process, I ensured that both datasets maintained data integrity and consistency. This involved thorough validation and verification to prevent any loss or corruption of information. Additionally, I applied necessary transformations and cleaning procedures to prepare the datasets for subsequent analysis wherever necessary.

**End Note**: This is my first ever data analytics project and would definitely appreciate constructive feedback.

