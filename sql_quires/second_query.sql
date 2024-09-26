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

--  explanation
-- Limit  (cost=8.19..8.20 rows=1 width=750)
--   ->  Sort  (cost=8.19..8.20 rows=1 width=750)
--         Sort Key: (count(bomb_damage_assessment)) DESC
--         ->  GroupAggregate  (cost=8.15..8.18 rows=1 width=750)
-- "              Group Key: target_country, bomb_damage_assessment"
--               ->  Sort  (cost=8.15..8.16 rows=1 width=734)
-- "                    Sort Key: target_country, bomb_damage_assessment"
--                     ->  Index Only Scan using index_mission on mission2  (cost=0.12..8.14 rows=1 width=734)
--                           Index Cond: ((airborne_aircraft > '5'::numeric) AND (bomb_damage_assessment IS NOT NULL))



explain analyse
select target_country ,bomb_damage_assessment, count(target_country) from mission
where bomb_damage_assessment is not null
and airborne_aircraft > 5
group by target_country, bomb_damage_assessment
order by count(bomb_damage_assessment) desc limit 1;

-- explanation with analyze
-- Limit  (cost=8.19..8.20 rows=1 width=750) (actual time=0.024..0.025 rows=0 loops=1)
--   ->  Sort  (cost=8.19..8.20 rows=1 width=750) (actual time=0.023..0.024 rows=0 loops=1)
--         Sort Key: (count(bomb_damage_assessment)) DESC
--         Sort Method: quicksort  Memory: 25kB
--         ->  GroupAggregate  (cost=8.15..8.18 rows=1 width=750) (actual time=0.018..0.018 rows=0 loops=1)
-- "              Group Key: target_country, bomb_damage_assessment"
--               ->  Sort  (cost=8.15..8.16 rows=1 width=734) (actual time=0.017..0.018 rows=0 loops=1)
-- "                    Sort Key: target_country, bomb_damage_assessment"
--                     Sort Method: quicksort  Memory: 25kB
--                     ->  Index Only Scan using index_mission on mission2  (cost=0.12..8.14 rows=1 width=734) (actual time=0.009..0.009 rows=0 loops=1)
--                           Index Cond: ((airborne_aircraft > '5'::numeric) AND (bomb_damage_assessment IS NOT NULL))
--                           Heap Fetches: 0
-- Planning Time: 0.161 ms
-- Execution Time: 0.049 ms


CREATE INDEX index_mission ON mission (airborne_aircraft, bomb_damage_assessment, target_country);
-- Limit  (cost=8.19..8.20 rows=1 width=750) (actual time=0.012..0.013 rows=0 loops=1)
--   ->  Sort  (cost=8.19..8.20 rows=1 width=750) (actual time=0.012..0.012 rows=0 loops=1)
--         Sort Key: (count(bomb_damage_assessment)) DESC
--         Sort Method: quicksort  Memory: 25kB
--         ->  GroupAggregate  (cost=8.15..8.18 rows=1 width=750) (actual time=0.009..0.009 rows=0 loops=1)
-- "              Group Key: target_country, bomb_damage_assessment"
--               ->  Sort  (cost=8.15..8.16 rows=1 width=734) (actual time=0.009..0.009 rows=0 loops=1)
-- "                    Sort Key: target_country, bomb_damage_assessment"
--                     Sort Method: quicksort  Memory: 25kB
--                     ->  Index Only Scan using indeex_mission on mission2  (cost=0.12..8.14 rows=1 width=734) (actual time=0.004..0.004 rows=0 loops=1)
--                           Index Cond: ((airborne_aircraft > '5'::numeric) AND (bomb_damage_assessment IS NOT NULL))
--                           Heap Fetches: 0
-- Planning Time: 0.910 ms
-- Execution Time: 0.040 ms


--  שווה לעשות אינדקס בגלל הפרש הזמנים
