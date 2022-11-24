SET
@Entry := 7000000,
@Model := 22752,
@Name  := 'Mailan',
@Title := 'Heirloom Vendor',
@Icon  := 'Buy',
@MinLevel := 45,
@MaxLevel := 45,
@Faction  := 35,
@NPCFlag  := 128,
@Type     := 7;

DELETE FROM `creature_template` WHERE `entry`=@Entry;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `unit_class`, `type`) VALUES
(@Entry, @Model, @Name, @Title, @Icon, @MinLevel, @MaxLevel, @Faction, @NPCFlag, 1, @Type);

DELETE FROM `creature` WHERE `id1`=@Entry;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 571, 5790.52, 642.311, 647.376, 0.536515);

-- Weapons
UPDATE `item_template` SET `BuyPrice`=5000000 WHERE `entry` IN (42943, 42944, 42945, 42946, 42947, 42948, 44091, 44092, 44093, 44094, 44095, 44096, 48716, 48718);

-- Armor
UPDATE `item_template` SET `BuyPrice`=2500000 WHERE `entry` IN (42949, 42950, 42951, 42952, 42984, 42985, 42991, 42992, 44097, 44098, 44099, 44100, 44101, 44102, 44103, 44105, 44107, 48677, 48683, 48685, 48687, 48689, 48691, 50255);

DELETE FROM `npc_vendor` WHERE `entry`=@Entry;
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES
-- Weapons
(@Entry, 42943),
(@Entry, 42944),
(@Entry, 42945),
(@Entry, 42946),
(@Entry, 42947),
(@Entry, 42948),
(@Entry, 44091),
(@Entry, 44092),
(@Entry, 44093),
(@Entry, 44094),
(@Entry, 44095),
(@Entry, 44096),
(@Entry, 48716),
(@Entry, 48718),
-- Armor
(@Entry, 42949),
(@Entry, 42950),
(@Entry, 42951),
(@Entry, 42952),
(@Entry, 42984),
(@Entry, 42985),
(@Entry, 42991),
(@Entry, 42992),
(@Entry, 44097),
(@Entry, 44098),
(@Entry, 44099),
(@Entry, 44100),
(@Entry, 44101),
(@Entry, 44102),
(@Entry, 44103),
(@Entry, 44105),
(@Entry, 44107),
(@Entry, 48677),
(@Entry, 48683),
(@Entry, 48685),
(@Entry, 48687),
(@Entry, 48689),
(@Entry, 48691),
(@Entry, 50255);
