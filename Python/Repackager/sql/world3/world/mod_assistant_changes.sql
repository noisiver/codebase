SET @Entry := 9000000;

DELETE FROM `npc_vendor` WHERE `entry`=@Entry+45 AND `item` IN (2662, 4500, 23162);
INSERT INTO `npc_vendor` (`entry`, `item`) VALUES
-- Container
(@Entry+45, 2662), -- Ribbly's Quiver
(@Entry+45, 4500), -- Traveler's Backpack
(@Entry+45, 23162); -- Foror's Crate of Endless Resist Gear Storage
