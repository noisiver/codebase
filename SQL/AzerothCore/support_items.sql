SET
@Entry := 9500000,
@Model := 18520,
@Name  := "Onidanis",
@Title := "Support",
@Icon  := "Buy",
@GossipMenu := 0,
@MinLevel := 30,
@MaxLevel := 30,
@Faction  := 35,
@NPCFlag  := 128,
@Scale    := 1.0,
@Rank     := 0,
@Type     := 7,
@TypeFlags := 0,
@FlagsExtra := 16777218;

DELETE FROM `creature_template` WHERE `entry`=@Entry;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `RegenHealth`, `flags_extra`) VALUES
(@Entry, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @Faction, @NPCFlag, 1, 1, @Scale, @Rank, 1, 2, @Type, @TypeFlags, 1, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 0, -8823.29, 649.216, 94.5696, 4.37579); -- Stormwind
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 0, -4974.51, -944.669, 501.66, 5.22683); -- Ironforge
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 1, 9952.74, 2498.32, 1317.63, 4.86313); -- Darnassus
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 530, -3909.85, -11606.6, -138.287, 4.44221); -- Exodar
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 1, 1676.9, -4423.44, 18.9322, 2.48496); -- Orgrimmar
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 1, -1272.35, 132.758, 131.956, 4.28419); -- Thunder Bluff
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 0, 1555.58, 247.924, -43.1026, 5.75556); -- Undercity
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 530, 9470.25, -7296.1, 14.3261, 0.419584); -- Silvermoon City
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 530, -1831.41, 5390.15, -12.4279, 2.32316); -- Shattrath
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (@Entry, 571, 5791.55, 633.407, 647.382, 5.86937); -- Dalaran

UPDATE `item_template` SET `BuyPrice`=0 AND `SellPrice`=0 WHERE `entry` IN (6217, 6338, 11128, 11144, 16206, 25843, 25844, 41741, 41745, 25845, 43145, 43146);
DELETE FROM `npc_vendor` WHERE `entry`=@Entry;
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 6217); -- Copper Rod
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 6338); -- Silver Rod
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 11128); -- Golden Rod
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 11144); -- Truesilver Rod
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 16206); -- Arcanite Rod
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 25843); -- Fel Iron Rod
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 25844); -- Adamantite Rod
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 41741); -- Cobalt Rod
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 41745); -- Titanium Rod
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 25845); -- Eternium Rod
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 43145); -- Armor Vellum III
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 43146); -- Weapon Vellum III
