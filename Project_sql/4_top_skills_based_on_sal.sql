/*
Objective: Retrieve the top 25 skills for 'Data Analyst' positions based on average yearly salary.
*/
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact AS j
INNER JOIN skills_job_dim AS sk ON j.job_id = sk.job_id 
INNER JOIN skills_dim AS s ON sk.skill_id = s.skill_id  
WHERE
    j.job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL  
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;