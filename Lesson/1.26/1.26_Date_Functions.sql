SELECT
    job_posted_date,
    job_posted_date::DATE AS date,
    job_posted_date::TIME AS time,
    job_posted_date::TIMESTAMP AS timestamp,
    job_posted_date::TIMESTAMPTZ AS zone_va_re
FROM job_postings_fact
LIMIT 10;



SELECT
    job_posted_date,
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
    EXTRACT(DAY FROM job_posted_date) AS job_posted_day
FROM job_postings_fact
LIMIT 10;

SELECT
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY
    EXTRACT(YEAR FROM job_posted_date),
    EXTRACT(MONTH FROM job_posted_date)
ORDER BY
    job_posted_year,
    job_posted_month;


SELECT
    job_posted_date,
    DATE_TRUNC('month', job_posted_date) AS job_posted_month
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;


SELECT
    job_posted_date,
    DATE_TRUNC('year', job_posted_date) AS truncated_year,
    DATE_TRUNC('quarter', job_posted_date) AS truncated_quarter,
    DATE_TRUNC('month', job_posted_date) AS truncated_month,
    DATE_TRUNC('week', job_posted_date) AS truncated_week,
    DATE_TRUNC('day', job_posted_date) AS truncated_day,
    DATE_TRUNC('hour', job_posted_date) AS truncated_hour
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;


SELECT
    DATE_TRUNC('month', job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY
    DATE_TRUNC('month', job_posted_date)
ORDER BY
    job_posted_month;


SELECT
    DATE_TRUNC('month', job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer' AND
      EXTRACT(YEAR FROM job_posted_date) = 2024
      --DATE_TRUNC('year', job_posted_date) = '2024-01-01'
GROUP BY
    DATE_TRUNC('month', job_posted_date)
ORDER BY
    job_posted_month;


SELECT
    '2026-01-01 00:00:00+00'::TIMESTAMPTZ;

SELECT
    '2026-01-01 00:00:00+00'::TIMESTAMPTZ AT TIME ZONE 'IST';

SELECT
    '2026-01-01 00:00:00+00'::TIMESTAMPTZ AT TIME ZONE 'CST';




SELECT
    job_posted_date
FROM
    job_postings_fact
LIMIT 10;



SELECT
    job_posted_date AT TIME ZONE 'UTC' 
FROM
    job_postings_fact
LIMIT 10;
--Here UTC is set as a time zone of the timestamp and then duckdb display it into IST TZ by converting uct timstamptz to session tz.



SELECT
    job_posted_date AT TIME ZONE 'IST' 
FROM
    job_postings_fact
LIMIT 10;


SELECT
    job_posted_date AT TIME ZONE 'CST' 
FROM
    job_postings_fact
LIMIT 10;



--converts a timestamp first into UTC(timestamtz) and later converts it to IST(timestamp).
--WHY??
--Beacuse same timestamp(2026-01-01 00:00:00) could represent different instant because they could belong to different tz.
--And different timestamp(2023-01-01 00:00:04//2023-01-01 05:30:04) could represent to same instant.
SELECT
    job_posted_date AT TIME ZONE 'UTC',
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST',
    job_posted_date AT TIME ZONE 'IST' AT TIME ZONE 'IST',
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'UTC'
FROM
    job_postings_fact
LIMIT 10;



SELECT
    job_title_short,
    job_location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM
    job_postings_fact
WHERE
    job_location LIKE '%Delhi%';



SELECT
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST') AS job_posted_hour,
    COUNT(job_id)
FROM
    job_postings_fact
WHERE
    job_location LIKE '%Delhi%'
GROUP BY
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST')
ORDER BY
    job_posted_hour;