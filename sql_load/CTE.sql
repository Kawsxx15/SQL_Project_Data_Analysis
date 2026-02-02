/*count of remote job skills per skill*/
WITH remote_job_skill AS (
SELECT 
    skill_id,
    COUNT(*) AS skil_count
FROM
    skills_job_dim
INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id 
WHERE
    job_postings_fact.job_work_from_home = TRUE
GROUP BY
    skill_id
)
SELECT 
    skills.skills,
    skills.skill_id,
    remote_job_skill.skil_count
FROM
    remote_job_skill
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skill.skill_id
ORDER BY
    remote_job_skill.skil_count DESC
LIMIT 5;