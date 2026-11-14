# Data Warehouse & Mart Build: Production ETL Pipeline

An end-to-end data analytics pipeline that transforms raw CSV files from Google Cloud Storage into a structured, normalized star schema data warehouse, then builds analytical data marts to support data exploration, reporting, and business insights.

![Data Pipeline Architecture](../Images\1_2_Project2_Data_Pipeline.png)

## 🧾 Executive Summary
✅ Pipeline scope: Built an end-to-end data analytics pipeline, transforming raw CSV files into a structured star schema data warehouse and analytical data marts.

✅ Data modeling: Designed a star schema consisting of fact tables, dimension tables, and bridge tables to handle many-to-many relationships.

✅ ETL development: Implemented extract, transform, and load (ETL) processes with idempotent operations and data quality checks to ensure data consistency and reliability.

✅ Analytical data marts: Developed specialized data marts (flat, skills, and priority) with additive measures and incremental update patterns to support efficient data analysis and reporting.


## 🧩 Problem & Context

Raw job posting data is stored in flat CSV files in Google Cloud Storage, making it difficult to perform consistent and efficient analytical queries. Analysts need to answer important questions such as:

- Which skills are most in demand in the job market?
- How do hiring trends vary across companies and locations?
- How do salary patterns differ by job role and required skills?

**Challenge:** Raw data is not directly suitable for complex analytical queries. A centralized data warehouse is needed to organize data, maintain consistency, and provide a reliable foundation for analysis. Furthermore, specialized data marts can simplify recurring analytical queries through pre-aggregated datasets, reducing query complexity and improving query performance.

**Solution:** Developed an end-to-end data analytics pipeline that extracts raw CSV files from Google Cloud Storage, transforms and organizes the data into a star schema data warehouse (separating fact and dimension tables), and builds specialized analytical data marts for flat data analysis, skill demand analysis, and priority role tracking.

## 🧰 Tech Stack

🐤 Database: DuckDB (file-based OLAP database with GCS integration via httpfs)
🧮 Language: SQL (DDL for schema design, DML for data loading and transformation)
📊 Data Model: Star schema (fact + dimension + bridge tables)
🛠️ Development: VS Code for SQL editing + Terminal for DuckDB CLI execution
🔧 Automation: Master SQL script for pipeline orchestration
📦 Version Control: Git/GitHub for versioned pipeline scripts
☁️ Storage: Google Cloud Storage for source CSV files

## 🏗️ Pipeline Architecture
![Data Pipeline Architecture](../Images/1_2_Project2_Data_Pipeline.png)

The pipeline transforms job posting CSVs from Google Cloud Storage into a normalized star schema data warehouse, then builds specialized analytical data marts. BI tools (Excel, Power BI, Tableau, Python) consume from both the warehouse and marts.

### Data Warehouse

The data warehouse implements a star schema with `company_dim`, `skills_dim`, `job_postings_fact`, and `skills_job_dim` tables.

![Data Warehouse Schema](../Images\1_2_Data_Warehouse.png)

- **SQL Files:**
  - [`01_create_tables_dw.sql`](./01_create_tables_dw.sql) – Defines star schema with 4 core tables
  - [`02_load_schema_dw.sql`](./02_load_schema_dw.sql) – Extracts CSVs from GCS and loads into warehouse tables
- **Purpose:** Star schema serving as single source of truth for analytical queries
- **Grain:** One row per job posting in the fact table (`job_postings_fact`)

### Flat Mart

Denormalized table with all dimensions for ad-hoc queries.

![Flat Mart Schema](../Images\1_2_Flat_Mart.png)

- **SQL File:** [`03_create_flat_mart.sql`](./03_create_flat_mart.sql) – Builds denormalized table with all dimensions joined
- **Purpose:** Denormalized table for quick ad-hoc queries
- **Grain:** One row per job posting with all dimensions joined

### Skills Mart

Time-series skill demand analysis with additive measures.

![Skills Mart Schema](../Images\1_2_Skills_Mart.png)

- **SQL File:** [`04_create_skills_mart.sql`](./04_create_skills_mart.sql) – Builds time-series skill demand mart
- **Purpose:** Time-series analysis of skill demand over time with additive measures
- **Grain:** `skill_id + month_start_date + job_title_short`
- **Key Features:** All measures are additive (counts/sums) for safe re-aggregation

### Priority Mart

Priority role tracking with incremental updates using MERGE operations.

![Priority Mart Schema](../Images\1_2_Priority_Mart.png)

- **SQL Files:**
  - [`05_create_priority_mart.sql`](./05_create_priority_mart.sql) – Initial build of priority roles and jobs snapshot
  - [`06_update_priority_mart.sql`](./06_update_priority_mart.sql) – **Incremental update using MERGE** (upsert pattern)
- **Purpose:** Track priority roles and job snapshots with incremental update capabilities
- **Grain:** One row per job posting with priority level assignment
- **Key Features:** **MERGE operations for incremental updates** - demonstrates production-ready upsert patterns (INSERT, UPDATE, DELETE in single statement)

## 💻 Data Engineering Skills Demonstrated

### ETL Pipeline Development

- **Extract:** Direct CSV loading from Google Cloud Storage using DuckDB's `httpfs` extension  
- **Transform:** Data normalization, type conversion (`CAST`, `DATE_TRUNC`), and quality filtering  
- **Load:** Idempotent table creation with `DROP TABLE IF EXISTS` patterns  
- **Incremental Updates:** MERGE operations for upsert patterns (INSERT, UPDATE, DELETE in single statement)  
- **Orchestration:** Master SQL script (`build_dw_marts.sql`) for automated pipeline execution  

### Dimensional Modeling

- **Star Schema Design:** Fact table (`job_postings_fact`) with dimension tables (`company_dim`, `skills_dim`)  
- **Bridge Tables:** Many-to-many relationship handling (`skills_job_dim`, `bridge_company_location`, `bridge_job_title`)  
- **Grain Definition:** Proper fact table granularity (skill+month, company+title+location+month)  
- **Additive Measures:** Counts and sums that can be safely re-aggregated at any level  
- **Surrogate Keys:** Sequential ID generation using CTEs with self-joins (optional company_mart build only)  



### SQL Advanced Techniques

- **DDL Operations:** `CREATE TABLE`, `DROP TABLE`, `CREATE SCHEMA` for schema management  
- **DML Operations:** `INSERT INTO ... SELECT` with explicit column mapping from CSV sources  
- **MERGE Operations:** Incremental updates using `MERGE INTO` with `WHEN MATCHED`, `WHEN NOT MATCHED`, and `WHEN NOT MATCHED BY SOURCE` clauses for production-ready upsert patterns  
- **CTEs:** Common Table Expressions for complex transformations and boolean flag conversions  
- **Date Functions:** `DATE_TRUNC('month')`, `EXTRACT(quarter)` for temporal dimension creation  
- **String Functions:** `STRING_AGG` for concatenation, `REPLACE` for data cleaning  
- **Boolean Logic:** `CASE WHEN` conversions for aggregating flags (remote, health insurance, no degree)  

### Data Quality & Production Practices

- **Idempotency:** All scripts safely rerunnable without side effects  
- **Data Validation:** Verification queries at each pipeline step to ensure data integrity  
- **Type Safety:** Proper data type definitions (`VARCHAR`, `INTEGER`, `DOUBLE`, `BOOLEAN`, `TIMESTAMP`)  
- **Schema Organization:** Separate schemas (`flat_mart`, `skills_mart`, `priority_mart`, `company_mart`) for logical separation  
- **Error Handling:** Structured script execution with clear error messages and progress reporting  


