local ENABLE_CLASS_SPELLS        = false -- Learn class-specific spells when leveling up or when entering the world
local ENABLE_SPELLS_FROM_QUESTS  = false -- Learn class-specific spells normally obtained from quests when leveling up or when entering the world
local ENABLE_TALENT_RANKS        = false -- Learn talent ranks when leveling up or when entering the world
local ENABLE_PROFICIENCIES       = false -- Learn weapon and defense skills when leveling up or when entering the world
local ENABLE_RIDING              = false -- Learn riding skills and mount spells when leveling up or when entering the world
local ENABLE_APPRENTICE_RIDING   = false -- Learn apprentice riding (75% ground mount) when leveling up or when entering the world
local ENABLE_JOURNEYMAN_RIDING   = false -- Learn journeyman riding (100% ground mount) when leveling up or when entering the world
local ENABLE_EXPERT_RIDING       = false -- Learn expert riding (225% flying mount) when leveling up or when entering the world
local ENABLE_ARTISAN_RIDING      = false -- Learn artisan riding (300% flying mount) when leveling up or when entering the world
local ENABLE_COLD_WEATHER_FLYING = false -- Learn cold weather flying when leveling up or when entering the world

-- Event ids
local EVENT_ON_LOGIN             = 3
local EVENT_ON_LEVEL_CHANGED     = 13

-- Team ids
local TEAM_UNDEFINED             = -1
local TEAM_ALLIANCE              = 0
local TEAM_HORDE                 = 1

-- Class ids
local CLASS_UNDEFINED            = -1
local CLASS_WARRIOR              = 1
local CLASS_PALADIN              = 2
local CLASS_HUNTER               = 3
local CLASS_ROGUE                = 4
local CLASS_PRIEST               = 5
local CLASS_DEATH_KNIGHT         = 6
local CLASS_SHAMAN               = 7
local CLASS_MAGE                 = 8
local CLASS_WARLOCK              = 9
local CLASS_DRUID                = 11

-- Race ids
local RACE_UNDEFINED             = -1
local RACE_HUMAN                 = 1
local RACE_ORC                   = 2
local RACE_DWARF                 = 3
local RACE_NIGHT_ELF             = 4
local RACE_UNDEAD                = 5
local RACE_TAUREN                = 6
local RACE_GNOME                 = 7
local RACE_TROLL                 = 8
local RACE_BLOOD_ELF             = 10
local RACE_DRAENEI               = 11

-- Spell types
local TYPE_CLASS_SPELL           = 0
local TYPE_TALENT_RANK           = 1
local TYPE_PROFICIENCY           = 2

-- The list of all class-specific spells
-- The order is type, race id, spell id, required level, required spell id, obtained from quest
local LIST_CLASS_SPELLS          = {
    -- Warrior (Id: 1)
    {{ TYPE_PROFICIENCY, RACE_UNDEFINED, 196,   0,  -1,    0 }, -- One-Handed Axes
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 197,   0,  -1,    0 }, -- Two-Handed Axes
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 198,   0,  -1,    0 }, -- One-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 199,   0,  -1,    0 }, -- Two-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 200,   0,  -1,    0 }, -- Polearms
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 201,   0,  -1,    0 }, -- One-Handed Swords
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 202,   0,  -1,    0 }, -- Two-Handed Swords
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 227,   0,  -1,    0 }, -- Staves
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 264,   0,  -1,    0 }, -- Bows
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 266,   0,  -1,    0 }, -- Guns
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 1180,  0,  -1,    0 }, -- Daggers
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 5011,  0,  -1,    0 }, -- Crossbows
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 15590, 0,  -1,    0 }, -- Fist Weapons
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 78,    1,  -1,    0 }, -- Heroic Strike (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2457,  1,  -1,    0 }, -- Battle Stance
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6673,  1,  -1,    0 }, -- Battle Shout (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 100,   4,  -1,    0 }, -- Charge (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 772,   4,  -1,    0 }, -- Rend (Rank 1)
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 3127,  6,  -1,    0 }, -- Parry (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6343,  6,  -1,    0 }, -- Thunder Clap (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 34428, 6,  -1,    0 }, -- Victory Rush
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 284,   8,  78,    0 }, -- Heroic Strike (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1715,  8,  -1,    0 }, -- Hamstring
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 71,    10, -1,    1 }, -- Defensive Stance
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 355,   10, 71,    1 }, -- Taunt
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2687,  10, -1,    0 }, -- Bloodrage
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6546,  10, 772,   0 }, -- Rend (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7386,  10, 71,    1 }, -- Sunder Armor
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 72,    12, -1,    0 }, -- Shield Bash
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5242,  12, 6673,  0 }, -- Battle Shout (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7384,  12, -1,    0 }, -- Overpower
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1160,  14, -1,    0 }, -- Demoralizing Shout (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6572,  14, -1,    0 }, -- Revenge (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 285,   16, 284,   0 }, -- Heroic Strike (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 694,   16, -1,    0 }, -- Mocking Blow
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2565,  16, -1,    0 }, -- Shield Block
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 676,   18, -1,    0 }, -- Disarm
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8198,  18, 6343,  0 }, -- Thunder Clap (Rank 2)
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 674,   20, -1,    0 }, -- Dual Wield (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 845,   20, -1,    0 }, -- Cleave (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6547,  20, 6546,  0 }, -- Rend (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 12678, 20, -1,    0 }, -- Stance Mastery (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20230, 20, -1,    0 }, -- Retaliation
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5246,  22, -1,    0 }, -- Intimidating Shout
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6192,  22, 5242,  0 }, -- Battle Shout (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1608,  24, 285,   0 }, -- Heroic Strike (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5308,  24, -1,    0 }, -- Execute (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6190,  24, 1160,  0 }, -- Demoralizing Shout (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6574,  24, 6572,  0 }, -- Revenge (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1161,  26, -1,    0 }, -- Challenging Shout
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6178,  26, 100,   0 }, -- Charge (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 871,   28, -1,    0 }, -- Shield Wall
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8204,  28, 8198,  0 }, -- Thunder Clap (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1464,  30, -1,    0 }, -- Slam (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2458,  30, -1,    1 }, -- Berserker Stance
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6548,  30, 6547,  0 }, -- Rend (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7369,  30, 845,   0 }, -- Cleave (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20252, 30, 2458,  1 }, -- Intercept
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11549, 32, 6192,  0 }, -- Battle Shout (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11564, 32, 1608,  0 }, -- Heroic Strike (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 18499, 32, -1,    0 }, -- Berserker Rage
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20658, 32, 5308,  0 }, -- Execute (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7379,  34, 6574,  0 }, -- Revenge (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11554, 34, 6190,  0 }, -- Demoralizing Shout (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1680,  36, -1,    0 }, -- Whirlwind
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6552,  38, -1,    0 }, -- Pummel
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8205,  38, 8204,  0 }, -- Thunder Clap (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8820,  38, 1464,  0 }, -- Slam (Rank 2)
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 750,   40, -1,    0 }, -- Plate Mail
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11565, 40, 11564, 0 }, -- Heroic Strike (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11572, 40, 6548,  0 }, -- Rend (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11608, 40, 7369,  0 }, -- Cleave (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20660, 40, 20658, 0 }, -- Execute (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 23922, 40, -1,    0 }, -- Shield Slam (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11550, 42, 11549, 0 }, -- Battle Shout (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11555, 44, 11554, 0 }, -- Demoralizing Shout (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11600, 44, 7379,  0 }, -- Revenge (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11578, 46, 6178,  0 }, -- Charge (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11604, 46, 8820,  0 }, -- Slam (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11566, 48, 11565, 0 }, -- Heroic Strike (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11580, 48, 8205,  0 }, -- Thunder Clap (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20661, 48, 20660, 0 }, -- Execute (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 21551, 48, 12294, 0 }, -- Mortal Strike (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 23923, 48, 23922, 0 }, -- Shield Slam (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1719,  50, -1,    0 }, -- Recklessness
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11573, 50, 11572, 0 }, -- Rend (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11609, 50, 11608, 0 }, -- Cleave (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11551, 52, 11550, 0 }, -- Battle Shout (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11556, 54, 11555, 0 }, -- Demoralizing Shout (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11601, 54, 11600, 0 }, -- Revenge (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11605, 54, 11604, 0 }, -- Slam (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 21552, 54, 21551, 0 }, -- Mortal Strike (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 23924, 54, 23923, 0 }, -- Shield Slam (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11567, 56, 11566, 0 }, -- Heroic Strike (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20662, 56, 20661, 0 }, -- Execute (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11581, 58, 11580, 0 }, -- Thunder Clap (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11574, 60, 11573, 0 }, -- Rend (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20569, 60, 11609, 0 }, -- Cleave (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 21553, 60, 21552, 0 }, -- Mortal Strike (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 23925, 60, 23924, 0 }, -- Shield Slam (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25286, 60, 11567, 0 }, -- Heroic Strike (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25288, 60, 11601, 0 }, -- Revenge (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25289, 60, 11551, 0 }, -- Battle Shout (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 30016, 60, 20243, 0 }, -- Devastate (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25241, 61, 11605, 0 }, -- Slam (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25202, 62, 11556, 0 }, -- Demoralizing Shout (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25269, 63, 25288, 0 }, -- Revenge (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 23920, 64, -1,    0 }, -- Spell Reflection
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25234, 65, 20662, 0 }, -- Execute (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 25248, 66, 21553, 0 }, -- Mortal Strike (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25258, 66, 23925, 0 }, -- Shield Slam (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 29707, 66, 25286, 0 }, -- Heroic Strike (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25264, 67, 11581, 0 }, -- Thunder Clap (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 469,   68, -1,    0 }, -- Commanding Shout (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25208, 68, 11574, 0 }, -- Rend (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25231, 68, 20569, 0 }, -- Cleave (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2048,  69, 25289, 0 }, -- Battle Shout (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25242, 69, 25241, 0 }, -- Slam (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3411,  70, -1,    0 }, -- Intervene
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25203, 70, 25202, 0 }, -- Demoralizing Shout (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25236, 70, 25234, 0 }, -- Execute (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 30022, 70, 30016, 0 }, -- Devastate (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 30324, 70, 29707, 0 }, -- Heroic Strike (Rank 11)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 30330, 70, 25248, 0 }, -- Mortal Strike (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 30356, 70, 25258, 0 }, -- Shield Slam (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 30357, 70, 25269, 0 }, -- Revenge (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 46845, 71, 25208, 0 }, -- Rend (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 64382, 71, -1,    0 }, -- Shattering Throw
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47449, 72, 30324, 0 }, -- Heroic Strike (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47519, 72, 25231, 0 }, -- Cleave (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47470, 73, 25236, 0 }, -- Execute (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47501, 73, 25264, 0 }, -- Thunder Clap (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47439, 74, 469,   0 }, -- Commanding Shout (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47474, 74, 25242, 0 }, -- Slam (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 47485, 75, 30330, 0 }, -- Mortal Strike (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47487, 75, 30356, 0 }, -- Shield Slam (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 47497, 75, 30022, 0 }, -- Devastate (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 55694, 75, -1,    0 }, -- Enraged Regeneration
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47450, 76, 47449, 0 }, -- Heroic Strike (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47465, 76, 46845, 0 }, -- Rend (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47520, 77, 47519, 0 }, -- Cleave (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47436, 78, 2048,  0 }, -- Battle Shout (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47502, 78, 47501, 0 }, -- Thunder Clap (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47437, 79, 25203, 0 }, -- Demoralizing Shout (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47475, 79, 47474, 0 }, -- Slam (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47440, 80, 47439, 0 }, -- Commanding Shout (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47471, 80, 47470, 0 }, -- Execute (Rank 9)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 47486, 80, 47485, 0 }, -- Mortal Strike (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47488, 80, 47487, 0 }, -- Shield Slam (Rank 8)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 47498, 80, 47497, 0 }, -- Devastate (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 57755, 80, -1,    0 }, -- Heroic Throw
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 57823, 80, 30357, 0 }}, -- Revenge (Rank 9)
    -- Paladin (Id: 2)
    {{ TYPE_PROFICIENCY, RACE_UNDEFINED, 196,   0,  -1,    0 }, -- One-Handed Axes
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 197,   0,  -1,    0 }, -- Two-Handed Axes
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 198,   0,  -1,    0 }, -- One-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 199,   0,  -1,    0 }, -- Two-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 200,   0,  -1,    0 }, -- Polearms
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 201,   0,  -1,    0 }, -- One-Handed Swords
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 202,   0,  -1,    0 }, -- Two-Handed Swords
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 465,   1,  -1,    0 }, -- Devotion Aura (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 635,   1,  -1,    0 }, -- Holy Light (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 21084, 1,  -1,    0 }, -- Seal of Righteousness
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19740, 4,  -1,    0 }, -- Blessing of Might (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20271, 4,  -1,    0 }, -- Judgement of Light
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 498,   6,  -1,    0 }, -- Divine Protection
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 639,   6,  635,   0 }, -- Holy Light (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 853,   8,  -1,    0 }, -- Hammer of Justice (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1152,  8,  -1,    0 }, -- Purify
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 3127,  8,  -1,    0 }, -- Parry (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 633,   10, -1,    0 }, -- Lay on Hands (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1022,  10, -1,    0 }, -- Hand of Protection (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10290, 10, 465,   0 }, -- Devotion Aura (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7328,  12, -1,    0 }, -- Redemption (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19834, 12, 19740, 0 }, -- Blessing of Might (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53408, 12, -1,    0 }, -- Judgement of Wisdom
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 647,   14, 639,   0 }, -- Holy Light (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19742, 14, -1,    0 }, -- Blessing of Wisdom (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 31789, 14, -1,    0 }, -- Righteous Defense
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7294,  16, -1,    0 }, -- Retribution Aura (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25780, 16, -1,    0 }, -- Righteous Fury
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 62124, 16, -1,    0 }, -- Hand of Reckoning
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1044,  18, -1,    0 }, -- Hand of Freedom
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 643,   20, 10290, 0 }, -- Devotion Aura (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 879,   20, -1,    0 }, -- Exorcism (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5502,  20, -1,    0 }, -- Sense Undead
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19750, 20, -1,    0 }, -- Flash of Light (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20217, 20, -1,    0 }, -- Blessing of Kings
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26573, 20, -1,    0 }, -- Consecration (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1026,  22, 647,   0 }, -- Holy Light (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19746, 22, -1,    0 }, -- Concentration Aura
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19835, 22, 19834, 0 }, -- Blessing of Might (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20164, 22, -1,    0 }, -- Seal of Justice
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5588,  24, 853,   0 }, -- Hammer of Justice (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5599,  24, 1022,  0 }, -- Hand of Protection (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10322, 24, 7328,  0 }, -- Redemption (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10326, 24, -1,    0 }, -- Turn Evil
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19850, 24, 19742, 0 }, -- Blessing of Wisdom (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1038,  26, -1,    0 }, -- Hand of Salvation
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10298, 26, 7294,  0 }, -- Retribution Aura (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19939, 26, 19750, 0 }, -- Flash of Light (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5614,  28, 879,   0 }, -- Exorcism (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19876, 28, -1,    0 }, -- Shadow Resistance Aura (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53407, 28, -1,    0 }, -- Judgement of Justice
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1042,  30, 1026,  0 }, -- Holy Light (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2800,  30, 633,   0 }, -- Lay on Hands (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10291, 30, 643,   0 }, -- Devotion Aura (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19752, 30, -1,    0 }, -- Divine Intervention
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20116, 30, 26573, 0 }, -- Consecration (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20165, 30, -1,    0 }, -- Seal of Light
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19836, 32, 19835, 0 }, -- Blessing of Might (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19888, 32, -1,    0 }, -- Frost Resistance Aura (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 642,   34, -1,    0 }, -- Divine Shield
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19852, 34, 19850, 0 }, -- Blessing of Wisdom (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19940, 34, 19939, 0 }, -- Flash of Light (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5615,  36, 5614,  0 }, -- Exorcism (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10299, 36, 10298, 0 }, -- Retribution Aura (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10324, 36, 10322, 0 }, -- Redemption (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19891, 36, -1,    0 }, -- Fire Resistance Aura (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3472,  38, 1042,  0 }, -- Holy Light (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10278, 38, 5599,  0 }, -- Hand of Protection (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20166, 38, -1,    0 }, -- Seal of Wisdom
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 750,   40, -1,    0 }, -- Plate Mail
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1032,  40, 10291, 0 }, -- Devotion Aura (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5589,  40, 5588,  0 }, -- Hammer of Justice (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19895, 40, 19876, 0 }, -- Shadow Resistance Aura (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20922, 40, 20116, 0 }, -- Consecration (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 4987,  42, -1,    0 }, -- Cleanse
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19837, 42, 19836, 0 }, -- Blessing of Might (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19941, 42, 19940, 0 }, -- Flash of Light (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10312, 44, 5615,  0 }, -- Exorcism (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19853, 44, 19852, 0 }, -- Blessing of Wisdom (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19897, 44, 19888, 0 }, -- Frost Resistance Aura (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 24275, 44, -1,    0 }, -- Hammer of Wrath (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6940,  46, -1,    0 }, -- Hand of Sacrifice
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10300, 46, 10299, 0 }, -- Retribution Aura (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10328, 46, 3472,  0 }, -- Holy Light (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19899, 48, 19891, 0 }, -- Fire Resistance Aura (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20772, 48, 10324, 0 }, -- Redemption (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 20929, 48, 20473, 0 }, -- Holy Shock (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2812,  50, -1,    0 }, -- Holy Wrath (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10292, 50, 1032,  0 }, -- Devotion Aura (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10310, 50, 2800,  0 }, -- Lay on Hands (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19942, 50, 19941, 0 }, -- Flash of Light (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20923, 50, 20922, 0 }, -- Consecration (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 20927, 50, 20925, 0 }, -- Holy Shield (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10313, 52, 10312, 0 }, -- Exorcism (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19838, 52, 19837, 0 }, -- Blessing of Might (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19896, 52, 19895, 0 }, -- Shadow Resistance Aura (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 24274, 52, 24275, 0 }, -- Hammer of Wrath (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25782, 52, -1,    0 }, -- Greater Blessing of Might (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10308, 54, 5589,  0 }, -- Hammer of Justice (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10329, 54, 10328, 0 }, -- Holy Light (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19854, 54, 19853, 0 }, -- Blessing of Wisdom (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25894, 54, -1,    0 }, -- Greater Blessing of Wisdom (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10301, 56, 10300, 0 }, -- Retribution Aura (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19898, 56, 19897, 0 }, -- Frost Resistance Aura (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 20930, 56, 20929, 0 }, -- Holy Shock (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19943, 58, 19942, 0 }, -- Flash of Light (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10293, 60, 10292, 0 }, -- Devotion Aura (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10314, 60, 10313, 0 }, -- Exorcism (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10318, 60, 2812,  0 }, -- Holy Wrath (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19900, 60, 19899, 0 }, -- Fire Resistance Aura (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20773, 60, 20772, 0 }, -- Redemption (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20924, 60, 20923, 0 }, -- Consecration (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 20928, 60, 20927, 0 }, -- Holy Shield (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 24239, 60, 24274, 0 }, -- Hammer of Wrath (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25290, 60, 19854, 0 }, -- Blessing of Wisdom (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25291, 60, 19838, 0 }, -- Blessing of Might (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25292, 60, 10329, 0 }, -- Holy Light (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25898, 60, -1,    0 }, -- Greater Blessing of Kings
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 25899, 60, 20911, 0 }, -- Greater Blessing of Sanctuary
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25916, 60, 25782, 0 }, -- Greater Blessing of Might (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25918, 60, 25894, 0 }, -- Greater Blessing of Wisdom (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 32699, 60, 31935, 0 }, -- Avenger's Shield (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27135, 62, 25292, 0 }, -- Holy Light (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 32223, 62, -1,    0 }, -- Crusader Aura
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27151, 63, 19896, 0 }, -- Shadow Resistance Aura (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27174, 64, 20930, 0 }, -- Holy Shock (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_DRAENEI,   31801, 64, -1,    0 }, -- Seal of Vengeance
    { TYPE_CLASS_SPELL,  RACE_DWARF,     31801, 64, -1,    0 }, -- Seal of Vengeance
    { TYPE_CLASS_SPELL,  RACE_HUMAN,     31801, 64, -1,    0 }, -- Seal of Vengeance
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27142, 65, 25290, 0 }, -- Blessing of Wisdom (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27143, 65, 25918, 0 }, -- Greater Blessing of Wisdom (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27137, 66, 19943, 0 }, -- Flash of Light (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27150, 66, 10301, 0 }, -- Retribution Aura (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_BLOOD_ELF, 53736, 66, -1,    0 }, -- Seal of Corruption
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27138, 68, 10314, 0 }, -- Exorcism (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27152, 68, 19898, 0 }, -- Frost Resistance Aura (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27180, 68, 24239, 0 }, -- Hammer of Wrath (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27139, 69, 10318, 0 }, -- Holy Wrath (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27154, 69, 10310, 0 }, -- Lay on Hands (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27136, 70, 27135, 0 }, -- Holy Light (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27140, 70, 25291, 0 }, -- Blessing of Might (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27141, 70, 25916, 0 }, -- Greater Blessing of Might (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27149, 70, 10293, 0 }, -- Devotion Aura (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27153, 70, 19900, 0 }, -- Fire Resistance Aura (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27173, 70, 20924, 0 }, -- Consecration (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27179, 70, 20928, 0 }, -- Holy Shield (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 31884, 70, -1,    0 }, -- Avenging Wrath
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 32700, 70, 32699, 0 }, -- Avenger's Shield (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 33072, 70, 27174, 0 }, -- Holy Shock (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48935, 71, 27142, 0 }, -- Blessing of Wisdom (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48937, 71, 27143, 0 }, -- Greater Blessing of Wisdom (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 54428, 71, -1,    0 }, -- Divine Plea
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48816, 72, 27139, 0 }, -- Holy Wrath (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48949, 72, 20773, 0 }, -- Redemption (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48800, 73, 27138, 0 }, -- Exorcism (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48931, 73, 27140, 0 }, -- Blessing of Might (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48933, 73, 27141, 0 }, -- Greater Blessing of Might (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48784, 74, 27137, 0 }, -- Flash of Light (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48805, 74, 27180, 0 }, -- Hammer of Wrath (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48941, 74, 27149, 0 }, -- Devotion Aura (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48781, 75, 27136, 0 }, -- Holy Light (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48818, 75, 27173, 0 }, -- Consecration (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48824, 75, 33072, 0 }, -- Holy Shock (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48826, 75, 32700, 0 }, -- Avenger's Shield (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48951, 75, 27179, 0 }, -- Holy Shield (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53600, 75, -1,    0 }, -- Shield of Righteousness (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48943, 76, 27151, 0 }, -- Shadow Resistance Aura (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 54043, 76, 27150, 0 }, -- Retribution Aura (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48936, 77, 48935, 0 }, -- Blessing of Wisdom (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48938, 77, 48937, 0 }, -- Greater Blessing of Wisdom (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48945, 77, 27152, 0 }, -- Frost Resistance Aura (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48788, 78, 27154, 0 }, -- Lay on Hands (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48817, 78, 48816, 0 }, -- Holy Wrath (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48947, 78, 27153, 0 }, -- Fire Resistance Aura (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48785, 79, 48784, 0 }, -- Flash of Light (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48801, 79, 48800, 0 }, -- Exorcism (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48932, 79, 48931, 0 }, -- Blessing of Might (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48934, 79, 48933, 0 }, -- Greater Blessing of Might (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48942, 79, 48941, 0 }, -- Devotion Aura (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48950, 79, 48949, 0 }, -- Redemption (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48782, 80, 48781, 0 }, -- Holy Light (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48806, 80, 48805, 0 }, -- Hammer of Wrath (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48819, 80, 48818, 0 }, -- Consecration (Rank 8)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48825, 80, 48824, 0 }, -- Holy Shock (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48827, 80, 48826, 0 }, -- Avenger's Shield (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48952, 80, 48951, 0 }, -- Holy Shield (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53601, 80, -1,    0 }, -- Sacred Shield (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 61411, 80, 53600, 0 }}, -- Shield of Righteousness (Rank 2)
    -- Hunter (Id: 3)
    {{ TYPE_PROFICIENCY, RACE_UNDEFINED, 196,   0,  -1,    0 }, -- One-Handed Axes
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 197,   0,  -1,    0 }, -- Two-Handed Axes
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 200,   0,  -1,    0 }, -- Polearms
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 201,   0,  -1,    0 }, -- One-Handed Swords
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 202,   0,  -1,    0 }, -- Two-Handed Swords
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 227,   0,  -1,    0 }, -- Staves
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 264,   0,  -1,    0 }, -- Bows
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 266,   0,  -1,    0 }, -- Guns
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 1180,  0,  -1,    0 }, -- Daggers
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 5011,  0,  -1,    0 }, -- Crossbows
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 15590, 0,  -1,    0 }, -- Fist Weapons
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1494,  1,  -1,    0 }, -- Track Beasts
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2973,  1,  -1,    0 }, -- Raptor Strike (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1978,  4,  -1,    0 }, -- Serpent Sting (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13163, 4,  -1,    0 }, -- Aspect of the Monkey
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1130,  6,  -1,    0 }, -- Hunter's Mark (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3044,  6,  -1,    0 }, -- Arcane Shot (Rank 1)
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 3127,  8,  -1,    0 }, -- Parry (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5116,  8,  -1,    0 }, -- Concussive Shot
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14260, 8,  2973,  0 }, -- Raptor Strike (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 883,   10, -1,    1 }, -- Call Pet
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 982,   10, 883,   1 }, -- Revive Pet
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1515,  10, 883,   1 }, -- Tame Beast
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2641,  10, 883,   1 }, -- Dismiss Pet
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6991,  10, 883,   1 }, -- Feed Pet
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13165, 10, -1,    0 }, -- Aspect of the Hawk (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13549, 10, 1978,  0 }, -- Serpent Sting (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19883, 10, -1,    0 }, -- Track Humanoids
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 136,   12, -1,    0 }, -- Mend Pet (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2974,  12, -1,    0 }, -- Wing Clip
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14281, 12, 3044,  0 }, -- Arcane Shot (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20736, 12, -1,    0 }, -- Distracting Shot (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1002,  14, -1,    0 }, -- Eyes of the Beast
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1513,  14, -1,    0 }, -- Scare Beast (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6197,  14, -1,    0 }, -- Eagle Eye
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1495,  16, -1,    0 }, -- Mongoose Bite (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5118,  16, -1,    0 }, -- Aspect of the Cheetah
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13795, 16, -1,    0 }, -- Immolation Trap (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14261, 16, 14260, 0 }, -- Raptor Strike (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2643,  18, -1,    0 }, -- Multi-Shot (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13550, 18, 13549, 0 }, -- Serpent Sting (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14318, 18, 13165, 0 }, -- Aspect of the Hawk (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19884, 18, -1,    0 }, -- Track Undead
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 674,   20, -1,    0 }, -- Dual Wield (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 781,   20, -1,    0 }, -- Disengage
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1499,  20, -1,    0 }, -- Freezing Trap (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3111,  20, 136,   0 }, -- Mend Pet (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14282, 20, 14281, 0 }, -- Arcane Shot (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 34074, 20, -1,    0 }, -- Aspect of the Viper
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3043,  22, -1,    0 }, -- Scorpid Sting
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14323, 22, 1130,  0 }, -- Hunter's Mark (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1462,  24, -1,    0 }, -- Beast Lore
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14262, 24, 14261, 0 }, -- Raptor Strike (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19885, 24, -1,    0 }, -- Track Hidden
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3045,  26, -1,    0 }, -- Rapid Fire
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13551, 26, 13550, 0 }, -- Serpent Sting (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14302, 26, 13795, 0 }, -- Immolation Trap (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19880, 26, -1,    0 }, -- Track Elementals
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3661,  28, 3111,  0 }, -- Mend Pet (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13809, 28, -1,    0 }, -- Frost Trap
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14283, 28, 14282, 0 }, -- Arcane Shot (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14319, 28, 14318, 0 }, -- Aspect of the Hawk (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 20900, 28, 19434, 0 }, -- Aimed Shot (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5384,  30, -1,    0 }, -- Feign Death
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13161, 30, -1,    0 }, -- Aspect of the Beast
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14269, 30, 1495,  0 }, -- Mongoose Bite (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14288, 30, 2643,  0 }, -- Multi-Shot (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14326, 30, 1513,  0 }, -- Scare Beast (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1543,  32, -1,    0 }, -- Flare
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14263, 32, 14262, 0 }, -- Raptor Strike (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19878, 32, -1,    0 }, -- Track Demons
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13552, 34, 13551, 0 }, -- Serpent Sting (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13813, 34, -1,    0 }, -- Explosive Trap (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3034,  36, -1,    0 }, -- Viper Sting
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3662,  36, 3661,  0 }, -- Mend Pet (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14284, 36, 14283, 0 }, -- Arcane Shot (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14303, 36, 14302, 0 }, -- Immolation Trap (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 20901, 36, 20900, 0 }, -- Aimed Shot (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14320, 38, 14319, 0 }, -- Aspect of the Hawk (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1510,  40, -1,    0 }, -- Volley (Rank 1)
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 8737,  40, -1,    0 }, -- Mail
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13159, 40, -1,    0 }, -- Aspect of the Pack
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14264, 40, 14263, 0 }, -- Raptor Strike (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14310, 40, 1499,  0 }, -- Freezing Trap (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14324, 40, 14323, 0 }, -- Hunter's Mark (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19882, 40, -1,    0 }, -- Track Giants
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13553, 42, 13552, 0 }, -- Serpent Sting (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14289, 42, 14288, 0 }, -- Multi-Shot (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 20909, 42, 19306, 0 }, -- Counterattack (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13542, 44, 3662,  0 }, -- Mend Pet (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14270, 44, 14269, 0 }, -- Mongoose Bite (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14285, 44, 14284, 0 }, -- Arcane Shot (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14316, 44, 13813, 0 }, -- Explosive Trap (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 20902, 44, 20901, 0 }, -- Aimed Shot (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14304, 46, 14303, 0 }, -- Immolation Trap (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14327, 46, 14326, 0 }, -- Scare Beast (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20043, 46, -1,    0 }, -- Aspect of the Wild (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14265, 48, 14264, 0 }, -- Raptor Strike (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14321, 48, 14320, 0 }, -- Aspect of the Hawk (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13554, 50, 13553, 0 }, -- Serpent Sting (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14294, 50, 1510,  0 }, -- Volley (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19879, 50, -1,    0 }, -- Track Dragonkin
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 24132, 50, 19386, 0 }, -- Wyvern Sting (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 56641, 50, -1,    0 }, -- Steady Shot (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13543, 52, 13542, 0 }, -- Mend Pet (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14286, 52, 14285, 0 }, -- Arcane Shot (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 20903, 52, 20902, 0 }, -- Aimed Shot (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14290, 54, 14289, 0 }, -- Multi-Shot (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14317, 54, 14316, 0 }, -- Explosive Trap (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 20910, 54, 20909, 0 }, -- Counterattack (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14266, 56, 14265, 0 }, -- Raptor Strike (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14305, 56, 14304, 0 }, -- Immolation Trap (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20190, 56, 20043, 0 }, -- Aspect of the Wild (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 63668, 57, 3674,  0 }, -- Black Arrow (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13555, 58, 13554, 0 }, -- Serpent Sting (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14271, 58, 14270, 0 }, -- Mongoose Bite (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14295, 58, 14294, 0 }, -- Volley (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14322, 58, 14321, 0 }, -- Aspect of the Hawk (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14325, 58, 14324, 0 }, -- Hunter's Mark (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 13544, 60, 13543, 0 }, -- Mend Pet (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14287, 60, 14286, 0 }, -- Arcane Shot (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14311, 60, 14310, 0 }, -- Freezing Trap (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19263, 60, -1,    0 }, -- Deterrence
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19801, 60, -1,    0 }, -- Tranquilizing Shot
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 20904, 60, 20903, 0 }, -- Aimed Shot (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 24133, 60, 24132, 0 }, -- Wyvern Sting (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25294, 60, 14290, 0 }, -- Multi-Shot (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25295, 60, 13555, 0 }, -- Serpent Sting (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25296, 60, 14322, 0 }, -- Aspect of the Hawk (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27025, 61, 14317, 0 }, -- Explosive Trap (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 34120, 62, 56641, 0 }, -- Steady Shot (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27014, 63, 14266, 0 }, -- Raptor Strike (Rank 9)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 63669, 63, 63668, 0 }, -- Black Arrow (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27023, 65, 14305, 0 }, -- Immolation Trap (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27067, 66, 20910, 0 }, -- Counterattack (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 34026, 66, -1,    0 }, -- Kill Command
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27016, 67, 25295, 0 }, -- Serpent Sting (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27021, 67, 25294, 0 }, -- Multi-Shot (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27022, 67, 14295, 0 }, -- Volley (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27044, 68, 25296, 0 }, -- Aspect of the Hawk (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27045, 68, 20190, 0 }, -- Aspect of the Wild (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27046, 68, 13544, 0 }, -- Mend Pet (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 34600, 68, -1,    0 }, -- Snake Trap
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27019, 69, 14287, 0 }, -- Arcane Shot (Rank 9)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 63670, 69, 63669, 0 }, -- Black Arrow (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27065, 70, 20904, 0 }, -- Aimed Shot (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27068, 70, 24133, 0 }, -- Wyvern Sting (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 34477, 70, -1,    0 }, -- Misdirection
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 36916, 70, 14271, 0 }, -- Mongoose Bite (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 60051, 70, 53301, 0 }, -- Explosive Shot (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48995, 71, 27014, 0 }, -- Raptor Strike (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49051, 71, 34120, 0 }, -- Steady Shot (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49066, 71, 27025, 0 }, -- Explosive Trap (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53351, 71, -1,    0 }, -- Kill Shot (Rank 1)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48998, 72, 27067, 0 }, -- Counterattack (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49055, 72, 27023, 0 }, -- Immolation Trap (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49000, 73, 27016, 0 }, -- Serpent Sting (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49044, 73, 27019, 0 }, -- Arcane Shot (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48989, 74, 27046, 0 }, -- Mend Pet (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49047, 74, 27021, 0 }, -- Multi-Shot (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58431, 74, 27022, 0 }, -- Volley (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 61846, 74, -1,    0 }, -- Aspect of the Dragonhawk (Rank 1)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 49011, 75, 27068, 0 }, -- Wyvern Sting (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 49049, 75, 27065, 0 }, -- Aimed Shot (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53271, 75, -1,    0 }, -- Master's Call
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53338, 75, 14325, 0 }, -- Hunter's Mark (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 60052, 75, 60051, 0 }, -- Explosive Shot (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 61005, 75, 53351, 0 }, -- Kill Shot (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 63671, 75, 63670, 0 }, -- Black Arrow (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49071, 76, 27045, 0 }, -- Aspect of the Wild (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48996, 77, 48995, 0 }, -- Raptor Strike (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49052, 77, 49051, 0 }, -- Steady Shot (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49067, 77, 49066, 0 }, -- Explosive Trap (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48999, 78, 48998, 0 }, -- Counterattack (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49056, 78, 49055, 0 }, -- Immolation Trap (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49001, 79, 49000, 0 }, -- Serpent Sting (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49045, 79, 49044, 0 }, -- Arcane Shot (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48990, 80, 48989, 0 }, -- Mend Pet (Rank 10)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 49012, 80, 49011, 0 }, -- Wyvern Sting (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49048, 80, -1,    0 }, -- Multi-Shot (Rank 8)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 49050, 80, 49049, 0 }, -- Aimed Shot (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53339, 80, 36916, 0 }, -- Mongoose Bite (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58434, 80, 58431, 0 }, -- Volley (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 60053, 80, 60052, 0 }, -- Explosive Shot (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 60192, 80, -1,    0 }, -- Freezing Arrow (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 61006, 80, 61005, 0 }, -- Kill Shot (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 61847, 80, 61846, 0 }, -- Aspect of the Dragonhawk (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 62757, 80, -1,    0 }, -- Call Stabled Pet
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 63672, 80, 63671, 0 }}, -- Black Arrow (Rank 6)
    -- Rogue (Id: 4)
    {{ TYPE_PROFICIENCY, RACE_UNDEFINED, 196,   0,  -1,    0 }, -- One-Handed Axes
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 198,   0,  -1,    0 }, -- One-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 201,   0,  -1,    0 }, -- One-Handed Swords
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 264,   0,  -1,    0 }, -- Bows
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 266,   0,  -1,    0 }, -- Guns
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 1180,  0,  -1,    0 }, -- Daggers
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 5011,  0,  -1,    0 }, -- Crossbows
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 15590, 0,  -1,    0 }, -- Fist Weapons
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1752,  1,  -1,    0 }, -- Sinister Strike (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1784,  1,  -1,    0 }, -- Stealth
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1804,  1,  -1,    0 }, -- Pick Lock
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2098,  1,  -1,    0 }, -- Eviscerate (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53,    4,  -1,    0 }, -- Backstab (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 921,   4,  -1,    0 }, -- Pick Pocket
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1757,  6,  1752,  0 }, -- Sinister Strike (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1776,  6,  -1,    0 }, -- Gouge
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5277,  8,  -1,    0 }, -- Evasion (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6760,  8,  2098,  0 }, -- Eviscerate (Rank 2)
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 674,   10, -1,    0 }, -- Dual Wield (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2983,  10, -1,    0 }, -- Sprint (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5171,  10, -1,    0 }, -- Slice and Dice (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6770,  10, -1,    0 }, -- Sap (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1766,  12, -1,    0 }, -- Kick
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2589,  12, 53,    0 }, -- Backstab (Rank 2)
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 3127,  12, -1,    0 }, -- Parry (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 703,   14, -1,    0 }, -- Garrote (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1758,  14, 1757,  0 }, -- Sinister Strike (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8647,  14, -1,    0 }, -- Expose Armor
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1966,  16, -1,    0 }, -- Feint (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6761,  16, 6760,  0 }, -- Eviscerate (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8676,  18, -1,    0 }, -- Ambush (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1943,  20, -1,    0 }, -- Rupture (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2590,  20, 2589,  0 }, -- Backstab (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51722, 20, -1,    0 }, -- Dismantle
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1725,  22, -1,    0 }, -- Distract
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1759,  22, 1758,  0 }, -- Sinister Strike (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1856,  22, -1,    0 }, -- Vanish (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8631,  22, 703,   0 }, -- Garrote (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2836,  24, -1,    0 }, -- Detect Traps (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6762,  24, 6761,  0 }, -- Eviscerate (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1833,  26, -1,    0 }, -- Cheap Shot
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8724,  26, 8676,  0 }, -- Ambush (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2070,  28, 6770,  0 }, -- Sap (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2591,  28, 2590,  0 }, -- Backstab (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6768,  28, 1966,  0 }, -- Feint (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8639,  28, 1943,  0 }, -- Rupture (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 408,   30, -1,    0 }, -- Kidney Shot (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1760,  30, 1759,  0 }, -- Sinister Strike (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1842,  30, -1,    0 }, -- Disarm Trap
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8632,  30, 8631,  0 }, -- Garrote (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8623,  32, 6762,  0 }, -- Eviscerate (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2094,  34, -1,    0 }, -- Blind
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8696,  34, 2983,  0 }, -- Sprint (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8725,  34, 8724,  0 }, -- Ambush (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8640,  36, 8639,  0 }, -- Rupture (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8721,  36, 2591,  0 }, -- Backstab (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8621,  38, 1760,  0 }, -- Sinister Strike (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8633,  38, 8632,  0 }, -- Garrote (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1860,  40, -1,    0 }, -- Safe Fall (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8624,  40, 8623,  0 }, -- Eviscerate (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8637,  40, 6768,  0 }, -- Feint (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1857,  42, 1856,  0 }, -- Vanish (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6774,  42, 5171,  0 }, -- Slice and Dice (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11267, 42, 8725,  0 }, -- Ambush (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11273, 44, 8640,  0 }, -- Rupture (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11279, 44, 8721,  0 }, -- Backstab (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11289, 46, 8633,  0 }, -- Garrote (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11293, 46, 8621,  0 }, -- Sinister Strike (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 17347, 46, 16511, 0 }, -- Hemorrhage (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11297, 48, 2070,  0 }, -- Sap (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11299, 48, 8624,  0 }, -- Eviscerate (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8643,  50, 408,   0 }, -- Kidney Shot (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11268, 50, 11267, 0 }, -- Ambush (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26669, 50, 5277,  0 }, -- Evasion (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 34411, 50, 1329,  0 }, -- Mutilate (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11274, 52, 11273, 0 }, -- Rupture (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11280, 52, 11279, 0 }, -- Backstab (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11303, 52, 8637,  0 }, -- Feint (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11290, 54, 11289, 0 }, -- Garrote (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11294, 54, 11293, 0 }, -- Sinister Strike (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11300, 56, 11299, 0 }, -- Eviscerate (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11269, 58, 11268, 0 }, -- Ambush (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11305, 58, 8696,  0 }, -- Sprint (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 17348, 58, 17347, 0 }, -- Hemorrhage (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11275, 60, 11274, 0 }, -- Rupture (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11281, 60, 11280, 0 }, -- Backstab (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25300, 60, 11281, 0 }, -- Backstab (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25302, 60, 11303, 0 }, -- Feint (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 31016, 60, 11300, 0 }, -- Eviscerate (Rank 9)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 34412, 60, 34411, 0 }, -- Mutilate (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26839, 61, 11290, 0 }, -- Garrote (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26861, 62, 11294, 0 }, -- Sinister Strike (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26889, 62, 1857,  0 }, -- Vanish (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 32645, 62, -1,    0 }, -- Envenom (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26679, 64, -1,    0 }, -- Deadly Throw (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26865, 64, 31016, 0 }, -- Eviscerate (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27448, 64, 25302, 0 }, -- Feint (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27441, 66, 11269, 0 }, -- Ambush (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 31224, 66, -1,    0 }, -- Cloak of Shadows
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26863, 68, 25300, 0 }, -- Backstab (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26867, 68, 11275, 0 }, -- Rupture (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 32684, 69, 32645, 0 }, -- Envenom (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5938,  70, -1,    0 }, -- Shiv
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26862, 70, 26861, 0 }, -- Sinister Strike (Rank 10)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 26864, 70, 17348, 0 }, -- Hemorrhage (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26884, 70, 26839, 0 }, -- Garrote (Rank 8)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 34413, 70, 34412, 0 }, -- Mutilate (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48673, 70, 26679, 0 }, -- Deadly Throw (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48689, 70, 27441, 0 }, -- Ambush (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51724, 71, 11297, 0 }, -- Sap (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48658, 72, 27448, 0 }, -- Feint (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48667, 73, 26865, 0 }, -- Eviscerate (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48656, 74, 26863, 0 }, -- Backstab (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48671, 74, 26867, 0 }, -- Rupture (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 57992, 74, 32684, 0 }, -- Envenom (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48663, 75, 34413, 0 }, -- Mutilate (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48675, 75, 26884, 0 }, -- Garrote (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48690, 75, 48689, 0 }, -- Ambush (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 57934, 75, -1,    0 }, -- Tricks of the Trade
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48637, 76, 26862, 0 }, -- Sinister Strike 11
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48674, 76, 48673, 0 }, -- Deadly Throw (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48659, 78, 48658, 0 }, -- Feint (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48668, 79, 48667, 0 }, -- Eviscerate (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48672, 79, 48671, 0 }, -- Rupture (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48638, 80, 48637, 0 }, -- Sinister Strike (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48657, 80, 48656, 0 }, -- Backstab (Rank 12)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48660, 80, 26864, 0 }, -- Hemorrhage (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48666, 80, 48663, 0 }, -- Mutilate (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48676, 80, 48675, 0 }, -- Garrote (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48691, 80, 48690, 0 }, -- Ambush (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51723, 80, -1,    0 }, -- Fan of Knives
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 57993, 80, 57992, 0 }}, -- Envenom (Rank 4)
    -- Priest (Id: 5)
    {{ TYPE_PROFICIENCY, RACE_UNDEFINED, 198,   0,  -1,    0 }, -- One-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 227,   0,  -1,    0 }, -- Staves
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 1180,  0,  -1,    0 }, -- Daggers
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 5009,  0,  -1,    0 }, -- Wands
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 585,   1,  -1,    0 }, -- Smite (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1243,  1,  -1,    0 }, -- Power Word: Fortitude (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2050,  1,  -1,    0 }, -- Lesser Heal (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 589,   4,  -1,    0 }, -- Shadow Word: Pain (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2052,  4,  2050,  0 }, -- Lesser Heal (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17,    6,  -1,    0 }, -- Power Word: Shield (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 591,   6,  585,   0 }, -- Smite (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 139,   8,  -1,    0 }, -- Renew (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 586,   8,  -1,    0 }, -- Fade
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 594,   10, 589,   0 }, -- Shadow Word: Pain (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2006,  10, -1,    0 }, -- Resurrection (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2053,  10, 2052,  0 }, -- Lesser Heal (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8092,  10, -1,    0 }, -- Mind Blast (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 588,   12, -1,    0 }, -- Inner Fire (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 592,   12, 17,    0 }, -- Power Word: Shield (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1244,  12, 1243,  0 }, -- Power Word: Fortitude (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 528,   14, -1,    0 }, -- Cure Disease
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 598,   14, 591,   0 }, -- Smite (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6074,  14, 139,   0 }, -- Renew (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8122,  14, -1,    0 }, -- Psychic Scream (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2054,  16, -1,    0 }, -- Heal (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8102,  16, 8092,  0 }, -- Mind Blast (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 527,   18, -1,    0 }, -- Dispel Magic (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 600,   18, 592,   0 }, -- Power Word: Shield (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 970,   18, 594,   0 }, -- Shadow Word: Pain (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 453,   20, -1,    0 }, -- Mind Soothe
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2061,  20, -1,    0 }, -- Flash Heal (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2944,  20, -1,    0 }, -- Devouring Plague (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6075,  20, 6074,  0 }, -- Renew (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6346,  20, -1,    0 }, -- Fear Ward
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7128,  20, 588,   0 }, -- Inner Fire (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9484,  20, -1,    0 }, -- Shackle Undead (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14914, 20, -1,    0 }, -- Holy Fire (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15237, 20, -1,    0 }, -- Holy Nova (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 984,   22, 598,   0 }, -- Smite (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2010,  22, 2006,  0 }, -- Resurrection (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2055,  22, 2054,  0 }, -- Heal (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2096,  22, -1,    0 }, -- Mind Vision (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8103,  22, 8102,  0 }, -- Mind Blast (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1245,  24, 1244,  0 }, -- Power Word: Fortitude (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3747,  24, 600,   0 }, -- Power Word: Shield (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8129,  24, -1,    0 }, -- Mana Burn
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15262, 24, 14914, 0 }, -- Holy Fire (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 992,   26, 970,   0 }, -- Shadow Word: Pain (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6076,  26, 6075,  0 }, -- Renew (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9472,  26, 2061,  0 }, -- Flash Heal (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 19238, 26, 19236, 0 }, -- Desperate Prayer (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6063,  28, 2055,  0 }, -- Heal (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8104,  28, 8103,  0 }, -- Mind Blast (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8124,  28, 8122,  0 }, -- Psychic Scream (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15430, 28, 15237, 0 }, -- Holy Nova (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 17311, 28, 15407, 0 }, -- Mind Flay (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19276, 28, 2944,  0 }, -- Devouring Plague (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 596,   30, -1,    0 }, -- Prayer of Healing (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 602,   30, 7128,  0 }, -- Inner Fire (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 605,   30, -1,    0 }, -- Mind Control
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 976,   30, -1,    0 }, -- Shadow Protection (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1004,  30, 984,   0 }, -- Smite (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6065,  30, 3747,  0 }, -- Power Word: Shield (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14752, 30, -1,    0 }, -- Divine Spirit (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15263, 30, 15262, 0 }, -- Holy Fire (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 552,   32, -1,    0 }, -- Abolish Disease
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6077,  32, 6076,  0 }, -- Renew (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9473,  32, 9472,  0 }, -- Flash Heal (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1706,  34, -1,    0 }, -- Levitate
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2767,  34, 992,   0 }, -- Shadow Word: Pain (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6064,  34, 6063,  0 }, -- Heal (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8105,  34, 8104,  0 }, -- Mind Blast (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10880, 34, 2010,  0 }, -- Resurrection (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 19240, 34, 19238, 0 }, -- Desperate Prayer (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 988,   36, 527,   0 }, -- Dispel Magic (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2791,  36, 1245,  0 }, -- Power Word: Fortitude (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6066,  36, 6065,  0 }, -- Power Word: Shield (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15264, 36, 15263, 0 }, -- Holy Fire (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15431, 36, 15430, 0 }, -- Holy Nova (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 17312, 36, 17311, 0 }, -- Mind Flay (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19277, 36, 19276, 0 }, -- Devouring Plague (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6060,  38, 1004,  0 }, -- Smite (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6078,  38, 6077,  0 }, -- Renew (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9474,  38, 9473,  0 }, -- Flash Heal (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 996,   40, 596,   0 }, -- Prayer of Healing (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1006,  40, 602,   0 }, -- Inner Fire (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2060,  40, -1,    0 }, -- Greater Heal (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8106,  40, 8105,  0 }, -- Mind Blast (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9485,  40, 9484,  0 }, -- Shackle Undead (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14818, 40, 14752, 0 }, -- Divine Spirit (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10888, 42, 8124,  0 }, -- Psychic Scream (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10892, 42, 2767,  0 }, -- Shadow Word: Pain (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10898, 42, 6066,  0 }, -- Power Word: Shield (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10957, 42, 976,   0 }, -- Shadow Protection (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15265, 42, 15264, 0 }, -- Holy Fire (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 19241, 42, 19240, 0 }, -- Desperate Prayer (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10909, 44, 2096,  0 }, -- Mind Vision (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10915, 44, 9474,  0 }, -- Flash Heal (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10927, 44, 6078,  0 }, -- Renew (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 17313, 44, 17312, 0 }, -- Mind Flay (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19278, 44, 19277, 0 }, -- Devouring Plague (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27799, 44, 15431, 0 }, -- Holy Nova (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10881, 46, 10880, 0 }, -- Resurrection (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10933, 46, 6060,  0 }, -- Smite (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10945, 46, 8106,  0 }, -- Mind Blast (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10963, 46, 2060,  0 }, -- Greater Heal (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10899, 48, 10898, 0 }, -- Power Word: Shield (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10937, 48, 2791,  0 }, -- Power Word: Fortitude (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15266, 48, 15265, 0 }, -- Holy Fire (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 21562, 48, -1,    0 }, -- Prayer of Fortitude (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10893, 50, 10892, 0 }, -- Shadow Word: Pain (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10916, 50, 10915, 0 }, -- Flash Heal (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10928, 50, 10927, 0 }, -- Renew (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10951, 50, 1006,  0 }, -- Inner Fire (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10960, 50, 996,   0 }, -- Prayer of Healing (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 14819, 50, 14818, 0 }, -- Divine Spirit (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 19242, 50, 19241, 0 }, -- Desperate Prayer (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27870, 50, 724,   0 }, -- Lightwell (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10946, 52, 10945, 0 }, -- Mind Blast (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10964, 52, 10963, 0 }, -- Greater Heal (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 17314, 52, 17313, 0 }, -- Mind Flay (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19279, 52, 19278, 0 }, -- Devouring Plague (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27800, 52, 27799, 0 }, -- Holy Nova (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10900, 54, 10899, 0 }, -- Power Word: Shield (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10934, 54, 10933, 0 }, -- Smite (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15267, 54, 15266, 0 }, -- Holy Fire (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10890, 56, 10888, 0 }, -- Psychic Scream (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10917, 56, 10916, 0 }, -- Flash Heal (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10929, 56, 10928, 0 }, -- Renew (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10958, 56, 10957, 0 }, -- Shadow Protection (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27683, 56, -1,    0 }, -- Prayer of Shadow Protection (Rank 1)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 34863, 56, 34861, 0 }, -- Circle of Healing (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10894, 58, 10893, 0 }, -- Shadow Word: Pain (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10947, 58, 10946, 0 }, -- Mind Blast (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10965, 58, 10964, 0 }, -- Greater Heal (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 19243, 58, 19242, 0 }, -- Desperate Prayer (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20770, 58, 10881, 0 }, -- Resurrection (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10901, 60, 10900, 0 }, -- Power Word: Shield (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10938, 60, 10937, 0 }, -- Power Word: Fortitude (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10952, 60, 10951, 0 }, -- Inner Fire (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10955, 60, 9485,  0 }, -- Shackle Undead (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10961, 60, 10960, 0 }, -- Prayer of Healing (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15261, 60, 15267, 0 }, -- Holy Fire (Rank 8)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 18807, 60, 17314, 0 }, -- Mind Flay (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 19280, 60, 19279, 0 }, -- Devouring Plague (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 21564, 60, 21562, 0 }, -- Prayer of Fortitude (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25314, 60, 10965, 0 }, -- Greater Heal (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25315, 60, 10929, 0 }, -- Renew (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25316, 60, 10961, 0 }, -- Prayer of Healing (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27681, 60, -1,    0 }, -- Prayer of Spirit (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27801, 60, 27800, 0 }, -- Holy Nova (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27841, 60, 14819, 0 }, -- Divine Spirit (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27871, 60, 27870, 0 }, -- Lightwell (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 34864, 60, 34863, 0 }, -- Circle of Healing (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 34916, 60, 34914, 0 }, -- Vampiric Touch (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25233, 61, 10917, 0 }, -- Flash Heal (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25363, 61, 10934, 0 }, -- Smite (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 32379, 62, -1,    0 }, -- Shadow Word: Death (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25210, 63, 25314, 0 }, -- Greater Heal (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25372, 63, 10947, 0 }, -- Mind Blast (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 32546, 64, -1,    0 }, -- Binding Heal (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25217, 65, 10901, 0 }, -- Power Word: Shield (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25221, 65, 25315, 0 }, -- Renew (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25367, 65, 10894, 0 }, -- Shadow Word: Pain (Rank 9)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 34865, 65, 34864, 0 }, -- Circle of Healing (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25384, 66, 15261, 0 }, -- Holy Fire (Rank 9)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 25437, 66, 19243, 0 }, -- Desperate Prayer (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 34433, 66, -1,    0 }, -- Shadowfiend
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25235, 67, 25233, 0 }, -- Flash Heal (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25213, 68, 25210, 0 }, -- Greater Heal (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25308, 68, 25316, 0 }, -- Prayer of Healing (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25331, 68, 27801, 0 }, -- Holy Nova (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 25387, 68, 18807, 0 }, -- Mind Flay (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25433, 68, 10958, 0 }, -- Shadow Protection (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25435, 68, 20770, 0 }, -- Resurrection (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25467, 68, 19280, 0 }, -- Devouring Plague (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 33076, 68, -1,    0 }, -- Prayer of Mending (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25364, 69, 25363, 0 }, -- Smite (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25375, 69, 25372, 0 }, -- Mind Blast (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25431, 69, 10952, 0 }, -- Inner Fire (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25218, 70, 25217, 0 }, -- Power Word: Shield (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25222, 70, 25221, 0 }, -- Renew (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25312, 70, 27841, 0 }, -- Divine Spirit (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25368, 70, 25367, 0 }, -- Shadow Word: Pain (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25389, 70, 10938, 0 }, -- Power Word: Fortitude (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25392, 70, 21564, 0 }, -- Prayer of Fortitude (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 28275, 70, 27871, 0 }, -- Lightwell (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 32375, 70, -1,    0 }, -- Mass Dispel
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 32996, 70, 32379, 0 }, -- Shadow Word: Death (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 32999, 70, 27681, 0 }, -- Prayer of Spirit (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 34866, 70, 34865, 0 }, -- Circle of Healing (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 34917, 70, 34916, 0 }, -- Vampiric Touch (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 39374, 70, 27683, 0 }, -- Prayer of Shadow Protection (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53005, 70, 47540, 0 }, -- Penance (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48040, 71, 25431, 0 }, -- Inner Fire (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48119, 72, 32546, 0 }, -- Binding Heal (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48134, 72, 25384, 0 }, -- Holy Fire (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48062, 73, 25213, 0 }, -- Greater Heal (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48070, 73, 25235, 0 }, -- Flash Heal (Rank 10)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48172, 73, 25437, 0 }, -- Desperate Prayer (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48299, 73, 25467, 0 }, -- Devouring Plague (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48112, 74, 33076, 0 }, -- Prayer of Mending (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48122, 74, 25364, 0 }, -- Smite (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48126, 74, 25375, 0 }, -- Mind Blast (Rank 12)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48155, 74, 25387, 0 }, -- Mind Flay (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48045, 75, -1,    0 }, -- Mind Sear (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48065, 75, 25218, 0 }, -- Power Word: Shield (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48067, 75, 25222, 0 }, -- Renew (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48077, 75, 25331, 0 }, -- Holy Nova (Rank 8)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48086, 75, 28275, 0 }, -- Lightwell (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48088, 75, 34866, 0 }, -- Circle of Healing (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48124, 75, 25368, 0 }, -- Shadow Word: Pain (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48157, 75, 32996, 0 }, -- Shadow Word: Death (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48159, 75, 34917, 0 }, -- Vampiric Touch (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53006, 75, 53005, 0 }, -- Penance (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48072, 76, 25308, 0 }, -- Prayer of Healing (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48169, 76, 25433, 0 }, -- Shadow Protection (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48168, 77, 48040, 0 }, -- Inner Fire (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48170, 77, 39374, 0 }, -- Prayer of Shadow Protection (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48063, 78, 48062, 0 }, -- Greater Heal (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48120, 78, 48119, 0 }, -- Binding Heal (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48135, 78, 48134, 0 }, -- Holy Fire (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48171, 78, 25435, 0 }, -- Resurrection (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48071, 79, 48070, 0 }, -- Flash Heal (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48113, 79, 48112, 0 }, -- Prayer of Mending (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48123, 79, 48122, 0 }, -- Smite (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48127, 79, 48126, 0 }, -- Mind Blast (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48300, 79, 48299, 0 }, -- Devouring Plague (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48066, 80, 48065, 0 }, -- Power Word: Shield (Rank 14)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48068, 80, 48067, 0 }, -- Renew (Rank 14)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48073, 80, 25312, 0 }, -- Divine Spirit (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48074, 80, 32999, 0 }, -- Prayer of Spirit (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48078, 80, 48077, 0 }, -- Holy Nova (Rank 9)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48087, 80, 48086, 0 }, -- Lightwell (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48089, 80, 48088, 0 }, -- Circle of Healing (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48125, 80, 48124, 0 }, -- Shadow Word: Pain (Rank 12)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48156, 80, 48155, 0 }, -- Mind Flay (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48158, 80, 48157, 0 }, -- Shadow Word: Death (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48160, 80, 48159, 0 }, -- Vampiric Touch (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48161, 80, 25389, 0 }, -- Power Word: Fortitude (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48162, 80, 25392, 0 }, -- Prayer of Fortitude (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48173, 80, 48172, 0 }, -- Desperate Prayer (Rank 9)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53007, 80, 53006, 0 }, -- Penance (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53023, 80, 48045, 0 }, -- Mind Sear (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 64843, 80, -1,    0 }, -- Divine Hymn (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 64901, 80, -1,    0 }}, -- Hymn of Hope
    -- Death Knight (Id: 6)
    {{ TYPE_PROFICIENCY, RACE_UNDEFINED, 196,   0,  -1,    0 }, -- One-Handed Axes
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 197,   0,  -1,    0 }, -- Two-Handed Axes
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 198,   0,  -1,    0 }, -- One-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 199,   0,  -1,    0 }, -- Two-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 200,   0,  -1,    0 }, -- Polearms
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 201,   0,  -1,    0 }, -- One-Handed Swords
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 202,   0,  -1,    0 }, -- Two-Handed Swords
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 3127,  12, -1,    0 }, -- Parry (Passive)
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 674,   20, -1,    0 }, -- Dual Wield (Passive)
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 750,   40, -1,    0 }, -- Plate Mail
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 45462, 55, -1,    0 }, -- Plague Strike (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 45477, 55, -1,    0 }, -- Icy Touch (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 45902, 55, -1,    0 }, -- Blood Strike (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47541, 55, -1,    0 }, -- Death Coil (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48266, 55, -1,    0 }, -- Blood Presence
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49576, 55, -1,    0 }, -- Death Grip
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50977, 55, -1,    0 }, -- Death Gate
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53323, 55, -1,    0 }, -- Rune of Swordshattering
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53331, 55, -1,    0 }, -- Rune of Lichbane
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53342, 55, -1,    0 }, -- Rune of Spellshattering
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53344, 55, -1,    0 }, -- Rune of the Fallen Crusader
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 54446, 55, -1,    0 }, -- Rune of Swordbreaking
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 54447, 55, -1,    0 }, -- Rune of Spellbreaking
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 62158, 55, -1,    0 }, -- Rune of the Stoneskin Gargoyle
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 70164, 55, -1,    0 }, -- Rune of the Nerubian Carapace
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 46584, 56, -1,    0 }, -- Raise Dead
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49998, 56, -1,    0 }, -- Death Strike (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50842, 56, -1,    0 }, -- Pestilence
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47528, 57, -1,    0 }, -- Mind Freeze
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48263, 57, -1,    0 }, -- Frost Presence
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 45524, 58, -1,    0 }, -- Chains of Ice
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48721, 58, -1,    0 }, -- Blood Boil (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47476, 59, -1,    0 }, -- Strangulate
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49926, 59, 45902, 0 }, -- Blood Strike (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 55258, 59, 55050, 0 }, -- Heart Strike (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43265, 60, -1,    0 }, -- Death and Decay (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49917, 60, 45462, 0 }, -- Plague Strike (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 51325, 60, 49158, 0 }, -- Corpse Explosion (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 51416, 60, 49143, 0 }, -- Frost Strike (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3714,  61, -1,    0 }, -- Path of Frost
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49020, 61, -1,    0 }, -- Obliterate (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49896, 61, 45477, 0 }, -- Icy Touch (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48792, 62, -1,    0 }, -- Icebound Fortitude
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49892, 62, 47541, 0 }, -- Death Coil (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49999, 63, 49998, 0 }, -- Death Strike (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 45529, 64, -1,    0 }, -- Blood Tap
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49927, 64, 49926, 0 }, -- Blood Strike (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 55259, 64, 55258, 0 }, -- Heart Strike (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49918, 65, 49917, 0 }, -- Plague Strike (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 51417, 65, 51416, 0 }, -- Frost Strike (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 56222, 65, -1,    0 }, -- Dark Command
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 57330, 65, -1,    0 }, -- Horn of Winter (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48743, 66, -1,    0 }, -- Death Pact
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49939, 66, 48721, 0 }, -- Blood Boil (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49903, 67, 49896, 0 }, -- Icy Touch (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49936, 67, 43265, 0 }, -- Death and Decay (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51423, 67, 49020, 0 }, -- Obliterate (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 55265, 67, 55090, 0 }, -- Scourge Strike (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 56815, 67, -1,    0 }, -- Rune Strike
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48707, 68, -1,    0 }, -- Anti-Magic Shell
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49893, 68, 49892, 0 }, -- Death Coil (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49928, 69, 49927, 0 }, -- Blood Strike (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 55260, 69, 55259, 0 }, -- Heart Strike (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 45463, 70, 49999, 0 }, -- Death Strike (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48265, 70, -1,    0 }, -- Unholy Presence
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49919, 70, 49918, 0 }, -- Plague Strike (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 51326, 70, 51325, 0 }, -- Corpse Explosion (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 51409, 70, 49184, 0 }, -- Howling Blast (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 51418, 70, 51417, 0 }, -- Frost Strike (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49940, 72, 49939, 0 }, -- Blood Boil (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 61999, 72, -1,    0 }, -- Raise Ally
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49904, 73, 49903, 0 }, -- Icy Touch (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49937, 73, 49936, 0 }, -- Death and Decay (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51424, 73, 51423, 0 }, -- Obliterate (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 55270, 73, 55265, 0 }, -- Scourge Strike (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49929, 74, 49928, 0 }, -- Blood Strike (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 55261, 74, 55260, 0 }, -- Heart Strike (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47568, 75, -1,    0 }, -- Empower Rune Weapon
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49920, 75, 49919, 0 }, -- Plague Strike (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49923, 75, 45463, 0 }, -- Death Strike (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 51327, 75, 51326, 0 }, -- Corpse Explosion (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 51410, 75, 51409, 0 }, -- Howling Blast (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 51419, 75, 51418, 0 }, -- Frost Strike (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 57623, 75, 57330, 0 }, -- Horn of Winter (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49894, 76, 49893, 0 }, -- Death Coil (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49909, 78, 49904, 0 }, -- Icy Touch (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49941, 78, 49940, 0 }, -- Blood Boil (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51425, 79, 51424, 0 }, -- Obliterate (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 55271, 79, 55270, 0 }, -- Scourge Strike (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42650, 80, -1,    0 }, -- Army of the Dead
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49895, 80, 49894, 0 }, -- Death Coil (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49921, 80, 49920, 0 }, -- Plague Strike (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49924, 80, 49923, 0 }, -- Death Strike (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49930, 80, 49929, 0 }, -- Blood Strike (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49938, 80, 49937, 0 }, -- Death and Decay (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 51328, 80, 51327, 0 }, -- Corpse Explosion (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 51411, 80, 51410, 0 }, -- Howling Blast (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 55262, 80, 55261, 0 }, -- Heart Strike (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 55268, 80, 51419, 0 }}, -- Frost Strike (Rank 6)
    -- Shaman (Id: 7)
    {{ TYPE_PROFICIENCY, RACE_UNDEFINED, 196,   0,  -1,    0 }, -- One-Handed Axes
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 197,   0,  -1,    0 }, -- Two-Handed Axes
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 198,   0,  -1,    0 }, -- One-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 199,   0,  -1,    0 }, -- Two-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 227,   0,  -1,    0 }, -- Staves
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 1180,  0,  -1,    0 }, -- Daggers
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 15590, 0,  -1,    0 }, -- Fist Weapons
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 331,   1,  -1,    0 }, -- Healing Wave (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 403,   1,  -1,    0 }, -- Lightning Bolt (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8017,  1,  -1,    0 }, -- Rockbiter Weapon (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8042,  4,  -1,    0 }, -- Earth Shock (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8071,  4,  -1,    1 }, -- Stoneskin Totem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 332,   6,  331,   0 }, -- Healing Wave (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2484,  6,  -1,    0 }, -- Earthbind Totem
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 324,   8,  -1,    0 }, -- Lightning Shield (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 529,   8,  403,   0 }, -- Lightning Bolt (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5730,  8,  -1,    0 }, -- Stoneclaw Totem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8018,  8,  8017,  0 }, -- Rockbiter Weapon (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8044,  8,  8042,  0 }, -- Earth Shock (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3599,  10, -1,    1 }, -- Searing Totem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8024,  10, -1,    0 }, -- Flametongue Weapon (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8050,  10, -1,    0 }, -- Flame Shock (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8075,  10, -1,    0 }, -- Strength of Earth Totem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 370,   12, -1,    0 }, -- Purge (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 547,   12, 332,   0 }, -- Healing Wave (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1535,  12, -1,    0 }, -- Fire Nova (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2008,  12, -1,    0 }, -- Ancestral Spirit (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 548,   14, 529,   0 }, -- Lightning Bolt (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8045,  14, 8044,  0 }, -- Earth Shock (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8154,  14, 8071,  0 }, -- Stoneskin Totem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 325,   16, 324,   0 }, -- Lightning Shield (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 526,   16, -1,    0 }, -- Cure Toxins
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2645,  16, -1,    0 }, -- Ghost Wolf
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8019,  16, 8018,  0 }, -- Rockbiter Weapon (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 57994, 16, -1,    0 }, -- Wind Shear
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 913,   18, 547,   0 }, -- Healing Wave (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6390,  18, 5730,  0 }, -- Stoneclaw Totem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8027,  18, 8024,  0 }, -- Flametongue Weapon (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8052,  18, 8050,  0 }, -- Flame Shock (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8143,  18, -1,    0 }, -- Tremor Totem
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 915,   20, 548,   0 }, -- Lightning Bolt (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5394,  20, -1,    1 }, -- Healing Stream Totem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6363,  20, 3599,  0 }, -- Searing Totem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8004,  20, -1,    0 }, -- Lesser Healing Wave (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8033,  20, -1,    0 }, -- Frostbrand Weapon (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8056,  20, -1,    0 }, -- Frost Shock (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 52127, 20, -1,    0 }, -- Water Shield (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 131,   22, -1,    0 }, -- Water Breathing
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8498,  22, 1535,  0 }, -- Fire Nova (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 905,   24, 325,   0 }, -- Lightning Shield (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 939,   24, 913,   0 }, -- Healing Wave (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8046,  24, 8045,  0 }, -- Earth Shock (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8155,  24, 8154,  0 }, -- Stoneskin Totem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8160,  24, 8075,  0 }, -- Strength of Earth Totem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8181,  24, -1,    0 }, -- Frost Resistance Totem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10399, 24, 8019,  0 }, -- Rockbiter Weapon (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20609, 24, 2008,  0 }, -- Ancestral Spirit (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 943,   26, 915,   0 }, -- Lightning Bolt (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5675,  26, -1,    0 }, -- Mana Spring Totem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6196,  26, -1,    0 }, -- Far Sight
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8030,  26, 8027,  0 }, -- Flametongue Weapon (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8190,  26, -1,    0 }, -- Magma Totem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 546,   28, -1,    0 }, -- Water Walking
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6391,  28, 6390,  0 }, -- Stoneclaw Totem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8008,  28, 8004,  0 }, -- Lesser Healing Wave (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8038,  28, 8033,  0 }, -- Frostbrand Weapon (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8053,  28, 8052,  0 }, -- Flame Shock (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8184,  28, -1,    0 }, -- Fire Resistance Totem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8227,  28, -1,    0 }, -- Flametongue Totem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 52129, 28, 52127, 0 }, -- Water Shield (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 556,   30, -1,    0 }, -- Astral Recall
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6364,  30, 6363,  0 }, -- Searing Totem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6375,  30, 5394,  0 }, -- Healing Stream Totem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8177,  30, -1,    0 }, -- Grounding Totem
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8232,  30, -1,    0 }, -- Windfury Weapon (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10595, 30, -1,    0 }, -- Nature Resistance Totem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20608, 30, -1,    0 }, -- Reincarnation (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 36936, 30, -1,    0 }, -- Totemic Recall
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51730, 30, -1,    0 }, -- Earthliving Weapon (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 66842, 30, -1,    0 }, -- Call of the Elements
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 421,   32, -1,    0 }, -- Chain Lightning (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 945,   32, 905,   0 }, -- Lightning Shield (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 959,   32, 939,   0 }, -- Healing Wave (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6041,  32, 943,   0 }, -- Lightning Bolt (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8012,  32, 370,   0 }, -- Purge (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8499,  32, 8498,  0 }, -- Fire Nova (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8512,  32, -1,    0 }, -- Windfury Totem
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6495,  34, -1,    0 }, -- Sentry Totem
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8058,  34, 8056,  0 }, -- Frost Shock (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10406, 34, 8155,  0 }, -- Stoneskin Totem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 52131, 34, 52129, 0 }, -- Water Shield (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8010,  36, 8008,  0 }, -- Lesser Healing Wave (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10412, 36, 8046,  0 }, -- Earth Shock (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10495, 36, 5675,  0 }, -- Mana Spring Totem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10585, 36, 8190,  0 }, -- Magma Totem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16339, 36, 8030,  0 }, -- Flametongue Weapon (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20610, 36, 20609, 0 }, -- Ancestral Spirit (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6392,  38, 6391,  0 }, -- Stoneclaw Totem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8161,  38, 8160,  0 }, -- Strength of Earth Totem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8170,  38, -1,    0 }, -- Cleansing Totem
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8249,  38, 8227,  0 }, -- Flametongue Totem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10391, 38, 6041,  0 }, -- Lightning Bolt (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10456, 38, 8038,  0 }, -- Frostbrand Weapon (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10478, 38, 8181,  0 }, -- Frost Resistance Totem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 930,   40, 421,   0 }, -- Chain Lightning (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1064,  40, -1,    0 }, -- Chain Heal (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6365,  40, 6364,  0 }, -- Searing Totem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6377,  40, 6375,  0 }, -- Healing Stream Totem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8005,  40, 959,   0 }, -- Healing Wave (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8134,  40, 945,   0 }, -- Lightning Shield (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8235,  40, 8232,  0 }, -- Windfury Weapon (Rank 2)
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 8737,  40, -1,    0 }, -- Mail
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10447, 40, 8053,  0 }, -- Flame Shock (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51988, 40, 51730, 0 }, -- Earthliving Weapon (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 66843, 40, -1,    0 }, -- Call of the Ancestors
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 52134, 41, 52131, 0 }, -- Water Shield (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10537, 42, 8184,  0 }, -- Fire Resistance Totem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11314, 42, 8499,  0 }, -- Fire Nova (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10392, 44, 10391, 0 }, -- Lightning Bolt (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10407, 44, 10406, 0 }, -- Stoneskin Totem (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10466, 44, 8010,  0 }, -- Lesser Healing Wave (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10600, 44, 10595, 0 }, -- Nature Resistance Totem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10472, 46, 8058,  0 }, -- Frost Shock (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10496, 46, 10495, 0 }, -- Mana Spring Totem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10586, 46, 10585, 0 }, -- Magma Totem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10622, 46, 1064,  0 }, -- Chain Heal (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16341, 46, 16339, 0 }, -- Flametongue Weapon (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2860,  48, 930,   0 }, -- Chain Lightning (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10395, 48, 8005,  0 }, -- Healing Wave (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10413, 48, 10412, 0 }, -- Earth Shock (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10427, 48, 6392,  0 }, -- Stoneclaw Totem (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10431, 48, 8134,  0 }, -- Lightning Shield (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10526, 48, 8249,  0 }, -- Flametongue Totem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16355, 48, 10456, 0 }, -- Frostbrand Weapon (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20776, 48, 20610, 0 }, -- Ancestral Spirit (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 52136, 48, 52134, 0 }, -- Water Shield (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10437, 50, 6365,  0 }, -- Searing Totem (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10462, 50, 6377,  0 }, -- Healing Stream Totem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10486, 50, 8235,  0 }, -- Windfury Weapon (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15207, 50, 10392, 0 }, -- Lightning Bolt (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51991, 50, 51988, 0 }, -- Earthliving Weapon (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 66844, 50, -1,    0 }, -- Call of the Spirits
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10442, 52, 8161,  0 }, -- Strength of Earth Totem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10448, 52, 10447, 0 }, -- Flame Shock (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10467, 52, 10466, 0 }, -- Lesser Healing Wave (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11315, 52, 11314, 0 }, -- Fire Nova (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10408, 54, 10407, 0 }, -- Stoneskin Totem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10479, 54, 10478, 0 }, -- Frost Resistance Totem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10623, 54, 10622, 0 }, -- Chain Heal (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 52138, 55, 52136, 0 }, -- Water Shield (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10396, 56, 10395, 0 }, -- Healing Wave (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10432, 56, 10431, 0 }, -- Lightning Shield (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10497, 56, 10496, 0 }, -- Mana Spring Totem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10587, 56, 10586, 0 }, -- Magma Totem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10605, 56, 2860,  0 }, -- Chain Lightning (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 15208, 56, 15207, 0 }, -- Lightning Bolt (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16342, 56, 16341, 0 }, -- Flametongue Weapon (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10428, 58, 10427, 0 }, -- Stoneclaw Totem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10473, 58, 10472, 0 }, -- Frost Shock (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10538, 58, 10537, 0 }, -- Fire Resistance Totem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16356, 58, 16355, 0 }, -- Frostbrand Weapon (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16387, 58, 10526, 0 }, -- Flametongue Totem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10414, 60, 10413, 0 }, -- Earth Shock (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10438, 60, 10437, 0 }, -- Searing Totem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10463, 60, 10462, 0 }, -- Healing Stream Totem (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10468, 60, 10467, 0 }, -- Lesser Healing Wave (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10601, 60, 10600, 0 }, -- Nature Resistance Totem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16362, 60, 10486, 0 }, -- Windfury Weapon (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20777, 60, 20776, 0 }, -- Ancestral Spirit (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25357, 60, 10396, 0 }, -- Healing Wave (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25361, 60, 10442, 0 }, -- Strength of Earth Totem (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 29228, 60, 10448, 0 }, -- Flame Shock (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 32593, 60, 974,   0 }, -- Earth Shield (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51992, 60, 51991, 0 }, -- Earthliving Weapon (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 57720, 60, 30706, 0 }, -- Totem of Wrath (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25422, 61, 10623, 0 }, -- Chain Heal (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25546, 61, 11315, 0 }, -- Fire Nova (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 24398, 62, 52138, 0 }, -- Water Shield (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25448, 62, 15208, 0 }, -- Lightning Bolt (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25391, 63, 25357, 0 }, -- Healing Wave (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25439, 63, 10605, 0 }, -- Chain Lightning (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25469, 63, 10432, 0 }, -- Lightning Shield (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25508, 63, 10408, 0 }, -- Stoneskin Totem (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3738,  64, -1,    0 }, -- Wrath of Air Totem
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25489, 64, 16342, 0 }, -- Flametongue Weapon (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25528, 65, 25361, 0 }, -- Strength of Earth Totem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25552, 65, 10587, 0 }, -- Magma Totem (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25570, 65, 10497, 0 }, -- Mana Spring Totem (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2062,  66, -1,    0 }, -- Earth Elemental Totem
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25420, 66, 10468, 0 }, -- Lesser Healing Wave (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25500, 66, 16356, 0 }, -- Frostbrand Weapon (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25449, 67, 25448, 0 }, -- Lightning Bolt (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25525, 67, 10428, 0 }, -- Stoneclaw Totem (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25557, 67, 16387, 0 }, -- Flametongue Totem (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25560, 67, 10479, 0 }, -- Frost Resistance Totem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2894,  68, -1,    0 }, -- Fire Elemental Totem
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25423, 68, 25422, 0 }, -- Chain Heal (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25464, 68, 10473, 0 }, -- Frost Shock (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25505, 68, 16362, 0 }, -- Windfury Weapon (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25563, 68, 10538, 0 }, -- Fire Resistance Totem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25454, 69, 10414, 0 }, -- Earth Shock (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25533, 69, 10438, 0 }, -- Searing Totem (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25567, 69, 10463, 0 }, -- Healing Stream Totem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25574, 69, 10601, 0 }, -- Nature Resistance Totem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25590, 69, 20777, 0 }, -- Ancestral Spirit (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 33736, 69, 24398, 0 }, -- Water Shield (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2825,  70, -1,    0 }, -- Bloodlust
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25396, 70, 25391, 0 }, -- Healing Wave (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25442, 70, 25439, 0 }, -- Chain Lightning (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25457, 70, 29228, 0 }, -- Flame Shock (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25472, 70, 25469, 0 }, -- Lightning Shield (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25509, 70, 25508, 0 }, -- Stoneskin Totem (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25547, 70, 25546, 0 }, -- Fire Nova (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 32594, 70, 32593, 0 }, -- Earth Shield (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51993, 70, 51992, 0 }, -- Earthliving Weapon (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 57721, 70, 57720, 0 }, -- Totem of Wrath (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 59156, 70, 51490, 0 }, -- Thunderstorm (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 61299, 70, 61295, 0 }, -- Riptide (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58580, 71, 25525, 0 }, -- Stoneclaw Totem (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58649, 71, 25557, 0 }, -- Flametongue Totem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58699, 71, 25533, 0 }, -- Searing Totem (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58755, 71, 25567, 0 }, -- Healing Stream Totem (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58771, 71, 25570, 0 }, -- Mana Spring Totem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58785, 71, 25489, 0 }, -- Flametongue Weapon (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58794, 71, 25500, 0 }, -- Frostbrand Weapon (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58801, 71, 25505, 0 }, -- Windfury Weapon (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49275, 72, 25420, 0 }, -- Lesser Healing Wave (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49235, 73, 25464, 0 }, -- Frost Shock (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49237, 73, 25449, 0 }, -- Lightning Bolt (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58731, 73, 25552, 0 }, -- Magma Totem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58751, 73, 25509, 0 }, -- Stoneskin Totem (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49230, 74, 25454, 0 }, -- Earth Shock (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49270, 74, 25442, 0 }, -- Chain Lightning (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 55458, 74, 25423, 0 }, -- Chain Heal (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49232, 75, 25457, 0 }, -- Flame Shock (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49272, 75, 25396, 0 }, -- Healing Wave (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49280, 75, 25472, 0 }, -- Lightning Shield (Rank 10)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 49283, 75, 32594, 0 }, -- Earth Shield (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51505, 75, -1,    0 }, -- Lava Burst (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 57622, 75, 25528, 0 }, -- Strength of Earth Totem (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58581, 75, 58580, 0 }, -- Stoneclaw Totem (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58652, 75, 58649, 0 }, -- Flametongue Totem (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58703, 75, 58699, 0 }, -- Searing Totem (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58737, 75, 25563, 0 }, -- Fire Resistance Totem (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58741, 75, 25560, 0 }, -- Frost Resistance Totem (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58746, 75, 25574, 0 }, -- Nature Resistance Totem (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 59158, 75, 59156, 0 }, -- Thunderstorm (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 61300, 75, 61299, 0 }, -- Riptide (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 61649, 75, 25547, 0 }, -- Fire Nova (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 57960, 76, 33736, 0 }, -- Water Shield (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58756, 76, 58755, 0 }, -- Healing Stream Totem (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58773, 76, 58771, 0 }, -- Mana Spring Totem (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58789, 76, 58785, 0 }, -- Flametongue Weapon (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58795, 76, 58794, 0 }, -- Frostbrand Weapon (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58803, 76, 58801, 0 }, -- Windfury Weapon (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49276, 77, 49275, 0 }, -- Lesser Healing Wave (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49236, 78, 49235, 0 }, -- Frost Shock (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58582, 78, 58581, 0 }, -- Stoneclaw Totem (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58734, 78, 58731, 0 }, -- Magma Totem (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58753, 78, 58751, 0 }, -- Stoneskin Totem (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49231, 79, 49230, 0 }, -- Earth Shock (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49238, 79, 49237, 0 }, -- Lightning Bolt (Rank 14)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49233, 80, 49232, 0 }, -- Flame Shock (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49271, 80, 49270, 0 }, -- Chain Lightning (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49273, 80, 49272, 0 }, -- Healing Wave (Rank 14)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49277, 80, 25590, 0 }, -- Ancestral Spirit (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49281, 80, 49280, 0 }, -- Lightning Shield (Rank 11)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 49284, 80, 49283, 0 }, -- Earth Shield (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51514, 80, -1,    0 }, -- Hex
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 51994, 80, 51993, 0 }, -- Earthliving Weapon (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 55459, 80, 55458, 0 }, -- Chain Heal (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 57722, 80, 57721, 0 }, -- Totem of Wrath (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58643, 80, 57622, 0 }, -- Strength of Earth Totem (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58656, 80, 58652, 0 }, -- Flametongue Totem (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58704, 80, 58703, 0 }, -- Searing Totem (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58739, 80, 58737, 0 }, -- Fire Resistance Totem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58745, 80, 58741, 0 }, -- Frost Resistance Totem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58749, 80, 58746, 0 }, -- Nature Resistance Totem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58757, 80, 58756, 0 }, -- Healing Stream Totem (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58774, 80, 58773, 0 }, -- Mana Spring Totem (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58790, 80, 58789, 0 }, -- Flametongue Weapon (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58796, 80, 58795, 0 }, -- Frostbrand Weapon (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58804, 80, 58803, 0 }, -- Windfury Weapon (Rank 8)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 59159, 80, 59158, 0 }, -- Thunderstorm (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 60043, 80, 51505, 0 }, -- Lava Burst (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 61301, 80, 61300, 0 }, -- Riptide (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 61657, 80, 61649, 0 }}, -- Fire Nova (Rank 9)
    -- Mage (Id: 8)
    {{ TYPE_PROFICIENCY, RACE_UNDEFINED, 201,   0,  -1,    0 }, -- One-Handed Swords
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 227,   0,  -1,    0 }, -- Staves
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 1180,  0,  -1,    0 }, -- Daggers
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 5009,  0,  -1,    0 }, -- Wands
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 133,   1,  -1,    0 }, -- Fireball (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 168,   1,  -1,    0 }, -- Frost Armor (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1459,  1,  -1,    0 }, -- Arcane Intellect (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 116,   4,  -1,    0 }, -- Frostbolt (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5504,  4,  -1,    0 }, -- Conjure Water (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 143,   6,  133,   0 }, -- Fireball (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 587,   6,  -1,    0 }, -- Conjure Food (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2136,  6,  -1,    0 }, -- Fire Blast (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 118,   8,  -1,    0 }, -- Polymorph (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 205,   8,  116,   0 }, -- Frostbolt (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5143,  8,  -1,    0 }, -- Arcane Missiles (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 122,   10, -1,    0 }, -- Frost Nova (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5505,  10, 5504,  0 }, -- Conjure Water (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7300,  10, 168,   0 }, -- Frost Armor (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 130,   12, -1,    0 }, -- Slow Fall
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 145,   12, 143,   0 }, -- Fireball (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 597,   12, 587,   0 }, -- Conjure Food (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 604,   12, -1,    0 }, -- Dampen Magic (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 837,   14, 205,   0 }, -- Frostbolt (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1449,  14, -1,    0 }, -- Arcane Explosion (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1460,  14, 1459,  0 }, -- Arcane Intellect (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2137,  14, 2136,  0 }, -- Fire Blast (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2120,  16, -1,    0 }, -- Flamestrike (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5144,  16, 5143,  0 }, -- Arcane Missiles (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 475,   18, -1,    0 }, -- Remove Curse
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1008,  18, -1,    0 }, -- Amplify Magic (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3140,  18, 145,   0 }, -- Fireball (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10,    20, -1,    0 }, -- Blizzard (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 543,   20, -1,    0 }, -- Fire Ward (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1463,  20, -1,    0 }, -- Mana Shield (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1953,  20, -1,    0 }, -- Blink
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5506,  20, 5505,  0 }, -- Conjure Water (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7301,  20, 7300,  0 }, -- Frost Armor (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7322,  20, 837,   0 }, -- Frostbolt (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 12051, 20, -1,    0 }, -- Evocation
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 12824, 20, 118,   0 }, -- Polymorph (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 990,   22, 597,   0 }, -- Conjure Food (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2138,  22, 2137,  0 }, -- Fire Blast (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2948,  22, -1,    0 }, -- Scorch (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6143,  22, -1,    0 }, -- Frost Ward (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8437,  22, 1449,  0 }, -- Arcane Explosion (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2121,  24, 2120,  0 }, -- Flamestrike (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2139,  24, -1,    0 }, -- Counterspell
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5145,  24, 5144,  0 }, -- Arcane Missiles (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8400,  24, 3140,  0 }, -- Fireball (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8450,  24, 604,   0 }, -- Dampen Magic (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 12505, 24, 11366, 0 }, -- Pyroblast (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 120,   26, -1,    0 }, -- Cone of Cold (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 865,   26, 122,   0 }, -- Frost Nova (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8406,  26, 7322,  0 }, -- Frostbolt (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 759,   28, -1,    0 }, -- Conjure Mana Gem (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1461,  28, 1460,  0 }, -- Arcane Intellect (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6141,  28, 10,    0 }, -- Blizzard (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8444,  28, 2948,  0 }, -- Scorch (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8494,  28, 1463,  0 }, -- Mana Shield (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6127,  30, 5506,  0 }, -- Conjure Water (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7302,  30, -1,    0 }, -- Ice Armor (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8401,  30, 8400,  0 }, -- Fireball (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8412,  30, 2138,  0 }, -- Fire Blast (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8438,  30, 8437,  0 }, -- Arcane Explosion (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8455,  30, 1008,  0 }, -- Amplify Magic (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8457,  30, 543,   0 }, -- Fire Ward (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 12522, 30, 12505, 0 }, -- Pyroblast (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 45438, 30, -1,    0 }, -- Ice Block
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6129,  32, 990,   0 }, -- Conjure Food (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8407,  32, 8406,  0 }, -- Frostbolt (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8416,  32, 5145,  0 }, -- Arcane Missiles (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8422,  32, 2121,  0 }, -- Flamestrike (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8461,  32, 6143,  0 }, -- Frost Ward (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6117,  34, -1,    0 }, -- Mage Armor (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8445,  34, 8444,  0 }, -- Scorch (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8492,  34, 120,   0 }, -- Cone of Cold (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8402,  36, 8401,  0 }, -- Fireball (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8427,  36, 6141,  0 }, -- Blizzard (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8451,  36, 8450,  0 }, -- Dampen Magic (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8495,  36, 8494,  0 }, -- Mana Shield (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 12523, 36, 12522, 0 }, -- Pyroblast (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 13018, 36, 11113, 0 }, -- Blast Wave (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3552,  38, 759,   0 }, -- Conjure Mana Gem (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8408,  38, 8407,  0 }, -- Frostbolt (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8413,  38, 8412,  0 }, -- Fire Blast (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8439,  38, 8438,  0 }, -- Arcane Explosion (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6131,  40, 865,   0 }, -- Frost Nova (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7320,  40, 7302,  0 }, -- Ice Armor (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8417,  40, 8416,  0 }, -- Arcane Missiles (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8423,  40, 8422,  0 }, -- Flamestrike (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8446,  40, 8445,  0 }, -- Scorch (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8458,  40, 8457,  0 }, -- Fire Ward (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10138, 40, 6127,  0 }, -- Conjure Water (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 12825, 40, 12824, 0 }, -- Polymorph (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8462,  42, 8461,  0 }, -- Frost Ward (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10144, 42, 6129,  0 }, -- Conjure Food (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10148, 42, 8402,  0 }, -- Fireball (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10156, 42, 1461,  0 }, -- Arcane Intellect (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10159, 42, 8492,  0 }, -- Cone of Cold (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10169, 42, 8455,  0 }, -- Amplify Magic (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 12524, 42, 12523, 0 }, -- Pyroblast (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10179, 44, 8408,  0 }, -- Frostbolt (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10185, 44, 8427,  0 }, -- Blizzard (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10191, 44, 8495,  0 }, -- Mana Shield (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 13019, 44, 13018, 0 }, -- Blast Wave (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10197, 46, 8413,  0 }, -- Fire Blast (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10201, 46, 8439,  0 }, -- Arcane Explosion (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10205, 46, 8446,  0 }, -- Scorch (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 13031, 46, 11426, 0 }, -- Ice Barrier (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 22782, 46, 6117,  0 }, -- Mage Armor (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10053, 48, 3552,  0 }, -- Conjure Mana Gem (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10149, 48, 10148, 0 }, -- Fireball (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10173, 48, 8451,  0 }, -- Dampen Magic (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10211, 48, 8417,  0 }, -- Arcane Missiles (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10215, 48, 8423,  0 }, -- Flamestrike (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 12525, 48, 12524, 0 }, -- Pyroblast (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10139, 50, 10138, 0 }, -- Conjure Water (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10160, 50, 10159, 0 }, -- Cone of Cold (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10180, 50, 10179, 0 }, -- Frostbolt (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10219, 50, 7320,  0 }, -- Ice Armor (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10223, 50, 8458,  0 }, -- Fire Ward (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10145, 52, 10144, 0 }, -- Conjure Food (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10177, 52, 8462,  0 }, -- Frost Ward (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10186, 52, 10185, 0 }, -- Blizzard (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10192, 52, 10191, 0 }, -- Mana Shield (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10206, 52, 10205, 0 }, -- Scorch (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 13020, 52, 13019, 0 }, -- Blast Wave (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 13032, 52, 13031, 0 }, -- Ice Barrier (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10150, 54, 10149, 0 }, -- Fireball (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10170, 54, 10169, 0 }, -- Amplify Magic (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10199, 54, 10197, 0 }, -- Fire Blast (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10202, 54, 10201, 0 }, -- Arcane Explosion (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10230, 54, 6131,  0 }, -- Frost Nova (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 12526, 54, 12525, 0 }, -- Pyroblast (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10157, 56, 10156, 0 }, -- Arcane Intellect (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10181, 56, 10180, 0 }, -- Frostbolt (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10212, 56, 10211, 0 }, -- Arcane Missiles (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10216, 56, 10215, 0 }, -- Flamestrike (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 23028, 56, -1,    0 }, -- Arcane Brilliance (Rank 1)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 33041, 56, 31661, 0 }, -- Dragon's Breath (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10054, 58, 10053, 0 }, -- Conjure Mana Gem (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10161, 58, 10160, 0 }, -- Cone of Cold (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10207, 58, 10206, 0 }, -- Scorch (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 13033, 58, 13032, 0 }, -- Ice Barrier (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 22783, 58, 22782, 0 }, -- Mage Armor (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10140, 60, 10139, 0 }, -- Conjure Water (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10151, 60, 10150, 0 }, -- Fireball (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10174, 60, 10173, 0 }, -- Dampen Magic (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10187, 60, 10186, 0 }, -- Blizzard (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10193, 60, 10192, 0 }, -- Mana Shield (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10220, 60, 10219, 0 }, -- Ice Armor (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 10225, 60, 10223, 0 }, -- Fire Ward (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 12826, 60, 12825, 0 }, -- Polymorph (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 13021, 60, 13020, 0 }, -- Blast Wave (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 18809, 60, 12526, 0 }, -- Pyroblast (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25304, 60, 10181, 0 }, -- Frostbolt (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25306, 60, 10151, 0 }, -- Fireball (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25345, 60, 10212, 0 }, -- Arcane Missiles (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 28609, 60, 10177, 0 }, -- Frost Ward (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 28612, 60, 10145, 0 }, -- Conjure Food (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27078, 61, 10199, 0 }, -- Fire Blast (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27080, 62, 10202, 0 }, -- Arcane Explosion (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 30482, 62, -1,    0 }, -- Molten Armor (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27071, 63, 25304, 0 }, -- Frostbolt (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27075, 63, 25345, 0 }, -- Arcane Missiles (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27130, 63, 10170, 0 }, -- Amplify Magic (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27086, 64, 10216, 0 }, -- Flamestrike (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27134, 64, 13033, 0 }, -- Ice Barrier (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 30451, 64, -1,    0 }, -- Arcane Blast (Rank 1)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 33042, 64, 33041, 0 }, -- Dragon's Breath (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27073, 65, 10207, 0 }, -- Scorch (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27087, 65, 10161, 0 }, -- Cone of Cold (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27133, 65, 13021, 0 }, -- Blast Wave (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 37420, 65, 10140, 0 }, -- Conjure Water (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27070, 66, 25306, 0 }, -- Fireball (Rank 13)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27132, 66, 18809, 0 }, -- Pyroblast (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 30455, 66, -1,    0 }, -- Ice Lance (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27088, 67, 10230, 0 }, -- Frost Nova (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 33944, 67, 10174, 0 }, -- Dampen Magic (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 66,    68, -1,    0 }, -- Invisibility
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27085, 68, 10187, 0 }, -- Blizzard (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27101, 68, 10054, 0 }, -- Conjure Mana Gem (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27131, 68, 10193, 0 }, -- Mana Shield (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27072, 69, 27071, 0 }, -- Frostbolt (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27124, 69, 10220, 0 }, -- Ice Armor (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27125, 69, 22783, 0 }, -- Mage Armor Armor 4
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27128, 69, 10225, 0 }, -- Fire Ward (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 33946, 69, 27130, 0 }, -- Amplify Magic (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 38699, 69, 27075, 0 }, -- Arcane Missiles (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27074, 70, 27073, 0 }, -- Scorch (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27079, 70, 27078, 0 }, -- Fire Blast (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27082, 70, 27080, 0 }, -- Arcane Explosion (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27090, 70, 37420, 0 }, -- Conjure Water (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27126, 70, 10157, 0 }, -- Arcane Intellect (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27127, 70, 23028, 0 }, -- Arcane Brilliance (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 30449, 70, -1,    0 }, -- Spellsteal
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 32796, 70, 28609, 0 }, -- Frost Ward (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 33043, 70, 33042, 0 }, -- Dragon's Breath (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 33405, 70, 27134, 0 }, -- Ice Barrier (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 33717, 70, 28612, 0 }, -- Conjure Food (Rank 8)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 33933, 70, 27133, 0 }, -- Blast Wave (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 33938, 70, 27132, 0 }, -- Pyroblast (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 38692, 70, 27070, 0 }, -- Fireball (Rank 14)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 38697, 70, 27072, 0 }, -- Frostbolt (Rank 14)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 38704, 70, 38699, 0 }, -- Arcane Missiles (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43987, 70, -1,    0 }, -- Ritual of Refreshment
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 44780, 70, 44425, 0 }, -- Arcane Barrage (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 55359, 70, 44457, 0 }, -- Living Bomb (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42894, 71, 30451, 0 }, -- Arcane Blast (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43023, 71, 27125, 0 }, -- Mage Armor (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43045, 71, 30482, 0 }, -- Molten Armor (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42913, 72, 30455, 0 }, -- Ice Lance (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42925, 72, 27086, 0 }, -- Flamestrike (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42930, 72, 27087, 0 }, -- Cone of Cold (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42858, 73, 27074, 0 }, -- Scorch (Rank 10)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 42890, 73, 33938, 0 }, -- Pyroblast (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43019, 73, 27131, 0 }, -- Mana Shield (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42832, 74, 38692, 0 }, -- Fireball (Rank 15)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42872, 74, 27079, 0 }, -- Fire Blast (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42939, 74, 27085, 0 }, -- Blizzard (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42841, 75, 38697, 0 }, -- Frostbolt (Rank 15)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42843, 75, 38704, 0 }, -- Arcane Missiles (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42917, 75, 27088, 0 }, -- Frost Nova (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 42944, 75, 33933, 0 }, -- Blast Wave (Rank 8)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 42949, 75, 33043, 0 }, -- Dragon's Breath (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42955, 75, -1,    0 }, -- Conjure Refreshment (Rank 1)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 43038, 75, 33405, 0 }, -- Ice Barrier (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 44614, 75, -1,    0 }, -- Frostfire Bolt (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42896, 76, 42894, 0 }, -- Arcane Blast (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42920, 76, 27082, 0 }, -- Arcane Explosion (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43015, 76, 33944, 0 }, -- Dampen Magic (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 42891, 77, 42890, 0 }, -- Pyroblast (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42985, 77, 27101, 0 }, -- Conjure Mana Gem (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43017, 77, 33946, 0 }, -- Amplify Magic (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42833, 78, 42832, 0 }, -- Fireball (Rank 16)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42859, 78, 42858, 0 }, -- Scorch (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42914, 78, 42913, 0 }, -- Ice Lance (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43010, 78, 27128, 0 }, -- Fire Ward (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42842, 79, 42841, 0 }, -- Frostbolt (Rank 16)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42846, 79, 42843, 0 }, -- Arcane Missiles (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42926, 79, 42925, 0 }, -- Flamestrike (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42931, 79, 42930, 0 }, -- Cone of Cold (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43008, 79, 27124, 0 }, -- Ice Armor (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43012, 79, 32796, 0 }, -- Frost Ward (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43020, 79, 43019, 0 }, -- Mana Shield (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43024, 79, 43023, 0 }, -- Mage Armor (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43046, 79, 43045, 0 }, -- Molten Armor (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42873, 80, 42872, 0 }, -- Fire Blast (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42897, 80, 42896, 0 }, -- Arcane Blast (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42921, 80, 42920, 0 }, -- Arcane Explosion (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42940, 80, 42939, 0 }, -- Blizzard (Rank 9)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 42945, 80, 42944, 0 }, -- Blast Wave (Rank 9)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 42950, 80, 42949, 0 }, -- Dragon's Breath (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42956, 80, 42955, 0 }, -- Conjure Refreshment (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 42995, 80, 27126, 0 }, -- Arcane Intellect (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 43002, 80, 27127, 0 }, -- Arcane Brilliance (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 43039, 80, 43038, 0 }, -- Ice Barrier (Rank 8)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 44781, 80, 44780, 0 }, -- Arcane Barrage (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47610, 80, 44614, 0 }, -- Frostfire Bolt (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 55342, 80, -1,    0 }, -- Mirror Image
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 55360, 80, 55359, 0 }, -- Living Bomb (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58659, 80, -1,    0 }}, -- Ritual of Refreshment
    -- Warlock (Id: 9)
    {{ TYPE_PROFICIENCY, RACE_UNDEFINED, 201,   0,  -1,    0 }, -- One-Handed Swords
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 227,   0,  -1,    0 }, -- Staves
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 1180,  0,  -1,    0 }, -- Daggers
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 5009,  0,  -1,    0 }, -- Wands
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 348,   1,  -1,    0 }, -- Immolate (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 686,   1,  -1,    0 }, -- Shadow Bolt (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 687,   1,  -1,    0 }, -- Demon Skin (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 688,   1,  -1,    0 }, -- Summon Imp
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 172,   4,  -1,    0 }, -- Corruption (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 702,   4,  -1,    0 }, -- Curse of Weakness (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 695,   6,  686,   0 }, -- Shadow Bolt (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1454,  6,  -1,    0 }, -- Life Tap (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 980,   8,  -1,    0 }, -- Curse of Agony (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5782,  8,  -1,    0 }, -- Fear (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 696,   10, 687,   0 }, -- Demon Skin (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 697,   10, -1,    1 }, -- Summon Voidwalker
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 707,   10, 348,   0 }, -- Immolate (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1120,  10, -1,    0 }, -- Drain Soul (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6201,  10, -1,    0 }, -- Create Healthstone (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 705,   12, 695,   0 }, -- Shadow Bolt (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 755,   12, -1,    0 }, -- Health Funnel (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1108,  12, 702,   0 }, -- Curse of Weakness (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 689,   14, -1,    0 }, -- Drain Life (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6222,  14, 172,   0 }, -- Corruption (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1455,  16, 1454,  0 }, -- Life Tap (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5697,  16, -1,    0 }, -- Unending Breath
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 693,   18, -1,    0 }, -- Create Soulstone (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1014,  18, 980,   0 }, -- Curse of Agony (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5676,  18, -1,    0 }, -- Searing Pain (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 698,   20, -1,    0 }, -- Ritual of Summoning
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 706,   20, -1,    0 }, -- Demon Armor (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 712,   20, -1,    1 }, -- Summon Succubus
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1088,  20, 705,   0 }, -- Shadow Bolt (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1094,  20, 707,   0 }, -- Immolate (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3698,  20, 755,   0 }, -- Health Funnel (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5740,  20, -1,    0 }, -- Rain of Fire (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 126,   22, -1,    0 }, -- Eye of Kilrogg
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 699,   22, 689,   0 }, -- Drain Life (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6202,  22, 6201,  0 }, -- Create Healthstone (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6205,  22, 1108,  0 }, -- Curse of Weakness (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5138,  24, -1,    0 }, -- Drain Mana
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5500,  24, -1,    0 }, -- Sense Demons
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6223,  24, 6222,  0 }, -- Corruption (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8288,  24, 1120,  0 }, -- Drain Soul (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 18867, 24, 17877, 0 }, -- Shadowburn (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 132,   26, -1,    0 }, -- Detect Invisibility
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1456,  26, 1455,  0 }, -- Life Tap (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1714,  26, -1,    0 }, -- Curse of Tongues (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17919, 26, 5676,  0 }, -- Searing Pain (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 710,   28, -1,    0 }, -- Banish (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1106,  28, 1088,  0 }, -- Shadow Bolt (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3699,  28, 3698,  0 }, -- Health Funnel (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6217,  28, 1014,  0 }, -- Curse of Agony (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6366,  28, -1,    0 }, -- Create Firestone (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 691,   30, -1,    1 }, -- Summon Felhunter
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 709,   30, 699,   0 }, -- Drain Life (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1086,  30, 706,   0 }, -- Demon Armor (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1098,  30, -1,    0 }, -- Enslave Demon (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1949,  30, -1,    0 }, -- Hellfire (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2941,  30, 1094,  0 }, -- Immolate (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20752, 30, 693,   0 }, -- Create Soulstone (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1490,  32, -1,    0 }, -- Curse of the Elements (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6213,  32, 5782,  0 }, -- Fear (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6229,  32, -1,    0 }, -- Shadow Ward (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7646,  32, 6205,  0 }, -- Curse of Weakness (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 18868, 32, 18867, 0 }, -- Shadowburn (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5699,  34, 6202,  0 }, -- Create Healthstone (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6219,  34, 5740,  0 }, -- Rain of Fire (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7648,  34, 6223,  0 }, -- Corruption (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17920, 34, 17919, 0 }, -- Searing Pain (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2362,  36, -1,    0 }, -- Create Spellstone (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3700,  36, 3699,  0 }, -- Health Funnel (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7641,  36, 1106,  0 }, -- Shadow Bolt (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11687, 36, 1456,  0 }, -- Life Tap (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17951, 36, 6366,  0 }, -- Create Firestone (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 7651,  38, 709,   0 }, -- Drain Life (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8289,  38, 8288,  0 }, -- Drain Soul (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11711, 38, 6217,  0 }, -- Curse of Agony (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5484,  40, -1,    0 }, -- Howl of Terror (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11665, 40, 2941,  0 }, -- Immolate (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11733, 40, 1086,  0 }, -- Demon Armor (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 18869, 40, 18868, 0 }, -- Shadowburn (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20755, 40, 20752, 0 }, -- Create Soulstone (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6789,  42, -1,    0 }, -- Death Coil (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11683, 42, 1949,  0 }, -- Hellfire (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11707, 42, 7646,  0 }, -- Curse of Weakness (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11739, 42, 6229,  0 }, -- Shadow Ward (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17921, 42, 17920, 0 }, -- Searing Pain (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11659, 44, 7641,  0 }, -- Shadow Bolt (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11671, 44, 7648,  0 }, -- Corruption (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11693, 44, 3700,  0 }, -- Health Funnel (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11725, 44, 1098,  0 }, -- Enslave Demon (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11677, 46, 6219,  0 }, -- Rain of Fire (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11688, 46, 11687, 0 }, -- Life Tap (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11699, 46, 7651,  0 }, -- Drain Life (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11721, 46, 1490,  0 }, -- Curse of the Elements (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11729, 46, 5699,  0 }, -- Create Healthstone (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17952, 46, 17951, 0 }, -- Create Firestone (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6353,  48, -1,    0 }, -- Soul Fire (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11712, 48, 11711, 0 }, -- Curse of Agony (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17727, 48, 2362,  0 }, -- Create Spellstone (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 18647, 48, 710,   0 }, -- Banish (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 18870, 48, 18869, 0 }, -- Shadowburn (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11667, 50, 11665, 0 }, -- Immolate (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11719, 50, 1714,  0 }, -- Curse of Tongues (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11734, 50, 11733, 0 }, -- Demon Armor (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17922, 50, 17921, 0 }, -- Searing Pain (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17925, 50, 6789,  0 }, -- Death Coil (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 18937, 50, 18220, 0 }, -- Dark Pact (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20756, 50, 20755, 0 }, -- Create Soulstone (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11660, 52, 11659, 0 }, -- Shadow Bolt (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11675, 52, 8289,  0 }, -- Drain Soul (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11694, 52, 11693, 0 }, -- Health Funnel (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11708, 52, 11707, 0 }, -- Curse of Weakness (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11740, 52, 11739, 0 }, -- Shadow Ward (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11672, 54, 11671, 0 }, -- Corruption (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11684, 54, 11683, 0 }, -- Hellfire (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11700, 54, 11699, 0 }, -- Drain Life (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17928, 54, 5484,  0 }, -- Howl of Terror (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6215,  56, 6213,  0 }, -- Fear (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11689, 56, 11688, 0 }, -- Life Tap (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17924, 56, 6353,  0 }, -- Soul Fire (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17953, 56, 17952, 0 }, -- Create Firestone (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 18871, 56, 18870, 0 }, -- Shadowburn (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11678, 58, 11677, 0 }, -- Rain of Fire (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11713, 58, 11712, 0 }, -- Curse of Agony (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11726, 58, 11725, 0 }, -- Enslave Demon (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11730, 58, 11729, 0 }, -- Create Healthstone (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17923, 58, 17922, 0 }, -- Searing Pain (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17926, 58, 17925, 0 }, -- Death Coil (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 603,   60, -1,    0 }, -- Curse of Doom (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11661, 60, 11660, 0 }, -- Shadow Bolt (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11668, 60, 11667, 0 }, -- Immolate (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11695, 60, 11694, 0 }, -- Health Funnel (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11722, 60, 11721, 0 }, -- Curse of the Elements (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 11735, 60, 11734, 0 }, -- Demon Armor (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17728, 60, 17727, 0 }, -- Create Spellstone (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 18938, 60, 18937, 0 }, -- Dark Pact (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20757, 60, 20756, 0 }, -- Create Soulstone (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25307, 60, 11661, 0 }, -- Shadow Bolt (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25309, 60, 11668, 0 }, -- Immolate (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25311, 60, 11672, 0 }, -- Corruption (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 28610, 60, 11740, 0 }, -- Shadow Ward (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 30404, 60, 30108, 0 }, -- Unstable Affliction (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 30413, 60, 30283, 0 }, -- Shadowfury (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27224, 61, 11708, 0 }, -- Curse of Weakness (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27219, 62, 11700, 0 }, -- Drain Life (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 28176, 62, -1,    0 }, -- Fel Armor (Rank 1)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27263, 63, 18871, 0 }, -- Shadowburn (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27211, 64, 17924, 0 }, -- Soul Fire (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 29722, 64, -1,    0 }, -- Incinerate (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27210, 65, 17923, 0 }, -- Searing Pain (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27216, 65, 25311, 0 }, -- Corruption (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27250, 66, 17953, 0 }, -- Create Firestone (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 28172, 66, 17728, 0 }, -- Create Spellstone (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 29858, 66, -1,    0 }, -- Soulshatter
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27217, 67, 11675, 0 }, -- Drain Soul (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27218, 67, 11713, 0 }, -- Curse of Agony (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27259, 67, 11695, 0 }, -- Health Funnel (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27213, 68, 11684, 0 }, -- Hellfire (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27222, 68, 11689, 0 }, -- Life Tap (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27223, 68, 17926, 0 }, -- Death Coil (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27230, 68, 11730, 0 }, -- Create Healthstone (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 29893, 68, -1,    0 }, -- Ritual of Souls (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27209, 69, 25307, 0 }, -- Shadow Bolt (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27212, 69, 11678, 0 }, -- Rain of Fire (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27215, 69, 25309, 0 }, -- Immolate (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27220, 69, 27219, 0 }, -- Drain Life (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27228, 69, 11722, 0 }, -- Curse of the Elements (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 28189, 69, 28176, 0 }, -- Fel Armor (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 30909, 69, 27224, 0 }, -- Curse of Weakness (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27238, 70, 20757, 0 }, -- Create Soulstone (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27243, 70, -1,    0 }, -- Seed of Corruption (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27260, 70, 11735, 0 }, -- Demon Armor (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27265, 70, 18938, 0 }, -- Dark Pact (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 30405, 70, 30404, 0 }, -- Unstable Affliction (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 30414, 70, 30413, 0 }, -- Shadowfury (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 30459, 70, 27210, 0 }, -- Searing Pain (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 30545, 70, 27211, 0 }, -- Soul Fire (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 30546, 70, 27263, 0 }, -- Shadowburn (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 30910, 70, 603,   0 }, -- Curse of Doom (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 32231, 70, 29722, 0 }, -- Incinerate (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 59161, 70, 48181, 0 }, -- Haunt (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 59170, 70, 50796, 0 }, -- Chaos Bolt (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47812, 71, 27216, 0 }, -- Corruption (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50511, 71, 30909, 0 }, -- Curse of Weakness (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47819, 72, 27212, 0 }, -- Rain of Fire (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47886, 72, 28172, 0 }, -- Create Spellstone (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47890, 72, 28610, 0 }, -- Shadow Ward (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 61191, 72, 11726, 0 }, -- Enslave Demon (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47859, 73, 27223, 0 }, -- Death Coil (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47863, 73, 27218, 0 }, -- Curse of Agony (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47871, 73, 27230, 0 }, -- Create Healthstone (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47808, 74, 27209, 0 }, -- Shadow Bolt (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47814, 74, 30459, 0 }, -- Searing Pain (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47837, 74, 32231, 0 }, -- Incinerate (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47892, 74, 28189, 0 }, -- Fel Armor (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 60219, 74, 27250, 0 }, -- Create Firestone (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47810, 75, 27215, 0 }, -- Immolate (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47824, 75, 30545, 0 }, -- Soul Fire (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 47826, 75, 30546, 0 }, -- Shadowburn (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47835, 75, 27243, 0 }, -- Seed of Corruption (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 47841, 75, 30405, 0 }, -- Unstable Affliction (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 47846, 75, 30414, 0 }, -- Shadowfury (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47897, 75, -1,    0 }, -- Shadowflame (Rank 1)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 59163, 75, 59161, 0 }, -- Haunt (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 59171, 75, 59170, 0 }, -- Chaos Bolt (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47793, 76, 27260, 0 }, -- Demon Armor (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47856, 76, 27259, 0 }, -- Health Funnel (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47884, 76, 27238, 0 }, -- Create Soulstone (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47813, 77, 47812, 0 }, -- Corruption (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47855, 77, 27217, 0 }, -- Drain Soul (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47823, 78, 27213, 0 }, -- Hellfire (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47857, 78, 27220, 0 }, -- Drain Life (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47860, 78, 47859, 0 }, -- Death Coil (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47865, 78, 27228, 0 }, -- Curse of the Elements (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47888, 78, 47886, 0 }, -- Create Spellstone (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47891, 78, 47890, 0 }, -- Shadow Ward (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47809, 79, 47808, 0 }, -- Shadow Bolt (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47815, 79, 47814, 0 }, -- Searing Pain (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47820, 79, 47819, 0 }, -- Rain of Fire (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47864, 79, 47863, 0 }, -- Curse of Agony (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47878, 79, 47871, 0 }, -- Create Healthstone (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47893, 79, 47892, 0 }, -- Fel Armor (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47811, 80, 47810, 0 }, -- Immolate (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47825, 80, 47824, 0 }, -- Soul Fire (Rank 6)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 47827, 80, 47826, 0 }, -- Shadowburn (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47836, 80, 47835, 0 }, -- Seed of Corruption (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47838, 80, 47837, 0 }, -- Incinerate (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 47843, 80, 47841, 0 }, -- Unstable Affliction (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 47847, 80, 47846, 0 }, -- Shadowfury (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47867, 80, 30910, 0 }, -- Curse of Doom (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 47889, 80, 47793, 0 }, -- Demon Armor (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48018, 80, -1,    0 }, -- Demonic Circle: Summon
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48020, 80, -1,    0 }, -- Demonic Circle: Teleport
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 57946, 80, 27222, 0 }, -- Life Tap (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 58887, 80, 29893, 0 }, -- Ritual of Souls (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 59092, 80, 27265, 0 }, -- Dark Pact (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 59164, 80, 59163, 0 }, -- Haunt (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 59172, 80, 59171, 0 }, -- Chaos Bolt (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 60220, 80, 60219, 0 }, -- Create Firestone (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 61290, 80, 47897, 0 }}, -- Shadowflame (Rank 2)
    -- Unused (Id: 10)
    {{}},
    -- Druid (Id: 11)
    {{ TYPE_PROFICIENCY, RACE_UNDEFINED, 198,   0,  -1,    0 }, -- One-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 199,   0,  -1,    0 }, -- Two-Handed Maces
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 200,   0,  -1,    0 }, -- Polearms
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 227,   0,  -1,    0 }, -- Staves
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 1180,  0,  -1,    0 }, -- Daggers
    { TYPE_PROFICIENCY,  RACE_UNDEFINED, 15590, 0,  -1,    0 }, -- Fist Weapons
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1126,  1,  -1,    0 }, -- Mark of the Wild (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5176,  1,  -1,    0 }, -- Wrath (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5185,  1,  -1,    0 }, -- Healing Touch (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 774,   4,  -1,    0 }, -- Rejuvenation (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8921,  4,  -1,    0 }, -- Moonfire (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 467,   6,  -1,    0 }, -- Thorns (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5177,  6,  5176,  0 }, -- Wrath (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 339,   8,  -1,    0 }, -- Entangling Roots (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5186,  8,  5185,  0 }, -- Healing Touch (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 99,    10, -1,    0 }, -- Demoralizing Roar (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1058,  10, 774,   0 }, -- Rejuvenation (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5232,  10, 1126,  0 }, -- Mark of the Wild (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5487,  10, -1,    1 }, -- Bear Form (Shapeshift)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6795,  10, 5487,  1 }, -- Growl
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6807,  10, 5487,  1 }, -- Maul (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8924,  10, 8921,  0 }, -- Moonfire (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16689, 10, -1,    0 }, -- Nature's Grasp (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5229,  12, -1,    0 }, -- Enrage
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8936,  12, -1,    0 }, -- Regrowth (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50769, 12, -1,    0 }, -- Revive (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 782,   14, 467,   0 }, -- Thorns (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5178,  14, 5177,  0 }, -- Wrath (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5187,  14, 5186,  0 }, -- Healing Touch (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5211,  14, -1,    0 }, -- Bash (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 779,   16, -1,    0 }, -- Swipe (Bear) (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 783,   16, -1,    0 }, -- Travel Form (Shapeshift)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1066,  16, -1,    0 }, -- Aquatic Form (Shapeshift)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1430,  16, 1058,  0 }, -- Rejuvenation (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8925,  16, 8924,  0 }, -- Moonfire (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 770,   18, -1,    0 }, -- Faerie Fire
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1062,  18, 339,   0 }, -- Entangling Roots (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2637,  18, -1,    0 }, -- Hibernate (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6808,  18, 6807,  0 }, -- Maul (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8938,  18, 8936,  0 }, -- Regrowth (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16810, 18, 16689, 0 }, -- Nature's Grasp (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16857, 18, -1,    0 }, -- Faerie Fire (Feral)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 768,   20, -1,    0 }, -- Cat Form (Shapeshift)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1079,  20, -1,    0 }, -- Rip (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1082,  20, -1,    0 }, -- Claw (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1735,  20, 99,    0 }, -- Demoralizing Roar (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2912,  20, -1,    0 }, -- Starfire (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5188,  20, 5187,  0 }, -- Healing Touch (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5215,  20, -1,    0 }, -- Prowl
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6756,  20, 5232,  0 }, -- Mark of the Wild (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20484, 20, -1,    0 }, -- Rebirth (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2090,  22, 1430,  0 }, -- Rejuvenation (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2908,  22, -1,    0 }, -- Soothe Animal (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5179,  22, 5178,  0 }, -- Wrath (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5221,  22, -1,    0 }, -- Shred (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8926,  22, 8925,  0 }, -- Moonfire (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 780,   24, 779,   0 }, -- Swipe (Bear) (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1075,  24, 782,   0 }, -- Thorns (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1822,  24, -1,    0 }, -- Rake (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2782,  24, -1,    0 }, -- Remove Curse
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5217,  24, -1,    0 }, -- Tiger's Fury (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8939,  24, 8938,  0 }, -- Regrowth (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50768, 24, 50769, 0 }, -- Revive (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1850,  26, -1,    0 }, -- Dash (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2893,  26, -1,    0 }, -- Abolish Poison
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5189,  26, 5188,  0 }, -- Healing Touch (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6809,  26, 6808,  0 }, -- Maul (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8949,  26, 2912,  0 }, -- Starfire (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 2091,  28, 2090,  0 }, -- Rejuvenation (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3029,  28, 1082,  0 }, -- Claw (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5195,  28, 1062,  0 }, -- Entangling Roots (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5209,  28, -1,    0 }, -- Challenging Roar
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8927,  28, 8926,  0 }, -- Moonfire (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8998,  28, -1,    0 }, -- Cower (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9492,  28, 1079,  0 }, -- Rip (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16811, 28, 16810, 0 }, -- Nature's Grasp (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 740,   30, -1,    0 }, -- Tranquility (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5180,  30, 5179,  0 }, -- Wrath (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5234,  30, 6756,  0 }, -- Mark of the Wild (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6798,  30, 5211,  0 }, -- Bash (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6800,  30, 5221,  0 }, -- Shred (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8940,  30, 8939,  0 }, -- Regrowth (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20739, 30, 20484, 0 }, -- Rebirth (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 24974, 30, 5570,  0 }, -- Insect Swarm (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5225,  32, -1,    0 }, -- Track Humanoids
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6778,  32, 5189,  0 }, -- Healing Touch (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6785,  32, -1,    0 }, -- Ravage (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9490,  32, 1735,  0 }, -- Demoralizing Roar (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 22568, 32, -1,    0 }, -- Ferocious Bite (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 769,   34, 780,   0 }, -- Swipe (Bear) (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1823,  34, 1822,  0 }, -- Rake (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 3627,  34, 2091,  0 }, -- Rejuvenation (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8914,  34, 1075,  0 }, -- Thorns (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8928,  34, 8927,  0 }, -- Moonfire (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8950,  34, 8949,  0 }, -- Starfire (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8972,  34, 6809,  0 }, -- Maul (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6793,  36, 5217,  0 }, -- Tiger's Fury (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8941,  36, 8940,  0 }, -- Regrowth (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9005,  36, -1,    0 }, -- Pounce (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9493,  36, 9492,  0 }, -- Rip (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 22842, 36, -1,    0 }, -- Frenzied Regeneration
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50767, 36, 50768, 0 }, -- Revive (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5196,  38, 5195,  0 }, -- Entangling Roots (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 5201,  38, 3029,  0 }, -- Claw (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6780,  38, 5180,  0 }, -- Wrath (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8903,  38, 6778,  0 }, -- Healing Touch (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8955,  38, 2908,  0 }, -- Soothe Animal (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8992,  38, 6800,  0 }, -- Shred (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16812, 38, 16811, 0 }, -- Nature's Grasp (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 18657, 38, 2637,  0 }, -- Hibernate (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8907,  40, 5234,  0 }, -- Mark of the Wild (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8910,  40, 3627,  0 }, -- Rejuvenation (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8918,  40, 740,   0 }, -- Tranquility (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8929,  40, 8928,  0 }, -- Moonfire (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9000,  40, 8998,  0 }, -- Cower (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9634,  40, -1,    0 }, -- Dire Bear Form (Shapeshift)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16914, 40, -1,    0 }, -- Hurricane (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20719, 40, -1,    0 }, -- Feline Grace (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20742, 40, 20739, 0 }, -- Rebirth (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 22827, 40, 22568, 0 }, -- Ferocious Bite (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 24975, 40, 24974, 0 }, -- Insect Swarm (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 29166, 40, -1,    0 }, -- Innervate
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 62600, 40, -1,    0 }, -- Savage Defense (Passive)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 6787,  42, 6785,  0 }, -- Ravage (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8951,  42, 8950,  0 }, -- Starfire (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9745,  42, 8972,  0 }, -- Maul (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9747,  42, 9490,  0 }, -- Demoralizing Roar (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9750,  42, 8941,  0 }, -- Regrowth (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 1824,  44, 1823,  0 }, -- Rake (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9752,  44, 9493,  0 }, -- Rip (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9754,  44, 769,   0 }, -- Swipe (Bear) (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9756,  44, 8914,  0 }, -- Thorns (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9758,  44, 8903,  0 }, -- Healing Touch (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 22812, 44, -1,    0 }, -- Barkskin
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8905,  46, 6780,  0 }, -- Wrath (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 8983,  46, 6798,  0 }, -- Bash (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9821,  46, 1850,  0 }, -- Dash (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9823,  46, 9005,  0 }, -- Pounce (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9829,  46, 8992,  0 }, -- Shred (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9833,  46, 8929,  0 }, -- Moonfire (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9839,  46, 8910,  0 }, -- Rejuvenation (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9845,  48, 6793,  0 }, -- Tiger's Fury (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9849,  48, 5201,  0 }, -- Claw (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9852,  48, 5196,  0 }, -- Entangling Roots (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9856,  48, 9750,  0 }, -- Regrowth (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 16813, 48, 16812, 0 }, -- Nature's Grasp (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 22828, 48, 22827, 0 }, -- Ferocious Bite (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50766, 48, 50767, 0 }, -- Revive (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9862,  50, 8918,  0 }, -- Tranquility (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9866,  50, 6787,  0 }, -- Ravage (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9875,  50, 8951,  0 }, -- Starfire (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9880,  50, 9745,  0 }, -- Maul (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9884,  50, 8907,  0 }, -- Mark of the Wild (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9888,  50, 9758,  0 }, -- Healing Touch (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17401, 50, 16914, 0 }, -- Hurricane (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20747, 50, 20742, 0 }, -- Rebirth (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 21849, 50, -1,    0 }, -- Gift of the Wild (Rank 1)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 24976, 50, 24975, 0 }, -- Insect Swarm (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9834,  52, 9833,  0 }, -- Moonfire (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9840,  52, 9839,  0 }, -- Rejuvenation (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9892,  52, 9000,  0 }, -- Cower (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9894,  52, 9752,  0 }, -- Rip (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9898,  52, 9747,  0 }, -- Demoralizing Roar (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9830,  54, 9829,  0 }, -- Shred (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9857,  54, 9856,  0 }, -- Regrowth (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9901,  54, 8955,  0 }, -- Soothe Animal (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9904,  54, 1824,  0 }, -- Rake (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9908,  54, 9754,  0 }, -- Swipe (Bear) (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9910,  54, 9756,  0 }, -- Thorns (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9912,  54, 8905,  0 }, -- Wrath (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9827,  56, 9823,  0 }, -- Pounce (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9889,  56, 9888,  0 }, -- Healing Touch (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 22829, 56, 22828, 0 }, -- Ferocious Bite (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9835,  58, 9834,  0 }, -- Moonfire (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9841,  58, 9840,  0 }, -- Rejuvenation (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9850,  58, 9849,  0 }, -- Claw (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9853,  58, 9852,  0 }, -- Entangling Roots (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9867,  58, 9866,  0 }, -- Ravage (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9876,  58, 9875,  0 }, -- Starfire (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9881,  58, 9880,  0 }, -- Maul (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17329, 58, 16813, 0 }, -- Nature's Grasp (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 18658, 58, 18657, 0 }, -- Hibernate (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 33982, 58, 33876, 0 }, -- Mangle (Cat) (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 33986, 58, 33878, 0 }, -- Mangle (Bear) (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9846,  60, 9845,  0 }, -- Tiger's Fury (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9858,  60, 9857,  0 }, -- Regrowth (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9863,  60, 9862,  0 }, -- Tranquility (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9885,  60, 9884,  0 }, -- Mark of the Wild (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 9896,  60, 9894,  0 }, -- Rip (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 17402, 60, 17401, 0 }, -- Hurricane (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 20748, 60, 20747, 0 }, -- Rebirth (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 21850, 60, 21849, 0 }, -- Gift of the Wild (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 24977, 60, 24976, 0 }, -- Insect Swarm (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25297, 60, 9889,  0 }, -- Healing Touch (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25298, 60, 9876,  0 }, -- Starfire (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 25299, 60, 9841,  0 }, -- Rejuvenation (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 31018, 60, 22829, 0 }, -- Ferocious Bite (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 31709, 60, 9892,  0 }, -- Cower (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 33943, 60, 34090, 0 }, -- Flight Form (Shapeshift)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50765, 60, 50766, 0 }, -- Revive (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53223, 60, 50516, 0 }, -- Typhoon (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26984, 61, 9912,  0 }, -- Wrath (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27001, 61, 9830,  0 }, -- Shred (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 22570, 62, -1,    0 }, -- Maim (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26978, 62, 25297, 0 }, -- Healing Touch (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26998, 62, 9898,  0 }, -- Demoralizing Roar (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 24248, 63, 31018, 0 }, -- Ferocious Bite (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26981, 63, 25299, 0 }, -- Rejuvenation (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26987, 63, 9835,  0 }, -- Moonfire (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26992, 64, 9910,  0 }, -- Thorns (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26997, 64, 9908,  0 }, -- Swipe (Bear) (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27003, 64, 9904,  0 }, -- Rake (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 33763, 64, -1,    0 }, -- Lifebloom (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26980, 65, 9858,  0 }, -- Regrowth (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 33357, 65, 9821,  0 }, -- Dash (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27005, 66, 9867,  0 }, -- Ravage (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27006, 66, 9827,  0 }, -- Pounce (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 33745, 66, -1,    0 }, -- Lacerate (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26986, 67, 25298, 0 }, -- Starfire (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26996, 67, 9881,  0 }, -- Maul (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27000, 67, 9850,  0 }, -- Claw (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27008, 67, 9896,  0 }, -- Rip (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26989, 68, 9853,  0 }, -- Entangling Roots (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27009, 68, 17329, 0 }, -- Nature's Grasp (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 33983, 68, 33982, 0 }, -- Mangle (Cat) (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 33987, 68, 33986, 0 }, -- Mangle (Bear) (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26979, 69, 26978, 0 }, -- Healing Touch (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26982, 69, 26981, 0 }, -- Rejuvenation (Rank 13)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26985, 69, 26984, 0 }, -- Wrath (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26994, 69, 20748, 0 }, -- Rebirth (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27004, 69, 31709, 0 }, -- Cower (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50764, 69, 50765, 0 }, -- Revive (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26983, 70, 9863,  0 }, -- Tranquility (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26988, 70, 26987, 0 }, -- Moonfire (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26990, 70, 9885,  0 }, -- Mark of the Wild (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26991, 70, 21850, 0 }, -- Gift of the Wild (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 26995, 70, 9901,  0 }, -- Soothe Animal (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27002, 70, 27001, 0 }, -- Shred (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 27012, 70, 17402, 0 }, -- Hurricane (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 27013, 70, 24977, 0 }, -- Insect Swarm (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 33786, 70, -1,    0 }, -- Cyclone
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 40120, 70, 34091, 0 }, -- Swift Flight Form (Shapeshift)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53199, 70, 48505, 0 }, -- Starfall (Rank 2)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53225, 70, 53223, 0 }, -- Typhoon (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53248, 70, 48438, 0 }, -- Wild Growth (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48442, 71, 26980, 0 }, -- Regrowth (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48559, 71, 26998, 0 }, -- Demoralizing Roar (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49799, 71, 27008, 0 }, -- Rip (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50212, 71, 9846,  0 }, -- Tiger's Fury (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 62078, 71, -1,    0 }, -- Swipe (Cat) (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48450, 72, 33763, 0 }, -- Lifebloom (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48464, 72, 26986, 0 }, -- Starfire (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48561, 72, 26997, 0 }, -- Swipe (Bear) (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48573, 72, 27003, 0 }, -- Rake (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48576, 72, 24248, 0 }, -- Ferocious Bite (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48479, 73, 26996, 0 }, -- Maul (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48567, 73, 33745, 0 }, -- Lacerate (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48569, 73, 27000, 0 }, -- Claw (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48578, 73, 27005, 0 }, -- Ravage (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48377, 74, 26979, 0 }, -- Healing Touch (Rank 14)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48459, 74, 26985, 0 }, -- Wrath (Rank 11)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49802, 74, 22570, 0 }, -- Maim (Rank 2)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53307, 74, 26992, 0 }, -- Thorns (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48440, 75, 26982, 0 }, -- Rejuvenation (Rank 14)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48446, 75, 26983, 0 }, -- Tranquility (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48462, 75, 26988, 0 }, -- Moonfire (Rank 13)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48563, 75, 33987, 0 }, -- Mangle (Bear) (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48565, 75, 33983, 0 }, -- Mangle (Cat) (Rank 4)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48571, 75, 27002, 0 }, -- Shred (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 52610, 75, -1,    0 }, -- Savage Roar (Rank 1)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53200, 75, 53199, 0 }, -- Starfall (Rank 3)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53226, 75, 53225, 0 }, -- Typhoon (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53249, 75, 53248, 0 }, -- Wild Growth (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48575, 76, 27004, 0 }, -- Cower (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48443, 77, 48442, 0 }, -- Regrowth (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48560, 77, 48559, 0 }, -- Demoralizing Roar (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48562, 77, 48561, 0 }, -- Swipe (Bear) (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49803, 77, 27006, 0 }, -- Pounce (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48465, 78, 48464, 0 }, -- Starfire (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48574, 78, 48573, 0 }, -- Rake (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48577, 78, 48576, 0 }, -- Ferocious Bite (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53308, 78, 26989, 0 }, -- Entangling Roots (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 53312, 78, 27009, 0 }, -- Nature's Grasp (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48378, 79, 48377, 0 }, -- Healing Touch (Rank 15)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48461, 79, 48459, 0 }, -- Wrath (Rank 12)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48477, 79, 26994, 0 }, -- Rebirth (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48480, 79, 48479, 0 }, -- Maul (Rank 10)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48570, 79, 48569, 0 }, -- Claw (Rank 8)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48579, 79, 48578, 0 }, -- Ravage (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50213, 79, 50212, 0 }, -- Tiger's Fury (Rank 6)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48441, 80, 48440, 0 }, -- Rejuvenation (Rank 15)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48447, 80, 48446, 0 }, -- Tranquility (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48451, 80, 48450, 0 }, -- Lifebloom (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48463, 80, 48462, 0 }, -- Moonfire (Rank 14)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48467, 80, 27012, 0 }, -- Hurricane (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48468, 80, 27013, 0 }, -- Insect Swarm (Rank 7)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48469, 80, 26990, 0 }, -- Mark of the Wild (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48470, 80, 26991, 0 }, -- Gift of the Wild (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48564, 80, 48563, 0 }, -- Mangle (Bear) (Rank 5)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 48566, 80, 48565, 0 }, -- Mangle (Cat) (Rank 5)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48568, 80, 48567, 0 }, -- Lacerate (Rank 3)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 48572, 80, 48571, 0 }, -- Shred (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 49800, 80, 49799, 0 }, -- Rip (Rank 9)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50464, 80, -1,    0 }, -- Nourish (Rank 1)
    { TYPE_CLASS_SPELL,  RACE_UNDEFINED, 50763, 80, 50764, 0 }, -- Revive (Rank 7)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53201, 80, 53200, 0 }, -- Starfall (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 53251, 80, 53249, 0 }, -- Wild Growth (Rank 4)
    { TYPE_TALENT_RANK,  RACE_UNDEFINED, 61384, 80, 53226, 0 }} -- Typhoon (Rank 5)
}

-- The list of all mount-specific spells
-- The order is team id, race id, class id, spell id, required level, required spell id, obtained from quest, enabled
local LIST_RIDING_SPELLS = {
    { TEAM_UNDEFINED, RACE_UNDEFINED, CLASS_UNDEFINED,    33388, 20, -1,    0, ENABLE_APPRENTICE_RIDING   }, -- Apprentice Riding
    { TEAM_ALLIANCE,  RACE_HUMAN,     CLASS_UNDEFINED,    458,   20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Brown Horse
    { TEAM_ALLIANCE,  RACE_HUMAN,     CLASS_UNDEFINED,    472,   20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Pinto
    { TEAM_HORDE,     RACE_ORC,       CLASS_UNDEFINED,    580,   20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Timber Wolf
    { TEAM_UNDEFINED, RACE_UNDEFINED, CLASS_WARLOCK,      5784,  20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Felsteed
    { TEAM_ALLIANCE,  RACE_HUMAN,     CLASS_UNDEFINED,    6648,  20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Chestnut Mare
    { TEAM_HORDE,     RACE_ORC,       CLASS_UNDEFINED,    6653,  20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Dire Wolf
    { TEAM_HORDE,     RACE_ORC,       CLASS_UNDEFINED,    6654,  20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Brown Wolf
    { TEAM_ALLIANCE,  RACE_DWARF,     CLASS_UNDEFINED,    6777,  20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Gray Ram
    { TEAM_ALLIANCE,  RACE_DWARF,     CLASS_UNDEFINED,    6898,  20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- White Ram
    { TEAM_ALLIANCE,  RACE_DWARF,     CLASS_UNDEFINED,    6899,  20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Brown Ram
    { TEAM_ALLIANCE,  RACE_NIGHT_ELF, CLASS_UNDEFINED,    8394,  20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Striped Frostsaber
    { TEAM_HORDE,     RACE_TROLL,     CLASS_UNDEFINED,    8395,  20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Emerald Raptor
    { TEAM_ALLIANCE,  RACE_NIGHT_ELF, CLASS_UNDEFINED,    10789, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Spotted Frostsaber
    { TEAM_ALLIANCE,  RACE_NIGHT_ELF, CLASS_UNDEFINED,    10793, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Striped Nightsaber
    { TEAM_HORDE,     RACE_TROLL,     CLASS_UNDEFINED,    10796, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Turquoise Raptor
    { TEAM_HORDE,     RACE_TROLL,     CLASS_UNDEFINED,    10799, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Violet Raptor
    { TEAM_ALLIANCE,  RACE_GNOME,     CLASS_UNDEFINED,    10873, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Red Mechanostrider
    { TEAM_ALLIANCE,  RACE_GNOME,     CLASS_UNDEFINED,    10969, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Blue Mechanostrider
    { TEAM_HORDE,     RACE_BLOOD_ELF, CLASS_PALADIN,      13819, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Warhorse
    { TEAM_ALLIANCE,  RACE_GNOME,     CLASS_UNDEFINED,    17453, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Green Mechanostrider
    { TEAM_ALLIANCE,  RACE_GNOME,     CLASS_UNDEFINED,    17454, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Unpainted Mechanostrider
    { TEAM_HORDE,     RACE_UNDEAD,    CLASS_UNDEFINED,    17462, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Red Skeletal Horse
    { TEAM_HORDE,     RACE_UNDEAD,    CLASS_UNDEFINED,    17463, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Blue Skeletal Horse
    { TEAM_HORDE,     RACE_UNDEAD,    CLASS_UNDEFINED,    17464, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Brown Skeletal Horse
    { TEAM_HORDE,     RACE_TAUREN,    CLASS_UNDEFINED,    18989, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Gray Kodo
    { TEAM_HORDE,     RACE_TAUREN,    CLASS_UNDEFINED,    18990, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Brown Kodo
    { TEAM_ALLIANCE,  RACE_DRAENEI,   CLASS_UNDEFINED,    34406, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Brown Elekk
    { TEAM_ALLIANCE,  RACE_DRAENEI,   CLASS_PALADIN,      34769, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Summon Warhorse
    { TEAM_ALLIANCE,  RACE_HUMAN,     CLASS_PALADIN,      34769, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Summon Warhorse
    { TEAM_ALLIANCE,  RACE_DWARF,     CLASS_PALADIN,      34769, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Summon Warhorse
    { TEAM_HORDE,     RACE_BLOOD_ELF, CLASS_UNDEFINED,    34795, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Red Hawkstrider
    { TEAM_HORDE,     RACE_BLOOD_ELF, CLASS_UNDEFINED,    35018, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Purple Hawkstrider
    { TEAM_HORDE,     RACE_BLOOD_ELF, CLASS_UNDEFINED,    35020, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Blue Hawkstrider
    { TEAM_HORDE,     RACE_BLOOD_ELF, CLASS_UNDEFINED,    35022, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Black Hawkstrider
    { TEAM_ALLIANCE,  RACE_DRAENEI,   CLASS_UNDEFINED,    35710, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Gray Elekk
    { TEAM_ALLIANCE,  RACE_DRAENEI,   CLASS_UNDEFINED,    35711, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Purple Elekk
    { TEAM_HORDE,     RACE_TAUREN,    CLASS_UNDEFINED,    64657, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- White Kodo
    { TEAM_HORDE,     RACE_ORC,       CLASS_UNDEFINED,    64658, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Black Wolf
    { TEAM_HORDE,     RACE_UNDEAD,    CLASS_UNDEFINED,    64977, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Black Skeletal Horse
    { TEAM_ALLIANCE,  RACE_NIGHT_ELF, CLASS_UNDEFINED,    66847, 20, 33388, 0, ENABLE_APPRENTICE_RIDING   }, -- Striped Dawnsaber
    { TEAM_UNDEFINED, RACE_UNDEFINED, CLASS_UNDEFINED,    33391, 40, 33388, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Journeyman Riding
    { TEAM_HORDE,     RACE_UNDEAD,    CLASS_UNDEFINED,    17465, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Green Skeletal Warhorse
    { TEAM_UNDEFINED, RACE_UNDEFINED, CLASS_WARLOCK,      23161, 40, 33391, 1, ENABLE_JOURNEYMAN_RIDING   }, -- Dreadsteed
    { TEAM_ALLIANCE,  RACE_HUMAN,     CLASS_PALADIN,      23214, 40, 33391, 1, ENABLE_JOURNEYMAN_RIDING   }, -- Summon Charger
    { TEAM_ALLIANCE,  RACE_DWARF,     CLASS_PALADIN,      23214, 40, 33391, 1, ENABLE_JOURNEYMAN_RIDING   }, -- Summon Charger
    { TEAM_ALLIANCE,  RACE_DRAENEI,   CLASS_PALADIN,      23214, 40, 33391, 1, ENABLE_JOURNEYMAN_RIDING   }, -- Summon Charger
    { TEAM_ALLIANCE,  RACE_NIGHT_ELF, CLASS_UNDEFINED,    23219, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Mistsaber
    { TEAM_ALLIANCE,  RACE_NIGHT_ELF, CLASS_UNDEFINED,    23221, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Frostsaber
    { TEAM_ALLIANCE,  RACE_GNOME,     CLASS_UNDEFINED,    23222, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Yellow Mechanostrider
    { TEAM_ALLIANCE,  RACE_GNOME,     CLASS_UNDEFINED,    23223, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift White Mechanostrider
    { TEAM_ALLIANCE,  RACE_GNOME,     CLASS_UNDEFINED,    23225, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Green Mechanostrider
    { TEAM_ALLIANCE,  RACE_HUMAN,     CLASS_UNDEFINED,    23227, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Palomino
    { TEAM_ALLIANCE,  RACE_HUMAN,     CLASS_UNDEFINED,    23228, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift White Steed
    { TEAM_ALLIANCE,  RACE_HUMAN,     CLASS_UNDEFINED,    23229, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Brown Steed
    { TEAM_ALLIANCE,  RACE_DWARF,     CLASS_UNDEFINED,    23238, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Brown Ram
    { TEAM_ALLIANCE,  RACE_DWARF,     CLASS_UNDEFINED,    23239, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Gray Ram
    { TEAM_ALLIANCE,  RACE_DWARF,     CLASS_UNDEFINED,    23240, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift White Ram
    { TEAM_HORDE,     RACE_TROLL,     CLASS_UNDEFINED,    23241, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Blue Raptor
    { TEAM_HORDE,     RACE_TROLL,     CLASS_UNDEFINED,    23242, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Olive Raptor
    { TEAM_HORDE,     RACE_TROLL,     CLASS_UNDEFINED,    23243, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Orange Raptor
    { TEAM_HORDE,     RACE_UNDEAD,    CLASS_UNDEFINED,    23246, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Purple Skeletal Warhorse
    { TEAM_HORDE,     RACE_TAUREN,    CLASS_UNDEFINED,    23247, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Great White Kodo
    { TEAM_HORDE,     RACE_TAUREN,    CLASS_UNDEFINED,    23248, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Great Gray Kodo
    { TEAM_HORDE,     RACE_TAUREN,    CLASS_UNDEFINED,    23249, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Great Brown Kodo
    { TEAM_HORDE,     RACE_ORC,       CLASS_UNDEFINED,    23250, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Brown Wolf
    { TEAM_HORDE,     RACE_ORC,       CLASS_UNDEFINED,    23251, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Timber Wolf
    { TEAM_HORDE,     RACE_ORC,       CLASS_UNDEFINED,    23252, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Gray Wolf
    { TEAM_ALLIANCE,  RACE_NIGHT_ELF, CLASS_UNDEFINED,    23338, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Stormsaber
    { TEAM_HORDE,     RACE_BLOOD_ELF, CLASS_UNDEFINED,    33660, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Pink Hawkstrider
    { TEAM_HORDE,     RACE_BLOOD_ELF, CLASS_PALADIN,      34767, 40, 33391, 1, ENABLE_JOURNEYMAN_RIDING   }, -- Charger
    { TEAM_HORDE,     RACE_BLOOD_ELF, CLASS_UNDEFINED,    35025, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Green Hawkstrider
    { TEAM_HORDE,     RACE_BLOOD_ELF, CLASS_UNDEFINED,    35027, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Swift Purple Hawkstrider
    { TEAM_ALLIANCE,  RACE_DRAENEI,   CLASS_UNDEFINED,    35712, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Great Green Elekk
    { TEAM_ALLIANCE,  RACE_DRAENEI,   CLASS_UNDEFINED,    35713, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Great Blue Elekk
    { TEAM_ALLIANCE,  RACE_DRAENEI,   CLASS_UNDEFINED,    35714, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Great Purple Elekk
    { TEAM_HORDE,     RACE_UNDEAD,    CLASS_UNDEFINED,    66846, 40, 33391, 0, ENABLE_JOURNEYMAN_RIDING   }, -- Ochre Skeletal Warhorse
    { TEAM_UNDEFINED, RACE_UNDEFINED, CLASS_UNDEFINED,    34090, 60, 33391, 0, ENABLE_EXPERT_RIDING       }, -- Expert Riding
    { TEAM_ALLIANCE,  RACE_UNDEFINED, CLASS_UNDEFINED,    32235, 60, 34090, 0, ENABLE_EXPERT_RIDING       }, -- Golden Gryphon
    { TEAM_ALLIANCE,  RACE_UNDEFINED, CLASS_UNDEFINED,    32239, 60, 34090, 0, ENABLE_EXPERT_RIDING       }, -- Ebon Gryphon
    { TEAM_ALLIANCE,  RACE_UNDEFINED, CLASS_UNDEFINED,    32240, 60, 34090, 0, ENABLE_EXPERT_RIDING       }, -- Snowy Gryphon
    { TEAM_HORDE,     RACE_UNDEFINED, CLASS_UNDEFINED,    32243, 60, 34090, 0, ENABLE_EXPERT_RIDING       }, -- Tawny Wind Rider
    { TEAM_HORDE,     RACE_UNDEFINED, CLASS_UNDEFINED,    32244, 60, 34090, 0, ENABLE_EXPERT_RIDING       }, -- Blue Wind Rider
    { TEAM_HORDE,     RACE_UNDEFINED, CLASS_UNDEFINED,    32245, 60, 34090, 0, ENABLE_EXPERT_RIDING       }, -- Green Wind Rider
    { TEAM_UNDEFINED, RACE_UNDEFINED, CLASS_DEATH_KNIGHT, 48778, 60, 33391, 0, ENABLE_EXPERT_RIDING       }, -- Acherus Deathcharger
    { TEAM_UNDEFINED, RACE_UNDEFINED, CLASS_UNDEFINED,    34091, 70, 34090, 0, ENABLE_ARTISAN_RIDING      }, -- Artisan Riding
    { TEAM_ALLIANCE,  RACE_UNDEFINED, CLASS_UNDEFINED,    32242, 70, 34091, 0, ENABLE_ARTISAN_RIDING      }, -- Swift Blue Gryphon
    { TEAM_HORDE,     RACE_UNDEFINED, CLASS_UNDEFINED,    32246, 70, 34091, 0, ENABLE_ARTISAN_RIDING      }, -- Swift Red Wind Rider
    { TEAM_ALLIANCE,  RACE_UNDEFINED, CLASS_UNDEFINED,    32289, 70, 34091, 0, ENABLE_ARTISAN_RIDING      }, -- Swift Red Gryphon
    { TEAM_ALLIANCE,  RACE_UNDEFINED, CLASS_UNDEFINED,    32290, 70, 34091, 0, ENABLE_ARTISAN_RIDING      }, -- Swift Green Gryphon
    { TEAM_ALLIANCE,  RACE_UNDEFINED, CLASS_UNDEFINED,    32292, 70, 34091, 0, ENABLE_ARTISAN_RIDING      }, -- Swift Purple Gryphon
    { TEAM_HORDE,     RACE_UNDEFINED, CLASS_UNDEFINED,    32295, 70, 34091, 0, ENABLE_ARTISAN_RIDING      }, -- Swift Green Wind Rider
    { TEAM_HORDE,     RACE_UNDEFINED, CLASS_UNDEFINED,    32296, 70, 34091, 0, ENABLE_ARTISAN_RIDING      }, -- Swift Yellow Wind Rider
    { TEAM_HORDE,     RACE_UNDEFINED, CLASS_UNDEFINED,    32297, 70, 34091, 0, ENABLE_ARTISAN_RIDING      }, -- Swift Purple Wind Rider
    { TEAM_UNDEFINED, RACE_UNDEFINED, CLASS_UNDEFINED,    54197, 77, 34090, 0, ENABLE_COLD_WEATHER_FLYING } -- Cold Weather Flying (Passive)
}

-- The list of all shaman totems
-- The order is item id, required level
local LIST_SHAMAN_TOTEMS = {
    { 5175, 4  }, -- Earth Totem
    { 5176, 10 }, -- Fire Totem
    { 5177, 20 }, -- Water totem
    { 5178, 30 } -- Air Totem
}

-- Triggers to teach the player all available, and enabled, spells
function learnClassSpells(player)
    -- Get a total count of the spells for the players class
    local count = 0
    for _ in pairs(LIST_CLASS_SPELLS[player:GetClass()]) do count = count + 1 end

    -- Loop through each row of spells
    for i=1,count do
        -- Check if the type is enabled
        if ((LIST_CLASS_SPELLS[player:GetClass()][i][1] == TYPE_CLASS_SPELL and ENABLE_CLASS_SPELLS) or 
            (LIST_CLASS_SPELLS[player:GetClass()][i][1] == TYPE_TALENT_RANK and ENABLE_TALENT_RANKS) or 
            (LIST_CLASS_SPELLS[player:GetClass()][i][1] == TYPE_PROFICIENCY and ENABLE_PROFICIENCIES)) then
            -- Check all requirements for the spell
            if ((LIST_CLASS_SPELLS[player:GetClass()][i][4] <= player:GetLevel()) and 
                (LIST_CLASS_SPELLS[player:GetClass()][i][6] == 0 or (LIST_CLASS_SPELLS[player:GetClass()][i][6] == 1 and ENABLE_SPELLS_FROM_QUESTS)) and 
                (LIST_CLASS_SPELLS[player:GetClass()][i][2] == RACE_UNDEFINED or LIST_CLASS_SPELLS[player:GetClass()][i][2] == player:GetRace()) and 
                (LIST_CLASS_SPELLS[player:GetClass()][i][5] == -1 or (LIST_CLASS_SPELLS[player:GetClass()][i][5] > 0 and player:HasSpell(LIST_CLASS_SPELLS[player:GetClass()][i][5])))) then
                -- Check if the player already has the spell
                if not (player:HasSpell(LIST_CLASS_SPELLS[player:GetClass()][i][3])) then
                    -- Teach the player the spell
                    player:LearnSpell(LIST_CLASS_SPELLS[player:GetClass()][i][3])
                end
            end
        end
    end
end

-- Triggers to teach the player all available, and enabled, spells related to mounts
function learnRidingSpells(player)
    -- Get a total count of the riding spells
    local count = 0
    for _ in pairs(LIST_RIDING_SPELLS) do count = count + 1 end

    -- Loop through each row of spells
    for i=1, count do
        -- Check if the spell is enabled
        if (LIST_RIDING_SPELLS[i][8]) then
            -- Check all requirements for the spell
            if ((LIST_RIDING_SPELLS[i][5] <= player:GetLevel()) and 
                (LIST_RIDING_SPELLS[i][7] == 0 or (LIST_RIDING_SPELLS[i][7] == 1 and ENABLE_SPELLS_FROM_QUESTS)) and 
                (LIST_RIDING_SPELLS[i][1] == TEAM_UNDEFINED or LIST_RIDING_SPELLS[i][1] == player:GetTeam()) and 
                (LIST_RIDING_SPELLS[i][2] == RACE_UNDEFINED or LIST_RIDING_SPELLS[i][2] == player:GetRace()) and 
                (LIST_RIDING_SPELLS[i][3] == CLASS_UNDEFINED or LIST_RIDING_SPELLS[i][3] == player:GetClass()) and 
                (LIST_RIDING_SPELLS[i][6] == -1 or (LIST_RIDING_SPELLS[i][6] > 0 and player:HasSpell(LIST_RIDING_SPELLS[i][6])))) then
                -- Check if the player already has the spell
                if not (player:HasSpell(LIST_RIDING_SPELLS[i][4])) then
                    -- Teach the player the spell
                    player:LearnSpell(LIST_RIDING_SPELLS[i][4])
                end
            end
        end
    end
end

-- Triggers to give shamans their totems
function addShamanTotems(player)
    -- Check if the player is a shaman
    if (player:GetClass() == CLASS_SHAMAN) then
        -- Check if class spells and spells from quests are enabled
        if (ENABLE_CLASS_SPELLS and ENABLE_SPELLS_FROM_QUESTS) then
            -- Get a total count of the totems
            local count = 0
            for _ in pairs(LIST_SHAMAN_TOTEMS) do count = count + 1 end

            -- Loop through each row of items
            for i=1,count do
                -- Check if the player meets the required level
                if (LIST_SHAMAN_TOTEMS[i][2] <= player:GetLevel()) then
                    -- Check if the player already has the totem
                    if not (player:HasItem(LIST_SHAMAN_TOTEMS[i][1], 1, true)) then
                        -- Give the player the item
                        player:AddItem(LIST_SHAMAN_TOTEMS[i][1], 1)
                    end
                end
            end
        end
    end
end

-- Called when the player enters the world
function learnSpellsOnLogin(event, player)
    -- Learn all available, and enabled, spells
    learnClassSpells(player)

    -- Learn all available, and enabled, mounts
    learnRidingSpells(player)

    -- Add all available, and enabled, shaman totems
    addShamanTotems(player)
end

RegisterPlayerEvent(EVENT_ON_LOGIN, learnSpellsOnLogin)

-- Called when the players level is changed
function learnSpellsOnLevelChanged(event, player, oldLevel)
    -- Learn all available, and enabled, spells
    learnClassSpells(player)

    -- Learn all available, and enabled, mounts
    learnRidingSpells(player)

    -- Add all available, and enabled, shaman totems
    addShamanTotems(player)
end

RegisterPlayerEvent(EVENT_ON_LEVEL_CHANGED, learnSpellsOnLevelChanged)
