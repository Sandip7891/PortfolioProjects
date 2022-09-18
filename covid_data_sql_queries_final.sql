select location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
order by location, date;

-- Country Wise Total Cases vs Total Deaths percentage

select location, date, total_cases, total_deaths, round(total_deaths*100/total_cases,2) death_percentage
FROM coviddeaths 
where location = 'India'
order by location, date;

-- Region wise highest mortality rate

select location, max(total_deaths) highest_deaths, population, round(max(total_deaths*100/population),2) peak_mortality_rate
FROM coviddeaths 
where continent is null and location not like '%income'
group by location, population
order by peak_mortality_rate desc;

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
