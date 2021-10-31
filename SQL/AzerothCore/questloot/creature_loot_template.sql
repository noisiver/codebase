-- Taillasher Egg (Quest: Break a Few Eggs (Id: 815))
DELETE FROM `creature_loot_template` WHERE `Entry`=3122 AND `Item`=4890;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3122, 4890, 48, 'Bloodtalon Taillasher - Taillasher Egg');
