-- Set spawn points to Dalaran
DELETE FROM `mod_spawnpoints`;
INSERT INTO `mod_spawnpoints` (`team_id`, `map_id`, `pos_x`, `pos_y`, `pos_z`, `orientation`, `comment`) VALUES (0, 571, 5807.779, 588.14, 660.93, 1.65, 'Alliance - Dalaran');
INSERT INTO `mod_spawnpoints` (`team_id`, `map_id`, `pos_x`, `pos_y`, `pos_z`, `orientation`, `comment`) VALUES (1, 571, 5807.779, 588.14, 660.93, 1.65, 'Horde - Dalaran');
