-- Emblem of Conquest
SET @emblem := 45624;

-- Ahn'kahet: The Old Kingdom
-- Elder Nadox
SET @entry := 29309;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Prince Taldaram
SET @entry := 29308;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Jedoga Shadowseeker
SET @entry := 29310;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Herald Volazj
SET @entry := 29311;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');

-- Azjol-Nerub
-- Krik'thir the Gatewatcher
SET @entry := 28684;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Hadronox
SET @entry := 28921;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Anub'arak
SET @entry := 29120;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');

-- Caverns of Time: The Culling of Stratholme
-- Meathook
SET @entry := 26529;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Salramm the Fleshcrafter
SET @entry := 26530;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Chrono-Lord Epoch
SET @entry := 26532;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Mal'Ganis 
SET @entry := 35037;
DELETE FROM `reference_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `reference_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');

-- Drak'Tharon Keep
-- Trollgore
SET @entry := 26630;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Novos the Summoner
SET @entry := 26631;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- King Dred
SET @entry := 27483;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- The Prophet Tharon'ja
SET @entry := 26632;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');

-- Gundrak
-- Slad'ran
SET @entry := 29304;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Drakkari Colossus
SET @entry := 35038;
DELETE FROM `reference_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `reference_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Moorabi
SET @entry := 29305;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Gal'darah
SET @entry := 29306;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');

-- Halls of Lightning
-- General Bjarngrim
SET @entry := 28586;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Volkhan
SET @entry := 28587;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Ionar
SET @entry := 28546;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Loken
SET @entry := 28923;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');

-- Halls of Stone
-- Maiden of Grief
SET @entry := 27975;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Krystallus
SET @entry := 27977;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- The Tribunal of Ages
SET @entry := 24661;
DELETE FROM `gameobject_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `gameobject_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Sjonnir the Ironshaper
SET @entry := 27978;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');

-- The Nexus
-- Grand Magus Telestra
SET @entry := 26731;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Anomalus
SET @entry := 26763;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Ormorok the Tree-Shaper
SET @entry := 26794;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Keristrasza
SET @entry := 26723;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');

-- The Oculus
-- Drakos the Interrogator
SET @entry := 27654;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Varos Cloudstrider
SET @entry := 27447;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Mage-Lord Urom
SET @entry := 27655;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Ley-Guardian Eregos
SET @entry := 27656;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');

-- Utgarde Keep
-- Prince Keleseth
SET @entry := 23953;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Skarvald the Constructor / Dalronn the Controller
SET @entry := 24200;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
SET @entry := 24201;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Ingvar the Plunderer
SET @entry := 23954;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');

-- Utgarde Pinnacle
-- Svala
SET @entry := 26668;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Gortok Palehoof
SET @entry := 26687;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Skadi the Ruthless
SET @entry := 26693;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- King Ymiron
SET @entry := 26861;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');

-- The Violet Hold
-- Erekem
SET @entry := 29315;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Zuramat the Obliterator
SET @entry := 29314;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Xevozz
SET @entry := 29266;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Ichoron
SET @entry := 29313;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Moragg
SET @entry := 29316;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Lavanthor
SET @entry := 29312;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 1, 1, 'Emblem of Conquest');
-- Cyanigosa
SET @entry := 31134;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, 2, 2, 'Emblem of Conquest');
