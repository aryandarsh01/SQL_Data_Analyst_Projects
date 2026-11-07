SELECT LENGTH('SQL');
SELECT CHAR_LENGTH('SQL');
SELECT CHARACTER_LENGTH('SQL');

SELECT LOWER('SQL');

SELECT UPPER('sql');

SELECT LEFT('SQL', 2);

SELECT RIGHT('SQL', 2);

SELECT SUBSTRING('SQL', 2, 1);

SELECT CONCAT('SQL', '_', 'Functions');

SELECT 'SQL' || '_' || 'Functions';

SELECT ' SQL ';

SELECT TRIM(' SQL ');

SELECT LTRIM(' SQL ');

SELECT RTRIM(' SQL ');

SELECT REPLACE('SQL', 'Q', '_');

SELECT REGEXP_EXTRACT('bhartiya.machinery@gmail.com', 'gmail');

--patern is what is present inside the ''.
SELECT REGEXP_EXTRACT('Order ID: 12345', '2');--patern is 2


--only pick the match of the pattern and then stop.
SELECT REGEXP_EXTRACT('Order ID: 12345', '2');

--only pick the firstcome match of the pattern and then stop.
SELECT REGEXP_EXTRACT('Order ID: 123452', '2');

--DIGITS SHOULD BE IN SEQUENCE
SELECT REGEXP_EXTRACT('Order ID: 1223345', '32');
SELECT REGEXP_EXTRACT('Order ID: 1223345', '23');


-- "+" MAKE THE PRECEDING digit REPETATIVE
SELECT REGEXP_EXTRACT('Order ID: 122045', '2+');--patern could be 2, 22, 222, 2222 whatever continous sequence of 2 is present.
-- AS:- SELECT REGEXP_EXTRACT('Order ID: 122045', '22')
--in xy+ PATTERN COULD BE xy, xyy, xyy BECAUSE only y is preceding of "+" not x.
SELECT REGEXP_EXTRACT('Order ID: 1223345', '23+');

--When two or more digits are present in the square bracket which is preceding of "+" then every two or more individual digits act as a seperate preceding of "+".
SELECT REGEXP_EXTRACT('Order ID: 1223345', '[23]+');
--output is same as above because..
SELECT REGEXP_EXTRACT('Order ID: 1223345222', '[232]+');--sequence is wrong
SELECT REGEXP_EXTRACT('Order ID: 1223345', '[235]+');--sequence is wrong

SELECT REGEXP_EXTRACT('Order ID: 1223322245', '[232]+');--sequence is right
SELECT REGEXP_EXTRACT('Order ID: 1223355', '[235]+');--sequence is right


--only pick the match of first matched-pattern and then stop.
SELECT REGEXP_EXTRACT('Order ID: 12345', '[0-9]');
SELECT REGEXP_EXTRACT('Order ID: 21345', '[0-9]');
SELECT REGEXP_EXTRACT('Order ID: 31245', '[0-9]');


--keep picking the match for each pattern till the chain break.
--(Sequence is not studied because each pattern is a single digit and ther is no-sequence in single digit)
SELECT REGEXP_EXTRACT('Order ID: 12345', '[0-9]+');
SELECT REGEXP_EXTRACT('Order ID: 1122334455', '[0-9]+');
SELECT REGEXP_EXTRACT('Order ID: 12345123', '[0-9]+');
SELECT REGEXP_EXTRACT('Order ID: and12345', '[0-9]+');
SELECT REGEXP_EXTRACT('Order ID: 78910AND12345', '[0-9]+');

SELECT REGEXP_EXTRACT('Hello Aryan', '[A-Z][a-z]+');


-- "." Represent single digit pattern that could be any thing.
SELECT REGEXP_EXTRACT('Order ID: 12345', '.');
-- continous multiple "." represent multiple digit pattern.
SELECT REGEXP_EXTRACT('Order ID: 12345', '..');
SELECT REGEXP_EXTRACT('Order ID: 12345', '...');
SELECT REGEXP_EXTRACT('Order ID: 12345', '.+');
SELECT REGEXP_EXTRACT('Order ID: 12345', '.*');
SELECT REGEXP_EXTRACT('Order ID: 12345', '^.+');
SELECT REGEXP_EXTRACT('Order ID: 12345', '^.*');


/*
. = Match any single character.
+ = Match one or more occurrences of the preceding pattern.
* = Match zero or more occurrences of the preceding pattern.
*/

SELECT
    REGEXP_EXTRACT('B', '^.+B') AS plus_result,
    REGEXP_EXTRACT('B', '^.*B') AS star_result;


--^ means the beginning (starting position) of a string.
--^ tells regex that the pattern must be present at the beginning of the string.”
SELECT REGEXP_EXTRACT('Order ID: 12345', 'ID.+');
SELECT REGEXP_EXTRACT('Order ID: 12345', '^ID.+');


--REGEXP_REPLACE() is used to find a particular pattern in a string and replace the matched portion with something else.
SELECT REGEXP_REPLACE('bhartiyamachinery@gmail.com', 'gmail', 'yahoo');
SELECT REGEXP_EXTRACT('bhartiyamachinery@gmail.com', '^.*(@)');
SELECT REGEXP_REPLACE('bhartiyamachinery@gmail.com', '^.*(@)','\1');


/*
() = Capture a portion of the match
\1 = Reuse the first captured portion.
\2 = Reuse the second captured portion.
*/

--Final Example - Cleanup this using Text Functions

SELECT
    job_title,
    CASE
        WHEN job_title LIKE '%Data%'
         AND job_title LIKE '%Analyst%' THEN 'Data Analyst'
        WHEN job_title LIKE '%Data%'
         AND job_title LIKE '%Scientist%' THEN 'Scientist'
        WHEN job_title LIKE '%Data%'
         AND job_title LIKE '%Engineer%' THEN 'Engineer'
        ELSE 'Other'
      END AS job_title_category
    FROM job_postings_fact
    ORDER BY RANDOM()
    LIMIT 30;


WITH title_lower As(
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM    job_postings_fact
)

SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        ELSE 'Other'
      END AS job_title_category
    FROM title_lower
    ORDER BY RANDOM()
    LIMIT 30;


SELECT NULLIF(10, 10);
SELECT NULLIF(10, 20);

SELECT NULLIF('same', 'same');
SELECT NULLIF('1stsame', '2nddiffer');


SELECT NULLIF(5+5, 20);



SELECT
    salary_year_avg,
    salary_hour_avg
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_Avg IS NOT NULL
LIMIT 10;


--What if salary_year_avg, salary_hour_avg have 0 inplace of null.
SELECT
    NULLIF(salary_year_avg, 0),
    NULLIF(salary_hour_avg, 0)
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_Avg IS NOT NULL
LIMIT 10;


SELECT COALESCE(0, 1, 2);
SELECT COALESCE(NULL, 1, 2);
SELECT COALESCE(NULL, NULL, 2);


SELECT
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg*2080)
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_Avg IS NOT NULL
LIMIT 10;




--Final Eaxmple
WITH salaries AS (
    SELECT
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        CASE
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg*2080
        END AS standardized_salary
    FROM
        job_postings_fact
)

SELECT
    *,
    CASE
        WHEN standardized_salary IS NULL THEN 'Misssing'
        WHEN standardized_salary < 75_000 THEN 'LOW'
        WHEN standardized_salary < 150_000 THEN 'Medium'
        ELSE 'HIGH'
    END AS salary_bucket
FROM Salaries
ORDER BY standardized_salary DESC
LIMIT 10;

--Simplify with Coalesce

SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg*2080) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) IS NULL THEN 'Misssing'
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) < 75_000 THEN 'LOW'
        WHEN COALESCE(salary_year_avg, salary_hour_avg*2080) < 150_000 THEN 'Medium'
        ELSE 'HIGH'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;