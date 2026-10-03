-- Practical Exam — Data Analysis (Set B)
-- SQL Dialect: PostgreSQL
-- Version: PostgreSQL 16.x
-- Run order: S2a, S2b, S2c, then S3 diagnostic.
-- S3 diagnostic is included after the three required analytical queries.

-- S2a — Average resolution time by department
-- Join tickets to teams and order by average resolution_hours descending.
SELECT
    tm.department,
    ROUND(AVG(t.resolution_hours), 2) AS avg_resolution_hours
FROM tickets AS t
JOIN teams AS tm
    ON t.team_id = tm.team_id
GROUP BY tm.department
ORDER BY avg_resolution_hours DESC;

-- S2b — Teams breaching SLA
-- Return teams whose average resolution time exceeds 24 hours.
SELECT
    tm.team,
    ROUND(AVG(t.resolution_hours), 2) AS avg_resolution_hours
FROM tickets AS t
JOIN teams AS tm
    ON t.team_id = tm.team_id
GROUP BY tm.team_id, tm.team
HAVING AVG(t.resolution_hours) > 24
ORDER BY avg_resolution_hours DESC;

-- S2c — Top two channels by breach count
-- A breach is resolution_hours > 24.
-- Alphabetical channel order is used to break ties.
SELECT
    t.channel,
    COUNT(*) AS breach_count
FROM tickets AS t
WHERE t.resolution_hours > 24
GROUP BY t.channel
ORDER BY breach_count DESC, t.channel ASC
LIMIT 2;

-- S3 — Diagnostic data-integrity check
-- LEFT JOIN from teams to tickets. Any team with zero unmatched tickets
-- is confirmed by unmatched_ticket_count = 0.
SELECT
    tm.team_id,
    tm.team,
    tm.department,
    COUNT(t.ticket_id) AS matched_ticket_count,
    CASE
        WHEN COUNT(t.ticket_id) = 0 THEN 1
        ELSE 0
    END AS unmatched_team_flag
FROM teams AS tm
LEFT JOIN tickets AS t
    ON t.team_id = tm.team_id
GROUP BY tm.team_id, tm.team, tm.department
ORDER BY tm.team_id;
