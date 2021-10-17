-- Spawn points for Stormwind, Orgrimmar and Dalaran
DELETE FROM `creature` WHERE `id`=9000000;
INSERT INTO `creature` (`guid`, `id`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (9000000, 9000000, 0, -8825.05, 649.331, 94.5545, 4.6664); -- Stormwind City
INSERT INTO `creature` (`guid`, `id`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (9000001, 9000000, 1, 1676.62, -4423.69, 18.9152, 2.64126); -- Orgrimmar
INSERT INTO `creature` (`guid`, `id`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (9000002, 9000000, 571, 5784.29, 623.186, 647.71, 5.75156); -- Dalaran
