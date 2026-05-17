-- ============================================================
-- Talent Bridge Job Portal
-- Milestone 5: DML and Data Validation
-- data_operations.sql  |  Self-contained (no external CSV files)
-- ============================================================


-- =========================================================
-- SECTION 1: DATABASE INITIALIZATION
-- =========================================================

USE jobportal;


-- =========================================================
-- SECTION 2: DATA LOADING (INSERT STATEMENTS)
-- =========================================================

-- ------------------------------------------------------------
-- 2.1  USERS  (3 Employers + 4 Job Seekers; Admin already seeded by schema)
-- ------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE USERS;
TRUNCATE TABLE COMPANIES;
TRUNCATE TABLE APPLICANTS;



SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO USERS (UserID, Name, Email, PasswordHash, Role, CreatedAt) VALUES
(1, 'Aisha Rahman',  'aishha@nexatech.io',      'hash_aisha_001',  'Employer',  '2024-10-01 09:00:00'),
(2, 'Marcus Cole',   'marcujs@greenbridge.com', 'hash_marcus_002', 'Employer',  '2024-10-03 10:30:00'),
(3, 'Priya Menon',   'priya7@cloudworks.io',    'hash_priya_003',  'Employer',  '2024-10-05 11:00:00'),
(4, 'Daniel Osei',   'daniel.osei8@gmail.com',  'hash_daniel_004', 'JobSeeker', '2024-10-10 08:15:00'),
(5, 'Sofia Alves',   'sofia.alves9@gmail.com',  'hash_sofia_005',  'JobSeeker', '2024-10-11 09:45:00'),
(6, 'Liam Nguyen',   'liam.nguyen9@gmail.com',  'hash_liam_006',   'JobSeeker', '2024-10-12 14:00:00'),
(7, 'Fatima Zahra',  'fatima.zahra5@gmail.com', 'hash_fatima_007', 'JobSeeker', '2024-10-14 16:30:00');

-- ------------------------------------------------------------
-- 2.2  COMPANIES  (one per Employer user)
-- ------------------------------------------------------------
INSERT INTO COMPANIES (CompanyID, Name, Industry, HeadquartersLocation, ContactEmail, UserID) VALUES
(5, 'NexaTech Solutions', 'Information Technology', 'San Francisco, CA', 'hr@nexatech.io',       2),
(4, 'GreenBridge Corp',   'Renewable Energy',       'Austin, TX',        'jobs@greenbridge.com', 3),
(3, 'CloudWorks Inc',     'Cloud Computing',        'Seattle, WA',       'talent@cloudworks.io', 4);

-- ------------------------------------------------------------
-- 2.3  APPLICANTS  (one per Job Seeker user)
-- ------------------------------------------------------------
INSERT INTO APPLICANTS (ApplicantID, UserID, ResumeURL, ExperienceYears, Bio, Gender, University) VALUES
(4, 5, 'https://cdn.talentbridge.io/resumes/daniel_osei.pdf', 3, 'Full-stack developer with a passion for clean APIs.',        'Male',   'University of Ghana'),
(2, 6, 'https://cdn.talentbridge.io/resumes/sofia_alves.pdf', 5, 'Data scientist specialising in predictive modelling.',      'Female', 'University of Sao Paulo'),
(3, 7, 'https://cdn.talentbridge.io/resumes/liam_nguyen.pdf', 2, 'Junior DevOps engineer eager to automate everything.',      'Male',   'Oregon State University'),
(4, 8, NULL,                                                   1, 'Recent design graduate with a strong UI/UX portfolio.',    'Female', 'American University of Beirut');

-- ------------------------------------------------------------
-- 2.4  JOBS  (4 open + 1 closed position across the 3 companies)
-- Note: SKILLS seed rows already exist from schema.sql (SkillID 1-32)
-- ------------------------------------------------------------
INSERT INTO JOBS (JobID, Title, Description, CompanyID, WorkLocation, Salary, Deadline, Status) VALUES
(1, 'Backend Python Developer', 'Build and maintain RESTful APIs using Flask and PostgreSQL.',       1, 'Remote',           85000.00, '2025-08-31', 'Open'),
(2, 'Data Scientist',           'Develop ML models to optimise energy consumption forecasting.',     2, 'Austin, TX',       92000.00, '2025-07-15', 'Open'),
(3, 'DevOps Engineer',          'Manage CI/CD pipelines and Kubernetes clusters on AWS.',            3, 'Seattle, WA',      98000.00, '2025-09-01', 'Open'),
(4, 'UI/UX Designer',           'Design intuitive interfaces for our SaaS dashboard product.',       1, 'San Francisco, CA',75000.00, '2025-07-30', 'Open'),
(5, 'Junior Data Analyst',      'Support the analytics team with reporting and data visualisation.', 2, 'Remote',           58000.00, '2025-06-30', 'Closed');

-- ------------------------------------------------------------
-- 2.5  JOB_SKILLS  (skills required per job)
-- SkillID ref: 1=Python, 5=SQL, 9=React, 14=Figma, 15=UI/UX Design,
--              16=Machine Learning, 17=Data Analysis, 18=Power BI,
--              20=Docker, 21=Kubernetes, 22=AWS
-- ------------------------------------------------------------
INSERT INTO JOB_SKILLS (JobID, SkillID, RequirementLevel) VALUES
(1, 1,  'Expert'),        -- Backend Python Dev  -> Python
(1, 5,  'Intermediate'),  -- Backend Python Dev  -> SQL
(2, 16, 'Expert'),        -- Data Scientist      -> Machine Learning
(2, 17, 'Intermediate'),  -- Data Scientist      -> Data Analysis
(3, 21, 'Expert'),        -- DevOps Engineer     -> Kubernetes
(3, 22, 'Intermediate'),  -- DevOps Engineer     -> AWS
(3, 20, 'Intermediate'),  -- DevOps Engineer     -> Docker
(4, 14, 'Expert'),        -- UI/UX Designer      -> Figma
(4, 15, 'Expert'),        -- UI/UX Designer      -> UI/UX Design
(5, 17, 'Beginner'),      -- Junior Data Analyst -> Data Analysis
(5, 18, 'Beginner');      -- Junior Data Analyst -> Power BI

-- ------------------------------------------------------------
-- 2.6  APPLICANT_SKILLS  (skills each applicant possesses)
-- ------------------------------------------------------------
INSERT INTO APPLICANT_SKILLS (ApplicantID, SkillID, ProficiencyLevel) VALUES
(1, 1,  'Expert'),        -- Daniel  -> Python
(1, 5,  'Intermediate'),  -- Daniel  -> SQL
(1, 9,  'Intermediate'),  -- Daniel  -> React
(2, 16, 'Expert'),        -- Sofia   -> Machine Learning
(2, 17, 'Expert'),        -- Sofia   -> Data Analysis
(2, 18, 'Intermediate'),  -- Sofia   -> Power BI
(3, 20, 'Intermediate'),  -- Liam    -> Docker
(3, 22, 'Beginner'),      -- Liam    -> AWS
(3, 21, 'Beginner'),      -- Liam    -> Kubernetes
(4, 14, 'Expert'),        -- Fatima  -> Figma
(4, 15, 'Intermediate');  -- Fatima  -> UI/UX Design

-- ------------------------------------------------------------
-- 2.7  APPLICATIONS  (who applied to which job)
-- ------------------------------------------------------------
INSERT INTO APPLICATIONS (AppID, ApplicantID, JobID, AppliedDate, Status) VALUES
(1, 1, 1, '2024-11-01', 'Shortlisted'),  -- Daniel  -> Backend Python Developer
(2, 2, 2, '2024-11-03', 'Applied'),      -- Sofia   -> Data Scientist
(3, 3, 3, '2024-11-05', 'Applied'),      -- Liam    -> DevOps Engineer
(4, 4, 4, '2024-11-06', 'Applied'),      -- Fatima  -> UI/UX Designer
(5, 2, 5, '2024-10-20', 'Rejected');     -- Sofia   -> Junior Data Analyst (closed role)

-- ------------------------------------------------------------
-- 2.8  INTERVIEWS  (only progressed applications get an interview)
-- ------------------------------------------------------------
INSERT INTO INTERVIEWS (InterviewID, AppID, ScheduledDate, Mode, Result) VALUES
(1, 1, '2024-11-15 10:00:00', 'Online', 'Passed');  -- Daniel's interview for Backend Python Dev


-- =========================================================
-- SECTION 3: DML OPERATIONS (UPDATE & DELETE)
-- =========================================================

-- UPDATE: The DevOps Engineer role (JobID 3) received budget approval;
--         salary revised upward before the listing goes live on the public feed.
UPDATE JOBS
SET    Salary = 110000.00
WHERE  JobID = 3
  AND  Status = 'Open';

-- DELETE: Remove Sofia's rejected application for the now-closed Junior Data
--         Analyst role (AppID 5). No INTERVIEWS row exists for AppID 5,
--         so the delete is safe with no cascade side-effects.
DELETE FROM APPLICATIONS
WHERE  AppID = 5
  AND  Status = 'Rejected';


-- =========================================================
-- SECTION 4: COMPLEX ANALYTICAL QUERIES & VIEWS
-- =========================================================

-- GROUP BY: Total applications received per job, with company context.
-- Helps employers quickly see which listings are attracting the most candidates.
SELECT   j.JobID,
         j.Title           AS JobTitle,
         c.Name            AS CompanyName,
         COUNT(a.AppID)    AS TotalApplications
FROM     JOBS          j
JOIN     COMPANIES     c ON j.CompanyID = c.CompanyID
LEFT JOIN APPLICATIONS a ON j.JobID     = a.JobID
GROUP BY j.JobID, j.Title, c.Name
ORDER BY TotalApplications DESC;

-- VIEW: vw_job_feed
-- Powers the public job listing page and employer dashboard.
-- Joins JOBS -> COMPANIES so Flask routes can query a single object.
CREATE OR REPLACE VIEW vw_job_feed AS
SELECT j.JobID,
       j.Title,
       j.WorkLocation,
       j.Salary,
       j.Deadline,
       j.Status,
       c.Name                 AS CompanyName,
       c.Industry,
       c.HeadquartersLocation AS CompanyHQ,
       c.ContactEmail         AS CompanyContact
FROM   JOBS      j
JOIN   COMPANIES c ON j.CompanyID = c.CompanyID;


-- =========================================================
-- SECTION 5: VALIDATION & INTEGRITY CHECKS
-- =========================================================

-- 5a. Row counts for every table — confirms all inserts landed correctly.
SELECT 'USERS'            AS TableName, COUNT(*) AS RowCount FROM USERS
UNION ALL
SELECT 'COMPANIES',                     COUNT(*)             FROM COMPANIES
UNION ALL
SELECT 'APPLICANTS',                    COUNT(*)             FROM APPLICANTS
UNION ALL
SELECT 'SKILLS',                        COUNT(*)             FROM SKILLS
UNION ALL
SELECT 'JOBS',                          COUNT(*)             FROM JOBS
UNION ALL
SELECT 'JOB_SKILLS',                    COUNT(*)             FROM JOB_SKILLS
UNION ALL
SELECT 'APPLICANT_SKILLS',              COUNT(*)             FROM APPLICANT_SKILLS
UNION ALL
SELECT 'APPLICATIONS',                  COUNT(*)             FROM APPLICATIONS
UNION ALL
SELECT 'INTERVIEWS',                    COUNT(*)             FROM INTERVIEWS;

-- 5b. NULL check — surface applicant profiles missing a resume URL.
--     NULL is schema-allowed, but flags incomplete profiles for follow-up.
SELECT ApplicantID,
       UserID,
       'ResumeURL is NULL — profile incomplete' AS ValidationNote
FROM   APPLICANTS
WHERE  ResumeURL IS NULL;

-- 5c. Foreign key integrity check — verify every job has a valid parent company.
--     A healthy database returns zero rows from this query.
SELECT j.JobID,
       j.Title,
       j.CompanyID AS OrphanedCompanyID
FROM   JOBS      j
LEFT   JOIN COMPANIES c ON j.CompanyID = c.CompanyID
WHERE  c.CompanyID IS NULL;


SELECT * FROM USERS;
