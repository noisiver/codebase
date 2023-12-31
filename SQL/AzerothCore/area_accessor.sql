-- Orc & Troll
SET
@Entry := 8000000,
@Model := 1379,
@Name  := 'Kuz Bloodslice',
@Title := 'Area Accessor',
@Icon  := 'Speak',
@GossipMenu := 65000,
@MinLevel := 30,
@MaxLevel := 30,
@Faction  := 85,
@NPCFlag  := 1,
@Scale    := 1.0,
@Rank     := 0,
@Type     := 7,
@TypeFlags := 0,
@AIName := 'SmartAI',
@FlagsExtra := 16777218;

DELETE FROM `creature_template` WHERE `entry`=@Entry;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `RegenHealth`, `AIName`, `flags_extra`) VALUES
(@Entry, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @Faction, @NPCFlag, 1, 1, @Scale, @Rank, 1, 2, @Type, @TypeFlags, 1, @AIName, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`) VALUES (@Entry, 1, -589.616, -4224.45, 38.2941, 4.21834, 300);

DELETE FROM `gossip_menu` WHERE `MenuID`=@GossipMenu;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES (@GossipMenu, 48);

DELETE FROM `gossip_menu_option` WHERE `MenuID`=@GossipMenu;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionType`, `OptionNpcFlag`) VALUES 
(@GossipMenu, 0, 7, 'I want to go to Red Cloud Mesa', 1, 1),
(@GossipMenu, 1, 7, 'I want to go to Deathknell', 1, 1),
(@GossipMenu, 2, 7, 'I want to go to Sunstrider Isle', 1, 1);
/*(@GossipMenu, 3, 7, 'I want to go to Orgrimmar', 1, 1),
(@GossipMenu, 4, 7, 'I want to go to Thunder Bluff', 1, 1),
(@GossipMenu, 5, 7, 'I want to go to Undercity', 1, 1),
(@GossipMenu, 6, 7, 'I want to go to Silvermoon City', 1, 1),
(@GossipMenu, 7, 7, 'I want to go to Dalaran', 1, 1);*/

DELETE FROM `smart_scripts` WHERE `entryorguid`=@Entry;
INSERT INTO `smart_scripts` (`entryorguid`, `id`, `event_type`, `event_param1`, `event_param2`, `action_type`, `action_param1`, `target_type`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@Entry, 0, 62, @GossipMenu, 0, 62, 1, 7, -2923.569, -264.370, 53.444, 0.596, 'Kuz Bloodslice - OnGossipSelect - Teleport to Red Cloud Mesa'),
(@Entry, 1, 62, @GossipMenu, 1, 62, 0, 7, 1834.376, 1603.325, 95.663, 5.479, 'Kuz Bloodslice - OnGossipSelect - Teleport to Deathknell'),
(@Entry, 2, 62, @GossipMenu, 2, 62, 530, 7, 10337.844, -6373.725, 35.107, 0.815, 'Kuz Bloodslice - OnGossipSelect - Teleport to Sunstrider Isle');
/*(@Entry, 3, 62, @GossipMenu, 3, 62, 1, 7, 1659.147, -4428.456, 17.368, 2.008, 'Kuz Bloodslice - OnGossipSelect - Teleport to Orgrimmar'),
(@Entry, 4, 62, @GossipMenu, 4, 62, 1, 7, -1273.327, 71.340, 128.020, 5.992, 'Kuz Bloodslice - OnGossipSelect - Teleport to Thunder Bluff'),
(@Entry, 5, 62, @GossipMenu, 5, 62, 0, 7, 1595.664, 220.437, -57.161, 4.670, 'Kuz Bloodslice - OnGossipSelect - Teleport to Undercity'),
(@Entry, 6, 62, @GossipMenu, 6, 62, 530, 7, 9514.708, -7265.375, 14.341, 4.967, 'Kuz Bloodslice - OnGossipSelect - Teleport to Silvermoon City'),
(@Entry, 7, 62, @GossipMenu, 7, 62, 571, 7, 5804.337, 621.452, 647.911, 1.651, 'Kuz Bloodslice - OnGossipSelect - Teleport to Dalaran');*/

-- Tauren
SET
@Model := 3814,
@Name := 'Muraco Proudgrain',
@Faction := 104;

DELETE FROM `creature_template` WHERE `entry`=@Entry+1;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `RegenHealth`, `AIName`, `flags_extra`) VALUES
(@Entry+1, @Model, @Name, @Title, @Icon, @GossipMenu+1, @MinLevel, @MaxLevel, @Faction, @NPCFlag, 1, 1, @Scale, @Rank, 1, 2, @Type, @TypeFlags, 1, @AIName, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+1;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`) VALUES (@Entry+1, 1, -2900.73, -274.041, 53.8725, 1.99333, 300);

DELETE FROM `gossip_menu` WHERE `MenuID`=@GossipMenu+1;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES (@GossipMenu+1, 48);

DELETE FROM `gossip_menu_option` WHERE `MenuID`=@GossipMenu+1;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionType`, `OptionNpcFlag`) VALUES 
(@GossipMenu+1, 0, 7, 'I want to go to Valley of Trials', 1, 1),
(@GossipMenu+1, 1, 7, 'I want to go to Deathknell', 1, 1),
(@GossipMenu+1, 2, 7, 'I want to go to Sunstrider Isle', 1, 1);
/*(@GossipMenu+1, 3, 7, 'I want to go to Orgrimmar', 1, 1),
(@GossipMenu+1, 4, 7, 'I want to go to Thunder Bluff', 1, 1),
(@GossipMenu+1, 5, 7, 'I want to go to Undercity', 1, 1),
(@GossipMenu+1, 6, 7, 'I want to go to Silvermoon City', 1, 1),
(@GossipMenu+1, 7, 7, 'I want to go to Dalaran', 1, 1);*/

DELETE FROM `smart_scripts` WHERE `entryorguid`=@Entry+1;
INSERT INTO `smart_scripts` (`entryorguid`, `id`, `event_type`, `event_param1`, `event_param2`, `action_type`, `action_param1`, `target_type`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@Entry+1, 0, 62, @GossipMenu+1, 0, 62, 1, 7, -604.192, -4221.229, 38.614, 4.74, 'Muraco Proudgrain - OnGossipSelect - Teleport to Valley of Trials'),
(@Entry+1, 1, 62, @GossipMenu+1, 1, 62, 0, 7, 1834.376, 1603.325, 95.663, 5.479, 'Muraco Proudgrain - OnGossipSelect - Teleport to Deathknell'),
(@Entry+1, 2, 62, @GossipMenu+1, 2, 62, 530, 7, 10337.844, -6373.725, 35.107, 0.815, 'Muraco Proudgrain - OnGossipSelect - Teleport to Sunstrider Isle');
/*(@Entry+1, 3, 62, @GossipMenu+1, 3, 62, 1, 7, 1659.147, -4428.456, 17.368, 2.008, 'Muraco Proudgrain - OnGossipSelect - Teleport to Orgrimmar'),
(@Entry+1, 4, 62, @GossipMenu+1, 4, 62, 1, 7, -1273.327, 71.340, 128.020, 5.992, 'Muraco Proudgrain - OnGossipSelect - Teleport to Thunder Bluff'),
(@Entry+1, 5, 62, @GossipMenu+1, 5, 62, 0, 7, 1595.664, 220.437, -57.161, 4.670, 'Muraco Proudgrain - OnGossipSelect - Teleport to Undercity'),
(@Entry+1, 6, 62, @GossipMenu+1, 6, 62, 530, 7, 9514.708, -7265.375, 14.341, 4.967, 'Muraco Proudgrain - OnGossipSelect - Teleport to Silvermoon City'),
(@Entry+1, 7, 62, @GossipMenu+1, 7, 62, 571, 7, 5804.337, 621.452, 647.911, 1.651, 'Muraco Proudgrain - OnGossipSelect - Teleport to Dalaran');*/

-- Undead
SET
@Model := 3521,
@Name := 'Zackary Aries',
@Faction := 118;

DELETE FROM `creature_template` WHERE `entry`=@Entry+2;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `RegenHealth`, `AIName`, `flags_extra`) VALUES
(@Entry+2, @Model, @Name, @Title, @Icon, @GossipMenu+2, @MinLevel, @MaxLevel, @Faction, @NPCFlag, 1, 1, @Scale, @Rank, 1, 2, @Type, @TypeFlags, 1, @AIName, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+2;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`) VALUES (@Entry+2, 0, 1832.56, 1579.9, 95.4766, 1.30079, 300);

DELETE FROM `gossip_menu` WHERE `MenuID`=@GossipMenu+2;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES (@GossipMenu+2, 48);

DELETE FROM `gossip_menu_option` WHERE `MenuID`=@GossipMenu+2;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionType`, `OptionNpcFlag`) VALUES 
(@GossipMenu+2, 0, 7, 'I want to go to Valley of Trials', 1, 1),
(@GossipMenu+2, 1, 7, 'I want to go to Red Cloud Mesa', 1, 1),
(@GossipMenu+2, 2, 7, 'I want to go to Sunstrider Isle', 1, 1);
/*(@GossipMenu+2, 3, 7, 'I want to go to Orgrimmar', 1, 1),
(@GossipMenu+2, 4, 7, 'I want to go to Thunder Bluff', 1, 1),
(@GossipMenu+2, 5, 7, 'I want to go to Undercity', 1, 1),
(@GossipMenu+2, 6, 7, 'I want to go to Silvermoon City', 1, 1),
(@GossipMenu+2, 7, 7, 'I want to go to Dalaran', 1, 1);*/

DELETE FROM `smart_scripts` WHERE `entryorguid`=@Entry+2;
INSERT INTO `smart_scripts` (`entryorguid`, `id`, `event_type`, `event_param1`, `event_param2`, `action_type`, `action_param1`, `target_type`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@Entry+2, 0, 62, @GossipMenu+2, 0, 62, 1, 7, -604.192, -4221.229, 38.614, 4.74, 'Zackary Aries - OnGossipSelect - Teleport to Valley of Trials'),
(@Entry+2, 1, 62, @GossipMenu+2, 1, 62, 1, 7, -2923.569, -264.370, 53.444, 0.596, 'Zackary Aries - OnGossipSelect - Teleport to Red Cloud Mesa'),
(@Entry+2, 2, 62, @GossipMenu+2, 2, 62, 530, 7, 10337.844, -6373.725, 35.107, 0.815, 'Zackary Aries - OnGossipSelect - Teleport to Sunstrider Isle');
/*(@Entry+2, 3, 62, @GossipMenu+2, 3, 62, 1, 7, 1659.147, -4428.456, 17.368, 2.008, 'Zackary Aries - OnGossipSelect - Teleport to Orgrimmar'),
(@Entry+2, 4, 62, @GossipMenu+2, 4, 62, 1, 7, -1273.327, 71.340, 128.020, 5.992, 'Zackary Aries - OnGossipSelect - Teleport to Thunder Bluff'),
(@Entry+2, 5, 62, @GossipMenu+2, 5, 62, 0, 7, 1595.664, 220.437, -57.161, 4.670, 'Zackary Aries - OnGossipSelect - Teleport to Undercity'),
(@Entry+2, 6, 62, @GossipMenu+2, 6, 62, 530, 7, 9514.708, -7265.375, 14.341, 4.967, 'Zackary Aries - OnGossipSelect - Teleport to Silvermoon City'),
(@Entry+2, 7, 62, @GossipMenu+2, 7, 62, 571, 7, 5804.337, 621.452, 647.911, 1.651, 'Zackary Aries - OnGossipSelect - Teleport to Dalaran');*/

-- Blood Elf
SET
@Model := 16626,
@Name := 'Lethnas Coldbinder',
@Faction := 1604;

DELETE FROM `creature_template` WHERE `entry`=@Entry+3;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `RegenHealth`, `AIName`, `flags_extra`) VALUES
(@Entry+3, @Model, @Name, @Title, @Icon, @GossipMenu+3, @MinLevel, @MaxLevel, @Faction, @NPCFlag, 1, 1, @Scale, @Rank, 1, 2, @Type, @TypeFlags, 1, @AIName, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+3;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`) VALUES (@Entry+3, 530, 10357.3, -6370.18, 36.1758, 2.35042, 300);

DELETE FROM `gossip_menu` WHERE `MenuID`=@GossipMenu+3;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES (@GossipMenu+3, 48);

DELETE FROM `gossip_menu_option` WHERE `MenuID`=@GossipMenu+3;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionType`, `OptionNpcFlag`) VALUES 
(@GossipMenu+3, 0, 7, 'I want to go to Valley of Trials', 1, 1),
(@GossipMenu+3, 1, 7, 'I want to go to Red Cloud Mesa', 1, 1),
(@GossipMenu+3, 2, 7, 'I want to go to Deathknell', 1, 1);
/*(@GossipMenu+3, 3, 7, 'I want to go to Orgrimmar', 1, 1),
(@GossipMenu+3, 4, 7, 'I want to go to Thunder Bluff', 1, 1),
(@GossipMenu+3, 5, 7, 'I want to go to Undercity', 1, 1),
(@GossipMenu+3, 6, 7, 'I want to go to Silvermoon City', 1, 1),
(@GossipMenu+3, 7, 7, 'I want to go to Dalaran', 1, 1);*/

DELETE FROM `smart_scripts` WHERE `entryorguid`=@Entry+3;
INSERT INTO `smart_scripts` (`entryorguid`, `id`, `event_type`, `event_param1`, `event_param2`, `action_type`, `action_param1`, `target_type`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@Entry+3, 0, 62, @GossipMenu+3, 0, 62, 1, 7, -604.192, -4221.229, 38.614, 4.74, 'Lethnas Coldbinder - OnGossipSelect - Teleport to Valley of Trials'),
(@Entry+3, 1, 62, @GossipMenu+3, 1, 62, 1, 7, -2923.569, -264.370, 53.444, 0.596, 'Lethnas Coldbinder - OnGossipSelect - Teleport to Red Cloud Mesa'),
(@Entry+3, 2, 62, @GossipMenu+3, 2, 62, 0, 7, 1834.376, 1603.325, 95.663, 5.479, 'Lethnas Coldbinder - OnGossipSelect - Teleport to Deathknell');
/*(@Entry+3, 3, 62, @GossipMenu+3, 3, 62, 1, 7, 1659.147, -4428.456, 17.368, 2.008, 'Lethnas Coldbinder - OnGossipSelect - Teleport to Orgrimmar'),
(@Entry+3, 4, 62, @GossipMenu+3, 4, 62, 1, 7, -1273.327, 71.340, 128.020, 5.992, 'Lethnas Coldbinder - OnGossipSelect - Teleport to Thunder Bluff'),
(@Entry+3, 5, 62, @GossipMenu+3, 5, 62, 0, 7, 1595.664, 220.437, -57.161, 4.670, 'Lethnas Coldbinder - OnGossipSelect - Teleport to Undercity'),
(@Entry+3, 6, 62, @GossipMenu+3, 6, 62, 530, 7, 9514.708, -7265.375, 14.341, 4.967, 'Lethnas Coldbinder - OnGossipSelect - Teleport to Silvermoon City'),
(@Entry+3, 7, 62, @GossipMenu+3, 7, 62, 571, 7, 5804.337, 621.452, 647.911, 1.651, 'Lethnas Coldbinder - OnGossipSelect - Teleport to Dalaran');*/

-- Human
SET
@Model := 9257,
@Name := 'Amalia Fletcher',
@Faction := 12;

DELETE FROM `creature_template` WHERE `entry`=@Entry+4;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `RegenHealth`, `AIName`, `flags_extra`) VALUES
(@Entry+4, @Model, @Name, @Title, @Icon, @GossipMenu+4, @MinLevel, @MaxLevel, @Faction, @NPCFlag, 1, 1, @Scale, @Rank, 1, 2, @Type, @TypeFlags, 1, @AIName, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+4;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`) VALUES (@Entry+4, 0, -8896.29, -139.16, 80.5286, 2.02353, 300);

DELETE FROM `gossip_menu` WHERE `MenuID`=@GossipMenu+4;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES (@GossipMenu+4, 48);

DELETE FROM `gossip_menu_option` WHERE `MenuID`=@GossipMenu+4;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionType`, `OptionNpcFlag`) VALUES 
(@GossipMenu+4, 0, 7, 'I want to go to Coldridge Valley', 1, 1),
(@GossipMenu+4, 1, 7, 'I want to go to Shadowglen', 1, 1),
(@GossipMenu+4, 2, 7, 'I want to go to Ammen Vale', 1, 1);
/*(@GossipMenu+4, 3, 7, 'I want to go to Stormwind', 1, 1),
(@GossipMenu+4, 4, 7, 'I want to go to Ironforge', 1, 1),
(@GossipMenu+4, 5, 7, 'I want to go to Darnassus', 1, 1),
(@GossipMenu+4, 6, 7, 'I want to go to Exodar', 1, 1),
(@GossipMenu+4, 7, 7, 'I want to go to Dalaran', 1, 1);*/

DELETE FROM `smart_scripts` WHERE `entryorguid`=@Entry+4;
INSERT INTO `smart_scripts` (`entryorguid`, `id`, `event_type`, `event_param1`, `event_param2`, `action_type`, `action_param1`, `target_type`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@Entry+4, 0, 62, @GossipMenu+4, 0, 62, 0, 7, -6241.955, 342.429, 383.198, 5.834, 'Amalia Fletcher - OnGossipSelect - Teleport to Coldridge Valley'),
(@Entry+4, 1, 62, @GossipMenu+4, 1, 62, 1, 7, 10325.171, 822.017, 1326.410, 1.787, 'Amalia Fletcher - OnGossipSelect - Teleport to Shadowglen'),
(@Entry+4, 2, 62, @GossipMenu+4, 2, 62, 530, 7, -4181.665, -13718.229, 73.801, 4.286, 'Amalia Fletcher - OnGossipSelect - Teleport to Ammen Vale');
/*(@Entry+4, 3, 62, @GossipMenu+4, 3, 62, 0, 7, -8830.514, 645.764, 94.640, 4.803, 'Amalia Fletcher - OnGossipSelect - Teleport to Stormwind City'),
(@Entry+4, 4, 62, @GossipMenu+4, 4, 62, 0, 7, -4896.213, -964.740, 501.445, 2.541, 'Amalia Fletcher - OnGossipSelect - Teleport to Ironforge'),
(@Entry+4, 5, 62, @GossipMenu+4, 5, 62, 1, 7, 9944.447, 2495.491, 1317.583, 4.313, 'Amalia Fletcher - OnGossipSelect - Teleport to Darnassus'),
(@Entry+4, 6, 62, @GossipMenu+4, 6, 62, 530, 7, -3933.855, -11637.088, -138.431, 1.939, 'Amalia Fletcher - OnGossipSelect - Teleport to Exodar'),
(@Entry+4, 7, 62, @GossipMenu+4, 7, 62, 571, 7, 5804.337, 621.452, 647.911, 1.651, 'Amalia Fletcher - OnGossipSelect - Teleport to Dalaran');*/

-- Dwarf & Gnome
SET
@Model := 3414,
@Name := 'Drehrdamir Stoutstrike',
@Faction := 55;

DELETE FROM `creature_template` WHERE `entry`=@Entry+5;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `RegenHealth`, `AIName`, `flags_extra`) VALUES
(@Entry+5, @Model, @Name, @Title, @Icon, @GossipMenu+5, @MinLevel, @MaxLevel, @Faction, @NPCFlag, 1, 1, @Scale, @Rank, 1, 2, @Type, @TypeFlags, 1, @AIName, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+5;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`) VALUES (@Entry+5, 0, -6214.13, 327.51, 383.573, 2.66359, 300);

DELETE FROM `gossip_menu` WHERE `MenuID`=@GossipMenu+5;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES (@GossipMenu+5, 48);

DELETE FROM `gossip_menu_option` WHERE `MenuID`=@GossipMenu+5;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionType`, `OptionNpcFlag`) VALUES 
(@GossipMenu+5, 0, 7, 'I want to go to Northshire Valley', 1, 1),
(@GossipMenu+5, 1, 7, 'I want to go to Shadowglen', 1, 1),
(@GossipMenu+5, 2, 7, 'I want to go to Ammen Vale', 1, 1);
/*(@GossipMenu+5, 3, 7, 'I want to go to Stormwind', 1, 1),
(@GossipMenu+5, 4, 7, 'I want to go to Ironforge', 1, 1),
(@GossipMenu+5, 5, 7, 'I want to go to Darnassus', 1, 1),
(@GossipMenu+5, 6, 7, 'I want to go to Exodar', 1, 1),
(@GossipMenu+5, 7, 7, 'I want to go to Dalaran', 1, 1);*/

DELETE FROM `smart_scripts` WHERE `entryorguid`=@Entry+5;
INSERT INTO `smart_scripts` (`entryorguid`, `id`, `event_type`, `event_param1`, `event_param2`, `action_type`, `action_param1`, `target_type`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@Entry+5, 0, 62, @GossipMenu+5, 0, 62, 0, 7, -8921.6777, -108.750, 82.961, 4.238, 'Drehrdamir Stoutstrike - OnGossipSelect - Teleport to Nortshire Valley'),
(@Entry+5, 1, 62, @GossipMenu+5, 1, 62, 1, 7, 10325.171, 822.017, 1326.410, 1.787, 'Drehrdamir Stoutstrike - OnGossipSelect - Teleport to Shadowglen'),
(@Entry+5, 2, 62, @GossipMenu+5, 2, 62, 530, 7, -4181.665, -13718.229, 73.801, 4.286, 'Drehrdamir Stoutstrike - OnGossipSelect - Teleport to Ammen Vale');
/*(@Entry+5, 3, 62, @GossipMenu+5, 3, 62, 0, 7, -8830.514, 645.764, 94.640, 4.803, 'Drehrdamir Stoutstrike - OnGossipSelect - Teleport to Stormwind City'),
(@Entry+5, 4, 62, @GossipMenu+5, 4, 62, 0, 7, -4896.213, -964.740, 501.445, 2.541, 'Drehrdamir Stoutstrike - OnGossipSelect - Teleport to Ironforge'),
(@Entry+5, 5, 62, @GossipMenu+5, 5, 62, 1, 7, 9944.447, 2495.491, 1317.583, 4.313, 'Drehrdamir Stoutstrike - OnGossipSelect - Teleport to Darnassus'),
(@Entry+5, 6, 62, @GossipMenu+5, 6, 62, 530, 7, -3933.855, -11637.088, -138.431, 1.939, 'Drehrdamir Stoutstrike - OnGossipSelect - Teleport to Exodar'),
(@Entry+5, 7, 62, @GossipMenu+5, 7, 62, 571, 7, 5804.337, 621.452, 647.911, 1.651, 'Drehrdamir Stoutstrike - OnGossipSelect - Teleport to Dalaran');*/

-- Night Elf
SET
@Model := 1714,
@Name := 'Uyrea Swiftsnow',
@Faction := 80;

DELETE FROM `creature_template` WHERE `entry`=@Entry+6;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `RegenHealth`, `AIName`, `flags_extra`) VALUES
(@Entry+6, @Model, @Name, @Title, @Icon, @GossipMenu+6, @MinLevel, @MaxLevel, @Faction, @NPCFlag, 1, 1, @Scale, @Rank, 1, 2, @Type, @TypeFlags, 1, @AIName, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+6;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`) VALUES (@Entry+6, 1, 10322.3, 817.783, 1326.47, 1.66919, 300);

DELETE FROM `gossip_menu` WHERE `MenuID`=@GossipMenu+6;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES (@GossipMenu+6, 48);

DELETE FROM `gossip_menu_option` WHERE `MenuID`=@GossipMenu+6;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionType`, `OptionNpcFlag`) VALUES 
(@GossipMenu+6, 0, 7, 'I want to go to Northshire Valley', 1, 1),
(@GossipMenu+6, 1, 7, 'I want to go to Coldridge Valley', 1, 1),
(@GossipMenu+6, 2, 7, 'I want to go to Ammen Vale', 1, 1);
/*(@GossipMenu+6, 3, 7, 'I want to go to Stormwind', 1, 1),
(@GossipMenu+6, 4, 7, 'I want to go to Ironforge', 1, 1),
(@GossipMenu+6, 5, 7, 'I want to go to Darnassus', 1, 1),
(@GossipMenu+6, 6, 7, 'I want to go to Exodar', 1, 1),
(@GossipMenu+6, 7, 7, 'I want to go to Dalaran', 1, 1);*/

DELETE FROM `smart_scripts` WHERE `entryorguid`=@Entry+6;
INSERT INTO `smart_scripts` (`entryorguid`, `id`, `event_type`, `event_param1`, `event_param2`, `action_type`, `action_param1`, `target_type`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@Entry+6, 0, 62, @GossipMenu+6, 0, 62, 0, 7, -8921.6777, -108.750, 82.961, 4.238, 'Uyrea Swiftsnow - OnGossipSelect - Teleport to Nortshire Valley'),
(@Entry+6, 1, 62, @GossipMenu+6, 1, 62, 0, 7, -6241.955, 342.429, 383.198, 5.834, 'Uyrea Swiftsnow - OnGossipSelect - Teleport to Coldridge Valley'),
(@Entry+6, 2, 62, @GossipMenu+6, 2, 62, 530, 7, -4181.665, -13718.229, 73.801, 4.286, 'Uyrea Swiftsnow - OnGossipSelect - Teleport to Ammen Vale');
/*(@Entry+6, 3, 62, @GossipMenu+6, 3, 62, 0, 7, -8830.514, 645.764, 94.640, 4.803, 'Uyrea Swiftsnow - OnGossipSelect - Teleport to Stormwind City'),
(@Entry+6, 4, 62, @GossipMenu+6, 4, 62, 0, 7, -4896.213, -964.740, 501.445, 2.541, 'Uyrea Swiftsnow - OnGossipSelect - Teleport to Ironforge'),
(@Entry+6, 5, 62, @GossipMenu+6, 5, 62, 1, 7, 9944.447, 2495.491, 1317.583, 4.313, 'Uyrea Swiftsnow - OnGossipSelect - Teleport to Darnassus'),
(@Entry+6, 6, 62, @GossipMenu+6, 6, 62, 530, 7, -3933.855, -11637.088, -138.431, 1.939, 'Uyrea Swiftsnow - OnGossipSelect - Teleport to Exodar'),
(@Entry+6, 7, 62, @GossipMenu+6, 7, 62, 571, 7, 5804.337, 621.452, 647.911, 1.651, 'Uyrea Swiftsnow - OnGossipSelect - Teleport to Dalaran');*/

-- Draenei
SET
@Model := 16860,
@Name := 'Jorsuur',
@Faction := 1638;

DELETE FROM `creature_template` WHERE `entry`=@Entry+7;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `RegenHealth`, `AIName`, `flags_extra`) VALUES
(@Entry+7, @Model, @Name, @Title, @Icon, @GossipMenu+7, @MinLevel, @MaxLevel, @Faction, @NPCFlag, 1, 1, @Scale, @Rank, 1, 2, @Type, @TypeFlags, 1, @AIName, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+7;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`) VALUES (@Entry+7, 530, -4176.56, -13719.7, 74.7417, 3.72837, 300);

DELETE FROM `gossip_menu` WHERE `MenuID`=@GossipMenu+7;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES (@GossipMenu+7, 48);

DELETE FROM `gossip_menu_option` WHERE `MenuID`=@GossipMenu+7;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionType`, `OptionNpcFlag`) VALUES 
(@GossipMenu+7, 0, 7, 'I want to go to Northshire Valley', 1, 1),
(@GossipMenu+7, 1, 7, 'I want to go to Coldridge Valley', 1, 1),
(@GossipMenu+7, 2, 7, 'I want to go to Shadowglen', 1, 1);
/*(@GossipMenu+7, 3, 7, 'I want to go to Stormwind', 1, 1),
(@GossipMenu+7, 4, 7, 'I want to go to Ironforge', 1, 1),
(@GossipMenu+7, 5, 7, 'I want to go to Darnassus', 1, 1),
(@GossipMenu+7, 6, 7, 'I want to go to Exodar', 1, 1),
(@GossipMenu+7, 7, 7, 'I want to go to Dalaran', 1, 1);*/

DELETE FROM `smart_scripts` WHERE `entryorguid`=@Entry+7;
INSERT INTO `smart_scripts` (`entryorguid`, `id`, `event_type`, `event_param1`, `event_param2`, `action_type`, `action_param1`, `target_type`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@Entry+7, 0, 62, @GossipMenu+7, 0, 62, 0, 7, -8921.6777, -108.750, 82.961, 4.238, 'Jorsuur - OnGossipSelect - Teleport to Nortshire Valley'),
(@Entry+7, 1, 62, @GossipMenu+7, 1, 62, 0, 7, -6241.955, 342.429, 383.198, 5.834, 'Jorsuur - OnGossipSelect - Teleport to Coldridge Valley'),
(@Entry+7, 2, 62, @GossipMenu+7, 2, 62, 1, 7, 10325.171, 822.017, 1326.410, 1.787, 'Jorsuur - OnGossipSelect - Teleport to Shadowglen');
/*(@Entry+7, 3, 62, @GossipMenu+7, 3, 62, 0, 7, -8830.514, 645.764, 94.640, 4.803, 'Jorsuur - OnGossipSelect - Teleport to Stormwind City'),
(@Entry+7, 4, 62, @GossipMenu+7, 4, 62, 0, 7, -4896.213, -964.740, 501.445, 2.541, 'Jorsuur - OnGossipSelect - Teleport to Ironforge'),
(@Entry+7, 5, 62, @GossipMenu+7, 5, 62, 1, 7, 9944.447, 2495.491, 1317.583, 4.313, 'Jorsuur - OnGossipSelect - Teleport to Darnassus'),
(@Entry+7, 6, 62, @GossipMenu+7, 6, 62, 530, 7, -3933.855, -11637.088, -138.431, 1.939, 'Jorsuur - OnGossipSelect - Teleport to Exodar'),
(@Entry+7, 7, 62, @GossipMenu+7, 7, 62, 571, 7, 5804.337, 621.452, 647.911, 1.651, 'Jorsuur - OnGossipSelect - Teleport to Dalaran');*/
