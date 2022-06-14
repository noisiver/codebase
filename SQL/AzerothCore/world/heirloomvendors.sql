SET
@Entry := 8500000,
@Model := 28149,
@Name  := 'Canith Eltren',
@Title := '',
@Icon  := 'Speak',
@GossipMenu := 0,
@MinLevel := 30,
@MaxLevel := 30,
@Faction  := 35,
@NPCFlag  := 129,
@Scale    := 1.0,
@Rank     := 0,
@Type     := 7,
@TypeFlags := 0,
@FlagsExtra := 16777218;

-- Creature template
DELETE FROM `creature_template` WHERE `entry`=@Entry;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `RegenHealth`, `flags_extra`) VALUES
(@Entry, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @Faction, @NPCFlag, 1, 1, @Scale, @Rank, 1, 2, @Type, @TypeFlags, 1, @FlagsExtra);

-- Spawn points
DELETE FROM `creature` WHERE `id1`=@Entry;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (8500000, 1, -640.721, -4248.98, 38.166, 6.12292);
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (8500000, 1, -2922.62, -238.746, 53.9154, 4.73516);
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (8500000, 0, 1838.44, 1609.19, 95.5577, 4.69764);
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (8500000, 530, 10339.9, -6374.2, 35.4478, 0.7757);
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (8500000, 0, -8928.23, -153.275, 81.3196, 2.01174);
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (8500000, 0, -6243.83, 342.115, 383.046, 5.94263);
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (8500000, 1, 10330.8, 824.311, 1326.39, 2.54542);
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES (8500000, 530, -4191.69, -13739.9, 74.3792, 1.20559);

-- Heirloom: Weapon
DELETE FROM `npc_vendor` WHERE `entry`=@Entry;
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42943);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42944);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42945);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42946);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42947);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42948);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44091);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44092);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44093);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44094);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44095);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44096);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 48716);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 48718);
-- Heirloom: Armor
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42949);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42950);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42951);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42952);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42984);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42985);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42991);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 42992);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44097);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44098);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44099);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44100);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44101);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44102);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44103);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44105);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 44107);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 48677);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 48683);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 48685);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 48687);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 48689);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 48691);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 50255);
-- Heirloom: Other
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES (@Entry, 49177);
