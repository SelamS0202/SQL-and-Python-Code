-- Exploring the data
select *
from PortfolioPro..Covidvaccinations
order by 3,4;
select *
from PortfolioPro..CovidDeaths
where continent is not null
order by 3,4
-- Select Data for Analysis
Select Location, date,total_cases,new_cases,total_deaths, population
From PortfolioPro..CovidDeaths
where continent is not null
Order by 1,2
--Total cases vs Total deathes
--- Liklihood of daying with covid in Italy  from  Feb 2020 to Feb 2023
Select Location, date,total_cases,cast(total_deaths as int) as total_deaths,(cast(total_deaths as int)/total_cases)  * 100 as Death_Percentage
From PortfolioPro..CovidDeaths
WHERE location = 'Italy' and cast(total_deaths as int) is not null
Order by 2
--- Total cases vs population
-- Shows what percentage of population got Covid in Italy from 2020 Feb to 2023 Feb
Select Location, date,total_cases,population,(total_cases/population)  * 100 as Infection_Percentage
From PortfolioPro..CovidDeaths
WHERE location = 'Italy'
Order by 2
--- Countries with highest infection rate compared to population
Select Location,Population, MAX (total_cases) as HighestInfection,MAX(total_cases/population)  * 100 as Percent_PopulationInfected
From PortfolioPro..CovidDeaths
where continent is not null
Group by location, population
Order by 4 desc 
--- Exploration by Continent 
Select Continent, MAX(cast(total_deaths as int)) as MaxTotal_death
From PortfolioPro..CovidDeaths
where continent is not null
Group by continent
Order by MaxTotal_death desc
-- Countries with highest death per population
Select Location, MAX(cast(total_deaths as int)) as MaxTotal_death
From PortfolioPro..CovidDeaths
where continent is not null
Group by location
Order by MaxTotal_death desc

-- Global numbers convert(date, GETDATE(),113) 
Select t1.date, SUM(t1.new_cases)
From
(Select convert(date, GETDATE(),113) as date,new_cases 
From PortfolioPro..CovidDeaths
WHERE continent is not null and cast(new_cases as int) is not null) t1
group by t1.date
Order by 1,2
--- Global % of death 
Select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, round (sum(cast(new_deaths as int))/sum(new_cases)*100,2) as DeathPercentage
From PortfolioPro..CovidDeaths
WHERE continent is not null and cast(new_cases as int) is not null and cast(new_deaths as int) is not null
Order by 1,2
--- Vaccination Data exploration
Select *
FROM PortfolioPro..Covidvaccinations;

-- Using CET(Common Expression Table)
WITH PopvsVacc(Continent, Location, Date, Population,new_vaccinations,RollingVaccinatedPeople)
as (
--- Join Vaccination Data with Death Data to look at total population vs vaccinations
Select D.continent, D.location,cast(SUBSTRING(convert(varchar(25),D.date,120),1,10) as date) as date, D.population,V.new_vaccinations,
SUM (convert(bigint,V.new_vaccinations)) over (Partition by D.Location order by D.date) as RollingVaccinatedPeople
FROM PortfolioPro..CovidDeaths D
Inner Join PortfolioPro..Covidvaccinations V
on D.location = V.location 
and D.date = V.date
WHERE D.continent is not null 
--Order by D.location,D.date
)
select *, (RollingVaccinatedPeople/Population)*100 as PercentagePeopleVaccinated
from PopvsVacc
order by location,date
--- Create Temp table
Drop Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
NewVaccinations numeric,
RollingPeopleVaccinated numeric);
insert into PercentPopulationVaccinated
Select D.continent, D.location,cast(SUBSTRING(convert(varchar(25),D.date,120),1,10) as date) as date, D.population,V.new_vaccinations,
SUM (convert(bigint,V.new_vaccinations)) over (Partition by D.Location order by D.date) as RollingVaccinatedPeople
FROM PortfolioPro..CovidDeaths D
Inner Join PortfolioPro..Covidvaccinations V
on D.location = V.location 
and D.date = V.date
WHERE D.continent is not null
Order by D.location,D.date
select *, (RollingPeopleVaccinated/Population)*100 as PercentagePeopleVaccinated
from PercentPopulationVaccinated
order by location,date;

--Create view to store data for later visualization
-- Rolling Vaccinated People by location 
GO
Create View PercentPopulationVaccinated_View as
Select D.continent, D.location,cast(SUBSTRING(convert(varchar(25),D.date,120),1,10) as date) as date, D.population,V.new_vaccinations,
SUM (convert(bigint,V.new_vaccinations)) over (Partition by D.Location order by D.date) as RollingVaccinatedPeople
FROM PortfolioPro..CovidDeaths D
Inner Join PortfolioPro..Covidvaccinations V
on D.location = V.location 
and D.date = V.date
WHERE D.continent is not null;
select * 
FROM PercentPopulationVaccinated_View;
--- Highest number of death by continent 
GO
Create VIEW MaxDeath as 
Select Continent, MAX(cast(total_deaths as int)) as MaxTotal_death
From PortfolioPro..CovidDeaths
where continent is not null
Group by continent;
Select *
From MaxDeath
Order by MaxTotal_death desc

