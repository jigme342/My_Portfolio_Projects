--Exploring the table 

SELECT * 
FROM PortfolioProject..[CovidDeaths.xls];

--Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..[CovidDeaths.xls]
ORDER BY 1

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid

SELECT location, date, total_cases,total_deaths,
       CASE 
	       WHEN total_cases = 0 THEN NULL
		   ELSE (CONVERT(float,total_deaths)/total_cases)*100 
	   END AS DeathPercentage
FROM PortfolioProject..[CovidDeaths.xls]
WHERE location like '%India%'
ORDER BY 1;

--Looking at Total Cases vs Population

SELECT location, date, total_cases, population,
       CASE 
	       WHEN total_cases = 0 THEN NULL
		   ELSE (CONVERT(float,total_cases)/population)*100
	   END AS DeathPercentage
FROM PortfolioProject..[CovidDeaths.xls]
--WHERE location like '%India%'
ORDER BY 1;

--Looking at Countries with highest infection rate Compared to Population

SELECT location,population, MAX(total_cases) AS HighestInfectionCount,
       CASE 
	       WHEN MAX(total_cases) = 0 THEN NULL
	       ELSE (MAX(CONVERT(float,total_cases)/population))*100
	   END AS PercentPopulationInfected
FROM PortfolioProject..[CovidDeaths.xls]
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;




--Looking at Countries with Highest Death Count per Population
 
SELECT location,MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..[CovidDeaths.xls]
WHERE continent<> ' '
GROUP BY location
ORDER BY TotalDeathCount DESC;


--Lets now break things down by Continent

--Showing Continents with Highest Death Count per population

SELECT continent,MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..[CovidDeaths.xls]
WHERE continent<> ' '
GROUP BY continent
ORDER BY TotalDeathCount DESC;


--Global Numbers

SELECT SUM(CAST(new_cases as int)) AS total_cases, 
	   SUM(CAST(new_deaths as int)) AS total_deathS
	    
FROM PortfolioProject..[CovidDeaths.xls]
WHERE continent <> ' ' ;


--Looking at Total Population vs Vaccinations

--USE CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location
	   ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated

FROM PortfolioProject..[CovidDeaths.xls] dea
JOIN PortfolioProject..[CovidVaccinations.xls] vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent <> ' '
)
SELECT *, (RollingPeopleVaccinated/population)*100 AS PercentPeopleVaccinated
FROM PopvsVac


--TEMP TABLE FOR ANY ALTERATIONS 

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location
	   ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated

FROM PortfolioProject..[CovidDeaths.xls] dea
JOIN PortfolioProject..[CovidVaccinations.xls] vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent <> ' '


SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


--Creating View to store data for later Visualizations

CREATE VIEW TotalDeathCount AS 
SELECT location,MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..[CovidDeaths.xls]
WHERE continent<> ' '
GROUP BY location;

SELECT * 
FROM TotalDeathCount










