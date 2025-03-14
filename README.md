# COVID-19 Data Analysis Project

## Overview

This project provides a comprehensive analysis of COVID-19 data using SQL. The data, sourced from [Our World in Data](https://ourworldindata.org/covid-deaths), includes global COVID-19 statistics on infections, deaths, and vaccinations from March 2020 to July 2024. The analysis aims to uncover key insights and trends about the pandemic.

## Data Source

The dataset was divided into two main parts for easy analysis:
- **CovidDeaths**: Contains data on global COVID-19 cases and total deaths.
- **CovidVaccinations**: Contains data on COVID-19 vaccinations.

The dataset includes various metrics such as the number of infected persons, total deaths, vaccinations,location, date,continents and many more.

## Objectives

The primary goal of this project is to perform exploratory data analysis using SQL to answer the following questions:
1. What is the percentage of total cases recorded compared to total deaths recorded?
2. What is the percentage of total cases recorded vs total population by countries?
3. Which country has the highest infection rate?
4. Which countries recorded the highest number of death cases per population?
5. What is the global death rate percentage for COVID-19?
6. What is the total population vaccinated per country?
7. What is the mortality rate?
8. Which age group has the highest infection rate?

##Project Objective

This project aims to analyze COVID-19 data to identify trends, patterns, and key insights that can support data-driven decision-making. By leveraging statistical and visualization techniques, the analysis will provide insights into infection rates, recovery trends, mortality rates, and the impact of various factors such as location, demographics, and healthcare interventions. The goal is to transform raw data into actionable information, enabling stakeholders to make informed decisions for public health strategies, resource allocation, and policy-making.

## SQL Analysis

SQL was utilized to extract, transform, and analyze the data. Key analyses performed include:

- **Data Extraction**: Pulling relevant columns and rows for analysis.
- **Data Transformation**: Cleaning and preparing data for analysis.
- **Trend Analysis**: Examining trends in cases, deaths, and vaccinations over time.
- **Comparative Analysis**: Comparing data between different countries and continents.
- **Visualization Preparation**: Creating views to facilitate data visualization.

## Key Insights

### Global Insights
- **Total Cases**: 775,741,465 cases recorded globally.
- **Total Deaths**: 7,057,367 deaths recorded globally.
- **Global Death Rate**: Approximately 1%.

### Country-Specific Insights
- **United States**: Highest death rate per population with 103,436,829 infected persons and 1,190,579 deaths.
- **Top 5 Countries with Highest Infection Rates**: United States, Brazil, India, Russia, and Mexico.
- **Top Continents with Highest Death Cases**: 
  - North America: 1,190,579 deaths
  - South America
  - Asia
  - Oceania recorded the least number of deaths with 25,236.

### Vaccination Insights
- Data on total population vaccinated per country was analyzed.

## Data Visualization

SQL views were created to assist in data visualization. These views can be imported into visualization tools such as Tableau or Power BI to generate interactive dashboards.


## Conclusion

This project demonstrates the use of SQL for analyzing a large COVID-19 dataset. The insights obtained provide valuable information on the trends and impacts of the pandemic from March 2020 to July 2024. The created views enable further exploration and effective visualization of the data.

