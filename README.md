### 📊 Data Analyst Job Market Analysis (2023)

## 1. Introduction

  - This project explores the 2023 Data Analyst job market using SQL to uncover insights about top-paying jobs, in-demand skills, and optimal skill combinations.

  - The goal is to understand what skills drive higher salaries and which tools are most valuable for aspiring data analysts, especially for remote roles.

  - The analysis is fully SQL-driven and structured into multiple focused queries, each answering a specific business question.

## 2. Background

The data used in this project comes from a dataset of data-related job postings in 2023, including information about:

  - Job titles and roles

  - Salaries (yearly and hourly)

  - Job locations (remote vs onsite)

  - Required skills

  - Companies posting the jobs

As the data analytics field becomes increasingly competitive, understanding which skills are most demanded and best compensated is crucial for career planning
and upskilling.

## 3. Tools I Have Used

This project was built using the following tools and technologies:

  - PostgreSQL – Core database used for querying and analysis

  - VS Code – Writing, organizing, and managing SQL files

  - Git & GitHub – Version control and project documentation

These tools together enabled efficient querying, experimentation, and reproducibility of the analysis.

## 4. The Analysis

The analysis is divided into five key SQL-driven sections, each represented by a separate SQL file:

### 1️⃣ Top Paying Jobs

Identified the highest-paying Data Analyst roles based on average yearly salary, with a focus on remote positions.

### Key questions answered:

  - What are the top-paying Data Analyst jobs?

```sql
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
```

### 2️⃣ Top Skills Needed for Top Paying Jobs

Analyzed the skills associated with the highest-paying jobs to understand what employers expect at the top end of the market.

### Key questions answered:

  - What are the top skills for remote Data Analyst ?
  ```sql 
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
```



### 3️⃣ Most In-Demand Skills

Focused on skill demand across all job postings, regardless of salary, to identify core skills required in the market.

### Key questions answered:

  - Which skills are most frequently requested?
```sql
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
```
### Result:
| Skill Name | Demand Count |
|-----------|--------------|
| SQL       | 92,628       |
| Excel     | 67,031       |
| Python    | 57,326       |
| Tableau   | 46,554       |
| Power BI  | 39,468       |


### 4️⃣ Top Skills Based on Salary

Combined salary data with skill data to determine which skills correlate with higher pay.

### Key questions answered:

  - Which skills are associated with higher average salaries?
  ```sql
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
```
### Result:
| Skill | Avg Salary (USD) |
|------|------------------|
| SVN | 400,000 |
| Solidity | 179,000 |
| Couchbase | 160,515 |
| DataRobot | 155,486 |
| Golang | 155,000 |
| MXNet | 149,000 |
| dplyr | 147,633 |
| VMware | 147,500 |
| Terraform | 146,734 |
| Twilio | 138,500 |
| GitLab | 134,126 |
| Kafka | 129,999 |
| Puppet | 129,820 |
| Keras | 127,013 |
| PyTorch | 125,226 |


### 5️⃣ Optimal Skills to Learn

Synthesized demand + salary insights to identify the best skills to learn that balance:

  - High demand

  - High salary potential
```sql
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
```
### Result:
| Skill Name | Demand Count | Avg Salary (USD) |
|-----------|--------------|------------------|
| SQL       | 3,083        | 96,435           |
| Excel     | 2,143        | 86,419           |
| Python    | 1,840        | 101,512          |
| Tableau   | 1,659        | 97,978           |
| R         | 1,073        | 98,708           |
| Power BI  | 1,044        | 92,324           |
| Word      | 527          | 82,941           |
| PowerPoint| 524          | 88,316           |
| SAS       | 500          | 93,707           |

This section provides actionable guidance for learning and career development.

## 5. What I Learned

Through this project, I significantly strengthened my SQL and data analysis skills, including:

  - CTEs (Common Table Expressions) for cleaner, modular queries

  - Subqueries for multi-step analytical logic

  - Advanced SQL concepts, such as:

  - CASE statements

  - UNION ALL

  - Aggregate functions with GROUP BY

  - Filtering with WHERE vs HAVING

### JOIN strategies:

  - INNER JOIN vs LEFT JOIN

  - Many-to-many relationships using bridge tables

  - PostgreSQL-specific syntax and best practices

I also learned how to translate business questions into SQL queries and structure an analysis like a real-world data project.

### 6. Conclusions

  - The analysis shows that top-paying Data Analyst roles in 2023 require more than basic reporting skills.

### 🔑 Key takeaways:

  - SQL and Python are non-negotiable core skills

  - BI tools like Tableau and Power BI remain highly valuable

  - Cloud platforms (Snowflake, AWS, Azure) significantly increase salary potential

  - High-paying analysts often work close to data engineering and analytics engineering teams
    
Overall, this project highlights that combining strong analytical foundations with modern data stack skills is the most effective path to higher-paying Data 
Analyst roles.
