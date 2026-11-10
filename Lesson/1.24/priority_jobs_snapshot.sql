-- Source Table – The table from which we take data.
-- Target Table – The table into which we want to insert, update, or delete data.

-- Term	    Meaning
-- Source	Where data comes FROM
-- Target	Where data goes TO


-- 1. How can we prepare the source data for synchronizing priority jobs?

--CREATE TEMP Table
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM
    data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles AS r
    ON jpf.job_title_short = r.role_name;

/*
-- 2. How can we update the priority level and timestamp of existing jobs when their priority changes?

--UPDATE statement
UPDATE main.priority_jobs_snapshot AS tgt
SET
    priority_lvl = src.priority_lvl,
    updated_at = src.updated_at
FROM src_priority_jobs AS src
WHERE tgt.job_id = src.job_id
    AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;


-- 3. How can we insert new priority jobs that do not already exist in the target table?

--INSERT Statement
INSERT INTO main.priority_jobs_snapshot(
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
SELECT
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
FROM src_priority_jobs AS src
WHERE NOT EXISTS(
    SELECT 1
    FROM main.priority_jobs_snapshot AS tgt
    WHERE tgt.job_id = src.job_id
);


-- 4. How can we delete jobs from the target table that no longer exist in the source data?

-- DELETE Statement
DELETE FROM main.priority_jobs_snapshot AS tgt
WHERE NOT EXISTS (
    SELECT 1
    FROM src_priority_jobs AS src
    WHERE src.job_id = tgt.job_id
);
*/


--MERGE INTO
MERGE INTO main.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id


WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at


WHEN NOT MATCHED THEN 
    INSERT(
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    )
    VALUES(
        src.job_id,
        src.job_title_short,
        src.company_name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        src.updated_at
    )


WHEN NOT MATCHED BY SOURCE THEN DELETE;






-- FINAL CHECK QUERY
SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;






/*
Two ways to achieve the same final result

Method A: Rebuild the entire table (main.priority_jobs_snapshot)
 What happens?
This reads the source tables and replaces the target table with the query's result.
The benefit is simplicity: one query does the work.
However, there are important trade-offs:
- The entire target table is rebuilt, even if only one job's priority changed.
One query does everything. You don't need a temporary table or separate UPDATE, INSERT, and DELETE statements.


Method B: Synchronize the existing table
Your current approach does this:
1. Prepare the latest desired data in src_priority_jobs.
2. Compare it with main.priority_jobs_snapshot and apply only the necessary changes.
That gives you three distinct operations:
Operation	What it does
1. UPDATE existing jobs when their priority changes.
2. INSERT jobs that are missing from the target.
3. DELETE jobs that no longer exist in the source.
The goal is to maintain the existing target table rather than rebuild it from scratch.

This is commonly called synchronization or a form of incremental loading.
*/

