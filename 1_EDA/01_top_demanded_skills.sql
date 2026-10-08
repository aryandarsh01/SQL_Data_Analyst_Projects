/*
Question: What are the most in-demand skills for data analyst in India?
- Identify the top 10 in-demand skills for data analyst in India?
- Focus on remote job postings
- Why? 
    Retrieves the top 10 skills with the highest demand in the remote
    job market, providing insights into the most valuable skills for
    data analyst seeking remote work.
*/

SELECT
    sd.skills,
    COUNT (sd.skills) AS demand_count
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
ORDER BY demand_count ASC
LIMIT 10;




/*
Here's the breakdown of the most demanded skills for remote Data Analysts in India:
SQL and Python dominate the top requirements, with SQL leading at 1,318 job postings and Python closely following at 1,002.
Data visualization tools form a heavy second tier, with Tableau (692 postings), Excel (691 postings), and Power BI (493 postings) showing nearly identical strong demand.
Cloud platforms and business intelligence tools like R, SAS, AWS, Azure, and Looker round out the top 10 skills.

Key takeaways:
- SQL and Python are the essential core technical skills for remote Data Analysts in India
- Visualization & reporting tools (Tableau, Excel, Power BI) are indispensable requirements
- R and SAS maintain steady demand for statistical analysis
- Cloud infrastructure (AWS, Azure) and BI tools (Looker) represent valuable specialized skills

┌──────────┬──────────────┐
│  skills  │ demand_count │
│ varchar  │    int64     │
├──────────┼──────────────┤
│ sql      │         1318 │
│ python   │         1002 │
│ tableau  │          692 │
│ excel    │          691 │
│ power bi │          493 │
│ r        │          487 │
│ sas      │          312 │
│ aws      │          154 │
│ azure    │          145 │
│ looker   │          110 │
└──────────┴──────────────┘
  10 rows       2 columns
*/