-- Taillasher Egg (Quest: Break a Few Eggs (Id: 815))
DELETE FROM `creature_loot_template` WHERE `Entry`=3122 AND `Item`=4890;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3122, 4890, 48, 'Bloodtalon Taillasher - Taillasher Egg');

-- Sack of Supplies (Quest: Winds in the Desert (Id: 834))
DELETE FROM `creature_loot_template` WHERE `Entry`=3115 AND `Item`=4918;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3115, 4918, 36, 'Dustwind Harpy - Sack of Supplies');
DELETE FROM `creature_loot_template` WHERE `Entry`=3116 AND `Item`=4918;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3116, 4918, 36, 'Dustwind Pillager - Sack of Supplies');
