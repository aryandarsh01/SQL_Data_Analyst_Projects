/*
Question: What are the most optimal skills for data analysts-balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Analyst position with specified annual salaries.
-Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills 
        appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the 
        most practical and valuable to learn for data engineering careers.
*/

SELECT
    sd.skills,
    MEDIAN (jpf.salary_year_avg) AS median_salary,
    COUNT(sd.skills) AS skill_count,
    COUNT(jpf.salary_year_avg) AS salary_count,
    CASE
        WHEN COUNT(jpf.salary_year_avg) = 0 THEN 0
        ELSE ROUND(LN(COUNT(jpf.salary_year_avg)+1), 3)
    END AS ln_salary_count_plus_1,
    CASE
        WHEN COUNT(jpf.salary_year_avg) = 0 THEN 0
        ELSE ROUND(MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.salary_year_avg)+1)/1_000_000, 2)
    END AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_country LIKE '%India%' AND
    jpf.job_title_short = 'Data Analyst' AND
    jpf.job_work_from_home = True
GROUP BY sd.skills
ORDER BY optimal_score DESC
LIMIT 15;

 /*
 Breakdown of the Most Optimal Skills for Remote Data Analysts in India

Top Skills by Optimal Score

- SQL leads the list with a median salary of 60,000 and the highest optimal score of 0.08.
- Tableau has the highest observed median salary of 67,500, with 692 job-skill records.
- Python and AWS both show a median salary of 60,000, with 1,002 and 154 job-skill records, respectively.
- Excel appears in 691 job-skill records, with a median salary of 23,040.
- SharePoint shows a median salary of 40,000, but has only 10 job-skill records.

Data Analysis & Visualization Tools

- Tableau stands out with the highest observed median salary among the listed skills.
- Power BI appears in 493 job-skill records, with a median salary of 23,040.
- Excel also appears frequently, highlighting its presence in the dataset.

Programming & Cloud Technologies

- Python appears in 1,002 job-skill records, with a median salary of 60,000.
- AWS appears in 154 records and has the same median salary of 60,000.
- SQL remains prominent in both demand and the custom optimal score.

Summary

- SQL ranks highest according to the optimal score, while Tableau has the highest observed median salary. 
- However, the available salary counts for these skills range from just 1 to 3 records, so the salary estimates may not represent the wider job market. 
- The optimal score combines median salary with the logarithm of salary count to balance compensation and data availability; 
    it is a custom comparison metric, not an actual salary or standardized measure of skill value.



Why Use Logarithms Instead of Simple Multiplication?

- The optimal score is calculated as:
    Median Salary × LN(Salary Count + 1)

- A simple multiplication by `salary_count` would make the score increase too quickly as the number of salary records grows. 
    The logarithm increases more slowly, allowing salary to remain an important factor without letting record count dominate the score. 
    Adding 1 also prevents a salary count of 1 from producing a zero score.

┌────────────┬───────────────┬─────────────┬──────────────┬────────────────────────┬───────────────┐
│   skills   │ median_salary │ skill_count │ salary_count │ ln_salary_count_plus_1 │ optimal_score │
│  varchar   │    double     │    int64    │    int64     │         double         │    double     │
├────────────┼───────────────┼─────────────┼──────────────┼────────────────────────┼───────────────┤
│ sql        │       60000.0 │        1318 │            3 │                  1.386 │          0.08 │
│ tableau    │       67500.0 │         692 │            1 │                  0.693 │          0.05 │
│ aws        │       60000.0 │         154 │            1 │                  0.693 │          0.04 │
│ python     │       60000.0 │        1002 │            1 │                  0.693 │          0.04 │
│ excel      │       23040.0 │         691 │            3 │                  1.386 │          0.03 │
│ sharepoint │       40000.0 │          10 │            1 │                  0.693 │          0.03 │
│ sheets     │       22500.0 │          77 │            1 │                  0.693 │          0.02 │
│ ssrs       │       23040.0 │          14 │            1 │                  0.693 │          0.02 │
│ power bi   │       23040.0 │         493 │            1 │                  0.693 │          0.02 │
│ c#         │       23040.0 │          14 │            1 │                  0.693 │          0.02 │
│ notion     │          NULL │           2 │            0 │                    0.0 │           0.0 │
│ css        │          NULL │          12 │            0 │                    0.0 │           0.0 │
│ svn        │          NULL │           1 │            0 │                    0.0 │           0.0 │
│ cassandra  │          NULL │           6 │            0 │                    0.0 │           0.0 │
│ sap        │          NULL │          75 │            0 │                    0.0 │           0.0 │
└────────────┴───────────────┴─────────────┴──────────────┴────────────────────────┴───────────────┘
  15 rows                                                                                6 columns
  */