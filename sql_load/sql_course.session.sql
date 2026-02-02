SELECT
    j.job_title_short,
    s.skills AS skill_name,
    s.type AS skill_type
FROM january_jobs_new AS j
LEFT JOIN skills_job_dim AS skills_to_job ON j.job_id = skills_to_job.job_id
LEFT JOIN skills_dim AS s ON skills_to_job.skill_id = s.skill_id
WHERE j.salary_year_avg > 70000

UNION ALL

SELECT
    f.job_title_short,
    s.skills AS skill_name,
    s.type AS skill_type
FROM febuary_jobs_new AS f
LEFT JOIN skills_job_dim AS skills_to_job ON f.job_id = skills_to_job.job_id
LEFT JOIN skills_dim AS s ON skills_to_job.skill_id = s.skill_id
WHERE f.salary_year_avg > 70000

UNION ALL

SELECT
    m.job_title_short,
    s.skills AS skill_name,
    s.type AS skill_type
FROM march_jobs_new AS m
LEFT JOIN skills_job_dim AS skills_to_job ON m.job_id = skills_to_job.job_id
LEFT JOIN skills_dim AS s ON skills_to_job.skill_id = s.skill_id
WHERE m.salary_year_avg > 70000;
