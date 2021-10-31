-- Taillasher Egg (Quest: Break a Few Eggs (Id: 815))
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3122 AND `ItemId`=4890;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3122, 0, 4890);
