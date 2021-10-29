-- Book of Runes Chapter 1, 2, 3
UPDATE `item_template` SET `Flags`=3136 WHERE `entry` IN (33778, 33779, 33780);
-- Golem Blueprint Section 1, 2, 3
UPDATE `item_template` SET `Flags`=3136 WHERE `entry` IN (36849, 36850, 36851);
-- Grizzly Hide
UPDATE `item_template` SET `Flags`=2048 WHERE `entry`=37020;
-- Grizzly Flank
UPDATE `item_template` SET `Flags`=2048 WHERE `entry`=37200;
-- Demonic Rune Stone
UPDATE `item_template` SET `Flags`=2048 WHERE `entry`=28513;
-- Bleeding Hollow Blood
UPDATE `item_template` SET `Flags`=2112 WHERE `entry`=30425;
-- Shredder Operating Manual
UPDATE `item_template` SET `Flags`=3136 WHERE `entry` IN (16645, 16646, 16647, 16648, 16649, 16650, 16651, 16652, 16653, 16654, 16655, 16656);
-- Icetip Venom Sac
UPDATE `item_template` SET `Flags`=67840 WHERE `entry`=40944;
-- Sunscale Feather
UPDATE `item_template` SET `Flags`=2112 WHERE `entry`=5165;
-- Charred Razormane Wand
UPDATE `item_template` SET `Flags`=2048 WHERE `entry`=5092;
-- Razormane Backstabber
UPDATE `item_template` SET `Flags`=2048 WHERE `entry`=5093;
-- Razormane War Shield
UPDATE `item_template` SET `Flags`=2048 WHERE `entry`=5094;
-- Uncured Caribou Hide
UPDATE `item_template` SET `Flags`=3136 WHERE `entry`=35288;
-- Black Blood of Yogg-Saron Sample
UPDATE `item_template` SET `Flags`=67584 WHERE `entry`=36725;
-- Sweetroot
UPDATE `item_template` SET `Flags`=67584 WHERE `entry`=37087;
-- Vordrassil's Seed
UPDATE `item_template` SET `Flags`=2048 WHERE `entry`=37302;
-- Missing Journal Page
UPDATE `item_template` SET `Flags`=3136 WHERE `entry`=35737;
-- Haze Leaf
UPDATE `item_template` SET `Flags`=67584 WHERE `entry`=37085;
-- Banana Bunch
UPDATE `item_template` SET `Flags`=2048 WHERE `entry`=38653;
-- Papaya
UPDATE `item_template` SET `Flags`=67584 WHERE `entry`=38655;
-- Orange
UPDATE `item_template` SET `Flags`=2048 WHERE `entry`=38656;
-- Venture Co. Spare Parts
UPDATE `item_template` SET `Flags`=2048 WHERE `entry`=38349;

-- Ruby Lilac
UPDATE `gameobject` SET `spawntimesecs`=1 WHERE `id`=188489;

-- Gurgleboggle's Bauble
UPDATE `gameobject` SET `spawntimesecs`=1 WHERE `id`=187885;
-- Burblegobble's Bauble
UPDATE `gameobject` SET `spawntimesecs`=1 WHERE `id`=187886;

-- Flying Machine Engine
UPDATE `gameobject` SET `spawntimesecs`=1 WHERE `id`=190447;

-- Warsong Munitions
UPDATE `creature_loot_template` SET `Chance`=38 WHERE `Entry`=24566 AND `Item`=34709;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=24566 AND `ItemId`=34709;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (24566, 0, 34709);
UPDATE `creature_loot_template` SET `Chance`=38 WHERE `Entry`=25294 AND `Item`=34709;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25294 AND `ItemId`=34709;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25294, 1, 34709);
UPDATE `creature_loot_template` SET `Chance`=38 WHERE `Entry`=25445 AND `Item`=34709;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25445 AND `ItemId`=34709;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25445, 1, 34709);

-- Super Strong Metal Plate
UPDATE `creature_loot_template` SET `Chance`=35 WHERE `Entry`=25496 AND `Item`=34786;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25496 AND `ItemId`=34786;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25496, 2, 34786);

-- Bloodspore Carpel
UPDATE `creature_loot_template` SET `Chance`=36 WHERE `Entry`=25468 AND `Item`=34974;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25468 AND `ItemId`=34974;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25468, 0, 34974);

-- Fizzcrank Spare Parts
UPDATE `creature_loot_template` SET `Chance`=43 WHERE `Entry`=25752 AND `Item`=34972;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25752 AND `ItemId`=34972;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25752, 0, 34972);
UPDATE `creature_loot_template` SET `Chance`=43 WHERE `Entry`=25753 AND `Item`=34972;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25753 AND `ItemId`=34972;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25753, 0, 34972);
UPDATE `creature_loot_template` SET `Chance`=43 WHERE `Entry`=25758 AND `Item`=34972;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25758 AND `ItemId`=34972;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25758, 0, 34972);
UPDATE `creature_loot_template` SET `Chance`=43 WHERE `Entry`=25814 AND `Item`=34972;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25814 AND `ItemId`=34972;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25814, 0, 34972);

-- Scourged Earth
UPDATE `creature_loot_template` SET `Chance`=48 WHERE `Entry`=26202 AND `Item`=34774;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=26202 AND `ItemId`=34774;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (26202, 1, 34774);
UPDATE `creature_loot_template` SET `Chance`=48 WHERE `Entry`=25700 AND `Item`=34774;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25700 AND `ItemId`=34774;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25700, 1, 34774);
UPDATE `creature_loot_template` SET `Chance`=48 WHERE `Entry`=25701 AND `Item`=34774;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25701 AND `ItemId`=34774;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25701, 1, 34774);

-- Frostberry
UPDATE `creature_loot_template` SET `Chance`=44 WHERE `Entry`=25707 AND `Item`=35492;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25707 AND `ItemId`=35492;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25707, 2, 35492);
UPDATE `creature_loot_template` SET `Chance`=44 WHERE `Entry`=25717 AND `Item`=35492;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25717 AND `ItemId`=35492;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25717, 0, 35492);
UPDATE `creature_loot_template` SET `Chance`=44 WHERE `Entry`=25722 AND `Item`=35492;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25722 AND `ItemId`=35492;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25722, 0, 35492);
UPDATE `creature_loot_template` SET `Chance`=44 WHERE `Entry`=25728 AND `Item`=35492;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=25728 AND `ItemId`=35492;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (25728, 1, 35492);

-- Black Blood of Yogg-Saron Sample
DELETE FROM `creature_loot_template` WHERE `Entry`=26605 AND `Item`=36725;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (26605, 36725, 40, 'Anub\'ar Underlord - Black Blood of Yogg-Saron Sample');
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=26605 AND `ItemId`=36725;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (26605, 2, 36725);

-- Scarlet Onslaught Weapon
UPDATE `creature_loot_template` SET `Chance`=54 WHERE `Entry`=27207 AND `Item`=37137;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=27207 AND `ItemId`=37137;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (27207, 0, 37137);
UPDATE `creature_loot_template` SET `Chance`=54 WHERE `Entry`=27234 AND `Item`=37137;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=27234 AND `ItemId`=37137;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (27234, 0, 37137);

-- Scarlet Onslaught Armor
UPDATE `creature_loot_template` SET `Chance`=42 WHERE `Entry`=27203 AND `Item`=37136;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=27203 AND `ItemId`=37136;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (27203, 0, 37136);
UPDATE `creature_loot_template` SET `Chance`=42 WHERE `Entry`=27206 AND `Item`=37136;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=27206 AND `ItemId`=37136;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (27206, 1, 37136);

-- Forgotten Treasure
UPDATE `creature_loot_template` SET `Chance`=49 WHERE `Entry`=27226 AND `Item`=37580;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=27226 AND `ItemId`=37580;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (27226, 2, 37580);

-- Emerald Dragon Tier
UPDATE `creature_loot_template` SET `Chance`=46 WHERE `Entry`=27254 AND `Item`=37124;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=27254 AND `ItemId`=37124;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (27254, 2, 37124);

-- Vordrassil's Seed
DELETE FROM `creature_loot_template` WHERE `Entry`=26605 AND `Item`=37302;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (26605, 37302, 38, 'Redfang Hunter - Vordrassil\'s Seed');
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=26605 AND `ItemId`=37302;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (26605, 4, 37302);
DELETE FROM `creature_loot_template` WHERE `Entry`=26357 AND `Item`=37302;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (26357, 37302, 38, 'Frostpaw Warrior - Vordrassil\'s Seed');
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=26357 AND `ItemId`=37302;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (26357, 1, 37302);

-- Sweetroot
DELETE FROM `creature_loot_template` WHERE `Entry`=26457 AND `Item`=37087;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (26457, 37087, 36, 'Diseased Drakkari - Sweetroot');
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=26457 AND `ItemId`=37087;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (26457, 1, 37087);

-- Shimmering Snowcap
UPDATE `creature_loot_template` SET `Chance`=42 WHERE `Entry`=26446 AND `Item`=35782;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=26446 AND `ItemId`=35782;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (26446, 1, 35782);

-- Missing Journal Page
DELETE FROM `creature_loot_template` WHERE `Entry`=26284 AND `Item`=35737;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (26284, 35737, 38, 'Runic Battle Golem - Missing Journal Page');
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=26284 AND `ItemId`=35737;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (26284, 1, 35737);
DELETE FROM `creature_loot_template` WHERE `Entry`=26268 AND `Item`=35737;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (26268, 35737, 39, 'Rune Reaver - Missing Journal Page');
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=26268 AND `ItemId`=35737;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (26268, 2, 35737);

-- War Golem Part
UPDATE `creature_loot_template` SET `Chance`=37 WHERE `Entry`=26347 AND `Item`=36852;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=26347 AND `ItemId`=36852;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (26347, 2, 36852);
UPDATE `creature_loot_template` SET `Chance`=38 WHERE `Entry`=26408 AND `Item`=36852;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=26408 AND `ItemId`=36852;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (26408, 4, 36852);
UPDATE `creature_loot_template` SET `Chance`=36 WHERE `Entry`=26409 AND `Item`=36852;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=26409 AND `ItemId`=36852;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (26409, 3, 36852);

-- Waterweed Frond
UPDATE `creature_loot_template` SET `Chance`=46 WHERE `Entry`=27617 AND `Item`=35795;
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=27617 AND `ItemId`=35795;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (27617, 0, 35795);

-- Haze Leaf
DELETE FROM `creature_loot_template` WHERE `Entry`=27617 AND `Item`=37085;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (27617, 37085, 41, 'River Thresher - Haze Leaf');
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=27617 AND `ItemId`=37085;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (27617, 1, 37085);

-- Banana Bunch
DELETE FROM `creature_loot_template` WHERE `Entry`=28011 AND `Item`=38653;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (28011, 38653, 26, 'Emperor Cobra - Banana Bunch');
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=28011 AND `ItemId`=38653;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (28011, 2, 38653);

-- Papaya
DELETE FROM `creature_loot_template` WHERE `Entry`=28011 AND `Item`=38655;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (28011, 38655, 22, 'Emperor Cobra - Papaya');
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=28011 AND `ItemId`=38655;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (28011, 3, 38655);

-- Orange
DELETE FROM `creature_loot_template` WHERE `Entry`=28011 AND `Item`=38656;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (28011, 38656, 22, 'Emperor Cobra - Orange');
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=28011 AND `ItemId`=38656;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (28011, 4, 38656);

-- Venture Co. Spare Parts
DELETE FROM `creature_loot_template` WHERE `Entry`=28123 AND `Item`=38349;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `Comment`) VALUES (28123, 38349, 43, 'Venture Co. Excavator - Venture Co. Spare Parts');
DELETE FROM `creature_questitem` WHERE `CreatureEntry`=28123 AND `ItemId`=38349;
INSERT INTO `creature_questitem` (`CreatureEntry`, `Idx`, `ItemId`) VALUES (28123, 2, 38349);
