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

-- explanation
-- Sort  (cost=10270.76..10270.80 rows=16 width=13)
--   Sort Key: (count(*)) DESC
--   ->  Finalize GroupAggregate  (cost=10261.09..10270.44 rows=16 width=13)
--         Group Key: air_force
--         ->  Gather Merge  (cost=10261.09..10270.12 rows=32 width=13)
--               Workers Planned: 2
--               ->  Partial GroupAggregate  (cost=9261.06..9266.41 rows=16 width=13)
--                     Group Key: air_force
--                     ->  Sort  (cost=9261.06..9262.79 rows=691 width=5)
--                           Sort Key: air_force
--                           ->  Parallel Seq Scan on mission  (cost=0.00..9228.48 rows=691 width=5)
--                                 Filter: (EXTRACT(year FROM mission_date) = '1945'::numeric)

EXPLAIN ANALYZE
SELECT air_force, COUNT(*) AS active_missions
FROM mission
WHERE EXTRACT(YEAR FROM mission_date) = 1945
GROUP BY air_force
ORDER BY active_missions DESC;

-- explanation with analyze
-- Sort  (cost=10997.70..10997.74 rows=16 width=13) (actual time=78.696..78.779 rows=14 loops=1)
--   Sort Key: (count(*)) DESC
--   Sort Method: quicksort  Memory: 25kB
--   ->  Finalize GroupAggregate  (cost=10987.61..10997.38 rows=16 width=13) (actual time=72.374..78.748 rows=14 loops=1)
--         Group Key: air_force
--         ->  Gather Merge  (cost=10987.61..10997.06 rows=32 width=13) (actual time=72.358..78.716 rows=42 loops=1)
--               Workers Planned: 2
--               Workers Launched: 2
--               ->  Partial GroupAggregate  (cost=9987.59..9993.34 rows=16 width=13) (actual time=31.810..34.482 rows=14 loops=3)
--                     Group Key: air_force
--                     ->  Sort  (cost=9987.59..9989.45 rows=745 width=5) (actual time=31.682..32.639 rows=17136 loops=3)
--                           Sort Key: air_force
--                           Sort Method: quicksort  Memory: 1022kB
--                           Worker 0:  Sort Method: quicksort  Memory: 509kB
--                           Worker 1:  Sort Method: quicksort  Memory: 545kB
--                           ->  Parallel Seq Scan on mission  (cost=0.00..9952.05 rows=745 width=5) (actual time=0.323..27.233 rows=17136 loops=3)
--                                 Filter: (EXTRACT(year FROM mission_date) = '1945'::numeric)
--                                 Rows Removed by Filter: 42291
-- Planning Time: 0.781 ms
-- Execution Time: 79.027 ms
