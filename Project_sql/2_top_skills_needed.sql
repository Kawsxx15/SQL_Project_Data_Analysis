/* Question 2:
What are the top skills needed for data analyst jobs?
-use top 10 data analyst jobs from previous query 
- identify the top 10 skills that are most frequently mentioned in remote data analyst job postings.
- Focuses on job postings with specified skills (remove null)
*/

WITH top_data_analyst_jobs_remote AS (
    SELECT
        job_id,
        job_title_short,
        c.name AS company_name,
        salary_year_avg,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'Onsite'
    END AS job_location_type 
    FROM
        job_postings_fact j
    LEFT JOIN company_dim c ON j.company_id = c.company_id

    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
)
SELECT 
    tda.*,
    s.skills AS skill_name
FROM top_data_analyst_jobs_remote tda
INNER JOIN skills_job_dim sk ON tda.job_id = sk.job_id  
INNER JOIN skills_dim s ON sk.skill_id = s.skill_id;


/* 🥇 Most in-demand skills

Skill	    Appearances	Insight
SQL	        8	Core skill — non-negotiable
Python	    7	Required for analysis + automation
Tableau	    6	Strong BI / visualization demand
R	        4	Still relevant at the high end

*/
