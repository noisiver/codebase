/*
To remove everything, run these queries
SET
@Entry := 5000000,
@QuestId := 50000;
DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (5723, 5728, 5761, 14356, 166, 2040, 914, 962, 1486, 1487, 1013, 1014, 1199, 1200, 6561, 6565, 6921, 377, 378, 386, 387, 391, 1101, 1102, 1109, 2924, 2928, 2929, 1053, 14355, 1049, 1050, 3341, 3636, 2768, 2770, 2846, 2865, 3042, 7064, 7065, 1445, 1446, 3907, 4003, 4063, 4081, 4082, 4123, 4126, 4132, 4134, 4136, 4263, 4286, 4362, 7201, 7441, 7488, 7489);
DELETE FROM `creature` WHERE `id1` BETWEEN @Entry AND @Entry+16;
DELETE FROM `creature_template` WHERE `entry` BETWEEN @Entry AND @Entry+16;
DELETE FROM `quest_template` WHERE `ID` BETWEEN @QuestId AND @QuestId+63;
DELETE FROM `quest_request_items` WHERE `ID` BETWEEN @QuestId AND @QuestId+63;
DELETE FROM `quest_offer_reward` WHERE `ID` BETWEEN @QuestId AND @QuestId+63;
DELETE FROM `creature_queststarter` WHERE `quest` BETWEEN @QuestId AND @QuestId+63;
DELETE FROM `creature_questender` WHERE `quest` BETWEEN @QuestId AND @QuestId+63;
*/

DELETE FROM `disables` WHERE `sourceType`=1 AND `entry` IN (5723, 5728, 5761, 14356, 166, 2040, 914, 962, 1486, 1487, 1013, 1014, 1199, 1200, 6561, 6565, 6921, 377, 378, 386, 387, 391, 1101, 1102, 1109, 2924, 2928, 2929, 1053, 14355, 1049, 1050, 3341, 3636, 2768, 2770, 2846, 2865, 3042, 7064, 7065, 1445, 1446, 3907, 4003, 4063, 4081, 4082, 4123, 4126, 4132, 4134, 4136, 4263, 4286, 4362, 7201, 7441, 7488, 7489);
INSERT INTO `disables` (`sourceType`, `entry`, `comment`) VALUES
-- Ragefire Chasm
(1, 5723, 'Disabled quest for custom dungeon quests'),
(1, 5728, 'Disabled quest for custom dungeon quests'),
(1, 5761, 'Disabled quest for custom dungeon quests'),
(1, 14356, 'Disabled quest for custom dungeon quests'),
-- The Deadmines
(1, 166, 'Disabled quest for custom dungeon quests'),
(1, 2040, 'Disabled quest for custom dungeon quests'),
-- Wailing Caverns
(1, 914, 'Disabled quest for custom dungeon quests'),
(1, 962, 'Disabled quest for custom dungeon quests'),
(1, 1486, 'Disabled quest for custom dungeon quests'),
(1, 1487, 'Disabled quest for custom dungeon quests'),
-- Shadowfang Keep
(1, 1013, 'Disabled quest for custom dungeon quests'),
(1, 1014, 'Disabled quest for custom dungeon quests'),
-- Blackfathom Deeps
(1, 1199, 'Disabled quest for custom dungeon quests'),
(1, 1200, 'Disabled quest for custom dungeon quests'),
(1, 6561, 'Disabled quest for custom dungeon quests'),
(1, 6565, 'Disabled quest for custom dungeon quests'),
(1, 6921, 'Disabled quest for custom dungeon quests'),
-- The Stockade
(1, 377, 'Disabled quest for custom dungeon quests'),
(1, 378, 'Disabled quest for custom dungeon quests'),
(1, 386, 'Disabled quest for custom dungeon quests'),
(1, 387, 'Disabled quest for custom dungeon quests'),
(1, 391, 'Disabled quest for custom dungeon quests'),
-- Razorfen Kraul
(1, 1101, 'Disabled quest for custom dungeon quests'),
(1, 1102, 'Disabled quest for custom dungeon quests'),
(1, 1109, 'Disabled quest for custom dungeon quests'),
-- Gnomeregan
(1, 2924, 'Disabled quest for custom dungeon quests'),
(1, 2928, 'Disabled quest for custom dungeon quests'),
(1, 2929, 'Disabled quest for custom dungeon quests'),
-- Scarlet Monastery (Cathedral)
(1, 1053, 'Disabled quest for custom dungeon quests'),
(1, 14355, 'Disabled quest for custom dungeon quests'),
-- Scarlet Monastery (Library)
(1, 1049, 'Disabled quest for custom dungeon quests'),
(1, 1050, 'Disabled quest for custom dungeon quests'),
-- Razorfen Downs
(1, 3341, 'Disabled quest for custom dungeon quests'),
(1, 3636, 'Disabled quest for custom dungeon quests'),
-- Zul'Farrak
(1, 2768, 'Disabled quest for custom dungeon quests'),
(1, 2770, 'Disabled quest for custom dungeon quests'),
(1, 2846, 'Disabled quest for custom dungeon quests'),
(1, 2865, 'Disabled quest for custom dungeon quests'),
(1, 3042, 'Disabled quest for custom dungeon quests'),
-- Maraudon
(1, 7064, 'Disabled quest for custom dungeon quests'),
(1, 7065, 'Disabled quest for custom dungeon quests'),
-- Sunken Temple
(1, 1445, 'Disabled quest for custom dungeon quests'),
(1, 1446, 'Disabled quest for custom dungeon quests'),
-- Blackrock Depths
(1, 3907, 'Disabled quest for custom dungeon quests'),
(1, 4003, 'Disabled quest for custom dungeon quests'),
(1, 4063, 'Disabled quest for custom dungeon quests'),
(1, 4081, 'Disabled quest for custom dungeon quests'),
(1, 4082, 'Disabled quest for custom dungeon quests'),
(1, 4123, 'Disabled quest for custom dungeon quests'),
(1, 4126, 'Disabled quest for custom dungeon quests'),
(1, 4132, 'Disabled quest for custom dungeon quests'),
(1, 4134, 'Disabled quest for custom dungeon quests'),
(1, 4136, 'Disabled quest for custom dungeon quests'),
(1, 4263, 'Disabled quest for custom dungeon quests'),
(1, 4286, 'Disabled quest for custom dungeon quests'),
(1, 4362, 'Disabled quest for custom dungeon quests'),
(1, 7201, 'Disabled quest for custom dungeon quests'),
-- Dire Maul (East)
(1, 7441, 'Disabled quest for custom dungeon quests'),
(1, 7488, 'Disabled quest for custom dungeon quests'),
(1, 7489, 'Disabled quest for custom dungeon quests');

SET
@QuestId         := 50000,
@QuestType       := 2,
@QuestInfoID     := 81,
@QuestFlags      := 8,
@Entry           := 5000000,
@Title           := '',
@Icon            := 'Speak',
@GossipMenu      := 0,
@NPCFlag         := 3,
@Scale           := 1.0,
@TypeFlags       := 0,
@FlagsExtra      := 2,
@Rank            := 1,
@UnitFlags       := 768,
@Type            := 7,
@FactionHorde    := 83,
@FactionAlliance := 84,
@FactionFriendly := 35;

-- Ragefire Chasm: Groggarg
SET
@Model    := 6873,
@Name     := 'Groggarg',
@MinLevel := 16,
@MaxLevel := 16;

DELETE FROM `creature_template` WHERE `entry`=@Entry;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionHorde, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry, 389, 5.11779, -27.0224, -21.0126, 1.78636);

SET
@QuestLevel                     := 16,
@QuestMinLevel                  := 9,
@QuestSortID                    := 2437,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 700,
@QuestRewardBonusMoney          := 960,
@QuestRewardFactionId1          := 76,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Testing an Enemy\'s Strength',
@QuestLogDescription            := 'Kill 8 Ragefire Troggs and 8 Ragefire Shaman before returning to Groggarg.',
@QuestDescription               := 'Within Ragefire Chasm, stout creatures known as troggs started coming to the surface from deep below the lava filled tunnels. In her ever-benevolence, Magatha sought to make peace with the creatures, but they turned on her diplomats, killing them. She will not allow such treatment of the tauren people and now consider the creatures a threat to all of the Horde.$B$BShe asks that you put an end to this trogg threat before it overwhelms the Horde from below. Find and destroy them all.',
@QuestCompletionLog             := 'Return to Groggarg.',
@QuestRequiredNpcOrGo1          := 11318,
@QuestRequiredNpcOrGo2          := 11319,
@QuestRequiredNpcOrGoCount1     := 8,
@QuestRequiredNpcOrGoCount2     := 8,

@QuestRequestitems              := 'How goes your search for the troggs?$B$BThe threat cannot be allowed to persist--it will only injure our orc brethren if it continues.',
@QuestRewardText                := 'I am glad to see you took Magatha\'s task seriously. Thank you, $N. I\'m sure the troggs will have a harder time coming to the surface with their numbers so greatly reduced.$B$BPerhaps in the future we can take time to figure out where such creatures came from, and what they really want.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardFactionId1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGo2`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGoCount2`) VALUES
(@QuestId, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGo2, @QuestRequiredNpcOrGoCount1, @QuestRequiredNpcOrGoCount2);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry AND `quest`=@QuestId;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry, @QuestId);

DELETE FROM `creature_questender` WHERE `id`=@Entry AND `quest`=@QuestId;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry, @QuestId);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId, @QuestRewardText);

SET
@QuestLevel                     := 16,
@QuestMinLevel                  := 9,
@QuestSortID                    := 2437,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 800,
@QuestRewardBonusMoney          := 1080,
@QuestRewardFactionId1          := 76,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Hidden Enemies',
@QuestLogDescription            := 'Kill Bazzalan and Jergosh the Invoker before returning to Groggarg.',
@QuestDescription               := 'Hmm, leaders of the Searing Blade... this concerns me most. If they are the ones of value to Neeru, then those are who we must target first. This satyr... Bazzalan, and the other Neeru mentioned--what was he, a warlock?--must be slain.$B$BFind these two leaders of the Searing Blade, and kill them. But be careful not to let Neeru know it was you who did this. You must retain your identity as one of his $gbrothers:sisters; in arms.',
@QuestCompletionLog             := 'Return to Groggarg.',
@QuestRequiredNpcOrGo1          := 11519,
@QuestRequiredNpcOrGo2          := 11518,
@QuestRequiredNpcOrGoCount1     := 1,
@QuestRequiredNpcOrGoCount2     := 1,

@QuestRequestitems              := 'Have you found them yet, $N? The leaders of the Searing Blade.$b$bI knew the Shadow Council sought to take Orgrimmar and all of the Horde from me, but I hadn\'t realized how quickly they were able to infiltrate the city. So many arms this beast has... we can cut them off until exhaustion sets in, but we will be no further than when we started. I will have to have my spies double their efforts.',
@QuestRewardText                := 'I am glad you\'ve returned, $N. Some of those loyal to me brought word immediately that the caverns below Orgrimmar were in disarray now that their leaders have been slain. I even heard reports that Neeru was more than agitated. It seems we\'ve put a dent in his armor. I can\'t say I\'m displeased... even with such a minor victory.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+1;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardFactionId1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGo2`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGoCount2`) VALUES
(@QuestId+1, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGo2, @QuestRequiredNpcOrGoCount1, @QuestRequiredNpcOrGoCount2);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry AND `quest`=@QuestId+1;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry, @QuestId+1);

DELETE FROM `creature_questender` WHERE `id`=@Entry AND `quest`=@QuestId+1;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry, @QuestId+1);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+1;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+1, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+1;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+1, @QuestRewardText);

SET
@QuestLevel                     := 16,
@QuestMinLevel                  := 9,
@QuestSortID                    := 2437,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 800,
@QuestRewardBonusMoney          := 1080,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Slaying the Beast',
@QuestLogDescription            := 'Slay Taragaman the Hungerer, then bring his heart back to Groggarg.',
@QuestDescription               := 'The primary task set upon me by our great Warchief is to root out the creatures responsible for infesting our lord\'s great city with demonic influence. The Burning Blade is one threat, but there are others; the Searing Blade for instance, who make their home in Ragefire Chasm, secretly attempting to subvert innocent members of the Horde.$B$BIf they are to be stopped, then their leader must be slain--a Felguard named Taragaman the Hungerer.$B$BKill him, and his heart will appease Thrall, of this I\'m sure.',
@QuestCompletionLog             := 'Return to Groggarg.',
@QuestRequiredItemId1           := 14540,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Have you killed the beast? He surely must be the leader of the Searing Blade in Ragefire Chasm.',
@QuestRewardText                := 'Ha! You\'ve done it! Thrall will be so pleased.$b$bI will ensure this heart is taken care of properly.$b$bFor now though, you must celebrate your victory. I will inform Thrall of your success.$b$bThank you for your aid, $c.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+2;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+2, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry AND `quest`=@QuestId+2;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry, @QuestId+2);

DELETE FROM `creature_questender` WHERE `id`=@Entry AND `quest`=@QuestId+2;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry, @QuestId+2);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+2;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+2, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+2;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+2, @QuestRewardText);

SET
@QuestLevel                     := 16,
@QuestMinLevel                  := 9,
@QuestSortID                    := 2437,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1080,
@QuestRewardChoiceItemID1       := 15449,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 15450,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 15451,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestRewardFactionId1          := 76,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'The Power to Destroy...',
@QuestLogDescription            := 'Bring the books Spells of Shadow and Incantations from the Nether to Groggarg.',
@QuestDescription               := 'Listen up, $c.$b$bYou may not know this, but Orgrimmar\'s got a problem. A sect of the Shadow Council called the Searing Blade performs their sinister work. They\'re mainly orcs, and I can\'t trust sensitive information in the hands of the grunts there. That\'s where you come in.$b$bThey should have two books in their possession. I want them kept out of the hands of the Searing Blade and the Forsaken alike. Bring them to me directly.',
@QuestCompletionLog             := 'Return to Groggarg.',
@QuestRequiredItemId1           := 14395,
@QuestRequiredItemId2           := 14396,
@QuestRequiredItemCount1        := 1,
@QuestRequiredItemCount2        := 1,

@QuestRequestitems              := 'Did you secure the books? They need to be kept out of the wrong hands.',
@QuestRewardText                := 'Good, $c. You\'ve done well. I\'ll keep these safe from prying eyes; the last thing we need is a strong Shadow Council rising up again.$B$BCheck back with me in the future; there\'s always something that needs doing around here, apparently, and I might need another able body.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+3;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `Flags`, `RewardFactionId1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemId2`, `RequiredItemCount1`, `RequiredItemCount2`) VALUES
(@QuestId+3, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemId2, @QuestRequiredItemCount1, @QuestRequiredItemCount2);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry AND `quest`=@QuestId+3;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry, @QuestId+3);

DELETE FROM `creature_questender` WHERE `id`=@Entry AND `quest`=@QuestId+3;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry, @QuestId+3);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+3;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+3, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+3;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+3, @QuestRewardText);

-- The Deadmines: Bradly Stanford
SET
@Model    := 1504,
@Name     := 'Bradly Stanford',
@MinLevel := 20,
@MaxLevel := 20;

DELETE FROM `creature_template` WHERE `entry`=@Entry+1;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+1, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionAlliance, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+1;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+1, 36, -11.1909, -375.448, 61.1099, 3.71272);

SET
@QuestLevel                     := 22,
@QuestMinLevel                  := 14,
@QuestSortID                    := 1581,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1560,
@QuestRewardChoiceItemID1       := 6087,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 2041,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 2042,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestRewardFactionId1          := 72,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'The Defias Brotherhood',
@QuestLogDescription            := 'Kill Edwin VanCleef and bring his head to Bradly Stanford.',
@QuestDescription               := 'There is but one task left for you to complete.  Edwin VanCleef must be assassinated.  While it saddens me to condemn any man to a death sentence, it is for the greater good of the people of Westfall that VanCleef is laid to rest once and for all.  Bring me the villain\'s head once the deed is done.',
@QuestCompletionLog             := 'Return to Bradly Stanford.',
@QuestRequiredItemId1           := 3637,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'How goes the hunt for Edwin VanCleef?',
@QuestRewardText                := '$N, your bravery is remarkable. The People\'s Militia thanks you for your service to the people of Westfall. With VanCleef dead, this marks the beginning of the end for the Defias Brotherhood. Hopefully some day soon peace will once again grace the plains of this fair land.$B$BI salute you, $gLord:Lady;!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+4;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `Flags`, `RewardFactionId1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+4, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+1 AND `quest`=@QuestId+4;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+1, @QuestId+4);

DELETE FROM `creature_questender` WHERE `id`=@Entry+1 AND `quest`=@QuestId+4;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+1, @QuestId+4);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+4;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+4, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+4;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+4, @QuestRewardText);

SET
@QuestLevel                     := 20,
@QuestMinLevel                  := 15,
@QuestSortID                    := 1581,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1440,
@QuestRewardChoiceItemID1       := 7606,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 7607,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 72,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Underground Assault',
@QuestLogDescription            := 'Retrieve the Gnoam Sprecklesprocket and return it to Bradly Stanford.',
@QuestDescription               := 'Gnomeregan has fallen under the control of those dastardly troggs! The situation is grave but perhaps you can help, $N.$B$BDeep in the Deadmines is a functional goblin shredder. Find that shredder and bring back the intact power supply. With the shredder\'s power supply, we can give our gyrodrillmatic excavationators the power they need to break through the rocky underground borders of Gnomeregan, opening the way for a gnomish assault!',
@QuestCompletionLog             := 'Return to Bradly Stanford.',
@QuestRequiredItemId1           := 7365,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Have you found the Gnoam Sprecklesprocket, $N?',
@QuestRewardText                := 'Well done, $N. Thanks to you, Gnomeregan is one step closer to its day of liberation!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+5;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `Flags`, `RewardFactionId1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+5, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+1 AND `quest`=@QuestId+5;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+1, @QuestId+5);

DELETE FROM `creature_questender` WHERE `id`=@Entry+1 AND `quest`=@QuestId+5;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+1, @QuestId+5);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+5;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+5, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+5;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+5, @QuestRewardText);

-- Wailing Caverns: Lynasha
SET
@Model    := 4290,
@Name     := 'Lynasha',
@MinLevel := 20,
@MaxLevel := 20;

DELETE FROM `creature_template` WHERE `entry`=@Entry+2;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+2, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+2;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+2, 43, -146.196, 122.073, -76.7319, 1.64649);

SET
@QuestLevel                     := 22,
@QuestMinLevel                  := 10,
@QuestSortID                    := 718,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1560,
@QuestRewardChoiceItemID1       := 6505,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 6504,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 81,
@QuestRewardFactionValue1       := 0,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Leaders of the Fang',
@QuestLogDescription            := 'Bring the Gems of Cobrahn, Anacondra, Pythas and Serpentis to Lynasha.',
@QuestDescription               := 'The Druids of the Fang, are an aberration. They were part of an order of noble druids whose plan was to heal the Barrens, but now seek to remake that land to match their own, twisted dreams.$B$BThe Druids of the Fang have four leaders, and each possesses a dream gem. Even now their faces haunt me!  Defeat the leaders and bring me their gems, and the Barrens may again know peace.$B$BGo, $N. You will find them lurking deep within.',
@QuestCompletionLog             := 'Return to Lynasha.',
@QuestRequiredItemId1           := 9738,
@QuestRequiredItemId2           := 9739,
@QuestRequiredItemId3           := 9740,
@QuestRequiredItemId4           := 9741,
@QuestRequiredItemCount1        := 1,
@QuestRequiredItemCount2        := 1,
@QuestRequiredItemCount3        := 1,
@QuestRequiredItemCount4        := 1,

@QuestRequestitems              := 'Memories of my nightmares haunt me, $N. Have you defeated the leaders of the fang and acquired their gems?',
@QuestRewardText                := 'You have done it, $N. You killed the leaders of the Druids of the Fang. My dreams are now free of their wicked faces, and you have helped save the Barrens from a cursed future.$b$bI thank you, $N. I thank you for myself, for the druids of Thunder Bluff, and for the land.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+6;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `Flags`, `RewardFactionId1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemId2`, `RequiredItemId3`, `RequiredItemId4`, `RequiredItemCount1`, `RequiredItemCount2`, `RequiredItemCount3`, `RequiredItemCount4`) VALUES
(@QuestId+6, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemId2, @QuestRequiredItemId3, @QuestRequiredItemId4, @QuestRequiredItemCount1, @QuestRequiredItemCount2, @QuestRequiredItemCount3, @QuestRequiredItemCount4);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+2 AND `quest`=@QuestId+6;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+2, @QuestId+6);

DELETE FROM `creature_questender` WHERE `id`=@Entry+2 AND `quest`=@QuestId+6;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+2, @QuestId+6);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+6;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+6, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+6;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+6, @QuestRewardText);

SET
@QuestLevel                     := 18,
@QuestMinLevel                  := 14,
@QuestSortID                    := 718,
@QuestRewardXPDifficulty        := 5,
@QuestRewardMoney               := 1000,
@QuestRewardBonusMoney          := 840,
@QuestRewardItem1               := 10919,
@QuestRewardAmount1             := 1,
@QuestRewardFactionId1          := 68,
@QuestRewardFactionValue1       := 5,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Serpentbloom',
@QuestLogDescription            := 'Lynasha wants you to collect 10 Serpentbloom.',
@QuestDescription               := 'The Royal Apothecary Society, based in the great Undercity of Lordaeron, has sent me here for a very specific service, $n. Perhaps you wish to aid me, and in turn The Dark Lady in our efforts to advance the Forsaken.$b$bRecently I studied a rare specimen of flora named Serpentbloom. I believe in greater quantities this herb has great potential.$b$bUnfortunately Serpentbloom can only be found in the darkest recesses of the Wailing Caverns.',
@QuestCompletionLog             := 'Return to Lynasha.',
@QuestRequiredItemId1           := 5339,
@QuestRequiredItemCount1        := 10,

@QuestRequestitems              := 'I am eager to see if you can gather enough Serpentbloom. I\'ve sent many to do my bidding but none have returned.',
@QuestRewardText                := 'Ah, splendid specimens. You have done well, $N.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+7;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardItem1`, `RewardAmount1`, `Flags`, `RewardFactionId1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+7, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardItem1, @QuestRewardAmount1, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+2 AND `quest`=@QuestId+7;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+2, @QuestId+7);

DELETE FROM `creature_questender` WHERE `id`=@Entry+2 AND `quest`=@QuestId+7;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+2, @QuestId+7);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+7;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+7, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+7;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+7, @QuestRewardText);

SET
@QuestLevel                     := 17,
@QuestMinLevel                  := 13,
@QuestSortID                    := 718,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 1800,
@QuestRewardBonusMoney          := 1140,
@QuestRewardChoiceItemID1       := 6480,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 918,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestAllowableRaces            := 0,
@QuestLogTitle                  := 'Deviate Hides',
@QuestLogDescription            := 'Lynasha wants 20 Deviate Hides.',
@QuestDescription               := 'As Naralex descended deeper into his nightmare, a strange breed of beasts arose from beneath the Barrens into the Wailing Caverns.$b$bThese deviate creatures have strange, otherworldly properties. While evil in nature, it is my opinion that some good can come from their existence here in Kalimdor. I believe their hides will be of particular use in the ways of leatherworking.$b$bIf you feel up to the task, retrieve some deviate hides.',
@QuestCompletionLog             := 'Return to Lynasha.',
@QuestRequiredItemId1           := 6443,
@QuestRequiredItemCount1        := 20,

@QuestRequestitems              := 'I am very interested in examining the hides from the deviate creatures who have infested these caves. Have you had any luck in collecting some, $C?',
@QuestRewardText                := 'Your efforts shall not go unnoticed in gathering these hides, $N.$b$bThank you for your dedication.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+8;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+8, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+2 AND `quest`=@QuestId+8;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+2, @QuestId+8);

DELETE FROM `creature_questender` WHERE `id`=@Entry+2 AND `quest`=@QuestId+8;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+2, @QuestId+8);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+8;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+8, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+8;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+8, @QuestRewardText);

SET
@QuestLevel                     := 21,
@QuestMinLevel                  := 15,
@QuestSortID                    := 718,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 2500,
@QuestRewardBonusMoney          := 1500,
@QuestRewardChoiceItemID1       := 6476,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 8071,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 6481,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestAllowableRaces            := 0,
@QuestLogTitle                  := 'Deviate Eradication',
@QuestLogDescription            := 'Lynasha wants you to kill 7 Deviate Ravagers, 7 Deviate Vipers, 7 Deviate Shamblers and 7 Deviate Dreadfangs.',
@QuestDescription               := 'Naralex had a noble goal.$b$bOur great leader aspired to enter the Emerald Dream and help regrow these harsh lands back into the lush forest it once was. But something went terribly wrong.$b$bNaralex\'s dream turned into a nightmare and corrupt creatures began to inhabit the caverns.$b$bWhile some Disciples of Naralex seek to awake our master, my concern is with ridding these caves of the evil beasts.$b$bBrave the caverns, $n, and eradicate the deviate spawn.',
@QuestCompletionLog             := 'Return to Lynasha.',
@QuestRequiredNpcOrGo1          := 3636,
@QuestRequiredNpcOrGo2          := 5755,
@QuestRequiredNpcOrGo3          := 5761,
@QuestRequiredNpcOrGo4          := 5056,
@QuestRequiredNpcOrGoCount1     := 7,
@QuestRequiredNpcOrGoCount2     := 7,
@QuestRequiredNpcOrGoCount3     := 7,
@QuestRequiredNpcOrGoCount4     := 7,

@QuestRequestitems              := '$N, the Disciples of Naralex needs your help. Their numbers are dwindling with their master trapped in his twisted nightmare. They have not the forces necessary to deal with the corrupt creatures which now haunt these caverns.$b$bI beg of you, enter the caves and wage war on the deviate creatures!',
@QuestRewardText                := 'I commend your bravery, $N.$b$bYour aid in ridding the caverns is the first step in our long plight to see the Barrens restored.$b$bThank you and may you prosper.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+9;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGo2`, `RequiredNpcOrGo3`, `RequiredNpcOrGo4`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGoCount2`, `RequiredNpcOrGoCount3`, `RequiredNpcOrGoCount4`) VALUES
(@QuestId+9, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGo2, @QuestRequiredNpcOrGo3, @QuestRequiredNpcOrGo4, @QuestRequiredNpcOrGoCount1, @QuestRequiredNpcOrGoCount2, @QuestRequiredNpcOrGoCount3, @QuestRequiredNpcOrGoCount4);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+2 AND `quest`=@QuestId+9;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+2, @QuestId+9);

DELETE FROM `creature_questender` WHERE `id`=@Entry+2 AND `quest`=@QuestId+9;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+2, @QuestId+9);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+9;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+9, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+9;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+9, @QuestRewardText);

-- Shadowfang Keep: Luther
SET
@Model    := 11805,
@Name     := 'Luther',
@MinLevel := 21,
@MaxLevel := 21;

DELETE FROM `creature_template` WHERE `entry`=@Entry+3;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+3, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionHorde, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+3;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+3, 33, -216.062, 2120.4, 80.1958, 3.70959);

SET
@QuestLevel                     := 26,
@QuestMinLevel                  := 16,
@QuestSortID                    := 209,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1920,
@QuestRewardChoiceItemID1       := 6335,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 4534,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 68,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'The Book of Ur',
@QuestLogDescription            := 'Bring the Book of Ur to Luther.',
@QuestDescription               := '$N, Shadowfang Keep holds a book, the Book of Ur, which would be much prized in my collection. Ur was a great mage of Dalaran before the coming of the Scourge, his studies in other worlds are of much value to ... certain parties among the Forsaken.$B$BFind the book and bring it to me, and I will report your service to our Dark Lady...',
@QuestCompletionLog             := 'Return to Luther.',
@QuestRequiredItemId1           := 6283,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Did you find the book, $N?',
@QuestRewardText                := 'Very good. This book will add nicely to my collections of the workings of Ur. His knowledge was great, but his conscience held him from true power. And so when the Scourge came and his strength was tested, it failed.$B$BWe of the Forsaken cannot afford such weakness, if we are to survive...';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+10;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+10, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+3 AND `quest`=@QuestId+10;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+3, @QuestId+10);

DELETE FROM `creature_questender` WHERE `id`=@Entry+3 AND `quest`=@QuestId+10;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+3, @QuestId+10);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+10;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+10, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+10;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+10, @QuestRewardText);

SET
@QuestLevel                     := 27,
@QuestMinLevel                  := 18,
@QuestSortID                    := 209,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1980,
@QuestRewardSpell               := 1460,
@QuestRewardItem1               := 6414,
@QuestRewardAmount1             := 1,
@QuestRewardFactionId1          := 68,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Arugal Must Die',
@QuestLogDescription            := 'Kill Arugal and bring his head to Luther.',
@QuestDescription               := 'Arugal still resides in Shadowfang Keep. We cannot claim Silverpine as a strategic stronghold for the Dark Lady until Arugal is slain.$b$bI shall see to it that his magic is eradicated, $n. But I leave it in your hands to see that Arugal meets the death he so deserves.$b$bPut an end to Arugal\'s foul spells once and for all. Bring to me the vile wizard\'s head!',
@QuestCompletionLog             := 'Return to Luther.',
@QuestRequiredItemId1           := 5442,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'With Arugal\'s death we stand to increase the Dark Lady\'s stronghold on Lordaeron.',
@QuestRewardText                := 'Silverpine Forest is finally free from the vice of that wretch Arugal. You have done the Dark Lady a great service, $N. Your tenacity shall be rewarded.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+11;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardSpell`, `RewardItem1`, `RewardAmount1`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+11, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardSpell, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+3 AND `quest`=@QuestId+11;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+3, @QuestId+11);

DELETE FROM `creature_questender` WHERE `id`=@Entry+3 AND `quest`=@QuestId+11;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+3, @QuestId+11);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+11;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+11, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+11;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+11, @QuestRewardText);

-- Blackfathom Deeps: Larthras Leafgazer
SET
@Model    := 3301,
@Name     := 'Larthras Leafgazer',
@MinLevel := 24,
@MaxLevel := 24;

DELETE FROM `creature_template` WHERE `entry`=@Entry+4;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+4, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+4;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+4, 48, -149.417, 81.4611, -43.6999, 1.9696);

SET
@QuestLevel                     := 25,
@QuestMinLevel                  := 20,
@QuestSortID                    := 719,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1860,
@QuestRewardItem1               := 6998,
@QuestRewardAmount1             := 1,
@QuestRewardItem2               := 7000,
@QuestRewardAmount2             := 1,
@QuestRewardFactionId1          := 529,
@QuestRewardFactionValue1       := 7,
@QuestRewardFactionId2          := 69,
@QuestRewardFactionValue2       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Twilight Falls',
@QuestLogDescription            := 'Bring 10 Twilight Pendants to Larthras Leafgazer.',
@QuestDescription               := 'Empowered by the ancient rites of the chaotic Old Gods the members of the Twilight\'s Hammer strive to bring about the return of their dark patrons and spread death and terror across the world.$b$bWe believe that the Twilight\'s Hammer has allied with the naga.$b$bWhatever evil plan brews in the depths of the old temple must be thwarted.$b$bWage war on the Hammer and bring back proof of your deeds. Your efforts will be rewarded handsomely.',
@QuestCompletionLog             := 'Return to Larthras Leafgazer.',
@QuestRequiredItemId1           := 5879,
@QuestRequiredItemCount1        := 10,

@QuestRequestitems              := 'Blackfathom Deeps was once an ancient night elf temple. It once housed a most powerful moonwell. Who knows what evil brews there now at the hands of the Twilight\'s Hammer.$B$BHave you made any progress in ridding their presence?',
@QuestRewardText                := 'You are no doubt of brave and noble blood, $N. The Argent Dawn commends you for your efforts against evil.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+12;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardItem1`, `RewardAmount1`, `RewardItem2`, `RewardAmount2`, `RewardFactionID1`, `RewardFactionValue1`, `RewardFactionID2`, `RewardFactionValue2`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+12, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardItem2, @QuestRewardAmount2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestRewardFactionId2, @QuestRewardFactionValue2, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+4 AND `quest`=@QuestId+12;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+4, @QuestId+12);

DELETE FROM `creature_questender` WHERE `id`=@Entry+4 AND `quest`=@QuestId+12;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+4, @QuestId+12);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+12;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+12, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+12;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+12, @QuestRewardText);

SET
@QuestLevel                     := 27,
@QuestMinLevel                  := 18,
@QuestSortID                    := 719,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 6500,
@QuestRewardBonusMoney          := 1980,
@QuestRewardChoiceItemID1       := 7001,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 7002,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 529,
@QuestRewardFactionValue1       := 7,
@QuestRewardFactionId2          := 69,
@QuestRewardFactionValue2       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Blackfathom Villainy',
@QuestLogDescription            := 'Bring the head of Twilight Lord Kelris to Larthras Leafgazer.',
@QuestDescription               := 'Strength has left me. Your help is needed!$b$bLong ago this site was a great temple of Elune. But misfortune led to ruin when the corruption of an Old God seeped up from beneath the earth and tainted the sacred Moon Well.$b$bAku\'Mai, servant of the Old God, rose from the waters.$b$bThe Twilight\'s Hammer cultists have allied with the naga to occupy these grounds. The cultists, led by Kelris, sacrifice innocents to Aku\'Mai for power.$b$bSlay Kelris and bring me his head, $N, please.',
@QuestCompletionLog             := 'Return to Larthras Leafgazer.',
@QuestRequiredItemId1           := 5881,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Time is a precious commodity, $C.$B$BMy role here is to ensure that the Argent Dawn thrives and that the evil forces encroaching upon Kalimdor are thwarted.$B$BState your business quickly or be on your way.',
@QuestRewardText                := 'Kelris has eluded us for quite some time.$B$BIt seems as though whenever evil made its presence known in these parts, Kelris had played a role. For some time we considered him dead or missing.$B$BBut this makes perfect sense. By ending his reign you have spared the lives of many innocent people.$B$BBy the light! To sacrifice someone to a servant of an Old God for one\'s personal gain is beyond reproachful!$B$BYou have done a great deed, $N. I salute you on behalf of the Argent Dawn.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+13;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardFactionID1`, `RewardFactionValue1`, `RewardFactionID2`, `RewardFactionValue2`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+13, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestRewardFactionId2, @QuestRewardFactionValue2, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+4 AND `quest`=@QuestId+13;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+4, @QuestId+13);

DELETE FROM `creature_questender` WHERE `id`=@Entry+4 AND `quest`=@QuestId+13;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+4, @QuestId+13);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+13;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+13, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+13;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+13, @QuestRewardText);

SET
@QuestLevel                     := 27,
@QuestMinLevel                  := 18,
@QuestSortID                    := 719,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 6500,
@QuestRewardBonusMoney          := 1980,
@QuestRewardChoiceItemID1       := 7001,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 7002,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 529,
@QuestRewardFactionValue1       := 7,
@QuestRewardFactionId2          := 81,
@QuestRewardFactionValue2       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Blackfathom Villainy',
@QuestLogDescription            := 'Bring the head of Twilight Lord Kelris to Larthras Leafgazer.',
@QuestDescription               := 'Strength has left me. Your help is needed!$b$bLong ago this site was a great temple of Elune. But misfortune led to ruin when the corruption of an Old God seeped up from beneath the earth and tainted the sacred Moon Well.$b$bAku\'Mai, servant of the Old God, rose from the waters.$b$bThe Twilight\'s Hammer cultists have allied with the naga to occupy these grounds. The cultists, led by Kelris, sacrifice innocents to Aku\'Mai for power.$b$bSlay Kelris and bring me his head, $N, please.',
@QuestCompletionLog             := 'Return to Larthras Leafgazer.',
@QuestRequiredItemId1           := 5881,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Time is a precious commodity, $C.$B$BMy role here is to ensure that the Argent Dawn thrives and that the evil forces encroaching upon Kalimdor are thwarted.$B$BState your business quickly or be on your way.',
@QuestRewardText                := 'Kelris has eluded us for quite some time.$B$BIt seems as though whenever evil made its presence known in these parts, Kelris had played a role. For some time we considered him dead or missing.$B$BBut this makes perfect sense. By ending his reign you have spared the lives of many innocent people.$B$BBy the light! To sacrifice someone to a servant of an Old God for one\'s personal gain is beyond reproachful!$B$BYou have done a great deed, $N. I salute you on behalf of the Argent Dawn.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+14;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardFactionID1`, `RewardFactionValue1`, `RewardFactionID2`, `RewardFactionValue2`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+14, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestRewardFactionId2, @QuestRewardFactionValue2, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+4 AND `quest`=@QuestId+14;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+4, @QuestId+14);

DELETE FROM `creature_questender` WHERE `id`=@Entry+4 AND `quest`=@QuestId+14;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+4, @QuestId+14);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+14;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+14, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+14;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+14, @QuestRewardText);

SET
@QuestLevel                     := 26,
@QuestMinLevel                  := 17,
@QuestSortID                    := 719,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 4000,
@QuestRewardBonusMoney          := 1920,
@QuestRewardChoiceItemID1       := 17694,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 17695,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 530,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Allegiance to the Old Gods',
@QuestLogDescription            := 'Kill Lorgus Jett and then return to Larthras Leafgazer.',
@QuestDescription               := 'This Twilight\'s Hammer follower cannot be allowed to complete his plan. The Twilight\'s Hammer do not understand the spirits of nature. They believe in the Old Gods--creatures of chaos and destruction that were long ago defeated. This Lorgus cannot be allowed to succeed. You must stop him, $N. I cannot do it myself--I am too weak.$B$BFind him and kill him. Return to me when it\'s done.',
@QuestCompletionLog             := 'Return to Larthras Leafgazer.',
@QuestRequiredNpcOrGo1          := 12902,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'Have you found him yet, $N? Lorgus must be stopped!',
@QuestRewardText                := 'Very good!! Thank you, $N. We may not have stopped the Twilight\'s Hammer completely, but at least you have staved off another of their plans to return the Old Gods to power.$b$bWho knows what other plans they have manifesting, but we can rest easy for now.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+15;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+15, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+4 AND `quest`=@QuestId+15;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+4, @QuestId+15);

DELETE FROM `creature_questender` WHERE `id`=@Entry+4 AND `quest`=@QuestId+15;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+4, @QuestId+15);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+15;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+15, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+15;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+15, @QuestRewardText);

SET
@QuestLevel                     := 27,
@QuestMinLevel                  := 21,
@QuestSortID                    := 719,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 4500,
@QuestRewardBonusMoney          := 1980,
@QuestRewardFactionId1          := 530,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Amongst the Ruins',
@QuestLogDescription            := 'Bring the Fathom Core to Larthras Leafgazer.',
@QuestDescription               := 'The Twilight\'s Hammer has moved into the Moonshrine Ruins of Blackfathom Deeps. Their presence can only serve to coerce the elements into working against us. If left unchecked, this region will be theirs for good.$B$B$N, go and find the ruin\'s fathom stone; it should be somewhere close in the water. In it is a fathom core - a device that when properly read it will relate a history of all elemental activity. If I have it, I and the Earthen Ring can maybe do something to stop them!',
@QuestCompletionLog             := 'Return to Larthras Leafgazer.',
@QuestRequiredItemId1           := 16762,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Have you been successful in locating the fathom core?  Without it we\'ll have no idea what the Twilight\'s Hammer is exactly up to down there.',
@QuestRewardText                := 'This is exactly what I need! A fathom core is an incredible well of information that we will be able to draw much good from. Whatever the Twilight\'s Hammer is up to in there - and believe me when I say it is no good - my comrades and I will now uncover.$b$bYou\'ve done well here today; the Earthen Ring looks upon you warmly for assisting us. You\'ve also helped the Horde as a whole, and for that you should be proud.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+16;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+16, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+4 AND `quest`=@QuestId+16;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+4, @QuestId+16);

DELETE FROM `creature_questender` WHERE `id`=@Entry+4 AND `quest`=@QuestId+16;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+4, @QuestId+16);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+16;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+16, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+16;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+16, @QuestRewardText);

-- The Stockade: Andrew Oakley
SET
@Model    := 2991,
@Name     := 'Andrew Oakley',
@MinLevel := 25,
@MaxLevel := 25;

DELETE FROM `creature_template` WHERE `entry`=@Entry+5;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+5, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionAlliance, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+5;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+5, 34, 59.119, 4.45802, -20.2073, 4.08445);

SET
@QuestLevel                     := 26,
@QuestMinLevel                  := 22,
@QuestSortID                    := 717,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1920,
@QuestRewardChoiceItemID1       := 2033,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 2906,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 72,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Crime and Punishment',
@QuestLogDescription            := 'Andrew Oakley wants you to bring him the hand of Dextren Ward.',
@QuestDescription               := 'As if the neglect for the residents of Duskwood was not bad enough, now the House of Nobles spits in the eye of the Darkshire Council with their decision to imprison Dextren Ward in Stormwind rather than behead the villain as per Lord Ebonlocke\'s sentence.$b$bWard was caught selling bodies from the cemetery to Morbent Fel, a crime punishable by death. Yet Stormwind claims Ward as their prisoner.$b$bAssassinate Ward - bring me his hand - and I shall reward you.',
@QuestCompletionLog             := 'Return to Andrew Oakley.',
@QuestRequiredItemId1           := 3628,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'So long as a molester of the dead like Dextren Ward is permitted to live, justice stands betrayed. Return to me once Lord Ebonlocke\'s sentence of death is carried out on that defiler, Ward. We shall give the families of the dead the closure they deserve and better yet, we will send a clear message to the House of Nobles in Stormwind.',
@QuestRewardText                := 'So Dextren Ward finally paid for his crimes against humanity? Good riddance to the scum I say. And cheers to you, my friend! Not only have you given the families of the dead the peace of mind they deserve, you sent a poignant message to those corrupt bureaucrats in the House of Nobles. Stormwind must rise to the needs of the people of Duskwood or we will break free from their tyranny.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+17;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+17, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+5 AND `quest`=@QuestId+17;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+5, @QuestId+17);

DELETE FROM `creature_questender` WHERE `id`=@Entry+5 AND `quest`=@QuestId+17;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+5, @QuestId+17);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+17;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+17, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+17;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+17, @QuestRewardText);

SET
@QuestLevel                     := 27,
@QuestMinLevel                  := 22,
@QuestSortID                    := 717,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1980,
@QuestRewardChoiceItemID1       := 3562,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 1264,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 47,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'The Fury Runs Deep',
@QuestLogDescription            := 'Andrew Oakley wants Kam Deepfury\'s head brought to him.',
@QuestDescription               := 'You have proven your loyalty to King Magni, $c. And your hatred for the Dark Iron scum is as great as my own.$b$bThere is a task I wish to complete myself but I am bound by honor to stay with Longbraid. But Roggo has gathered intelligence that proves Kam Deepfury was a conspirator in the attack on the Thandol Span. It was by Deepfury\'s planning that Longbraid lost his kin.$b$bDeepfury is being held for political reasons in the Stormwind Stockade. I want him dead, $N. For Longbraid! Bring me his head!',
@QuestCompletionLog             := 'Return to Andrew Oakley.',
@QuestRequiredItemId1           := 3640,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'I won\'t let foolish Human bureaucracy interfere with Dwarven matters, $N. Kam Deepfury is a proven conspirator in the Thandol Span attack. King Magni\'s good people lost their lives because of Deepfury\'s deceit. The Humans might be content to let Deepfury rot in The Stockade but I will not sleep soundly at night until Deepfury is slain.',
@QuestRewardText                := 'So Kam Deepfury finally got to feel what it is like to be on the receiving end of Death? Good. Serves the cowardly Dark Iron scum right. You have done well, $c. The victims of the Thandol Span attack were but mere victims in a world torn with war and unrest. Their families will have the peace of knowing Deepfury got the punishment he deserved. Longbraid\'s brother\'s death has been avenged.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+18;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+18, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+5 AND `quest`=@QuestId+18;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+5, @QuestId+18);

DELETE FROM `creature_questender` WHERE `id`=@Entry+5 AND `quest`=@QuestId+18;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+5, @QuestId+18);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+18;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+18, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+18;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+18, @QuestRewardText);

SET
@QuestLevel                     := 25,
@QuestMinLevel                  := 22,
@QuestSortID                    := 717,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1860,
@QuestRewardChoiceItemID1       := 3400,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 1317,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 72,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'What Comes Around...',
@QuestLogDescription            := 'Bring the head of Targorr the Dread to Andrew Oakley.',
@QuestDescription               := 'Targorr the Dread served under Gath\'Ilzogg as supreme Executioner. His methods were ruthless, even by filthy orc standards. Men who fought bravely to defend the Kingdom were tortured on his whim. Now he is being held and is sentenced to die. Yet something is amiss. One of the bureaucratic nobles put a hold on his execution. I am sure foul play is in the works.$b$bPut an end to Targorr the Dread, $N. Find and behead him before trickery is upon us.',
@QuestCompletionLog             := 'Return to Andrew Oakley.',
@QuestRequiredItemId1           := 3630,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'I fear whatever trickery that has kept Targorr the Dread alive for this long will eventually bring about his freedom. He was sentenced to die, $N, not act as some political pawn on a noble\'s whim.',
@QuestRewardText                := 'Targorr the Dread has finally met his fate. I for one am glad to hear the beast now knows what it is like to be on the receiving end of Death\'s ruthless grip. You have done well, $N. Sometimes the truest justice can only be found outside the courtroom and beyond the clouded vision of politics.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+19;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+19, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+5 AND `quest`=@QuestId+19;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+5, @QuestId+19);

DELETE FROM `creature_questender` WHERE `id`=@Entry+5 AND `quest`=@QuestId+19;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+5, @QuestId+19);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+19;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+19, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+19;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+19, @QuestRewardText);

SET
@QuestLevel                     := 26,
@QuestMinLevel                  := 22,
@QuestSortID                    := 717,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 6000,
@QuestRewardBonusMoney          := 1920,
@QuestRewardFactionId1          := 72,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Quell The Uprising',
@QuestLogDescription            := 'to Andrew Oakley wants you to kill 10 Defias Prisoners, 8 Defias Convicts, and 8 Defias Insurgents.',
@QuestDescription               := 'The uprising must be quelled! I need your assistance. If word gets out that the prison is overrun I will lose my job! This is a case of foul play if I\'ve ever seen one. But what\'s important now is forcing these prisoners into submission for the safety of Stormwind.$b$bThe punishment for insurgency is death. Kill some of these deviants! That ought to get things under control.',
@QuestCompletionLog             := 'Return to Andrew Oakley.',
@QuestRequiredNpcOrGo1          := 1706,
@QuestRequiredNpcOrGo2          := 1711,
@QuestRequiredNpcOrGo3          := 1715,
@QuestRequiredNpcOrGoCount1     := 10,
@QuestRequiredNpcOrGoCount2     := 8,
@QuestRequiredNpcOrGoCount3     := 8,

@QuestRequestitems              := 'The Stockade is still overrun! These Defias Rats must be shown that their actions will not be tolerated. Now go down there and show some force!',
@QuestRewardText                := 'Your efforts were valiant, $N. It\'s obvious this problem is bigger than the both of us. But you have performed well and for that I am thankful.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+20;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGo2`, `RequiredNpcOrGo3`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGoCount2`, `RequiredNpcOrGoCount3`) VALUES
(@QuestId+20, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGo2, @QuestRequiredNpcOrGo3, @QuestRequiredNpcOrGoCount1, @QuestRequiredNpcOrGoCount2, @QuestRequiredNpcOrGoCount3);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+5 AND `quest`=@QuestId+20;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+5, @QuestId+20);

DELETE FROM `creature_questender` WHERE `id`=@Entry+5 AND `quest`=@QuestId+20;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+5, @QuestId+20);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+20;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+20, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+20;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+20, @QuestRewardText);

SET
@QuestLevel                     := 29,
@QuestMinLevel                  := 16,
@QuestSortID                    := 717,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 2500,
@QuestRewardBonusMoney          := 2160,
@QuestRewardFactionId1          := 72,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'The Stockade Riots',
@QuestLogDescription            := 'Kill Bazil Thredd and bring his head back to Andrew Oakley.',
@QuestDescription               := 'Let\'s get one thing straight, $N: I don\'t trust you. But, with the situation as it is, you probably won\'t make a difference.$B$BSo here\'s how it\'s going to be: go down there and have your talk with Thredd. If you\'re really on our side, then kill him and bring me his head when the job\'s done. And if it turns out you\'re on his side, and don\'t come out... when we find you, you\'ll die along with the rest of the maggots.',
@QuestCompletionLog             := 'Return to Andrew Oakley.',
@QuestRequiredItemId1           := 2926,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Either you bring me Thredd\'s head, or I\'ll take yours, understand, $N?',
@QuestRewardText                := 'Without Thredd to lead them, hopefully the riots will be more controllable. We shall see.$B$BI must say, after a half hour, I hardly expected you to come out, but it seems I misjudged you.$B$BI\'d guess, then, that you didn\'t get much useful information out of him? But I know a thing or two that might be of interest to you about Thredd\'s activities.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+21;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+21, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+5 AND `quest`=@QuestId+21;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+5, @QuestId+21);

DELETE FROM `creature_questender` WHERE `id`=@Entry+5 AND `quest`=@QuestId+21;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+5, @QuestId+21);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+21;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+21, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+21;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+21, @QuestRewardText);

-- Razorfen Kraul: Dekle Shortwizzle
SET
@Model    := 7051,
@Name     := 'Dekle Shortwizzle',
@MinLevel := 27,
@MaxLevel := 27;

DELETE FROM `creature_template` WHERE `entry`=@Entry+6;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+6, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+6;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+6, 47, 1947.8, 1586.11, 82.2491, 5.10672);

SET
@QuestLevel                     := 27,
@QuestMinLevel                  := 23,
@QuestSortID                    := 1717,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1980,
@QuestRewardItem1               := 29200,
@QuestRewardAmount1             := 1,
@QuestRewardChoiceItemID1       := 4197,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 6742,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 6725,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'The Crone of the Kraul',
@QuestLogDescription            := 'Bring Razorflank\'s Medallion to Dekle Shortwizzle.',
@QuestDescription               := 'Poor Heralath! And this dwarf... Lonebrow. What a brave soul he was.$b$bWe must not let their valiance go for naught. This crone... Charlga Razorflank ... must be stopped.$b$bSurely, infiltrating the Kraul will be perilous. There isn\'t time to send word to Darnassus. $n, assemble a party to slay the crone.$b$bBring me Razorflank\'s Medallion as proof of demise.',
@QuestCompletionLog             := 'Return to Dekle Shortwizzle.',
@QuestRequiredItemId1           := 5792,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'So long as Charlga Razorflank is mustering a force, these lands are in great danger.',
@QuestRewardText                := 'The crone has been laid to rest. This is fantastic news, $N.$B$BIn these times of peril, it is refreshing to see one as brave as yourself.$B$BWith Razorflank\'s minions taken care of, our studies in the area can continue. Perhaps now we can gain further knowledge of exactly what happened to corrupt the resting place of Agamaggan.$B$BHowever, I fear the answer to that question lies in treachery as well...';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+22;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `RewardItem1`, `RewardAmount1`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+22, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestRewardItem1, @QuestRewardAmount1, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+6 AND `quest`=@QuestId+22;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+6, @QuestId+22);

DELETE FROM `creature_questender` WHERE `id`=@Entry+6 AND `quest`=@QuestId+22;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+6, @QuestId+22);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+22;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+22, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+22;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+22, @QuestRewardText);

SET
@QuestLevel                     := 27,
@QuestMinLevel                  := 23,
@QuestSortID                    := 1717,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1980,
@QuestRewardChoiceItemID1       := 4197,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 6742,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 6725,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestRewardFactionId1          := 81,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'A Vengeful Fate',
@QuestLogDescription            := 'Bring Razorflank\'s Heart to Dekle Shortwizzle.',
@QuestDescription               := 'Cairne is a noble leader for uniting the people of Thunder Bluff.$b$bBut I cannot forgive those who drove them from their ancestral lands as easily as some. Their people inhabited the southern Barrens for decades. The land was holy to them. But they were driven off by numerous foes.$b$bA vengeful fate awaits the crone, Charlga Razorflank, who musters a foul army.$b$bBring me Razorflank\'s heart, $n.',
@QuestCompletionLog             := 'Return to Dekle Shortwizzle.',
@QuestRequiredItemId1           := 5793,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Once I know the foul beasts have been driven from their foul lair, I will be able to rest in peace, knowing that revenge has been served.$b$bHave you the driven the quilboar away? Do you bring to me good news in the form of Razorflank\'s heart?',
@QuestRewardText                := 'I see the nasty tribe now knows the pain of the people of Thunder Bluff. Serves the foul beasts right.$b$bTo drive one from a holy land is a sin worthy of the most severe revenge.$b$bThank you, $N, for aiding them in their plight.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+23;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+23, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+6 AND `quest`=@QuestId+23;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+6, @QuestId+23);

DELETE FROM `creature_questender` WHERE `id`=@Entry+6 AND `quest`=@QuestId+23;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+6, @QuestId+23);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+23;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+23, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+23;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+23, @QuestRewardText);

SET
@QuestLevel                     := 26,
@QuestMinLevel                  := 22,
@QuestSortID                    := 1717,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 1920,
@QuestRewardFactionId1          := 68,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Going, Going, Guano!',
@QuestLogDescription            := 'Bring 1 pile of Kraul Guano to Dekle Shortwizzle.',
@QuestDescription               := 'As you might know, $n, they\'re up to some very.... interesting experiments at the Royal Apothecary Society.$b$bThe Master there is responsible of overseeing the most ambitious of alchemical attempts. So much work and so little time!$b$bYou look well traveled for a $c. Perhaps you can aid them.$b$bThey\'re in need of a rare substance. It\'s foul material; it comes from a rare species of bats only found here. Bring to me the guano from the Kraul Bats so they can begin their work...',
@QuestCompletionLog             := 'Return to Dekle Shortwizzle.',
@QuestRequiredItemId1           := 5801,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Ah, I see you have returned. Were you able to procure any Kraul Guano?',
@QuestRewardText                := 'Splendid! This is just the start we needed, $N.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+24;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+24, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+6 AND `quest`=@QuestId+24;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+6, @QuestId+24);

DELETE FROM `creature_questender` WHERE `id`=@Entry+6 AND `quest`=@QuestId+24;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+6, @QuestId+24);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+24;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+24, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+24;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+24, @QuestRewardText);

-- Gnomeregan: Sunkull Fizzlebell
SET
@Model    := 3106,
@Name     := 'Sunkull Fizzlebell',
@MinLevel := 28,
@MaxLevel := 28;

DELETE FROM `creature_template` WHERE `entry`=@Entry+7;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+7, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionAlliance, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+7;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+7, 90, -359.066, 4.51921, -152.851, 6.23753);

SET
@QuestLevel                     := 30,
@QuestMinLevel                  := 24,
@QuestSortID                    := 133,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 5500,
@QuestRewardBonusMoney          := 2220,
@QuestRewardFactionId1          := 54,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Essential Artificials',
@QuestLogDescription            := 'Bring 12 Essential Artificials to Sunkull Fizzlebell.',
@QuestDescription               := 'A nigh-universal mechanical component--the essential artificial--was of great use to the tinkers and smiths of Gnomeregan. But during the frantic exodus from our city, no one remembered to take any of these devices with them! And I need a large supply of them for work I will soon undertake.$B$BPlease, go and get me some essential artificials. You\'ll find them in the deeper areas of our city, held in containers called artificial extrapolators.$B$BThank you, $N, and please hurry!',
@QuestCompletionLog             := 'Return to Sunkull Fizzlebell.',
@QuestRequiredItemId1           := 9278,
@QuestRequiredItemCount1        := 12,

@QuestRequestitems              := 'Do you have the essential artificials?',
@QuestRewardText                := 'You got them! Now I can begin my new experiments!$B$BI can\'t thank you enough, $N! Your bravery has advanced gnomish research by a leap and a bound!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+25;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+25, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+7 AND `quest`=@QuestId+25;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+7, @QuestId+25);

DELETE FROM `creature_questender` WHERE `id`=@Entry+7 AND `quest`=@QuestId+25;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+7, @QuestId+25);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+25;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+25, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+25;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+25, @QuestRewardText);

SET
@QuestLevel                     := 30,
@QuestMinLevel                  := 20,
@QuestSortID                    := 133,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 2220,
@QuestRewardChoiceItemID1       := 9608,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 9609,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 72,
@QuestRewardFactionValue1       := 7,
@QuestRewardFactionId2          := 54,
@QuestRewardFactionValue2       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Gyrodrillmatic Excavationators',
@QuestLogDescription            := 'Bring twenty-four Robo-mechanical Guts to Sunkull Fizzlebell.',
@QuestDescription               := 'It\'s terrible, $N. We are not going to have enough parts to get our fleet of gyrodrillmatic excavationators to Dun Morogh.$B$BWhat we need are spare parts, $N. What better place to get the spare parts for our vehicles than Gnomeregan? I hear that bots and mechs roam around that place like cattle on an open range.$B$BWhat I need you to do is go and tear apart those robots. Bring me back their robot guts. Two dozen should be sufficient.$B',
@QuestCompletionLog             := 'Return to Sunkull Fizzlebell.',
@QuestRequiredItemId1           := 9309,
@QuestRequiredItemCount1        := 24,

@QuestRequestitems              := 'If this were a race, you would have lost by now.',
@QuestRewardText                := 'This will do nicely, $N. One gyrodrillmatic excavationator fixed; 398 left to go.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+26;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardFactionID1`, `RewardFactionValue1`, `RewardFactionID2`, `RewardFactionValue2`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+26, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestRewardFactionId2, @QuestRewardFactionValue2, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+7 AND `quest`=@QuestId+26;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+7, @QuestId+26);

DELETE FROM `creature_questender` WHERE `id`=@Entry+7 AND `quest`=@QuestId+26;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+7, @QuestId+26);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+26;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+26, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+26;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+26, @QuestRewardText);

SET
@QuestLevel                     := 35,
@QuestMinLevel                  := 25,
@QuestSortID                    := 133,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 3500,
@QuestRewardBonusMoney          := 3000,
@QuestRewardChoiceItemID1       := 9623,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 9624,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 9625,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestRewardFactionId1          := 54,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'The Grand Betrayal',
@QuestLogDescription            := 'Kill Mekgineer Thermaplugg. Return to Sunkull Fizzlebell when the task is complete.',
@QuestDescription               := 'I trusted Thermaplugg, $r. Never did I expect that he would betray me and the entire gnomish people. And for what? Power? Wealth? All things that he would have had in time. Now we have been displaced from our home and that madman is in charge. The king of nothing....$B$BWe will retake Gnomeregan, $N. We will not stop until the city is back in our control. If you wish to join in our fight, a simple task I ask of you: Kill the betrayer. Destroy Mekgineer Thermaplugg.',
@QuestCompletionLog             := 'Return to Sunkull Fizzlebell.',
@QuestRequiredNpcOrGo1          := 7800,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'Is the task complete? Did he beg for lenience? For mercy??',
@QuestRewardText                := 'I like to think that the last thing that went through his head as he collapsed to the ground was your foot, $R. With Thermaplugg dead, our plans to retake Gnomeregan are one step closer to becoming a reality.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+27;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+27, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+7 AND `quest`=@QuestId+27;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+7, @QuestId+27);

DELETE FROM `creature_questender` WHERE `id`=@Entry+7 AND `quest`=@QuestId+27;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+7, @QuestId+27);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+27;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+27, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+27;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+27, @QuestRewardText);

-- Scarlet Monastery (Cathedral): Reese Hartford
SET
@Model    := 10187,
@Name     := 'Reese Hartford',
@MinLevel := 40,
@MaxLevel := 40;

DELETE FROM `creature_template` WHERE `entry`=@Entry+8;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+8, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+8;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+8, 189, 870.735, 1309.67, 18.006, 1.48615);

SET
@QuestLevel                     := 40,
@QuestMinLevel                  := 34,
@QuestSortID                    := 796,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 3900,
@QuestRewardChoiceItemID1       := 6829,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 6830,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 6831,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestRewardChoiceItemID4       := 11262,
@QuestRewardChoiceItemQuantity4 := 1,
@QuestRewardFactionId1          := 72,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'In the Name of the Light',
@QuestLogDescription            := 'Kill High Inquisitor Whitemane and Scarlet Commander Mograine and then report back to Reese Hartford.',
@QuestDescription               := 'I once served the Scarlet Crusade with honor, loyalty and pride. I believed their cause to be a noble one: to rid Azeroth of the undead.$b$bBut as time went on I realized that their grasp on reality was slipping. They now think everyone is plagued who doesn\'t wear the tabard of the Crusade. Innocent men and women were tortured because they were supposedly plagued. $b$bThe Scarlet Crusade must be crushed in the name of the Light. You, $n, must destroy the deranged regime.',
@QuestCompletionLog             := 'Return to Reese Hartford.',
@QuestRequiredNpcOrGo1          := 3977,
@QuestRequiredNpcOrGo2          := 3976,
@QuestRequiredNpcOrGoCount1     := 1,
@QuestRequiredNpcOrGoCount2     := 1,

@QuestRequestitems              := 'The corruption in the Monastery will not end until the highest ranking officials have been removed.$b$bIn the name of the Light, slay High Inquisitor Whitemane and Scarlet Commander Mograine. Once they have fallen, perhaps the true cause can be rekindled. Until then, anyone who crosses the path of the Crusade lies in peril.$b$bVenture forth and make it so!',
@QuestRewardText                := 'While disciples of the Light never revel in the loss of life, we must accept that on occasion, such sacrifices must happen for the greater good of the Kingdom and the planet.$B$BThrough your deeds you have spared many innocent lives, $N. I salute your tenacity.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+28;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `RewardChoiceItemID4`, `RewardChoiceItemQuantity4`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGo2`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGoCount2`) VALUES
(@QuestId+28, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestRewardChoiceItemID4, @QuestRewardChoiceItemQuantity4, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGo2, @QuestRequiredNpcOrGoCount1, @QuestRequiredNpcOrGoCount2);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+8 AND `quest`=@QuestId+28;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+8, @QuestId+28);

DELETE FROM `creature_questender` WHERE `id`=@Entry+8 AND `quest`=@QuestId+28;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+8, @QuestId+28);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+28;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+28, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+28;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+28, @QuestRewardText);

SET
@QuestLevel                     := 42,
@QuestMinLevel                  := 30,
@QuestSortID                    := 796,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 4350,
@QuestRewardChoiceItemID1       := 6802,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 6803,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 10711,
@QuestRewardChoiceItemQuantity4 := 1,
@QuestRewardFactionId1          := 68,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Into The Scarlet Monastery',
@QuestLogDescription            := 'Kill High Inquisitor Whitemane and Scarlet Commander Mograine and then report back to Reese Hartford.',
@QuestDescription               := 'One of my duties while I\'m stationed here is to help the Forsaken take care of their borders, and that, $c, is exactly what you\'re going to do for me.$b$bI might live and breathe, but the Scarlet Crusade will cut down my people as quickly as they will one of the undead. They\'re a problem here, a big one, and you\'re going to do something about it.$b$bGo slay High Inquisitor Whitemane and her commander.',
@QuestCompletionLog             := 'Return to Reese Hartford.',
@QuestRequiredNpcOrGo1          := 3977,
@QuestRequiredNpcOrGo2          := 3976,
@QuestRequiredNpcOrGoCount1     := 1,
@QuestRequiredNpcOrGoCount2     := 1,

@QuestRequestitems              := 'Have you taken care of the High Inquisitor and Scarlet Commander?',
@QuestRewardText                := 'I\'m sure Sylvanas will be glad to have that problem taken care of, $N. The task I gave you wasn\'t easy, but here you stand, victorious. That commands respect, and what you\'ve done won\'t be forgotten.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+29;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGo2`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGoCount2`) VALUES
(@QuestId+29, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGo2, @QuestRequiredNpcOrGoCount1, @QuestRequiredNpcOrGoCount2);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+8 AND `quest`=@QuestId+29;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+8, @QuestId+29);

DELETE FROM `creature_questender` WHERE `id`=@Entry+8 AND `quest`=@QuestId+29;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+8, @QuestId+29);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+29;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+29, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+29;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+29, @QuestRewardText);

-- Scarlet Monastery (Armory): Trail'tuho
SET
@Model    := 6839,
@Name     := 'Trail\'tuho',
@MinLevel := 40,
@MaxLevel := 40;

DELETE FROM `creature_template` WHERE `entry`=@Entry+9;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+9, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+9;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+9, 189, 1624.79, -312.561, 18.0075, 4.67025);

SET
@QuestLevel                     := 38,
@QuestMinLevel                  := 32,
@QuestSortID                    := 796,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 3500,
@QuestRewardBonusMoney          := 3900,
@QuestRewardFactionId1          := 72,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Herod Must Be Stopped!',
@QuestLogDescription            := 'Kill Herod, the Scarlet Champion, and then report back to Trail\'tuho.',
@QuestDescription               := 'In order to put an end to the Scarlet Crusade, we must eliminate the lieutenants of the High Inquisitor.$B$BIf you have the courage to help us, venture on and put an end to Herod once and for all.',
@QuestCompletionLog             := 'Return to Trail\'tuho.',
@QuestRequiredNpcOrGo1          := 3975,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'Have you disposed of the Scarlet Champion?',
@QuestRewardText                := 'You did it!$B$BWe are truly close to putting an end to the Scarlet Crusade, thanks to you!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+30;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+30, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+9 AND `quest`=@QuestId+30;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+9, @QuestId+30);

DELETE FROM `creature_questender` WHERE `id`=@Entry+9 AND `quest`=@QuestId+30;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+9, @QuestId+30);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+30;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+30, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+30;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+30, @QuestRewardText);

SET
@QuestLevel                     := 38,
@QuestMinLevel                  := 32,
@QuestSortID                    := 796,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 3500,
@QuestRewardBonusMoney          := 4350,
@QuestRewardFactionId1          := 68,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Herod Must Be Stopped!',
@QuestLogDescription            := 'Kill Herod, the Scarlet Champion, and then report back to Trail\'tuho.',
@QuestDescription               := 'In order to put an end to the Scarlet Crusade, we must eliminate the lieutenants of the High Inquisitor.$B$BIf you have the courage to help us, venture on and put an end to Herod once and for all.',
@QuestCompletionLog             := 'Return to Trail\'tuho.',
@QuestRequiredNpcOrGo1          := 3975,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'Have you disposed of the Scarlet Champion?',
@QuestRewardText                := 'You did it!$B$BWe are truly close to putting an end to the Scarlet Crusade, thanks to you!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+31;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+31, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+9 AND `quest`=@QuestId+31;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+9, @QuestId+31);

DELETE FROM `creature_questender` WHERE `id`=@Entry+9 AND `quest`=@QuestId+31;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+9, @QuestId+31);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+31;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+31, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+31;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+31, @QuestRewardText);

-- Scarlet Monastery (Library): Gidion Thackeray
SET
@Model    := 13171,
@Name     := 'Gidion Thackeray',
@MinLevel := 40,
@MaxLevel := 40;

DELETE FROM `creature_template` WHERE `entry`=@Entry+10;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+10, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+10;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+10, 189, 280.646, -228.318, 18.5307, 3.09748);

SET
@QuestLevel                     := 36,
@QuestMinLevel                  := 30,
@QuestSortID                    := 796,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 3500,
@QuestRewardBonusMoney          := 3900,
@QuestRewardFactionId1          := 72,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Houndmaster Loksey Must Be Stopped!',
@QuestLogDescription            := 'Kill Houndmaster Loksey and then report back to Gidion Thackeray.',
@QuestDescription               := 'I am tasked with preparing the assault on Houndmaster Loksey. His death is crucial in order to stop the Scarlet Crusade.$B$BI must ask for your help, if you have the courage.',
@QuestCompletionLog             := 'Return to Gidion Thackeray.',
@QuestRequiredNpcOrGo1          := 3974,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'Have you taken care of the Houndmaster?',
@QuestRewardText                := 'You did it!$B$BWe\'re close to putting an end to the Scarlet Crusade, after all!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+32;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+32, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+10 AND `quest`=@QuestId+32;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+10, @QuestId+32);

DELETE FROM `creature_questender` WHERE `id`=@Entry+10 AND `quest`=@QuestId+32;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+10, @QuestId+32);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+32;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+32, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+32;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+32, @QuestRewardText);

SET
@QuestLevel                     := 36,
@QuestMinLevel                  := 30,
@QuestSortID                    := 796,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 3500,
@QuestRewardBonusMoney          := 3900,
@QuestRewardFactionId1          := 68,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Houndmaster Loksey Must Be Stopped!',
@QuestLogDescription            := 'Kill Houndmaster Loksey and then report back to Gidion Thackeray.',
@QuestDescription               := 'I am tasked with preparing the assault on Houndmaster Loksey. His death is crucial in order to stop the Scarlet Crusade.$B$BI must ask for your help, if you have the courage.',
@QuestCompletionLog             := 'Return to Gidion Thackeray.',
@QuestRequiredNpcOrGo1          := 3974,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'Have you taken care of the Houndmaster?',
@QuestRewardText                := 'You did it!$B$BWe\'re close to putting an end to the Scarlet Crusade, after all!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+33;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+33, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+10 AND `quest`=@QuestId+33;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+10, @QuestId+33);

DELETE FROM `creature_questender` WHERE `id`=@Entry+10 AND `quest`=@QuestId+33;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+10, @QuestId+33);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+33;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+33, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+33;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+33, @QuestRewardText);

SET
@QuestLevel                     := 38,
@QuestMinLevel                  := 28,
@QuestSortID                    := 796,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 3450,
@QuestRewardChoiceItemID1       := 7747,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 17508,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 7749,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestRewardFactionId1          := 81,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Compendium of the Fallen',
@QuestLogDescription            := 'Retrieve the Compendium of the Fallen and return to Gidion Thackeray.',
@QuestDescription               := 'The Earthen Ring had pure intentions towards our plagued brethren. But who is to know the motivations of those whispering in the ears of the Elder Council?$b$bThe Forsaken whom we have allied with have a history wrought with deceit. Too hasty was our pact. Perhaps Cairne would have been wise to heed the warnings from Orgrimmar.$b$bInside the library lies the Compendium of the Fallen, guarded by crazed human zealots. Their method is forged from insanity but their research might prove useful.',
@QuestCompletionLog             := 'Return to Gidion Thackeray.',
@QuestRequiredItemId1           := 5535,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Cairne is a brave and noble leader and I would trust him with my own life. But it is others that I do not trust in this political climate.$b$bOnce I have a chance to gather all the knowledge available I can provide sound council to the Chieftain.$b$bHave you had a chance to retrieve the compendium? The Compendium of the Fallen is just one piece in this complicated puzzle...',
@QuestRewardText                := 'The Compendium of the Fallen! I was beginning to wonder if the very book existed!$b$bYou have served the Tauren of Thunder Bluff well, $N. Your dedication shall not be forgotten.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+34;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+34, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+10 AND `quest`=@QuestId+34;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+10, @QuestId+34);

DELETE FROM `creature_questender` WHERE `id`=@Entry+10 AND `quest`=@QuestId+34;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+10, @QuestId+34);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+34;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+34, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+34;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+34, @QuestRewardText);

SET
@QuestLevel                     := 38,
@QuestMinLevel                  := 28,
@QuestSortID                    := 796,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 3450,
@QuestRewardItem1               := 7746,
@QuestRewardAmount1             := 1,
@QuestRewardFactionId1          := 47,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Mythology of the Titans',
@QuestLogDescription            := 'Retrieve Mythology of the Titans from the library and bring it to Gidion Thackeray.',
@QuestDescription               := 'The future is inevitable! We hurl ourselves towards it like falling raindrops to the Great Sea.$b$bBut perhaps, by studying the past, we can know what to expect and be better prepared for the unknown.$b$bBefore dire troubles fell upon Lordaeron, there was a bastion of knowledge tucked away in the Tirisfal Glades. It is rumored that a book called Mythology of the Titans was housed in the library.$b$bBring it to me and perhaps together we can unlock the secrets of the past!',
@QuestCompletionLog             := 'Return to Gidion Thackeray.',
@QuestRequiredItemId1           := 5536,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'The Monastery was a seminary for Paladins-in-training. Once a stronghold of the Light, it fell into the hands of the crazed zealots of the Scarlet Crusade.$b$bThe Crusade believed their goal a noble one: to purify the land of the undead plague. But insanity tainted their plight and now they stand enemies to all.$b$bBring Mythology of the Titans to me so I can study it.$b$bThe corrupt halls of the Monastery are no place for such a historical treasure.',
@QuestRewardText                := 'You have rescued the sacred text!$b$bYour journey was long and acquiring the book was undoubtedly no easy task. But the dwarves of Ironforge stand to benefit from your success.$b$bThank you, $N, on behalf of the Explorers\' League.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+35;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardItem1`, `RewardAmount1`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+35, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+10 AND `quest`=@QuestId+35;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+10, @QuestId+35);

DELETE FROM `creature_questender` WHERE `id`=@Entry+10 AND `quest`=@QuestId+35;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+10, @QuestId+35);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+35;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+35, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+35;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+35, @QuestRewardText);

-- Razorfen Downs: Dowoe Farjumper
SET
@Model    := 7625,
@Name     := 'Dowoe Farjumper',
@MinLevel := 37,
@MaxLevel := 37;

DELETE FROM `creature_template` WHERE `entry`=@Entry+11;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+11, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+11;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+11, 129, 2571.45, 1108.09, 47.6629, 4.50831);

SET
@QuestLevel                     := 37,
@QuestMinLevel                  := 33,
@QuestSortID                    := 722,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 3300,
@QuestRewardItem1               := 10823,
@QuestRewardAmount1             := 1,
@QuestRewardFactionId1          := 68,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Bring the End',
@QuestLogDescription            := 'Dowoe Farjumper wants you to kill Amnennar the Coldbringer and return his skull.',
@QuestDescription               := 'While our first observations of this place revealed little threat, our recent findings are much more serious...$B$BThe quilboar have aligned themselves with the Scourge. A Lich named Amnennar the Coldbringer rules them now, using the power of his massive consciousness to control their every move.$B$BAmnennar has a direct telepathic link to Ner\'zhul; we must sever this bond, $N. An end must come to the Coldbringer.',
@QuestCompletionLog             := 'Return to Dowoe Farjumper.',
@QuestRequiredItemId1           := 10420,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'This matter is of utmost importance, $N. We must stop any attempt by the Scourge to bolster their ranks.',
@QuestRewardText                := 'The loyalty of a Lich is unswerving, $N. Let them know that such loyalty will only bring them destruction.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+36;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardItem1`, `RewardAmount1`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+36, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+11 AND `quest`=@QuestId+36;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+11, @QuestId+36);

DELETE FROM `creature_questender` WHERE `id`=@Entry+11 AND `quest`=@QuestId+36;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+11, @QuestId+36);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+36;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+36, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+36;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+36, @QuestRewardText);

SET
@QuestLevel                     := 37,
@QuestMinLevel                  := 33,
@QuestSortID                    := 722,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 3300,
@QuestRewardItem1               := 10823,
@QuestRewardAmount1             := 1,
@QuestRewardItem2               := 10824,
@QuestRewardAmount2             := 1,
@QuestRewardFactionId1          := 72,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Bring the Light',
@QuestLogDescription            := 'Dowoe Farjumper wants you to slay Amnennar the Coldbringer.',
@QuestDescription               := 'The Scourge is a persistent threat to the Alliance, a fact I am sure you know quite well. Recently, we have come across some very peculiar findings, $N.$B$BWhile once this was the home of simple quilboar, now it has become apparent that a pact was made with the Scourge, creating creatures far worse... They are now ruled by the lich, Amnennar the Coldbringer.$B$BAlign yourself with the Light, $N; put an end to this evil union.',
@QuestCompletionLog             := 'Return to Dowoe Farjumper.',
@QuestRequiredNpcOrGo1          := 7358,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'Amnennar must be eradicated. Go, swiftly.',
@QuestRewardText                := 'Thank you, $N. The Scourge will now think twice before attempting to bolster its ranks again.$B$BMay you be blessed by the Light.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+37;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardItem1`, `RewardAmount1`, `RewardItem2`, `RewardAmount2`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+37, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardItem2, @QuestRewardAmount2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+11 AND `quest`=@QuestId+37;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+11, @QuestId+37);

DELETE FROM `creature_questender` WHERE `id`=@Entry+11 AND `quest`=@QuestId+37;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+11, @QuestId+37);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+37;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+37, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+37;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+37, @QuestRewardText);

-- Zul'Farrak: Javion Padley
SET
@Model    := 5547,
@Name     := 'Javion Padley',
@MinLevel := 46,
@MaxLevel := 46;

DELETE FROM `creature_template` WHERE `entry`=@Entry+12;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+12, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+12;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+12, 209, 1241.62, 811.337, 8.97133, 2.0579);

SET
@QuestLevel                     := 47,
@QuestMinLevel                  := 40,
@QuestSortID                    := 978,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 5400,
@QuestRewardChoiceItemID1       := 9533,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 9534,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 369,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 0,
@QuestLogTitle                  := 'Divino-matic Rod',
@QuestLogDescription            := 'Bring the Divino-matic Rod to Javion Padley.',
@QuestDescription               := 'Sergeant Bly stole from me! He said he\'d only borrow it, but he stole my cherished divino-matic rod!! Without that rod how will I know where to dig new water holes??$B$BFind Bly and bring me my rod! Let\'s hope the trolls took care of him, because if you have to fight him for the rod then you\'re in for a serious fight.',
@QuestCompletionLog             := 'Return to Javion Padley.',
@QuestRequiredItemId1           := 8548,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Did you find Sergeant Bly? Did you get my divino-matic rod?',
@QuestRewardText                := 'You found it! Well done, $N! Did you have to fight Bly for it? I hope you knocked him and his band down good and hard!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+38;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+38, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+12 AND `quest`=@QuestId+38;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+12, @QuestId+38);

DELETE FROM `creature_questender` WHERE `id`=@Entry+12 AND `quest`=@QuestId+38;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+12, @QuestId+38);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+38;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+38, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+38;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+38, @QuestRewardText);

SET
@QuestLevel                     := 50,
@QuestMinLevel                  := 40,
@QuestSortID                    := 978,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 7500,
@QuestRewardBonusMoney          := 6000,
@QuestRewardItem1               := 11122,
@QuestRewardAmount1             := 1,
@QuestAllowableRaces            := 0,
@QuestLogTitle                  := 'Gahz\'rilla',
@QuestLogDescription            := 'Bring Gahz\'rilla\'s Electrified Scale to Javion Padley.',
@QuestDescription               := 'Deep in Zul\'Farrak there is a sacred pool. From that pool the trolls summon a huge beast! Gahz\'rilla! He\'s so fierce that even his scales crackle with energy. It\'s that energy I want to harness for my car!$B$BBring me the electrified scale of Gahz\'rilla!$B$BBut the summoning of Gahz\'rilla is a well-kept secret of the trolls. To face him, you must first wrest the secret from them.',
@QuestCompletionLog             := 'Return to Javion Padley.',
@QuestRequiredItemId1           := 8707,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Do you have the scale? I can\'t wait to try different ways to harness its energy!',
@QuestRewardText                := 'Wow, you got the scale! Thanks, $N. I can\'t wait to get to work on this thing!$B$BSo you saw Gahz\'rilla? Was he as big as they say??';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+39;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `RewardItem1`, `RewardAmount1`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+39, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestRewardItem1, @QuestRewardAmount1, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+12 AND `quest`=@QuestId+39;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+12, @QuestId+39);

DELETE FROM `creature_questender` WHERE `id`=@Entry+12 AND `quest`=@QuestId+39;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+12, @QuestId+39);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+39;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+39, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+39;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+39, @QuestRewardText);

SET
@QuestLevel                     := 46,
@QuestMinLevel                  := 40,
@QuestSortID                    := 978,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 6500,
@QuestRewardBonusMoney          := 5250,
@QuestRewardItem1               := 9527,
@QuestRewardAmount1             := 1,
@QuestRewardItem2               := 9531,
@QuestRewardAmount2             := 1,
@QuestAllowableRaces            := 0,
@QuestLogTitle                  := 'Tiara of the Deep',
@QuestLogDescription            := 'Bring the Tiara of the Deep to Javion Padley.',
@QuestDescription               := 'Long ago I possessed a beautiful piece of jewelry, the Tiara of the Deep. And not only was it pretty--it held great power for those with the knowledge to use it.$B$BSo when word of the tiara reached the Hydromancer Velratha, she had to have it. She sent agents to my home and they stole it while I was away. The thieves!$B$BI want my tiara back! Find Velratha and wrench the tiara from her. Return it to me and you\'ll earn my favor.',
@QuestCompletionLog             := 'Return to Javion Padley.',
@QuestRequiredItemId1           := 9234,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Do you have the tiara, $N? Has Velratha learned the price of crossing me?',
@QuestRewardText                := 'Wonderful! You found it! And what\'s just as important--Velratha no longer has it! Thank you, $N. I am forever in your debt!$B$BAnd if I sounded a little... mean before, pay it no mind. You\'ll find me a much nicer person to those who haven\'t stolen from me.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+40;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `RewardItem1`, `RewardAmount1`, `RewardItem2`, `RewardAmount2`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+40, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardItem2, @QuestRewardAmount2, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+12 AND `quest`=@QuestId+40;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+12, @QuestId+40);

DELETE FROM `creature_questender` WHERE `id`=@Entry+12 AND `quest`=@QuestId+40;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+12, @QuestId+40);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+40;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+40, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+40;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+40, @QuestRewardText);

SET
@QuestLevel                     := 45,
@QuestMinLevel                  := 40,
@QuestSortID                    := 978,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 6500,
@QuestRewardBonusMoney          := 4950,
@QuestRewardFactionId1          := 369,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 0,
@QuestLogTitle                  := 'Scarab Shells',
@QuestLogDescription            := 'Bring 5 Uncracked Scarab Shells to Javion Padley.',
@QuestDescription               := 'The scarabs of Tanaris have very hard shells! Hard enough to use as a building material for lots of things. So many things!$B$BIn fact, those shells are so useful... the scarabs were hunted all to near extinction!$B$BI know where there are more scarabs, and if you promise to bring me their shells then I\'ll tell you where they are. Promise?$B$BOk, the scarabs have a colony here in Zul\'Farrak. I guess the trolls don\'t hunt them for their shells.$B$BBut you can! Go and get me uncracked shells!',
@QuestCompletionLog             := 'Return to Javion Padley.',
@QuestRequiredItemId1           := 9238,
@QuestRequiredItemCount1        := 5,

@QuestRequestitems              := 'Do you have the shells? My cousin in Booty Bay is waiting for a load of them, and he\'s getting impatient!',
@QuestRewardText                := 'Oh, great! You got them!$B$BThanks, $N. You\'re a real lifesaver!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+41;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `RewardFactionID1`, `RewardFactionValue1`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+41, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+12 AND `quest`=@QuestId+41;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+12, @QuestId+41);

DELETE FROM `creature_questender` WHERE `id`=@Entry+12 AND `quest`=@QuestId+41;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+12, @QuestId+41);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+41;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+41, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+41;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+41, @QuestRewardText);

SET
@QuestLevel                     := 45,
@QuestMinLevel                  := 40,
@QuestSortID                    := 978,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 19500,
@QuestRewardBonusMoney          := 4950,
@QuestAllowableRaces            := 0,
@QuestLogTitle                  := 'Troll Temper',
@QuestLogDescription            := 'Bring 20 Vials of Troll Temper to Javion Padley.',
@QuestDescription               := 'The Sandfury trolls make a tempering agent from sandstones, and I can use that to temper the goods I craft, yes I can! It is highly prized by connoisseurs, so if you bring me a good supply of the temper, then I\'ll reward you well.$B$BGood luck.',
@QuestCompletionLog             := 'Return to Javion Padley.',
@QuestRequiredItemId1           := 9523,
@QuestRequiredItemCount1        := 20,

@QuestRequestitems              := 'Did you bring me the temper, $N?',
@QuestRewardText                := 'Ah, this is very nice temper indeed! And so much of it! I\'ll be at work for days before I use it all!$B$BThank you, $N. Please, take this as payment.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+42;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+42, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+12 AND `quest`=@QuestId+42;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+12, @QuestId+42);

DELETE FROM `creature_questender` WHERE `id`=@Entry+12 AND `quest`=@QuestId+42;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+12, @QuestId+42);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+42;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+42, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+42;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+42, @QuestRewardText);

-- Maraudon: Dendron Skystalker
SET
@Model    := 7997,
@Name     := 'Dendron Skystalker',
@MinLevel := 48,
@MaxLevel := 48;

DELETE FROM `creature_template` WHERE `entry`=@Entry+13;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+13, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+13;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+13, 349, 19.2122, -11.5937, -127.618, 5.31322);

SET
@QuestLevel                     := 51,
@QuestMinLevel                  := 45,
@QuestSortID                    := 2100,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 6300,
@QuestRewardChoiceItemID1       := 17705,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 17743,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 17753,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestRewardFactionId1          := 609,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Corruption of Earth and Seed',
@QuestLogDescription            := 'Slay Princess Theradras and return to Dendron Skystalker.',
@QuestDescription               := 'Princess Theradras is an elemental force of earth related to the Old Gods. Ages ago, she and Zaetar, first son of Cenarius, began a relationship. The offspring of their time together became known to the people of Kalimdor as centaur. Ever-thankful creatures, the centaur killed Zaetar, and now hold Zaetar\'s remains. My quest here is to find those powerful enough to slay Theradras so we may recover Zaetar\'s remains before returning to Stonetalon.',
@QuestCompletionLog             := 'Return to Dendron Skystalker.',
@QuestRequiredNpcOrGo1          := 12201,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'I would prefer to fight this battle on our own, but we are left with no other options--we need those more powerful, and the races of Azeroth have proven without a doubt they can overcome such things when they work together. So it is to you we turn for help.$B$BI only hope it is enough.$B$BZaetar, brother to Remulos, brought many pains to this world, and ultimately it caused his own death. I just hope I have not caused more death by asking you to aid us.',
@QuestRewardText                := 'This is most wonderful news, $N! Thank you!$b$bI will speak with Marandis and ask his wisdom on the topic of Zaetar\'s remains, but at least you have overcome the hardest of the tasks.$b$bI was told that if we were successful in our mission, I had permission to reward those who aided us. I was given these items as tokens from our people--you may choose one.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+43;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+43, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+13 AND `quest`=@QuestId+43;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+13, @QuestId+43);

DELETE FROM `creature_questender` WHERE `id`=@Entry+13 AND `quest`=@QuestId+43;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+13, @QuestId+43);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+43;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+43, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+43;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+43, @QuestRewardText);

SET
@QuestLevel                     := 51,
@QuestMinLevel                  := 45,
@QuestSortID                    := 2100,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 6300,
@QuestRewardChoiceItemID1       := 17705,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 17743,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 17753,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestRewardFactionId1          := 609,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Corruption of Earth and Seed',
@QuestLogDescription            := 'Slay Princess Theradras and return to Dendron Skystalker.',
@QuestDescription               := 'Princess Theradras is an elemental force of earth related to the Old Gods. Ages ago, she and Zaetar, first son of Cenarius, began a relationship. The offspring of their time together became known to the people of Kalimdor as centaur. Ever-thankful creatures, the centaur killed Zaetar, and now hold Zaetar\'s remains. My quest here is to find those powerful enough to slay Theradras so we may recover Zaetar\'s remains before returning to Stonetalon.',
@QuestCompletionLog             := 'Return to Dendron Skystalker.',
@QuestRequiredNpcOrGo1          := 12201,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'I feel the weight of imposing my plea on the mortal races, but we are left with no other options. The races of Azeroth have proven without a doubt they can overcome such things when they work together, so it is to them I ask for help.$B$BI only hope it is enough.$B$BZaetar, brother to Remulos, brought many pains to this world, and ultimately it caused his own death. There is a lesson there to all of us if we are wise enough to see it.',
@QuestRewardText                := 'This is most wonderful news, $N! Thank you!$B$BAlthough it concerns me that you were not able to bring back Zaetar\'s remains, who am I to question the will of Cenarius\' first born. Perhaps now the will of the centaur will break and their thirst for blood will lesson--we can only hope.$B$BIf successful in our mission, I was given these items to reward any who aided us. You may choose one as a token of thanks.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+44;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+44, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+13 AND `quest`=@QuestId+44;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+13, @QuestId+44);

DELETE FROM `creature_questender` WHERE `id`=@Entry+13 AND `quest`=@QuestId+44;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+13, @QuestId+44);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+44;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+44, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+44;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+44, @QuestRewardText);

-- Sunken Temple: Taesosh
SET
@Model    := 10171,
@Name     := 'Taesosh',
@MinLevel := 50,
@MaxLevel := 50;

DELETE FROM `creature_template` WHERE `entry`=@Entry+14;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+14, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+14;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+14, 109, -349.203, 100.612, -131.85, 6.28016);

SET
@QuestLevel                     := 50,
@QuestMinLevel                  := 38,
@QuestSortID                    := 1417,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 6000,
@QuestRewardItem1               := 1490,
@QuestRewardAmount1             := 1,
@QuestRewardFactionId1          := 76,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'The Temple of Atal\'Hakkar',
@QuestLogDescription            := 'Collect 20 Fetishes of Hakkar and bring them to Taesosh.',
@QuestDescription               := 'The Atal\'ai spiritual leader believes once Hakkar returns to Azeroth from the Nether, the god will grant the Atal\'ai tribe immortality.$b$bFoolish trickery to bring about a premature doomsday if you ask me.$b$bBut you say the exile spoke of enchanted fetishes? This concerns me greatly. If these are in fact the key to the Atal\'ai ritual which caused this mess, we must understand their intrinsic powers.$b$bYou must seize the fetishes!',
@QuestCompletionLog             := 'Return to Taesosh.',
@QuestRequiredItemId1           := 6181,
@QuestRequiredItemCount1        := 20,

@QuestRequestitems              := 'If the Atal\'ai fetishes hold the power to summon Hakkar and fulfill Jammal\'an\'s prophecy they must be seized. Such powers must be understood by the Horde!',
@QuestRewardText                := 'Brave $c, you have proven yourself to be a great champion of the Horde.$b$bNow this collection of fetishes of Hakkar must be dealt with at once!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+45;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardItem1`, `RewardAmount1`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+45, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+14 AND `quest`=@QuestId+45;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+14, @QuestId+45);

DELETE FROM `creature_questender` WHERE `id`=@Entry+14 AND `quest`=@QuestId+45;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+14, @QuestId+45);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+45;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+45, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+45;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+45, @QuestRewardText);

SET
@QuestLevel                     := 53,
@QuestMinLevel                  := 38,
@QuestSortID                    := 1417,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 6900,
@QuestRewardChoiceItemID1       := 11123,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 11124,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestAllowableRaces            := 0,
@QuestLogTitle                  := 'Jammal\'an the Prophet',
@QuestLogDescription            := 'Taesosh wants the Head of Jammal\'an.',
@QuestDescription               := 'My Witherbark companions don\'t take kindly to strangers around their home.$b$bMe? I don\'t have a home anymore. I was exiled from my people, the great Atal\'ai tribe of the Swamp of Sorrows.$b$bOur spiritual leader, Jammal\'an, had what he called a prophecy. He believes the summoning of the god, Hakkar will bring the Atal\'ai immortality.$b$bBut I urged caution. What if the prophecy was nothing more than manipulation?$b$bI want revenge for my exile. Bring me Jammal\'an\'s head. Maybe then my people will be free.',
@QuestCompletionLog             := 'Return to Taesosh.',
@QuestRequiredItemId1           := 6212,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Once Jammal\'an has been removed, I stand a chance of returning to my people.$b$bWith Jammal\'an as their spiritual leader, the Atal\'ai face certain destruction.',
@QuestRewardText                := 'Jammal\'an\'s reckless trust of false visions led my people to their eternal doom.$b$bI thank you, $c, for avenging my exile. I mourn for my people. I have no home to return to.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+46;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+46, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+14 AND `quest`=@QuestId+46;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+14, @QuestId+46);

DELETE FROM `creature_questender` WHERE `id`=@Entry+14 AND `quest`=@QuestId+46;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+14, @QuestId+46);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+46;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+46, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+46;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+46, @QuestRewardText);

-- Blackrock Depths: Ugdarn Wildhold
SET
@Model    := 10184,
@Name     := 'Ugdarn Wildhold',
@MinLevel := 56,
@MaxLevel := 56;

DELETE FROM `creature_template` WHERE `entry`=@Entry+15;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+15, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+15;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+15, 230, 450.705, -0.353959, -70.3875, 1.48246);

SET
@QuestLevel                     := 56,
@QuestMinLevel                  := 48,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 25500,
@QuestRewardBonusMoney          := 7500,
@QuestRewardChoiceItemID1       := 12113,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 12114,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 12112,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestRewardChoiceItemID4       := 12115,
@QuestRewardChoiceItemQuantity4 := 1,
@QuestRewardFactionId1          := 81,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Disharmony of Fire',
@QuestLogDescription            := 'Track down Lord Incendius. Slay him and return any source of information you may find to Ugdarn Wildhold.$B',
@QuestDescription               := 'I can taste the foulness in the air that surrounds you, $N. There is another, hidden in the depths, who does control this foulness.$B$BThe wind and earth cry his name: Lord Incendius... but someone... something... commands this being. He is merely an emissary.$B$BFind him and discover where his master hides. Return to me when you have collected this information.',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredNpcOrGo1          := 9017,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'The flames will soon overtake these lands. Make haste, $N!',
@QuestRewardText                := '<Ugdarn Wildhold clutches the Tablet of Kurniya.>$b$bRagnaros... here...$b$bThe elders were right to fear the corruption emanating from Blackrock Mountain. A general of the Old Gods! IN OUR WORLD! We must reassess our position. We must decide on whether we stay and fight or run for fear of a new sundering.$b$bBe weary of any further exploration, $N. A far greater evil than anything that exists in this world resides in those fiery depths.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+47;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `RewardChoiceItemID4`, `RewardChoiceItemQuantity4`, `RewardFactionID1`, `RewardFactionValue1`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+47, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestRewardChoiceItemID4, @QuestRewardChoiceItemQuantity4, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+47;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+47);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+47;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+47);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+47;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+47, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+47;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+47, @QuestRewardText);

SET
@QuestLevel                     := 59,
@QuestMinLevel                  := 48,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 8400,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'The Royal Rescue',
@QuestLogDescription            := 'Slay Emperor Dagran Thaurissan and free Princess Moira Bronzebeard from his evil spell. $B',
@QuestDescription               := 'This strike against the Dark Iron dwarves, if successful, will send a shockwave throughout their entire kingdom.$B$BPrincess Bronzebeard is under the control of Emperor Thaurissan. To free her, you must kill the Emperor. Be warned, your task is doubly dangerous, as Bronzebeard will attack you without question while under the control of the Emperor.$B$BDO NOT HARM HER!',
@QuestCompletionLog             := 'Speak to Princess Moira Bronzebeard near the throne.',
@QuestRequiredNpcOrGo1          := 9019,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := '<Princess Moira cowers in fear.>',
@QuestRewardText                := 'What have you done!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+48;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+48, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+48;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+48);

DELETE FROM `creature_questender` WHERE `id`=8929 AND `quest`=@QuestId+48;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(8929, @QuestId+48);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+48;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+48, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+48;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+48, @QuestRewardText);

SET
@QuestLevel                     := 58,
@QuestMinLevel                  := 52,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 26500,
@QuestRewardBonusMoney          := 8100,
@QuestRewardChoiceItemID1       := 12109,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 12110,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 12108,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestRewardChoiceItemID4       := 12111,
@QuestRewardChoiceItemQuantity4 := 1,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'The Rise of the Machines',
@QuestLogDescription            := 'Find and slay Golem Lord Argelmach. Return his head to Ugdarn Wildhold. You will also need to collect 10 Intact Elemental Cores from the Ragereaver Golems and Warbringer Constructs protecting Argelmach. You know this because you are psychic.',
@QuestDescription               := 'This can\'t be Argelmach! Argelmach was killed ten years ago. How can I be sure? I was the one who killed him.$B$BHe was a despicable dwarf, hell-bent on twisting my life\'s work to meet his diabolical needs. It seems that the wicked always find a way to escape justice.$B$BIf this is Argelmach\'s handiwork then he must be destroyed. I will need samplings of his latest creations. With the proper samples, I may be able to stop this uprising. The creations guard Argelmach.',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredItemId1           := 11268,
@QuestRequiredItemId2           := 11269,
@QuestRequiredItemCount1        := 1,
@QuestRequiredItemCount2        := 10,

@QuestRequestitems              := 'Was it him? Was he really alive?',
@QuestRewardText                := 'What is this?!? This head is not flesh. This is some sort of dark iron creation: A shadow of Argelmach - ANOTHER machine! I suspect that your destruction of Argelmach will be short lived as another shall rise to take \'its\' place soon.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+49;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `RewardChoiceItemID4`, `RewardChoiceItemQuantity4`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemId2`, `RequiredItemCount1`, `RequiredItemCount2`) VALUES
(@QuestId+49, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestRewardChoiceItemID4, @QuestRewardChoiceItemQuantity4, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemId2, @QuestRequiredItemCount1, @QuestRequiredItemCount2);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+49;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+49);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+49;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+49);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+49;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+49, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+49;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+49, @QuestRewardText);

SET
@QuestLevel                     := 52,
@QuestMinLevel                  := 48,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 15500,
@QuestRewardBonusMoney          := 6600,
@QuestRewardFactionId1          := 76,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Dark Iron Dwarves',
@QuestLogDescription            := 'Destroy the vile aggressors!$B$BUgdarn Wildhold wants you to kill 15 Anvilrage Guardsmen, 10 Anvilrage Wardens and 5 Anvilrage Footmen. Return to him once your task is complete.',
@QuestDescription               := 'Any and all of General Angerforge\'s forces must be annihilated.$B$BAngerforge\'s men are ruthless killers, responsible for the mass murder of the 109th division of the Kargath Expeditionary Force. You are warned to exercise extreme caution when confronting these brutes.$B$BIf you manage to destroy the first line of General Angerforge\'s forces, you shall receive a tribute.',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredNpcOrGo1          := 8891,
@QuestRequiredNpcOrGo2          := 8890,
@QuestRequiredNpcOrGo3          := 8892,
@QuestRequiredNpcOrGoCount1     := 15,
@QuestRequiredNpcOrGoCount2     := 10,
@QuestRequiredNpcOrGoCount3     := 5,

@QuestRequestitems              := 'What is it, $r? Don\'t you know I have a platoon to command?',
@QuestRewardText                := 'This first strike should put a crease in Angerforge\'s pants. Now, move along soldier. I have work to complete, battles to plan, enemies to crush!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+50;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGo2`, `RequiredNpcOrGo3`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGoCount2`, `RequiredNpcOrGoCount3`) VALUES
(@QuestId+50, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGo2, @QuestRequiredNpcOrGo3, @QuestRequiredNpcOrGoCount1, @QuestRequiredNpcOrGoCount2, @QuestRequiredNpcOrGoCount3);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+50;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+50);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+50;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+50);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+50;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+50, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+50;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+50, @QuestRewardText);

SET
@QuestLevel                     := 54,
@QuestMinLevel                  := 48,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 16500,
@QuestRewardBonusMoney          := 7200,
@QuestRewardFactionId1          := 76,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'High Ranking Dark Iron Officials',
@QuestLogDescription            := 'Destroy the vile aggressors!$B$BUgdarn Wildhold wants you to kill 10 Anvilrage Medics, 10 Anvilrage Soldiers and 10 Anvilrage Officers. Return to him once your task is complete.',
@QuestDescription               := 'Head of the K.E.F. reconnaissance division, Grandmaster Lexlort, has returned with news of the whereabouts of high ranking Dark Iron officials. Through locked gate, near the heart of the city, they train their forces to snuff out our men. You must destroy them!$B$BCompletion of this mission will result in a tribute.',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredNpcOrGo1          := 8894,
@QuestRequiredNpcOrGo2          := 8893,
@QuestRequiredNpcOrGo3          := 8895,
@QuestRequiredNpcOrGoCount1     := 10,
@QuestRequiredNpcOrGoCount2     := 10,
@QuestRequiredNpcOrGoCount3     := 10,

@QuestRequestitems              := 'You again? I have to hand it to you, $N, you are tenacious.',
@QuestRewardText                := 'Angerforge is undoubtedly... angry.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+51;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardFactionID1`, `RewardFactionValue1`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGo2`, `RequiredNpcOrGo3`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGoCount2`, `RequiredNpcOrGoCount3`) VALUES
(@QuestId+51, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGo2, @QuestRequiredNpcOrGo3, @QuestRequiredNpcOrGoCount1, @QuestRequiredNpcOrGoCount2, @QuestRequiredNpcOrGoCount3);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+51;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+51);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+51;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+51);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+51;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+51, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+51;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+51, @QuestRewardText);

SET
@QuestLevel                     := 55,
@QuestMinLevel                  := 50,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 8500,
@QuestRewardBonusMoney          := 7500,
@QuestAllowableRaces            := 0,
@QuestLogTitle                  := 'The Heart of the Mountain',
@QuestLogDescription            := 'Bring the Heart of the Mountain to Ugdarn Wildhold.',
@QuestDescription               := 'For years I have sought a certain gem.  It is called the Heart of the Mountain and it\'s the size of your fist! The Dark Iron dwarves have it locked in their vault and, try as I may, they won\'t let me purchase it.$B$BSo I must resort to force.$B$BFight your way to the Lower Vault, breach its secret safe and gain the Heart. To do that,you must defeat Watchman Doomgrip, and he won\'t appear until you\'ve opened every relic coffer in the vault!$B$BGood luck.',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredItemId1           := 11309,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Do you have the Heart of the Mountain? To me, its value is without limit.',
@QuestRewardText                := 'You have the heart! Amazing! It is even more beautiful than I imagined!$B$BPlease, $N, take this as payment!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+52;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+52, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+52;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+52);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+52;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+52);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+52;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+52, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+52;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+52, @QuestRewardText);

SET
@QuestLevel                     := 55,
@QuestMinLevel                  := 50,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 16500,
@QuestRewardBonusMoney          := 7500,
@QuestRewardItem1               := 12003,
@QuestRewardAmount1             := 10,
@QuestRewardChoiceItemID1       := 11964,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 12000,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Hurley Blackbreath',
@QuestLogDescription            := 'Bring the Lost Thunderbrew Recipe to Ugdarn Wildhold.',
@QuestDescription               := 'The Dark Iron dwarves, led by the villain Hurley Blackbreath, stole one of the Thunderbrew\'s best recipes, Thunderbrew Lager. The villains! They don\'t deserve such a fine brew!$B$B$N, I have a tough task for you. Destroy any kegs of Thunderbrew Lager you find, and bring back our recipe for Thunderbrew Lager!$B$BPlease, get that recipe back, even if you have to turn this place upside down to do it!',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredItemId1           := 11312,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Do you have the recipe, $N? I can\'t stand the idea of those Dark Iron dwarves drinking my family\'s drink!',
@QuestRewardText                := 'You found it! Well done! And I hope you gave those Dark Irons, and Hurley Blackbreath, a good thumping!$b$bThe Thunderbrews are at your service, $N. You are a hero of heroes!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+53;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardItem1`, `RewardAmount1`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+53, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+53;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+53);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+53;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+53);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+53;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+53, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+53;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+53, @QuestRewardText);

SET
@QuestLevel                     := 58,
@QuestMinLevel                  := 52,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 26500,
@QuestRewardBonusMoney          := 8100,
@QuestRewardItem1               := 12059,
@QuestRewardAmount1             := 1,
@QuestRewardFactionId1          := 76,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Death to Angerforge',
@QuestLogDescription            := 'Slay General Angerforge! Return to Ugdarn Wildhold when the task is complete.',
@QuestDescription               := 'You have done an exemplary job, $N. It is now time to send you on your last mission.$B$BGeneral Angerforge, the Dark Iron responsible for coordinating the attacks on the 109th division of the K.E.F. and the mass slaughter of our forces must be brought to justice.$B$BThis will undoubtedly be your most grueling mission, but should you succeed, you will be richly rewarded.',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredNpcOrGo1          := 9033,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'Has the Butcher of Blackrock been disposed of?',
@QuestRewardText                := 'Finally! The villain been brought to justice! You are a remarkable individual, $N. Wear this medallion as a symbol of your stalwart dedication to the Horde and the K.E.F.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+54;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardItem1`, `RewardAmount1`, `RewardFactionID1`, `RewardFactionValue1`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+54, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+54;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+54);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+54;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+54);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+54;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+54, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+54;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+54, @QuestRewardText);

SET
@QuestLevel                     := 55,
@QuestMinLevel                  := 50,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 8500,
@QuestRewardBonusMoney          := 7500,
@QuestRewardItem1               := 3928,
@QuestRewardAmount1             := 5,
@QuestRewardItem2               := 6149,
@QuestRewardAmount2             := 5,
@QuestRewardChoiceItemID1       := 11964,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 12000,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Lost Thunderbrew Recipe',
@QuestLogDescription            := 'Bring the Lost Thunderbrew Recipe to Ugdarn Wildhold.',
@QuestDescription               := 'It is rumored that the Dark Iron Hurley Blackbreath has stolen a recipe for ale. This ale, Thunderbrew Lager, is said to infuse its imbiber with great strength and courage. We wish to study the drink. Perhaps, we will find other applications for its virtues... applications more in line with Forsaken objectives.$B$BFind Hurley, take from him the recipe for Thunderbrew lager and bring it to me.$B$BAnd to find him, you may have to entice him by threatening his precious ale.',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredItemId1           := 11312,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Do you have the recipe for the Thunderbrew Lager, $N?',
@QuestRewardText                := 'Very good. I will send this recipe to the Apothecarium to be studied, and in time we will unlock its secrets. One day, the dwarves of the Alliance may find the virtues of this drink used against them!$b$bI find that terribly amusing. Perhaps death has an affect on one\'s sense of humor... do you think?';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+55;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardItem1`, `RewardAmount1`, `RewardItem2`, `RewardAmount2`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+55, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardItem2, @QuestRewardAmount2, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+55;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+55);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+55;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+55);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+55;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+55, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+55;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+55, @QuestRewardText);

SET
@QuestLevel                     := 53,
@QuestMinLevel                  := 48,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 6000,
@QuestRewardBonusMoney          := 6900,
@QuestRewardChoiceItemID1       := 11865,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 11963,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 12049,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestAllowableRaces            := 0,
@QuestLogTitle                  := 'Ribbly Screwspigot',
@QuestLogDescription            := 'Bring Ribbly\'s Head to Ugdarn Wildhold.',
@QuestDescription               := 'My brother Ribbly has always been a drain to his family, taking our money and wasting it on one scheme after another.$B$BWell, his last scheme must have been his worst, because Baron Revilgaz of Booty Bay just put a price on poor Ribbly\'s head. I can\'t tell you how happy this makes the Screwspigots! Our little Ribbly\'s finally worth something!$B$BBut now he\'s hiding. Please, find him and bring him to me!$B$BOr, if he won\'t come, then that\'s ok... just bring me his head.',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredItemId1           := 11313,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Do you have Ribbly? Or, at least a part of him?',
@QuestRewardText                := 'Aha! You found him! And... it appears that my little brother didn\'t want to come quiety. It\'s a pity. I would have liked to see the look on his face when I told him our plans to turn him in to Revilgaz.$b$bThank you, $N. You\'ve made my family very happy. And Ribbly\'s never looked as peaceful as he does now.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+56;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+56, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+56;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+56);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+56;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+56);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+56;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+56, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+56;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+56, @QuestRewardText);

SET
@QuestLevel                     := 56,
@QuestMinLevel                  := 48,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 8500,
@QuestRewardBonusMoney          := 7500,
@QuestRewardChoiceItemID1       := 12113,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 12114,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardChoiceItemID3       := 12112,
@QuestRewardChoiceItemQuantity3 := 1,
@QuestRewardChoiceItemID4       := 12115,
@QuestRewardChoiceItemQuantity4 := 1,
@QuestRewardFactionId1          := 54,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Incendius!',
@QuestLogDescription            := 'Find Lord Incendius and destroy him!',
@QuestDescription               := 'Lord Incendius is purported to be a minion of Ragnaros! Oh dear, oh dear... whatever will we do?$B$BDo you think you can handle another mission? I don\'t have anybody else to send, $N!$B$BWe will never get a team in if Incendius continues to raise Pyron from the ashes.$B$BYou\'ll have to find and destroy Lord Incendius!',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredNpcOrGo1          := 9017,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := 'Is the fiend dead??',
@QuestRewardText                := 'Oh dear! Are you sure Incendius said \'Ragnaros?\'$b$b<Ugdarn hands you something and pats you on the wrist as he fades deep into thought.>';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+57;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardChoiceItemID3`, `RewardChoiceItemQuantity3`, `RewardChoiceItemID4`, `RewardChoiceItemQuantity4`, `RewardFactionID1`, `RewardFactionValue1`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+57, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardChoiceItemID3, @QuestRewardChoiceItemQuantity3, @QuestRewardChoiceItemID4, @QuestRewardChoiceItemQuantity4, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+57;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+57);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+57;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+57);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+57;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+57, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+57;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+57, @QuestRewardText);

SET
@QuestLevel                     := 56,
@QuestMinLevel                  := 50,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 8500,
@QuestRewardBonusMoney          := 7500,
@QuestRewardItem1               := 11883,
@QuestRewardAmount1             := 1,
@QuestRewardFactionId1          := 47,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'The Good Stuff',
@QuestLogDescription            := 'Collect 20 Dark Iron Fanny Packs.',
@QuestDescription               := 'Captain Winky tells me that the Dark Irons in the Depths got all the good stuff. Ain\'t that right, Winky?$B$B<Ugdarn does his best impersonation of a pirate.>$B$BARRR MATEY! IT BE RIGHT!$B$BSee what I\'m saying? You need to bring me some samples of the good stuff.$B$BGet in there and shake your moneymaker!$B',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredItemId1           := 11468,
@QuestRequiredItemCount1        := 20,

@QuestRequestitems              := 'I can\'t be bothered right now, $N. Me and Winky got a meeting to attend.',
@QuestRewardText                := '<Ugdarn starts rummaging through the mountainous pile of fanny packs.>$B$BOH WONDERFUL!$B$B<Ugdarn sticks his large nose into the pile and takes a whiff.>$B$BDELICIOUS! Look at all these goodies!$B$BTake one for yourself, $N. There\'s plenty to go around.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+58;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardItem1`, `RewardAmount1`, `RewardFactionID1`, `RewardFactionValue1`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+58, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+58;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+58);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+58;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+58);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+58;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+58, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+58;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+58, @QuestRewardText);

SET
@QuestLevel                     := 59,
@QuestMinLevel                  := 50,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardBonusMoney          := 8400,
@QuestRewardFactionId1          := 47,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'The Fate of the Kingdom',
@QuestLogDescription            := 'Rescue Princess Moira Bronzebeard from the evil clutches of Emperor Dagran Thaurissan.',
@QuestDescription               := 'It would seem as if my old adversary, Dagran Thaurissan, has me and the kingdom of Ironforge at his mercy.$B$BYou may be my last hope, $N. You must rescue my dear daughter, Moira!$B$BThere is only one way to make sure that the spell Thaurissan has cast on Moira is broken: Kill him.$B$BAnd $N, do not harm her! Remember, she is being controlled by Thaurissan! The things she may do or say are a result of Thaurissan\'s evil spell!',
@QuestCompletionLog             := 'Speak to Princess Moira Bronzebeard near the throne in Blackrock Depths.',
@QuestRequiredNpcOrGo1          := 9019,
@QuestRequiredNpcOrGoCount1     := 1,

@QuestRequestitems              := '',
@QuestRewardText                := '<Princess Bronzebeard weeps over the loss of Emperor Dagran Thaurissan.>$B$BWhy???';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+59;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardBonusMoney`, `RewardFactionID1`, `RewardFactionValue1`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`) VALUES
(@QuestId+59, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardBonusMoney, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredNpcOrGo1, @QuestRequiredNpcOrGoCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+59;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+59);

DELETE FROM `creature_questender` WHERE `id`=8929 AND `quest`=@QuestId+59;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(8929, @QuestId+59);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+59;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+59, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+59;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+59, @QuestRewardText);

SET
@QuestLevel                     := 54,
@QuestMinLevel                  := 48,
@QuestSortID                    := 1584,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 24500,
@QuestRewardBonusMoney          := 7200,
@QuestRewardItem1               := 12038,
@QuestRewardAmount1             := 1,
@QuestRewardFactionId1          := 68,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'The Last Element',
@QuestLogDescription            := 'Recover 10 Essence of the Elements. Your first inclination is to search the golems and golem makers.',
@QuestDescription               := 'There is work to be had for those venturing into the depths, $N.$B$BThe Dark Irons have mastered creation of extremely powerful golems.$B$BInitial reports from our spies indicate that the dwarves use a unique power source to give their creations incomparable killing power.$B$BJust imagine what we could do with our abominations if we could get our hands on this essence of the elements! Turn that city upside down if you must, but do not return until you have found the essence! Payment will be worth the risk.',
@QuestCompletionLog             := 'Return to Ugdarn Wildhold.',
@QuestRequiredItemId1           := 11129,
@QuestRequiredItemCount1        := 10,

@QuestRequestitems              := 'Show them to me!',
@QuestRewardText                := 'Wonderful! I will have these sent by courier to the Undercity at once!$B$BAs for you - here is payment, as promised. Keep the change, you filthy beast!';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+60;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardItem1`, `RewardAmount1`, `RewardFactionID1`, `RewardFactionValue1`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+60, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+15 AND `quest`=@QuestId+60;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+60);

DELETE FROM `creature_questender` WHERE `id`=@Entry+15 AND `quest`=@QuestId+60;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+15, @QuestId+60);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+60;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+60, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+60;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+60, @QuestRewardText);

-- Dire Maul (East): Gronladan Ravenoak
SET
@Model    := 2264,
@Name     := 'Gronladan Ravenoak',
@MinLevel := 60,
@MaxLevel := 60;

DELETE FROM `creature_template` WHERE `entry`=@Entry+16;
INSERT INTO `creature_template` (`entry`, `modelid1`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `unit_class`, `unit_flags`, `type`, `type_flags`, `flags_extra`) VALUES
(@Entry+16, @Model, @Name, @Title, @Icon, @GossipMenu, @MinLevel, @MaxLevel, @FactionFriendly, @NPCFlag, 1, 1, @Scale, @Rank, 1, @UnitFlags, @Type, @TypeFlags, @FlagsExtra);

DELETE FROM `creature` WHERE `id1`=@Entry+16;
INSERT INTO `creature` (`id1`, `map`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES 
(@Entry+16, 429, 61.9005, -148.875, -2.71438, 3.97019);

SET
@QuestLevel                     := 58,
@QuestMinLevel                  := 54,
@QuestSortID                    := 2557,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 17500,
@QuestRewardBonusMoney          := 7200,
@QuestRewardChoiceItemID1       := 18411,
@QuestRewardChoiceItemQuantity1 := 1,
@QuestRewardChoiceItemID2       := 18410,
@QuestRewardChoiceItemQuantity2 := 1,
@QuestRewardFactionId1          := 809,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 0,
@QuestLogTitle                  := 'Pusillin and the Elder Azj\'Tordin',
@QuestLogDescription            := 'Locate the Imp, Pusillin. Convince Pusillin to give you Azj\'Tordin\'s Book of Incantations through any means necessary.$B$BReturn to Gronladan Ravenoak should you recover the Book of Incantations.',
@QuestDescription               := 'I had let my guard down for only one moment, stranger. In my haste to escape the grip of the fallen Prince, I was robbed. A most foul demon, the imp Pusillin, pilfered my book of incantations and the key to the once great halls of Eldre\'Thalas.$B$BI no longer hold interest in the key, as I have exchanged my immortality for freedom, but I desperately need my book of incantations.$B$BFind the imp, Pusillin, and recover my book.$B$BSearch the Warpwood Quarter for Pusillin.',
@QuestCompletionLog             := 'Return to Gronladan Ravenoak.',
@QuestRequiredItemId1           := 18261,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'I regret nothing, stranger. The Queen has long since passed. The works of the Shen\'Dralar have been marred by the madness of Prince Tortheldrin. I seek only freedom... Escape...',
@QuestRewardText                := 'You have found it! A curse upon that miserable imp. Alas, my material possessions are meager at best. You may choose from what I have to offer.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+61;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardChoiceItemID1`, `RewardChoiceItemQuantity1`, `RewardChoiceItemID2`, `RewardChoiceItemQuantity2`, `RewardFactionID1`, `RewardFactionValue1`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+61, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardChoiceItemID1, @QuestRewardChoiceItemQuantity1, @QuestRewardChoiceItemID2, @QuestRewardChoiceItemQuantity2, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+16 AND `quest`=@QuestId+61;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+16, @QuestId+61);

DELETE FROM `creature_questender` WHERE `id`=@Entry+16 AND `quest`=@QuestId+61;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+16, @QuestId+61);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+61;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+61, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+61;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+61, @QuestRewardText);

SET
@QuestLevel                     := 57,
@QuestMinLevel                  := 54,
@QuestSortID                    := 2557,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 17000,
@QuestRewardBonusMoney          := 7800,
@QuestRewardItem1               := 18491,
@QuestRewardAmount1             := 1,
@QuestRewardFactionId1          := 469,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 1101,
@QuestLogTitle                  := 'Lethtendris\'s Web',
@QuestLogDescription            := 'Bring Lethtendris\' Web to Gronladan Ravenoak.',
@QuestDescription               := 'The mage Lethtendris, a vicious blood elf whose brutality is matched only by her twisted addiction to magic, has fled. She has created a device, a web to ensnare the magical energies of that place and we fear that, if left unchecked, she will cause irreparable damage to our world!$B$BStop her, $N. Find her and retrieve her web. She is likely near the satyrs in Warpwood Quarter. Bring the web to me so that its power may be released safely back into the wilds...',
@QuestCompletionLog             := 'Return to Gronladan Ravenoak.',
@QuestRequiredItemId1           := 18426,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := 'Do you have the web, $N?  Its concentrated magical energy must be dissipated!',
@QuestRewardText                := 'You retrieved the web! Well done, $N! Lethtendris, like many elves of her ilk, are blind to the dangers the abuse of magic can cause to our world. They believe they are masters of magic; they do not realize that they are slaves to their own addiction. Her death saddens me, but it was necessary.$B$BThank you, $N. I will have the energies within the web released safely over a wide area, and then I\'ll destroy it to prevent future magical exploits.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+62;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardItem1`, `RewardAmount1`, `RewardFactionID1`, `RewardFactionValue1`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+62, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+16 AND `quest`=@QuestId+62;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+16, @QuestId+62);

DELETE FROM `creature_questender` WHERE `id`=@Entry+16 AND `quest`=@QuestId+62;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+16, @QuestId+62);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+62;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+62, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+62;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+62, @QuestRewardText);

SET
@QuestLevel                     := 57,
@QuestMinLevel                  := 54,
@QuestSortID                    := 2557,
@QuestRewardXPDifficulty        := 7,
@QuestRewardMoney               := 17000,
@QuestRewardBonusMoney          := 7800,
@QuestRewardItem1               := 18491,
@QuestRewardAmount1             := 1,
@QuestRewardFactionId1          := 67,
@QuestRewardFactionValue1       := 7,
@QuestAllowableRaces            := 690,
@QuestLogTitle                  := 'Lethtendris\'s Web',
@QuestLogDescription            := 'Bring Lethtendris\' Web to Gronladan Ravenoak.',
@QuestDescription               := 'The blood elf Lethtendris has overstepped her bounds. So eager was she to gather magical power that she defied her brethren and created a device of insidious design, a web meant to siphon the tainted magical energies of Dire Maul. Even now she gathers those energies and plans to release them against her enemies.$B$BLethtendris must be stopped. Find her within the Warpwood Quarter, defeat her and bring her web to me so that it might be returned to more clear-headed blood elves for study.',
@QuestCompletionLog             := 'Return to Gronladan Ravenoak.',
@QuestRequiredItemId1           := 18426,
@QuestRequiredItemCount1        := 1,

@QuestRequestitems              := '$N, do you have Lethtendris\'s Web?',
@QuestRewardText                := 'You have done well, $N. This web holds within it vast stores of the magic of Dire Maul, and I fear what damage may be unleashed if those energies were harnessed by one so irresponsible as Lethtendris. I am saddened by her death, but I know that she could never part with her web while alive.$b$bThank you, $N. I will send the web to students of magic more responsible than Lethtendris. They will be the new wardens of its power.';

DELETE FROM `quest_template` WHERE `ID`=@QuestId+63;
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestSortID`, `QuestInfoID`, `RewardXPDifficulty`, `RewardMoney`, `RewardBonusMoney`, `RewardItem1`, `RewardAmount1`, `RewardFactionID1`, `RewardFactionValue1`, `Flags`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredItemId1`, `RequiredItemCount1`) VALUES
(@QuestId+63, @QuestType, @QuestLevel, @QuestMinLevel, @QuestSortID, @QuestInfoID, @QuestRewardXPDifficulty, @QuestRewardMoney, @QuestRewardBonusMoney, @QuestRewardItem1, @QuestRewardAmount1, @QuestRewardFactionId1, @QuestRewardFactionValue1, @QuestFlags, @QuestAllowableRaces, @QuestLogTitle, @QuestLogDescription, @QuestDescription, @QuestCompletionLog, @QuestRequiredItemId1, @QuestRequiredItemCount1);

DELETE FROM `creature_queststarter` WHERE `id`=@Entry+16 AND `quest`=@QuestId+63;
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES 
(@Entry+16, @QuestId+63);

DELETE FROM `creature_questender` WHERE `id`=@Entry+16 AND `quest`=@QuestId+63;
INSERT INTO `creature_questender` (`id`, `quest`) VALUES 
(@Entry+16, @QuestId+63);

DELETE FROM `quest_request_items` WHERE `ID`=@QuestId+63;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`) VALUES
(@QuestId+63, @QuestRequestItems);

DELETE FROM `quest_offer_reward` WHERE `ID`=@QuestId+63;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`) VALUES
(@QuestId+63, @QuestRewardText);
