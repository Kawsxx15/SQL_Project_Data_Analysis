/* Question 1:
What are the top paying data analyst jobs?
- identify the top 10 highest paying data analyst job roles that are available remotely.
-Focuses on job postings with specified salaries (remove null)
*/

SELECT
    job_id,
    job_title_short,
    c.name AS company_name,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
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
LIMIT 10;