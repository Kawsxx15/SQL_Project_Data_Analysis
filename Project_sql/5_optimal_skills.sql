/* what are the most optimal skill sets for data analyst positions considering both demand and salary? */
WITH skills_demand AS (
SELECT
    s.skill_id,
    s.skills AS skill_name,
    count(sk.skill_id) AS demand_count
FROM
    job_postings_fact AS j
INNER JOIN skills_job_dim AS sk ON j.job_id = sk.job_id 
INNER JOIN skills_dim AS s ON sk.skill_id = s.skill_id  
WHERE
    j.job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND skills IS NOT NULL  
GROUP BY
    s.skill_id
), average_salaries_p_skill AS (
SELECT
    s.skill_id,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact AS j
INNER JOIN skills_job_dim AS sk ON j.job_id = sk.job_id 
INNER JOIN skills_dim AS s ON sk.skill_id = s.skill_id  
WHERE
    j.job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL  
GROUP BY
    s.skill_id
)
SELECT
    skills_demand.skill_id,
    skills_demand.skill_name,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN average_salaries_p_skill AS avg_sal ON skills_demand.skill_id = avg_sal.skill_id 
ORDER BY
    demand_count DESC
LIMIT 10;