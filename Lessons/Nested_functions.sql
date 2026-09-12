/*
Array, Struct, Array_of_struct, Map, JSON
*/
-- Array 

SELECT ['python','sql','r'];

WITH skills AS (
    SELECT 'python' AS skills
    UNION ALL
    SELECT 'SQL'
    UNION ALL
    SELECT 'R'
)
SELECT ARRAY_AGG(skills) AS skills_array -- or LIST()
FROM skills; 

-- Struct

SELECT {skill: 'python', type: 'programming'} AS skill_struct;

WITH skill_struct AS (
    SELECT 
        STRUCT_PACK(
            skill := 'python',
            type := 'programming'
        ) AS s
)
SELECT 
    s.skill,
    s.type
FROM skill_struct;


with skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'SQL', 'quert language'
    UNION ALL
    SELECT 'R', 'programming'
)
SELECT 
    STRUCT_PACK(
        skill := skills,
        type := types
    )
FROM skill_table;

-- Array of Structs

SELECT [
    {skill: 'python', type:'programming'},
    {skill: 'sql', type:'query language'}
] AS skills_array_of_struct;

with skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'SQL', 'quert language'
    UNION ALL
    SELECT 'R', 'programming'
)
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill := skills,
            type := types
        )
    )
FROM skill_table;

-- Map

WITH skill_map AS (
    SELECT MAP {'skill':'python', 'type':'programming'} AS skill_type
)
SELECT
    skill_type['skill'],
    skill_type['type']
FROM
    skill_map;

-- JSON
WITH raw_skill_json AS (
    SELECT 
        '{"skill":"python", "type":"programming"}'::json as skill_json
)
SELECT 
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
FROM raw_skill_json;


SELECT 
    TO_JSON('{"skill":"python", "type":"programming"}') as skill_json;


-- Arrays - Final Example
-- Build a flat skill table for co-workers to access job titles, salary info, and skills in one table

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

WITH flat_skills AS (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS medain_salary
FROM flat_skills
GROUP BY skill
ORDER BY medain_salary DESC;

-- Array of Structs - Final Example
-- Build a flat skill & type table for co-workers to access job titles, salary info, skills, and type in one table

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
     ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

-- From the perspective of a Data Analyst, analyze the median salary per type of skill

WITH flat_skills AS (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array).skill_type AS skill_type,
        UNNEST(skills_array).skill_name AS skill_name
    FROM job_skills_array_struct
)
SELECT
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill_type;


