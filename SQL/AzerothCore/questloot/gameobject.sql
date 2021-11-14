-- Cactus Apple (Quest: Galgar's Cactus Apple Surprise (Id: 4402))
-- Change respawn time from 60 to 10 seconds
UPDATE `gameobject` SET `spawntimesecs`=10 WHERE `id`=171938;

-- Gnomish Toolbox (Quest: From The Wreckage.... (Id: 825))
-- Change respawn time from 900 to 10 seconds
UPDATE `gameobject` SET `spawntimesecs`=10 WHERE `id`=3236;

-- Alien Egg (Quest: Alien Egg (Id: 4821))
UPDATE `gameobject` SET `spawntimesecs`=1 WHERE `id`=175565;

-- Gri'lek the Wanderer (Quest: The Vile Reef (Id: 629))
-- Change respawn time from 60 to 1 seconds
UPDATE `gameobject` SET `spawntimesecs`=1 WHERE `id`=58;

-- Warped Crates (Quest: Twilight of the Dawn Runner (Id: 9437))
UPDATE `gameobject` SET `spawntimesecs`=1 WHERE `id`=181626
