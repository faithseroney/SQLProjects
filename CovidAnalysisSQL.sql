/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

I am from Africa, specifically from Kenya. When Covid hit, Africa was expected to have the most deaths due to our 
presumed inferior healthcare. I will analyse this data to get the impact of Covid in Africa and later in Kenya.

Lets see what we will find.
*/

select *
from [portfolio project].[covid].[deaths]
where continent is not null
order by 3, 4

--Let's select the data that we will start with i.e the columns that are most important for this query
select location, date, total_cases, new_cases, population, total_deaths
from [portfolio project].[covid].[deaths]
where continent is not null
order by 3, 4

--What is the likelihood of dying if you contracted covid in your country?
--We look at total death per total cases
select location,date, total_cases, total_deaths, (total_deaths/total_cases) *100  as DeathPercentage
from [portfolio project].[covid].[deaths]
where continent is not null
and continent = 'Africa'
order by 1,2

--So what percentage of the population of each country was infected per day?
--Total cases vs  the population
select location,date, total_cases, population, (total_cases/population) *100  as PopulationInfected
from [portfolio project].[covid].[deaths]
where continent is not null
and continent = 'Africa'
order by 1,2

--Which were the countries with the highest infection rates compared to the population?
select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
from [portfolio project].[covid].[deaths]
where continent is not null
and continent = 'Africa'
Group by location, population
order by PercentPopulationInfected desc
--We see that Africa did not have high infection rates compared to other continents

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [portfolio project].[covid].[deaths]
--Where location like '%states%'
Where continent = 'Africa'
Group by Location
order by TotalDeathCount desc

--which continent had the highest death count?
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [portfolio project].[covid].[deaths]
--Where location like '%states%'
Where continent is null
Group by location
order by TotalDeathCount desc


--Global numbers
--Looking at the view point for when we will visualize

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(New_cases)*100 as DeathPercentage
from [portfolio project].[covid].[deaths]
where continent is not null
--and continent = 'Africa'
order by 1,2
---If you contacted covid, across the world, you have a 2% possibility of dying



--VACCINATIONS
--Looking at total vaccinations over the population
--percentage of the population that has received the vaccine


select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(dea.new_cases as int)) OVER (partition by dea.location order by dea.location, dea.date) as PeopleVaccinatedOrdered
from [portfolio project].[covid].[deaths] as dea
	join [portfolio project].[dbo].[CovidVaccinations$] as vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 1, 2

--To find the percentage of vaccinated vs population, we need to create a CTE

With PopVsVac (Continent, location, date, population, new_vaccinations, PeopleVaccinatedOrdered)
as
(
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(dea.new_cases as int)) OVER (partition by dea.location order by dea.location, dea.date) as PeopleVaccinatedOrdered
from [portfolio project].[covid].[deaths] as dea
	join [portfolio project].[dbo].[CovidVaccinations$] as vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 1, 2
)

select * , (PeopleVaccinatedOrdered/population) *100 as percentagevacc
from PopVsVac




---create a temp table for the query above
drop table if exists #PercentPeopleVaccinated
create table #PercentPeopleVaccinated
	(
	location nvarchar(255), 
	Continent nvarchar(255),
	date DateTime,
	Population numeric,
	New_vaccinations numeric,
	PeopleVaccinatedOrdered numeric
	)


insert into #PercentPeopleVaccinated
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(dea.new_cases as int)) OVER (partition by dea.location order by dea.location, dea.date) as PeopleVaccinatedOrdered
from [portfolio project].[covid].[deaths] as dea
	join [portfolio project].[dbo].[CovidVaccinations$] as vac
	on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null
--order by 1, 2

select * ,
(PeopleVaccinatedOrdered/population) *100 as percentagevacc
from #PercentPeopleVaccinated
--where Continent =  'Africa'
--and location = 'Kenya'
order by percentagevacc desc




--CREATING A VIEW to store data for visualizations
Create View PercentPopulationVaccinated as
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(dea.new_cases as int)) OVER (partition by dea.location order by dea.location, dea.date) as PeopleVaccinatedOrdered
from [portfolio project].[covid].[deaths] as dea
	join [portfolio project].[dbo].[CovidVaccinations$] as vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null







