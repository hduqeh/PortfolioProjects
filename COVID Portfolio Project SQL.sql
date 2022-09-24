SELECT * 
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT * 
--FROM PortfolioProject.dbo.CovidVaccinations
--ORDER BY 3,4

-- Select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER by 1, 2 -- basing things off of location

--Looking at Total cases vs total deaths (whats the % of people who died have covid)
--we want to know the % of people dying who got infected

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPerc --if you want the % of something divide then multiple by 100
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%Canada%'
AND continent is not null
ORDER by 1,2-- basing things off of location

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
-- we are visualizing into the future
SELECT Location, date, Population, total_cases, (total_cases/Population)*100 AS PercPopInfected 
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Canada'
ORDER by 1,2

-- What countries have the highest infection rates compared to the Population
-- Looking at Countries with Highest Infection Rate compared to Population

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/Population))*100 AS PercPopInfected 
FROM PortfolioProject.dbo.CovidDeaths
--Where location = 'Canada'
GROUP BY Location, Population
ORDER BY PercPopInfected DESC

--Look at how many people actuall died
--Showing the Countries with the Highest Death Count per Population

SELECT Location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--Where location = 'Canada'
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC

-- LET'S BREAK THINGS DOWN BY CONTINENT

SELECT location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- calculate everything across the entire world
-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS DeathPerc
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
--GROUP BY date
ORDER by 1,2


--Looking at Total Population vs Vaccinations

SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations, 
SUM(CONVERT(int,vacc.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,
deaths.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject.dbo.CovidDeaths deaths
JOIN PortfolioProject.dbo.CovidVaccinations vacc
	ON deaths.location = vacc.location
	AND deaths.date = vacc.date
WHERE deaths.continent is not null
ORDER BY 2,3

-- USE CTE

WITH PopvsVacc (Continent, Locaton, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations, 
SUM(CONVERT(int,vacc.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,
deaths.date) AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeaths deaths
JOIN PortfolioProject.dbo.CovidVaccinations vacc
	ON deaths.location = vacc.location
	AND deaths.date = vacc.date
WHERE deaths.continent is not null
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS RollingPeopleVaccinated_perc
FROM PopvsVacc

--TEMP TABLE

DROP TABLE if exists PercentPopulationVaccinated
CREATE TABLE PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

INSERT INTO PercentPopulationVaccinated
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations, 
SUM(CONVERT(int,vacc.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,
deaths.date) AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeaths deaths
JOIN PortfolioProject.dbo.CovidVaccinations vacc
	ON deaths.location = vacc.location
	AND deaths.date = vacc.date
--WHERE deaths.continent is not null

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated AS
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations, 
SUM(CONVERT(int,vacc.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location,
deaths.date) AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeaths deaths
JOIN PortfolioProject.dbo.CovidVaccinations vacc
	ON deaths.location = vacc.location
	AND deaths.date = vacc.date
WHERE deaths.continent is not null


SELECT *
FROM PercentPopulationVaccinated

