
# 🧮 COVID-19 Data Exploratory Analysis (SQL Project)

## 🧠 Overview

This project presents an **end-to-end Exploratory Data Analysis (EDA)** of the global COVID-19 pandemic using **Structured Query Language (SQL)**. The analysis investigates patterns in cases, deaths, and vaccinations between **2020 – 2024**, revealing how the pandemic evolved across countries and continents.

The dataset was sourced from **[Our World in Data](https://ourworldindata.org/covid-deaths)** and contains over **414 k rows** of daily COVID-19 records.
All SQL code, analysis steps, and results are contained in the file:

🔗 **[CovidExploratoryAnalysis.sql](./CovidExploratoryAnalysis.sql)**

---

## 🧩 Project Description

The goal of this project is to showcase how SQL alone can be used to perform **real-world data cleaning, transformation, analysis, and insight generation** without external analytics tools.

This project demonstrates the practical application of:

* Common Table Expressions (CTEs)
* Window Functions (`SUM() OVER (PARTITION BY …)`)
* Joins and Aggregations
* Temporary Tables
* Data-type conversions (`CAST`, `CONVERT`)
* Creating reusable SQL Views

The analysis provides insights such as:

* Global and country-level infection rates and death percentages
* Comparison of death burden across continents
* Vaccination trends and population coverage over time
* Global mortality rates and cumulative vaccination progress

---

## 🌍 Project Context

The **COVID-19 pandemic** transformed global health and economic landscapes. Accurate data analytics became essential for understanding transmission trends, mortality rates, and the effect of vaccination programs.

This project leverages SQL to transform the raw dataset into an **insight-rich analytical summary**, forming the foundation for visualization dashboards or further predictive modeling.

---

## ❗ Problem Statement

The pandemic led to unprecedented data generation worldwide. However, challenges such as inconsistent reporting, missing values, and fragmented data structures made it difficult to quickly extract reliable insights.

The core problems this project addresses include:

1.	Identifying and quantifying the impact of COVID-19 on populations through case and death trends.
2.	Tracking vaccination progress and understanding its effect on infection and death rates.
3.	Comparing trends across countries and continents to uncover disparities and regional differences.
4.	Designing efficient SQL-based processes for transforming raw data into structured, insightful, and reusable datasets.
---

## 🎯 Aim of the Project

The project aims to perform a **comprehensive SQL-based exploratory analysis** of global COVID-19 data to uncover trends, compute key metrics, and identify actionable insights.

### Specific Objectives

* Calculate global and regional **infection and death trends (2020–2024)**.
* Evaluate **case fatality rates (CFR)** across countries and continents.
* Determine **the percentage of each country’s population infected**.
* Track **vaccination progress** using rolling cumulative totals.
* Create **views and reusable SQL components** for integration with BI dashboards.
* Identify **top countries and continents** by total deaths and infection rates.

---

## ⚙️ My Approach

### 1. Data Exploration (EDA)

The project used two main tables:

* **CovidDeaths**
  Columns: `iso_code`, `continent`, `location`, `date`, `population`, `total_cases`, `new_cases`, `total_deaths`, `new_deaths`
* **CovidVaccinations**
  Columns: `iso_code`, `continent`, `location`, `date`, `total_tests`, `new_tests`, `new_vaccinations`, `population_density`, `death_rate`

#### Sample inspection query

```sql
SELECT TOP 10 *
FROM CovidData..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;
```

### 2. Data Cleaning & Preparation

* Converted data types for numeric calculations:

  ```sql
  CONVERT(int, total_deaths)
  ```
* Filtered out `NULL` continents to exclude aggregates like “World” or “European Union”.
* Joined tables on `location` and `date` for synchronized case and vaccination analysis.

### 3. Analytical Process

Key analytical queries included:

#### a. Death Percentage (Case Fatality Rate)

```sql
SELECT location, date, total_cases, total_deaths,
       (total_deaths / total_cases) * 100 AS DeathPercentage
FROM CovidData..CovidDeaths
WHERE continent IS NOT NULL;
```

#### b. Infection Rate by Population

```sql
SELECT location, population,
       MAX((total_cases / population) * 100) AS PercentPopulationInfected
FROM CovidData..CovidDeaths
GROUP BY location, population;
```

#### c. Global Summary Metrics

```sql
SELECT SUM(new_cases) AS TotalCases,
       SUM(CAST(new_deaths AS int)) AS TotalDeaths,
       SUM(CAST(new_deaths AS int)) / SUM(new_cases) * 100 AS GlobalDeathPercentage
FROM CovidData..CovidDeaths
WHERE continent IS NOT NULL;
```

#### d. Rolling Vaccination Totals

```sql
SELECT dea.location, dea.date, dea.population,
       SUM(CONVERT(bigint, vac.new_vaccinations))
         OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM CovidData..CovidDeaths dea
JOIN CovidData..CovidVaccinations vac
     ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
```

#### e. View Creation for Visualization

```sql
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population,
       SUM(CONVERT(bigint, vac.new_vaccinations))
         OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM CovidData..CovidDeaths dea
JOIN CovidData..CovidVaccinations vac
     ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
```

---

## 🧰 Skills and Tools Used

* **SQL (T-SQL / Microsoft SQL Server)**
* **Data Cleaning & Transformation**
* **Analytical Query Design**
* **Window Functions & Aggregations**
* **Common Table Expressions (CTEs)**
* **Joins, Subqueries, Views, Temp Tables**
* **Data Documentation & Interpretation**

---

## 📊 Key Performance Indicators (KPIs)

### Country-Level Death Counts

| Location       | Total Death Count |
| -------------- | ----------------: |
| United States  |         1,190,579 |
| Brazil         |           702,116 |
| India          |           533,622 |
| Russia         |           403,108 |
| Mexico         |           334,501 |
| United Kingdom |           232,112 |

### Continent-Level Summary

| Continent     | Total Death Count |
| ------------- | ----------------: |
| North America |         1,190,579 |
| South America |           702,116 |
| Asia          |           533,622 |
| Europe        |           403,108 |
| Africa        |           102,595 |
| Oceania       |            25,236 |

### Global Summary

| Metric                  |       Value |
| ----------------------- | ----------: |
| Total Cases             | 775,741,465 |
| Global Death Percentage |      0.91 % |
| Total Deaths            |   7,057,367 |

---

## 🔍 Key Insights

* The **United States** reported the highest number of total deaths globally, followed by **Brazil** and **India**.
* **Asia** and **Europe** exhibited comparable total death counts, emphasizing widespread regional impact.
* The **global case-fatality rate (CFR)** stood at roughly **0.9 %**, though country-level variation was significant.
* Rolling vaccination data show **steady cumulative growth**, with advanced economies reaching high coverage early.
* Some regions demonstrate **vaccination plateaus**, suggesting logistic or policy-related barriers.

---

## ✨ Key Features

* End-to-end analysis written entirely in **SQL** — no external tools required.
* Modular code structure: each section (deaths, infections, vaccinations) analyzed separately.
* Use of **window functions** for cumulative trends and **CTEs** for readability.
* Includes **reusable view** (`PercentPopulationVaccinated`) for BI integration.
* Fully documented and reproducible analytical process.

---

## 💡 Recommendations

* Strengthen **global data standardization** to minimize inconsistencies in reported metrics.
* Leverage **automated ETL pipelines** to refresh dashboards in real-time using the created SQL view.
* Visualize the output using BI tools such as Power BI or Tableau to enhance stakeholder interpretation.
* Extend analysis by incorporating:

  * **Rolling 7-day averages** to smooth daily reporting irregularities.
  * **Population-density and testing metrics** for deeper epidemiological insights.
  * **Forecasting models** (e.g., ARIMA / Prophet) to predict future case and vaccination trends.

---

## 🏁 Final Note

This SQL-based COVID-19 analysis highlights how **structured data querying** can reveal global health insights without relying on external analytical platforms.
The project blends **technical SQL expertise** with **data storytelling**, forming a strong example of how a data analyst can turn raw public data into meaningful, policy-relevant intelligence.

It demonstrates an ability to manage real-world datasets, engineer analytical pipelines, and communicate insights clearly — essential competencies for professional data analysts.

---

## 📬 Contact

👤 **[Aduga Emmanuel]**
📧 Email: [adugasamuel@gmail.com](adugasamuel@gmail.com)
🌐 Portfolio: 
💻 [GitHub](https://github.com/adugasamuel)]
