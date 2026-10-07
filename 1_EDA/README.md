# Exploratory Data Analysis w/ SQL: Job Market Analytics

![Project 1 Overview](../Images\1_1_Project1_EDA.png)

A SQL project analyzing the data analyst job market using real world job posting data. It demonstrates my ability to **write production-quality analytical SQL, design efficient queries, and turn business questions into data-driven insights**.

## Executive Summary

- **✅ Project scope**: Built **3 analytical queries** that answer key questions about the data analyst job market
- **✅ Data modeling**: Used **multi-table joins** across fact and dimension tables to extract insights
- **✅ Analytics**: Applied **aggregations, filtering, and sorting** to find top skills by demand, salary, and overall value
- **✅ Outcomes**: Delivered **actionable insights** on SQL/Python demand, BI & visualization skills, cloud-platform demand, and salary patterns

If you only have a minute, review these:

1. [`01_top_demanded_skills.sql`](01_top_demanded_skills.sql) -demand analysis with multi-table joins

2. [`02_top_paying_skills.sql`](02_top_paying_skills.sql) – salary analysis with aggregations

3. [`03_optimal_skills.sql`](03_optimal_skills.sql) – combined demand/salary optimization query

## Problem & Context
Job market analysts need to answer questions like:

- 🎯 **Most in-demand**: Which skills are most in-demand for data analysts?
- 💰 **Highest paid**: Which skills command the highest salaries?
- ⚖️ **Best trade-off**: What is the optimal skill set balancing demand and compensation?  

This project analyzes a **data warehouse** built using a star schema design. The warehouse structure consists of:

![Data Warehouse](../Images\1_2_Data_Warehouse.png)

- **Fact Table:** `job_postings_fact` - Central table containing job posting details (job titles, locations, salaries, dates, etc.)
- **Dimension Tables:**
    - `company_dim` - Company information linked to job postings
    - `skills_dim` - Skills catalog with skill names and types
- **Bridge Table:** `skills_job_dim` - Resolves the many-to-many relationship between job postings and skills

By querying across these interconnected tables, I extracted insights about skill demand, salary patterns, and optimal skill combinations for data engineering roles.

## Tech Stack

- 🐤 **Query Engine:** DuckDB for fast OLAP-style analytical queries
- 🧮 **Language:** SQL (ANSI-style with analytical functions)
- 📊 **Data Model:** Star schema with fact + dimension + bridge tables
- 🛠️ **Development:** VS Code for SQL editing + Terminal for DuckDB CLI
- 📦 **Version Control:** Git/GitHub for versioned SQL scripts

## Analysis Overview

### Query Structure
1. **[Top Demanded Skills](./01_top_demanded_skills.sql)** – Identifies the 10 most in-demand skills for remote data engineer positions
2. **[Top Paying Skills](./02_top_paying_skills.sql)** – Analyzes the 10 highest-paying skills with salary and demand metrics
3. **[Optimal Skills](./03_optimal_skills.sql)** – Calculates an optimal score using natural log of demand combined with median salary to identify the most valuable skills to learn


### Key Insights

- 🧠 Core skills: SQL and Python lead demand with 1,318 and 1,002 postings, making them the most sought-after skills.
- 📊 BI & visualization: Tableau (692), Excel (691), and Power BI (493) show strong demand for reporting and data visualization skills.
- 📈 Statistical tools: R (487) and SAS (312) remain relevant for analytics and statistical analysis roles.
- ☁️ Cloud platforms: AWS (154) and Azure (145) show growing demand for cloud skills among Data Analyst positions.
- 💰 High-paying skills: Tableau has the highest median salary at $67.5K, while SQL, Python, and AWS each reach $60K median salaries.
- 🎯 Best demand–salary balance: SQL ranks highest in your custom optimal score (0.08), combining its very high demand with a $60K median salary.

One important caveat: the salary data is based on very few salary observations for most skills (often only 1–3), so the salary figures should be treated cautiously.


## SQL Skills Demonstrated

### Query Design & Optimization

- **Complex Joins**: Multi-table `INNER JOIN` operations across `job_postings_fact`, `skills_job_dim`, and `skills_dim`
- **Aggregations**: `COUNT()`, `MEDIAN()`, `ROUND()` for statistical analysis
- **Filtering**: Boolean logic with `WHERE` clauses and multiple conditions (job_title_short, job_work_from_home)
- **Sorting & Limiting**: `ORDER BY` with `DESC` and `LIMIT` for top-N analysis

### Data Analysis Techniques

- **Grouping**: `GROUP BY` for categorical analysis by skill
- **Mathematical Functions**: `LN()` for natural logarithm transformation to normalize demand metrics
- **Conditional Logics**: `CASE WHEN`
Calculated Metrics: Derived optimal score combining log-transformed demand with median salary










