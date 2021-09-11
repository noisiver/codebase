-- Warrior
-- Set prices to zero
UPDATE `npc_trainer` SET `MoneyCost`=0 WHERE `ID` IN (200001, 200002);
-- Defensive Stance
DELETE FROM `npc_trainer` WHERE `ID`=200002 AND `SpellID`=71;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200002, 71, 0, 0, 0, 10);
-- Taunt
DELETE FROM `npc_trainer` WHERE `ID`=200002 AND `SpellID`=355;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200002, 355, 0, 0, 0, 10);
-- Sunder Armor
DELETE FROM `npc_trainer` WHERE `ID`=200002 AND `SpellID`=7386;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200002, 7386, 0, 0, 0, 10);
-- Berserker Stance
DELETE FROM `npc_trainer` WHERE `ID`=200002 AND `SpellID`=2458;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200002, 2458, 0, 0, 0, 30);
-- Intercept
DELETE FROM `npc_trainer` WHERE `ID`=200002 AND `SpellID`=20252;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200002, 20252, 0, 0, 0, 30);

-- Paladin
-- Set prices to zero
UPDATE `npc_trainer` SET `MoneyCost`=0 WHERE `ID` IN (200003, 200004, 200020, 200021);
-- Redemption
DELETE FROM `npc_trainer` WHERE `ID`=200003 AND `SpellID`=7328;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200003, 7328, 0, 0, 0, 12);
DELETE FROM `npc_trainer` WHERE `ID`=200004 AND `SpellID`=7328;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200004, 7328, 0, 0, 0, 12);

-- Hunter
-- Set prices to zero
UPDATE `npc_trainer` SET `MoneyCost`=0 WHERE `ID` IN (200013, 200014);
-- Tame Beast
DELETE FROM `npc_trainer` WHERE `ID`=200014 AND `SpellID`=1515;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200014, 1515, 0, 0, 0, 10);
-- Call Pet
DELETE FROM `npc_trainer` WHERE `ID`=200014 AND `SpellID`=883;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200014, 883, 0, 0, 0, 10);
-- Dismiss Pet
DELETE FROM `npc_trainer` WHERE `ID`=200014 AND `SpellID`=2641;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200014, 2641, 0, 0, 0, 10);
-- Revive Pet
DELETE FROM `npc_trainer` WHERE `ID`=200014 AND `SpellID`=982;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200014, 982, 0, 0, 0, 10);
-- Feed Pet
DELETE FROM `npc_trainer` WHERE `ID`=200014 AND `SpellID`=6991;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200014, 6991, 0, 0, 0, 10);

-- Rogue
-- Set prices to zero
UPDATE `npc_trainer` SET `MoneyCost`=0 WHERE `ID` IN (200015, 200016);

-- Priest
-- Set prices to zero
UPDATE `npc_trainer` SET `MoneyCost`=0 WHERE `ID` IN (200011, 200012);

-- Death Knight
-- Set prices to zero
UPDATE `npc_trainer` SET `MoneyCost`=0 WHERE `ID` IN (200019);

-- Shaman
-- Set prices to zero
UPDATE `npc_trainer` SET `MoneyCost`=0 WHERE `ID` IN (200017, 200018);
-- Stoneskin Totem
DELETE FROM `npc_trainer` WHERE `ID`=200018 AND `SpellID`=8071;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200018, 8071, 0, 0, 0, 4);
-- Searing Totem
DELETE FROM `npc_trainer` WHERE `ID`=200018 AND `SpellID`=3599;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200018, 3599, 0, 0, 0, 10);
-- Healing Stream Totem
DELETE FROM `npc_trainer` WHERE `ID`=200018 AND `SpellID`=5394;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200018, 5394, 0, 0, 0, 20);

-- Mage
-- Set prices to zero
UPDATE `npc_trainer` SET `MoneyCost`=0 WHERE `ID` IN (200007, 200008);

-- Warlock
-- Set prices to zero
UPDATE `npc_trainer` SET `MoneyCost`=0 WHERE `ID` IN (200009, 200010);
-- Summon Voidwalker
DELETE FROM `npc_trainer` WHERE `ID`=200010 AND `SpellID`=697;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200010, 697, 0, 0, 0, 10);
-- Summon Succubus
DELETE FROM `npc_trainer` WHERE `ID`=200010 AND `SpellID`=712;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200010, 712, 0, 0, 0, 20);
-- Summon Felhunter
DELETE FROM `npc_trainer` WHERE `ID`=200010 AND `SpellID`=691;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200010, 691, 0, 0, 0, 30);

-- Druid
-- Set prices to zero
UPDATE `npc_trainer` SET `MoneyCost`=0 WHERE `ID` IN (200005, 200006);
-- Bear Form
DELETE FROM `npc_trainer` WHERE `ID`=200006 AND `SpellID`=5487;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200006, 5487, 0, 0, 0, 10);
-- Growl
DELETE FROM `npc_trainer` WHERE `ID`=200006 AND `SpellID`=6795;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200006, 6795, 0, 0, 0, 10);
-- Maul
DELETE FROM `npc_trainer` WHERE `ID`=200006 AND `SpellID`=6807;
INSERT INTO `npc_trainer` (`ID`, `SpellID`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqLevel`) VALUES (200006, 6807, 0, 0, 0, 10);
