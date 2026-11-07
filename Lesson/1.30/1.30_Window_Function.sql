-- Count Rows - Aggregate Only
SELECT
    COUNT(*)
FROM
    job_postings_fact;


-- Count Rows - Window Function
SELECT
    job_id,
    COUNT(*) OVER()
FROM
    job_postings_fact;


--Partition BY - Find hourly salary

SELECT AVG(salary_hour_avg)
FROM job_postings_fact;


SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER()
FROM job_postings_fact;



SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
    )
FROM job_postings_fact
LIMIT 10;



SELECT
    job_id,
    job_title_short,
    company_id
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short, company_id
    ) AS avg_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;





/*
WITH FILTER AS(
    SELECT
        job_id,
        job_title_short,
        company_id,
        salary_hour_avg,
        AVG(salary_hour_avg) OVER(
            PARTITION BY job_title_short
        ) AS avg_salary
    FROM job_postings_fact)

SELECT *
FROM FILTER
WHERE job_title_short = 'Data Scientist' AND
    company_id IN(12463, 15886, 1114220, 6213, 910462, 6249, 5585)
ORDER BY RANDOM()
LIMIT 10;




WITH FILTER AS(
    SELECT
        job_id,
        job_title_short,
        company_id,
        salary_hour_avg,
        AVG(salary_hour_avg) OVER(
            PARTITION BY job_title_short, company_id
        ) AS avg_salary
    FROM job_postings_fact)


SELECT *
FROM FILTER
WHERE job_title_short = 'Data Scientist' AND
    company_id IN(12463, 15886, 1114220, 6213, 910462, 6249, 5585)
ORDER BY RANDOM()
LIMIT 10;
*/



--ORDER BY - Ranking hourly salary
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY
   salary_hour_avg ASC
LIMIT 10;



-- PARTITION BY & ORDER BY - Running Average Hourly Salary
SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) AS running_avg_hourly_by_title
--avg based on (upto each) orderby which is based on partitionby
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY
    job_title_short,
    job_posted_date;


--PARTITION BY & ORDER BY - Ranking by job_title_short
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    job_title_short,
    salary_hour_avg DESC
LIMIT 10;


SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC,
    job_title_short
LIMIT 10;







-- Ranking Functions - RANK() vs DENSE_RANK
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    DENSE_RANK() OVER(
    --RANK() OVER(
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY
   salary_hour_avg DESC
LIMIT 140;


--ROW_NUMBER() - Providing a new job_id
SELECT
    *,
    ROW_NUMBER() OVER(
        ORDER BY job_posted_date
    )
FROM
    job_postings_fact
ORDER BY
    job_posted_date
LIMIT 20;


--LAG() - Time Based Comparison of Company Yearly Salary
SELECT
    job_id,
    company_id,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_postings_salary
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;



SELECT
    job_id,
    company_id,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_postings_salary,
    salary_year_avg - LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;



--LAG() - Time Based Comparison of Company Yearly Salary
SELECT
    job_id,
    company_id,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_postings_salary,
    salary_year_avg - LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;