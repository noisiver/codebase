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

-- Troll Charm (Quest: Troll Charm (Id: 6462))
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3921 AND `ItemId`=16602;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3921, 1, 16602);
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3922 AND `ItemId`=16602;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3922, 1, 16602);
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3923 AND `ItemId`=16602;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3923, 1, 16602);

-- Charred Razormane Wand (Quest: Weapons of Choice (Id: 893))
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3458 AND `ItemId`=5092;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3458, 1, 5092);

-- Razormane Backstabber (Quest: Weapons of Choice (Id: 893))
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3456 AND `ItemId`=5093;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3456, 0, 5093);
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3457 AND `ItemId`=5093;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3457, 0, 5093);

-- Razormane War Shield (Quest: Weapons of Choice (Id: 893))
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=3459 AND `ItemId`=5094;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (3459, 0, 5094);
