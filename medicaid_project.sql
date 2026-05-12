-----Medicaid Enrollment Consulting Project-----

--CREATE TABLES--
CREATE TABLE members (
    member_id INT,
    age INT,
    gender VARCHAR(5),
    county VARCHAR(50),
    eligibility_group VARCHAR(50),
    race_ethnicity VARCHAR(50)
);
CREATE TABLE enrollment (
    member_id INT,
    enrollment_start DATE,
    enrollment_end DATE,
    plan_type VARCHAR(20)
);
CREATE TABLE cms_summary (
    state VARCHAR(10),
    total_enrollment INT,
    total_pct_change DECIMAL,
    medicaid_enrollment INT,
    medicaid_pct_change DECIMAL,
    chip_enrollment INT,
    chip_pct_change DECIMAL
);
---Verify that csv data imported successfully---
SELECT * FROM members;
SELECT * FROM enrollment;
SELECT * FROM cms_summary;

--------ANALYSIS-------

--Enrollment by Eligbility Group--
SELECT 
    eligibility_group,
    COUNT(*) AS total_members
FROM members
GROUP BY eligibility_group
ORDER BY total_members DESC;

--County Distribution--
SELECT 
    county,
    COUNT(*) AS total_members
FROM members
GROUP BY county
ORDER BY total_members DESC;

--Medicaid vs. CHIP Composition--
SELECT 
    plan_type,
    COUNT(*) AS total_enrollments
FROM enrollment
GROUP BY plan_type;

--Coverage Churn--
SELECT 
    member_id,
    COUNT(*) AS enrollment_periods
FROM enrollment
GROUP BY member_id
HAVING COUNT(*) > 1
ORDER BY enrollment_periods DESC;

--Average Enrollment Duration--
SELECT 
    AVG(enrollment_end - enrollment_start) AS avg_days_enrolled
FROM enrollment;

--Enrollment by Eligibility Group + Plan Type--
SELECT 
    m.eligibility_group,
    e.plan_type,
    COUNT(*) AS total_enrollments
FROM members m
JOIN enrollment e
    ON m.member_id = e.member_id
GROUP BY m.eligibility_group, e.plan_type
ORDER BY total_enrollments DESC;

--Average Enrollment Duration by Eligibility Group--
SELECT 
    m.eligibility_group,
    AVG(e.enrollment_end - e.enrollment_start) AS avg_days_enrolled
FROM members m
JOIN enrollment e
    ON m.member_id = e.member_id
GROUP BY m.eligibility_group
ORDER BY avg_days_enrolled DESC;

--Churn by Eligibility Group--
SELECT 
    m.eligibility_group,
    COUNT(DISTINCT e.member_id) AS churned_members
FROM members m
JOIN enrollment e
    ON m.member_id = e.member_id
GROUP BY m.eligibility_group
HAVING COUNT(e.member_id) > COUNT(DISTINCT e.member_id)
ORDER BY churned_members DESC;