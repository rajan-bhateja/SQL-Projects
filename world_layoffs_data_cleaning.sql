SELECT 
    *
FROM
    layoffs;

CREATE TABLE layoffs_staging LIKE layoffs;

SELECT 
    *
FROM
    layoffs_staging;

insert into layoffs_staging
select * from layoffs;

with duplicate_cte as 
(
	select *, row_number()
    over(partition by company, location, industry, total_laid_off,
    percentage_laid_off, `date`, stage, country, funds_raised_millions)
    as row_num
    from layoffs_staging
)
select * from duplicate_cte
where row_num>1;


CREATE TABLE `layoffs_staging2` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
    `row_num` INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;

SELECT 
    *
FROM
    layoffs_staging2;

insert into layoffs_staging2
select *, row_number()
    over(partition by company, location, industry, total_laid_off,
    percentage_laid_off, `date`, stage, country, funds_raised_millions)
    as row_num
    from layoffs_staging;
    
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    row_num > 1;

DELETE FROM layoffs_staging2 
WHERE
    row_num > 1;


SELECT 
    company, TRIM(company), location, industry
FROM
    layoffs_staging2;

UPDATE layoffs_staging2 
SET 
    company = TRIM(company);

UPDATE layoffs_staging2 
SET 
    industry = TRIM(industry);

UPDATE layoffs_staging2 
SET 
    location = TRIM(location);

SELECT DISTINCT
    industry
FROM
    layoffs_staging2
ORDER BY industry;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry LIKE 'Crypto%';

UPDATE layoffs_staging2 
SET 
    industry = 'Crypto'
WHERE
    industry LIKE 'Crypto%';

SELECT DISTINCT
    (industry)
FROM
    layoffs_staging2;

SELECT DISTINCT
    (country)
FROM
    layoffs_staging2
ORDER BY 1;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    country LIKE 'United States%';

UPDATE layoffs_staging2 
SET 
    country = 'United States'
WHERE
    country LIKE 'United States%';

SELECT 
    `date`
FROM
    layoffs_staging2;

SELECT 
    `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM
    layoffs_staging2;

UPDATE layoffs_staging2 
SET 
    `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT 
    *
FROM
    layoffs_staging2;

alter table layoffs_staging2
modify column `date` date;


SELECT 
    *
FROM
    layoffs_staging2;

UPDATE layoffs_staging2 
SET 
    industry = NULL
WHERE
    industry = '';

SELECT 
    t1.company, t1.industry, t2.company, t2.industry
FROM
    layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company
WHERE
    (t1.industry IS NULL OR t1.industry = '')
        AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company 
SET 
    t1.industry = t2.industry
WHERE
    t1.industry IS NULL
        AND t2.industry IS NOT NULL;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    company = 'Airbnb';

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging2 
WHERE
    total_laid_off IS NULL
    AND percentage_laid_off IS NULL;

SELECT 
    *
FROM
    layoffs_staging2;

alter table layoffs_staging2
drop column row_num;
