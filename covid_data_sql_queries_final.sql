select sum(new_cases) total_affected, sum(new_deaths) total_death, round((sum(new_deaths)*100/sum(new_cases)),2) death_percent
FROM coviddeaths
where continent <> '' and location not like '%income';

-- Country Wise Total Cases vs Total Deaths percentage

select location, date, total_cases, total_deaths, round(total_deaths*100/total_cases,2) death_percentage
FROM coviddeaths 
where continent <> '' and location not like '%income'
order by location, date;

-- Region wise highest mortality rate

select location, max(total_deaths) highest_deaths, population, round(max(total_deaths*100/population),2) peak_mortality_rate
FROM coviddeaths 
where continent = '' and location not like '%income'
group by location, population
order by peak_mortality_rate desc;

-- Country wise highest infection percent & highest death percent

SELECT location, population, max(total_cases) highest_infect,
max(total_deaths) highest_death, round(max(total_cases)*100/population,2) peak_infect_percent,
round(max(total_deaths)*100/population,2) peak_death_percent
from coviddeaths
where continent <> '' and location not like '%income'
group by location, population
order by peak_death_percent desc;

-- Country wise vaccinations over time

create view vaccinations_over_time as
  (with t1 as 
    (select d.location, d.date, d.population, v.new_vaccinations,
    sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) tot_vac
    FROM coviddeaths d
    join covidvaccinations v
    on d.location = v.location
    and d.date = v.date)
  select *, round(tot_vac*100/population,1) vaccine_percent from t1
  order by location, date);
