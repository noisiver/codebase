-- Taillasher Egg (Quest: Break a Few Eggs (Id: 815))
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3122 AND `ItemId`=4890;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3122, 0, 4890);

-- Sack of Supplies (Quest: Winds in the Desert (Id: 834))
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3115 AND `ItemId`=4918;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3115, 0, 4918);
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3116 AND `ItemId`=4918;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3116, 0, 4918);

-- Fungal Spores (Quest: Fungal Spores (Id: 848))
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3461 AND `ItemId`=5012;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3461, 1, 5012);

-- Nugget Slug (Quest: Nugget Slugs (Id: 3922))
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3282 AND `ItemId`=11143;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3282, 0, 11143);
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3284 AND `ItemId`=11143;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3284, 0, 11143);

-- Gaea Seed (Quest: Cycle of Rebirth (Id: 6301))
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=4012 AND `ItemId`=16205;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (4012, 1, 16205);
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=4014 AND `ItemId`=16205;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (4014, 1, 16205);
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=6141 AND `ItemId`=16205;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (6141, 1, 16205);
