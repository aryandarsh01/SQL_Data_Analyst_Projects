SELECT
    jpf.*,
    cd.*
FROM
    job_postings_fact as jpf
LEFT JOIN company_dim as cd
    ON jpf.company_id = cd.company_id
LIMIT 10;


SELECT
    job_id,
    job_title_short,
    name AS company_name,
    job_location
FROM
    job_postings_fact as jpf
LEFT JOIN company_dim as cd
    ON jpf.company_id = cd.company_id
LIMIT 10;


SELECT
    job_id,
    job_title_short,
    company_id,
    name AS company_name,
    job_location
FROM
    job_postings_fact as jpf
LEFT JOIN company_dim as cd
    ON jpf.company_id = cd.company_id
LIMIT 10;


SELECT
    job_id,
    job_title_short,
    cd.company_id,
    name AS company_name,
    job_location
FROM
    job_postings_fact as jpf
LEFT JOIN company_dim as cd
    ON jpf.company_id = cd.company_id
LIMIT 10;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact as jpf
LEFT JOIN company_dim as cd --LEFT OUTER JOIN
    ON jpf.company_id = cd.company_id
LIMIT 10;


SELECT
    COUNT(*)
FROM
    job_postings_fact;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact as jpf --positional argument(Left Table) 
LEFT JOIN company_dim as cd --positional argument(Right Table)
    ON jpf.company_id = cd.company_id;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact as jpf --positional argument(Left Table)
RIGHT JOIN company_dim as cd --positional argument(Right Table)
    ON jpf.company_id = cd.company_id;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact as jpf 
INNER JOIN company_dim as cd --(INNER JOIN is Default join in sql.so,)
--JOIN company_dim as cd
    ON jpf.company_id = cd.company_id;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact as jpf
FULL OUTER JOIN company_dim as cd --or just FULL JOIN
    ON jpf.company_id = cd.company_id;


SELECT *
FROM skills_job_dim
LIMIT 10;

SELECT *
FROM skills_dim
LIMIT 10;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LIMIT 10;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
LIMIT 10;
