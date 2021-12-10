-- Covid 19 Data Exploration 
-- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views
show databases;
use portfolio;

select * 
from covid_deaths
where continent is not null
order by 4,5;

-- Select date that we are going to be starting with

select location,date,population,total_cases,new_cases,total_deaths
from covid_deaths
where continent is not null
order by 1,2;

-- Total cases vs Total deaths
-- shows likelihood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from covid_deaths
where location like '%India%' and continent is not null
order by 1,2; 

-- Total cases vs. population
-- shows that percentage of population infected with covid

select location,date,population,total_cases,(total_cases/population)*100 as Percentagepopulationinfected
from covid_deaths
where location like '%India%'
order by 1,2;

-- Countries with Highest infection rate compared to population

select location,population,max(total_cases) as Highestinfectioncount,max(total_cases/population)*100 as Percentagepopulationinfected
from covid_deaths
where location like '%India%'
group by location,population
order by Percentagepopulationinfected;

select location,max(total_deaths) as TotalDeathCount
from covid_deaths
where location like '%India%' and continent is not null
group by location
order by TotalDeathCount desc;

-- Breaking things down by continent
-- showing continents with the highest death count per population

select continent,max(total_deaths) as TotalDeathcount
from covid_deaths
where  continent is not null
group  by continent
order by TotalDeathCount desc;

-- GLOBAL numbers

select date,sum(new_cases) as Toatl_cases,sum(new_deaths) as Total_Deaths,sum(new_deaths/new_cases)*100 as DeathPercentage
from covid_deaths
where  continent is not null
group  by date
order by 1,2;

-- Total population vs. vaccinations
-- Shows Percentage of population that has recieved at least one covid vaccine

select * from covid_deaths;
select * from covid_vaccination;

 select d.continent,d.location,d.date,d.population,v.new_vaccinations,sum(v.new_vaccinations)over (partition by d.location order by d.location,d.date) as Rollingpeoplevaccinated
 from covid_deaths d
 join covid_vaccination v
 on d.location=v.location
 and d.date=v.date
 where d.continent is not null
 order by 2,3;
 
 
 -- using CTE to perform calculation on partition by in previous query
 
 WITH PopVsVac AS 
 (select d.continent,d.location,d.date,d.population,v.new_vaccinations,sum(v.new_vaccinations)over (partition by d.location order by d.location,d.date) as Rollingpeoplevaccinated
 from covid_deaths d
 join covid_vaccination v
 on d.location=v.location
 and d.date=v.date
 where d.continent is not null
 order by 2,3)
select (Rollingpeoplevaccinated)*100
from PopVsVac;

create table PopulationVaccinated
(continent nvarchar(200),
location nvarchar(200),
date datetime,
population numeric,
new_vaccination numeric,
PopulationVaccinated numeric);

insert into PopulationVaccinated
(select d.continent,d.location,d.date,d.population,v.new_vaccinations,sum(v.new_vaccinations)over (partition by d.location order by d.location,d.date) as Rollingpeoplevaccinated
 from covid_deaths d
 join covid_vaccination v
 on d.location=v.location
 and d.date=v.date
 where d.continent is not null
 order by 2,3);
select (PopulationVaccinated)*100
from PopulationVaccinated;

-- Creating view to store data for later visualisation

CREATE VIEW PercentPpopulationvaccinated AS
select d.continent,d.location,d.date,d.population,v.new_vaccinations,sum(v.new_vaccinations)over (partition by d.location order by d.location,d.date) as Rollingpeoplevaccinated
from covid_deaths d
join covid_vaccination v
on d.location=v.location
and d.date=v.date
where d.continent is not null
order by 2,3;
 
