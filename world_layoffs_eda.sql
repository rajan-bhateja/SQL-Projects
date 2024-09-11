# Exploratory Data Analysis

SELECT 
    *
FROM
    layoffs_staging2;


SELECT 
    MIN(`date`), MAX(`date`)
FROM
    layoffs_staging2;
    

SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT 
    industry, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;



SELECT 
    MIN(`date`), MAX(`date`)
FROM
    layoffs_staging2;



SELECT 
    country, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


SELECT 
    *
FROM
    layoffs_staging2;


SELECT 
    YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


SELECT 
    stage, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


SELECT 
    company, AVG(percentage_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT 
    *
FROM
    layoffs_staging2;
    
    
SELECT 
    SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off)
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1;

# CTE
with Rolling_Total as
(
SELECT 
    SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off) as total_off
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1
)
select `Month`, total_off, sum(total_off) over(order by `Month`) as rolling_total
from Rolling_Total;

# CTE
With Company_Year (company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), Company_Year_Rank as
(
select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from Company_Year
where years is not null
order by ranking
)
select * from Company_Year_Rank
where ranking<=5
order by years;


SELECT 
    location, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY location
ORDER BY 2 DESC;

select * from layoffs_staging2;

SELECT 
    stage, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;