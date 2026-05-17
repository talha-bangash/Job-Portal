-- ============================================================
-- Job Portal with Intelligent Filtering
-- MySQL Schema v2.0
-- ============================================================

CREATE DATABASE IF NOT EXISTS jobportal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE jobportal;

-- ============================================================
-- 1. USERS — Central Authentication & Identity Store
-- ============================================================
CREATE TABLE IF NOT EXISTS USERS (
    UserID       INT AUTO_INCREMENT PRIMARY KEY,
    Name         VARCHAR(100)  NOT NULL,
    Email        VARCHAR(150)  NOT NULL UNIQUE,
    PasswordHash VARCHAR(255)  NOT NULL,
    Role         ENUM('JobSeeker','Employer','Admin') NOT NULL,
    CreatedAt    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- 2. COMPANIES — Employer Organizational Profiles
-- ============================================================
CREATE TABLE IF NOT EXISTS COMPANIES (
    CompanyID            INT AUTO_INCREMENT PRIMARY KEY,
    Name                 VARCHAR(150) NOT NULL,
    Industry             VARCHAR(100) NOT NULL,
    HeadquartersLocation VARCHAR(150) NOT NULL,
    ContactEmail         VARCHAR(150) NOT NULL,
    UserID               INT          NOT NULL,
    CONSTRAINT fk_companies_user FOREIGN KEY (UserID) REFERENCES USERS(UserID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 3. APPLICANTS — Job Seeker Extended Profiles
-- ============================================================
CREATE TABLE IF NOT EXISTS APPLICANTS (
    ApplicantID     INT AUTO_INCREMENT PRIMARY KEY,
    UserID          INT          NOT NULL UNIQUE,
    ResumeURL       VARCHAR(500) NULL,
    ExperienceYears INT          NOT NULL DEFAULT 0,
    Bio             TEXT         NULL,
    Gender          ENUM('Male','Female','Other','Prefer not to say') NULL,
    University      VARCHAR(200) NULL,
    CONSTRAINT fk_applicants_user FOREIGN KEY (UserID) REFERENCES USERS(UserID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 4. SKILLS — Canonical Skill Repository
-- ============================================================
CREATE TABLE IF NOT EXISTS SKILLS (
    SkillID   INT AUTO_INCREMENT PRIMARY KEY,
    SkillName VARCHAR(100) NOT NULL UNIQUE,
    Category  ENUM('Programming','Data Science','Design','Management',
                   'Soft Skills','DevOps','Database','Networking','Other') NOT NULL
) ENGINE=InnoDB;

-- ============================================================
-- 5. JOBS — Primary Listing Entity
-- ============================================================
CREATE TABLE IF NOT EXISTS JOBS (
    JobID        INT AUTO_INCREMENT PRIMARY KEY,
    Title        VARCHAR(200)   NOT NULL,
    Description  TEXT           NOT NULL,
    CompanyID    INT            NOT NULL,
    WorkLocation VARCHAR(150)   NOT NULL,
    Salary       DECIMAL(10,2)  NULL,
    Deadline     DATE           NOT NULL,
    Status       ENUM('Open','Closed','Draft') NOT NULL DEFAULT 'Draft',
    CONSTRAINT fk_jobs_company FOREIGN KEY (CompanyID) REFERENCES COMPANIES(CompanyID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 6. JOB_SKILLS — Job-to-Skill Junction Table
-- ============================================================
CREATE TABLE IF NOT EXISTS JOB_SKILLS (
    JobSkillID       INT AUTO_INCREMENT PRIMARY KEY,
    JobID            INT NOT NULL,
    SkillID          INT NOT NULL,
    RequirementLevel ENUM('Beginner','Intermediate','Expert') NOT NULL,
    UNIQUE KEY uq_job_skill (JobID, SkillID),
    CONSTRAINT fk_jobskills_job   FOREIGN KEY (JobID)   REFERENCES JOBS(JobID)   ON DELETE CASCADE,
    CONSTRAINT fk_jobskills_skill FOREIGN KEY (SkillID) REFERENCES SKILLS(SkillID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 7. APPLICANT_SKILLS — Applicant-to-Skill Junction Table
-- ============================================================
CREATE TABLE IF NOT EXISTS APPLICANT_SKILLS (
    AppSkillID      INT AUTO_INCREMENT PRIMARY KEY,
    ApplicantID     INT NOT NULL,
    SkillID         INT NOT NULL,
    ProficiencyLevel ENUM('Beginner','Intermediate','Expert') NOT NULL,
    UNIQUE KEY uq_applicant_skill (ApplicantID, SkillID),
    CONSTRAINT fk_appskills_applicant FOREIGN KEY (ApplicantID) REFERENCES APPLICANTS(ApplicantID) ON DELETE CASCADE,
    CONSTRAINT fk_appskills_skill     FOREIGN KEY (SkillID)     REFERENCES SKILLS(SkillID)         ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 8. APPLICATIONS — Core Transactional Table
-- ============================================================
CREATE TABLE IF NOT EXISTS APPLICATIONS (
    AppID       INT AUTO_INCREMENT PRIMARY KEY,
    ApplicantID INT  NOT NULL,
    JobID       INT  NOT NULL,
    AppliedDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    Status      ENUM('Applied','Shortlisted','Rejected','Hired') NOT NULL DEFAULT 'Applied',
    UNIQUE KEY uq_application (ApplicantID, JobID),
    CONSTRAINT fk_apps_applicant FOREIGN KEY (ApplicantID) REFERENCES APPLICANTS(ApplicantID) ON DELETE CASCADE,
    CONSTRAINT fk_apps_job       FOREIGN KEY (JobID)       REFERENCES JOBS(JobID)             ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 9. INTERVIEWS — Application Lifecycle Extension
-- ============================================================
CREATE TABLE IF NOT EXISTS INTERVIEWS (
    InterviewID   INT AUTO_INCREMENT PRIMARY KEY,
    AppID         INT      NOT NULL UNIQUE,
    ScheduledDate DATETIME NOT NULL,
    Mode          ENUM('Online','Onsite') NOT NULL,
    Result        ENUM('Pending','Passed','Failed') NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_interviews_app FOREIGN KEY (AppID) REFERENCES APPLICATIONS(AppID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- SEED DATA — Skills Master Table
-- ============================================================
INSERT IGNORE INTO SKILLS (SkillName, Category) VALUES
('Python',           'Programming'),
('JavaScript',       'Programming'),
('Java',             'Programming'),
('C++',              'Programming'),
('SQL',              'Database'),
('MySQL',            'Database'),
('PostgreSQL',       'Database'),
('MongoDB',          'Database'),
('React',            'Programming'),
('Node.js',          'Programming'),
('Flask',            'Programming'),
('Django',           'Programming'),
('HTML/CSS',         'Design'),
('Figma',            'Design'),
('UI/UX Design',     'Design'),
('Machine Learning', 'Data Science'),
('Data Analysis',    'Data Science'),
('Power BI',         'Data Science'),
('Tableau',          'Data Science'),
('Docker',           'DevOps'),
('Kubernetes',       'DevOps'),
('AWS',              'DevOps'),
('Azure',            'DevOps'),
('Git',              'DevOps'),
('Linux',            'Networking'),
('Networking',       'Networking'),
('Project Management','Management'),
('Agile/Scrum',      'Management'),
('Leadership',       'Soft Skills'),
('Communication',    'Soft Skills'),
('Problem Solving',  'Soft Skills'),
('Teamwork',         'Soft Skills');

-- ============================================================
-- SEED DATA — Admin User (password: Admin@123)
-- ============================================================
INSERT IGNORE INTO USERS (Name, Email, PasswordHash, Role) VALUES
('Admin', 'admin@jobportal.com',
 'pbkdf2:sha256:260000$rQmhKQMa$c6e8a14a0d3e5f7b2c9d8e1f4a7b0c3d6e9f2a5b8c1d4e7f0a3b6c9d2e5f8a1b4',
 'Admin');
