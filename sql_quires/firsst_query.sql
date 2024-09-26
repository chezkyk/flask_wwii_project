SELECT air_force, COUNT(*) AS active_missions
FROM mission
WHERE EXTRACT(YEAR FROM mission_date) = 1945
GROUP BY air_force
ORDER BY active_missions DESC;