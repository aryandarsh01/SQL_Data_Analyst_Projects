SELECT 'Hello';
SELECT 'Hello' AS TAB;



-- Array Intro
SELECT [1, 2, 3];
SELECT['python', 'sql', 'r'] AS skills_array;


--in a UNION ALL, SQL takes the column names from the first SELECT statement.
--SELECT statement is only for column
SELECT 'python' AS skill
UNION ALL
SELECT 'sql' AS tkill
UNION ALL
SELECT 'r';



WITH skills AS(
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' 
    UNION ALL
    SELECT 'r'
)
SELECT skill
FROM Skills;



WITH skills AS(
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' 
    UNION ALL
    SELECT 'r'
)

SELECT ARRAY_AGG(skill) AS skills_array
FROM skills;


WITH skills AS(
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' 
    UNION ALL
    SELECT 'r'
)

SELECT LIST(skill) AS skills_array
FROM skills;






WITH skills AS(
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' 
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)

SELECT
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill
FROM skills_array;



WITH skills AS(
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' 
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
    FROM skills
)

SELECT
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill
FROM skills_array;




--###############################################



-- STRUCT
SELECT {skill: 'python', type: 'programming'} AS skill_struct;
--skill and type are field.
--STRUCT have fields.

SELECT {skill: 'python'} AS skill_struct;

--other way of creating a struct

SELECT STRUCT_PACK(skill := 'python', type := 'programming') AS skill_struct;


SELECT
    STRUCT_PACK(
        skill := 'python',
        type := 'programming'
    ) AS skill_struct;

-----------------------------------------

--STRUCT as cte
WITH skill_struct AS(
    SELECT
        STRUCT_PACK(
            skill := 'python',
            type := 'programming'
        ) AS S
)
SELECT
    s.skill,
    s.type
FROM skill_struct;

-------------------------------------------

--table with two column. (1.skill, 2.type)

SELECT 'python' AS skill, 'programming' AS type
UNION ALL
SELECT 'sql', 'query_language'
UNION ALL
SELECT 'r', 'programming';

----------------------------------------

--STRUCT using cte

WITH skill_table AS(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
)

SELECT
    STRUCT_PACK(
        skills := skills,
        type := types
    )
FROM skill_table;

------------------------------------------------

--STRUCT as cte

WITH skill_table AS(
        SELECT 'python' AS skills, 'programming' AS types
        UNION ALL
        SELECT 'sql', 'query_language'
        UNION ALL
        SELECT 'r', 'programming'),
    skill_struct AS(
        SELECT STRUCT_PACK(
            skill := skills,
            type := types
        ) AS s
        FROM skill_table)

--SELECT *
SELECT
    s.skill,
    s.type
FROM skill_struct;


/*
WITH skill_table AS(
        SELECT 'python' AS skills, 'programming' AS types
        UNION ALL
        SELECT 'sql', 'query_language'
        UNION ALL
        SELECT 'r', 'programming'),
    skill_struct AS(
        SELECT STRUCT_PACK(
            skill := skills,
            type := types
        )
        FROM skill_table)

--SELECT *
SELECT
    skill_struct.skill,
    skill_struct.type
FROM skill_struct;
*/





--#################################################




-- Array of structs

SELECT[
    {skill: 'python', type: 'programming'},
    {skill: 'sql', type: 'query_language'}
] AS skills_array_of_structs;


------------------------------------------------

--array of struct using cte

WITH skill_table AS(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
)
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skills := skills,
            type := types
            )
        )
FROM skill_table;


---------------------------------------------------

--array of struct as cte

WITH skill_table AS(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
), skills_array_struct AS (
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skills := skills,
                type := types
                )
            ) AS array_struct
    FROM skill_table
)

SELECT
    array_struct[1],
    array_struct[2],
    array_struct[3]
FROM skills_array_struct;


-----------------------------------------------
--order in struct

WITH skill_table AS(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
), skills_array_struct AS (
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skill := skills,
                type := types
                ) ORDER BY skills
            ) AS array_struct
    FROM skill_table
)

SELECT
    array_struct[1],
    array_struct[2],
    array_struct[3]
FROM skills_array_struct;


WITH skill_table AS(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
), skills_array_struct AS (
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skill := skills,
                type := types
                ) ORDER BY types
            ) AS array_struct
    FROM skill_table
)

SELECT
    array_struct[1],
    array_struct[2],
    array_struct[3]
FROM skills_array_struct;


-------------------------------------------------


WITH skill_table AS(
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
), skills_array_struct AS (
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skill:= skills,
                type := types
                )
            ) AS array_struct
    FROM skill_table
)

SELECT
    array_struct[1].skill,
    array_struct[2].type,
    array_struct[3]
FROM skills_array_struct;





--#############################################




--MAP

SELECT MAP{'skill' : 'python'};

SELECT MAP{skill : 'python'};

SELECT MAP{'skill' : 'python', 'type' : 'programming'};

SELECT MAP{'skill' : 'python', 'type' : 'programming', 'skill' : 'sql'};

---------------------------------------------

--MAP as cte

WITH skill_map AS (
    SELECT MAP{'skill' : 'python', 'type' : 'programming'} AS skill_type
)
SELECT
    skill_type['skill'],
    skill_type['type']
FROM
    skill_map;




--####################################################



--JSON




SELECT
    '{"skill":"python", "type":"programming"}'::JSON AS skill_json;

--SELECT
--    TO_JSON('{"skill":"python", "type":"programming"}') AS skill_json;



----------------------------------------------


--json as cte

WITH raw_skill_json AS (
    SELECT
        '{"skill":"python", "type":"programming"}'::JSON AS skill_json
)
SELECT
    skill_json
FROM raw_skill_json;


----------------------------------------------

WITH raw_skill_json AS (
    SELECT
        '{"skill":"python", "type":"programming"}'::JSON AS skill_json
)
SELECT
    json_extract_string(skill_json, '$') AS
    s
FROM raw_skill_json;





WITH raw_skill_json AS (
    SELECT
        '{"skill":"python", "type":"programming"}'::JSON AS skill_json
)
SELECT
    json_extract_string(skill_json, '$.skill') AS
    s
FROM raw_skill_json;



---------------------------------------------------



WITH raw_skill_json AS (
    SELECT
        '{"skill":"python", "type":"programming"}'::JSON AS skill_json
)
SELECT
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
FROM raw_skill_json;


---------------------------------------------------


--JSON to ARRAY of STRUCT


--json_each() takes the JSON array and expands its elements into separate rows.
--Each e.value is one JSON object.
WITH raw_json As(
    SELECT
        '[
          {"skill":"python", "type":"programming"},
          {"skill":"sql", "type":"query_language"},
          {"skill":"r", "type":"programming"}
        ]' :: JSON AS skills_json
)
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill := json_extract_string(e.value, '$.skill'),
            type := json_extract_string(e.value, '$.type')
        )
    ORDER BY json_extract_string(e.value, '$.skill')
    ) AS skills
FROM raw_json, json_each(skills_json) AS e;
/*
Part	                      Meaning
e.value	                     The current JSON object
'$'	                         Root of the JSON object
.skill	                     Access the skill field
json_extract_string()	     Extract its value as VARCHAR*/



--##############################################




-- Arrays -Final Example
-- Build a flat skill table for co-workers to access job_titles, salary info, and skills in one table

SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    sd.skills
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id;



SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;


/*
WITH caa as(
    SELECT
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg,
        ARRAY_AGG(sd.skills) AS skills_array
    FROM job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    LEFT JOIN skills_dim AS sd
        ON sd.skill_id = sjd.skill_id
    GROUP BY ALL)
SELECT *
FROM caa
WHERE job_title_short = 'Data Engineer';



WITH caa as(
    SELECT
        jpf.job_title_short,
        jpf.job_id,
        jpf.salary_year_avg,
        ARRAY_AGG(sd.skills) AS skills_array
    FROM job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    LEFT JOIN skills_dim AS sd
        ON sd.skill_id = sjd.skill_id
    GROUP BY ALL)
SELECT *
FROM caa
WHERE job_title_short = 'Data Engineer';
*/

------

CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;



-- From the perspective of a Data Analyst, analyze the median salary per skill

/*
WITH skills AS(
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' 
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)
SELECT
    skills
FROM skills_array;




WITH skills AS(
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql' 
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)
SELECT
    UNNEST(skills)
FROM skills_array;
*/


/*
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_array) AS skill
FROM
    job_skills_array
LIMIT 20;
*/




WITH flat_skills AS(
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM
        job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC;

------------------
/*
SELECT
    sd.skills,
    MEDIAN(salary_year_avg) AS median_salary
FROM
    job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    LEFT JOIN skills_dim AS sd
        ON sd.skill_id = sjd.skill_id
GROUP BY sd.skills
ORDER BY median_salary DESC;
*/

/*
SELECT
    table_catalog,
    table_name,
    table_schema,
    column_name
FROM information_schema.columns
WHERE table_name = 'skills_dim';


SELECT
    *
FROM skills_dim
LIMIT 10;



SELECT
    *
FROM skills_job_dim
LIMIT 10;*/





--##########################################





--Array of Structs - Final Example
--Build a flat skill & type table for co-workers to access job titles, salary info, skills, and type in one table.

--GROUP BY ALL automatically groups by all non-aggregated columns in your SELECT statement.(of select order)



/*
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL
ORDER BY jpf.job_id;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    sd.skills
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL
ORDER BY jpf.job_id;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skills_type
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;
*/


CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS(
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(--making pairs of field:value pair using value from two columns and their common rows & specified field.
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skills_type
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL);

-- From the perspective of a Data Analyst, analyze the medium salary per type of skill.
/*
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_type)--unnesting array of struct_object.
FROM
    job_skills_array_struct;



SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_type).skill_type AS skill_type,--unnesting struct_object for field.
    UNNEST(skills_type).skill_name AS skill_name--unnesting struct_object for value.
FROM
    job_skills_array_struct;
*/




WITH flat_skills AS(
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_type).skill_type AS skill_type,--unnesting struct_object for field.
        UNNEST(skills_type).skill_name AS skill_name--unnesting struct_object for value.
    FROM
        job_skills_array_struct
)
SELECT
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill_type;