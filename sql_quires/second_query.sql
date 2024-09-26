select target_country ,bomb_damage_assessment, count(target_country) from mission
where bomb_damage_assessment is not null
and airborne_aircraft > 5
group by target_country, bomb_damage_assessment
order by count(bomb_damage_assessment) desc limit 1;

explain
select target_country ,bomb_damage_assessment, count(target_country) from mission
where bomb_damage_assessment is not null
and airborne_aircraft > 5
group by target_country, bomb_damage_assessment
order by count(bomb_damage_assessment) desc limit 1;

-- explanation
-- Limit  (cost=5777.16..5777.16 rows=1 width=43)
--   ->  Sort  (cost=5777.16..5777.22 rows=26 width=43)
--         Sort Key: (count(bomb_damage_assessment)) DESC
--         ->  Finalize GroupAggregate  (cost=5773.76..5777.03 rows=26 width=43)
-- "              Group Key: target_country, bomb_damage_assessment"
--               ->  Gather Merge  (cost=5773.76..5776.55 rows=22 width=43)
--                     Workers Planned: 2
--                     ->  Partial GroupAggregate  (cost=4773.74..4773.98 rows=11 width=43)
-- "                          Group Key: target_country, bomb_damage_assessment"
--                           ->  Sort  (cost=4773.74..4773.76 rows=11 width=27)
-- "                                Sort Key: target_country, bomb_damage_assessment"
--                                 ->  Parallel Seq Scan on mission  (cost=0.00..4773.55 rows=11 width=27)
--                                       Filter: ((bomb_damage_assessment IS NOT NULL) AND (airborne_aircraft > '5'::numeric))

explain analyse
select target_country ,bomb_damage_assessment, count(target_country) from mission
where bomb_damage_assessment is not null
and airborne_aircraft > 5
group by target_country, bomb_damage_assessment
order by count(bomb_damage_assessment) desc limit 1;

-- explanation with analyze
-- Limit  (cost=5777.16..5777.16 rows=1 width=43) (actual time=45.243..48.329 rows=1 loops=1)
--   ->  Sort  (cost=5777.16..5777.22 rows=26 width=43) (actual time=45.241..48.327 rows=1 loops=1)
--         Sort Key: (count(bomb_damage_assessment)) DESC
--         Sort Method: top-N heapsort  Memory: 25kB
--         ->  Finalize GroupAggregate  (cost=5773.76..5777.03 rows=26 width=43) (actual time=45.198..48.316 rows=21 loops=1)
-- "              Group Key: target_country, bomb_damage_assessment"
--               ->  Gather Merge  (cost=5773.76..5776.55 rows=22 width=43) (actual time=45.186..48.295 rows=21 loops=1)
--                     Workers Planned: 2
--                     Workers Launched: 2
--                     ->  Partial GroupAggregate  (cost=4773.74..4773.98 rows=11 width=43) (actual time=11.370..11.377 rows=7 loops=3)
-- "                          Group Key: target_country, bomb_damage_assessment"
--                           ->  Sort  (cost=4773.74..4773.76 rows=11 width=27) (actual time=11.367..11.369 rows=11 loops=3)
-- "                                Sort Key: target_country, bomb_damage_assessment"
--                                 Sort Method: quicksort  Memory: 27kB
--                                 Worker 0:  Sort Method: quicksort  Memory: 25kB
--                                 Worker 1:  Sort Method: quicksort  Memory: 25kB
--                                 ->  Parallel Seq Scan on mission  (cost=0.00..4773.55 rows=11 width=27) (actual time=7.302..11.259 rows=11 loops=3)
--                                       Filter: ((bomb_damage_assessment IS NOT NULL) AND (airborne_aircraft > '5'::numeric))
--                                       Rows Removed by Filter: 59416
-- Planning Time: 0.147 ms
-- Execution Time: 48.386 ms
