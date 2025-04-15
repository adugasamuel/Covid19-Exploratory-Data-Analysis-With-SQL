SELECT *
FROM covid19Project..CovidDeaths
order by 3,4

--SELECT *
--FROM covid19Project..CovidDeaths
--order by 3,4
-- SELECTING THE DATA TO USE
SELECT Location, date, total_cases, new_deaths, total_deaths, population
FROM covid19Project..CovidDeaths
Where continent is not null
order by 1,2


--Looking at total cases vs total deaths
-- this shows the likelihood of dieing if you contract covid in your country
SELECT Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM covid19Project..CovidDeaths
--Where location like'%South africa%' -- selecting the state u want to view
order by 1,2 desc


SELECT Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentaage
FROM covid19Project ..CovidDeaths
Where location like'%South africa%' -- selecting the state u want to view
order by 1,2



-- Now, lets look at total cases vs population
--Shows what percentage of the population got covid
SELECT Location, date, population ,total_cases, (total_cases/population)*100 As ContractedPercentage
FROM covid19Project ..CovidDeaths
Where location like'%STATES%' -- selecting the state u want to view
order by 1,2 


--Countries with the highest infection rate compared to population
SELECT Location,population ,Max (total_cases) as TotalContracted, MAX((total_cases/population)*100) As ContractedPercentagePop
FROM covid19Project..CovidDeaths
Where continent is not null
--Where location like'%STATES%' -- selecting the state u want to view
group by Location, population 
order by ContractedPercentagePop desc




--Showing countries with highest deathcount per population

SELECT Location, Max (total_cases) as TotalContracted,MAX (CAST (total_deaths AS INT )) as TotalDeathCount
From covid19Project..CovidDeaths
Where continent is not null
Group by location
order by totalDeathCount desc




--Showing Continents with highest deathcount per population

SELECT continent, MAX(CAST (total_deaths AS INT)) as TotalDeathCount
From covid19Project..CovidDeaths
Where continent is not null
Group by continent
order by totalDeathCount desc





--GLOBAL NUMBERS
-- AS From March 2020 to July 2024 The death percentage drastically reduced to 1% Globally.

SELECT SUM(new_cases) as total_cases, SUM (CAST (new_deaths as int)) as totaldeaths, 
 SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM covid19Project..CovidDeaths
--Where location like'%South africa%' -- selecting the state u want to view
Where continent is not null
order by 1,2




--Looking at total population vs Vaccination
SELECT cod.continent, cod.location,cod.date,cod.population,cov.new_vaccinations,
SUM(CONVERT(bigint,cov.new_vaccinations)) OVER (partition by cod.Location order by cod.location, cod.date) as RollingPeopleVaccinated
FROM covid19Project..CovidDeaths as cod
JOIN covid19Project..CovidVaccinations as cov
ON cod.location = cov.location and
cod.date = cov.date
where cod.continent is not null
order by 1,2,3

-- CREATING AND USING CTE
WITH PopulationVsVaccinate (continent, location, date,population,new_vaccination,RollingPeopleVaccinated)
As
(SELECT cod.continent, cod.location,cod.date,cod.population,cov.new_vaccinations,
SUM(CONVERT(bigint,cov.new_vaccinations)) OVER (partition by cod.Location order by cod.location, cod.date) as RollingPeopleVaccinated
FROM covid19Project..CovidDeaths as cod
JOIN covid19Project..CovidVaccinations as cov
ON cod.location = cov.location and
cod.date = cov.date
--Order by 1,2,3
where cod.continent is not null)
SELECT *, (RollingPeopleVaccinated/Population )*100 as PercentageVaccinationPerPopulation
FROM PopulationVsVaccinate

--TEMP TABLE
Drop table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT cod.continent, cod.location,cod.date,cod.population,cov.new_vaccinations,
SUM(CONVERT(bigint,cov.new_vaccinations)) OVER (partition by cod.Location order by cod.location, cod.date) as RollingPeopleVaccinated
FROM covid19Project..CovidDeaths as cod
JOIN covid19Project..CovidVaccinations as cov
ON cod.location = cov.location and
cod.date = cov.date
where cod.continent is not null
--Order by 1,2,3

SELECT *,(RollingPeopleVaccinated/population)*100
 FROM #PercentPopulationVaccinated

 --Create view to store for data visualization

 CREATE VIEW PercentPopulationVaccinated AS
SELECT cod.continent, cod.location,cod.date,cod.population,cov.new_vaccinations,
SUM(CONVERT(bigint,cov.new_vaccinations)) OVER (partition by cod.Location order by cod.location, cod.date) as RollingPeopleVaccinated
FROM covid19Project..CovidDeaths as cod
JOIN covid19Project..CovidVaccinations as cov
ON cod.location = cov.location and
cod.date = cov.date
where cod.continent is not null
--Order by 1,2,3 


Select *
From PercentPopulationVaccinated 


--View for Countries with the highest infection rate compared to population to be used for visuaization.
SELECT Location,population ,Max (total_cases) as TotalContracted, MAX((total_cases/population)*100) As ContractedPercentagePop
FROM covid19Project..CovidDeaths
Where continent is not null
--Where location like'%STATES%' -- selecting the state u want to view
group by Location, population 
order by ContractedPercentagePop desc