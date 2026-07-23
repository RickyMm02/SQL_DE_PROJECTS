/*
Find the top 10 companies for posting jobs
They must have >3000 postings
Limit this to only India Jobs
*/

EXPLAIN
SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS total_postings
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'INDIA'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY total_postings;
