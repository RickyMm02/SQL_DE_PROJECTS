-- EXTRACT function

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

-- DATE_TRUNC function
SELECT 
    DATE_TRUNC('month', job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY 
    DATE_TRUNC('month', job_posted_date)
ORDER BY
    job_posted_month;


-- AT TIME ZONE function
SELECT  
    '2026-01-01 00:00:00+00'::TIMESTAMPTZ AT TIME ZONE 'CST';

SELECT
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'CST'
FROM
    job_postings_fact
LIMIT 10;

SELECT 
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST') AS job_posted_hour,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY 
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST')
ORDER BY
    job_posted_hour;