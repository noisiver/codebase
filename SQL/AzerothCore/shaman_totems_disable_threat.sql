/*
SELECT `ID`, `Category`, `Dispel` AS `DispelType`, `Mechanic`, `Attributes`, `AttributesEx`, `AttributesEx2`, `AttributesEx3`, `AttributesEx4`, `AttributesEx5`, `AttributesEx6`, `AttributesEx7`, `Stances` AS `ShapeshiftMask`, `Unknown1` AS `unk_320_2`, `StancesNot` AS `ShapeshiftExclude`, `Unknown2` AS `unk_320_3`, `Targets`, `TargetCreatureType`, `RequiresSpellFocus`, `FacingCasterFlags`, `CasterAuraState`, `TargetAuraState`, `CasterAuraStateNot` AS `ExcludeCasterAuraState`, `TargetAuraStateNot` AS `ExcludeTargetAuraState`, `CasterAuraSpell`, `TargetAuraSpell`, `ExcludeCasterAuraSpell`, `ExcludeTargetAuraSpell`, `CastingTimeIndex`, `RecoveryTime`, `CategoryRecoveryTime`, `InterruptFlags`, `AuraInterruptFlags`, `ChannelInterruptFlags`, `ProcFlags` AS `ProcTypeMask`, `ProcChance`, `ProcCharges`, `MaximumLevel` AS `MaxLevel`, `BaseLevel`, `SpellLevel`, `DurationIndex`, `PowerType`, `ManaCost`, `ManaCostPerLevel`, `ManaPerSecond`, `ManaPerSecondPerLevel`, `RangeIndex`, `Speed`, `ModalNextSpell`, `StackAmount` AS `CumulativeAura`, `Totem1` AS `Totem_1`, `Totem2` AS `Totem_2`, `Reagent1` AS `Reagent_1`, `Reagent2` AS `Reagent_2`, `Reagent3` AS `Reagent_3`, `Reagent4` AS `Reagent_4`, `Reagent5` AS `Reagent_5`, `Reagent6` AS `Reagent_6`, `Reagent7` AS `Reagent_7`, `Reagent8` AS `Reagent_8`, `ReagentCount1` AS `ReagentCount_1`, `ReagentCount2` AS `ReagentCount_2`, `ReagentCount3` AS `ReagentCount_3`, `ReagentCount4` AS `ReagentCount_4`, `ReagentCount5` AS `ReagentCount_5`, `ReagentCount6` AS `ReagentCount_6`, `ReagentCount7` AS `ReagentCount_7`, `ReagentCount8` AS `ReagentCount_8`, `EquippedItemClass`, `EquippedItemSubClassMask` AS `EquippedItemSubclass`, `EquippedItemInventoryTypeMask` AS `EquippedItemInvTypes`, `Effect1` AS `Effect_1`, `Effect2` AS `Effect_2`, `Effect3` AS `Effect_3`, `EffectDieSides1` AS `EffectDieSides_1`, `EffectDieSides2` AS `EffectDieSides_2`, `EffectDieSides3` AS `EffectDieSides_3`, `EffectRealPointsPerLevel1` AS `EffectRealPointsPerLevel_1`, `EffectRealPointsPerLevel2` AS `EffectRealPointsPerLevel_2`, `EffectRealPointsPerLevel3` AS `EffectRealPointsPerLevel_3`, `EffectBasePoints1` AS `EffectBasePoints_1`, `EffectBasePoints2` AS `EffectBasePoints_2`, `EffectBasePoints3` AS `EffectBasePoints_3`, `EffectMechanic1` AS `EffectMechanic_1`, `EffectMechanic2` AS `EffectMechanic_2`, `EffectMechanic3` AS `EffectMechanic_3`, `EffectImplicitTargetA1` AS `ImplicitTargetA_1`, `EffectImplicitTargetA2` AS `ImplicitTargetA_2`, `EffectImplicitTargetA3` AS `ImplicitTargetA_3`, `EffectImplicitTargetB1` AS `ImplicitTargetB_1`, `EffectImplicitTargetB2` AS `ImplicitTargetB_2`, `EffectImplicitTargetB3` AS `ImplicitTargetB_3`, `EffectRadiusIndex1` AS `EffectRadiusIndex_1`, `EffectRadiusIndex2` AS `EffectRadiusIndex_2`, `EffectRadiusIndex3` AS `EffectRadiusIndex_3`, `EffectApplyAuraName1` AS `EffectAura_1`, `EffectApplyAuraName2` AS `EffectAura_2`, `EffectApplyAuraName3` AS `EffectAura_3`, `EffectAmplitude1` AS `EffectAuraPeriod_1`, `EffectAmplitude2` AS `EffectAuraPeriod_2`, `EffectAmplitude3` AS `EffectAuraPeriod_3`, `EffectMultipleValue1` AS `EffectMultipleValue_1`, `EffectMultipleValue2` AS `EffectMultipleValue_2`, `EffectMultipleValue3` AS `EffectMultipleValue_3`, `EffectChainTarget1` AS `EffectChainTargets_1`, `EffectChainTarget2` AS `EffectChainTargets_2`, `EffectChainTarget3` AS `EffectChainTargets_3`, `EffectItemType1` AS `EffectItemType_1`, `EffectItemType2` AS `EffectItemType_2`, `EffectItemType3` AS `EffectItemType_3`, `EffectMiscValue1` AS `EffectMiscValue_1`, `EffectMiscValue2` AS `EffectMiscValue_2`, `EffectMiscValue3` AS `EffectMiscValue_3`, `EffectMiscValueB1` AS `EffectMiscValueB_1`, `EffectMiscValueB2` AS `EffectMiscValueB_2`, `EffectMiscValueB3` AS `EffectMiscValueB_3`, `EffectTriggerSpell1` AS `EffectTriggerSpell_1`, `EffectTriggerSpell2` AS `EffectTriggerSpell_2`, `EffectTriggerSpell3` AS `EffectTriggerSpell_3`, `EffectPointsPerComboPoint1` AS `EffectPointsPerCombo_1`, `EffectPointsPerComboPoint2` AS `EffectPointsPerCombo_2`, `EffectPointsPerComboPoint3` AS `EffectPointsPerCombo_3`, `EffectSpellClassMaskA1` AS `EffectSpellClassMaskA_1`, `EffectSpellClassMaskA2` AS `EffectSpellClassMaskA_2`, `EffectSpellClassMaskA3` AS `EffectSpellClassMaskA_3`, `EffectSpellClassMaskB1` AS `EffectSpellClassMaskB_1`, `EffectSpellClassMaskB2` AS `EffectSpellClassMaskB_2`, `EffectSpellClassMaskB3` AS `EffectSpellClassMaskB_3`, `EffectSpellClassMaskC1` AS `EffectSpellClassMaskC_1`, `EffectSpellClassMaskC2` AS `EffectSpellClassMaskC_2`, `EffectSpellClassMaskC3` AS `EffectSpellClassMaskC_3`, `SpellVisual1` AS `SpellVisualID_1`, `SpellVisual2` AS `SpellVisualID_2`, `SpellIconID`, `ActiveIconID`, `SpellPriority`, `SpellName0` AS `Name_Lang_enUS`, `SpellNameFlag0` AS `Name_Lang_Mask`, `SpellDescription0` AS `Description_Lang_enUS`, `SpellDescriptionFlags0` AS `Description_Lang_Mask`, `SpellToolTip0` AS `AuraDescription_Lang_enUS`, `SpellToolTipFlags0` AS `AuraDescription_Lang_Mask`, `ManaCostPercentage` AS `ManaCostPct`, `StartRecoveryCategory`, `StartRecoveryTime`, `MaximumTargetLevel` AS `MaxTargetLevel`, `MaximumAffectedTargets` AS `MaxTargets`, `PreventionType`, `StanceBarOrder`, `EffectDamageMultiplier1` AS `EffectChainAmplitude_1`, `EffectDamageMultiplier2` AS `EffectChainAmplitude_2`, `EffectDamageMultiplier3` AS `EffectChainAmplitude_3`, `MinimumFactionId` AS `MinFactionID`, `MinimumReputation` AS `MinReputation`, `RequiredAuraVision`, `TotemCategory1` AS `RequiredTotemCategoryID_1`, `TotemCategory2` AS `RequiredTotemCategoryID_2`, `AreaGroupID` AS `RequiredAreasID`, `SchoolMask`, `RuneCostID`, `SpellMissileID`, `PowerDisplayID`, `EffectBonusMultiplier1` AS `EffectBonusMultiplier_1`, `EffectBonusMultiplier2` AS `EffectBonusMultiplier_2`, `EffectBonusMultiplier3` AS `EffectBonusMultiplier_3`, `SpellDescriptionVariableID`, `SpellDifficultyID` FROM `spell` WHERE `ID` IN (5672, 6371, 6372, 8145, 8146, 8171, 8172, 10460, 10461, 25566, 52041, 52046, 52047, 52048, 52049, 52050, 58759, 58760, 58761, 58763, 58764, 58765);
*/

DELETE FROM `spell_dbc` WHERE `ID` IN (5672, 6371, 6372, 8145, 8146, 8171, 8172, 10460, 10461, 25566, 52041, 52046, 52047, 52048, 52049, 52050, 58759, 58760, 58761, 58763, 58764, 58765);
INSERT INTO `spell_dbc` (`ID`, `Category`, `DispelType`, `Mechanic`, `Attributes`, `AttributesEx`, `AttributesEx2`, `AttributesEx3`, `AttributesEx4`, `AttributesEx5`, `AttributesEx6`, `AttributesEx7`, `ShapeshiftMask`, `unk_320_2`, `ShapeshiftExclude`, `unk_320_3`, `Targets`, `TargetCreatureType`, `RequiresSpellFocus`, `FacingCasterFlags`, `CasterAuraState`, `TargetAuraState`, `ExcludeCasterAuraState`, `ExcludeTargetAuraState`, `CasterAuraSpell`, `TargetAuraSpell`, `ExcludeCasterAuraSpell`, `ExcludeTargetAuraSpell`, `CastingTimeIndex`, `RecoveryTime`, `CategoryRecoveryTime`, `InterruptFlags`, `AuraInterruptFlags`, `ChannelInterruptFlags`, `ProcTypeMask`, `ProcChance`, `ProcCharges`, `MaxLevel`, `BaseLevel`, `SpellLevel`, `DurationIndex`, `PowerType`, `ManaCost`, `ManaCostPerLevel`, `ManaPerSecond`, `ManaPerSecondPerLevel`, `RangeIndex`, `Speed`, `ModalNextSpell`, `CumulativeAura`, `Totem_1`, `Totem_2`, `Reagent_1`, `Reagent_2`, `Reagent_3`, `Reagent_4`, `Reagent_5`, `Reagent_6`, `Reagent_7`, `Reagent_8`, `ReagentCount_1`, `ReagentCount_2`, `ReagentCount_3`, `ReagentCount_4`, `ReagentCount_5`, `ReagentCount_6`, `ReagentCount_7`, `ReagentCount_8`, `EquippedItemClass`, `EquippedItemSubclass`, `EquippedItemInvTypes`, `Effect_1`, `Effect_2`, `Effect_3`, `EffectDieSides_1`, `EffectDieSides_2`, `EffectDieSides_3`, `EffectRealPointsPerLevel_1`, `EffectRealPointsPerLevel_2`, `EffectRealPointsPerLevel_3`, `EffectBasePoints_1`, `EffectBasePoints_2`, `EffectBasePoints_3`, `EffectMechanic_1`, `EffectMechanic_2`, `EffectMechanic_3`, `ImplicitTargetA_1`, `ImplicitTargetA_2`, `ImplicitTargetA_3`, `ImplicitTargetB_1`, `ImplicitTargetB_2`, `ImplicitTargetB_3`, `EffectRadiusIndex_1`, `EffectRadiusIndex_2`, `EffectRadiusIndex_3`, `EffectAura_1`, `EffectAura_2`, `EffectAura_3`, `EffectAuraPeriod_1`, `EffectAuraPeriod_2`, `EffectAuraPeriod_3`, `EffectMultipleValue_1`, `EffectMultipleValue_2`, `EffectMultipleValue_3`, `EffectChainTargets_1`, `EffectChainTargets_2`, `EffectChainTargets_3`, `EffectItemType_1`, `EffectItemType_2`, `EffectItemType_3`, `EffectMiscValue_1`, `EffectMiscValue_2`, `EffectMiscValue_3`, `EffectMiscValueB_1`, `EffectMiscValueB_2`, `EffectMiscValueB_3`, `EffectTriggerSpell_1`, `EffectTriggerSpell_2`, `EffectTriggerSpell_3`, `EffectPointsPerCombo_1`, `EffectPointsPerCombo_2`, `EffectPointsPerCombo_3`, `EffectSpellClassMaskA_1`, `EffectSpellClassMaskA_2`, `EffectSpellClassMaskA_3`, `EffectSpellClassMaskB_1`, `EffectSpellClassMaskB_2`, `EffectSpellClassMaskB_3`, `EffectSpellClassMaskC_1`, `EffectSpellClassMaskC_2`, `EffectSpellClassMaskC_3`, `SpellVisualID_1`, `SpellVisualID_2`, `SpellIconID`, `ActiveIconID`, `SpellPriority`, `Name_Lang_enUS`, `Name_Lang_Mask`, `Description_Lang_enUS`, `Description_Lang_Mask`, `AuraDescription_Lang_enUS`, `AuraDescription_Lang_Mask`, `ManaCostPct`, `StartRecoveryCategory`, `StartRecoveryTime`, `MaxTargetLevel`, `MaxTargets`, `PreventionType`, `StanceBarOrder`, `EffectChainAmplitude_1`, `EffectChainAmplitude_2`, `EffectChainAmplitude_3`, `MinFactionID`, `MinReputation`, `RequiredAuraVision`, `RequiredTotemCategoryID_1`, `RequiredTotemCategoryID_2`, `RequiredAreasID`, `SchoolMask`, `RuneCostID`, `SpellMissileID`, `PowerDisplayID`, `EffectBonusMultiplier_1`, `EffectBonusMultiplier_2`, `EffectBonusMultiplier_3`, `SpellDescriptionVariableID`, `SpellDifficultyID`) VALUES
(5672, 0, 0, 0, 64, 1024, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 20, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 6, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52041, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 366, 0, 1647, 0, 0, 'Healing Stream', 0, '', 0, 'Heals $s1 every $t1 seconds.', 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0),
(6371, 0, 0, 0, 64, 1024, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30, 30, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 6, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52046, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 366, 0, 1647, 0, 0, 'Healing Stream', 0, '', 0, 'Heals $s1 every $t1 seconds.', 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0),
(6372, 0, 0, 0, 64, 1024, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 40, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 6, 0, 0, 1, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52047, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 366, 0, 1647, 0, 0, 'Healing Stream', 0, '', 0, 'Heals $s1 every $t1 seconds.', 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0),
(8145, 0, 0, 0, 67904, 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 18, 18, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 6, 0, 0, 1, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 3000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8146, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1676, 0, 0, 'Tremor Totem Passive', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0),
(8146, 0, 0, 0, 2304, 1024, 0, 0, 0, 0, 512, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 18, 18, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 108, 108, 108, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 22, 22, 33, 33, 33, 10, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 5, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1676, 0, 0, 'Tremor Totem Effect', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 1, 1, 1, 0, 0),
(8171, 0, 0, 0, 65920, 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 38, 38, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1673, 0, 0, 'Cleansing Totem Pulse', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0),
(8172, 0, 0, 0, 67904, 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 38, 38, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 6, 0, 0, 1, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 3000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8171, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1673, 0, 0, 'Cleansing Totem Passive', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0),
(10460, 0, 0, 0, 64, 1024, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 50, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 6, 0, 0, 1, 0, 0, 0, 0, 0, 11, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52048, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 366, 0, 1647, 0, 0, 'Healing Stream', 0, '', 0, 'Heals $s1 every $t1 seconds.', 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0),
(10461, 0, 0, 0, 64, 1024, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 60, 60, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 6, 0, 0, 1, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52049, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 366, 0, 1647, 0, 0, 'Healing Stream', 0, '', 0, 'Heals $s1 every $t1 seconds.', 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0),
(25566, 0, 0, 0, 64, 1024, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 69, 69, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 6, 0, 0, 1, 0, 0, 0, 0, 0, 17, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52050, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 366, 0, 1647, 0, 0, 'Healing Stream', 0, 'Heals $s1 every $t1 seconds.', 0, 'Heals $s1 every $t1 seconds.', 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0),
(52041, 0, 0, 0, 134218112, 1024, 268435456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2213, 0, 0, 'Healing Stream Totem', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 1, 1, 0, 0),
(52046, 0, 0, 0, 134218112, 1024, 268435456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2213, 0, 0, 'Healing Stream Totem', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 1, 1, 0, 0),
(52047, 0, 0, 0, 134218112, 1024, 268435456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2213, 0, 0, 'Healing Stream Totem', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 1, 1, 0, 0),
(52048, 0, 0, 0, 134218112, 1024, 268435456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0, 11, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2213, 0, 0, 'Healing Stream Totem', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 1, 1, 0, 0),
(52049, 0, 0, 0, 134218112, 1024, 268435456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2213, 0, 0, 'Healing Stream Totem', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 1, 1, 0, 0),
(52050, 0, 0, 0, 134218112, 1024, 268435456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0, 17, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2213, 0, 0, 'Healing Stream Totem', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 1, 1, 0, 0),
(58759, 0, 0, 0, 134218112, 1024, 268435456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0, 19, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2213, 0, 0, 'Healing Stream Totem', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 1, 1, 0, 0),
(58760, 0, 0, 0, 134218112, 1024, 268435456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2213, 0, 0, 'Healing Stream Totem', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 1, 1, 0, 0),
(58761, 0, 0, 0, 134218112, 1024, 268435456, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 101, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2213, 0, 0, 'Healing Stream Totem', 0, '', 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 1, 1, 0, 0),
(58763, 0, 0, 0, 64, 1024, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 71, 71, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 6, 0, 0, 1, 0, 0, 0, 0, 0, 19, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 58759, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 366, 0, 1647, 0, 0, 'Healing Stream', 0, 'Heals $s1 every $t1 seconds.', 0, 'Heals $s1 every $t1 seconds.', 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0),
(58764, 0, 0, 0, 64, 1024, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 76, 76, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 6, 0, 0, 1, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 58760, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 366, 0, 1647, 0, 0, 'Healing Stream', 0, 'Heals $s1 every $t1 seconds.', 0, 'Heals $s1 every $t1 seconds.', 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0),
(58765, 0, 0, 0, 64, 1024, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 80, 80, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 6, 0, 0, 1, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 58761, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 366, 0, 1647, 0, 0, 'Healing Stream', 0, 'Heals $s1 every $t1 seconds.', 0, 'Heals $s1 every $t1 seconds.', 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0);