/* Question 3
What are the most in-demand skills across all data analyst jobs?
*/

SELECT
    skills AS skill_name,
    count(*) AS demand_count
FROM
    job_postings_fact AS j
INNER JOIN skills_job_dim AS sk ON j.job_id = sk.job_id 
INNER JOIN skills_dim AS s ON sk.skill_id = s.skill_id  
WHERE
    j.job_title_short = 'Data Analyst'
    AND skills IS NOT NULL  
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;