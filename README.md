# Job Portal with Intelligent Filtering

A web-based recruitment platform that matches job seekers to jobs using SQL-based skill scoring.

**Team:** Talha Muhammad Bangash & Aleena Rafiq | **BCS Group A** | **Database Systems Lab 2025–26**  
**Stack:** Python (Flask) · SQLite · HTML/CSS · JavaScript

---

## Getting Started

```bash
pip install flask werkzeug
python app.py
```

Open **http://127.0.0.1:5000** — the database is created automatically on first run.

**Demo accounts**

| Role | Email | Password |
|---|---|---|
| 👤 Job Seeker | `seeker@demo.com` | `demo123` |
| 🏢 Employer | `employer@demo.com` | `demo123` |
| 🔧 Admin | `admin@jobportal.com` | `admin123` |

---

## What It Does

**Job Seekers** build a skill profile, browse jobs with a live match score, apply in one click, and track application status (Applied → Shortlisted → Hired).

**Employers** post jobs with required skills, view applicants ranked by match score, update pipeline status, schedule interviews, and view a hiring analytics dashboard.

**Admins** manage users, toggle job listings, and maintain the skills master list.

### Skill Match Formula
```
Match Score = (skills applicant HAS ÷ skills job REQUIRES) × 100
```
Computed dynamically via SQL at request time — always up to date.

---

## Scope In ✅

- Role-based registration & login (Seeker / Employer / Admin)
- Applicant profiles with skills and proficiency levels
- Job posting with required/preferred skills
- Intelligent SQL skill-match scoring
- Job search — filter by keyword, location, type, and skill
- Application submission with cover letter
- Application status tracking with visual pipeline
- Employer applicant management sorted by match score
- Interview scheduling (date, mode, notes)
- Admin panel — users, jobs, skills master list
- Analytics dashboard — applications, skill demand, hiring funnel
- Normalized 3NF relational schema with foreign keys and constraints

## Scope Out ❌

- Mobile app (web only)
- AI / ML matching (rule-based SQL only)
- Resume file upload and parsing
- Email notifications
- Payment or subscription features
- Third-party integrations (LinkedIn, Rozee.pk)
- OAuth / social login
- Real-time updates (WebSockets)

---

## Database

9-table normalized schema: `users` · `companies` · `applicants` · `skills` · `jobs` · `job_skills` · `applicant_skills` · `applications` · `interviews`

Key constraints: `UNIQUE(applicant_id, job_id)` · `FOREIGN KEY ON DELETE CASCADE` · `CHECK` on all status fields
