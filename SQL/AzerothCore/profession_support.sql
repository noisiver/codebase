SET
@Entry := 9900000,
@Model := 28119,
@Name  := "Alfred",
@Title := "Profession Support",
@Icon  := "Buy",
@MinLevel := 50,
@MaxLevel := 50,
@Faction  := 35,
@NPCFlag  := 128,
@Type     := 7;

-- Creature template
DELETE FROM `creature_template` WHERE `entry`=@Entry;
INSERT INTO `creature_template` (`entry`, `name`, `subname`, `IconName`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `type`, `unit_class`) VALUES
(@Entry, @Name, @Title, @Icon, @MinLevel, @MaxLevel, @Faction, @NPCFlag, @Type, 1);

DELETE FROM `creature_template_model` WHERE `CreatureID`=@Entry;
INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`) VALUES
(@Entry, 0, @Model, 1, 1);

-- Spawn point
DELETE FROM `creature` WHERE `id1`=@Entry;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 571, 5791.49, 633.431, 647.395, 5.69658);

-- Infinite Dust
UPDATE `item_template` SET `BuyCount`=40 WHERE `entry`=34054;

-- Vendor entries
DELETE FROM `npc_vendor` WHERE `entry`=@Entry;
INSERT INTO `npc_vendor` (`entry`, `item`, `ExtendedCost`) VALUES
(@Entry, 34054, 2553), -- Infinite Dust (4 Dream Shard -> 40 Infinite Dust)
(@Entry, 6217, 0), -- Copper Rod
(@Entry, 6338, 0), -- Silver Rod
(@Entry, 11128, 0), -- Golden Rod
(@Entry, 11144, 0), -- Truesilver Rod
(@Entry, 16206, 0), -- Arcanite Rod
(@Entry, 25843, 0), -- Fel Iron Rod
(@Entry, 25844, 0), -- Adamantite Rod
(@Entry, 25845, 0), -- Eternium Rod
(@Entry, 41745, 0); -- Titanium Rod
