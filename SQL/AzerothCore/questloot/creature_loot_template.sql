-- Taillasher Egg (Quest: Break a Few Eggs (Id: 815))
DELETE FROM `creature_loot_template` WHERE `Entry`=3122 AND `Item`=4890;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3122, 4890, 48, 'Bloodtalon Taillasher - Taillasher Egg');

-- Sack of Supplies (Quest: Winds in the Desert (Id: 834))
DELETE FROM `creature_loot_template` WHERE `Entry`=3115 AND `Item`=4918;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3115, 4918, 36, 'Dustwind Harpy - Sack of Supplies');
DELETE FROM `creature_loot_template` WHERE `Entry`=3116 AND `Item`=4918;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3116, 4918, 35, 'Dustwind Pillager - Sack of Supplies');

-- Fungal Spores (Quest: Fungal Spores (Id: 848))
DELETE FROM `creature_loot_template` WHERE `Entry`=3461 AND `Item`=5012;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3461, 5012, 39, 'Oasis Snapjaw - Fungal Spores');

-- Nugget Slug (Quest: Nugget Slugs (Id: 3922))
DELETE FROM `creature_loot_template` WHERE `Entry`=3282 AND `Item`=11143;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3282, 11143, 41, 'Venture Co. Mercenary - Nugget Slug');
DELETE FROM `creature_loot_template` WHERE `Entry`=3284 AND `Item`=11143;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3284, 11143, 42, 'Venture Co. Drudger - Nugget Slug');

-- Gaea Seed (Quest: Cycle of Rebirth (Id: 6301))
DELETE FROM `creature_loot_template` WHERE `Entry`=4012 AND `Item`=16205;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (4012, 16205, 42, 'Pridewing Wyvern - Gaea Seed');
DELETE FROM `creature_loot_template` WHERE `Entry`=4014 AND `Item`=16205;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (4014, 16205, 43, 'Pridewing Consort - Gaea Seed');
DELETE FROM `creature_loot_template` WHERE `Entry`=6141 AND `Item`=16205;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (6141, 16205, 44, 'Pridewing Soarer - Gaea Seed');

-- Troll Charm (Quest: Troll Charm (Id: 6462))
DELETE FROM `creature_loot_template` WHERE `Entry`=3921 AND `Item`=16602;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3921, 16602, 39, 'Thistlefur Ursa - Troll Charm');
DELETE FROM `creature_loot_template` WHERE `Entry`=3922 AND `Item`=16602;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3922, 16602, 40, 'Thistlefur Totemic - Troll Charm');
DELETE FROM `creature_loot_template` WHERE `Entry`=3923 AND `Item`=16602;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (3923, 16602, 38, 'Thistlefur Den Watcher - Troll Charm');

-- Mudsnout Blossoms (Quest: Elixir of Agony (Id: 509))
DELETE FROM `creature_loot_template` WHERE `Entry`=2372 AND `Item`=3502;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (2372, 3502, 46, 'Mudsnout Gnoll - Mudsnout Blossoms');
DELETE FROM `creature_loot_template` WHERE `Entry`=2373 AND `Item`=3502;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (2373, 3502, 48, 'Mudsnout Shaman - Mudsnout Blossoms');

-- Highperch Wyvern Egg (Quest: Wind Rider (Id: 4767))
DELETE FROM `creature_loot_template` WHERE `Entry`=4107 AND `Item`=12356;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (4107, 12356, 41, 'Highperch Wyvern - Highperch Wyvern Egg');
DELETE FROM `creature_loot_template` WHERE `Entry`=4109 AND `Item`=12356;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (4109, 12356, 43, 'Highperch Consort - Highperch Wyvern Egg');
DELETE FROM `creature_loot_template` WHERE `Entry`=4110 AND `Item`=12356;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (4110, 12356, 44, 'Highperch Patriarch - Highperch Wyvern Egg');

-- Incendia Agave (Quest: Sacred Fire (Id: 5062))
DELETE FROM `creature_loot_template` WHERE `Entry`=10756 AND `Item`=12732;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (10756, 12732, 42, 'Scalding Elemental - Incendia Agave');
DELETE FROM `creature_loot_template` WHERE `Entry`=10757 AND `Item`=12732;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (10757, 12732, 44, 'Boiling Elemental - Incendia Agave');

-- Witchbane (Quest: The Witch's Bane (11181))
UPDATE `creature_loot_template` SET `Chance`=43 WHERE `Entry`=23554 AND `Item`=33112;
UPDATE `creature_loot_template` SET `Chance`=46 WHERE `Entry`=23555 AND `Item`=33112;
