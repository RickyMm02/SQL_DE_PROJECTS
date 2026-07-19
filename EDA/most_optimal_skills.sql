/*
Question: What are the most optimal skills for data engineers? - balancing both demand and salary
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why? This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately, ensuring that the most valuable skills are prioritized for skill development and career growth.
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 1) AS median_salary,
--    COUNT(jpf.salary_year_avg) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000, 2) AS ranking_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING 
    COUNT(jpf.*) > 100
ORDER BY
    ranking_score DESC
LIMIT 25;


/*
────────────┬───────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ ln_demand_count │ ranking_score │
│  varchar   │    double     │     double      │    double     │
├────────────┼───────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │             5.3 │          0.97 │
│ python     │      135000.0 │             7.0 │          0.95 │
│ sql        │      130000.0 │             7.0 │          0.91 │
│ aws        │      137320.3 │             6.7 │          0.91 │
│ airflow    │      150000.0 │             6.0 │          0.89 │
│ spark      │      140000.0 │             6.2 │          0.87 │
│ kafka      │      145000.0 │             5.7 │          0.82 │
│ snowflake  │      135500.0 │             6.1 │          0.82 │
│ azure      │      128000.0 │             6.2 │          0.79 │
│ java       │      135000.0 │             5.7 │          0.77 │
│ scala      │      137290.5 │             5.5 │          0.76 │
│ git        │      140000.0 │             5.3 │          0.75 │
│ kubernetes │      150500.0 │             5.0 │          0.75 │
│ databricks │      132750.0 │             5.6 │          0.74 │
│ redshift   │      130000.0 │             5.6 │          0.73 │
│ gcp        │      136000.0 │             5.3 │          0.72 │
│ hadoop     │      135000.0 │             5.3 │          0.71 │
│ nosql      │      134415.0 │             5.3 │          0.71 │
│ pyspark    │      140000.0 │             5.0 │           0.7 │
│ mongodb    │      135750.0 │             4.9 │          0.67 │
│ docker     │      135000.0 │             5.0 │          0.67 │
│ go         │      140000.0 │             4.7 │          0.66 │
│ r          │      134775.0 │             4.9 │          0.66 │
│ bigquery   │      135000.0 │             4.8 │          0.65 │
│ github     │      135000.0 │             4.8 │          0.65 │
└────────────┴───────────────┴─────────────────┴───────────────┘
  25 rows                                            4 columns
*/