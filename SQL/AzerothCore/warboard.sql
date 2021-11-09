DELETE FROM `gameobject_template` WHERE `entry`=9000000;
INSERT INTO `gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`) VALUES (9000000, 2, 3053, 'Warboard', 'Quest');

DELETE FROM `gameobject` WHERE `id`=9000000;
-- Stormwind City
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`) VALUES (9000000, 9000000, 0, 0, -8830.64, 647.904, 95.0995, 5.24519, 0, 0, -0.496008, 0.868318);
-- Orgrimmar
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`) VALUES (9000001, 9000000, 1, 0, 1637.35, -4431.34, 15.8744, 1.86371, -0, -0, -0.802728, -0.596345);
