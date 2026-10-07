/*
Question: What are the highest-paying skills for data analysts in India?
- Calculate the median salary for each skill required in data analyst positions
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highjest compensation while also showing
    how common those skills are, providing a more complete picture for skill development priorities
*/


SELECT
    sd.skills,
    ROUND(MEDIAN (jpf.salary_year_avg), 0) AS median_salary,
    COUNT (jpf.*) AS demand_count
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
ORDER BY median_salary DESC
LIMIT 10;



/*
Here's a breakdown of the highest-paying skills for remote Data Analysts in India:

Key Insights:

- Tableau has the highest median annual salary at $67,500, though its demand count is 692 job-skill records.
- SQL, Python, and AWS all have a median annual salary of $60,000. SQL leads in demand with 1,318 records, followed by Python with 1,002 and AWS with 154.
- Excel and Power BI have lower median annual salaries at $23,040, but both show considerable demand (Excel: 691 records; Power BI: 493 records).
- SharePoint has a median salary of $40,000 but appears in only 10 job-skill records, so its salary result should be interpreted cautiously.
- C# and SSRS each have a median salary of $23,040 and 14 demand records, while Sheets has a median salary of $22,500 with 77 records.
- Comparing salary with demand reveals that the highest-paying skill is not necessarily the most frequently requested.

Takeaway: Tableau shows the highest median salary in this dataset, while SQL and Python combine a $60,000 median salary with the strongest demand.
         Excel and Power BI also appear frequently despite lower median salaries. These findings can help compare compensation and skill demand, 
         but salary estimates based on small samples may not reflect the wider job market.


┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ tableau    │       67500.0 │          692 │
│ python     │       60000.0 │         1002 │
│ aws        │       60000.0 │          154 │
│ sql        │       60000.0 │         1318 │
│ sharepoint │       40000.0 │           10 │
│ excel      │       23040.0 │          691 │
│ power bi   │       23040.0 │          493 │
│ c#         │       23040.0 │           14 │
│ ssrs       │       23040.0 │           14 │
│ sheets     │       22500.0 │           77 │
└────────────┴───────────────┴──────────────┘
  10 rows                         3 columns

*/



