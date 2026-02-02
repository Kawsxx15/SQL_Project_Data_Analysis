SELECT
    job_title_short,
    MAX(salary_year_avg) AS max_salary
FROM
    job_postings_fact
GROUP BY
    job_title_short
ORDER BY
    max_salary DESC;
