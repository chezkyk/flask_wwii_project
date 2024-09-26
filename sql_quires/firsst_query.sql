SELECT air_force, COUNT(*) AS active_missions
FROM mission
WHERE EXTRACT(YEAR FROM mission_date) = 1945
GROUP BY air_force
ORDER BY active_missions DESC;

EXPLAIN
SELECT air_force, COUNT(*) AS active_missions
FROM mission
WHERE EXTRACT(YEAR FROM mission_date) = 1945
GROUP BY air_force
ORDER BY active_missions DESC;

-- Sort  (cost=10.04..10.04 rows=1 width=226)
--   Sort Key: (count(*)) DESC
--   ->  GroupAggregate  (cost=10.01..10.03 rows=1 width=226)
--         Group Key: air_force
--         ->  Sort  (cost=10.01..10.02 rows=1 width=218)
--               Sort Key: air_force
--               ->  Seq Scan on mission2  (cost=0.00..10.00 rows=1 width=218)
--                     Filter: (EXTRACT(year FROM mission_date) = '1945'::numeric)


EXPLAIN ANALYZE
SELECT air_force, COUNT(*) AS active_missions
FROM mission
WHERE EXTRACT(YEAR FROM mission_date) = 1945
GROUP BY air_force
ORDER BY active_missions DESC;

-- Sort  (cost=10.04..10.04 rows=1 width=226) (actual time=0.026..0.026 rows=0 loops=1)
--   Sort Key: (count(*)) DESC
--   Sort Method: quicksort  Memory: 25kB
--   ->  GroupAggregate  (cost=10.01..10.03 rows=1 width=226) (actual time=0.017..0.018 rows=0 loops=1)
--         Group Key: air_force
--         ->  Sort  (cost=10.01..10.02 rows=1 width=218) (actual time=0.017..0.017 rows=0 loops=1)
--               Sort Key: air_force
--               Sort Method: quicksort  Memory: 25kB
--               ->  Seq Scan on mission2  (cost=0.00..10.00 rows=1 width=218) (actual time=0.010..0.010 rows=0 loops=1)
--                     Filter: (EXTRACT(year FROM mission_date) = '1945'::numeric)
-- Planning Time: 0.160 ms
-- Execution Time: 0.050 ms


CREATE INDEX idx_mission_date_year ON mission (EXTRACT(YEAR FROM mission_date));

-- Sort  (cost=8.18..8.19 rows=1 width=226) (actual time=0.012..0.012 rows=0 loops=1)
--   Sort Key: (count(*)) DESC
--   Sort Method: quicksort  Memory: 25kB
--   ->  GroupAggregate  (cost=8.15..8.17 rows=1 width=226) (actual time=0.010..0.010 rows=0 loops=1)
--         Group Key: air_force
--         ->  Sort  (cost=8.15..8.16 rows=1 width=218) (actual time=0.009..0.009 rows=0 loops=1)
--               Sort Key: air_force
--               Sort Method: quicksort  Memory: 25kB
--               ->  Index Scan using iidx_mission_date_year on mission2  (cost=0.12..8.14 rows=1 width=218) (actual time=0.006..0.006 rows=0 loops=1)
--                     Index Cond: (EXTRACT(year FROM mission_date) = '1945'::numeric)
-- Planning Time: 1.101 ms
-- Execution Time: 0.031 ms

--מסקנה לא שווה לעשות אינדקס כי עם אינדקס זה לוקח יותר זמן
