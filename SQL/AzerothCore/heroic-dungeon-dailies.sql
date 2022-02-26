DELETE FROM `creature_queststarter` WHERE `id`=31439 AND `quest` IN (13245, 13246, 13247, 13248, 13249, 13250, 13251, 13252, 13253, 13254, 13255, 13256, 14199);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13245);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13246);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13247);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13248);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13249);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13250);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13251);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13252);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13253);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13254);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13255);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 13256);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES (31439, 14199);

UPDATE `quest_template` SET `Flags`=4232 WHERE `ID` IN (13245, 13246, 13247, 13248, 13249, 13250, 13251, 13252, 13253, 13254, 13255, 13256, 14199);

UPDATE `quest_template_addon` SET `ExclusiveGroup`=13245 WHERE `ID`=14199;

DELETE FROM `pool_template` WHERE `entry`=90000;
INSERT INTO `pool_template` (`entry`, `max_limit`, `description`) VALUES (90000, 1, 'Heroic Dungeon Dailies');

DELETE FROM `pool_quest` WHERE `pool_entry`=90000;
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13245, 90000, 'Proof of Demise: Ingvar the Plunderer');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13246, 90000, 'Proof of Demise: Keristrasza');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13247, 90000, 'Proof of Demise: Ley-Guardian Eregos');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13248, 90000, 'Proof of Demise: King Ymiron');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13249, 90000, 'Proof of Demise: The Prophet Tharon\'ja');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13250, 90000, 'Proof of Demise: Gal\'darah');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13251, 90000, 'Proof of Demise: Mal\'Ganis');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13252, 90000, 'Proof of Demise: Sjonnir The Ironshaper');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13253, 90000, 'Proof of Demise: Loken');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13254, 90000, 'Proof of Demise: Anub\'arak');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13255, 90000, 'Proof of Demise: Herald Volazj');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (13256, 90000, 'Proof of Demise: Cyanigosa');
INSERT INTO `pool_quest` (`entry`, `pool_entry`, `description`) VALUES (14199, 90000, 'Proof of Demise: The Black Knight');
