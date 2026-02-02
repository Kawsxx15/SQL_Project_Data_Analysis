SELECT DISTINCT
    c.name AS company_name,
    c.company_id
FROM (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
) AS no_degree_jobs
JOIN company_dim c
    ON no_degree_jobs.company_id = c.company_id
order BY c.company_id;