/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


SELECT *
FROM PortfolioProject..CovidDeaths
where continent is NOT NULL
order by 3,4

--------------------------------------------------------------------------------------------------------------------------------------
-- Select data that we are going to be starting with 

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is NOT NULL
order by 1,2


--------------------------------------------------------------------------------------------------------------------------------------
-- Looking at Total Deaths vs Total Cases
-- Shows the likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like 'India' and continent is NOT NULL
order by 1,2

    
--------------------------------------------------------------------------------------------------------------------------------------
-- Looking at Total Cases vs Population
-- Shows what percentage of the population got covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where location like 'India' and continent is NOT NULL
order by 1,2


--------------------------------------------------------------------------------------------------------------------------------------
-- Looking at countries with highest Infection Rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- where location like 'india'
where continent is NOT NULL
GROUP BY location, population
order by 4 desc


--------------------------------------------------------------------------------------------------------------------------------------    
-- Showing countries with Highest Death Count per Population

Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- where location like 'india'
where continent is NOT NULL
GROUP BY location
order by 2 desc



--------------------------------------------------------------------------------------------------------------------------------------
-- LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing continents with highest death count per population

Select continent, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- where location like 'india'
where continent is NOT NULL
GROUP BY continent
order by 2 desc


    
--------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL NUMBERS


-- OVERALL PERCENTAGE
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,
CASE 
    WHEN SUM(new_cases) = 0 THEN 0 -- Prevent division by zero
    ELSE 
        CASE 
            WHEN SUM(new_deaths) / SUM(new_cases) * 100 > 100 THEN 100 -- Cap at 100
            ELSE CAST(SUM(new_deaths) / SUM(new_cases) * 100 AS DECIMAL(38, 10)) -- Use original calculation
        END
    END AS DeathPercentage
From PortfolioProject..CovidDeaths
-- where location like 'India' 
where continent is NOT NULL and new_cases is NOT NULL
-- GROUP BY date
order by 1,2

    
--------------------------------------------------------------------------------------------------------------------------------------
-- PERCENTAGE BY DATE
Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
CASE 
    WHEN SUM(new_cases) = 0 THEN 0 -- Prevent division by zero
    ELSE 
        CASE 
            WHEN SUM(new_deaths) / SUM(new_cases) * 100 > 100 THEN 100 -- Cap at 100
            ELSE CAST(SUM(new_deaths) / SUM(new_cases) * 100 AS DECIMAL(38, 10)) -- Use original calculation
        END
    END AS DeathPercentage
From PortfolioProject..CovidDeaths
-- where location like 'India' 
where continent is NOT NULL and new_cases is NOT NULL
GROUP BY date
order by 1,2


    
--------------------------------------------------------------------------------------------------------------------------------------
-- Looking at Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) * 100 This won't work
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
where dea.continent is NOT NULL and vac.new_vaccinations is NOT NULL
order by 2,3


    
--------------------------------------------------------------------------------------------------------------------------------------
-- Using CTE to perform Calculation on Partition By in previous query

With PopVSVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
where dea.continent is NOT NULL and vac.new_vaccinations is NOT NULL
--order by 2,3
)
SELECT *, CAST(RollingPeopleVaccinated * 1.0 /population as DECIMAL(18,10)) * 100
FROM PopVSVac



    
--------------------------------------------------------------------------------------------------------------------------------------
-- Using Temp Table to perform Calculation on Partition By in previous query
DROP TABLE if EXISTS #PercentagePeopleVaccinated
CREATE TABLE #PercentagePeopleVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
)

INSERT into #PercentagePeopleVaccinated
SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) * 100 This won't work
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
where dea.continent is NOT NULL and vac.new_vaccinations is NOT NULL
order by 2,3

SELECT *, CAST(RollingPeopleVaccinated * 1.0 /population as DECIMAL(18,10)) * 100
FROM #PercentagePeopleVaccinated



    
--------------------------------------------------------------------------------------------------------------------------------------
-- Creating View to store data for later visualizations

CREATE VIEW PercentagePeopleVaccinated as
SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population) * 100 This won't work
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
where dea.continent is NOT NULL and new_vaccinations is NOT NULL
-- order by 2,3

SELECT *
FROM PercentagePeopleVaccinated
ORDER BY 2,3
