use world_layoffs;
-- Data Exploration & Analysis

-- The companies with the most layoffs 
select company,sum(total_laid_off)  as total_layoffs
from layoffs_staging2
group by company
order by 2 desc limit 5;



-- The industries with the most layoffs 
select industry,sum(total_laid_off) as total_layoffs
from layoffs_staging2
group by industry
order by 2 desc limit 5;



-- The countries with the most layoffs 
select country,sum(total_laid_off) as total_layoffs
from layoffs_staging2
group by country
order by 2 desc limit 5;



-- The total number of people who were laid off in each stage
select stage,sum(total_laid_off) as total_layoffs
from layoffs_staging2
group by stage
order by 2 desc;



-- The total number of people who were laid off during each year
select year(`date`) as `year`,sum(total_laid_off) as total_layoffs
from layoffs_staging2
group by 1
having `year` is not null
order by 1 desc ;



-- The month with the most layoffs in four years
select month(`date`) as `month` ,sum(total_laid_off) as total_layoffs
from layoffs_staging2
group by 1 
having `month` is not null
order by 2 desc limit 1;



-- rolling total layoffs based on months for all years
with rolling_total_cte as
(select substring(`date`,1,7) as `month`,sum(total_laid_off) as total
from layoffs_staging2 
group by 1
having `month` is not null
order by 1 asc)
select `month` ,total,sum(total) over(order by `month`) as rolling_total
from rolling_total_cte ;



-- The companies with the most layoffs during each year
with company_year(company,years,total_laid_off) as
(    
select company,year(`date`),sum(total_laid_off) 
from layoffs_staging2
group by company,year(`date`)
),company_year_rank as
(
select*,
dense_rank() over(partition by years order by total_laid_off desc ) As ranking
from company_year
where years is not null
)
select*
from company_year_rank 
where ranking<=5;










