
SELECT
    tm.department,
    ROUND(AVG(t.resolution_hours), 2) AS avg_resolution_hours
FROM tickets AS t
JOIN teams AS tm
    ON t.team_id = tm.team_id
GROUP BY tm.department
ORDER BY avg_resolution_hours DESC;




SELECT
    tm.team,
    ROUND(AVG(t.resolution_hours), 2) AS avg_resolution_hours
FROM tickets AS t
JOIN teams AS tm
    ON t.team_id = tm.team_id
GROUP BY tm.team_id, tm.team
HAVING AVG(t.resolution_hours) > 24
ORDER BY avg_resolution_hours DESC;




SELECT
    t.channel,
    COUNT(*) AS breach_count
FROM tickets AS t
WHERE t.resolution_hours > 24
GROUP BY t.channel
ORDER BY breach_count DESC, t.channel ASC
LIMIT 2;




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
