
/*
Covid 19 Data Exploratory Analysis

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select *
From CovidData..CovidDeaths
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidData..CovidDeaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidData..CovidDeaths
Where location like '%igeria%'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population is infected with Covid


-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidData..CovidDeaths
--Where location like '%igerias%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidData..CovidDeaths
Where continent is not null 
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(CONVERT(INT,(Total_deaths))) as TotalDeathCount
From CovidData..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(CONVERT(INT,Total_deaths)) as TotalDeathCount
From CovidData..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(CONVERT(INT,new_deaths))/SUM(New_Cases)*100 as DeathPercentage
From CovidData..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Joining our two tables together

Select *
From CovidData..CovidDeaths dea
Join CovidData..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidData..CovidDeaths dea
Join CovidData..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 1,2


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--,
From CovidData..CovidDeaths dea
Join CovidData..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Using CTE to perform Calculation on Partition By in previous query(2)
--MAX of Total vacination  vs Max rolling Average by continents and countries

WITH MaxPopvsVac (continent, location, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
    SELECT 
        dea.continent, 
        dea.location, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (
            PARTITION BY dea.location 
            ORDER BY dea.location, dea.date
        ) AS RollingPeopleVaccinated
    FROM CovidData..CovidDeaths dea
    JOIN CovidData..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL 
)
SELECT 
    continent,
    location,
    MAX((RollingPeopleVaccinated / population) * 100) AS MaxVaccinatedPercent
FROM MaxPopvsVac
GROUP BY continent, location
ORDER BY 1,2;


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidData..CovidDeaths dea
Join CovidData..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as PercentageVaccination
From #PercentPopulationVaccinated

-- Using TEMP Table to perform Calculation on Partition By in previous query (2)
-- Using Temp Table to calculate Max Vaccination Percentage and Date per Country

DROP TABLE IF EXISTS #MaxPercentPopulationVaccinated;
CREATE TABLE #MaxPercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

-- Insert data into temp table with rolling total
INSERT INTO #MaxPercentPopulationVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (
        PARTITION BY dea.location 
        ORDER BY dea.location, dea.date
    ) AS RollingPeopleVaccinated
FROM CovidData..CovidDeaths dea
JOIN CovidData..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
--ORDER BY 2,3;

----------------------------------------------------------
-- Step 2: Find the Max Vaccination % for Each Country
----------------------------------------------------------

DROP TABLE IF EXISTS #MaxVaccination;
CREATE TABLE #MaxVaccination
(
    Location NVARCHAR(255),
    MaxVaccinatedPercent FLOAT
);

INSERT INTO #MaxVaccination
SELECT 
    Location,
    MAX((RollingPeopleVaccinated / Population) * 100) AS MaxVaccinatedPercent
FROM #MaxPercentPopulationVaccinated
GROUP BY Location;

----------------------------------------------------------
-- Step 3: Join both tables to get the Date of Max Vaccination
----------------------------------------------------------

SELECT 
    p.Continent,
    p.Location,
    p.Date AS DateReachedMax,
    p.RollingPeopleVaccinated,
    (p.RollingPeopleVaccinated / p.Population) * 100 AS VaccinatedPercent
FROM #MaxPercentPopulationVaccinated p
JOIN #MaxVaccination m
    ON p.Location = m.Location
    AND (p.RollingPeopleVaccinated / p.Population) * 100 = m.MaxVaccinatedPercent
ORDER BY p.Continent, p.Location;



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidData..CovidDeaths dea
Join CovidData..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
