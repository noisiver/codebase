DELETE FROM `playercreateinfo` WHERE `race`=1 AND `class`=3;
DELETE FROM `playercreateinfo` WHERE `race`=2 AND `class`=8;
DELETE FROM `playercreateinfo` WHERE `race`=3 AND `class` IN (7, 8, 9);
DELETE FROM `playercreateinfo` WHERE `race`=4 AND `class`=8;
DELETE FROM `playercreateinfo` WHERE `race`=5 AND `class`=3;
DELETE FROM `playercreateinfo` WHERE `race`=6 AND `class` IN (2, 5);
DELETE FROM `playercreateinfo` WHERE `race`=7 AND `class`=5;
DELETE FROM `playercreateinfo` WHERE `race`=8 AND `class` IN (9, 11);
DELETE FROM `playercreateinfo` WHERE `race`=10 AND `class`=1;
INSERT INTO `playercreateinfo` (`race`, `class`, `map`, `zone`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES
-- Human
(1, 3, 0, 12, -8949.95, -132.493, 83.5312, 0), -- Hunter
-- Orc
(2, 8, 1, 14, -618.518, -4251.67, 38.718, 0), -- Mage
-- Dwarf
(3, 7, 0, 1, -6240.32, 331.033, 382.758, 6.17716), -- Shaman
(3, 8, 0, 1, -6240.32, 331.033, 382.758, 6.17716), -- Mage
(3, 9, 0, 1, -6240.32, 331.033, 382.758, 6.17716), -- Warlock
-- Night Elf
(4, 8, 1, 141, 10311.3, 832.463, 1326.41, 5.69632), -- Mage
-- Undead
(5, 3, 0, 85, 1676.71, 1678.31, 121.67, 2.70526), -- Hunter
-- Tauren
(6, 2, 1, 215, -2917.58, -257.98, 52.9968, 0), -- Paladin
(6, 5, 1, 215, -2917.58, -257.98, 52.9968, 0), -- Priest
-- Gnome
(7, 5, 0, 1, -6240.32, 331.033, 382.758, 0), -- Priest
-- Troll
(8, 9, 1, 14, -618.518, -4251.67, 38.718, 0), -- Warlock
(8, 11, 1, 14, -618.518, -4251.67, 38.718, 0), -- Druid
-- Bood Elf
(10, 1, 530, 3431, 10349.6, -6357.29, 33.4026, 5.31605); -- Warrior

DELETE FROM `playercreateinfo_action` WHERE `race`=1 AND `class`=3;
DELETE FROM `playercreateinfo_action` WHERE `race`=2 AND `class`=8;
DELETE FROM `playercreateinfo_action` WHERE `race`=3 AND `class` IN (7, 8, 9);
DELETE FROM `playercreateinfo_action` WHERE `race`=4 AND `class`=8;
DELETE FROM `playercreateinfo_action` WHERE `race`=5 AND `class`=3;
DELETE FROM `playercreateinfo_action` WHERE `race`=6 AND `class` IN (2, 5);
DELETE FROM `playercreateinfo_action` WHERE `race`=7 AND `class`=5;
DELETE FROM `playercreateinfo_action` WHERE `race`=8 AND `class` IN (9, 11);
DELETE FROM `playercreateinfo_action` WHERE `race`=10 AND `class`=1;
INSERT INTO `playercreateinfo_action` (`race`, `class`, `button`, `action`, `type`) VALUES
-- Human, Hunter
(1, 3, 0, 6603, 0),
(1, 3, 1, 2973, 0),
(1, 3, 2, 75, 0),
(1, 3, 3, 59752, 0),
-- Orc, Mage
(2, 8, 0, 133, 0),
(2, 8, 1, 168, 0),
-- (2, 8, 2, 33702, 0),
-- Dwarf, Shaman
(3, 7, 0, 6603, 0),
(3, 7, 1, 403, 0),
(3, 7, 2, 331, 0),
(3, 7, 3, 20594, 0),
-- Dwarf, Mage
(3, 8, 0, 133, 0),
(3, 8, 1, 168, 0),
(3, 8, 2, 20594, 0),
-- Dwarf, Warlock
(3, 9, 0, 686, 0),
(3, 9, 1, 687, 0),
(3, 9, 2, 20594, 0),
-- Night Elf, Mage
(4, 8, 0, 133, 0),
(4, 8, 1, 168, 0),
(4, 8, 2, 58984, 0),
-- Undead, Hunter
(5, 3, 0, 6603, 0),
(5, 3, 1, 2973, 0),
(5, 3, 2, 75, 0),
(5, 3, 3, 20577, 0),
-- Tauren, Paladin
(6, 2, 0, 6603, 0),
(6, 2, 1, 21084, 0),
(6, 2, 2, 635, 0),
(6, 2, 3, 20549, 0),
-- Tauren, Priest
(6, 5, 0, 585, 0),
(6, 5, 1, 2050, 0),
(6, 5, 2, 20549, 0),
-- Gnome, Priest
(7, 5, 0, 585, 0),
(7, 5, 1, 2050, 0),
(7, 5, 2, 20589, 0),
-- Troll, Warlock
(8, 9, 0, 686, 0),
(8, 9, 1, 687, 0),
(8, 9, 2, 26297, 0),
-- Troll, Druid
(8, 11, 0, 5176, 0),
(8, 11, 1, 5185, 0),
(8, 11, 2, 26297, 0),
-- Bood Elf, Warrior
(10, 1, 0, 6603, 0),
(10, 1, 1, 78, 0),
(10, 1, 2, 50613, 0);

UPDATE `playercreateinfo_skills` SET `raceMask`=`raceMask`|1 WHERE `skill` IN (45, 46, 226);
UPDATE `playercreateinfo_skills` SET `raceMask`=`raceMask`|16 WHERE `skill` IN (45, 46, 173, 226);

DELETE FROM `creature_template` WHERE `entry` BETWEEN 110000 AND 110003;
INSERT INTO `creature_template` (`entry`, `name`, `subname`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `unit_class`, `trainer_class`, `type`) VALUES
(110000, 'Yeante Skydreamer', 'Paladin Trainer', 6647, 10, 10, 104, 51, 2, 2, 7), -- Tauren, Paladin
(110001, 'Ago Suncreek', 'Priest Trainer', 3644, 10, 10, 104, 51, 8, 5, 7), -- Tauren, Priest
(110002, 'Megan Currington', 'Hunter Trainer', 4695, 10, 10, 12, 51, 2, 3, 7), -- Human, Hunter
(110003, 'Gomok Slatebrow', 'Shaman Trainer', 7522, 10, 10, 55, 51, 8, 7, 7); -- Dwarf, Shaman

DELETE FROM `creature_template_model` WHERE `CreatureID` BETWEEN 110000 AND 110003;
INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`) VALUES
(110000, 0, 4516, 1, 1), -- Yeante Skydreamer <Paladin Trainer>
(110001, 0, 7627, 1, 1), -- Ago Suncreek <Priest Trainer>
(110002, 0, 1522, 1, 1), -- Megan Currington <Hunter Trainer>
(110003, 0, 7003, 1, 1); -- Gomok Slatebrow <Shaman Trainer>

DELETE FROM `creature` WHERE `id1` BETWEEN 110000 AND 110003;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`) VALUES
(110000, 1, -2910.19, -231.596, 53.8569, 4.88491, 300), -- Yeante Skydreamer <Paladin Trainer>
(110001, 1, -2870.28, -215.97, 54.8206, 3.96792, 300), -- Ago Suncreek <Priest Trainer>
(110002, 0, -8927.37, -153.964, 81.2517, 2.53402, 300), -- Megan Currington <Hunter Trainer>
(110003, 0, -6105.46, 401.384, 395.541, 4.79644, 300); -- Gomok Slatebrow <Shaman Trainer>

DELETE FROM `npc_trainer` WHERE `ID` BETWEEN 110000 AND 110003;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`, `ReqSpell`) VALUES
(110000, -200003, 0, 0, 0, 0, 0), -- Yeante Skydreamer <Paladin Trainer>
(110001, -200011, 0, 0, 0, 0, 0), -- Ago Suncreek <Priest Trainer>
(110002, -200013, 0, 0, 0, 0, 0), -- Megan Currington <Hunter Trainer>
(110003, -200017, 0, 0, 0, 0, 0); -- Gomok Slatebrow <Shaman Trainer>

DELETE FROM `quest_template` WHERE `ID`=31000;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `RewardXPDifficulty`, `RewardDisplaySpell`, `RewardSpell`, `Flags`, `RewardItem1`, `RewardAmount1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(31000, 2, -1, 4, -82, 5, 8071, 8073, 8, 5175, 1, 1101, 'Call of Earth', 'Slay 4 Rockjaw Raiders and then return to Gomok Slatebrow at Anvilmar in Coldridge Valley.', 'PLACEHOLDER', 'Return to Gomok Slatebrow at Anvilmar in Coldridge Valley.', 1718, 4);

DELETE FROM `quest_template_addon` WHERE `ID`=31000;
INSERT INTO `quest_template_addon` (`ID`, `AllowableClasses`) VALUES
(31000, 64);

DELETE FROM `quest_offer_reward` WHERE `ID`=31000;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(31000, 'PLACEHOLDER');

DELETE FROM `quest_request_items` WHERE `ID`=31000;
INSERT INTO `quest_request_items` (`ID`, `EmoteOnComplete`) VALUES
(31000, 1);

DELETE FROM `creature_queststarter` WHERE `quest`=31000;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES
(110003, 31000);

DELETE FROM `creature_questender` WHERE `quest`=31000;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES
(110003, 31000);
