-- Emblem of Heroism
SET
@emblemName := 'Emblem of Heroism',
@emblem := 40752,
@bossAmount := 1,
@finalBossAmount := 2;

-- Ahn'kahet: The Old Kingdom
-- Elder Nadox
SET @entry := 29309;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Prince Taldaram
SET @entry := 29308;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Jedoga Shadowseeker
SET @entry := 29310;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Herald Volazj
SET @entry := 29311;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);

-- Azjol-Nerub
-- Krik'thir the Gatewatcher
SET @entry := 28684;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Hadronox
SET @entry := 28921;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Anub'arak
SET @entry := 29120;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);

-- Caverns of Time: The Culling of Stratholme
-- Meathook
SET @entry := 26529;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Salramm the Fleshcrafter
SET @entry := 26530;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Chrono-Lord Epoch
SET @entry := 26532;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Mal'Ganis 
SET @entry := 35037;
DELETE FROM `reference_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `reference_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);

-- Drak'Tharon Keep
-- Trollgore
SET @entry := 26630;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Novos the Summoner
SET @entry := 26631;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- King Dred
SET @entry := 27483;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- The Prophet Tharon'ja
SET @entry := 26632;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);

-- Gundrak
-- Slad'ran
SET @entry := 29304;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Drakkari Colossus
SET @entry := 35038;
DELETE FROM `reference_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `reference_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Moorabi
SET @entry := 29305;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Gal'darah
SET @entry := 29306;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);

-- Halls of Lightning
-- General Bjarngrim
SET @entry := 28586;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Volkhan
SET @entry := 28587;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Ionar
SET @entry := 28546;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Loken
SET @entry := 28923;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);

-- Halls of Stone
-- Maiden of Grief
SET @entry := 27975;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Krystallus
SET @entry := 27977;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- The Tribunal of Ages
SET @entry := 24661;
DELETE FROM `gameobject_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `gameobject_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Sjonnir the Ironshaper
SET @entry := 27978;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);

-- The Nexus
-- Grand Magus Telestra
SET @entry := 26731;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Anomalus
SET @entry := 26763;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Ormorok the Tree-Shaper
SET @entry := 26794;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Keristrasza
SET @entry := 26723;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);

-- The Oculus
-- Drakos the Interrogator
SET @entry := 27654;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Varos Cloudstrider
SET @entry := 27447;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Mage-Lord Urom
SET @entry := 27655;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Ley-Guardian Eregos
SET @entry := 27656;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);

-- Utgarde Keep
-- Prince Keleseth
SET @entry := 23953;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Skarvald the Constructor / Dalronn the Controller
SET @entry := 24200;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
SET @entry := 24201;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Ingvar the Plunderer
SET @entry := 23954;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);

-- Utgarde Pinnacle
-- Svala
SET @entry := 26668;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Gortok Palehoof
SET @entry := 26687;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Skadi the Ruthless
SET @entry := 26693;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- King Ymiron
SET @entry := 26861;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);

-- The Violet Hold
-- Erekem
SET @entry := 29315;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Zuramat the Obliterator
SET @entry := 29314;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Xevozz
SET @entry := 29266;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Ichoron
SET @entry := 29313;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Moragg
SET @entry := 29316;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Lavanthor
SET @entry := 29312;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @bossAmount, @bossAmount, @emblemName);
-- Cyanigosa
SET @entry := 31134;
DELETE FROM `creature_loot_template` WHERE `Entry`=@entry AND `Item`=@emblem;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Chance`, `MinCount`, `MaxCount`, `Comment`) VALUES (@entry, @emblem, 100, @finalBossAmount, @finalBossAmount, @emblemName);
