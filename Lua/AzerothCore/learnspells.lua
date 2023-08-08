local Config = {}
Config.EnableForGamemaster     = true
Config.EnableClassSpells       = true
Config.EnableTalentRanks       = true
Config.EnableProficiencies     = true
Config.EnableSpellsFromQuests  = true
Config.EnableApprenticeRiding  = false
Config.EnableJourneymanRiding  = false
Config.EnableExpertRiding      = false
Config.EnableArtisanRiding     = false
Config.EnableColdWeatherFlying = false

local Event                    = {
    OnLogin                    = 3,
    OnLevelChanged             = 13,
    OnTalentsChanged           = 16
}

local Team                     = {
    Universal                  = -1,
    Alliance                   = 0,
    Horde                      = 1,
}

local Race                     = {
    Universal                  = -1,
    Human                      = 1,
    Orc                        = 2,
    Dwarf                      = 3,
    NightElf                   = 4,
    Undead                     = 5,
    Tauren                     = 6,
    Gnome                      = 7,
    Troll                      = 8,
    BloodElf                   = 10,
    Draenei                    = 11,
}

local Class                    = {
    Universal                  = -1,
    Warrior                    = 1,
    Paladin                    = 2,
    Hunter                     = 3,
    Rogue                      = 4,
    Priest                     = 5,
    DeathKnight                = 6,
    Shaman                     = 7,
    Mage                       = 8,
    Warlock                    = 9,
    Druid                      = 11,
}

local Type                     = {
    Class                      = 0,
    Talents                    = 1,
    Proficiencies              = 2,
    Riding                     = 3,
}

local SpellColumn              = {
    Id                         = 1,
    Team                       = 2,
    Race                       = 3,
    Class                      = 4,
    RequiredLevel              = 5,
    RequiredSpell              = 6,
    QuestRequired              = 7,
    Enabled                    = 8,
}

local TotemColumn              = {
    Id                         = 1,
    RequiredLevel              = 2,
    Enabled                    = 3,
}

local Totems                   = {
    { 5175, 4, (Config.EnableClassSpells and Config.EnableSpellsFromQuests) }, -- Earth Totem
    { 5176, 10, (Config.EnableClassSpells and Config.EnableSpellsFromQuests) }, -- Fire Totem
    { 5177, 20, (Config.EnableClassSpells and Config.EnableSpellsFromQuests) }, -- Water totem
    { 5178, 30, (Config.EnableClassSpells and Config.EnableSpellsFromQuests) } -- Air Totem
}

function GetSpellList(type)
    local SpellList

    if (type == Type.Class) then
        SpellList = {
            -- Warrior
            { 78, Team.Universal, Race.Universal, Class.Warrior, 1, -1, false, Config.EnableClassSpells }, --Heroic Strike (Rank 1)
            { 2457, Team.Universal, Race.Universal, Class.Warrior, 1, -1, false, Config.EnableClassSpells }, --Battle Stance
            { 6673, Team.Universal, Race.Universal, Class.Warrior, 1, -1, false, Config.EnableClassSpells }, --Battle Shout (Rank 1)
            { 100, Team.Universal, Race.Universal, Class.Warrior, 4, -1, false, Config.EnableClassSpells }, --Charge (Rank 1)
            { 772, Team.Universal, Race.Universal, Class.Warrior, 4, -1, false, Config.EnableClassSpells }, --Rend (Rank 1)
            { 6343, Team.Universal, Race.Universal, Class.Warrior, 6, -1, false, Config.EnableClassSpells }, --Thunder Clap (Rank 1)
            { 34428, Team.Universal, Race.Universal, Class.Warrior, 6, -1, false, Config.EnableClassSpells }, --Victory Rush
            { 284, Team.Universal, Race.Universal, Class.Warrior, 8, 78, false, Config.EnableClassSpells }, --Heroic Strike (Rank 2)
            { 1715, Team.Universal, Race.Universal, Class.Warrior, 8, -1, false, Config.EnableClassSpells }, --Hamstring
            { 71, Team.Universal, Race.Universal, Class.Warrior, 10, -1, true, Config.EnableClassSpells }, --Defensive Stance
            { 355, Team.Universal, Race.Universal, Class.Warrior, 10, 71, true, Config.EnableClassSpells }, --Taunt
            { 2687, Team.Universal, Race.Universal, Class.Warrior, 10, -1, false, Config.EnableClassSpells }, --Bloodrage
            { 6546, Team.Universal, Race.Universal, Class.Warrior, 10, 772, false, Config.EnableClassSpells }, --Rend (Rank 2)
            { 7386, Team.Universal, Race.Universal, Class.Warrior, 10, 71, true, Config.EnableClassSpells }, --Sunder Armor
            { 72, Team.Universal, Race.Universal, Class.Warrior, 12, -1, false, Config.EnableClassSpells }, --Shield Bash
            { 5242, Team.Universal, Race.Universal, Class.Warrior, 12, 6673, false, Config.EnableClassSpells }, --Battle Shout (Rank 2)
            { 7384, Team.Universal, Race.Universal, Class.Warrior, 12, -1, false, Config.EnableClassSpells }, --Overpower
            { 1160, Team.Universal, Race.Universal, Class.Warrior, 14, -1, false, Config.EnableClassSpells }, --Demoralizing Shout (Rank 1)
            { 6572, Team.Universal, Race.Universal, Class.Warrior, 14, -1, false, Config.EnableClassSpells }, --Revenge (Rank 1)
            { 285, Team.Universal, Race.Universal, Class.Warrior, 16, 284, false, Config.EnableClassSpells }, --Heroic Strike (Rank 3)
            { 694, Team.Universal, Race.Universal, Class.Warrior, 16, -1, false, Config.EnableClassSpells }, --Mocking Blow
            { 2565, Team.Universal, Race.Universal, Class.Warrior, 16, -1, false, Config.EnableClassSpells }, --Shield Block
            { 676, Team.Universal, Race.Universal, Class.Warrior, 18, -1, false, Config.EnableClassSpells }, --Disarm
            { 8198, Team.Universal, Race.Universal, Class.Warrior, 18, 6343, false, Config.EnableClassSpells }, --Thunder Clap (Rank 2)
            { 845, Team.Universal, Race.Universal, Class.Warrior, 20, -1, false, Config.EnableClassSpells }, --Cleave (Rank 1)
            { 6547, Team.Universal, Race.Universal, Class.Warrior, 20, 6546, false, Config.EnableClassSpells }, --Rend (Rank 3)
            { 12678, Team.Universal, Race.Universal, Class.Warrior, 20, -1, false, Config.EnableClassSpells }, --Stance Mastery (Passive)
            { 20230, Team.Universal, Race.Universal, Class.Warrior, 20, -1, false, Config.EnableClassSpells }, --Retaliation
            { 5246, Team.Universal, Race.Universal, Class.Warrior, 22, -1, false, Config.EnableClassSpells }, --Intimidating Shout
            { 6192, Team.Universal, Race.Universal, Class.Warrior, 22, 5242, false, Config.EnableClassSpells }, --Battle Shout (Rank 3)
            { 1608, Team.Universal, Race.Universal, Class.Warrior, 24, 285, false, Config.EnableClassSpells }, --Heroic Strike (Rank 4)
            { 5308, Team.Universal, Race.Universal, Class.Warrior, 24, -1, false, Config.EnableClassSpells }, --Execute (Rank 1)
            { 6190, Team.Universal, Race.Universal, Class.Warrior, 24, 1160, false, Config.EnableClassSpells }, --Demoralizing Shout (Rank 2)
            { 6574, Team.Universal, Race.Universal, Class.Warrior, 24, 6572, false, Config.EnableClassSpells }, --Revenge (Rank 2)
            { 1161, Team.Universal, Race.Universal, Class.Warrior, 26, -1, false, Config.EnableClassSpells }, --Challenging Shout
            { 6178, Team.Universal, Race.Universal, Class.Warrior, 26, 100, false, Config.EnableClassSpells }, --Charge (Rank 2)
            { 871, Team.Universal, Race.Universal, Class.Warrior, 28, -1, false, Config.EnableClassSpells }, --Shield Wall
            { 8204, Team.Universal, Race.Universal, Class.Warrior, 28, 8198, false, Config.EnableClassSpells }, --Thunder Clap (Rank 3)
            { 1464, Team.Universal, Race.Universal, Class.Warrior, 30, -1, false, Config.EnableClassSpells }, --Slam (Rank 1)
            { 2458, Team.Universal, Race.Universal, Class.Warrior, 30, -1, true, Config.EnableClassSpells }, --Berserker Stance
            { 6548, Team.Universal, Race.Universal, Class.Warrior, 30, 6547, false, Config.EnableClassSpells }, --Rend (Rank 4)
            { 7369, Team.Universal, Race.Universal, Class.Warrior, 30, 845, false, Config.EnableClassSpells }, --Cleave (Rank 2)
            { 20252, Team.Universal, Race.Universal, Class.Warrior, 30, 2458, true, Config.EnableClassSpells }, --Intercept
            { 11549, Team.Universal, Race.Universal, Class.Warrior, 32, 6192, false, Config.EnableClassSpells }, --Battle Shout (Rank 4)
            { 11564, Team.Universal, Race.Universal, Class.Warrior, 32, 1608, false, Config.EnableClassSpells }, --Heroic Strike (Rank 5)
            { 18499, Team.Universal, Race.Universal, Class.Warrior, 32, -1, false, Config.EnableClassSpells }, --Berserker Rage
            { 20658, Team.Universal, Race.Universal, Class.Warrior, 32, 5308, false, Config.EnableClassSpells }, --Execute (Rank 2)
            { 7379, Team.Universal, Race.Universal, Class.Warrior, 34, 6574, false, Config.EnableClassSpells }, --Revenge (Rank 3)
            { 11554, Team.Universal, Race.Universal, Class.Warrior, 34, 6190, false, Config.EnableClassSpells }, --Demoralizing Shout (Rank 3)
            { 1680, Team.Universal, Race.Universal, Class.Warrior, 36, -1, false, Config.EnableClassSpells }, --Whirlwind
            { 6552, Team.Universal, Race.Universal, Class.Warrior, 38, -1, false, Config.EnableClassSpells }, --Pummel
            { 8205, Team.Universal, Race.Universal, Class.Warrior, 38, 8204, false, Config.EnableClassSpells }, --Thunder Clap (Rank 4)
            { 8820, Team.Universal, Race.Universal, Class.Warrior, 38, 1464, false, Config.EnableClassSpells }, --Slam (Rank 2)
            { 11565, Team.Universal, Race.Universal, Class.Warrior, 40, 11564, false, Config.EnableClassSpells }, --Heroic Strike (Rank 6)
            { 11572, Team.Universal, Race.Universal, Class.Warrior, 40, 6548, false, Config.EnableClassSpells }, --Rend (Rank 5)
            { 11608, Team.Universal, Race.Universal, Class.Warrior, 40, 7369, false, Config.EnableClassSpells }, --Cleave (Rank 3)
            { 20660, Team.Universal, Race.Universal, Class.Warrior, 40, 20658, false, Config.EnableClassSpells }, --Execute (Rank 3)
            { 23922, Team.Universal, Race.Universal, Class.Warrior, 40, -1, false, Config.EnableClassSpells }, --Shield Slam (Rank 1)
            { 11550, Team.Universal, Race.Universal, Class.Warrior, 42, 11549, false, Config.EnableClassSpells }, --Battle Shout (Rank 5)
            { 11555, Team.Universal, Race.Universal, Class.Warrior, 44, 11554, false, Config.EnableClassSpells }, --Demoralizing Shout (Rank 4)
            { 11600, Team.Universal, Race.Universal, Class.Warrior, 44, 7379, false, Config.EnableClassSpells }, --Revenge (Rank 4)
            { 11578, Team.Universal, Race.Universal, Class.Warrior, 46, 6178, false, Config.EnableClassSpells }, --Charge (Rank 3)
            { 11604, Team.Universal, Race.Universal, Class.Warrior, 46, 8820, false, Config.EnableClassSpells }, --Slam (Rank 3)
            { 11566, Team.Universal, Race.Universal, Class.Warrior, 48, 11565, false, Config.EnableClassSpells }, --Heroic Strike (Rank 7)
            { 11580, Team.Universal, Race.Universal, Class.Warrior, 48, 8205, false, Config.EnableClassSpells }, --Thunder Clap (Rank 5)
            { 20661, Team.Universal, Race.Universal, Class.Warrior, 48, 20660, false, Config.EnableClassSpells }, --Execute (Rank 4)
            { 23923, Team.Universal, Race.Universal, Class.Warrior, 48, 23922, false, Config.EnableClassSpells }, --Shield Slam (Rank 2)
            { 1719, Team.Universal, Race.Universal, Class.Warrior, 50, -1, false, Config.EnableClassSpells }, --Recklessness
            { 11573, Team.Universal, Race.Universal, Class.Warrior, 50, 11572, false, Config.EnableClassSpells }, --Rend (Rank 6)
            { 11609, Team.Universal, Race.Universal, Class.Warrior, 50, 11608, false, Config.EnableClassSpells }, --Cleave (Rank 4)
            { 11551, Team.Universal, Race.Universal, Class.Warrior, 52, 11550, false, Config.EnableClassSpells }, --Battle Shout (Rank 6)
            { 11556, Team.Universal, Race.Universal, Class.Warrior, 54, 11555, false, Config.EnableClassSpells }, --Demoralizing Shout (Rank 5)
            { 11601, Team.Universal, Race.Universal, Class.Warrior, 54, 11600, false, Config.EnableClassSpells }, --Revenge (Rank 5)
            { 11605, Team.Universal, Race.Universal, Class.Warrior, 54, 11604, false, Config.EnableClassSpells }, --Slam (Rank 4)
            { 23924, Team.Universal, Race.Universal, Class.Warrior, 54, 23923, false, Config.EnableClassSpells }, --Shield Slam (Rank 3)
            { 11567, Team.Universal, Race.Universal, Class.Warrior, 56, 11566, false, Config.EnableClassSpells }, --Heroic Strike (Rank 8)
            { 20662, Team.Universal, Race.Universal, Class.Warrior, 56, 20661, false, Config.EnableClassSpells }, --Execute (Rank 5)
            { 11581, Team.Universal, Race.Universal, Class.Warrior, 58, 11580, false, Config.EnableClassSpells }, --Thunder Clap (Rank 6)
            { 11574, Team.Universal, Race.Universal, Class.Warrior, 60, 11573, false, Config.EnableClassSpells }, --Rend (Rank 7)
            { 20569, Team.Universal, Race.Universal, Class.Warrior, 60, 11609, false, Config.EnableClassSpells }, --Cleave (Rank 5)
            { 23925, Team.Universal, Race.Universal, Class.Warrior, 60, 23924, false, Config.EnableClassSpells }, --Shield Slam (Rank 4)
            { 25286, Team.Universal, Race.Universal, Class.Warrior, 60, 11567, false, Config.EnableClassSpells }, --Heroic Strike (Rank 9)
            { 25288, Team.Universal, Race.Universal, Class.Warrior, 60, 11601, false, Config.EnableClassSpells }, --Revenge (Rank 6)
            { 25289, Team.Universal, Race.Universal, Class.Warrior, 60, 11551, false, Config.EnableClassSpells }, --Battle Shout (Rank 7)
            { 25241, Team.Universal, Race.Universal, Class.Warrior, 61, 11605, false, Config.EnableClassSpells }, --Slam (Rank 5)
            { 25202, Team.Universal, Race.Universal, Class.Warrior, 62, 11556, false, Config.EnableClassSpells }, --Demoralizing Shout (Rank 6)
            { 25269, Team.Universal, Race.Universal, Class.Warrior, 63, 25288, false, Config.EnableClassSpells }, --Revenge (Rank 7)
            { 23920, Team.Universal, Race.Universal, Class.Warrior, 64, -1, false, Config.EnableClassSpells }, --Spell Reflection
            { 25234, Team.Universal, Race.Universal, Class.Warrior, 65, 20662, false, Config.EnableClassSpells }, --Execute (Rank 6)
            { 25258, Team.Universal, Race.Universal, Class.Warrior, 66, 23925, false, Config.EnableClassSpells }, --Shield Slam (Rank 5)
            { 29707, Team.Universal, Race.Universal, Class.Warrior, 66, 25286, false, Config.EnableClassSpells }, --Heroic Strike (Rank 10)
            { 25264, Team.Universal, Race.Universal, Class.Warrior, 67, 11581, false, Config.EnableClassSpells }, --Thunder Clap (Rank 7)
            { 469, Team.Universal, Race.Universal, Class.Warrior, 68, -1, false, Config.EnableClassSpells }, --Commanding Shout (Rank 1)
            { 25208, Team.Universal, Race.Universal, Class.Warrior, 68, 11574, false, Config.EnableClassSpells }, --Rend (Rank 8)
            { 25231, Team.Universal, Race.Universal, Class.Warrior, 68, 20569, false, Config.EnableClassSpells }, --Cleave (Rank 6)
            { 2048, Team.Universal, Race.Universal, Class.Warrior, 69, 25289, false, Config.EnableClassSpells }, --Battle Shout (Rank 8)
            { 25242, Team.Universal, Race.Universal, Class.Warrior, 69, 25241, false, Config.EnableClassSpells }, --Slam (Rank 6)
            { 3411, Team.Universal, Race.Universal, Class.Warrior, 70, -1, false, Config.EnableClassSpells }, --Intervene
            { 25203, Team.Universal, Race.Universal, Class.Warrior, 70, 25202, false, Config.EnableClassSpells }, --Demoralizing Shout (Rank 7)
            { 25236, Team.Universal, Race.Universal, Class.Warrior, 70, 25234, false, Config.EnableClassSpells }, --Execute (Rank 7)
            { 30324, Team.Universal, Race.Universal, Class.Warrior, 70, 29707, false, Config.EnableClassSpells }, --Heroic Strike (Rank 11)
            { 30356, Team.Universal, Race.Universal, Class.Warrior, 70, 25258, false, Config.EnableClassSpells }, --Shield Slam (Rank 6)
            { 30357, Team.Universal, Race.Universal, Class.Warrior, 70, 25269, false, Config.EnableClassSpells }, --Revenge (Rank 8)
            { 46845, Team.Universal, Race.Universal, Class.Warrior, 71, 25208, false, Config.EnableClassSpells }, --Rend (Rank 9)
            { 64382, Team.Universal, Race.Universal, Class.Warrior, 71, -1, false, Config.EnableClassSpells }, --Shattering Throw
            { 47449, Team.Universal, Race.Universal, Class.Warrior, 72, 30324, false, Config.EnableClassSpells }, --Heroic Strike (Rank 12)
            { 47519, Team.Universal, Race.Universal, Class.Warrior, 72, 25231, false, Config.EnableClassSpells }, --Cleave (Rank 7)
            { 47470, Team.Universal, Race.Universal, Class.Warrior, 73, 25236, false, Config.EnableClassSpells }, --Execute (Rank 8)
            { 47501, Team.Universal, Race.Universal, Class.Warrior, 73, 25264, false, Config.EnableClassSpells }, --Thunder Clap (Rank 8)
            { 47439, Team.Universal, Race.Universal, Class.Warrior, 74, 469, false, Config.EnableClassSpells }, --Commanding Shout (Rank 2)
            { 47474, Team.Universal, Race.Universal, Class.Warrior, 74, 25242, false, Config.EnableClassSpells }, --Slam (Rank 7)
            { 47487, Team.Universal, Race.Universal, Class.Warrior, 75, 30356, false, Config.EnableClassSpells }, --Shield Slam (Rank 7)
            { 55694, Team.Universal, Race.Universal, Class.Warrior, 75, -1, false, Config.EnableClassSpells }, --Enraged Regeneration
            { 47450, Team.Universal, Race.Universal, Class.Warrior, 76, 47449, false, Config.EnableClassSpells }, --Heroic Strike (Rank 13)
            { 47465, Team.Universal, Race.Universal, Class.Warrior, 76, 46845, false, Config.EnableClassSpells }, --Rend (Rank 10)
            { 47520, Team.Universal, Race.Universal, Class.Warrior, 77, 47519, false, Config.EnableClassSpells }, --Cleave (Rank 8)
            { 47436, Team.Universal, Race.Universal, Class.Warrior, 78, 2048, false, Config.EnableClassSpells }, --Battle Shout (Rank 9)
            { 47502, Team.Universal, Race.Universal, Class.Warrior, 78, 47501, false, Config.EnableClassSpells }, --Thunder Clap (Rank 9)
            { 47437, Team.Universal, Race.Universal, Class.Warrior, 79, 25203, false, Config.EnableClassSpells }, --Demoralizing Shout (Rank 8)
            { 47475, Team.Universal, Race.Universal, Class.Warrior, 79, 47474, false, Config.EnableClassSpells }, --Slam (Rank 8)
            { 47440, Team.Universal, Race.Universal, Class.Warrior, 80, 47439, false, Config.EnableClassSpells }, --Commanding Shout (Rank 3)
            { 47471, Team.Universal, Race.Universal, Class.Warrior, 80, 47470, false, Config.EnableClassSpells }, --Execute (Rank 9)
            { 47488, Team.Universal, Race.Universal, Class.Warrior, 80, 47487, false, Config.EnableClassSpells }, --Shield Slam (Rank 8)
            { 57755, Team.Universal, Race.Universal, Class.Warrior, 80, -1, false, Config.EnableClassSpells }, --Heroic Throw
            { 57823, Team.Universal, Race.Universal, Class.Warrior, 80, 30357, false, Config.EnableClassSpells }, --Revenge (Rank 9)
            -- Paladin
            { 465, Team.Universal, Race.Universal, Class.Paladin, 1, -1, false, Config.EnableClassSpells }, --Devotion Aura (Rank 1)
            { 635, Team.Universal, Race.Universal, Class.Paladin, 1, -1, false, Config.EnableClassSpells }, --Holy Light (Rank 1)
            { 21084, Team.Universal, Race.Universal, Class.Paladin, 1, -1, false, Config.EnableClassSpells }, --Seal of Righteousness
            { 19740, Team.Universal, Race.Universal, Class.Paladin, 4, -1, false, Config.EnableClassSpells }, --Blessing of Might (Rank 1)
            { 20271, Team.Universal, Race.Universal, Class.Paladin, 4, -1, false, Config.EnableClassSpells }, --Judgement of Light
            { 498, Team.Universal, Race.Universal, Class.Paladin, 6, -1, false, Config.EnableClassSpells }, --Divine Protection
            { 639, Team.Universal, Race.Universal, Class.Paladin, 6, 635, false, Config.EnableClassSpells }, --Holy Light (Rank 2)
            { 853, Team.Universal, Race.Universal, Class.Paladin, 8, -1, false, Config.EnableClassSpells }, --Hammer of Justice (Rank 1)
            { 1152, Team.Universal, Race.Universal, Class.Paladin, 8, -1, false, Config.EnableClassSpells }, --Purify
            { 633, Team.Universal, Race.Universal, Class.Paladin, 10, -1, false, Config.EnableClassSpells }, --Lay on Hands (Rank 1)
            { 1022, Team.Universal, Race.Universal, Class.Paladin, 10, -1, false, Config.EnableClassSpells }, --Hand of Protection (Rank 1)
            { 10290, Team.Universal, Race.Universal, Class.Paladin, 10, 465, false, Config.EnableClassSpells }, --Devotion Aura (Rank 2)
            { 7328, Team.Universal, Race.Universal, Class.Paladin, 12, -1, false, Config.EnableClassSpells }, --Redemption (Rank 1)
            { 19834, Team.Universal, Race.Universal, Class.Paladin, 12, 19740, false, Config.EnableClassSpells }, --Blessing of Might (Rank 2)
            { 53408, Team.Universal, Race.Universal, Class.Paladin, 12, -1, false, Config.EnableClassSpells }, --Judgement of Wisdom
            { 647, Team.Universal, Race.Universal, Class.Paladin, 14, 639, false, Config.EnableClassSpells }, --Holy Light (Rank 3)
            { 19742, Team.Universal, Race.Universal, Class.Paladin, 14, -1, false, Config.EnableClassSpells }, --Blessing of Wisdom (Rank 1)
            { 31789, Team.Universal, Race.Universal, Class.Paladin, 14, -1, false, Config.EnableClassSpells }, --Righteous Defense
            { 7294, Team.Universal, Race.Universal, Class.Paladin, 16, -1, false, Config.EnableClassSpells }, --Retribution Aura (Rank 1)
            { 25780, Team.Universal, Race.Universal, Class.Paladin, 16, -1, false, Config.EnableClassSpells }, --Righteous Fury
            { 62124, Team.Universal, Race.Universal, Class.Paladin, 16, -1, false, Config.EnableClassSpells }, --Hand of Reckoning
            { 1044, Team.Universal, Race.Universal, Class.Paladin, 18, -1, false, Config.EnableClassSpells }, --Hand of Freedom
            { 643, Team.Universal, Race.Universal, Class.Paladin, 20, 10290, false, Config.EnableClassSpells }, --Devotion Aura (Rank 3)
            { 879, Team.Universal, Race.Universal, Class.Paladin, 20, -1, false, Config.EnableClassSpells }, --Exorcism (Rank 1)
            { 5502, Team.Universal, Race.Universal, Class.Paladin, 20, -1, false, Config.EnableClassSpells }, --Sense Undead
            { 19750, Team.Universal, Race.Universal, Class.Paladin, 20, -1, false, Config.EnableClassSpells }, --Flash of Light (Rank 1)
            { 20217, Team.Universal, Race.Universal, Class.Paladin, 20, -1, false, Config.EnableClassSpells }, --Blessing of Kings
            { 26573, Team.Universal, Race.Universal, Class.Paladin, 20, -1, false, Config.EnableClassSpells }, --Consecration (Rank 1)
            { 1026, Team.Universal, Race.Universal, Class.Paladin, 22, 647, false, Config.EnableClassSpells }, --Holy Light (Rank 4)
            { 19746, Team.Universal, Race.Universal, Class.Paladin, 22, -1, false, Config.EnableClassSpells }, --Concentration Aura
            { 19835, Team.Universal, Race.Universal, Class.Paladin, 22, 19834, false, Config.EnableClassSpells }, --Blessing of Might (Rank 3)
            { 20164, Team.Universal, Race.Universal, Class.Paladin, 22, -1, false, Config.EnableClassSpells }, --Seal of Justice
            { 5588, Team.Universal, Race.Universal, Class.Paladin, 24, 853, false, Config.EnableClassSpells }, --Hammer of Justice (Rank 2)
            { 5599, Team.Universal, Race.Universal, Class.Paladin, 24, 1022, false, Config.EnableClassSpells }, --Hand of Protection (Rank 2)
            { 10322, Team.Universal, Race.Universal, Class.Paladin, 24, 7328, false, Config.EnableClassSpells }, --Redemption (Rank 2)
            { 10326, Team.Universal, Race.Universal, Class.Paladin, 24, -1, false, Config.EnableClassSpells }, --Turn Evil
            { 19850, Team.Universal, Race.Universal, Class.Paladin, 24, 19742, false, Config.EnableClassSpells }, --Blessing of Wisdom (Rank 2)
            { 1038, Team.Universal, Race.Universal, Class.Paladin, 26, -1, false, Config.EnableClassSpells }, --Hand of Salvation
            { 10298, Team.Universal, Race.Universal, Class.Paladin, 26, 7294, false, Config.EnableClassSpells }, --Retribution Aura (Rank 2)
            { 19939, Team.Universal, Race.Universal, Class.Paladin, 26, 19750, false, Config.EnableClassSpells }, --Flash of Light (Rank 2)
            { 5614, Team.Universal, Race.Universal, Class.Paladin, 28, 879, false, Config.EnableClassSpells }, --Exorcism (Rank 2)
            { 19876, Team.Universal, Race.Universal, Class.Paladin, 28, -1, false, Config.EnableClassSpells }, --Shadow Resistance Aura (Rank 1)
            { 53407, Team.Universal, Race.Universal, Class.Paladin, 28, -1, false, Config.EnableClassSpells }, --Judgement of Justice
            { 1042, Team.Universal, Race.Universal, Class.Paladin, 30, 1026, false, Config.EnableClassSpells }, --Holy Light (Rank 5)
            { 2800, Team.Universal, Race.Universal, Class.Paladin, 30, 633, false, Config.EnableClassSpells }, --Lay on Hands (Rank 2)
            { 10291, Team.Universal, Race.Universal, Class.Paladin, 30, 643, false, Config.EnableClassSpells }, --Devotion Aura (Rank 4)
            { 19752, Team.Universal, Race.Universal, Class.Paladin, 30, -1, false, Config.EnableClassSpells }, --Divine Intervention
            { 20116, Team.Universal, Race.Universal, Class.Paladin, 30, 26573, false, Config.EnableClassSpells }, --Consecration (Rank 2)
            { 20165, Team.Universal, Race.Universal, Class.Paladin, 30, -1, false, Config.EnableClassSpells }, --Seal of Light
            { 19836, Team.Universal, Race.Universal, Class.Paladin, 32, 19835, false, Config.EnableClassSpells }, --Blessing of Might (Rank 4)
            { 19888, Team.Universal, Race.Universal, Class.Paladin, 32, -1, false, Config.EnableClassSpells }, --Frost Resistance Aura (Rank 1)
            { 642, Team.Universal, Race.Universal, Class.Paladin, 34, -1, false, Config.EnableClassSpells }, --Divine Shield
            { 19852, Team.Universal, Race.Universal, Class.Paladin, 34, 19850, false, Config.EnableClassSpells }, --Blessing of Wisdom (Rank 3)
            { 19940, Team.Universal, Race.Universal, Class.Paladin, 34, 19939, false, Config.EnableClassSpells }, --Flash of Light (Rank 3)
            { 5615, Team.Universal, Race.Universal, Class.Paladin, 36, 5614, false, Config.EnableClassSpells }, --Exorcism (Rank 3)
            { 10299, Team.Universal, Race.Universal, Class.Paladin, 36, 10298, false, Config.EnableClassSpells }, --Retribution Aura (Rank 3)
            { 10324, Team.Universal, Race.Universal, Class.Paladin, 36, 10322, false, Config.EnableClassSpells }, --Redemption (Rank 3)
            { 19891, Team.Universal, Race.Universal, Class.Paladin, 36, -1, false, Config.EnableClassSpells }, --Fire Resistance Aura (Rank 1)
            { 3472, Team.Universal, Race.Universal, Class.Paladin, 38, 1042, false, Config.EnableClassSpells }, --Holy Light (Rank 6)
            { 10278, Team.Universal, Race.Universal, Class.Paladin, 38, 5599, false, Config.EnableClassSpells }, --Hand of Protection (Rank 3)
            { 20166, Team.Universal, Race.Universal, Class.Paladin, 38, -1, false, Config.EnableClassSpells }, --Seal of Wisdom
            { 1032, Team.Universal, Race.Universal, Class.Paladin, 40, 10291, false, Config.EnableClassSpells }, --Devotion Aura (Rank 5)
            { 5589, Team.Universal, Race.Universal, Class.Paladin, 40, 5588, false, Config.EnableClassSpells }, --Hammer of Justice (Rank 3)
            { 19895, Team.Universal, Race.Universal, Class.Paladin, 40, 19876, false, Config.EnableClassSpells }, --Shadow Resistance Aura (Rank 2)
            { 20922, Team.Universal, Race.Universal, Class.Paladin, 40, 20116, false, Config.EnableClassSpells }, --Consecration (Rank 3)
            { 4987, Team.Universal, Race.Universal, Class.Paladin, 42, -1, false, Config.EnableClassSpells }, --Cleanse
            { 19837, Team.Universal, Race.Universal, Class.Paladin, 42, 19836, false, Config.EnableClassSpells }, --Blessing of Might (Rank 5)
            { 19941, Team.Universal, Race.Universal, Class.Paladin, 42, 19940, false, Config.EnableClassSpells }, --Flash of Light (Rank 4)
            { 10312, Team.Universal, Race.Universal, Class.Paladin, 44, 5615, false, Config.EnableClassSpells }, --Exorcism (Rank 4)
            { 19853, Team.Universal, Race.Universal, Class.Paladin, 44, 19852, false, Config.EnableClassSpells }, --Blessing of Wisdom (Rank 4)
            { 19897, Team.Universal, Race.Universal, Class.Paladin, 44, 19888, false, Config.EnableClassSpells }, --Frost Resistance Aura (Rank 2)
            { 24275, Team.Universal, Race.Universal, Class.Paladin, 44, -1, false, Config.EnableClassSpells }, --Hammer of Wrath (Rank 1)
            { 6940, Team.Universal, Race.Universal, Class.Paladin, 46, -1, false, Config.EnableClassSpells }, --Hand of Sacrifice
            { 10300, Team.Universal, Race.Universal, Class.Paladin, 46, 10299, false, Config.EnableClassSpells }, --Retribution Aura (Rank 4)
            { 10328, Team.Universal, Race.Universal, Class.Paladin, 46, 3472, false, Config.EnableClassSpells }, --Holy Light (Rank 7)
            { 19899, Team.Universal, Race.Universal, Class.Paladin, 48, 19891, false, Config.EnableClassSpells }, --Fire Resistance Aura (Rank 2)
            { 20772, Team.Universal, Race.Universal, Class.Paladin, 48, 10324, false, Config.EnableClassSpells }, --Redemption (Rank 4)
            { 2812, Team.Universal, Race.Universal, Class.Paladin, 50, -1, false, Config.EnableClassSpells }, --Holy Wrath (Rank 1)
            { 10292, Team.Universal, Race.Universal, Class.Paladin, 50, 1032, false, Config.EnableClassSpells }, --Devotion Aura (Rank 6)
            { 10310, Team.Universal, Race.Universal, Class.Paladin, 50, 2800, false, Config.EnableClassSpells }, --Lay on Hands (Rank 3)
            { 19942, Team.Universal, Race.Universal, Class.Paladin, 50, 19941, false, Config.EnableClassSpells }, --Flash of Light (Rank 5)
            { 20923, Team.Universal, Race.Universal, Class.Paladin, 50, 20922, false, Config.EnableClassSpells }, --Consecration (Rank 4)
            { 10313, Team.Universal, Race.Universal, Class.Paladin, 52, 10312, false, Config.EnableClassSpells }, --Exorcism (Rank 5)
            { 19838, Team.Universal, Race.Universal, Class.Paladin, 52, 19837, false, Config.EnableClassSpells }, --Blessing of Might (Rank 6)
            { 19896, Team.Universal, Race.Universal, Class.Paladin, 52, 19895, false, Config.EnableClassSpells }, --Shadow Resistance Aura (Rank 3)
            { 24274, Team.Universal, Race.Universal, Class.Paladin, 52, 24275, false, Config.EnableClassSpells }, --Hammer of Wrath (Rank 2)
            { 25782, Team.Universal, Race.Universal, Class.Paladin, 52, -1, false, Config.EnableClassSpells }, --Greater Blessing of Might (Rank 1)
            { 10308, Team.Universal, Race.Universal, Class.Paladin, 54, 5589, false, Config.EnableClassSpells }, --Hammer of Justice (Rank 4)
            { 10329, Team.Universal, Race.Universal, Class.Paladin, 54, 10328, false, Config.EnableClassSpells }, --Holy Light (Rank 8)
            { 19854, Team.Universal, Race.Universal, Class.Paladin, 54, 19853, false, Config.EnableClassSpells }, --Blessing of Wisdom (Rank 5)
            { 25894, Team.Universal, Race.Universal, Class.Paladin, 54, -1, false, Config.EnableClassSpells }, --Greater Blessing of Wisdom (Rank 1)
            { 10301, Team.Universal, Race.Universal, Class.Paladin, 56, 10300, false, Config.EnableClassSpells }, --Retribution Aura (Rank 5)
            { 19898, Team.Universal, Race.Universal, Class.Paladin, 56, 19897, false, Config.EnableClassSpells }, --Frost Resistance Aura (Rank 3)
            { 19943, Team.Universal, Race.Universal, Class.Paladin, 58, 19942, false, Config.EnableClassSpells }, --Flash of Light (Rank 6)
            { 10293, Team.Universal, Race.Universal, Class.Paladin, 60, 10292, false, Config.EnableClassSpells }, --Devotion Aura (Rank 7)
            { 10314, Team.Universal, Race.Universal, Class.Paladin, 60, 10313, false, Config.EnableClassSpells }, --Exorcism (Rank 6)
            { 10318, Team.Universal, Race.Universal, Class.Paladin, 60, 2812, false, Config.EnableClassSpells }, --Holy Wrath (Rank 2)
            { 19900, Team.Universal, Race.Universal, Class.Paladin, 60, 19899, false, Config.EnableClassSpells }, --Fire Resistance Aura (Rank 3)
            { 20773, Team.Universal, Race.Universal, Class.Paladin, 60, 20772, false, Config.EnableClassSpells }, --Redemption (Rank 5)
            { 20924, Team.Universal, Race.Universal, Class.Paladin, 60, 20923, false, Config.EnableClassSpells }, --Consecration (Rank 5)
            { 24239, Team.Universal, Race.Universal, Class.Paladin, 60, 24274, false, Config.EnableClassSpells }, --Hammer of Wrath (Rank 3)
            { 25290, Team.Universal, Race.Universal, Class.Paladin, 60, 19854, false, Config.EnableClassSpells }, --Blessing of Wisdom (Rank 6)
            { 25291, Team.Universal, Race.Universal, Class.Paladin, 60, 19838, false, Config.EnableClassSpells }, --Blessing of Might (Rank 7)
            { 25292, Team.Universal, Race.Universal, Class.Paladin, 60, 10329, false, Config.EnableClassSpells }, --Holy Light (Rank 9)
            { 25898, Team.Universal, Race.Universal, Class.Paladin, 60, -1, false, Config.EnableClassSpells }, --Greater Blessing of Kings
            { 25916, Team.Universal, Race.Universal, Class.Paladin, 60, 25782, false, Config.EnableClassSpells }, --Greater Blessing of Might (Rank 2)
            { 25918, Team.Universal, Race.Universal, Class.Paladin, 60, 25894, false, Config.EnableClassSpells }, --Greater Blessing of Wisdom (Rank 2)
            { 27135, Team.Universal, Race.Universal, Class.Paladin, 62, 25292, false, Config.EnableClassSpells }, --Holy Light (Rank 10)
            { 32223, Team.Universal, Race.Universal, Class.Paladin, 62, -1, false, Config.EnableClassSpells }, --Crusader Aura
            { 27151, Team.Universal, Race.Universal, Class.Paladin, 63, 19896, false, Config.EnableClassSpells }, --Shadow Resistance Aura (Rank 4)
            { 31801, Team.Alliance, Race.Universal, Class.Paladin, 64, -1, false, Config.EnableClassSpells }, --Seal of Vengeance
            { 27142, Team.Universal, Race.Universal, Class.Paladin, 65, 25290, false, Config.EnableClassSpells }, --Blessing of Wisdom (Rank 7)
            { 27143, Team.Universal, Race.Universal, Class.Paladin, 65, 25918, false, Config.EnableClassSpells }, --Greater Blessing of Wisdom (Rank 3)
            { 27137, Team.Universal, Race.Universal, Class.Paladin, 66, 19943, false, Config.EnableClassSpells }, --Flash of Light (Rank 7)
            { 27150, Team.Universal, Race.Universal, Class.Paladin, 66, 10301, false, Config.EnableClassSpells }, --Retribution Aura (Rank 6)
            { 53736, Team.Horde, Race.Universal, Class.Paladin, 66, -1, false, Config.EnableClassSpells }, --Seal of Corruption
            { 27138, Team.Universal, Race.Universal, Class.Paladin, 68, 10314, false, Config.EnableClassSpells }, --Exorcism (Rank 7)
            { 27152, Team.Universal, Race.Universal, Class.Paladin, 68, 19898, false, Config.EnableClassSpells }, --Frost Resistance Aura (Rank 4)
            { 27180, Team.Universal, Race.Universal, Class.Paladin, 68, 24239, false, Config.EnableClassSpells }, --Hammer of Wrath (Rank 4)
            { 27139, Team.Universal, Race.Universal, Class.Paladin, 69, 10318, false, Config.EnableClassSpells }, --Holy Wrath (Rank 3)
            { 27154, Team.Universal, Race.Universal, Class.Paladin, 69, 10310, false, Config.EnableClassSpells }, --Lay on Hands (Rank 4)
            { 27136, Team.Universal, Race.Universal, Class.Paladin, 70, 27135, false, Config.EnableClassSpells }, --Holy Light (Rank 11)
            { 27140, Team.Universal, Race.Universal, Class.Paladin, 70, 25291, false, Config.EnableClassSpells }, --Blessing of Might (Rank 8)
            { 27141, Team.Universal, Race.Universal, Class.Paladin, 70, 25916, false, Config.EnableClassSpells }, --Greater Blessing of Might (Rank 3)
            { 27149, Team.Universal, Race.Universal, Class.Paladin, 70, 10293, false, Config.EnableClassSpells }, --Devotion Aura (Rank 8)
            { 27153, Team.Universal, Race.Universal, Class.Paladin, 70, 19900, false, Config.EnableClassSpells }, --Fire Resistance Aura (Rank 4)
            { 27173, Team.Universal, Race.Universal, Class.Paladin, 70, 20924, false, Config.EnableClassSpells }, --Consecration (Rank 6)
            { 31884, Team.Universal, Race.Universal, Class.Paladin, 70, -1, false, Config.EnableClassSpells }, --Avenging Wrath
            { 48935, Team.Universal, Race.Universal, Class.Paladin, 71, 27142, false, Config.EnableClassSpells }, --Blessing of Wisdom (Rank 8)
            { 48937, Team.Universal, Race.Universal, Class.Paladin, 71, 27143, false, Config.EnableClassSpells }, --Greater Blessing of Wisdom (Rank 4)
            { 54428, Team.Universal, Race.Universal, Class.Paladin, 71, -1, false, Config.EnableClassSpells }, --Divine Plea
            { 48816, Team.Universal, Race.Universal, Class.Paladin, 72, 27139, false, Config.EnableClassSpells }, --Holy Wrath (Rank 4)
            { 48949, Team.Universal, Race.Universal, Class.Paladin, 72, 20773, false, Config.EnableClassSpells }, --Redemption (Rank 6)
            { 48800, Team.Universal, Race.Universal, Class.Paladin, 73, 27138, false, Config.EnableClassSpells }, --Exorcism (Rank 8)
            { 48931, Team.Universal, Race.Universal, Class.Paladin, 73, 27140, false, Config.EnableClassSpells }, --Blessing of Might (Rank 9)
            { 48933, Team.Universal, Race.Universal, Class.Paladin, 73, 27141, false, Config.EnableClassSpells }, --Greater Blessing of Might (Rank 4)
            { 48784, Team.Universal, Race.Universal, Class.Paladin, 74, 27137, false, Config.EnableClassSpells }, --Flash of Light (Rank 8)
            { 48805, Team.Universal, Race.Universal, Class.Paladin, 74, 27180, false, Config.EnableClassSpells }, --Hammer of Wrath (Rank 5)
            { 48941, Team.Universal, Race.Universal, Class.Paladin, 74, 27149, false, Config.EnableClassSpells }, --Devotion Aura (Rank 9)
            { 48781, Team.Universal, Race.Universal, Class.Paladin, 75, 27136, false, Config.EnableClassSpells }, --Holy Light (Rank 12)
            { 48818, Team.Universal, Race.Universal, Class.Paladin, 75, 27173, false, Config.EnableClassSpells }, --Consecration (Rank 7)
            { 53600, Team.Universal, Race.Universal, Class.Paladin, 75, -1, false, Config.EnableClassSpells }, --Shield of Righteousness (Rank 1)
            { 48943, Team.Universal, Race.Universal, Class.Paladin, 76, 27151, false, Config.EnableClassSpells }, --Shadow Resistance Aura (Rank 5)
            { 54043, Team.Universal, Race.Universal, Class.Paladin, 76, 27150, false, Config.EnableClassSpells }, --Retribution Aura (Rank 7)
            { 48936, Team.Universal, Race.Universal, Class.Paladin, 77, 48935, false, Config.EnableClassSpells }, --Blessing of Wisdom (Rank 9)
            { 48938, Team.Universal, Race.Universal, Class.Paladin, 77, 48937, false, Config.EnableClassSpells }, --Greater Blessing of Wisdom (Rank 5)
            { 48945, Team.Universal, Race.Universal, Class.Paladin, 77, 27152, false, Config.EnableClassSpells }, --Frost Resistance Aura (Rank 5)
            { 48788, Team.Universal, Race.Universal, Class.Paladin, 78, 27154, false, Config.EnableClassSpells }, --Lay on Hands (Rank 5)
            { 48817, Team.Universal, Race.Universal, Class.Paladin, 78, 48816, false, Config.EnableClassSpells }, --Holy Wrath (Rank 5)
            { 48947, Team.Universal, Race.Universal, Class.Paladin, 78, 27153, false, Config.EnableClassSpells }, --Fire Resistance Aura (Rank 5)
            { 48785, Team.Universal, Race.Universal, Class.Paladin, 79, 48784, false, Config.EnableClassSpells }, --Flash of Light (Rank 9)
            { 48801, Team.Universal, Race.Universal, Class.Paladin, 79, 48800, false, Config.EnableClassSpells }, --Exorcism (Rank 9)
            { 48932, Team.Universal, Race.Universal, Class.Paladin, 79, 48931, false, Config.EnableClassSpells }, --Blessing of Might (Rank 10)
            { 48934, Team.Universal, Race.Universal, Class.Paladin, 79, 48933, false, Config.EnableClassSpells }, --Greater Blessing of Might (Rank 5)
            { 48942, Team.Universal, Race.Universal, Class.Paladin, 79, 48941, false, Config.EnableClassSpells }, --Devotion Aura (Rank 10)
            { 48950, Team.Universal, Race.Universal, Class.Paladin, 79, 48949, false, Config.EnableClassSpells }, --Redemption (Rank 7)
            { 48782, Team.Universal, Race.Universal, Class.Paladin, 80, 48781, false, Config.EnableClassSpells }, --Holy Light (Rank 13)
            { 48806, Team.Universal, Race.Universal, Class.Paladin, 80, 48805, false, Config.EnableClassSpells }, --Hammer of Wrath (Rank 6)
            { 48819, Team.Universal, Race.Universal, Class.Paladin, 80, 48818, false, Config.EnableClassSpells }, --Consecration (Rank 8)
            { 53601, Team.Universal, Race.Universal, Class.Paladin, 80, -1, false, Config.EnableClassSpells }, --Sacred Shield (Rank 1)
            { 61411, Team.Universal, Race.Universal, Class.Paladin, 80, 53600, false, Config.EnableClassSpells }, --Shield of Righteousness (Rank 2)
            -- Hunter
            { 1494, Team.Universal, Race.Universal, Class.Hunter, 1, -1, false, Config.EnableClassSpells }, --Track Beasts
            { 2973, Team.Universal, Race.Universal, Class.Hunter, 1, -1, false, Config.EnableClassSpells }, --Raptor Strike (Rank 1)
            { 1978, Team.Universal, Race.Universal, Class.Hunter, 4, -1, false, Config.EnableClassSpells }, --Serpent Sting (Rank 1)
            { 13163, Team.Universal, Race.Universal, Class.Hunter, 4, -1, false, Config.EnableClassSpells }, --Aspect of the Monkey
            { 1130, Team.Universal, Race.Universal, Class.Hunter, 6, -1, false, Config.EnableClassSpells }, --Hunter's Mark (Rank 1)
            { 3044, Team.Universal, Race.Universal, Class.Hunter, 6, -1, false, Config.EnableClassSpells }, --Arcane Shot (Rank 1)
            { 5116, Team.Universal, Race.Universal, Class.Hunter, 8, -1, false, Config.EnableClassSpells }, --Concussive Shot
            { 14260, Team.Universal, Race.Universal, Class.Hunter, 8, 2973, false, Config.EnableClassSpells }, --Raptor Strike (Rank 2)
            { 883, Team.Universal, Race.Universal, Class.Hunter, 10, -1, true, Config.EnableClassSpells }, --Call Pet
            { 982, Team.Universal, Race.Universal, Class.Hunter, 10, 883, true, Config.EnableClassSpells }, --Revive Pet
            { 1515, Team.Universal, Race.Universal, Class.Hunter, 10, 883, true, Config.EnableClassSpells }, --Tame Beast
            { 2641, Team.Universal, Race.Universal, Class.Hunter, 10, 883, true, Config.EnableClassSpells }, --Dismiss Pet
            { 6991, Team.Universal, Race.Universal, Class.Hunter, 10, 883, true, Config.EnableClassSpells }, --Feed Pet
            { 13165, Team.Universal, Race.Universal, Class.Hunter, 10, -1, false, Config.EnableClassSpells }, --Aspect of the Hawk (Rank 1)
            { 13549, Team.Universal, Race.Universal, Class.Hunter, 10, 1978, false, Config.EnableClassSpells }, --Serpent Sting (Rank 2)
            { 19883, Team.Universal, Race.Universal, Class.Hunter, 10, -1, false, Config.EnableClassSpells }, --Track Humanoids
            { 136, Team.Universal, Race.Universal, Class.Hunter, 12, -1, false, Config.EnableClassSpells }, --Mend Pet (Rank 1)
            { 2974, Team.Universal, Race.Universal, Class.Hunter, 12, -1, false, Config.EnableClassSpells }, --Wing Clip
            { 14281, Team.Universal, Race.Universal, Class.Hunter, 12, 3044, false, Config.EnableClassSpells }, --Arcane Shot (Rank 2)
            { 20736, Team.Universal, Race.Universal, Class.Hunter, 12, -1, false, Config.EnableClassSpells }, --Distracting Shot (Rank 1)
            { 1002, Team.Universal, Race.Universal, Class.Hunter, 14, -1, false, Config.EnableClassSpells }, --Eyes of the Beast
            { 1513, Team.Universal, Race.Universal, Class.Hunter, 14, -1, false, Config.EnableClassSpells }, --Scare Beast (Rank 1)
            { 6197, Team.Universal, Race.Universal, Class.Hunter, 14, -1, false, Config.EnableClassSpells }, --Eagle Eye
            { 1495, Team.Universal, Race.Universal, Class.Hunter, 16, -1, false, Config.EnableClassSpells }, --Mongoose Bite (Rank 1)
            { 5118, Team.Universal, Race.Universal, Class.Hunter, 16, -1, false, Config.EnableClassSpells }, --Aspect of the Cheetah
            { 13795, Team.Universal, Race.Universal, Class.Hunter, 16, -1, false, Config.EnableClassSpells }, --Immolation Trap (Rank 1)
            { 14261, Team.Universal, Race.Universal, Class.Hunter, 16, 14260, false, Config.EnableClassSpells }, --Raptor Strike (Rank 3)
            { 2643, Team.Universal, Race.Universal, Class.Hunter, 18, -1, false, Config.EnableClassSpells }, --Multi-Shot (Rank 1)
            { 13550, Team.Universal, Race.Universal, Class.Hunter, 18, 13549, false, Config.EnableClassSpells }, --Serpent Sting (Rank 3)
            { 14318, Team.Universal, Race.Universal, Class.Hunter, 18, 13165, false, Config.EnableClassSpells }, --Aspect of the Hawk (Rank 2)
            { 19884, Team.Universal, Race.Universal, Class.Hunter, 18, -1, false, Config.EnableClassSpells }, --Track Undead
            { 781, Team.Universal, Race.Universal, Class.Hunter, 20, -1, false, Config.EnableClassSpells }, --Disengage
            { 1499, Team.Universal, Race.Universal, Class.Hunter, 20, -1, false, Config.EnableClassSpells }, --Freezing Trap (Rank 1)
            { 3111, Team.Universal, Race.Universal, Class.Hunter, 20, 136, false, Config.EnableClassSpells }, --Mend Pet (Rank 2)
            { 14282, Team.Universal, Race.Universal, Class.Hunter, 20, 14281, false, Config.EnableClassSpells }, --Arcane Shot (Rank 3)
            { 34074, Team.Universal, Race.Universal, Class.Hunter, 20, -1, false, Config.EnableClassSpells }, --Aspect of the Viper
            { 3043, Team.Universal, Race.Universal, Class.Hunter, 22, -1, false, Config.EnableClassSpells }, --Scorpid Sting
            { 14323, Team.Universal, Race.Universal, Class.Hunter, 22, 1130, false, Config.EnableClassSpells }, --Hunter's Mark (Rank 2)
            { 1462, Team.Universal, Race.Universal, Class.Hunter, 24, -1, false, Config.EnableClassSpells }, --Beast Lore
            { 14262, Team.Universal, Race.Universal, Class.Hunter, 24, 14261, false, Config.EnableClassSpells }, --Raptor Strike (Rank 4)
            { 19885, Team.Universal, Race.Universal, Class.Hunter, 24, -1, false, Config.EnableClassSpells }, --Track Hidden
            { 3045, Team.Universal, Race.Universal, Class.Hunter, 26, -1, false, Config.EnableClassSpells }, --Rapid Fire
            { 13551, Team.Universal, Race.Universal, Class.Hunter, 26, 13550, false, Config.EnableClassSpells }, --Serpent Sting (Rank 4)
            { 14302, Team.Universal, Race.Universal, Class.Hunter, 26, 13795, false, Config.EnableClassSpells }, --Immolation Trap (Rank 2)
            { 19880, Team.Universal, Race.Universal, Class.Hunter, 26, -1, false, Config.EnableClassSpells }, --Track Elementals
            { 3661, Team.Universal, Race.Universal, Class.Hunter, 28, 3111, false, Config.EnableClassSpells }, --Mend Pet (Rank 3)
            { 13809, Team.Universal, Race.Universal, Class.Hunter, 28, -1, false, Config.EnableClassSpells }, --Frost Trap
            { 14283, Team.Universal, Race.Universal, Class.Hunter, 28, 14282, false, Config.EnableClassSpells }, --Arcane Shot (Rank 4)
            { 14319, Team.Universal, Race.Universal, Class.Hunter, 28, 14318, false, Config.EnableClassSpells }, --Aspect of the Hawk (Rank 3)
            { 5384, Team.Universal, Race.Universal, Class.Hunter, 30, -1, false, Config.EnableClassSpells }, --Feign Death
            { 13161, Team.Universal, Race.Universal, Class.Hunter, 30, -1, false, Config.EnableClassSpells }, --Aspect of the Beast
            { 14269, Team.Universal, Race.Universal, Class.Hunter, 30, 1495, false, Config.EnableClassSpells }, --Mongoose Bite (Rank 2)
            { 14288, Team.Universal, Race.Universal, Class.Hunter, 30, 2643, false, Config.EnableClassSpells }, --Multi-Shot (Rank 2)
            { 14326, Team.Universal, Race.Universal, Class.Hunter, 30, 1513, false, Config.EnableClassSpells }, --Scare Beast (Rank 2)
            { 1543, Team.Universal, Race.Universal, Class.Hunter, 32, -1, false, Config.EnableClassSpells }, --Flare
            { 14263, Team.Universal, Race.Universal, Class.Hunter, 32, 14262, false, Config.EnableClassSpells }, --Raptor Strike (Rank 5)
            { 19878, Team.Universal, Race.Universal, Class.Hunter, 32, -1, false, Config.EnableClassSpells }, --Track Demons
            { 13552, Team.Universal, Race.Universal, Class.Hunter, 34, 13551, false, Config.EnableClassSpells }, --Serpent Sting (Rank 5)
            { 13813, Team.Universal, Race.Universal, Class.Hunter, 34, -1, false, Config.EnableClassSpells }, --Explosive Trap (Rank 1)
            { 3034, Team.Universal, Race.Universal, Class.Hunter, 36, -1, false, Config.EnableClassSpells }, --Viper Sting
            { 3662, Team.Universal, Race.Universal, Class.Hunter, 36, 3661, false, Config.EnableClassSpells }, --Mend Pet (Rank 4)
            { 14284, Team.Universal, Race.Universal, Class.Hunter, 36, 14283, false, Config.EnableClassSpells }, --Arcane Shot (Rank 5)
            { 14303, Team.Universal, Race.Universal, Class.Hunter, 36, 14302, false, Config.EnableClassSpells }, --Immolation Trap (Rank 3)
            { 14320, Team.Universal, Race.Universal, Class.Hunter, 38, 14319, false, Config.EnableClassSpells }, --Aspect of the Hawk (Rank 4)
            { 1510, Team.Universal, Race.Universal, Class.Hunter, 40, -1, false, Config.EnableClassSpells }, --Volley (Rank 1)
            { 13159, Team.Universal, Race.Universal, Class.Hunter, 40, -1, false, Config.EnableClassSpells }, --Aspect of the Pack
            { 14264, Team.Universal, Race.Universal, Class.Hunter, 40, 14263, false, Config.EnableClassSpells }, --Raptor Strike (Rank 6)
            { 14310, Team.Universal, Race.Universal, Class.Hunter, 40, 1499, false, Config.EnableClassSpells }, --Freezing Trap (Rank 2)
            { 14324, Team.Universal, Race.Universal, Class.Hunter, 40, 14323, false, Config.EnableClassSpells }, --Hunter's Mark (Rank 3)
            { 19882, Team.Universal, Race.Universal, Class.Hunter, 40, -1, false, Config.EnableClassSpells }, --Track Giants
            { 13553, Team.Universal, Race.Universal, Class.Hunter, 42, 13552, false, Config.EnableClassSpells }, --Serpent Sting (Rank 6)
            { 14289, Team.Universal, Race.Universal, Class.Hunter, 42, 14288, false, Config.EnableClassSpells }, --Multi-Shot (Rank 3)
            { 13542, Team.Universal, Race.Universal, Class.Hunter, 44, 3662, false, Config.EnableClassSpells }, --Mend Pet (Rank 5)
            { 14270, Team.Universal, Race.Universal, Class.Hunter, 44, 14269, false, Config.EnableClassSpells }, --Mongoose Bite (Rank 3)
            { 14285, Team.Universal, Race.Universal, Class.Hunter, 44, 14284, false, Config.EnableClassSpells }, --Arcane Shot (Rank 6)
            { 14316, Team.Universal, Race.Universal, Class.Hunter, 44, 13813, false, Config.EnableClassSpells }, --Explosive Trap (Rank 2)
            { 14304, Team.Universal, Race.Universal, Class.Hunter, 46, 14303, false, Config.EnableClassSpells }, --Immolation Trap (Rank 4)
            { 14327, Team.Universal, Race.Universal, Class.Hunter, 46, 14326, false, Config.EnableClassSpells }, --Scare Beast (Rank 3)
            { 20043, Team.Universal, Race.Universal, Class.Hunter, 46, -1, false, Config.EnableClassSpells }, --Aspect of the Wild (Rank 1)
            { 14265, Team.Universal, Race.Universal, Class.Hunter, 48, 14264, false, Config.EnableClassSpells }, --Raptor Strike (Rank 7)
            { 14321, Team.Universal, Race.Universal, Class.Hunter, 48, 14320, false, Config.EnableClassSpells }, --Aspect of the Hawk (Rank 5)
            { 13554, Team.Universal, Race.Universal, Class.Hunter, 50, 13553, false, Config.EnableClassSpells }, --Serpent Sting (Rank 7)
            { 14294, Team.Universal, Race.Universal, Class.Hunter, 50, 1510, false, Config.EnableClassSpells }, --Volley (Rank 2)
            { 19879, Team.Universal, Race.Universal, Class.Hunter, 50, -1, false, Config.EnableClassSpells }, --Track Dragonkin
            { 56641, Team.Universal, Race.Universal, Class.Hunter, 50, -1, false, Config.EnableClassSpells }, --Steady Shot (Rank 1)
            { 13543, Team.Universal, Race.Universal, Class.Hunter, 52, 13542, false, Config.EnableClassSpells }, --Mend Pet (Rank 6)
            { 14286, Team.Universal, Race.Universal, Class.Hunter, 52, 14285, false, Config.EnableClassSpells }, --Arcane Shot (Rank 7)
            { 14290, Team.Universal, Race.Universal, Class.Hunter, 54, 14289, false, Config.EnableClassSpells }, --Multi-Shot (Rank 4)
            { 14317, Team.Universal, Race.Universal, Class.Hunter, 54, 14316, false, Config.EnableClassSpells }, --Explosive Trap (Rank 3)
            { 14266, Team.Universal, Race.Universal, Class.Hunter, 56, 14265, false, Config.EnableClassSpells }, --Raptor Strike (Rank 8)
            { 14305, Team.Universal, Race.Universal, Class.Hunter, 56, 14304, false, Config.EnableClassSpells }, --Immolation Trap (Rank 5)
            { 20190, Team.Universal, Race.Universal, Class.Hunter, 56, 20043, false, Config.EnableClassSpells }, --Aspect of the Wild (Rank 2)
            { 13555, Team.Universal, Race.Universal, Class.Hunter, 58, 13554, false, Config.EnableClassSpells }, --Serpent Sting (Rank 8)
            { 14271, Team.Universal, Race.Universal, Class.Hunter, 58, 14270, false, Config.EnableClassSpells }, --Mongoose Bite (Rank 4)
            { 14295, Team.Universal, Race.Universal, Class.Hunter, 58, 14294, false, Config.EnableClassSpells }, --Volley (Rank 3)
            { 14322, Team.Universal, Race.Universal, Class.Hunter, 58, 14321, false, Config.EnableClassSpells }, --Aspect of the Hawk (Rank 6)
            { 14325, Team.Universal, Race.Universal, Class.Hunter, 58, 14324, false, Config.EnableClassSpells }, --Hunter's Mark (Rank 4)
            { 13544, Team.Universal, Race.Universal, Class.Hunter, 60, 13543, false, Config.EnableClassSpells }, --Mend Pet (Rank 7)
            { 14287, Team.Universal, Race.Universal, Class.Hunter, 60, 14286, false, Config.EnableClassSpells }, --Arcane Shot (Rank 8)
            { 14311, Team.Universal, Race.Universal, Class.Hunter, 60, 14310, false, Config.EnableClassSpells }, --Freezing Trap (Rank 3)
            { 19263, Team.Universal, Race.Universal, Class.Hunter, 60, -1, false, Config.EnableClassSpells }, --Deterrence
            { 19801, Team.Universal, Race.Universal, Class.Hunter, 60, -1, false, Config.EnableClassSpells }, --Tranquilizing Shot
            { 25294, Team.Universal, Race.Universal, Class.Hunter, 60, 14290, false, Config.EnableClassSpells }, --Multi-Shot (Rank 5)
            { 25295, Team.Universal, Race.Universal, Class.Hunter, 60, 13555, false, Config.EnableClassSpells }, --Serpent Sting (Rank 9)
            { 25296, Team.Universal, Race.Universal, Class.Hunter, 60, 14322, false, Config.EnableClassSpells }, --Aspect of the Hawk (Rank 7)
            { 27025, Team.Universal, Race.Universal, Class.Hunter, 61, 14317, false, Config.EnableClassSpells }, --Explosive Trap (Rank 4)
            { 34120, Team.Universal, Race.Universal, Class.Hunter, 62, 56641, false, Config.EnableClassSpells }, --Steady Shot (Rank 2)
            { 27014, Team.Universal, Race.Universal, Class.Hunter, 63, 14266, false, Config.EnableClassSpells }, --Raptor Strike (Rank 9)
            { 27023, Team.Universal, Race.Universal, Class.Hunter, 65, 14305, false, Config.EnableClassSpells }, --Immolation Trap (Rank 6)
            { 34026, Team.Universal, Race.Universal, Class.Hunter, 66, -1, false, Config.EnableClassSpells }, --Kill Command
            { 27016, Team.Universal, Race.Universal, Class.Hunter, 67, 25295, false, Config.EnableClassSpells }, --Serpent Sting (Rank 10)
            { 27021, Team.Universal, Race.Universal, Class.Hunter, 67, 25294, false, Config.EnableClassSpells }, --Multi-Shot (Rank 6)
            { 27022, Team.Universal, Race.Universal, Class.Hunter, 67, 14295, false, Config.EnableClassSpells }, --Volley (Rank 4)
            { 27044, Team.Universal, Race.Universal, Class.Hunter, 68, 25296, false, Config.EnableClassSpells }, --Aspect of the Hawk (Rank 8)
            { 27045, Team.Universal, Race.Universal, Class.Hunter, 68, 20190, false, Config.EnableClassSpells }, --Aspect of the Wild (Rank 3)
            { 27046, Team.Universal, Race.Universal, Class.Hunter, 68, 13544, false, Config.EnableClassSpells }, --Mend Pet (Rank 8)
            { 34600, Team.Universal, Race.Universal, Class.Hunter, 68, -1, false, Config.EnableClassSpells }, --Snake Trap
            { 27019, Team.Universal, Race.Universal, Class.Hunter, 69, 14287, false, Config.EnableClassSpells }, --Arcane Shot (Rank 9)
            { 34477, Team.Universal, Race.Universal, Class.Hunter, 70, -1, false, Config.EnableClassSpells }, --Misdirection
            { 36916, Team.Universal, Race.Universal, Class.Hunter, 70, 14271, false, Config.EnableClassSpells }, --Mongoose Bite (Rank 5)
            { 48995, Team.Universal, Race.Universal, Class.Hunter, 71, 27014, false, Config.EnableClassSpells }, --Raptor Strike (Rank 10)
            { 49051, Team.Universal, Race.Universal, Class.Hunter, 71, 34120, false, Config.EnableClassSpells }, --Steady Shot (Rank 3)
            { 49066, Team.Universal, Race.Universal, Class.Hunter, 71, 27025, false, Config.EnableClassSpells }, --Explosive Trap (Rank 5)
            { 53351, Team.Universal, Race.Universal, Class.Hunter, 71, -1, false, Config.EnableClassSpells }, --Kill Shot (Rank 1)
            { 49055, Team.Universal, Race.Universal, Class.Hunter, 72, 27023, false, Config.EnableClassSpells }, --Immolation Trap (Rank 7)
            { 49000, Team.Universal, Race.Universal, Class.Hunter, 73, 27016, false, Config.EnableClassSpells }, --Serpent Sting (Rank 11)
            { 49044, Team.Universal, Race.Universal, Class.Hunter, 73, 27019, false, Config.EnableClassSpells }, --Arcane Shot (Rank 10)
            { 48989, Team.Universal, Race.Universal, Class.Hunter, 74, 27046, false, Config.EnableClassSpells }, --Mend Pet (Rank 9)
            { 49047, Team.Universal, Race.Universal, Class.Hunter, 74, 27021, false, Config.EnableClassSpells }, --Multi-Shot (Rank 7)
            { 58431, Team.Universal, Race.Universal, Class.Hunter, 74, 27022, false, Config.EnableClassSpells }, --Volley (Rank 5)
            { 61846, Team.Universal, Race.Universal, Class.Hunter, 74, -1, false, Config.EnableClassSpells }, --Aspect of the Dragonhawk (Rank 1)
            { 53271, Team.Universal, Race.Universal, Class.Hunter, 75, -1, false, Config.EnableClassSpells }, --Master's Call
            { 53338, Team.Universal, Race.Universal, Class.Hunter, 75, 14325, false, Config.EnableClassSpells }, --Hunter's Mark (Rank 5)
            { 61005, Team.Universal, Race.Universal, Class.Hunter, 75, 53351, false, Config.EnableClassSpells }, --Kill Shot (Rank 2)
            { 49071, Team.Universal, Race.Universal, Class.Hunter, 76, 27045, false, Config.EnableClassSpells }, --Aspect of the Wild (Rank 4)
            { 48996, Team.Universal, Race.Universal, Class.Hunter, 77, 48995, false, Config.EnableClassSpells }, --Raptor Strike (Rank 11)
            { 49052, Team.Universal, Race.Universal, Class.Hunter, 77, 49051, false, Config.EnableClassSpells }, --Steady Shot (Rank 4)
            { 49067, Team.Universal, Race.Universal, Class.Hunter, 77, 49066, false, Config.EnableClassSpells }, --Explosive Trap (Rank 6)
            { 49056, Team.Universal, Race.Universal, Class.Hunter, 78, 49055, false, Config.EnableClassSpells }, --Immolation Trap (Rank 8)
            { 49001, Team.Universal, Race.Universal, Class.Hunter, 79, 49000, false, Config.EnableClassSpells }, --Serpent Sting (Rank 12)
            { 49045, Team.Universal, Race.Universal, Class.Hunter, 79, 49044, false, Config.EnableClassSpells }, --Arcane Shot (Rank 11)
            { 48990, Team.Universal, Race.Universal, Class.Hunter, 80, 48989, false, Config.EnableClassSpells }, --Mend Pet (Rank 10)
            { 49048, Team.Universal, Race.Universal, Class.Hunter, 80, -1, false, Config.EnableClassSpells }, --Multi-Shot (Rank 8)
            { 53339, Team.Universal, Race.Universal, Class.Hunter, 80, 36916, false, Config.EnableClassSpells }, --Mongoose Bite (Rank 6)
            { 58434, Team.Universal, Race.Universal, Class.Hunter, 80, 58431, false, Config.EnableClassSpells }, --Volley (Rank 6)
            { 60192, Team.Universal, Race.Universal, Class.Hunter, 80, -1, false, Config.EnableClassSpells }, --Freezing Arrow (Rank 1)
            { 61006, Team.Universal, Race.Universal, Class.Hunter, 80, 61005, false, Config.EnableClassSpells }, --Kill Shot (Rank 3)
            { 61847, Team.Universal, Race.Universal, Class.Hunter, 80, 61846, false, Config.EnableClassSpells }, --Aspect of the Dragonhawk (Rank 2)
            { 62757, Team.Universal, Race.Universal, Class.Hunter, 80, -1, false, Config.EnableClassSpells }, --Call Stabled Pet
            -- Rogue
            { 1752, Team.Universal, Race.Universal, Class.Rogue, 1, -1, false, Config.EnableClassSpells }, --Sinister Strike (Rank 1)
            { 1784, Team.Universal, Race.Universal, Class.Rogue, 1, -1, false, Config.EnableClassSpells }, --Stealth
            { 1804, Team.Universal, Race.Universal, Class.Rogue, 1, -1, false, Config.EnableClassSpells }, --Pick Lock
            { 2098, Team.Universal, Race.Universal, Class.Rogue, 1, -1, false, Config.EnableClassSpells }, --Eviscerate (Rank 1)
            { 53, Team.Universal, Race.Universal, Class.Rogue, 4, -1, false, Config.EnableClassSpells }, --Backstab (Rank 1)
            { 921, Team.Universal, Race.Universal, Class.Rogue, 4, -1, false, Config.EnableClassSpells }, --Pick Pocket
            { 1757, Team.Universal, Race.Universal, Class.Rogue, 6, 1752, false, Config.EnableClassSpells }, --Sinister Strike (Rank 2)
            { 1776, Team.Universal, Race.Universal, Class.Rogue, 6, -1, false, Config.EnableClassSpells }, --Gouge
            { 5277, Team.Universal, Race.Universal, Class.Rogue, 8, -1, false, Config.EnableClassSpells }, --Evasion (Rank 1)
            { 6760, Team.Universal, Race.Universal, Class.Rogue, 8, 2098, false, Config.EnableClassSpells }, --Eviscerate (Rank 2)
            { 2983, Team.Universal, Race.Universal, Class.Rogue, 10, -1, false, Config.EnableClassSpells }, --Sprint (Rank 1)
            { 5171, Team.Universal, Race.Universal, Class.Rogue, 10, -1, false, Config.EnableClassSpells }, --Slice and Dice (Rank 1)
            { 6770, Team.Universal, Race.Universal, Class.Rogue, 10, -1, false, Config.EnableClassSpells }, --Sap (Rank 1)
            { 1766, Team.Universal, Race.Universal, Class.Rogue, 12, -1, false, Config.EnableClassSpells }, --Kick
            { 2589, Team.Universal, Race.Universal, Class.Rogue, 12, 53, false, Config.EnableClassSpells }, --Backstab (Rank 2)
            { 703, Team.Universal, Race.Universal, Class.Rogue, 14, -1, false, Config.EnableClassSpells }, --Garrote (Rank 1)
            { 1758, Team.Universal, Race.Universal, Class.Rogue, 14, 1757, false, Config.EnableClassSpells }, --Sinister Strike (Rank 3)
            { 8647, Team.Universal, Race.Universal, Class.Rogue, 14, -1, false, Config.EnableClassSpells }, --Expose Armor
            { 1966, Team.Universal, Race.Universal, Class.Rogue, 16, -1, false, Config.EnableClassSpells }, --Feint (Rank 1)
            { 6761, Team.Universal, Race.Universal, Class.Rogue, 16, 6760, false, Config.EnableClassSpells }, --Eviscerate (Rank 3)
            { 8676, Team.Universal, Race.Universal, Class.Rogue, 18, -1, false, Config.EnableClassSpells }, --Ambush (Rank 1)
            { 1943, Team.Universal, Race.Universal, Class.Rogue, 20, -1, false, Config.EnableClassSpells }, --Rupture (Rank 1)
            { 2590, Team.Universal, Race.Universal, Class.Rogue, 20, 2589, false, Config.EnableClassSpells }, --Backstab (Rank 3)
            { 51722, Team.Universal, Race.Universal, Class.Rogue, 20, -1, false, Config.EnableClassSpells }, --Dismantle
            { 1725, Team.Universal, Race.Universal, Class.Rogue, 22, -1, false, Config.EnableClassSpells }, --Distract
            { 1759, Team.Universal, Race.Universal, Class.Rogue, 22, 1758, false, Config.EnableClassSpells }, --Sinister Strike (Rank 4)
            { 1856, Team.Universal, Race.Universal, Class.Rogue, 22, -1, false, Config.EnableClassSpells }, --Vanish (Rank 1)
            { 8631, Team.Universal, Race.Universal, Class.Rogue, 22, 703, false, Config.EnableClassSpells }, --Garrote (Rank 2)
            { 2836, Team.Universal, Race.Universal, Class.Rogue, 24, -1, false, Config.EnableClassSpells }, --Detect Traps (Passive)
            { 6762, Team.Universal, Race.Universal, Class.Rogue, 24, 6761, false, Config.EnableClassSpells }, --Eviscerate (Rank 4)
            { 1833, Team.Universal, Race.Universal, Class.Rogue, 26, -1, false, Config.EnableClassSpells }, --Cheap Shot
            { 8724, Team.Universal, Race.Universal, Class.Rogue, 26, 8676, false, Config.EnableClassSpells }, --Ambush (Rank 2)
            { 2070, Team.Universal, Race.Universal, Class.Rogue, 28, 6770, false, Config.EnableClassSpells }, --Sap (Rank 2)
            { 2591, Team.Universal, Race.Universal, Class.Rogue, 28, 2590, false, Config.EnableClassSpells }, --Backstab (Rank 4)
            { 6768, Team.Universal, Race.Universal, Class.Rogue, 28, 1966, false, Config.EnableClassSpells }, --Feint (Rank 2)
            { 8639, Team.Universal, Race.Universal, Class.Rogue, 28, 1943, false, Config.EnableClassSpells }, --Rupture (Rank 2)
            { 408, Team.Universal, Race.Universal, Class.Rogue, 30, -1, false, Config.EnableClassSpells }, --Kidney Shot (Rank 1)
            { 1760, Team.Universal, Race.Universal, Class.Rogue, 30, 1759, false, Config.EnableClassSpells }, --Sinister Strike (Rank 5)
            { 1842, Team.Universal, Race.Universal, Class.Rogue, 30, -1, false, Config.EnableClassSpells }, --Disarm Trap
            { 8632, Team.Universal, Race.Universal, Class.Rogue, 30, 8631, false, Config.EnableClassSpells }, --Garrote (Rank 3)
            { 8623, Team.Universal, Race.Universal, Class.Rogue, 32, 6762, false, Config.EnableClassSpells }, --Eviscerate (Rank 5)
            { 2094, Team.Universal, Race.Universal, Class.Rogue, 34, -1, false, Config.EnableClassSpells }, --Blind
            { 8696, Team.Universal, Race.Universal, Class.Rogue, 34, 2983, false, Config.EnableClassSpells }, --Sprint (Rank 2)
            { 8725, Team.Universal, Race.Universal, Class.Rogue, 34, 8724, false, Config.EnableClassSpells }, --Ambush (Rank 3)
            { 8640, Team.Universal, Race.Universal, Class.Rogue, 36, 8639, false, Config.EnableClassSpells }, --Rupture (Rank 3)
            { 8721, Team.Universal, Race.Universal, Class.Rogue, 36, 2591, false, Config.EnableClassSpells }, --Backstab (Rank 5)
            { 8621, Team.Universal, Race.Universal, Class.Rogue, 38, 1760, false, Config.EnableClassSpells }, --Sinister Strike (Rank 6)
            { 8633, Team.Universal, Race.Universal, Class.Rogue, 38, 8632, false, Config.EnableClassSpells }, --Garrote (Rank 4)
            { 1860, Team.Universal, Race.Universal, Class.Rogue, 40, -1, false, Config.EnableClassSpells }, --Safe Fall (Passive)
            { 8624, Team.Universal, Race.Universal, Class.Rogue, 40, 8623, false, Config.EnableClassSpells }, --Eviscerate (Rank 6)
            { 8637, Team.Universal, Race.Universal, Class.Rogue, 40, 6768, false, Config.EnableClassSpells }, --Feint (Rank 3)
            { 1857, Team.Universal, Race.Universal, Class.Rogue, 42, 1856, false, Config.EnableClassSpells }, --Vanish (Rank 2)
            { 6774, Team.Universal, Race.Universal, Class.Rogue, 42, 5171, false, Config.EnableClassSpells }, --Slice and Dice (Rank 2)
            { 11267, Team.Universal, Race.Universal, Class.Rogue, 42, 8725, false, Config.EnableClassSpells }, --Ambush (Rank 4)
            { 11273, Team.Universal, Race.Universal, Class.Rogue, 44, 8640, false, Config.EnableClassSpells }, --Rupture (Rank 4)
            { 11279, Team.Universal, Race.Universal, Class.Rogue, 44, 8721, false, Config.EnableClassSpells }, --Backstab (Rank 6)
            { 11289, Team.Universal, Race.Universal, Class.Rogue, 46, 8633, false, Config.EnableClassSpells }, --Garrote (Rank 5)
            { 11293, Team.Universal, Race.Universal, Class.Rogue, 46, 8621, false, Config.EnableClassSpells }, --Sinister Strike (Rank 7)
            { 11297, Team.Universal, Race.Universal, Class.Rogue, 48, 2070, false, Config.EnableClassSpells }, --Sap (Rank 3)
            { 11299, Team.Universal, Race.Universal, Class.Rogue, 48, 8624, false, Config.EnableClassSpells }, --Eviscerate (Rank 7)
            { 8643, Team.Universal, Race.Universal, Class.Rogue, 50, 408, false, Config.EnableClassSpells }, --Kidney Shot (Rank 2)
            { 11268, Team.Universal, Race.Universal, Class.Rogue, 50, 11267, false, Config.EnableClassSpells }, --Ambush (Rank 5)
            { 26669, Team.Universal, Race.Universal, Class.Rogue, 50, 5277, false, Config.EnableClassSpells }, --Evasion (Rank 2)
            { 11274, Team.Universal, Race.Universal, Class.Rogue, 52, 11273, false, Config.EnableClassSpells }, --Rupture (Rank 5)
            { 11280, Team.Universal, Race.Universal, Class.Rogue, 52, 11279, false, Config.EnableClassSpells }, --Backstab (Rank 7)
            { 11303, Team.Universal, Race.Universal, Class.Rogue, 52, 8637, false, Config.EnableClassSpells }, --Feint (Rank 4)
            { 11290, Team.Universal, Race.Universal, Class.Rogue, 54, 11289, false, Config.EnableClassSpells }, --Garrote (Rank 6)
            { 11294, Team.Universal, Race.Universal, Class.Rogue, 54, 11293, false, Config.EnableClassSpells }, --Sinister Strike (Rank 8)
            { 11300, Team.Universal, Race.Universal, Class.Rogue, 56, 11299, false, Config.EnableClassSpells }, --Eviscerate (Rank 8)
            { 11269, Team.Universal, Race.Universal, Class.Rogue, 58, 11268, false, Config.EnableClassSpells }, --Ambush (Rank 6)
            { 11305, Team.Universal, Race.Universal, Class.Rogue, 58, 8696, false, Config.EnableClassSpells }, --Sprint (Rank 3)
            { 11275, Team.Universal, Race.Universal, Class.Rogue, 60, 11274, false, Config.EnableClassSpells }, --Rupture (Rank 6)
            { 11281, Team.Universal, Race.Universal, Class.Rogue, 60, 11280, false, Config.EnableClassSpells }, --Backstab (Rank 8)
            { 25300, Team.Universal, Race.Universal, Class.Rogue, 60, 11281, false, Config.EnableClassSpells }, --Backstab (Rank 9)
            { 25302, Team.Universal, Race.Universal, Class.Rogue, 60, 11303, false, Config.EnableClassSpells }, --Feint (Rank 5)
            { 31016, Team.Universal, Race.Universal, Class.Rogue, 60, 11300, false, Config.EnableClassSpells }, --Eviscerate (Rank 9)
            { 26839, Team.Universal, Race.Universal, Class.Rogue, 61, 11290, false, Config.EnableClassSpells }, --Garrote (Rank 7)
            { 26861, Team.Universal, Race.Universal, Class.Rogue, 62, 11294, false, Config.EnableClassSpells }, --Sinister Strike (Rank 9)
            { 26889, Team.Universal, Race.Universal, Class.Rogue, 62, 1857, false, Config.EnableClassSpells }, --Vanish (Rank 3)
            { 32645, Team.Universal, Race.Universal, Class.Rogue, 62, -1, false, Config.EnableClassSpells }, --Envenom (Rank 1)
            { 26679, Team.Universal, Race.Universal, Class.Rogue, 64, -1, false, Config.EnableClassSpells }, --Deadly Throw (Rank 1)
            { 26865, Team.Universal, Race.Universal, Class.Rogue, 64, 31016, false, Config.EnableClassSpells }, --Eviscerate (Rank 10)
            { 27448, Team.Universal, Race.Universal, Class.Rogue, 64, 25302, false, Config.EnableClassSpells }, --Feint (Rank 6)
            { 27441, Team.Universal, Race.Universal, Class.Rogue, 66, 11269, false, Config.EnableClassSpells }, --Ambush (Rank 7)
            { 31224, Team.Universal, Race.Universal, Class.Rogue, 66, -1, false, Config.EnableClassSpells }, --Cloak of Shadows
            { 26863, Team.Universal, Race.Universal, Class.Rogue, 68, 25300, false, Config.EnableClassSpells }, --Backstab (Rank 10)
            { 26867, Team.Universal, Race.Universal, Class.Rogue, 68, 11275, false, Config.EnableClassSpells }, --Rupture (Rank 7)
            { 32684, Team.Universal, Race.Universal, Class.Rogue, 69, 32645, false, Config.EnableClassSpells }, --Envenom (Rank 2)
            { 5938, Team.Universal, Race.Universal, Class.Rogue, 70, -1, false, Config.EnableClassSpells }, --Shiv
            { 26862, Team.Universal, Race.Universal, Class.Rogue, 70, 26861, false, Config.EnableClassSpells }, --Sinister Strike (Rank 10)
            { 26884, Team.Universal, Race.Universal, Class.Rogue, 70, 26839, false, Config.EnableClassSpells }, --Garrote (Rank 8)
            { 48673, Team.Universal, Race.Universal, Class.Rogue, 70, 26679, false, Config.EnableClassSpells }, --Deadly Throw (Rank 2)
            { 48689, Team.Universal, Race.Universal, Class.Rogue, 70, 27441, false, Config.EnableClassSpells }, --Ambush (Rank 8)
            { 51724, Team.Universal, Race.Universal, Class.Rogue, 71, 11297, false, Config.EnableClassSpells }, --Sap (Rank 4)
            { 48658, Team.Universal, Race.Universal, Class.Rogue, 72, 27448, false, Config.EnableClassSpells }, --Feint (Rank 7)
            { 48667, Team.Universal, Race.Universal, Class.Rogue, 73, 26865, false, Config.EnableClassSpells }, --Eviscerate (Rank 11)
            { 48656, Team.Universal, Race.Universal, Class.Rogue, 74, 26863, false, Config.EnableClassSpells }, --Backstab (Rank 11)
            { 48671, Team.Universal, Race.Universal, Class.Rogue, 74, 26867, false, Config.EnableClassSpells }, --Rupture (Rank 8)
            { 57992, Team.Universal, Race.Universal, Class.Rogue, 74, 32684, false, Config.EnableClassSpells }, --Envenom (Rank 3)
            { 48675, Team.Universal, Race.Universal, Class.Rogue, 75, 26884, false, Config.EnableClassSpells }, --Garrote (Rank 9)
            { 48690, Team.Universal, Race.Universal, Class.Rogue, 75, 48689, false, Config.EnableClassSpells }, --Ambush (Rank 9)
            { 57934, Team.Universal, Race.Universal, Class.Rogue, 75, -1, false, Config.EnableClassSpells }, --Tricks of the Trade
            { 48637, Team.Universal, Race.Universal, Class.Rogue, 76, 26862, false, Config.EnableClassSpells }, --Sinister Strike 11
            { 48674, Team.Universal, Race.Universal, Class.Rogue, 76, 48673, false, Config.EnableClassSpells }, --Deadly Throw (Rank 3)
            { 48659, Team.Universal, Race.Universal, Class.Rogue, 78, 48658, false, Config.EnableClassSpells }, --Feint (Rank 8)
            { 48668, Team.Universal, Race.Universal, Class.Rogue, 79, 48667, false, Config.EnableClassSpells }, --Eviscerate (Rank 12)
            { 48672, Team.Universal, Race.Universal, Class.Rogue, 79, 48671, false, Config.EnableClassSpells }, --Rupture (Rank 9)
            { 48638, Team.Universal, Race.Universal, Class.Rogue, 80, 48637, false, Config.EnableClassSpells }, --Sinister Strike (Rank 12)
            { 48657, Team.Universal, Race.Universal, Class.Rogue, 80, 48656, false, Config.EnableClassSpells }, --Backstab (Rank 12)
            { 48676, Team.Universal, Race.Universal, Class.Rogue, 80, 48675, false, Config.EnableClassSpells }, --Garrote (Rank 10)
            { 48691, Team.Universal, Race.Universal, Class.Rogue, 80, 48690, false, Config.EnableClassSpells }, --Ambush (Rank 10)
            { 51723, Team.Universal, Race.Universal, Class.Rogue, 80, -1, false, Config.EnableClassSpells }, --Fan of Knives
            { 57993, Team.Universal, Race.Universal, Class.Rogue, 80, 57992, false, Config.EnableClassSpells }, --Envenom (Rank 4)
            -- Priest
            { 585, Team.Universal, Race.Universal, Class.Priest, 1, -1, false, Config.EnableClassSpells }, --Smite (Rank 1)
            { 1243, Team.Universal, Race.Universal, Class.Priest, 1, -1, false, Config.EnableClassSpells }, --Power Word: Fortitude (Rank 1)
            { 2050, Team.Universal, Race.Universal, Class.Priest, 1, -1, false, Config.EnableClassSpells }, --Lesser Heal (Rank 1)
            { 589, Team.Universal, Race.Universal, Class.Priest, 4, -1, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 1)
            { 2052, Team.Universal, Race.Universal, Class.Priest, 4, 2050, false, Config.EnableClassSpells }, --Lesser Heal (Rank 2)
            { 17, Team.Universal, Race.Universal, Class.Priest, 6, -1, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 1)
            { 591, Team.Universal, Race.Universal, Class.Priest, 6, 585, false, Config.EnableClassSpells }, --Smite (Rank 2)
            { 139, Team.Universal, Race.Universal, Class.Priest, 8, -1, false, Config.EnableClassSpells }, --Renew (Rank 1)
            { 586, Team.Universal, Race.Universal, Class.Priest, 8, -1, false, Config.EnableClassSpells }, --Fade
            { 594, Team.Universal, Race.Universal, Class.Priest, 10, 589, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 2)
            { 2006, Team.Universal, Race.Universal, Class.Priest, 10, -1, false, Config.EnableClassSpells }, --Resurrection (Rank 1)
            { 2053, Team.Universal, Race.Universal, Class.Priest, 10, 2052, false, Config.EnableClassSpells }, --Lesser Heal (Rank 3)
            { 8092, Team.Universal, Race.Universal, Class.Priest, 10, -1, false, Config.EnableClassSpells }, --Mind Blast (Rank 1)
            { 588, Team.Universal, Race.Universal, Class.Priest, 12, -1, false, Config.EnableClassSpells }, --Inner Fire (Rank 1)
            { 592, Team.Universal, Race.Universal, Class.Priest, 12, 17, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 2)
            { 1244, Team.Universal, Race.Universal, Class.Priest, 12, 1243, false, Config.EnableClassSpells }, --Power Word: Fortitude (Rank 2)
            { 528, Team.Universal, Race.Universal, Class.Priest, 14, -1, false, Config.EnableClassSpells }, --Cure Disease
            { 598, Team.Universal, Race.Universal, Class.Priest, 14, 591, false, Config.EnableClassSpells }, --Smite (Rank 3)
            { 6074, Team.Universal, Race.Universal, Class.Priest, 14, 139, false, Config.EnableClassSpells }, --Renew (Rank 2)
            { 8122, Team.Universal, Race.Universal, Class.Priest, 14, -1, false, Config.EnableClassSpells }, --Psychic Scream (Rank 1)
            { 2054, Team.Universal, Race.Universal, Class.Priest, 16, -1, false, Config.EnableClassSpells }, --Heal (Rank 1)
            { 8102, Team.Universal, Race.Universal, Class.Priest, 16, 8092, false, Config.EnableClassSpells }, --Mind Blast (Rank 2)
            { 527, Team.Universal, Race.Universal, Class.Priest, 18, -1, false, Config.EnableClassSpells }, --Dispel Magic (Rank 1)
            { 600, Team.Universal, Race.Universal, Class.Priest, 18, 592, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 3)
            { 970, Team.Universal, Race.Universal, Class.Priest, 18, 594, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 3)
            { 453, Team.Universal, Race.Universal, Class.Priest, 20, -1, false, Config.EnableClassSpells }, --Mind Soothe
            { 2061, Team.Universal, Race.Universal, Class.Priest, 20, -1, false, Config.EnableClassSpells }, --Flash Heal (Rank 1)
            { 2944, Team.Universal, Race.Universal, Class.Priest, 20, -1, false, Config.EnableClassSpells }, --Devouring Plague (Rank 1)
            { 6075, Team.Universal, Race.Universal, Class.Priest, 20, 6074, false, Config.EnableClassSpells }, --Renew (Rank 3)
            { 6346, Team.Universal, Race.Universal, Class.Priest, 20, -1, false, Config.EnableClassSpells }, --Fear Ward
            { 7128, Team.Universal, Race.Universal, Class.Priest, 20, 588, false, Config.EnableClassSpells }, --Inner Fire (Rank 2)
            { 9484, Team.Universal, Race.Universal, Class.Priest, 20, -1, false, Config.EnableClassSpells }, --Shackle Undead (Rank 1)
            { 14914, Team.Universal, Race.Universal, Class.Priest, 20, -1, false, Config.EnableClassSpells }, --Holy Fire (Rank 1)
            { 15237, Team.Universal, Race.Universal, Class.Priest, 20, -1, false, Config.EnableClassSpells }, --Holy Nova (Rank 1)
            { 984, Team.Universal, Race.Universal, Class.Priest, 22, 598, false, Config.EnableClassSpells }, --Smite (Rank 4)
            { 2010, Team.Universal, Race.Universal, Class.Priest, 22, 2006, false, Config.EnableClassSpells }, --Resurrection (Rank 2)
            { 2055, Team.Universal, Race.Universal, Class.Priest, 22, 2054, false, Config.EnableClassSpells }, --Heal (Rank 2)
            { 2096, Team.Universal, Race.Universal, Class.Priest, 22, -1, false, Config.EnableClassSpells }, --Mind Vision (Rank 1)
            { 8103, Team.Universal, Race.Universal, Class.Priest, 22, 8102, false, Config.EnableClassSpells }, --Mind Blast (Rank 3)
            { 1245, Team.Universal, Race.Universal, Class.Priest, 24, 1244, false, Config.EnableClassSpells }, --Power Word: Fortitude (Rank 3)
            { 3747, Team.Universal, Race.Universal, Class.Priest, 24, 600, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 4)
            { 8129, Team.Universal, Race.Universal, Class.Priest, 24, -1, false, Config.EnableClassSpells }, --Mana Burn
            { 15262, Team.Universal, Race.Universal, Class.Priest, 24, 14914, false, Config.EnableClassSpells }, --Holy Fire (Rank 2)
            { 992, Team.Universal, Race.Universal, Class.Priest, 26, 970, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 4)
            { 6076, Team.Universal, Race.Universal, Class.Priest, 26, 6075, false, Config.EnableClassSpells }, --Renew (Rank 4)
            { 9472, Team.Universal, Race.Universal, Class.Priest, 26, 2061, false, Config.EnableClassSpells }, --Flash Heal (Rank 2)
            { 6063, Team.Universal, Race.Universal, Class.Priest, 28, 2055, false, Config.EnableClassSpells }, --Heal (Rank 3)
            { 8104, Team.Universal, Race.Universal, Class.Priest, 28, 8103, false, Config.EnableClassSpells }, --Mind Blast (Rank 4)
            { 8124, Team.Universal, Race.Universal, Class.Priest, 28, 8122, false, Config.EnableClassSpells }, --Psychic Scream (Rank 2)
            { 15430, Team.Universal, Race.Universal, Class.Priest, 28, 15237, false, Config.EnableClassSpells }, --Holy Nova (Rank 2)
            { 19276, Team.Universal, Race.Universal, Class.Priest, 28, 2944, false, Config.EnableClassSpells }, --Devouring Plague (Rank 2)
            { 596, Team.Universal, Race.Universal, Class.Priest, 30, -1, false, Config.EnableClassSpells }, --Prayer of Healing (Rank 1)
            { 602, Team.Universal, Race.Universal, Class.Priest, 30, 7128, false, Config.EnableClassSpells }, --Inner Fire (Rank 3)
            { 605, Team.Universal, Race.Universal, Class.Priest, 30, -1, false, Config.EnableClassSpells }, --Mind Control
            { 976, Team.Universal, Race.Universal, Class.Priest, 30, -1, false, Config.EnableClassSpells }, --Shadow Protection (Rank 1)
            { 1004, Team.Universal, Race.Universal, Class.Priest, 30, 984, false, Config.EnableClassSpells }, --Smite (Rank 5)
            { 6065, Team.Universal, Race.Universal, Class.Priest, 30, 3747, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 5)
            { 14752, Team.Universal, Race.Universal, Class.Priest, 30, -1, false, Config.EnableClassSpells }, --Divine Spirit (Rank 1)
            { 15263, Team.Universal, Race.Universal, Class.Priest, 30, 15262, false, Config.EnableClassSpells }, --Holy Fire (Rank 3)
            { 552, Team.Universal, Race.Universal, Class.Priest, 32, -1, false, Config.EnableClassSpells }, --Abolish Disease
            { 6077, Team.Universal, Race.Universal, Class.Priest, 32, 6076, false, Config.EnableClassSpells }, --Renew (Rank 5)
            { 9473, Team.Universal, Race.Universal, Class.Priest, 32, 9472, false, Config.EnableClassSpells }, --Flash Heal (Rank 3)
            { 1706, Team.Universal, Race.Universal, Class.Priest, 34, -1, false, Config.EnableClassSpells }, --Levitate
            { 2767, Team.Universal, Race.Universal, Class.Priest, 34, 992, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 5)
            { 6064, Team.Universal, Race.Universal, Class.Priest, 34, 6063, false, Config.EnableClassSpells }, --Heal (Rank 4)
            { 8105, Team.Universal, Race.Universal, Class.Priest, 34, 8104, false, Config.EnableClassSpells }, --Mind Blast (Rank 5)
            { 10880, Team.Universal, Race.Universal, Class.Priest, 34, 2010, false, Config.EnableClassSpells }, --Resurrection (Rank 3)
            { 988, Team.Universal, Race.Universal, Class.Priest, 36, 527, false, Config.EnableClassSpells }, --Dispel Magic (Rank 2)
            { 2791, Team.Universal, Race.Universal, Class.Priest, 36, 1245, false, Config.EnableClassSpells }, --Power Word: Fortitude (Rank 4)
            { 6066, Team.Universal, Race.Universal, Class.Priest, 36, 6065, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 6)
            { 15264, Team.Universal, Race.Universal, Class.Priest, 36, 15263, false, Config.EnableClassSpells }, --Holy Fire (Rank 4)
            { 15431, Team.Universal, Race.Universal, Class.Priest, 36, 15430, false, Config.EnableClassSpells }, --Holy Nova (Rank 3)
            { 19277, Team.Universal, Race.Universal, Class.Priest, 36, 19276, false, Config.EnableClassSpells }, --Devouring Plague (Rank 3)
            { 6060, Team.Universal, Race.Universal, Class.Priest, 38, 1004, false, Config.EnableClassSpells }, --Smite (Rank 6)
            { 6078, Team.Universal, Race.Universal, Class.Priest, 38, 6077, false, Config.EnableClassSpells }, --Renew (Rank 6)
            { 9474, Team.Universal, Race.Universal, Class.Priest, 38, 9473, false, Config.EnableClassSpells }, --Flash Heal (Rank 4)
            { 996, Team.Universal, Race.Universal, Class.Priest, 40, 596, false, Config.EnableClassSpells }, --Prayer of Healing (Rank 2)
            { 1006, Team.Universal, Race.Universal, Class.Priest, 40, 602, false, Config.EnableClassSpells }, --Inner Fire (Rank 4)
            { 2060, Team.Universal, Race.Universal, Class.Priest, 40, -1, false, Config.EnableClassSpells }, --Greater Heal (Rank 1)
            { 8106, Team.Universal, Race.Universal, Class.Priest, 40, 8105, false, Config.EnableClassSpells }, --Mind Blast (Rank 6)
            { 9485, Team.Universal, Race.Universal, Class.Priest, 40, 9484, false, Config.EnableClassSpells }, --Shackle Undead (Rank 2)
            { 14818, Team.Universal, Race.Universal, Class.Priest, 40, 14752, false, Config.EnableClassSpells }, --Divine Spirit (Rank 2)
            { 10888, Team.Universal, Race.Universal, Class.Priest, 42, 8124, false, Config.EnableClassSpells }, --Psychic Scream (Rank 3)
            { 10892, Team.Universal, Race.Universal, Class.Priest, 42, 2767, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 6)
            { 10898, Team.Universal, Race.Universal, Class.Priest, 42, 6066, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 7)
            { 10957, Team.Universal, Race.Universal, Class.Priest, 42, 976, false, Config.EnableClassSpells }, --Shadow Protection (Rank 2)
            { 15265, Team.Universal, Race.Universal, Class.Priest, 42, 15264, false, Config.EnableClassSpells }, --Holy Fire (Rank 5)
            { 10909, Team.Universal, Race.Universal, Class.Priest, 44, 2096, false, Config.EnableClassSpells }, --Mind Vision (Rank 2)
            { 10915, Team.Universal, Race.Universal, Class.Priest, 44, 9474, false, Config.EnableClassSpells }, --Flash Heal (Rank 5)
            { 10927, Team.Universal, Race.Universal, Class.Priest, 44, 6078, false, Config.EnableClassSpells }, --Renew (Rank 7)
            { 19278, Team.Universal, Race.Universal, Class.Priest, 44, 19277, false, Config.EnableClassSpells }, --Devouring Plague (Rank 4)
            { 27799, Team.Universal, Race.Universal, Class.Priest, 44, 15431, false, Config.EnableClassSpells }, --Holy Nova (Rank 4)
            { 10881, Team.Universal, Race.Universal, Class.Priest, 46, 10880, false, Config.EnableClassSpells }, --Resurrection (Rank 4)
            { 10933, Team.Universal, Race.Universal, Class.Priest, 46, 6060, false, Config.EnableClassSpells }, --Smite (Rank 7)
            { 10945, Team.Universal, Race.Universal, Class.Priest, 46, 8106, false, Config.EnableClassSpells }, --Mind Blast (Rank 7)
            { 10963, Team.Universal, Race.Universal, Class.Priest, 46, 2060, false, Config.EnableClassSpells }, --Greater Heal (Rank 2)
            { 10899, Team.Universal, Race.Universal, Class.Priest, 48, 10898, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 8)
            { 10937, Team.Universal, Race.Universal, Class.Priest, 48, 2791, false, Config.EnableClassSpells }, --Power Word: Fortitude (Rank 5)
            { 15266, Team.Universal, Race.Universal, Class.Priest, 48, 15265, false, Config.EnableClassSpells }, --Holy Fire (Rank 6)
            { 21562, Team.Universal, Race.Universal, Class.Priest, 48, -1, false, Config.EnableClassSpells }, --Prayer of Fortitude (Rank 1)
            { 10893, Team.Universal, Race.Universal, Class.Priest, 50, 10892, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 7)
            { 10916, Team.Universal, Race.Universal, Class.Priest, 50, 10915, false, Config.EnableClassSpells }, --Flash Heal (Rank 6)
            { 10928, Team.Universal, Race.Universal, Class.Priest, 50, 10927, false, Config.EnableClassSpells }, --Renew (Rank 8)
            { 10951, Team.Universal, Race.Universal, Class.Priest, 50, 1006, false, Config.EnableClassSpells }, --Inner Fire (Rank 5)
            { 10960, Team.Universal, Race.Universal, Class.Priest, 50, 996, false, Config.EnableClassSpells }, --Prayer of Healing (Rank 3)
            { 14819, Team.Universal, Race.Universal, Class.Priest, 50, 14818, false, Config.EnableClassSpells }, --Divine Spirit (Rank 3)
            { 10946, Team.Universal, Race.Universal, Class.Priest, 52, 10945, false, Config.EnableClassSpells }, --Mind Blast (Rank 8)
            { 10964, Team.Universal, Race.Universal, Class.Priest, 52, 10963, false, Config.EnableClassSpells }, --Greater Heal (Rank 3)
            { 19279, Team.Universal, Race.Universal, Class.Priest, 52, 19278, false, Config.EnableClassSpells }, --Devouring Plague (Rank 5)
            { 27800, Team.Universal, Race.Universal, Class.Priest, 52, 27799, false, Config.EnableClassSpells }, --Holy Nova (Rank 5)
            { 10900, Team.Universal, Race.Universal, Class.Priest, 54, 10899, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 9)
            { 10934, Team.Universal, Race.Universal, Class.Priest, 54, 10933, false, Config.EnableClassSpells }, --Smite (Rank 8)
            { 15267, Team.Universal, Race.Universal, Class.Priest, 54, 15266, false, Config.EnableClassSpells }, --Holy Fire (Rank 7)
            { 10890, Team.Universal, Race.Universal, Class.Priest, 56, 10888, false, Config.EnableClassSpells }, --Psychic Scream (Rank 4)
            { 10917, Team.Universal, Race.Universal, Class.Priest, 56, 10916, false, Config.EnableClassSpells }, --Flash Heal (Rank 7)
            { 10929, Team.Universal, Race.Universal, Class.Priest, 56, 10928, false, Config.EnableClassSpells }, --Renew (Rank 9)
            { 10958, Team.Universal, Race.Universal, Class.Priest, 56, 10957, false, Config.EnableClassSpells }, --Shadow Protection (Rank 3)
            { 27683, Team.Universal, Race.Universal, Class.Priest, 56, -1, false, Config.EnableClassSpells }, --Prayer of Shadow Protection (Rank 1)
            { 10894, Team.Universal, Race.Universal, Class.Priest, 58, 10893, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 8)
            { 10947, Team.Universal, Race.Universal, Class.Priest, 58, 10946, false, Config.EnableClassSpells }, --Mind Blast (Rank 9)
            { 10965, Team.Universal, Race.Universal, Class.Priest, 58, 10964, false, Config.EnableClassSpells }, --Greater Heal (Rank 4)
            { 20770, Team.Universal, Race.Universal, Class.Priest, 58, 10881, false, Config.EnableClassSpells }, --Resurrection (Rank 5)
            { 10901, Team.Universal, Race.Universal, Class.Priest, 60, 10900, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 10)
            { 10938, Team.Universal, Race.Universal, Class.Priest, 60, 10937, false, Config.EnableClassSpells }, --Power Word: Fortitude (Rank 6)
            { 10952, Team.Universal, Race.Universal, Class.Priest, 60, 10951, false, Config.EnableClassSpells }, --Inner Fire (Rank 6)
            { 10955, Team.Universal, Race.Universal, Class.Priest, 60, 9485, false, Config.EnableClassSpells }, --Shackle Undead (Rank 3)
            { 10961, Team.Universal, Race.Universal, Class.Priest, 60, 10960, false, Config.EnableClassSpells }, --Prayer of Healing (Rank 4)
            { 15261, Team.Universal, Race.Universal, Class.Priest, 60, 15267, false, Config.EnableClassSpells }, --Holy Fire (Rank 8)
            { 19280, Team.Universal, Race.Universal, Class.Priest, 60, 19279, false, Config.EnableClassSpells }, --Devouring Plague (Rank 6)
            { 21564, Team.Universal, Race.Universal, Class.Priest, 60, 21562, false, Config.EnableClassSpells }, --Prayer of Fortitude (Rank 2)
            { 25314, Team.Universal, Race.Universal, Class.Priest, 60, 10965, false, Config.EnableClassSpells }, --Greater Heal (Rank 5)
            { 25315, Team.Universal, Race.Universal, Class.Priest, 60, 10929, false, Config.EnableClassSpells }, --Renew (Rank 10)
            { 25316, Team.Universal, Race.Universal, Class.Priest, 60, 10961, false, Config.EnableClassSpells }, --Prayer of Healing (Rank 5)
            { 27681, Team.Universal, Race.Universal, Class.Priest, 60, -1, false, Config.EnableClassSpells }, --Prayer of Spirit (Rank 1)
            { 27801, Team.Universal, Race.Universal, Class.Priest, 60, 27800, false, Config.EnableClassSpells }, --Holy Nova (Rank 6)
            { 27841, Team.Universal, Race.Universal, Class.Priest, 60, 14819, false, Config.EnableClassSpells }, --Divine Spirit (Rank 4)
            { 25233, Team.Universal, Race.Universal, Class.Priest, 61, 10917, false, Config.EnableClassSpells }, --Flash Heal (Rank 8)
            { 25363, Team.Universal, Race.Universal, Class.Priest, 61, 10934, false, Config.EnableClassSpells }, --Smite (Rank 9)
            { 32379, Team.Universal, Race.Universal, Class.Priest, 62, -1, false, Config.EnableClassSpells }, --Shadow Word: Death (Rank 1)
            { 25210, Team.Universal, Race.Universal, Class.Priest, 63, 25314, false, Config.EnableClassSpells }, --Greater Heal (Rank 6)
            { 25372, Team.Universal, Race.Universal, Class.Priest, 63, 10947, false, Config.EnableClassSpells }, --Mind Blast (Rank 10)
            { 32546, Team.Universal, Race.Universal, Class.Priest, 64, -1, false, Config.EnableClassSpells }, --Binding Heal (Rank 1)
            { 25217, Team.Universal, Race.Universal, Class.Priest, 65, 10901, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 11)
            { 25221, Team.Universal, Race.Universal, Class.Priest, 65, 25315, false, Config.EnableClassSpells }, --Renew (Rank 11)
            { 25367, Team.Universal, Race.Universal, Class.Priest, 65, 10894, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 9)
            { 25384, Team.Universal, Race.Universal, Class.Priest, 66, 15261, false, Config.EnableClassSpells }, --Holy Fire (Rank 9)
            { 34433, Team.Universal, Race.Universal, Class.Priest, 66, -1, false, Config.EnableClassSpells }, --Shadowfiend
            { 25235, Team.Universal, Race.Universal, Class.Priest, 67, 25233, false, Config.EnableClassSpells }, --Flash Heal (Rank 9)
            { 25213, Team.Universal, Race.Universal, Class.Priest, 68, 25210, false, Config.EnableClassSpells }, --Greater Heal (Rank 7)
            { 25308, Team.Universal, Race.Universal, Class.Priest, 68, 25316, false, Config.EnableClassSpells }, --Prayer of Healing (Rank 6)
            { 25331, Team.Universal, Race.Universal, Class.Priest, 68, 27801, false, Config.EnableClassSpells }, --Holy Nova (Rank 7)
            { 25433, Team.Universal, Race.Universal, Class.Priest, 68, 10958, false, Config.EnableClassSpells }, --Shadow Protection (Rank 4)
            { 25435, Team.Universal, Race.Universal, Class.Priest, 68, 20770, false, Config.EnableClassSpells }, --Resurrection (Rank 6)
            { 25467, Team.Universal, Race.Universal, Class.Priest, 68, 19280, false, Config.EnableClassSpells }, --Devouring Plague (Rank 7)
            { 33076, Team.Universal, Race.Universal, Class.Priest, 68, -1, false, Config.EnableClassSpells }, --Prayer of Mending (Rank 1)
            { 25364, Team.Universal, Race.Universal, Class.Priest, 69, 25363, false, Config.EnableClassSpells }, --Smite (Rank 10)
            { 25375, Team.Universal, Race.Universal, Class.Priest, 69, 25372, false, Config.EnableClassSpells }, --Mind Blast (Rank 11)
            { 25431, Team.Universal, Race.Universal, Class.Priest, 69, 10952, false, Config.EnableClassSpells }, --Inner Fire (Rank 7)
            { 25218, Team.Universal, Race.Universal, Class.Priest, 70, 25217, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 12)
            { 25222, Team.Universal, Race.Universal, Class.Priest, 70, 25221, false, Config.EnableClassSpells }, --Renew (Rank 12)
            { 25312, Team.Universal, Race.Universal, Class.Priest, 70, 27841, false, Config.EnableClassSpells }, --Divine Spirit (Rank 5)
            { 25368, Team.Universal, Race.Universal, Class.Priest, 70, 25367, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 10)
            { 25389, Team.Universal, Race.Universal, Class.Priest, 70, 10938, false, Config.EnableClassSpells }, --Power Word: Fortitude (Rank 7)
            { 25392, Team.Universal, Race.Universal, Class.Priest, 70, 21564, false, Config.EnableClassSpells }, --Prayer of Fortitude (Rank 3)
            { 32375, Team.Universal, Race.Universal, Class.Priest, 70, -1, false, Config.EnableClassSpells }, --Mass Dispel
            { 32996, Team.Universal, Race.Universal, Class.Priest, 70, 32379, false, Config.EnableClassSpells }, --Shadow Word: Death (Rank 2)
            { 32999, Team.Universal, Race.Universal, Class.Priest, 70, 27681, false, Config.EnableClassSpells }, --Prayer of Spirit (Rank 2)
            { 39374, Team.Universal, Race.Universal, Class.Priest, 70, 27683, false, Config.EnableClassSpells }, --Prayer of Shadow Protection (Rank 2)
            { 48040, Team.Universal, Race.Universal, Class.Priest, 71, 25431, false, Config.EnableClassSpells }, --Inner Fire (Rank 8)
            { 48119, Team.Universal, Race.Universal, Class.Priest, 72, 32546, false, Config.EnableClassSpells }, --Binding Heal (Rank 2)
            { 48134, Team.Universal, Race.Universal, Class.Priest, 72, 25384, false, Config.EnableClassSpells }, --Holy Fire (Rank 10)
            { 48062, Team.Universal, Race.Universal, Class.Priest, 73, 25213, false, Config.EnableClassSpells }, --Greater Heal (Rank 8)
            { 48070, Team.Universal, Race.Universal, Class.Priest, 73, 25235, false, Config.EnableClassSpells }, --Flash Heal (Rank 10)
            { 48299, Team.Universal, Race.Universal, Class.Priest, 73, 25467, false, Config.EnableClassSpells }, --Devouring Plague (Rank 8)
            { 48112, Team.Universal, Race.Universal, Class.Priest, 74, 33076, false, Config.EnableClassSpells }, --Prayer of Mending (Rank 2)
            { 48122, Team.Universal, Race.Universal, Class.Priest, 74, 25364, false, Config.EnableClassSpells }, --Smite (Rank 11)
            { 48126, Team.Universal, Race.Universal, Class.Priest, 74, 25375, false, Config.EnableClassSpells }, --Mind Blast (Rank 12)
            { 48045, Team.Universal, Race.Universal, Class.Priest, 75, -1, false, Config.EnableClassSpells }, --Mind Sear (Rank 1)
            { 48065, Team.Universal, Race.Universal, Class.Priest, 75, 25218, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 13)
            { 48067, Team.Universal, Race.Universal, Class.Priest, 75, 25222, false, Config.EnableClassSpells }, --Renew (Rank 13)
            { 48077, Team.Universal, Race.Universal, Class.Priest, 75, 25331, false, Config.EnableClassSpells }, --Holy Nova (Rank 8)
            { 48124, Team.Universal, Race.Universal, Class.Priest, 75, 25368, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 11)
            { 48157, Team.Universal, Race.Universal, Class.Priest, 75, 32996, false, Config.EnableClassSpells }, --Shadow Word: Death (Rank 3)
            { 48072, Team.Universal, Race.Universal, Class.Priest, 76, 25308, false, Config.EnableClassSpells }, --Prayer of Healing (Rank 7)
            { 48169, Team.Universal, Race.Universal, Class.Priest, 76, 25433, false, Config.EnableClassSpells }, --Shadow Protection (Rank 5)
            { 48168, Team.Universal, Race.Universal, Class.Priest, 77, 48040, false, Config.EnableClassSpells }, --Inner Fire (Rank 9)
            { 48170, Team.Universal, Race.Universal, Class.Priest, 77, 39374, false, Config.EnableClassSpells }, --Prayer of Shadow Protection (Rank 3)
            { 48063, Team.Universal, Race.Universal, Class.Priest, 78, 48062, false, Config.EnableClassSpells }, --Greater Heal (Rank 9)
            { 48120, Team.Universal, Race.Universal, Class.Priest, 78, 48119, false, Config.EnableClassSpells }, --Binding Heal (Rank 3)
            { 48135, Team.Universal, Race.Universal, Class.Priest, 78, 48134, false, Config.EnableClassSpells }, --Holy Fire (Rank 11)
            { 48171, Team.Universal, Race.Universal, Class.Priest, 78, 25435, false, Config.EnableClassSpells }, --Resurrection (Rank 7)
            { 48071, Team.Universal, Race.Universal, Class.Priest, 79, 48070, false, Config.EnableClassSpells }, --Flash Heal (Rank 11)
            { 48113, Team.Universal, Race.Universal, Class.Priest, 79, 48112, false, Config.EnableClassSpells }, --Prayer of Mending (Rank 3)
            { 48123, Team.Universal, Race.Universal, Class.Priest, 79, 48122, false, Config.EnableClassSpells }, --Smite (Rank 12)
            { 48127, Team.Universal, Race.Universal, Class.Priest, 79, 48126, false, Config.EnableClassSpells }, --Mind Blast (Rank 13)
            { 48300, Team.Universal, Race.Universal, Class.Priest, 79, 48299, false, Config.EnableClassSpells }, --Devouring Plague (Rank 9)
            { 48066, Team.Universal, Race.Universal, Class.Priest, 80, 48065, false, Config.EnableClassSpells }, --Power Word: Shield (Rank 14)
            { 48068, Team.Universal, Race.Universal, Class.Priest, 80, 48067, false, Config.EnableClassSpells }, --Renew (Rank 14)
            { 48073, Team.Universal, Race.Universal, Class.Priest, 80, 25312, false, Config.EnableClassSpells }, --Divine Spirit (Rank 6)
            { 48074, Team.Universal, Race.Universal, Class.Priest, 80, 32999, false, Config.EnableClassSpells }, --Prayer of Spirit (Rank 3)
            { 48078, Team.Universal, Race.Universal, Class.Priest, 80, 48077, false, Config.EnableClassSpells }, --Holy Nova (Rank 9)
            { 48125, Team.Universal, Race.Universal, Class.Priest, 80, 48124, false, Config.EnableClassSpells }, --Shadow Word: Pain (Rank 12)
            { 48158, Team.Universal, Race.Universal, Class.Priest, 80, 48157, false, Config.EnableClassSpells }, --Shadow Word: Death (Rank 4)
            { 48161, Team.Universal, Race.Universal, Class.Priest, 80, 25389, false, Config.EnableClassSpells }, --Power Word: Fortitude (Rank 8)
            { 48162, Team.Universal, Race.Universal, Class.Priest, 80, 25392, false, Config.EnableClassSpells }, --Prayer of Fortitude (Rank 4)
            { 53023, Team.Universal, Race.Universal, Class.Priest, 80, 48045, false, Config.EnableClassSpells }, --Mind Sear (Rank 2)
            { 64843, Team.Universal, Race.Universal, Class.Priest, 80, -1, false, Config.EnableClassSpells }, --Divine Hymn (Rank 1)
            { 64901, Team.Universal, Race.Universal, Class.Priest, 80, -1, false, Config.EnableClassSpells }, --Hymn of Hope
            -- Death Knight
            { 45462, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Plague Strike (Rank 1)
            { 45477, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Icy Touch (Rank 1)
            { 45902, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Blood Strike (Rank 1)
            { 47541, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Death Coil (Rank 1)
            { 48266, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Blood Presence
            { 49576, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Death Grip
            { 50977, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Death Gate
            { 53323, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Rune of Swordshattering
            { 53331, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Rune of Lichbane
            { 53342, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Rune of Spellshattering
            { 53344, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Rune of the Fallen Crusader
            { 54446, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Rune of Swordbreaking
            { 54447, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Rune of Spellbreaking
            { 62158, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Rune of the Stoneskin Gargoyle
            { 70164, Team.Universal, Race.Universal, Class.DeathKnight, 55, -1, false, Config.EnableClassSpells }, --Rune of the Nerubian Carapace
            { 46584, Team.Universal, Race.Universal, Class.DeathKnight, 56, -1, false, Config.EnableClassSpells }, --Raise Dead
            { 49998, Team.Universal, Race.Universal, Class.DeathKnight, 56, -1, false, Config.EnableClassSpells }, --Death Strike (Rank 1)
            { 50842, Team.Universal, Race.Universal, Class.DeathKnight, 56, -1, false, Config.EnableClassSpells }, --Pestilence
            { 47528, Team.Universal, Race.Universal, Class.DeathKnight, 57, -1, false, Config.EnableClassSpells }, --Mind Freeze
            { 48263, Team.Universal, Race.Universal, Class.DeathKnight, 57, -1, false, Config.EnableClassSpells }, --Frost Presence
            { 45524, Team.Universal, Race.Universal, Class.DeathKnight, 58, -1, false, Config.EnableClassSpells }, --Chains of Ice
            { 48721, Team.Universal, Race.Universal, Class.DeathKnight, 58, -1, false, Config.EnableClassSpells }, --Blood Boil (Rank 1)
            { 47476, Team.Universal, Race.Universal, Class.DeathKnight, 59, -1, false, Config.EnableClassSpells }, --Strangulate
            { 49926, Team.Universal, Race.Universal, Class.DeathKnight, 59, 45902, false, Config.EnableClassSpells }, --Blood Strike (Rank 2)
            { 43265, Team.Universal, Race.Universal, Class.DeathKnight, 60, -1, false, Config.EnableClassSpells }, --Death and Decay (Rank 1)
            { 49917, Team.Universal, Race.Universal, Class.DeathKnight, 60, 45462, false, Config.EnableClassSpells }, --Plague Strike (Rank 2)
            { 3714, Team.Universal, Race.Universal, Class.DeathKnight, 61, -1, false, Config.EnableClassSpells }, --Path of Frost
            { 49020, Team.Universal, Race.Universal, Class.DeathKnight, 61, -1, false, Config.EnableClassSpells }, --Obliterate (Rank 1)
            { 49896, Team.Universal, Race.Universal, Class.DeathKnight, 61, 45477, false, Config.EnableClassSpells }, --Icy Touch (Rank 2)
            { 48792, Team.Universal, Race.Universal, Class.DeathKnight, 62, -1, false, Config.EnableClassSpells }, --Icebound Fortitude
            { 49892, Team.Universal, Race.Universal, Class.DeathKnight, 62, 47541, false, Config.EnableClassSpells }, --Death Coil (Rank 2)
            { 49999, Team.Universal, Race.Universal, Class.DeathKnight, 63, 49998, false, Config.EnableClassSpells }, --Death Strike (Rank 2)
            { 45529, Team.Universal, Race.Universal, Class.DeathKnight, 64, -1, false, Config.EnableClassSpells }, --Blood Tap
            { 49927, Team.Universal, Race.Universal, Class.DeathKnight, 64, 49926, false, Config.EnableClassSpells }, --Blood Strike (Rank 3)
            { 49918, Team.Universal, Race.Universal, Class.DeathKnight, 65, 49917, false, Config.EnableClassSpells }, --Plague Strike (Rank 3)
            { 56222, Team.Universal, Race.Universal, Class.DeathKnight, 65, -1, false, Config.EnableClassSpells }, --Dark Command
            { 57330, Team.Universal, Race.Universal, Class.DeathKnight, 65, -1, false, Config.EnableClassSpells }, --Horn of Winter (Rank 1)
            { 48743, Team.Universal, Race.Universal, Class.DeathKnight, 66, -1, false, Config.EnableClassSpells }, --Death Pact
            { 49939, Team.Universal, Race.Universal, Class.DeathKnight, 66, 48721, false, Config.EnableClassSpells }, --Blood Boil (Rank 2)
            { 49903, Team.Universal, Race.Universal, Class.DeathKnight, 67, 49896, false, Config.EnableClassSpells }, --Icy Touch (Rank 3)
            { 49936, Team.Universal, Race.Universal, Class.DeathKnight, 67, 43265, false, Config.EnableClassSpells }, --Death and Decay (Rank 2)
            { 51423, Team.Universal, Race.Universal, Class.DeathKnight, 67, 49020, false, Config.EnableClassSpells }, --Obliterate (Rank 2)
            { 56815, Team.Universal, Race.Universal, Class.DeathKnight, 67, -1, false, Config.EnableClassSpells }, --Rune Strike
            { 48707, Team.Universal, Race.Universal, Class.DeathKnight, 68, -1, false, Config.EnableClassSpells }, --Anti-Magic Shell
            { 49893, Team.Universal, Race.Universal, Class.DeathKnight, 68, 49892, false, Config.EnableClassSpells }, --Death Coil (Rank 3)
            { 49928, Team.Universal, Race.Universal, Class.DeathKnight, 69, 49927, false, Config.EnableClassSpells }, --Blood Strike (Rank 4)
            { 45463, Team.Universal, Race.Universal, Class.DeathKnight, 70, 49999, false, Config.EnableClassSpells }, --Death Strike (Rank 3)
            { 48265, Team.Universal, Race.Universal, Class.DeathKnight, 70, -1, false, Config.EnableClassSpells }, --Unholy Presence
            { 49919, Team.Universal, Race.Universal, Class.DeathKnight, 70, 49918, false, Config.EnableClassSpells }, --Plague Strike (Rank 4)
            { 49940, Team.Universal, Race.Universal, Class.DeathKnight, 72, 49939, false, Config.EnableClassSpells }, --Blood Boil (Rank 3)
            { 61999, Team.Universal, Race.Universal, Class.DeathKnight, 72, -1, false, Config.EnableClassSpells }, --Raise Ally
            { 49904, Team.Universal, Race.Universal, Class.DeathKnight, 73, 49903, false, Config.EnableClassSpells }, --Icy Touch (Rank 4)
            { 49937, Team.Universal, Race.Universal, Class.DeathKnight, 73, 49936, false, Config.EnableClassSpells }, --Death and Decay (Rank 3)
            { 51424, Team.Universal, Race.Universal, Class.DeathKnight, 73, 51423, false, Config.EnableClassSpells }, --Obliterate (Rank 3)
            { 49929, Team.Universal, Race.Universal, Class.DeathKnight, 74, 49928, false, Config.EnableClassSpells }, --Blood Strike (Rank 5)
            { 47568, Team.Universal, Race.Universal, Class.DeathKnight, 75, -1, false, Config.EnableClassSpells }, --Empower Rune Weapon
            { 49920, Team.Universal, Race.Universal, Class.DeathKnight, 75, 49919, false, Config.EnableClassSpells }, --Plague Strike (Rank 5)
            { 49923, Team.Universal, Race.Universal, Class.DeathKnight, 75, 45463, false, Config.EnableClassSpells }, --Death Strike (Rank 4)
            { 57623, Team.Universal, Race.Universal, Class.DeathKnight, 75, 57330, false, Config.EnableClassSpells }, --Horn of Winter (Rank 2)
            { 49894, Team.Universal, Race.Universal, Class.DeathKnight, 76, 49893, false, Config.EnableClassSpells }, --Death Coil (Rank 4)
            { 49909, Team.Universal, Race.Universal, Class.DeathKnight, 78, 49904, false, Config.EnableClassSpells }, --Icy Touch (Rank 5)
            { 49941, Team.Universal, Race.Universal, Class.DeathKnight, 78, 49940, false, Config.EnableClassSpells }, --Blood Boil (Rank 4)
            { 51425, Team.Universal, Race.Universal, Class.DeathKnight, 79, 51424, false, Config.EnableClassSpells }, --Obliterate (Rank 4)
            { 42650, Team.Universal, Race.Universal, Class.DeathKnight, 80, -1, false, Config.EnableClassSpells }, --Army of the Dead
            { 49895, Team.Universal, Race.Universal, Class.DeathKnight, 80, 49894, false, Config.EnableClassSpells }, --Death Coil (Rank 5)
            { 49921, Team.Universal, Race.Universal, Class.DeathKnight, 80, 49920, false, Config.EnableClassSpells }, --Plague Strike (Rank 6)
            { 49924, Team.Universal, Race.Universal, Class.DeathKnight, 80, 49923, false, Config.EnableClassSpells }, --Death Strike (Rank 5)
            { 49930, Team.Universal, Race.Universal, Class.DeathKnight, 80, 49929, false, Config.EnableClassSpells }, --Blood Strike (Rank 6)
            { 49938, Team.Universal, Race.Universal, Class.DeathKnight, 80, 49937, false, Config.EnableClassSpells }, --Death and Decay (Rank 4)
            -- Shaman
            { 331, Team.Universal, Race.Universal, Class.Shaman, 1, -1, false, Config.EnableClassSpells }, --Healing Wave (Rank 1)
            { 403, Team.Universal, Race.Universal, Class.Shaman, 1, -1, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 1)
            { 8017, Team.Universal, Race.Universal, Class.Shaman, 1, -1, false, Config.EnableClassSpells }, --Rockbiter Weapon (Rank 1)
            { 8042, Team.Universal, Race.Universal, Class.Shaman, 4, -1, false, Config.EnableClassSpells }, --Earth Shock (Rank 1)
            { 8071, Team.Universal, Race.Universal, Class.Shaman, 4, -1, false, Config.EnableClassSpells }, --Stoneskin Totem (Rank 1)
            { 332, Team.Universal, Race.Universal, Class.Shaman, 6, 331, false, Config.EnableClassSpells }, --Healing Wave (Rank 2)
            { 2484, Team.Universal, Race.Universal, Class.Shaman, 6, -1, false, Config.EnableClassSpells }, --Earthbind Totem
            { 324, Team.Universal, Race.Universal, Class.Shaman, 8, -1, false, Config.EnableClassSpells }, --Lightning Shield (Rank 1)
            { 529, Team.Universal, Race.Universal, Class.Shaman, 8, 403, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 2)
            { 5730, Team.Universal, Race.Universal, Class.Shaman, 8, -1, false, Config.EnableClassSpells }, --Stoneclaw Totem (Rank 1)
            { 8018, Team.Universal, Race.Universal, Class.Shaman, 8, 8017, false, Config.EnableClassSpells }, --Rockbiter Weapon (Rank 2)
            { 8044, Team.Universal, Race.Universal, Class.Shaman, 8, 8042, false, Config.EnableClassSpells }, --Earth Shock (Rank 2)
            { 3599, Team.Universal, Race.Universal, Class.Shaman, 10, -1, false, Config.EnableClassSpells }, --Searing Totem (Rank 1)
            { 8024, Team.Universal, Race.Universal, Class.Shaman, 10, -1, false, Config.EnableClassSpells }, --Flametongue Weapon (Rank 1)
            { 8050, Team.Universal, Race.Universal, Class.Shaman, 10, -1, false, Config.EnableClassSpells }, --Flame Shock (Rank 1)
            { 8075, Team.Universal, Race.Universal, Class.Shaman, 10, -1, false, Config.EnableClassSpells }, --Strength of Earth Totem (Rank 1)
            { 370, Team.Universal, Race.Universal, Class.Shaman, 12, -1, false, Config.EnableClassSpells }, --Purge (Rank 1)
            { 547, Team.Universal, Race.Universal, Class.Shaman, 12, 332, false, Config.EnableClassSpells }, --Healing Wave (Rank 3)
            { 1535, Team.Universal, Race.Universal, Class.Shaman, 12, -1, false, Config.EnableClassSpells }, --Fire Nova (Rank 1)
            { 2008, Team.Universal, Race.Universal, Class.Shaman, 12, -1, false, Config.EnableClassSpells }, --Ancestral Spirit (Rank 1)
            { 548, Team.Universal, Race.Universal, Class.Shaman, 14, 529, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 3)
            { 8045, Team.Universal, Race.Universal, Class.Shaman, 14, 8044, false, Config.EnableClassSpells }, --Earth Shock (Rank 3)
            { 8154, Team.Universal, Race.Universal, Class.Shaman, 14, 8071, false, Config.EnableClassSpells }, --Stoneskin Totem (Rank 2)
            { 325, Team.Universal, Race.Universal, Class.Shaman, 16, 324, false, Config.EnableClassSpells }, --Lightning Shield (Rank 2)
            { 526, Team.Universal, Race.Universal, Class.Shaman, 16, -1, false, Config.EnableClassSpells }, --Cure Toxins
            { 2645, Team.Universal, Race.Universal, Class.Shaman, 16, -1, false, Config.EnableClassSpells }, --Ghost Wolf
            { 8019, Team.Universal, Race.Universal, Class.Shaman, 16, 8018, false, Config.EnableClassSpells }, --Rockbiter Weapon (Rank 3)
            { 57994, Team.Universal, Race.Universal, Class.Shaman, 16, -1, false, Config.EnableClassSpells }, --Wind Shear
            { 913, Team.Universal, Race.Universal, Class.Shaman, 18, 547, false, Config.EnableClassSpells }, --Healing Wave (Rank 4)
            { 6390, Team.Universal, Race.Universal, Class.Shaman, 18, 5730, false, Config.EnableClassSpells }, --Stoneclaw Totem (Rank 2)
            { 8027, Team.Universal, Race.Universal, Class.Shaman, 18, 8024, false, Config.EnableClassSpells }, --Flametongue Weapon (Rank 2)
            { 8052, Team.Universal, Race.Universal, Class.Shaman, 18, 8050, false, Config.EnableClassSpells }, --Flame Shock (Rank 2)
            { 8143, Team.Universal, Race.Universal, Class.Shaman, 18, -1, false, Config.EnableClassSpells }, --Tremor Totem
            { 915, Team.Universal, Race.Universal, Class.Shaman, 20, 548, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 4)
            { 5394, Team.Universal, Race.Universal, Class.Shaman, 20, -1, false, Config.EnableClassSpells }, --Healing Stream Totem (Rank 1)
            { 6363, Team.Universal, Race.Universal, Class.Shaman, 20, 3599, false, Config.EnableClassSpells }, --Searing Totem (Rank 2)
            { 8004, Team.Universal, Race.Universal, Class.Shaman, 20, -1, false, Config.EnableClassSpells }, --Lesser Healing Wave (Rank 1)
            { 8033, Team.Universal, Race.Universal, Class.Shaman, 20, -1, false, Config.EnableClassSpells }, --Frostbrand Weapon (Rank 1)
            { 8056, Team.Universal, Race.Universal, Class.Shaman, 20, -1, false, Config.EnableClassSpells }, --Frost Shock (Rank 1)
            { 52127, Team.Universal, Race.Universal, Class.Shaman, 20, -1, false, Config.EnableClassSpells }, --Water Shield (Rank 1)
            { 131, Team.Universal, Race.Universal, Class.Shaman, 22, -1, false, Config.EnableClassSpells }, --Water Breathing
            { 8498, Team.Universal, Race.Universal, Class.Shaman, 22, 1535, false, Config.EnableClassSpells }, --Fire Nova (Rank 2)
            { 905, Team.Universal, Race.Universal, Class.Shaman, 24, 325, false, Config.EnableClassSpells }, --Lightning Shield (Rank 3)
            { 939, Team.Universal, Race.Universal, Class.Shaman, 24, 913, false, Config.EnableClassSpells }, --Healing Wave (Rank 5)
            { 8046, Team.Universal, Race.Universal, Class.Shaman, 24, 8045, false, Config.EnableClassSpells }, --Earth Shock (Rank 4)
            { 8155, Team.Universal, Race.Universal, Class.Shaman, 24, 8154, false, Config.EnableClassSpells }, --Stoneskin Totem (Rank 3)
            { 8160, Team.Universal, Race.Universal, Class.Shaman, 24, 8075, false, Config.EnableClassSpells }, --Strength of Earth Totem (Rank 2)
            { 8181, Team.Universal, Race.Universal, Class.Shaman, 24, -1, false, Config.EnableClassSpells }, --Frost Resistance Totem (Rank 1)
            { 10399, Team.Universal, Race.Universal, Class.Shaman, 24, 8019, false, Config.EnableClassSpells }, --Rockbiter Weapon (Rank 4)
            { 20609, Team.Universal, Race.Universal, Class.Shaman, 24, 2008, false, Config.EnableClassSpells }, --Ancestral Spirit (Rank 2)
            { 943, Team.Universal, Race.Universal, Class.Shaman, 26, 915, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 5)
            { 5675, Team.Universal, Race.Universal, Class.Shaman, 26, -1, false, Config.EnableClassSpells }, --Mana Spring Totem (Rank 1)
            { 6196, Team.Universal, Race.Universal, Class.Shaman, 26, -1, false, Config.EnableClassSpells }, --Far Sight
            { 8030, Team.Universal, Race.Universal, Class.Shaman, 26, 8027, false, Config.EnableClassSpells }, --Flametongue Weapon (Rank 3)
            { 8190, Team.Universal, Race.Universal, Class.Shaman, 26, -1, false, Config.EnableClassSpells }, --Magma Totem (Rank 1)
            { 546, Team.Universal, Race.Universal, Class.Shaman, 28, -1, false, Config.EnableClassSpells }, --Water Walking
            { 6391, Team.Universal, Race.Universal, Class.Shaman, 28, 6390, false, Config.EnableClassSpells }, --Stoneclaw Totem (Rank 3)
            { 8008, Team.Universal, Race.Universal, Class.Shaman, 28, 8004, false, Config.EnableClassSpells }, --Lesser Healing Wave (Rank 2)
            { 8038, Team.Universal, Race.Universal, Class.Shaman, 28, 8033, false, Config.EnableClassSpells }, --Frostbrand Weapon (Rank 2)
            { 8053, Team.Universal, Race.Universal, Class.Shaman, 28, 8052, false, Config.EnableClassSpells }, --Flame Shock (Rank 3)
            { 8184, Team.Universal, Race.Universal, Class.Shaman, 28, -1, false, Config.EnableClassSpells }, --Fire Resistance Totem (Rank 1)
            { 8227, Team.Universal, Race.Universal, Class.Shaman, 28, -1, false, Config.EnableClassSpells }, --Flametongue Totem (Rank 1)
            { 52129, Team.Universal, Race.Universal, Class.Shaman, 28, 52127, false, Config.EnableClassSpells }, --Water Shield (Rank 2)
            { 556, Team.Universal, Race.Universal, Class.Shaman, 30, -1, false, Config.EnableClassSpells }, --Astral Recall
            { 6364, Team.Universal, Race.Universal, Class.Shaman, 30, 6363, false, Config.EnableClassSpells }, --Searing Totem (Rank 3)
            { 6375, Team.Universal, Race.Universal, Class.Shaman, 30, 5394, false, Config.EnableClassSpells }, --Healing Stream Totem (Rank 2)
            { 8177, Team.Universal, Race.Universal, Class.Shaman, 30, -1, false, Config.EnableClassSpells }, --Grounding Totem
            { 8232, Team.Universal, Race.Universal, Class.Shaman, 30, -1, false, Config.EnableClassSpells }, --Windfury Weapon (Rank 1)
            { 10595, Team.Universal, Race.Universal, Class.Shaman, 30, -1, false, Config.EnableClassSpells }, --Nature Resistance Totem (Rank 1)
            { 20608, Team.Universal, Race.Universal, Class.Shaman, 30, -1, false, Config.EnableClassSpells }, --Reincarnation (Passive)
            { 36936, Team.Universal, Race.Universal, Class.Shaman, 30, -1, false, Config.EnableClassSpells }, --Totemic Recall
            { 51730, Team.Universal, Race.Universal, Class.Shaman, 30, -1, false, Config.EnableClassSpells }, --Earthliving Weapon (Rank 1)
            { 66842, Team.Universal, Race.Universal, Class.Shaman, 30, -1, false, Config.EnableClassSpells }, --Call of the Elements
            { 421, Team.Universal, Race.Universal, Class.Shaman, 32, -1, false, Config.EnableClassSpells }, --Chain Lightning (Rank 1)
            { 945, Team.Universal, Race.Universal, Class.Shaman, 32, 905, false, Config.EnableClassSpells }, --Lightning Shield (Rank 4)
            { 959, Team.Universal, Race.Universal, Class.Shaman, 32, 939, false, Config.EnableClassSpells }, --Healing Wave (Rank 6)
            { 6041, Team.Universal, Race.Universal, Class.Shaman, 32, 943, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 6)
            { 8012, Team.Universal, Race.Universal, Class.Shaman, 32, 370, false, Config.EnableClassSpells }, --Purge (Rank 2)
            { 8499, Team.Universal, Race.Universal, Class.Shaman, 32, 8498, false, Config.EnableClassSpells }, --Fire Nova (Rank 3)
            { 8512, Team.Universal, Race.Universal, Class.Shaman, 32, -1, false, Config.EnableClassSpells }, --Windfury Totem
            { 6495, Team.Universal, Race.Universal, Class.Shaman, 34, -1, false, Config.EnableClassSpells }, --Sentry Totem
            { 8058, Team.Universal, Race.Universal, Class.Shaman, 34, 8056, false, Config.EnableClassSpells }, --Frost Shock (Rank 2)
            { 10406, Team.Universal, Race.Universal, Class.Shaman, 34, 8155, false, Config.EnableClassSpells }, --Stoneskin Totem (Rank 4)
            { 52131, Team.Universal, Race.Universal, Class.Shaman, 34, 52129, false, Config.EnableClassSpells }, --Water Shield (Rank 3)
            { 8010, Team.Universal, Race.Universal, Class.Shaman, 36, 8008, false, Config.EnableClassSpells }, --Lesser Healing Wave (Rank 3)
            { 10412, Team.Universal, Race.Universal, Class.Shaman, 36, 8046, false, Config.EnableClassSpells }, --Earth Shock (Rank 5)
            { 10495, Team.Universal, Race.Universal, Class.Shaman, 36, 5675, false, Config.EnableClassSpells }, --Mana Spring Totem (Rank 2)
            { 10585, Team.Universal, Race.Universal, Class.Shaman, 36, 8190, false, Config.EnableClassSpells }, --Magma Totem (Rank 2)
            { 16339, Team.Universal, Race.Universal, Class.Shaman, 36, 8030, false, Config.EnableClassSpells }, --Flametongue Weapon (Rank 4)
            { 20610, Team.Universal, Race.Universal, Class.Shaman, 36, 20609, false, Config.EnableClassSpells }, --Ancestral Spirit (Rank 3)
            { 6392, Team.Universal, Race.Universal, Class.Shaman, 38, 6391, false, Config.EnableClassSpells }, --Stoneclaw Totem (Rank 4)
            { 8161, Team.Universal, Race.Universal, Class.Shaman, 38, 8160, false, Config.EnableClassSpells }, --Strength of Earth Totem (Rank 3)
            { 8170, Team.Universal, Race.Universal, Class.Shaman, 38, -1, false, Config.EnableClassSpells }, --Cleansing Totem
            { 8249, Team.Universal, Race.Universal, Class.Shaman, 38, 8227, false, Config.EnableClassSpells }, --Flametongue Totem (Rank 2)
            { 10391, Team.Universal, Race.Universal, Class.Shaman, 38, 6041, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 7)
            { 10456, Team.Universal, Race.Universal, Class.Shaman, 38, 8038, false, Config.EnableClassSpells }, --Frostbrand Weapon (Rank 3)
            { 10478, Team.Universal, Race.Universal, Class.Shaman, 38, 8181, false, Config.EnableClassSpells }, --Frost Resistance Totem (Rank 2)
            { 930, Team.Universal, Race.Universal, Class.Shaman, 40, 421, false, Config.EnableClassSpells }, --Chain Lightning (Rank 2)
            { 1064, Team.Universal, Race.Universal, Class.Shaman, 40, -1, false, Config.EnableClassSpells }, --Chain Heal (Rank 1)
            { 6365, Team.Universal, Race.Universal, Class.Shaman, 40, 6364, false, Config.EnableClassSpells }, --Searing Totem (Rank 4)
            { 6377, Team.Universal, Race.Universal, Class.Shaman, 40, 6375, false, Config.EnableClassSpells }, --Healing Stream Totem (Rank 3)
            { 8005, Team.Universal, Race.Universal, Class.Shaman, 40, 959, false, Config.EnableClassSpells }, --Healing Wave (Rank 7)
            { 8134, Team.Universal, Race.Universal, Class.Shaman, 40, 945, false, Config.EnableClassSpells }, --Lightning Shield (Rank 5)
            { 8235, Team.Universal, Race.Universal, Class.Shaman, 40, 8232, false, Config.EnableClassSpells }, --Windfury Weapon (Rank 2)
            { 10447, Team.Universal, Race.Universal, Class.Shaman, 40, 8053, false, Config.EnableClassSpells }, --Flame Shock (Rank 4)
            { 51988, Team.Universal, Race.Universal, Class.Shaman, 40, 51730, false, Config.EnableClassSpells }, --Earthliving Weapon (Rank 2)
            { 66843, Team.Universal, Race.Universal, Class.Shaman, 40, -1, false, Config.EnableClassSpells }, --Call of the Ancestors
            { 52134, Team.Universal, Race.Universal, Class.Shaman, 41, 52131, false, Config.EnableClassSpells }, --Water Shield (Rank 4)
            { 10537, Team.Universal, Race.Universal, Class.Shaman, 42, 8184, false, Config.EnableClassSpells }, --Fire Resistance Totem (Rank 2)
            { 11314, Team.Universal, Race.Universal, Class.Shaman, 42, 8499, false, Config.EnableClassSpells }, --Fire Nova (Rank 4)
            { 10392, Team.Universal, Race.Universal, Class.Shaman, 44, 10391, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 8)
            { 10407, Team.Universal, Race.Universal, Class.Shaman, 44, 10406, false, Config.EnableClassSpells }, --Stoneskin Totem (Rank 5)
            { 10466, Team.Universal, Race.Universal, Class.Shaman, 44, 8010, false, Config.EnableClassSpells }, --Lesser Healing Wave (Rank 4)
            { 10600, Team.Universal, Race.Universal, Class.Shaman, 44, 10595, false, Config.EnableClassSpells }, --Nature Resistance Totem (Rank 2)
            { 10472, Team.Universal, Race.Universal, Class.Shaman, 46, 8058, false, Config.EnableClassSpells }, --Frost Shock (Rank 3)
            { 10496, Team.Universal, Race.Universal, Class.Shaman, 46, 10495, false, Config.EnableClassSpells }, --Mana Spring Totem (Rank 3)
            { 10586, Team.Universal, Race.Universal, Class.Shaman, 46, 10585, false, Config.EnableClassSpells }, --Magma Totem (Rank 3)
            { 10622, Team.Universal, Race.Universal, Class.Shaman, 46, 1064, false, Config.EnableClassSpells }, --Chain Heal (Rank 2)
            { 16341, Team.Universal, Race.Universal, Class.Shaman, 46, 16339, false, Config.EnableClassSpells }, --Flametongue Weapon (Rank 5)
            { 2860, Team.Universal, Race.Universal, Class.Shaman, 48, 930, false, Config.EnableClassSpells }, --Chain Lightning (Rank 3)
            { 10395, Team.Universal, Race.Universal, Class.Shaman, 48, 8005, false, Config.EnableClassSpells }, --Healing Wave (Rank 8)
            { 10413, Team.Universal, Race.Universal, Class.Shaman, 48, 10412, false, Config.EnableClassSpells }, --Earth Shock (Rank 6)
            { 10427, Team.Universal, Race.Universal, Class.Shaman, 48, 6392, false, Config.EnableClassSpells }, --Stoneclaw Totem (Rank 5)
            { 10431, Team.Universal, Race.Universal, Class.Shaman, 48, 8134, false, Config.EnableClassSpells }, --Lightning Shield (Rank 6)
            { 10526, Team.Universal, Race.Universal, Class.Shaman, 48, 8249, false, Config.EnableClassSpells }, --Flametongue Totem (Rank 3)
            { 16355, Team.Universal, Race.Universal, Class.Shaman, 48, 10456, false, Config.EnableClassSpells }, --Frostbrand Weapon (Rank 4)
            { 20776, Team.Universal, Race.Universal, Class.Shaman, 48, 20610, false, Config.EnableClassSpells }, --Ancestral Spirit (Rank 4)
            { 52136, Team.Universal, Race.Universal, Class.Shaman, 48, 52134, false, Config.EnableClassSpells }, --Water Shield (Rank 5)
            { 10437, Team.Universal, Race.Universal, Class.Shaman, 50, 6365, false, Config.EnableClassSpells }, --Searing Totem (Rank 5)
            { 10462, Team.Universal, Race.Universal, Class.Shaman, 50, 6377, false, Config.EnableClassSpells }, --Healing Stream Totem (Rank 4)
            { 10486, Team.Universal, Race.Universal, Class.Shaman, 50, 8235, false, Config.EnableClassSpells }, --Windfury Weapon (Rank 3)
            { 15207, Team.Universal, Race.Universal, Class.Shaman, 50, 10392, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 9)
            { 51991, Team.Universal, Race.Universal, Class.Shaman, 50, 51988, false, Config.EnableClassSpells }, --Earthliving Weapon (Rank 3)
            { 66844, Team.Universal, Race.Universal, Class.Shaman, 50, -1, false, Config.EnableClassSpells }, --Call of the Spirits
            { 10442, Team.Universal, Race.Universal, Class.Shaman, 52, 8161, false, Config.EnableClassSpells }, --Strength of Earth Totem (Rank 4)
            { 10448, Team.Universal, Race.Universal, Class.Shaman, 52, 10447, false, Config.EnableClassSpells }, --Flame Shock (Rank 5)
            { 10467, Team.Universal, Race.Universal, Class.Shaman, 52, 10466, false, Config.EnableClassSpells }, --Lesser Healing Wave (Rank 5)
            { 11315, Team.Universal, Race.Universal, Class.Shaman, 52, 11314, false, Config.EnableClassSpells }, --Fire Nova (Rank 5)
            { 10408, Team.Universal, Race.Universal, Class.Shaman, 54, 10407, false, Config.EnableClassSpells }, --Stoneskin Totem (Rank 6)
            { 10479, Team.Universal, Race.Universal, Class.Shaman, 54, 10478, false, Config.EnableClassSpells }, --Frost Resistance Totem (Rank 3)
            { 10623, Team.Universal, Race.Universal, Class.Shaman, 54, 10622, false, Config.EnableClassSpells }, --Chain Heal (Rank 3)
            { 52138, Team.Universal, Race.Universal, Class.Shaman, 55, 52136, false, Config.EnableClassSpells }, --Water Shield (Rank 6)
            { 10396, Team.Universal, Race.Universal, Class.Shaman, 56, 10395, false, Config.EnableClassSpells }, --Healing Wave (Rank 9)
            { 10432, Team.Universal, Race.Universal, Class.Shaman, 56, 10431, false, Config.EnableClassSpells }, --Lightning Shield (Rank 7)
            { 10497, Team.Universal, Race.Universal, Class.Shaman, 56, 10496, false, Config.EnableClassSpells }, --Mana Spring Totem (Rank 4)
            { 10587, Team.Universal, Race.Universal, Class.Shaman, 56, 10586, false, Config.EnableClassSpells }, --Magma Totem (Rank 4)
            { 10605, Team.Universal, Race.Universal, Class.Shaman, 56, 2860, false, Config.EnableClassSpells }, --Chain Lightning (Rank 4)
            { 15208, Team.Universal, Race.Universal, Class.Shaman, 56, 15207, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 10)
            { 16342, Team.Universal, Race.Universal, Class.Shaman, 56, 16341, false, Config.EnableClassSpells }, --Flametongue Weapon (Rank 6)
            { 10428, Team.Universal, Race.Universal, Class.Shaman, 58, 10427, false, Config.EnableClassSpells }, --Stoneclaw Totem (Rank 6)
            { 10473, Team.Universal, Race.Universal, Class.Shaman, 58, 10472, false, Config.EnableClassSpells }, --Frost Shock (Rank 4)
            { 10538, Team.Universal, Race.Universal, Class.Shaman, 58, 10537, false, Config.EnableClassSpells }, --Fire Resistance Totem (Rank 3)
            { 16356, Team.Universal, Race.Universal, Class.Shaman, 58, 16355, false, Config.EnableClassSpells }, --Frostbrand Weapon (Rank 5)
            { 16387, Team.Universal, Race.Universal, Class.Shaman, 58, 10526, false, Config.EnableClassSpells }, --Flametongue Totem (Rank 4)
            { 10414, Team.Universal, Race.Universal, Class.Shaman, 60, 10413, false, Config.EnableClassSpells }, --Earth Shock (Rank 7)
            { 10438, Team.Universal, Race.Universal, Class.Shaman, 60, 10437, false, Config.EnableClassSpells }, --Searing Totem (Rank 6)
            { 10463, Team.Universal, Race.Universal, Class.Shaman, 60, 10462, false, Config.EnableClassSpells }, --Healing Stream Totem (Rank 5)
            { 10468, Team.Universal, Race.Universal, Class.Shaman, 60, 10467, false, Config.EnableClassSpells }, --Lesser Healing Wave (Rank 6)
            { 10601, Team.Universal, Race.Universal, Class.Shaman, 60, 10600, false, Config.EnableClassSpells }, --Nature Resistance Totem (Rank 3)
            { 16362, Team.Universal, Race.Universal, Class.Shaman, 60, 10486, false, Config.EnableClassSpells }, --Windfury Weapon (Rank 4)
            { 20777, Team.Universal, Race.Universal, Class.Shaman, 60, 20776, false, Config.EnableClassSpells }, --Ancestral Spirit (Rank 5)
            { 25357, Team.Universal, Race.Universal, Class.Shaman, 60, 10396, false, Config.EnableClassSpells }, --Healing Wave (Rank 10)
            { 25361, Team.Universal, Race.Universal, Class.Shaman, 60, 10442, false, Config.EnableClassSpells }, --Strength of Earth Totem (Rank 5)
            { 29228, Team.Universal, Race.Universal, Class.Shaman, 60, 10448, false, Config.EnableClassSpells }, --Flame Shock (Rank 6)
            { 51992, Team.Universal, Race.Universal, Class.Shaman, 60, 51991, false, Config.EnableClassSpells }, --Earthliving Weapon (Rank 4)
            { 25422, Team.Universal, Race.Universal, Class.Shaman, 61, 10623, false, Config.EnableClassSpells }, --Chain Heal (Rank 4)
            { 25546, Team.Universal, Race.Universal, Class.Shaman, 61, 11315, false, Config.EnableClassSpells }, --Fire Nova (Rank 6)
            { 24398, Team.Universal, Race.Universal, Class.Shaman, 62, 52138, false, Config.EnableClassSpells }, --Water Shield (Rank 7)
            { 25448, Team.Universal, Race.Universal, Class.Shaman, 62, 15208, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 11)
            { 25391, Team.Universal, Race.Universal, Class.Shaman, 63, 25357, false, Config.EnableClassSpells }, --Healing Wave (Rank 11)
            { 25439, Team.Universal, Race.Universal, Class.Shaman, 63, 10605, false, Config.EnableClassSpells }, --Chain Lightning (Rank 5)
            { 25469, Team.Universal, Race.Universal, Class.Shaman, 63, 10432, false, Config.EnableClassSpells }, --Lightning Shield (Rank 8)
            { 25508, Team.Universal, Race.Universal, Class.Shaman, 63, 10408, false, Config.EnableClassSpells }, --Stoneskin Totem (Rank 7)
            { 3738, Team.Universal, Race.Universal, Class.Shaman, 64, -1, false, Config.EnableClassSpells }, --Wrath of Air Totem
            { 25489, Team.Universal, Race.Universal, Class.Shaman, 64, 16342, false, Config.EnableClassSpells }, --Flametongue Weapon (Rank 7)
            { 25528, Team.Universal, Race.Universal, Class.Shaman, 65, 25361, false, Config.EnableClassSpells }, --Strength of Earth Totem (Rank 6)
            { 25552, Team.Universal, Race.Universal, Class.Shaman, 65, 10587, false, Config.EnableClassSpells }, --Magma Totem (Rank 5)
            { 25570, Team.Universal, Race.Universal, Class.Shaman, 65, 10497, false, Config.EnableClassSpells }, --Mana Spring Totem (Rank 5)
            { 2062, Team.Universal, Race.Universal, Class.Shaman, 66, -1, false, Config.EnableClassSpells }, --Earth Elemental Totem
            { 25420, Team.Universal, Race.Universal, Class.Shaman, 66, 10468, false, Config.EnableClassSpells }, --Lesser Healing Wave (Rank 7)
            { 25500, Team.Universal, Race.Universal, Class.Shaman, 66, 16356, false, Config.EnableClassSpells }, --Frostbrand Weapon (Rank 6)
            { 25449, Team.Universal, Race.Universal, Class.Shaman, 67, 25448, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 12)
            { 25525, Team.Universal, Race.Universal, Class.Shaman, 67, 10428, false, Config.EnableClassSpells }, --Stoneclaw Totem (Rank 7)
            { 25557, Team.Universal, Race.Universal, Class.Shaman, 67, 16387, false, Config.EnableClassSpells }, --Flametongue Totem (Rank 5)
            { 25560, Team.Universal, Race.Universal, Class.Shaman, 67, 10479, false, Config.EnableClassSpells }, --Frost Resistance Totem (Rank 4)
            { 2894, Team.Universal, Race.Universal, Class.Shaman, 68, -1, false, Config.EnableClassSpells }, --Fire Elemental Totem
            { 25423, Team.Universal, Race.Universal, Class.Shaman, 68, 25422, false, Config.EnableClassSpells }, --Chain Heal (Rank 5)
            { 25464, Team.Universal, Race.Universal, Class.Shaman, 68, 10473, false, Config.EnableClassSpells }, --Frost Shock (Rank 5)
            { 25505, Team.Universal, Race.Universal, Class.Shaman, 68, 16362, false, Config.EnableClassSpells }, --Windfury Weapon (Rank 5)
            { 25563, Team.Universal, Race.Universal, Class.Shaman, 68, 10538, false, Config.EnableClassSpells }, --Fire Resistance Totem (Rank 4)
            { 25454, Team.Universal, Race.Universal, Class.Shaman, 69, 10414, false, Config.EnableClassSpells }, --Earth Shock (Rank 8)
            { 25533, Team.Universal, Race.Universal, Class.Shaman, 69, 10438, false, Config.EnableClassSpells }, --Searing Totem (Rank 7)
            { 25567, Team.Universal, Race.Universal, Class.Shaman, 69, 10463, false, Config.EnableClassSpells }, --Healing Stream Totem (Rank 6)
            { 25574, Team.Universal, Race.Universal, Class.Shaman, 69, 10601, false, Config.EnableClassSpells }, --Nature Resistance Totem (Rank 4)
            { 25590, Team.Universal, Race.Universal, Class.Shaman, 69, 20777, false, Config.EnableClassSpells }, --Ancestral Spirit (Rank 6)
            { 33736, Team.Universal, Race.Universal, Class.Shaman, 69, 24398, false, Config.EnableClassSpells }, --Water Shield (Rank 8)
            { 2825, Team.Universal, Race.Universal, Class.Shaman, 70, -1, false, Config.EnableClassSpells }, --Bloodlust
            { 25396, Team.Universal, Race.Universal, Class.Shaman, 70, 25391, false, Config.EnableClassSpells }, --Healing Wave (Rank 12)
            { 25442, Team.Universal, Race.Universal, Class.Shaman, 70, 25439, false, Config.EnableClassSpells }, --Chain Lightning (Rank 6)
            { 25457, Team.Universal, Race.Universal, Class.Shaman, 70, 29228, false, Config.EnableClassSpells }, --Flame Shock (Rank 7)
            { 25472, Team.Universal, Race.Universal, Class.Shaman, 70, 25469, false, Config.EnableClassSpells }, --Lightning Shield (Rank 9)
            { 25509, Team.Universal, Race.Universal, Class.Shaman, 70, 25508, false, Config.EnableClassSpells }, --Stoneskin Totem (Rank 8)
            { 25547, Team.Universal, Race.Universal, Class.Shaman, 70, 25546, false, Config.EnableClassSpells }, --Fire Nova (Rank 7)
            { 51993, Team.Universal, Race.Universal, Class.Shaman, 70, 51992, false, Config.EnableClassSpells }, --Earthliving Weapon (Rank 5)
            { 58580, Team.Universal, Race.Universal, Class.Shaman, 71, 25525, false, Config.EnableClassSpells }, --Stoneclaw Totem (Rank 8)
            { 58649, Team.Universal, Race.Universal, Class.Shaman, 71, 25557, false, Config.EnableClassSpells }, --Flametongue Totem (Rank 6)
            { 58699, Team.Universal, Race.Universal, Class.Shaman, 71, 25533, false, Config.EnableClassSpells }, --Searing Totem (Rank 8)
            { 58755, Team.Universal, Race.Universal, Class.Shaman, 71, 25567, false, Config.EnableClassSpells }, --Healing Stream Totem (Rank 7)
            { 58771, Team.Universal, Race.Universal, Class.Shaman, 71, 25570, false, Config.EnableClassSpells }, --Mana Spring Totem (Rank 6)
            { 58785, Team.Universal, Race.Universal, Class.Shaman, 71, 25489, false, Config.EnableClassSpells }, --Flametongue Weapon (Rank 8)
            { 58794, Team.Universal, Race.Universal, Class.Shaman, 71, 25500, false, Config.EnableClassSpells }, --Frostbrand Weapon (Rank 7)
            { 58801, Team.Universal, Race.Universal, Class.Shaman, 71, 25505, false, Config.EnableClassSpells }, --Windfury Weapon (Rank 6)
            { 49275, Team.Universal, Race.Universal, Class.Shaman, 72, 25420, false, Config.EnableClassSpells }, --Lesser Healing Wave (Rank 8)
            { 49235, Team.Universal, Race.Universal, Class.Shaman, 73, 25464, false, Config.EnableClassSpells }, --Frost Shock (Rank 6)
            { 49237, Team.Universal, Race.Universal, Class.Shaman, 73, 25449, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 13)
            { 58731, Team.Universal, Race.Universal, Class.Shaman, 73, 25552, false, Config.EnableClassSpells }, --Magma Totem (Rank 6)
            { 58751, Team.Universal, Race.Universal, Class.Shaman, 73, 25509, false, Config.EnableClassSpells }, --Stoneskin Totem (Rank 9)
            { 49230, Team.Universal, Race.Universal, Class.Shaman, 74, 25454, false, Config.EnableClassSpells }, --Earth Shock (Rank 9)
            { 49270, Team.Universal, Race.Universal, Class.Shaman, 74, 25442, false, Config.EnableClassSpells }, --Chain Lightning (Rank 7)
            { 55458, Team.Universal, Race.Universal, Class.Shaman, 74, 25423, false, Config.EnableClassSpells }, --Chain Heal (Rank 6)
            { 49232, Team.Universal, Race.Universal, Class.Shaman, 75, 25457, false, Config.EnableClassSpells }, --Flame Shock (Rank 8)
            { 49272, Team.Universal, Race.Universal, Class.Shaman, 75, 25396, false, Config.EnableClassSpells }, --Healing Wave (Rank 13)
            { 49280, Team.Universal, Race.Universal, Class.Shaman, 75, 25472, false, Config.EnableClassSpells }, --Lightning Shield (Rank 10)
            { 51505, Team.Universal, Race.Universal, Class.Shaman, 75, -1, false, Config.EnableClassSpells }, --Lava Burst (Rank 1)
            { 57622, Team.Universal, Race.Universal, Class.Shaman, 75, 25528, false, Config.EnableClassSpells }, --Strength of Earth Totem (Rank 7)
            { 58581, Team.Universal, Race.Universal, Class.Shaman, 75, 58580, false, Config.EnableClassSpells }, --Stoneclaw Totem (Rank 9)
            { 58652, Team.Universal, Race.Universal, Class.Shaman, 75, 58649, false, Config.EnableClassSpells }, --Flametongue Totem (Rank 7)
            { 58703, Team.Universal, Race.Universal, Class.Shaman, 75, 58699, false, Config.EnableClassSpells }, --Searing Totem (Rank 9)
            { 58737, Team.Universal, Race.Universal, Class.Shaman, 75, 25563, false, Config.EnableClassSpells }, --Fire Resistance Totem (Rank 5)
            { 58741, Team.Universal, Race.Universal, Class.Shaman, 75, 25560, false, Config.EnableClassSpells }, --Frost Resistance Totem (Rank 5)
            { 58746, Team.Universal, Race.Universal, Class.Shaman, 75, 25574, false, Config.EnableClassSpells }, --Nature Resistance Totem (Rank 5)
            { 61649, Team.Universal, Race.Universal, Class.Shaman, 75, 25547, false, Config.EnableClassSpells }, --Fire Nova (Rank 8)
            { 57960, Team.Universal, Race.Universal, Class.Shaman, 76, 33736, false, Config.EnableClassSpells }, --Water Shield (Rank 9)
            { 58756, Team.Universal, Race.Universal, Class.Shaman, 76, 58755, false, Config.EnableClassSpells }, --Healing Stream Totem (Rank 8)
            { 58773, Team.Universal, Race.Universal, Class.Shaman, 76, 58771, false, Config.EnableClassSpells }, --Mana Spring Totem (Rank 7)
            { 58789, Team.Universal, Race.Universal, Class.Shaman, 76, 58785, false, Config.EnableClassSpells }, --Flametongue Weapon (Rank 9)
            { 58795, Team.Universal, Race.Universal, Class.Shaman, 76, 58794, false, Config.EnableClassSpells }, --Frostbrand Weapon (Rank 8)
            { 58803, Team.Universal, Race.Universal, Class.Shaman, 76, 58801, false, Config.EnableClassSpells }, --Windfury Weapon (Rank 7)
            { 49276, Team.Universal, Race.Universal, Class.Shaman, 77, 49275, false, Config.EnableClassSpells }, --Lesser Healing Wave (Rank 9)
            { 49236, Team.Universal, Race.Universal, Class.Shaman, 78, 49235, false, Config.EnableClassSpells }, --Frost Shock (Rank 7)
            { 58582, Team.Universal, Race.Universal, Class.Shaman, 78, 58581, false, Config.EnableClassSpells }, --Stoneclaw Totem (Rank 10)
            { 58734, Team.Universal, Race.Universal, Class.Shaman, 78, 58731, false, Config.EnableClassSpells }, --Magma Totem (Rank 7)
            { 58753, Team.Universal, Race.Universal, Class.Shaman, 78, 58751, false, Config.EnableClassSpells }, --Stoneskin Totem (Rank 10)
            { 49231, Team.Universal, Race.Universal, Class.Shaman, 79, 49230, false, Config.EnableClassSpells }, --Earth Shock (Rank 10)
            { 49238, Team.Universal, Race.Universal, Class.Shaman, 79, 49237, false, Config.EnableClassSpells }, --Lightning Bolt (Rank 14)
            { 49233, Team.Universal, Race.Universal, Class.Shaman, 80, 49232, false, Config.EnableClassSpells }, --Flame Shock (Rank 9)
            { 49271, Team.Universal, Race.Universal, Class.Shaman, 80, 49270, false, Config.EnableClassSpells }, --Chain Lightning (Rank 8)
            { 49273, Team.Universal, Race.Universal, Class.Shaman, 80, 49272, false, Config.EnableClassSpells }, --Healing Wave (Rank 14)
            { 49277, Team.Universal, Race.Universal, Class.Shaman, 80, 25590, false, Config.EnableClassSpells }, --Ancestral Spirit (Rank 7)
            { 49281, Team.Universal, Race.Universal, Class.Shaman, 80, 49280, false, Config.EnableClassSpells }, --Lightning Shield (Rank 11)
            { 51514, Team.Universal, Race.Universal, Class.Shaman, 80, -1, false, Config.EnableClassSpells }, --Hex
            { 51994, Team.Universal, Race.Universal, Class.Shaman, 80, 51993, false, Config.EnableClassSpells }, --Earthliving Weapon (Rank 6)
            { 55459, Team.Universal, Race.Universal, Class.Shaman, 80, 55458, false, Config.EnableClassSpells }, --Chain Heal (Rank 7)
            { 58643, Team.Universal, Race.Universal, Class.Shaman, 80, 57622, false, Config.EnableClassSpells }, --Strength of Earth Totem (Rank 8)
            { 58656, Team.Universal, Race.Universal, Class.Shaman, 80, 58652, false, Config.EnableClassSpells }, --Flametongue Totem (Rank 8)
            { 58704, Team.Universal, Race.Universal, Class.Shaman, 80, 58703, false, Config.EnableClassSpells }, --Searing Totem (Rank 10)
            { 58739, Team.Universal, Race.Universal, Class.Shaman, 80, 58737, false, Config.EnableClassSpells }, --Fire Resistance Totem (Rank 6)
            { 58745, Team.Universal, Race.Universal, Class.Shaman, 80, 58741, false, Config.EnableClassSpells }, --Frost Resistance Totem (Rank 6)
            { 58749, Team.Universal, Race.Universal, Class.Shaman, 80, 58746, false, Config.EnableClassSpells }, --Nature Resistance Totem (Rank 6)
            { 58757, Team.Universal, Race.Universal, Class.Shaman, 80, 58756, false, Config.EnableClassSpells }, --Healing Stream Totem (Rank 9)
            { 58774, Team.Universal, Race.Universal, Class.Shaman, 80, 58773, false, Config.EnableClassSpells }, --Mana Spring Totem (Rank 8)
            { 58790, Team.Universal, Race.Universal, Class.Shaman, 80, 58789, false, Config.EnableClassSpells }, --Flametongue Weapon (Rank 10)
            { 58796, Team.Universal, Race.Universal, Class.Shaman, 80, 58795, false, Config.EnableClassSpells }, --Frostbrand Weapon (Rank 9)
            { 58804, Team.Universal, Race.Universal, Class.Shaman, 80, 58803, false, Config.EnableClassSpells }, --Windfury Weapon (Rank 8)
            { 60043, Team.Universal, Race.Universal, Class.Shaman, 80, 51505, false, Config.EnableClassSpells }, --Lava Burst (Rank 2)
            { 61657, Team.Universal, Race.Universal, Class.Shaman, 80, 61649, false, Config.EnableClassSpells }, --Fire Nova (Rank 9)
            -- Mage
            { 133, Team.Universal, Race.Universal, Class.Mage, 1, -1, false, Config.EnableClassSpells }, --Fireball (Rank 1)
            { 168, Team.Universal, Race.Universal, Class.Mage, 1, -1, false, Config.EnableClassSpells }, --Frost Armor (Rank 1)
            { 1459, Team.Universal, Race.Universal, Class.Mage, 1, -1, false, Config.EnableClassSpells }, --Arcane Intellect (Rank 1)
            { 116, Team.Universal, Race.Universal, Class.Mage, 4, -1, false, Config.EnableClassSpells }, --Frostbolt (Rank 1)
            { 5504, Team.Universal, Race.Universal, Class.Mage, 4, -1, false, Config.EnableClassSpells }, --Conjure Water (Rank 1)
            { 143, Team.Universal, Race.Universal, Class.Mage, 6, 133, false, Config.EnableClassSpells }, --Fireball (Rank 2)
            { 587, Team.Universal, Race.Universal, Class.Mage, 6, -1, false, Config.EnableClassSpells }, --Conjure Food (Rank 1)
            { 2136, Team.Universal, Race.Universal, Class.Mage, 6, -1, false, Config.EnableClassSpells }, --Fire Blast (Rank 1)
            { 118, Team.Universal, Race.Universal, Class.Mage, 8, -1, false, Config.EnableClassSpells }, --Polymorph (Rank 1)
            { 205, Team.Universal, Race.Universal, Class.Mage, 8, 116, false, Config.EnableClassSpells }, --Frostbolt (Rank 2)
            { 5143, Team.Universal, Race.Universal, Class.Mage, 8, -1, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 1)
            { 122, Team.Universal, Race.Universal, Class.Mage, 10, -1, false, Config.EnableClassSpells }, --Frost Nova (Rank 1)
            { 5505, Team.Universal, Race.Universal, Class.Mage, 10, 5504, false, Config.EnableClassSpells }, --Conjure Water (Rank 2)
            { 7300, Team.Universal, Race.Universal, Class.Mage, 10, 168, false, Config.EnableClassSpells }, --Frost Armor (Rank 2)
            { 130, Team.Universal, Race.Universal, Class.Mage, 12, -1, false, Config.EnableClassSpells }, --Slow Fall
            { 145, Team.Universal, Race.Universal, Class.Mage, 12, 143, false, Config.EnableClassSpells }, --Fireball (Rank 3)
            { 597, Team.Universal, Race.Universal, Class.Mage, 12, 587, false, Config.EnableClassSpells }, --Conjure Food (Rank 2)
            { 604, Team.Universal, Race.Universal, Class.Mage, 12, -1, false, Config.EnableClassSpells }, --Dampen Magic (Rank 1)
            { 837, Team.Universal, Race.Universal, Class.Mage, 14, 205, false, Config.EnableClassSpells }, --Frostbolt (Rank 3)
            { 1449, Team.Universal, Race.Universal, Class.Mage, 14, -1, false, Config.EnableClassSpells }, --Arcane Explosion (Rank 1)
            { 1460, Team.Universal, Race.Universal, Class.Mage, 14, 1459, false, Config.EnableClassSpells }, --Arcane Intellect (Rank 2)
            { 2137, Team.Universal, Race.Universal, Class.Mage, 14, 2136, false, Config.EnableClassSpells }, --Fire Blast (Rank 2)
            { 2120, Team.Universal, Race.Universal, Class.Mage, 16, -1, false, Config.EnableClassSpells }, --Flamestrike (Rank 1)
            { 5144, Team.Universal, Race.Universal, Class.Mage, 16, 5143, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 2)
            { 475, Team.Universal, Race.Universal, Class.Mage, 18, -1, false, Config.EnableClassSpells }, --Remove Curse
            { 1008, Team.Universal, Race.Universal, Class.Mage, 18, -1, false, Config.EnableClassSpells }, --Amplify Magic (Rank 1)
            { 3140, Team.Universal, Race.Universal, Class.Mage, 18, 145, false, Config.EnableClassSpells }, --Fireball (Rank 4)
            { 10, Team.Universal, Race.Universal, Class.Mage, 20, -1, false, Config.EnableClassSpells }, --Blizzard (Rank 1)
            { 543, Team.Universal, Race.Universal, Class.Mage, 20, -1, false, Config.EnableClassSpells }, --Fire Ward (Rank 1)
            { 1463, Team.Universal, Race.Universal, Class.Mage, 20, -1, false, Config.EnableClassSpells }, --Mana Shield (Rank 1)
            { 1953, Team.Universal, Race.Universal, Class.Mage, 20, -1, false, Config.EnableClassSpells }, --Blink
            { 5506, Team.Universal, Race.Universal, Class.Mage, 20, 5505, false, Config.EnableClassSpells }, --Conjure Water (Rank 3)
            { 7301, Team.Universal, Race.Universal, Class.Mage, 20, 7300, false, Config.EnableClassSpells }, --Frost Armor (Rank 3)
            { 7322, Team.Universal, Race.Universal, Class.Mage, 20, 837, false, Config.EnableClassSpells }, --Frostbolt (Rank 4)
            { 12051, Team.Universal, Race.Universal, Class.Mage, 20, -1, false, Config.EnableClassSpells }, --Evocation
            { 12824, Team.Universal, Race.Universal, Class.Mage, 20, 118, false, Config.EnableClassSpells }, --Polymorph (Rank 2)
            { 990, Team.Universal, Race.Universal, Class.Mage, 22, 597, false, Config.EnableClassSpells }, --Conjure Food (Rank 3)
            { 2138, Team.Universal, Race.Universal, Class.Mage, 22, 2137, false, Config.EnableClassSpells }, --Fire Blast (Rank 3)
            { 2948, Team.Universal, Race.Universal, Class.Mage, 22, -1, false, Config.EnableClassSpells }, --Scorch (Rank 1)
            { 6143, Team.Universal, Race.Universal, Class.Mage, 22, -1, false, Config.EnableClassSpells }, --Frost Ward (Rank 1)
            { 8437, Team.Universal, Race.Universal, Class.Mage, 22, 1449, false, Config.EnableClassSpells }, --Arcane Explosion (Rank 2)
            { 2121, Team.Universal, Race.Universal, Class.Mage, 24, 2120, false, Config.EnableClassSpells }, --Flamestrike (Rank 2)
            { 2139, Team.Universal, Race.Universal, Class.Mage, 24, -1, false, Config.EnableClassSpells }, --Counterspell
            { 5145, Team.Universal, Race.Universal, Class.Mage, 24, 5144, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 3)
            { 8400, Team.Universal, Race.Universal, Class.Mage, 24, 3140, false, Config.EnableClassSpells }, --Fireball (Rank 5)
            { 8450, Team.Universal, Race.Universal, Class.Mage, 24, 604, false, Config.EnableClassSpells }, --Dampen Magic (Rank 2)
            { 120, Team.Universal, Race.Universal, Class.Mage, 26, -1, false, Config.EnableClassSpells }, --Cone of Cold (Rank 1)
            { 865, Team.Universal, Race.Universal, Class.Mage, 26, 122, false, Config.EnableClassSpells }, --Frost Nova (Rank 2)
            { 8406, Team.Universal, Race.Universal, Class.Mage, 26, 7322, false, Config.EnableClassSpells }, --Frostbolt (Rank 5)
            { 759, Team.Universal, Race.Universal, Class.Mage, 28, -1, false, Config.EnableClassSpells }, --Conjure Mana Gem (Rank 1)
            { 1461, Team.Universal, Race.Universal, Class.Mage, 28, 1460, false, Config.EnableClassSpells }, --Arcane Intellect (Rank 3)
            { 6141, Team.Universal, Race.Universal, Class.Mage, 28, 10, false, Config.EnableClassSpells }, --Blizzard (Rank 2)
            { 8444, Team.Universal, Race.Universal, Class.Mage, 28, 2948, false, Config.EnableClassSpells }, --Scorch (Rank 2)
            { 8494, Team.Universal, Race.Universal, Class.Mage, 28, 1463, false, Config.EnableClassSpells }, --Mana Shield (Rank 2)
            { 6127, Team.Universal, Race.Universal, Class.Mage, 30, 5506, false, Config.EnableClassSpells }, --Conjure Water (Rank 4)
            { 7302, Team.Universal, Race.Universal, Class.Mage, 30, -1, false, Config.EnableClassSpells }, --Ice Armor (Rank 1)
            { 8401, Team.Universal, Race.Universal, Class.Mage, 30, 8400, false, Config.EnableClassSpells }, --Fireball (Rank 6)
            { 8412, Team.Universal, Race.Universal, Class.Mage, 30, 2138, false, Config.EnableClassSpells }, --Fire Blast (Rank 4)
            { 8438, Team.Universal, Race.Universal, Class.Mage, 30, 8437, false, Config.EnableClassSpells }, --Arcane Explosion (Rank 3)
            { 8455, Team.Universal, Race.Universal, Class.Mage, 30, 1008, false, Config.EnableClassSpells }, --Amplify Magic (Rank 2)
            { 8457, Team.Universal, Race.Universal, Class.Mage, 30, 543, false, Config.EnableClassSpells }, --Fire Ward (Rank 2)
            { 45438, Team.Universal, Race.Universal, Class.Mage, 30, -1, false, Config.EnableClassSpells }, --Ice Block
            { 6129, Team.Universal, Race.Universal, Class.Mage, 32, 990, false, Config.EnableClassSpells }, --Conjure Food (Rank 4)
            { 8407, Team.Universal, Race.Universal, Class.Mage, 32, 8406, false, Config.EnableClassSpells }, --Frostbolt (Rank 6)
            { 8416, Team.Universal, Race.Universal, Class.Mage, 32, 5145, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 4)
            { 8422, Team.Universal, Race.Universal, Class.Mage, 32, 2121, false, Config.EnableClassSpells }, --Flamestrike (Rank 3)
            { 8461, Team.Universal, Race.Universal, Class.Mage, 32, 6143, false, Config.EnableClassSpells }, --Frost Ward (Rank 2)
            { 6117, Team.Universal, Race.Universal, Class.Mage, 34, -1, false, Config.EnableClassSpells }, --Mage Armor (Rank 1)
            { 8445, Team.Universal, Race.Universal, Class.Mage, 34, 8444, false, Config.EnableClassSpells }, --Scorch (Rank 3)
            { 8492, Team.Universal, Race.Universal, Class.Mage, 34, 120, false, Config.EnableClassSpells }, --Cone of Cold (Rank 2)
            { 8402, Team.Universal, Race.Universal, Class.Mage, 36, 8401, false, Config.EnableClassSpells }, --Fireball (Rank 7)
            { 8427, Team.Universal, Race.Universal, Class.Mage, 36, 6141, false, Config.EnableClassSpells }, --Blizzard (Rank 3)
            { 8451, Team.Universal, Race.Universal, Class.Mage, 36, 8450, false, Config.EnableClassSpells }, --Dampen Magic (Rank 3)
            { 8495, Team.Universal, Race.Universal, Class.Mage, 36, 8494, false, Config.EnableClassSpells }, --Mana Shield (Rank 3)
            { 3552, Team.Universal, Race.Universal, Class.Mage, 38, 759, false, Config.EnableClassSpells }, --Conjure Mana Gem (Rank 2)
            { 8408, Team.Universal, Race.Universal, Class.Mage, 38, 8407, false, Config.EnableClassSpells }, --Frostbolt (Rank 7)
            { 8413, Team.Universal, Race.Universal, Class.Mage, 38, 8412, false, Config.EnableClassSpells }, --Fire Blast (Rank 5)
            { 8439, Team.Universal, Race.Universal, Class.Mage, 38, 8438, false, Config.EnableClassSpells }, --Arcane Explosion (Rank 4)
            { 6131, Team.Universal, Race.Universal, Class.Mage, 40, 865, false, Config.EnableClassSpells }, --Frost Nova (Rank 3)
            { 7320, Team.Universal, Race.Universal, Class.Mage, 40, 7302, false, Config.EnableClassSpells }, --Ice Armor (Rank 2)
            { 8417, Team.Universal, Race.Universal, Class.Mage, 40, 8416, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 5)
            { 8423, Team.Universal, Race.Universal, Class.Mage, 40, 8422, false, Config.EnableClassSpells }, --Flamestrike (Rank 4)
            { 8446, Team.Universal, Race.Universal, Class.Mage, 40, 8445, false, Config.EnableClassSpells }, --Scorch (Rank 4)
            { 8458, Team.Universal, Race.Universal, Class.Mage, 40, 8457, false, Config.EnableClassSpells }, --Fire Ward (Rank 3)
            { 10138, Team.Universal, Race.Universal, Class.Mage, 40, 6127, false, Config.EnableClassSpells }, --Conjure Water (Rank 5)
            { 12825, Team.Universal, Race.Universal, Class.Mage, 40, 12824, false, Config.EnableClassSpells }, --Polymorph (Rank 3)
            { 8462, Team.Universal, Race.Universal, Class.Mage, 42, 8461, false, Config.EnableClassSpells }, --Frost Ward (Rank 3)
            { 10144, Team.Universal, Race.Universal, Class.Mage, 42, 6129, false, Config.EnableClassSpells }, --Conjure Food (Rank 5)
            { 10148, Team.Universal, Race.Universal, Class.Mage, 42, 8402, false, Config.EnableClassSpells }, --Fireball (Rank 8)
            { 10156, Team.Universal, Race.Universal, Class.Mage, 42, 1461, false, Config.EnableClassSpells }, --Arcane Intellect (Rank 4)
            { 10159, Team.Universal, Race.Universal, Class.Mage, 42, 8492, false, Config.EnableClassSpells }, --Cone of Cold (Rank 3)
            { 10169, Team.Universal, Race.Universal, Class.Mage, 42, 8455, false, Config.EnableClassSpells }, --Amplify Magic (Rank 3)
            { 10179, Team.Universal, Race.Universal, Class.Mage, 44, 8408, false, Config.EnableClassSpells }, --Frostbolt (Rank 8)
            { 10185, Team.Universal, Race.Universal, Class.Mage, 44, 8427, false, Config.EnableClassSpells }, --Blizzard (Rank 4)
            { 10191, Team.Universal, Race.Universal, Class.Mage, 44, 8495, false, Config.EnableClassSpells }, --Mana Shield (Rank 4)
            { 10197, Team.Universal, Race.Universal, Class.Mage, 46, 8413, false, Config.EnableClassSpells }, --Fire Blast (Rank 6)
            { 10201, Team.Universal, Race.Universal, Class.Mage, 46, 8439, false, Config.EnableClassSpells }, --Arcane Explosion (Rank 5)
            { 10205, Team.Universal, Race.Universal, Class.Mage, 46, 8446, false, Config.EnableClassSpells }, --Scorch (Rank 5)
            { 22782, Team.Universal, Race.Universal, Class.Mage, 46, 6117, false, Config.EnableClassSpells }, --Mage Armor (Rank 2)
            { 10053, Team.Universal, Race.Universal, Class.Mage, 48, 3552, false, Config.EnableClassSpells }, --Conjure Mana Gem (Rank 3)
            { 10149, Team.Universal, Race.Universal, Class.Mage, 48, 10148, false, Config.EnableClassSpells }, --Fireball (Rank 9)
            { 10173, Team.Universal, Race.Universal, Class.Mage, 48, 8451, false, Config.EnableClassSpells }, --Dampen Magic (Rank 4)
            { 10211, Team.Universal, Race.Universal, Class.Mage, 48, 8417, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 6)
            { 10215, Team.Universal, Race.Universal, Class.Mage, 48, 8423, false, Config.EnableClassSpells }, --Flamestrike (Rank 5)
            { 10139, Team.Universal, Race.Universal, Class.Mage, 50, 10138, false, Config.EnableClassSpells }, --Conjure Water (Rank 6)
            { 10160, Team.Universal, Race.Universal, Class.Mage, 50, 10159, false, Config.EnableClassSpells }, --Cone of Cold (Rank 4)
            { 10180, Team.Universal, Race.Universal, Class.Mage, 50, 10179, false, Config.EnableClassSpells }, --Frostbolt (Rank 9)
            { 10219, Team.Universal, Race.Universal, Class.Mage, 50, 7320, false, Config.EnableClassSpells }, --Ice Armor (Rank 3)
            { 10223, Team.Universal, Race.Universal, Class.Mage, 50, 8458, false, Config.EnableClassSpells }, --Fire Ward (Rank 4)
            { 10145, Team.Universal, Race.Universal, Class.Mage, 52, 10144, false, Config.EnableClassSpells }, --Conjure Food (Rank 6)
            { 10177, Team.Universal, Race.Universal, Class.Mage, 52, 8462, false, Config.EnableClassSpells }, --Frost Ward (Rank 4)
            { 10186, Team.Universal, Race.Universal, Class.Mage, 52, 10185, false, Config.EnableClassSpells }, --Blizzard (Rank 5)
            { 10192, Team.Universal, Race.Universal, Class.Mage, 52, 10191, false, Config.EnableClassSpells }, --Mana Shield (Rank 5)
            { 10206, Team.Universal, Race.Universal, Class.Mage, 52, 10205, false, Config.EnableClassSpells }, --Scorch (Rank 6)
            { 10150, Team.Universal, Race.Universal, Class.Mage, 54, 10149, false, Config.EnableClassSpells }, --Fireball (Rank 10)
            { 10170, Team.Universal, Race.Universal, Class.Mage, 54, 10169, false, Config.EnableClassSpells }, --Amplify Magic (Rank 4)
            { 10199, Team.Universal, Race.Universal, Class.Mage, 54, 10197, false, Config.EnableClassSpells }, --Fire Blast (Rank 7)
            { 10202, Team.Universal, Race.Universal, Class.Mage, 54, 10201, false, Config.EnableClassSpells }, --Arcane Explosion (Rank 6)
            { 10230, Team.Universal, Race.Universal, Class.Mage, 54, 6131, false, Config.EnableClassSpells }, --Frost Nova (Rank 4)
            { 10157, Team.Universal, Race.Universal, Class.Mage, 56, 10156, false, Config.EnableClassSpells }, --Arcane Intellect (Rank 5)
            { 10181, Team.Universal, Race.Universal, Class.Mage, 56, 10180, false, Config.EnableClassSpells }, --Frostbolt (Rank 10)
            { 10212, Team.Universal, Race.Universal, Class.Mage, 56, 10211, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 7)
            { 10216, Team.Universal, Race.Universal, Class.Mage, 56, 10215, false, Config.EnableClassSpells }, --Flamestrike (Rank 6)
            { 23028, Team.Universal, Race.Universal, Class.Mage, 56, -1, false, Config.EnableClassSpells }, --Arcane Brilliance (Rank 1)
            { 10054, Team.Universal, Race.Universal, Class.Mage, 58, 10053, false, Config.EnableClassSpells }, --Conjure Mana Gem (Rank 4)
            { 10161, Team.Universal, Race.Universal, Class.Mage, 58, 10160, false, Config.EnableClassSpells }, --Cone of Cold (Rank 5)
            { 10207, Team.Universal, Race.Universal, Class.Mage, 58, 10206, false, Config.EnableClassSpells }, --Scorch (Rank 7)
            { 22783, Team.Universal, Race.Universal, Class.Mage, 58, 22782, false, Config.EnableClassSpells }, --Mage Armor (Rank 3)
            { 10140, Team.Universal, Race.Universal, Class.Mage, 60, 10139, false, Config.EnableClassSpells }, --Conjure Water (Rank 7)
            { 10151, Team.Universal, Race.Universal, Class.Mage, 60, 10150, false, Config.EnableClassSpells }, --Fireball (Rank 11)
            { 10174, Team.Universal, Race.Universal, Class.Mage, 60, 10173, false, Config.EnableClassSpells }, --Dampen Magic (Rank 5)
            { 10187, Team.Universal, Race.Universal, Class.Mage, 60, 10186, false, Config.EnableClassSpells }, --Blizzard (Rank 6)
            { 10193, Team.Universal, Race.Universal, Class.Mage, 60, 10192, false, Config.EnableClassSpells }, --Mana Shield (Rank 6)
            { 10220, Team.Universal, Race.Universal, Class.Mage, 60, 10219, false, Config.EnableClassSpells }, --Ice Armor (Rank 4)
            { 10225, Team.Universal, Race.Universal, Class.Mage, 60, 10223, false, Config.EnableClassSpells }, --Fire Ward (Rank 5)
            { 12826, Team.Universal, Race.Universal, Class.Mage, 60, 12825, false, Config.EnableClassSpells }, --Polymorph (Rank 4)
            { 25304, Team.Universal, Race.Universal, Class.Mage, 60, 10181, false, Config.EnableClassSpells }, --Frostbolt (Rank 11)
            { 25306, Team.Universal, Race.Universal, Class.Mage, 60, 10151, false, Config.EnableClassSpells }, --Fireball (Rank 12)
            { 25345, Team.Universal, Race.Universal, Class.Mage, 60, 10212, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 8)
            { 28609, Team.Universal, Race.Universal, Class.Mage, 60, 10177, false, Config.EnableClassSpells }, --Frost Ward (Rank 5)
            { 28612, Team.Universal, Race.Universal, Class.Mage, 60, 10145, false, Config.EnableClassSpells }, --Conjure Food (Rank 7)
            { 27078, Team.Universal, Race.Universal, Class.Mage, 61, 10199, false, Config.EnableClassSpells }, --Fire Blast (Rank 8)
            { 27080, Team.Universal, Race.Universal, Class.Mage, 62, 10202, false, Config.EnableClassSpells }, --Arcane Explosion (Rank 7)
            { 30482, Team.Universal, Race.Universal, Class.Mage, 62, -1, false, Config.EnableClassSpells }, --Molten Armor (Rank 1)
            { 27071, Team.Universal, Race.Universal, Class.Mage, 63, 25304, false, Config.EnableClassSpells }, --Frostbolt (Rank 12)
            { 27075, Team.Universal, Race.Universal, Class.Mage, 63, 25345, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 9)
            { 27130, Team.Universal, Race.Universal, Class.Mage, 63, 10170, false, Config.EnableClassSpells }, --Amplify Magic (Rank 5)
            { 27086, Team.Universal, Race.Universal, Class.Mage, 64, 10216, false, Config.EnableClassSpells }, --Flamestrike (Rank 7)
            { 30451, Team.Universal, Race.Universal, Class.Mage, 64, -1, false, Config.EnableClassSpells }, --Arcane Blast (Rank 1)
            { 27073, Team.Universal, Race.Universal, Class.Mage, 65, 10207, false, Config.EnableClassSpells }, --Scorch (Rank 8)
            { 27087, Team.Universal, Race.Universal, Class.Mage, 65, 10161, false, Config.EnableClassSpells }, --Cone of Cold (Rank 6)
            { 37420, Team.Universal, Race.Universal, Class.Mage, 65, 10140, false, Config.EnableClassSpells }, --Conjure Water (Rank 8)
            { 27070, Team.Universal, Race.Universal, Class.Mage, 66, 25306, false, Config.EnableClassSpells }, --Fireball (Rank 13)
            { 30455, Team.Universal, Race.Universal, Class.Mage, 66, -1, false, Config.EnableClassSpells }, --Ice Lance (Rank 1)
            { 27088, Team.Universal, Race.Universal, Class.Mage, 67, 10230, false, Config.EnableClassSpells }, --Frost Nova (Rank 5)
            { 33944, Team.Universal, Race.Universal, Class.Mage, 67, 10174, false, Config.EnableClassSpells }, --Dampen Magic (Rank 6)
            { 66, Team.Universal, Race.Universal, Class.Mage, 68, -1, false, Config.EnableClassSpells }, --Invisibility
            { 27085, Team.Universal, Race.Universal, Class.Mage, 68, 10187, false, Config.EnableClassSpells }, --Blizzard (Rank 7)
            { 27101, Team.Universal, Race.Universal, Class.Mage, 68, 10054, false, Config.EnableClassSpells }, --Conjure Mana Gem (Rank 5)
            { 27131, Team.Universal, Race.Universal, Class.Mage, 68, 10193, false, Config.EnableClassSpells }, --Mana Shield (Rank 7)
            { 27072, Team.Universal, Race.Universal, Class.Mage, 69, 27071, false, Config.EnableClassSpells }, --Frostbolt (Rank 13)
            { 27124, Team.Universal, Race.Universal, Class.Mage, 69, 10220, false, Config.EnableClassSpells }, --Ice Armor (Rank 5)
            { 27125, Team.Universal, Race.Universal, Class.Mage, 69, 22783, false, Config.EnableClassSpells }, --Mage Armor Armor 4
            { 27128, Team.Universal, Race.Universal, Class.Mage, 69, 10225, false, Config.EnableClassSpells }, --Fire Ward (Rank 6)
            { 33946, Team.Universal, Race.Universal, Class.Mage, 69, 27130, false, Config.EnableClassSpells }, --Amplify Magic (Rank 6)
            { 38699, Team.Universal, Race.Universal, Class.Mage, 69, 27075, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 10)
            { 27074, Team.Universal, Race.Universal, Class.Mage, 70, 27073, false, Config.EnableClassSpells }, --Scorch (Rank 9)
            { 27079, Team.Universal, Race.Universal, Class.Mage, 70, 27078, false, Config.EnableClassSpells }, --Fire Blast (Rank 9)
            { 27082, Team.Universal, Race.Universal, Class.Mage, 70, 27080, false, Config.EnableClassSpells }, --Arcane Explosion (Rank 8)
            { 27090, Team.Universal, Race.Universal, Class.Mage, 70, 37420, false, Config.EnableClassSpells }, --Conjure Water (Rank 9)
            { 27126, Team.Universal, Race.Universal, Class.Mage, 70, 10157, false, Config.EnableClassSpells }, --Arcane Intellect (Rank 6)
            { 27127, Team.Universal, Race.Universal, Class.Mage, 70, 23028, false, Config.EnableClassSpells }, --Arcane Brilliance (Rank 2)
            { 30449, Team.Universal, Race.Universal, Class.Mage, 70, -1, false, Config.EnableClassSpells }, --Spellsteal
            { 32796, Team.Universal, Race.Universal, Class.Mage, 70, 28609, false, Config.EnableClassSpells }, --Frost Ward (Rank 6)
            { 33717, Team.Universal, Race.Universal, Class.Mage, 70, 28612, false, Config.EnableClassSpells }, --Conjure Food (Rank 8)
            { 38692, Team.Universal, Race.Universal, Class.Mage, 70, 27070, false, Config.EnableClassSpells }, --Fireball (Rank 14)
            { 38697, Team.Universal, Race.Universal, Class.Mage, 70, 27072, false, Config.EnableClassSpells }, --Frostbolt (Rank 14)
            { 38704, Team.Universal, Race.Universal, Class.Mage, 70, 38699, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 11)
            { 43987, Team.Universal, Race.Universal, Class.Mage, 70, -1, false, Config.EnableClassSpells }, --Ritual of Refreshment
            { 42894, Team.Universal, Race.Universal, Class.Mage, 71, 30451, false, Config.EnableClassSpells }, --Arcane Blast (Rank 2)
            { 43023, Team.Universal, Race.Universal, Class.Mage, 71, 27125, false, Config.EnableClassSpells }, --Mage Armor (Rank 5)
            { 43045, Team.Universal, Race.Universal, Class.Mage, 71, 30482, false, Config.EnableClassSpells }, --Molten Armor (Rank 2)
            { 42913, Team.Universal, Race.Universal, Class.Mage, 72, 30455, false, Config.EnableClassSpells }, --Ice Lance (Rank 2)
            { 42925, Team.Universal, Race.Universal, Class.Mage, 72, 27086, false, Config.EnableClassSpells }, --Flamestrike (Rank 8)
            { 42930, Team.Universal, Race.Universal, Class.Mage, 72, 27087, false, Config.EnableClassSpells }, --Cone of Cold (Rank 7)
            { 42858, Team.Universal, Race.Universal, Class.Mage, 73, 27074, false, Config.EnableClassSpells }, --Scorch (Rank 10)
            { 43019, Team.Universal, Race.Universal, Class.Mage, 73, 27131, false, Config.EnableClassSpells }, --Mana Shield (Rank 8)
            { 42832, Team.Universal, Race.Universal, Class.Mage, 74, 38692, false, Config.EnableClassSpells }, --Fireball (Rank 15)
            { 42872, Team.Universal, Race.Universal, Class.Mage, 74, 27079, false, Config.EnableClassSpells }, --Fire Blast (Rank 10)
            { 42939, Team.Universal, Race.Universal, Class.Mage, 74, 27085, false, Config.EnableClassSpells }, --Blizzard (Rank 8)
            { 42841, Team.Universal, Race.Universal, Class.Mage, 75, 38697, false, Config.EnableClassSpells }, --Frostbolt (Rank 15)
            { 42843, Team.Universal, Race.Universal, Class.Mage, 75, 38704, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 12)
            { 42917, Team.Universal, Race.Universal, Class.Mage, 75, 27088, false, Config.EnableClassSpells }, --Frost Nova (Rank 6)
            { 42955, Team.Universal, Race.Universal, Class.Mage, 75, -1, false, Config.EnableClassSpells }, --Conjure Refreshment (Rank 1)
            { 44614, Team.Universal, Race.Universal, Class.Mage, 75, -1, false, Config.EnableClassSpells }, --Frostfire Bolt (Rank 1)
            { 42896, Team.Universal, Race.Universal, Class.Mage, 76, 42894, false, Config.EnableClassSpells }, --Arcane Blast (Rank 3)
            { 42920, Team.Universal, Race.Universal, Class.Mage, 76, 27082, false, Config.EnableClassSpells }, --Arcane Explosion (Rank 9)
            { 43015, Team.Universal, Race.Universal, Class.Mage, 76, 33944, false, Config.EnableClassSpells }, --Dampen Magic (Rank 7)
            { 42985, Team.Universal, Race.Universal, Class.Mage, 77, 27101, false, Config.EnableClassSpells }, --Conjure Mana Gem (Rank 6)
            { 43017, Team.Universal, Race.Universal, Class.Mage, 77, 33946, false, Config.EnableClassSpells }, --Amplify Magic (Rank 7)
            { 42833, Team.Universal, Race.Universal, Class.Mage, 78, 42832, false, Config.EnableClassSpells }, --Fireball (Rank 16)
            { 42859, Team.Universal, Race.Universal, Class.Mage, 78, 42858, false, Config.EnableClassSpells }, --Scorch (Rank 11)
            { 42914, Team.Universal, Race.Universal, Class.Mage, 78, 42913, false, Config.EnableClassSpells }, --Ice Lance (Rank 3)
            { 43010, Team.Universal, Race.Universal, Class.Mage, 78, 27128, false, Config.EnableClassSpells }, --Fire Ward (Rank 7)
            { 42842, Team.Universal, Race.Universal, Class.Mage, 79, 42841, false, Config.EnableClassSpells }, --Frostbolt (Rank 16)
            { 42846, Team.Universal, Race.Universal, Class.Mage, 79, 42843, false, Config.EnableClassSpells }, --Arcane Missiles (Rank 13)
            { 42926, Team.Universal, Race.Universal, Class.Mage, 79, 42925, false, Config.EnableClassSpells }, --Flamestrike (Rank 9)
            { 42931, Team.Universal, Race.Universal, Class.Mage, 79, 42930, false, Config.EnableClassSpells }, --Cone of Cold (Rank 8)
            { 43008, Team.Universal, Race.Universal, Class.Mage, 79, 27124, false, Config.EnableClassSpells }, --Ice Armor (Rank 6)
            { 43012, Team.Universal, Race.Universal, Class.Mage, 79, 32796, false, Config.EnableClassSpells }, --Frost Ward (Rank 7)
            { 43020, Team.Universal, Race.Universal, Class.Mage, 79, 43019, false, Config.EnableClassSpells }, --Mana Shield (Rank 9)
            { 43024, Team.Universal, Race.Universal, Class.Mage, 79, 43023, false, Config.EnableClassSpells }, --Mage Armor (Rank 6)
            { 43046, Team.Universal, Race.Universal, Class.Mage, 79, 43045, false, Config.EnableClassSpells }, --Molten Armor (Rank 3)
            { 42873, Team.Universal, Race.Universal, Class.Mage, 80, 42872, false, Config.EnableClassSpells }, --Fire Blast (Rank 11)
            { 42897, Team.Universal, Race.Universal, Class.Mage, 80, 42896, false, Config.EnableClassSpells }, --Arcane Blast (Rank 4)
            { 42921, Team.Universal, Race.Universal, Class.Mage, 80, 42920, false, Config.EnableClassSpells }, --Arcane Explosion (Rank 10)
            { 42940, Team.Universal, Race.Universal, Class.Mage, 80, 42939, false, Config.EnableClassSpells }, --Blizzard (Rank 9)
            { 42956, Team.Universal, Race.Universal, Class.Mage, 80, 42955, false, Config.EnableClassSpells }, --Conjure Refreshment (Rank 2)
            { 42995, Team.Universal, Race.Universal, Class.Mage, 80, 27126, false, Config.EnableClassSpells }, --Arcane Intellect (Rank 7)
            { 43002, Team.Universal, Race.Universal, Class.Mage, 80, 27127, false, Config.EnableClassSpells }, --Arcane Brilliance (Rank 3)
            { 47610, Team.Universal, Race.Universal, Class.Mage, 80, 44614, false, Config.EnableClassSpells }, --Frostfire Bolt (Rank 2)
            { 55342, Team.Universal, Race.Universal, Class.Mage, 80, -1, false, Config.EnableClassSpells }, --Mirror Image
            { 58659, Team.Universal, Race.Universal, Class.Mage, 80, -1, false, Config.EnableClassSpells }, --Ritual of Refreshment
            -- Warlock
            { 348, Team.Universal, Race.Universal, Class.Warlock, 1, -1, false, Config.EnableClassSpells }, --Immolate (Rank 1)
            { 686, Team.Universal, Race.Universal, Class.Warlock, 1, -1, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 1)
            { 687, Team.Universal, Race.Universal, Class.Warlock, 1, -1, false, Config.EnableClassSpells }, --Demon Skin (Rank 1)
            { 688, Team.Universal, Race.Universal, Class.Warlock, 1, -1, false, Config.EnableClassSpells }, --Summon Imp
            { 172, Team.Universal, Race.Universal, Class.Warlock, 4, -1, false, Config.EnableClassSpells }, --Corruption (Rank 1)
            { 702, Team.Universal, Race.Universal, Class.Warlock, 4, -1, false, Config.EnableClassSpells }, --Curse of Weakness (Rank 1)
            { 695, Team.Universal, Race.Universal, Class.Warlock, 6, 686, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 2)
            { 1454, Team.Universal, Race.Universal, Class.Warlock, 6, -1, false, Config.EnableClassSpells }, --Life Tap (Rank 1)
            { 980, Team.Universal, Race.Universal, Class.Warlock, 8, -1, false, Config.EnableClassSpells }, --Curse of Agony (Rank 1)
            { 5782, Team.Universal, Race.Universal, Class.Warlock, 8, -1, false, Config.EnableClassSpells }, --Fear (Rank 1)
            { 696, Team.Universal, Race.Universal, Class.Warlock, 10, 687, false, Config.EnableClassSpells }, --Demon Skin (Rank 2)
            { 697, Team.Universal, Race.Universal, Class.Warlock, 10, -1, true, Config.EnableClassSpells }, --Summon Voidwalker
            { 707, Team.Universal, Race.Universal, Class.Warlock, 10, 348, false, Config.EnableClassSpells }, --Immolate (Rank 2)
            { 1120, Team.Universal, Race.Universal, Class.Warlock, 10, -1, false, Config.EnableClassSpells }, --Drain Soul (Rank 1)
            { 6201, Team.Universal, Race.Universal, Class.Warlock, 10, -1, false, Config.EnableClassSpells }, --Create Healthstone (Rank 1)
            { 705, Team.Universal, Race.Universal, Class.Warlock, 12, 695, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 3)
            { 755, Team.Universal, Race.Universal, Class.Warlock, 12, -1, false, Config.EnableClassSpells }, --Health Funnel (Rank 1)
            { 1108, Team.Universal, Race.Universal, Class.Warlock, 12, 702, false, Config.EnableClassSpells }, --Curse of Weakness (Rank 2)
            { 689, Team.Universal, Race.Universal, Class.Warlock, 14, -1, false, Config.EnableClassSpells }, --Drain Life (Rank 1)
            { 6222, Team.Universal, Race.Universal, Class.Warlock, 14, 172, false, Config.EnableClassSpells }, --Corruption (Rank 2)
            { 1455, Team.Universal, Race.Universal, Class.Warlock, 16, 1454, false, Config.EnableClassSpells }, --Life Tap (Rank 2)
            { 5697, Team.Universal, Race.Universal, Class.Warlock, 16, -1, false, Config.EnableClassSpells }, --Unending Breath
            { 693, Team.Universal, Race.Universal, Class.Warlock, 18, -1, false, Config.EnableClassSpells }, --Create Soulstone (Rank 1)
            { 1014, Team.Universal, Race.Universal, Class.Warlock, 18, 980, false, Config.EnableClassSpells }, --Curse of Agony (Rank 2)
            { 5676, Team.Universal, Race.Universal, Class.Warlock, 18, -1, false, Config.EnableClassSpells }, --Searing Pain (Rank 1)
            { 698, Team.Universal, Race.Universal, Class.Warlock, 20, -1, false, Config.EnableClassSpells }, --Ritual of Summoning
            { 706, Team.Universal, Race.Universal, Class.Warlock, 20, -1, false, Config.EnableClassSpells }, --Demon Armor (Rank 1)
            { 712, Team.Universal, Race.Universal, Class.Warlock, 20, -1, true, Config.EnableClassSpells }, --Summon Succubus
            { 1088, Team.Universal, Race.Universal, Class.Warlock, 20, 705, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 4)
            { 1094, Team.Universal, Race.Universal, Class.Warlock, 20, 707, false, Config.EnableClassSpells }, --Immolate (Rank 3)
            { 3698, Team.Universal, Race.Universal, Class.Warlock, 20, 755, false, Config.EnableClassSpells }, --Health Funnel (Rank 2)
            { 5740, Team.Universal, Race.Universal, Class.Warlock, 20, -1, false, Config.EnableClassSpells }, --Rain of Fire (Rank 1)
            { 126, Team.Universal, Race.Universal, Class.Warlock, 22, -1, false, Config.EnableClassSpells }, --Eye of Kilrogg
            { 699, Team.Universal, Race.Universal, Class.Warlock, 22, 689, false, Config.EnableClassSpells }, --Drain Life (Rank 2)
            { 6202, Team.Universal, Race.Universal, Class.Warlock, 22, 6201, false, Config.EnableClassSpells }, --Create Healthstone (Rank 2)
            { 6205, Team.Universal, Race.Universal, Class.Warlock, 22, 1108, false, Config.EnableClassSpells }, --Curse of Weakness (Rank 3)
            { 5138, Team.Universal, Race.Universal, Class.Warlock, 24, -1, false, Config.EnableClassSpells }, --Drain Mana
            { 5500, Team.Universal, Race.Universal, Class.Warlock, 24, -1, false, Config.EnableClassSpells }, --Sense Demons
            { 6223, Team.Universal, Race.Universal, Class.Warlock, 24, 6222, false, Config.EnableClassSpells }, --Corruption (Rank 3)
            { 8288, Team.Universal, Race.Universal, Class.Warlock, 24, 1120, false, Config.EnableClassSpells }, --Drain Soul (Rank 2)
            { 132, Team.Universal, Race.Universal, Class.Warlock, 26, -1, false, Config.EnableClassSpells }, --Detect Invisibility
            { 1456, Team.Universal, Race.Universal, Class.Warlock, 26, 1455, false, Config.EnableClassSpells }, --Life Tap (Rank 3)
            { 1714, Team.Universal, Race.Universal, Class.Warlock, 26, -1, false, Config.EnableClassSpells }, --Curse of Tongues (Rank 1)
            { 17919, Team.Universal, Race.Universal, Class.Warlock, 26, 5676, false, Config.EnableClassSpells }, --Searing Pain (Rank 2)
            { 710, Team.Universal, Race.Universal, Class.Warlock, 28, -1, false, Config.EnableClassSpells }, --Banish (Rank 1)
            { 1106, Team.Universal, Race.Universal, Class.Warlock, 28, 1088, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 5)
            { 3699, Team.Universal, Race.Universal, Class.Warlock, 28, 3698, false, Config.EnableClassSpells }, --Health Funnel (Rank 3)
            { 6217, Team.Universal, Race.Universal, Class.Warlock, 28, 1014, false, Config.EnableClassSpells }, --Curse of Agony (Rank 3)
            { 6366, Team.Universal, Race.Universal, Class.Warlock, 28, -1, false, Config.EnableClassSpells }, --Create Firestone (Rank 1)
            { 691, Team.Universal, Race.Universal, Class.Warlock, 30, -1, true, Config.EnableClassSpells }, --Summon Felhunter
            { 709, Team.Universal, Race.Universal, Class.Warlock, 30, 699, false, Config.EnableClassSpells }, --Drain Life (Rank 3)
            { 1086, Team.Universal, Race.Universal, Class.Warlock, 30, 706, false, Config.EnableClassSpells }, --Demon Armor (Rank 2)
            { 1098, Team.Universal, Race.Universal, Class.Warlock, 30, -1, false, Config.EnableClassSpells }, --Enslave Demon (Rank 1)
            { 1949, Team.Universal, Race.Universal, Class.Warlock, 30, -1, false, Config.EnableClassSpells }, --Hellfire (Rank 1)
            { 2941, Team.Universal, Race.Universal, Class.Warlock, 30, 1094, false, Config.EnableClassSpells }, --Immolate (Rank 4)
            { 20752, Team.Universal, Race.Universal, Class.Warlock, 30, 693, false, Config.EnableClassSpells }, --Create Soulstone (Rank 2)
            { 1490, Team.Universal, Race.Universal, Class.Warlock, 32, -1, false, Config.EnableClassSpells }, --Curse of the Elements (Rank 1)
            { 6213, Team.Universal, Race.Universal, Class.Warlock, 32, 5782, false, Config.EnableClassSpells }, --Fear (Rank 2)
            { 6229, Team.Universal, Race.Universal, Class.Warlock, 32, -1, false, Config.EnableClassSpells }, --Shadow Ward (Rank 1)
            { 7646, Team.Universal, Race.Universal, Class.Warlock, 32, 6205, false, Config.EnableClassSpells }, --Curse of Weakness (Rank 4)
            { 5699, Team.Universal, Race.Universal, Class.Warlock, 34, 6202, false, Config.EnableClassSpells }, --Create Healthstone (Rank 3)
            { 6219, Team.Universal, Race.Universal, Class.Warlock, 34, 5740, false, Config.EnableClassSpells }, --Rain of Fire (Rank 2)
            { 7648, Team.Universal, Race.Universal, Class.Warlock, 34, 6223, false, Config.EnableClassSpells }, --Corruption (Rank 4)
            { 17920, Team.Universal, Race.Universal, Class.Warlock, 34, 17919, false, Config.EnableClassSpells }, --Searing Pain (Rank 3)
            { 2362, Team.Universal, Race.Universal, Class.Warlock, 36, -1, false, Config.EnableClassSpells }, --Create Spellstone (Rank 1)
            { 3700, Team.Universal, Race.Universal, Class.Warlock, 36, 3699, false, Config.EnableClassSpells }, --Health Funnel (Rank 4)
            { 7641, Team.Universal, Race.Universal, Class.Warlock, 36, 1106, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 6)
            { 11687, Team.Universal, Race.Universal, Class.Warlock, 36, 1456, false, Config.EnableClassSpells }, --Life Tap (Rank 4)
            { 17951, Team.Universal, Race.Universal, Class.Warlock, 36, 6366, false, Config.EnableClassSpells }, --Create Firestone (Rank 2)
            { 7651, Team.Universal, Race.Universal, Class.Warlock, 38, 709, false, Config.EnableClassSpells }, --Drain Life (Rank 4)
            { 8289, Team.Universal, Race.Universal, Class.Warlock, 38, 8288, false, Config.EnableClassSpells }, --Drain Soul (Rank 3)
            { 11711, Team.Universal, Race.Universal, Class.Warlock, 38, 6217, false, Config.EnableClassSpells }, --Curse of Agony (Rank 4)
            { 5484, Team.Universal, Race.Universal, Class.Warlock, 40, -1, false, Config.EnableClassSpells }, --Howl of Terror (Rank 1)
            { 11665, Team.Universal, Race.Universal, Class.Warlock, 40, 2941, false, Config.EnableClassSpells }, --Immolate (Rank 5)
            { 11733, Team.Universal, Race.Universal, Class.Warlock, 40, 1086, false, Config.EnableClassSpells }, --Demon Armor (Rank 3)
            { 20755, Team.Universal, Race.Universal, Class.Warlock, 40, 20752, false, Config.EnableClassSpells }, --Create Soulstone (Rank 3)
            { 6789, Team.Universal, Race.Universal, Class.Warlock, 42, -1, false, Config.EnableClassSpells }, --Death Coil (Rank 1)
            { 11683, Team.Universal, Race.Universal, Class.Warlock, 42, 1949, false, Config.EnableClassSpells }, --Hellfire (Rank 2)
            { 11707, Team.Universal, Race.Universal, Class.Warlock, 42, 7646, false, Config.EnableClassSpells }, --Curse of Weakness (Rank 5)
            { 11739, Team.Universal, Race.Universal, Class.Warlock, 42, 6229, false, Config.EnableClassSpells }, --Shadow Ward (Rank 2)
            { 17921, Team.Universal, Race.Universal, Class.Warlock, 42, 17920, false, Config.EnableClassSpells }, --Searing Pain (Rank 4)
            { 11659, Team.Universal, Race.Universal, Class.Warlock, 44, 7641, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 7)
            { 11671, Team.Universal, Race.Universal, Class.Warlock, 44, 7648, false, Config.EnableClassSpells }, --Corruption (Rank 5)
            { 11693, Team.Universal, Race.Universal, Class.Warlock, 44, 3700, false, Config.EnableClassSpells }, --Health Funnel (Rank 5)
            { 11725, Team.Universal, Race.Universal, Class.Warlock, 44, 1098, false, Config.EnableClassSpells }, --Enslave Demon (Rank 2)
            { 11677, Team.Universal, Race.Universal, Class.Warlock, 46, 6219, false, Config.EnableClassSpells }, --Rain of Fire (Rank 3)
            { 11688, Team.Universal, Race.Universal, Class.Warlock, 46, 11687, false, Config.EnableClassSpells }, --Life Tap (Rank 5)
            { 11699, Team.Universal, Race.Universal, Class.Warlock, 46, 7651, false, Config.EnableClassSpells }, --Drain Life (Rank 5)
            { 11721, Team.Universal, Race.Universal, Class.Warlock, 46, 1490, false, Config.EnableClassSpells }, --Curse of the Elements (Rank 2)
            { 11729, Team.Universal, Race.Universal, Class.Warlock, 46, 5699, false, Config.EnableClassSpells }, --Create Healthstone (Rank 4)
            { 17952, Team.Universal, Race.Universal, Class.Warlock, 46, 17951, false, Config.EnableClassSpells }, --Create Firestone (Rank 3)
            { 6353, Team.Universal, Race.Universal, Class.Warlock, 48, -1, false, Config.EnableClassSpells }, --Soul Fire (Rank 1)
            { 11712, Team.Universal, Race.Universal, Class.Warlock, 48, 11711, false, Config.EnableClassSpells }, --Curse of Agony (Rank 5)
            { 17727, Team.Universal, Race.Universal, Class.Warlock, 48, 2362, false, Config.EnableClassSpells }, --Create Spellstone (Rank 2)
            { 18647, Team.Universal, Race.Universal, Class.Warlock, 48, 710, false, Config.EnableClassSpells }, --Banish (Rank 2)
            { 11667, Team.Universal, Race.Universal, Class.Warlock, 50, 11665, false, Config.EnableClassSpells }, --Immolate (Rank 6)
            { 11719, Team.Universal, Race.Universal, Class.Warlock, 50, 1714, false, Config.EnableClassSpells }, --Curse of Tongues (Rank 2)
            { 11734, Team.Universal, Race.Universal, Class.Warlock, 50, 11733, false, Config.EnableClassSpells }, --Demon Armor (Rank 4)
            { 17922, Team.Universal, Race.Universal, Class.Warlock, 50, 17921, false, Config.EnableClassSpells }, --Searing Pain (Rank 5)
            { 17925, Team.Universal, Race.Universal, Class.Warlock, 50, 6789, false, Config.EnableClassSpells }, --Death Coil (Rank 2)
            { 20756, Team.Universal, Race.Universal, Class.Warlock, 50, 20755, false, Config.EnableClassSpells }, --Create Soulstone (Rank 4)
            { 11660, Team.Universal, Race.Universal, Class.Warlock, 52, 11659, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 8)
            { 11675, Team.Universal, Race.Universal, Class.Warlock, 52, 8289, false, Config.EnableClassSpells }, --Drain Soul (Rank 4)
            { 11694, Team.Universal, Race.Universal, Class.Warlock, 52, 11693, false, Config.EnableClassSpells }, --Health Funnel (Rank 6)
            { 11708, Team.Universal, Race.Universal, Class.Warlock, 52, 11707, false, Config.EnableClassSpells }, --Curse of Weakness (Rank 6)
            { 11740, Team.Universal, Race.Universal, Class.Warlock, 52, 11739, false, Config.EnableClassSpells }, --Shadow Ward (Rank 3)
            { 11672, Team.Universal, Race.Universal, Class.Warlock, 54, 11671, false, Config.EnableClassSpells }, --Corruption (Rank 6)
            { 11684, Team.Universal, Race.Universal, Class.Warlock, 54, 11683, false, Config.EnableClassSpells }, --Hellfire (Rank 3)
            { 11700, Team.Universal, Race.Universal, Class.Warlock, 54, 11699, false, Config.EnableClassSpells }, --Drain Life (Rank 6)
            { 17928, Team.Universal, Race.Universal, Class.Warlock, 54, 5484, false, Config.EnableClassSpells }, --Howl of Terror (Rank 2)
            { 6215, Team.Universal, Race.Universal, Class.Warlock, 56, 6213, false, Config.EnableClassSpells }, --Fear (Rank 3)
            { 11689, Team.Universal, Race.Universal, Class.Warlock, 56, 11688, false, Config.EnableClassSpells }, --Life Tap (Rank 6)
            { 17924, Team.Universal, Race.Universal, Class.Warlock, 56, 6353, false, Config.EnableClassSpells }, --Soul Fire (Rank 2)
            { 17953, Team.Universal, Race.Universal, Class.Warlock, 56, 17952, false, Config.EnableClassSpells }, --Create Firestone (Rank 4)
            { 11678, Team.Universal, Race.Universal, Class.Warlock, 58, 11677, false, Config.EnableClassSpells }, --Rain of Fire (Rank 4)
            { 11713, Team.Universal, Race.Universal, Class.Warlock, 58, 11712, false, Config.EnableClassSpells }, --Curse of Agony (Rank 6)
            { 11726, Team.Universal, Race.Universal, Class.Warlock, 58, 11725, false, Config.EnableClassSpells }, --Enslave Demon (Rank 3)
            { 11730, Team.Universal, Race.Universal, Class.Warlock, 58, 11729, false, Config.EnableClassSpells }, --Create Healthstone (Rank 5)
            { 17923, Team.Universal, Race.Universal, Class.Warlock, 58, 17922, false, Config.EnableClassSpells }, --Searing Pain (Rank 6)
            { 17926, Team.Universal, Race.Universal, Class.Warlock, 58, 17925, false, Config.EnableClassSpells }, --Death Coil (Rank 3)
            { 603, Team.Universal, Race.Universal, Class.Warlock, 60, -1, false, Config.EnableClassSpells }, --Curse of Doom (Rank 1)
            { 11661, Team.Universal, Race.Universal, Class.Warlock, 60, 11660, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 9)
            { 11668, Team.Universal, Race.Universal, Class.Warlock, 60, 11667, false, Config.EnableClassSpells }, --Immolate (Rank 7)
            { 11695, Team.Universal, Race.Universal, Class.Warlock, 60, 11694, false, Config.EnableClassSpells }, --Health Funnel (Rank 7)
            { 11722, Team.Universal, Race.Universal, Class.Warlock, 60, 11721, false, Config.EnableClassSpells }, --Curse of the Elements (Rank 3)
            { 11735, Team.Universal, Race.Universal, Class.Warlock, 60, 11734, false, Config.EnableClassSpells }, --Demon Armor (Rank 5)
            { 17728, Team.Universal, Race.Universal, Class.Warlock, 60, 17727, false, Config.EnableClassSpells }, --Create Spellstone (Rank 3)
            { 20757, Team.Universal, Race.Universal, Class.Warlock, 60, 20756, false, Config.EnableClassSpells }, --Create Soulstone (Rank 5)
            { 25307, Team.Universal, Race.Universal, Class.Warlock, 60, 11661, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 10)
            { 25309, Team.Universal, Race.Universal, Class.Warlock, 60, 11668, false, Config.EnableClassSpells }, --Immolate (Rank 8)
            { 25311, Team.Universal, Race.Universal, Class.Warlock, 60, 11672, false, Config.EnableClassSpells }, --Corruption (Rank 7)
            { 28610, Team.Universal, Race.Universal, Class.Warlock, 60, 11740, false, Config.EnableClassSpells }, --Shadow Ward (Rank 4)
            { 27224, Team.Universal, Race.Universal, Class.Warlock, 61, 11708, false, Config.EnableClassSpells }, --Curse of Weakness (Rank 7)
            { 27219, Team.Universal, Race.Universal, Class.Warlock, 62, 11700, false, Config.EnableClassSpells }, --Drain Life (Rank 7)
            { 28176, Team.Universal, Race.Universal, Class.Warlock, 62, -1, false, Config.EnableClassSpells }, --Fel Armor (Rank 1)
            { 27211, Team.Universal, Race.Universal, Class.Warlock, 64, 17924, false, Config.EnableClassSpells }, --Soul Fire (Rank 3)
            { 29722, Team.Universal, Race.Universal, Class.Warlock, 64, -1, false, Config.EnableClassSpells }, --Incinerate (Rank 1)
            { 27210, Team.Universal, Race.Universal, Class.Warlock, 65, 17923, false, Config.EnableClassSpells }, --Searing Pain (Rank 7)
            { 27216, Team.Universal, Race.Universal, Class.Warlock, 65, 25311, false, Config.EnableClassSpells }, --Corruption (Rank 8)
            { 27250, Team.Universal, Race.Universal, Class.Warlock, 66, 17953, false, Config.EnableClassSpells }, --Create Firestone (Rank 5)
            { 28172, Team.Universal, Race.Universal, Class.Warlock, 66, 17728, false, Config.EnableClassSpells }, --Create Spellstone (Rank 4)
            { 29858, Team.Universal, Race.Universal, Class.Warlock, 66, -1, false, Config.EnableClassSpells }, --Soulshatter
            { 27217, Team.Universal, Race.Universal, Class.Warlock, 67, 11675, false, Config.EnableClassSpells }, --Drain Soul (Rank 5)
            { 27218, Team.Universal, Race.Universal, Class.Warlock, 67, 11713, false, Config.EnableClassSpells }, --Curse of Agony (Rank 7)
            { 27259, Team.Universal, Race.Universal, Class.Warlock, 67, 11695, false, Config.EnableClassSpells }, --Health Funnel (Rank 8)
            { 27213, Team.Universal, Race.Universal, Class.Warlock, 68, 11684, false, Config.EnableClassSpells }, --Hellfire (Rank 4)
            { 27222, Team.Universal, Race.Universal, Class.Warlock, 68, 11689, false, Config.EnableClassSpells }, --Life Tap (Rank 7)
            { 27223, Team.Universal, Race.Universal, Class.Warlock, 68, 17926, false, Config.EnableClassSpells }, --Death Coil (Rank 4)
            { 27230, Team.Universal, Race.Universal, Class.Warlock, 68, 11730, false, Config.EnableClassSpells }, --Create Healthstone (Rank 6)
            { 29893, Team.Universal, Race.Universal, Class.Warlock, 68, -1, false, Config.EnableClassSpells }, --Ritual of Souls (Rank 1)
            { 27209, Team.Universal, Race.Universal, Class.Warlock, 69, 25307, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 11)
            { 27212, Team.Universal, Race.Universal, Class.Warlock, 69, 11678, false, Config.EnableClassSpells }, --Rain of Fire (Rank 5)
            { 27215, Team.Universal, Race.Universal, Class.Warlock, 69, 25309, false, Config.EnableClassSpells }, --Immolate (Rank 9)
            { 27220, Team.Universal, Race.Universal, Class.Warlock, 69, 27219, false, Config.EnableClassSpells }, --Drain Life (Rank 8)
            { 27228, Team.Universal, Race.Universal, Class.Warlock, 69, 11722, false, Config.EnableClassSpells }, --Curse of the Elements (Rank 4)
            { 28189, Team.Universal, Race.Universal, Class.Warlock, 69, 28176, false, Config.EnableClassSpells }, --Fel Armor (Rank 2)
            { 30909, Team.Universal, Race.Universal, Class.Warlock, 69, 27224, false, Config.EnableClassSpells }, --Curse of Weakness (Rank 8)
            { 27238, Team.Universal, Race.Universal, Class.Warlock, 70, 20757, false, Config.EnableClassSpells }, --Create Soulstone (Rank 6)
            { 27243, Team.Universal, Race.Universal, Class.Warlock, 70, -1, false, Config.EnableClassSpells }, --Seed of Corruption (Rank 1)
            { 27260, Team.Universal, Race.Universal, Class.Warlock, 70, 11735, false, Config.EnableClassSpells }, --Demon Armor (Rank 6)
            { 30459, Team.Universal, Race.Universal, Class.Warlock, 70, 27210, false, Config.EnableClassSpells }, --Searing Pain (Rank 8)
            { 30545, Team.Universal, Race.Universal, Class.Warlock, 70, 27211, false, Config.EnableClassSpells }, --Soul Fire (Rank 4)
            { 30910, Team.Universal, Race.Universal, Class.Warlock, 70, 603, false, Config.EnableClassSpells }, --Curse of Doom (Rank 2)
            { 32231, Team.Universal, Race.Universal, Class.Warlock, 70, 29722, false, Config.EnableClassSpells }, --Incinerate (Rank 2)
            { 47812, Team.Universal, Race.Universal, Class.Warlock, 71, 27216, false, Config.EnableClassSpells }, --Corruption (Rank 9)
            { 50511, Team.Universal, Race.Universal, Class.Warlock, 71, 30909, false, Config.EnableClassSpells }, --Curse of Weakness (Rank 9)
            { 47819, Team.Universal, Race.Universal, Class.Warlock, 72, 27212, false, Config.EnableClassSpells }, --Rain of Fire (Rank 6)
            { 47886, Team.Universal, Race.Universal, Class.Warlock, 72, 28172, false, Config.EnableClassSpells }, --Create Spellstone (Rank 5)
            { 47890, Team.Universal, Race.Universal, Class.Warlock, 72, 28610, false, Config.EnableClassSpells }, --Shadow Ward (Rank 5)
            { 61191, Team.Universal, Race.Universal, Class.Warlock, 72, 11726, false, Config.EnableClassSpells }, --Enslave Demon (Rank 4)
            { 47859, Team.Universal, Race.Universal, Class.Warlock, 73, 27223, false, Config.EnableClassSpells }, --Death Coil (Rank 5)
            { 47863, Team.Universal, Race.Universal, Class.Warlock, 73, 27218, false, Config.EnableClassSpells }, --Curse of Agony (Rank 8)
            { 47871, Team.Universal, Race.Universal, Class.Warlock, 73, 27230, false, Config.EnableClassSpells }, --Create Healthstone (Rank 7)
            { 47808, Team.Universal, Race.Universal, Class.Warlock, 74, 27209, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 12)
            { 47814, Team.Universal, Race.Universal, Class.Warlock, 74, 30459, false, Config.EnableClassSpells }, --Searing Pain (Rank 9)
            { 47837, Team.Universal, Race.Universal, Class.Warlock, 74, 32231, false, Config.EnableClassSpells }, --Incinerate (Rank 3)
            { 47892, Team.Universal, Race.Universal, Class.Warlock, 74, 28189, false, Config.EnableClassSpells }, --Fel Armor (Rank 3)
            { 60219, Team.Universal, Race.Universal, Class.Warlock, 74, 27250, false, Config.EnableClassSpells }, --Create Firestone (Rank 6)
            { 47810, Team.Universal, Race.Universal, Class.Warlock, 75, 27215, false, Config.EnableClassSpells }, --Immolate (Rank 10)
            { 47824, Team.Universal, Race.Universal, Class.Warlock, 75, 30545, false, Config.EnableClassSpells }, --Soul Fire (Rank 5)
            { 47835, Team.Universal, Race.Universal, Class.Warlock, 75, 27243, false, Config.EnableClassSpells }, --Seed of Corruption (Rank 2)
            { 47897, Team.Universal, Race.Universal, Class.Warlock, 75, -1, false, Config.EnableClassSpells }, --Shadowflame (Rank 1)
            { 47793, Team.Universal, Race.Universal, Class.Warlock, 76, 27260, false, Config.EnableClassSpells }, --Demon Armor (Rank 7)
            { 47856, Team.Universal, Race.Universal, Class.Warlock, 76, 27259, false, Config.EnableClassSpells }, --Health Funnel (Rank 9)
            { 47884, Team.Universal, Race.Universal, Class.Warlock, 76, 27238, false, Config.EnableClassSpells }, --Create Soulstone (Rank 7)
            { 47813, Team.Universal, Race.Universal, Class.Warlock, 77, 47812, false, Config.EnableClassSpells }, --Corruption (Rank 10)
            { 47855, Team.Universal, Race.Universal, Class.Warlock, 77, 27217, false, Config.EnableClassSpells }, --Drain Soul (Rank 6)
            { 47823, Team.Universal, Race.Universal, Class.Warlock, 78, 27213, false, Config.EnableClassSpells }, --Hellfire (Rank 5)
            { 47857, Team.Universal, Race.Universal, Class.Warlock, 78, 27220, false, Config.EnableClassSpells }, --Drain Life (Rank 9)
            { 47860, Team.Universal, Race.Universal, Class.Warlock, 78, 47859, false, Config.EnableClassSpells }, --Death Coil (Rank 6)
            { 47865, Team.Universal, Race.Universal, Class.Warlock, 78, 27228, false, Config.EnableClassSpells }, --Curse of the Elements (Rank 5)
            { 47888, Team.Universal, Race.Universal, Class.Warlock, 78, 47886, false, Config.EnableClassSpells }, --Create Spellstone (Rank 6)
            { 47891, Team.Universal, Race.Universal, Class.Warlock, 78, 47890, false, Config.EnableClassSpells }, --Shadow Ward (Rank 6)
            { 47809, Team.Universal, Race.Universal, Class.Warlock, 79, 47808, false, Config.EnableClassSpells }, --Shadow Bolt (Rank 13)
            { 47815, Team.Universal, Race.Universal, Class.Warlock, 79, 47814, false, Config.EnableClassSpells }, --Searing Pain (Rank 10)
            { 47820, Team.Universal, Race.Universal, Class.Warlock, 79, 47819, false, Config.EnableClassSpells }, --Rain of Fire (Rank 7)
            { 47864, Team.Universal, Race.Universal, Class.Warlock, 79, 47863, false, Config.EnableClassSpells }, --Curse of Agony (Rank 9)
            { 47878, Team.Universal, Race.Universal, Class.Warlock, 79, 47871, false, Config.EnableClassSpells }, --Create Healthstone (Rank 8)
            { 47893, Team.Universal, Race.Universal, Class.Warlock, 79, 47892, false, Config.EnableClassSpells }, --Fel Armor (Rank 4)
            { 47811, Team.Universal, Race.Universal, Class.Warlock, 80, 47810, false, Config.EnableClassSpells }, --Immolate (Rank 11)
            { 47825, Team.Universal, Race.Universal, Class.Warlock, 80, 47824, false, Config.EnableClassSpells }, --Soul Fire (Rank 6)
            { 47836, Team.Universal, Race.Universal, Class.Warlock, 80, 47835, false, Config.EnableClassSpells }, --Seed of Corruption (Rank 3)
            { 47838, Team.Universal, Race.Universal, Class.Warlock, 80, 47837, false, Config.EnableClassSpells }, --Incinerate (Rank 4)
            { 47867, Team.Universal, Race.Universal, Class.Warlock, 80, 30910, false, Config.EnableClassSpells }, --Curse of Doom (Rank 3)
            { 47889, Team.Universal, Race.Universal, Class.Warlock, 80, 47793, false, Config.EnableClassSpells }, --Demon Armor (Rank 8)
            { 48018, Team.Universal, Race.Universal, Class.Warlock, 80, -1, false, Config.EnableClassSpells }, --Demonic Circle: Summon
            { 48020, Team.Universal, Race.Universal, Class.Warlock, 80, -1, false, Config.EnableClassSpells }, --Demonic Circle: Teleport
            { 57946, Team.Universal, Race.Universal, Class.Warlock, 80, 27222, false, Config.EnableClassSpells }, --Life Tap (Rank 8)
            { 58887, Team.Universal, Race.Universal, Class.Warlock, 80, 29893, false, Config.EnableClassSpells }, --Ritual of Souls (Rank 2)
            { 60220, Team.Universal, Race.Universal, Class.Warlock, 80, 60219, false, Config.EnableClassSpells }, --Create Firestone (Rank 7)
            { 61290, Team.Universal, Race.Universal, Class.Warlock, 80, 47897, false, Config.EnableClassSpells }, --Shadowflame (Rank 2)
            -- Druid
            { 1126, Team.Universal, Race.Universal, Class.Druid, 1, -1, false, Config.EnableClassSpells }, --Mark of the Wild (Rank 1)
            { 5176, Team.Universal, Race.Universal, Class.Druid, 1, -1, false, Config.EnableClassSpells }, --Wrath (Rank 1)
            { 5185, Team.Universal, Race.Universal, Class.Druid, 1, -1, false, Config.EnableClassSpells }, --Healing Touch (Rank 1)
            { 774, Team.Universal, Race.Universal, Class.Druid, 4, -1, false, Config.EnableClassSpells }, --Rejuvenation (Rank 1)
            { 8921, Team.Universal, Race.Universal, Class.Druid, 4, -1, false, Config.EnableClassSpells }, --Moonfire (Rank 1)
            { 467, Team.Universal, Race.Universal, Class.Druid, 6, -1, false, Config.EnableClassSpells }, --Thorns (Rank 1)
            { 5177, Team.Universal, Race.Universal, Class.Druid, 6, 5176, false, Config.EnableClassSpells }, --Wrath (Rank 2)
            { 339, Team.Universal, Race.Universal, Class.Druid, 8, -1, false, Config.EnableClassSpells }, --Entangling Roots (Rank 1)
            { 5186, Team.Universal, Race.Universal, Class.Druid, 8, 5185, false, Config.EnableClassSpells }, --Healing Touch (Rank 2)
            { 99, Team.Universal, Race.Universal, Class.Druid, 10, -1, false, Config.EnableClassSpells }, --Demoralizing Roar (Rank 1)
            { 1058, Team.Universal, Race.Universal, Class.Druid, 10, 774, false, Config.EnableClassSpells }, --Rejuvenation (Rank 2)
            { 5232, Team.Universal, Race.Universal, Class.Druid, 10, 1126, false, Config.EnableClassSpells }, --Mark of the Wild (Rank 2)
            { 5487, Team.Universal, Race.Universal, Class.Druid, 10, -1, true, Config.EnableClassSpells }, --Bear Form (Shapeshift)
            { 6795, Team.Universal, Race.Universal, Class.Druid, 10, 5487, true, Config.EnableClassSpells }, --Growl
            { 6807, Team.Universal, Race.Universal, Class.Druid, 10, 5487, true, Config.EnableClassSpells }, --Maul (Rank 1)
            { 8924, Team.Universal, Race.Universal, Class.Druid, 10, 8921, false, Config.EnableClassSpells }, --Moonfire (Rank 2)
            { 16689, Team.Universal, Race.Universal, Class.Druid, 10, -1, false, Config.EnableClassSpells }, --Nature's Grasp (Rank 1)
            { 5229, Team.Universal, Race.Universal, Class.Druid, 12, -1, false, Config.EnableClassSpells }, --Enrage
            { 8936, Team.Universal, Race.Universal, Class.Druid, 12, -1, false, Config.EnableClassSpells }, --Regrowth (Rank 1)
            { 50769, Team.Universal, Race.Universal, Class.Druid, 12, -1, false, Config.EnableClassSpells }, --Revive (Rank 1)
            { 782, Team.Universal, Race.Universal, Class.Druid, 14, 467, false, Config.EnableClassSpells }, --Thorns (Rank 2)
            { 5178, Team.Universal, Race.Universal, Class.Druid, 14, 5177, false, Config.EnableClassSpells }, --Wrath (Rank 3)
            { 5187, Team.Universal, Race.Universal, Class.Druid, 14, 5186, false, Config.EnableClassSpells }, --Healing Touch (Rank 3)
            { 5211, Team.Universal, Race.Universal, Class.Druid, 14, -1, false, Config.EnableClassSpells }, --Bash (Rank 1)
            { 779, Team.Universal, Race.Universal, Class.Druid, 16, -1, false, Config.EnableClassSpells }, --Swipe (Bear) (Rank 1)
            { 783, Team.Universal, Race.Universal, Class.Druid, 16, -1, false, Config.EnableClassSpells }, --Travel Form (Shapeshift)
            { 1066, Team.Universal, Race.Universal, Class.Druid, 16, -1, false, Config.EnableClassSpells }, --Aquatic Form (Shapeshift)
            { 1430, Team.Universal, Race.Universal, Class.Druid, 16, 1058, false, Config.EnableClassSpells }, --Rejuvenation (Rank 3)
            { 8925, Team.Universal, Race.Universal, Class.Druid, 16, 8924, false, Config.EnableClassSpells }, --Moonfire (Rank 3)
            { 770, Team.Universal, Race.Universal, Class.Druid, 18, -1, false, Config.EnableClassSpells }, --Faerie Fire
            { 1062, Team.Universal, Race.Universal, Class.Druid, 18, 339, false, Config.EnableClassSpells }, --Entangling Roots (Rank 2)
            { 2637, Team.Universal, Race.Universal, Class.Druid, 18, -1, false, Config.EnableClassSpells }, --Hibernate (Rank 1)
            { 6808, Team.Universal, Race.Universal, Class.Druid, 18, 6807, false, Config.EnableClassSpells }, --Maul (Rank 2)
            { 8938, Team.Universal, Race.Universal, Class.Druid, 18, 8936, false, Config.EnableClassSpells }, --Regrowth (Rank 2)
            { 16810, Team.Universal, Race.Universal, Class.Druid, 18, 16689, false, Config.EnableClassSpells }, --Nature's Grasp (Rank 2)
            { 16857, Team.Universal, Race.Universal, Class.Druid, 18, -1, false, Config.EnableClassSpells }, --Faerie Fire (Feral)
            { 768, Team.Universal, Race.Universal, Class.Druid, 20, -1, false, Config.EnableClassSpells }, --Cat Form (Shapeshift)
            { 1079, Team.Universal, Race.Universal, Class.Druid, 20, -1, false, Config.EnableClassSpells }, --Rip (Rank 1)
            { 1082, Team.Universal, Race.Universal, Class.Druid, 20, -1, false, Config.EnableClassSpells }, --Claw (Rank 1)
            { 1735, Team.Universal, Race.Universal, Class.Druid, 20, 99, false, Config.EnableClassSpells }, --Demoralizing Roar (Rank 2)
            { 2912, Team.Universal, Race.Universal, Class.Druid, 20, -1, false, Config.EnableClassSpells }, --Starfire (Rank 1)
            { 5188, Team.Universal, Race.Universal, Class.Druid, 20, 5187, false, Config.EnableClassSpells }, --Healing Touch (Rank 4)
            { 5215, Team.Universal, Race.Universal, Class.Druid, 20, -1, false, Config.EnableClassSpells }, --Prowl
            { 6756, Team.Universal, Race.Universal, Class.Druid, 20, 5232, false, Config.EnableClassSpells }, --Mark of the Wild (Rank 3)
            { 20484, Team.Universal, Race.Universal, Class.Druid, 20, -1, false, Config.EnableClassSpells }, --Rebirth (Rank 1)
            { 2090, Team.Universal, Race.Universal, Class.Druid, 22, 1430, false, Config.EnableClassSpells }, --Rejuvenation (Rank 4)
            { 2908, Team.Universal, Race.Universal, Class.Druid, 22, -1, false, Config.EnableClassSpells }, --Soothe Animal (Rank 1)
            { 5179, Team.Universal, Race.Universal, Class.Druid, 22, 5178, false, Config.EnableClassSpells }, --Wrath (Rank 4)
            { 5221, Team.Universal, Race.Universal, Class.Druid, 22, -1, false, Config.EnableClassSpells }, --Shred (Rank 1)
            { 8926, Team.Universal, Race.Universal, Class.Druid, 22, 8925, false, Config.EnableClassSpells }, --Moonfire (Rank 4)
            { 780, Team.Universal, Race.Universal, Class.Druid, 24, 779, false, Config.EnableClassSpells }, --Swipe (Bear) (Rank 2)
            { 1075, Team.Universal, Race.Universal, Class.Druid, 24, 782, false, Config.EnableClassSpells }, --Thorns (Rank 3)
            { 1822, Team.Universal, Race.Universal, Class.Druid, 24, -1, false, Config.EnableClassSpells }, --Rake (Rank 1)
            { 2782, Team.Universal, Race.Universal, Class.Druid, 24, -1, false, Config.EnableClassSpells }, --Remove Curse
            { 5217, Team.Universal, Race.Universal, Class.Druid, 24, -1, false, Config.EnableClassSpells }, --Tiger's Fury (Rank 1)
            { 8939, Team.Universal, Race.Universal, Class.Druid, 24, 8938, false, Config.EnableClassSpells }, --Regrowth (Rank 3)
            { 50768, Team.Universal, Race.Universal, Class.Druid, 24, 50769, false, Config.EnableClassSpells }, --Revive (Rank 2)
            { 1850, Team.Universal, Race.Universal, Class.Druid, 26, -1, false, Config.EnableClassSpells }, --Dash (Rank 1)
            { 2893, Team.Universal, Race.Universal, Class.Druid, 26, -1, false, Config.EnableClassSpells }, --Abolish Poison
            { 5189, Team.Universal, Race.Universal, Class.Druid, 26, 5188, false, Config.EnableClassSpells }, --Healing Touch (Rank 5)
            { 6809, Team.Universal, Race.Universal, Class.Druid, 26, 6808, false, Config.EnableClassSpells }, --Maul (Rank 3)
            { 8949, Team.Universal, Race.Universal, Class.Druid, 26, 2912, false, Config.EnableClassSpells }, --Starfire (Rank 2)
            { 2091, Team.Universal, Race.Universal, Class.Druid, 28, 2090, false, Config.EnableClassSpells }, --Rejuvenation (Rank 5)
            { 3029, Team.Universal, Race.Universal, Class.Druid, 28, 1082, false, Config.EnableClassSpells }, --Claw (Rank 2)
            { 5195, Team.Universal, Race.Universal, Class.Druid, 28, 1062, false, Config.EnableClassSpells }, --Entangling Roots (Rank 3)
            { 5209, Team.Universal, Race.Universal, Class.Druid, 28, -1, false, Config.EnableClassSpells }, --Challenging Roar
            { 8927, Team.Universal, Race.Universal, Class.Druid, 28, 8926, false, Config.EnableClassSpells }, --Moonfire (Rank 5)
            { 8998, Team.Universal, Race.Universal, Class.Druid, 28, -1, false, Config.EnableClassSpells }, --Cower (Rank 1)
            { 9492, Team.Universal, Race.Universal, Class.Druid, 28, 1079, false, Config.EnableClassSpells }, --Rip (Rank 2)
            { 16811, Team.Universal, Race.Universal, Class.Druid, 28, 16810, false, Config.EnableClassSpells }, --Nature's Grasp (Rank 3)
            { 740, Team.Universal, Race.Universal, Class.Druid, 30, -1, false, Config.EnableClassSpells }, --Tranquility (Rank 1)
            { 5180, Team.Universal, Race.Universal, Class.Druid, 30, 5179, false, Config.EnableClassSpells }, --Wrath (Rank 5)
            { 5234, Team.Universal, Race.Universal, Class.Druid, 30, 6756, false, Config.EnableClassSpells }, --Mark of the Wild (Rank 4)
            { 6798, Team.Universal, Race.Universal, Class.Druid, 30, 5211, false, Config.EnableClassSpells }, --Bash (Rank 2)
            { 6800, Team.Universal, Race.Universal, Class.Druid, 30, 5221, false, Config.EnableClassSpells }, --Shred (Rank 2)
            { 8940, Team.Universal, Race.Universal, Class.Druid, 30, 8939, false, Config.EnableClassSpells }, --Regrowth (Rank 4)
            { 20739, Team.Universal, Race.Universal, Class.Druid, 30, 20484, false, Config.EnableClassSpells }, --Rebirth (Rank 2)
            { 5225, Team.Universal, Race.Universal, Class.Druid, 32, -1, false, Config.EnableClassSpells }, --Track Humanoids
            { 6778, Team.Universal, Race.Universal, Class.Druid, 32, 5189, false, Config.EnableClassSpells }, --Healing Touch (Rank 6)
            { 6785, Team.Universal, Race.Universal, Class.Druid, 32, -1, false, Config.EnableClassSpells }, --Ravage (Rank 1)
            { 9490, Team.Universal, Race.Universal, Class.Druid, 32, 1735, false, Config.EnableClassSpells }, --Demoralizing Roar (Rank 3)
            { 22568, Team.Universal, Race.Universal, Class.Druid, 32, -1, false, Config.EnableClassSpells }, --Ferocious Bite (Rank 1)
            { 769, Team.Universal, Race.Universal, Class.Druid, 34, 780, false, Config.EnableClassSpells }, --Swipe (Bear) (Rank 3)
            { 1823, Team.Universal, Race.Universal, Class.Druid, 34, 1822, false, Config.EnableClassSpells }, --Rake (Rank 2)
            { 3627, Team.Universal, Race.Universal, Class.Druid, 34, 2091, false, Config.EnableClassSpells }, --Rejuvenation (Rank 6)
            { 8914, Team.Universal, Race.Universal, Class.Druid, 34, 1075, false, Config.EnableClassSpells }, --Thorns (Rank 4)
            { 8928, Team.Universal, Race.Universal, Class.Druid, 34, 8927, false, Config.EnableClassSpells }, --Moonfire (Rank 6)
            { 8950, Team.Universal, Race.Universal, Class.Druid, 34, 8949, false, Config.EnableClassSpells }, --Starfire (Rank 3)
            { 8972, Team.Universal, Race.Universal, Class.Druid, 34, 6809, false, Config.EnableClassSpells }, --Maul (Rank 4)
            { 6793, Team.Universal, Race.Universal, Class.Druid, 36, 5217, false, Config.EnableClassSpells }, --Tiger's Fury (Rank 2)
            { 8941, Team.Universal, Race.Universal, Class.Druid, 36, 8940, false, Config.EnableClassSpells }, --Regrowth (Rank 5)
            { 9005, Team.Universal, Race.Universal, Class.Druid, 36, -1, false, Config.EnableClassSpells }, --Pounce (Rank 1)
            { 9493, Team.Universal, Race.Universal, Class.Druid, 36, 9492, false, Config.EnableClassSpells }, --Rip (Rank 3)
            { 22842, Team.Universal, Race.Universal, Class.Druid, 36, -1, false, Config.EnableClassSpells }, --Frenzied Regeneration
            { 50767, Team.Universal, Race.Universal, Class.Druid, 36, 50768, false, Config.EnableClassSpells }, --Revive (Rank 3)
            { 5196, Team.Universal, Race.Universal, Class.Druid, 38, 5195, false, Config.EnableClassSpells }, --Entangling Roots (Rank 4)
            { 5201, Team.Universal, Race.Universal, Class.Druid, 38, 3029, false, Config.EnableClassSpells }, --Claw (Rank 3)
            { 6780, Team.Universal, Race.Universal, Class.Druid, 38, 5180, false, Config.EnableClassSpells }, --Wrath (Rank 6)
            { 8903, Team.Universal, Race.Universal, Class.Druid, 38, 6778, false, Config.EnableClassSpells }, --Healing Touch (Rank 7)
            { 8955, Team.Universal, Race.Universal, Class.Druid, 38, 2908, false, Config.EnableClassSpells }, --Soothe Animal (Rank 2)
            { 8992, Team.Universal, Race.Universal, Class.Druid, 38, 6800, false, Config.EnableClassSpells }, --Shred (Rank 3)
            { 16812, Team.Universal, Race.Universal, Class.Druid, 38, 16811, false, Config.EnableClassSpells }, --Nature's Grasp (Rank 4)
            { 18657, Team.Universal, Race.Universal, Class.Druid, 38, 2637, false, Config.EnableClassSpells }, --Hibernate (Rank 2)
            { 8907, Team.Universal, Race.Universal, Class.Druid, 40, 5234, false, Config.EnableClassSpells }, --Mark of the Wild (Rank 5)
            { 8910, Team.Universal, Race.Universal, Class.Druid, 40, 3627, false, Config.EnableClassSpells }, --Rejuvenation (Rank 7)
            { 8918, Team.Universal, Race.Universal, Class.Druid, 40, 740, false, Config.EnableClassSpells }, --Tranquility (Rank 2)
            { 8929, Team.Universal, Race.Universal, Class.Druid, 40, 8928, false, Config.EnableClassSpells }, --Moonfire (Rank 7)
            { 9000, Team.Universal, Race.Universal, Class.Druid, 40, 8998, false, Config.EnableClassSpells }, --Cower (Rank 2)
            { 9634, Team.Universal, Race.Universal, Class.Druid, 40, -1, false, Config.EnableClassSpells }, --Dire Bear Form (Shapeshift)
            { 16914, Team.Universal, Race.Universal, Class.Druid, 40, -1, false, Config.EnableClassSpells }, --Hurricane (Rank 1)
            { 20719, Team.Universal, Race.Universal, Class.Druid, 40, -1, false, Config.EnableClassSpells }, --Feline Grace (Passive)
            { 20742, Team.Universal, Race.Universal, Class.Druid, 40, 20739, false, Config.EnableClassSpells }, --Rebirth (Rank 3)
            { 22827, Team.Universal, Race.Universal, Class.Druid, 40, 22568, false, Config.EnableClassSpells }, --Ferocious Bite (Rank 2)
            { 29166, Team.Universal, Race.Universal, Class.Druid, 40, -1, false, Config.EnableClassSpells }, --Innervate
            { 62600, Team.Universal, Race.Universal, Class.Druid, 40, -1, false, Config.EnableClassSpells }, --Savage Defense (Passive)
            { 6787, Team.Universal, Race.Universal, Class.Druid, 42, 6785, false, Config.EnableClassSpells }, --Ravage (Rank 2)
            { 8951, Team.Universal, Race.Universal, Class.Druid, 42, 8950, false, Config.EnableClassSpells }, --Starfire (Rank 4)
            { 9745, Team.Universal, Race.Universal, Class.Druid, 42, 8972, false, Config.EnableClassSpells }, --Maul (Rank 5)
            { 9747, Team.Universal, Race.Universal, Class.Druid, 42, 9490, false, Config.EnableClassSpells }, --Demoralizing Roar (Rank 4)
            { 9750, Team.Universal, Race.Universal, Class.Druid, 42, 8941, false, Config.EnableClassSpells }, --Regrowth (Rank 6)
            { 1824, Team.Universal, Race.Universal, Class.Druid, 44, 1823, false, Config.EnableClassSpells }, --Rake (Rank 3)
            { 9752, Team.Universal, Race.Universal, Class.Druid, 44, 9493, false, Config.EnableClassSpells }, --Rip (Rank 4)
            { 9754, Team.Universal, Race.Universal, Class.Druid, 44, 769, false, Config.EnableClassSpells }, --Swipe (Bear) (Rank 4)
            { 9756, Team.Universal, Race.Universal, Class.Druid, 44, 8914, false, Config.EnableClassSpells }, --Thorns (Rank 5)
            { 9758, Team.Universal, Race.Universal, Class.Druid, 44, 8903, false, Config.EnableClassSpells }, --Healing Touch (Rank 8)
            { 22812, Team.Universal, Race.Universal, Class.Druid, 44, -1, false, Config.EnableClassSpells }, --Barkskin
            { 8905, Team.Universal, Race.Universal, Class.Druid, 46, 6780, false, Config.EnableClassSpells }, --Wrath (Rank 7)
            { 8983, Team.Universal, Race.Universal, Class.Druid, 46, 6798, false, Config.EnableClassSpells }, --Bash (Rank 3)
            { 9821, Team.Universal, Race.Universal, Class.Druid, 46, 1850, false, Config.EnableClassSpells }, --Dash (Rank 2)
            { 9823, Team.Universal, Race.Universal, Class.Druid, 46, 9005, false, Config.EnableClassSpells }, --Pounce (Rank 2)
            { 9829, Team.Universal, Race.Universal, Class.Druid, 46, 8992, false, Config.EnableClassSpells }, --Shred (Rank 4)
            { 9833, Team.Universal, Race.Universal, Class.Druid, 46, 8929, false, Config.EnableClassSpells }, --Moonfire (Rank 8)
            { 9839, Team.Universal, Race.Universal, Class.Druid, 46, 8910, false, Config.EnableClassSpells }, --Rejuvenation (Rank 8)
            { 9845, Team.Universal, Race.Universal, Class.Druid, 48, 6793, false, Config.EnableClassSpells }, --Tiger's Fury (Rank 3)
            { 9849, Team.Universal, Race.Universal, Class.Druid, 48, 5201, false, Config.EnableClassSpells }, --Claw (Rank 4)
            { 9852, Team.Universal, Race.Universal, Class.Druid, 48, 5196, false, Config.EnableClassSpells }, --Entangling Roots (Rank 5)
            { 9856, Team.Universal, Race.Universal, Class.Druid, 48, 9750, false, Config.EnableClassSpells }, --Regrowth (Rank 7)
            { 16813, Team.Universal, Race.Universal, Class.Druid, 48, 16812, false, Config.EnableClassSpells }, --Nature's Grasp (Rank 5)
            { 22828, Team.Universal, Race.Universal, Class.Druid, 48, 22827, false, Config.EnableClassSpells }, --Ferocious Bite (Rank 3)
            { 50766, Team.Universal, Race.Universal, Class.Druid, 48, 50767, false, Config.EnableClassSpells }, --Revive (Rank 4)
            { 9862, Team.Universal, Race.Universal, Class.Druid, 50, 8918, false, Config.EnableClassSpells }, --Tranquility (Rank 3)
            { 9866, Team.Universal, Race.Universal, Class.Druid, 50, 6787, false, Config.EnableClassSpells }, --Ravage (Rank 3)
            { 9875, Team.Universal, Race.Universal, Class.Druid, 50, 8951, false, Config.EnableClassSpells }, --Starfire (Rank 5)
            { 9880, Team.Universal, Race.Universal, Class.Druid, 50, 9745, false, Config.EnableClassSpells }, --Maul (Rank 6)
            { 9884, Team.Universal, Race.Universal, Class.Druid, 50, 8907, false, Config.EnableClassSpells }, --Mark of the Wild (Rank 6)
            { 9888, Team.Universal, Race.Universal, Class.Druid, 50, 9758, false, Config.EnableClassSpells }, --Healing Touch (Rank 9)
            { 17401, Team.Universal, Race.Universal, Class.Druid, 50, 16914, false, Config.EnableClassSpells }, --Hurricane (Rank 2)
            { 20747, Team.Universal, Race.Universal, Class.Druid, 50, 20742, false, Config.EnableClassSpells }, --Rebirth (Rank 4)
            { 21849, Team.Universal, Race.Universal, Class.Druid, 50, -1, false, Config.EnableClassSpells }, --Gift of the Wild (Rank 1)
            { 9834, Team.Universal, Race.Universal, Class.Druid, 52, 9833, false, Config.EnableClassSpells }, --Moonfire (Rank 9)
            { 9840, Team.Universal, Race.Universal, Class.Druid, 52, 9839, false, Config.EnableClassSpells }, --Rejuvenation (Rank 9)
            { 9892, Team.Universal, Race.Universal, Class.Druid, 52, 9000, false, Config.EnableClassSpells }, --Cower (Rank 3)
            { 9894, Team.Universal, Race.Universal, Class.Druid, 52, 9752, false, Config.EnableClassSpells }, --Rip (Rank 5)
            { 9898, Team.Universal, Race.Universal, Class.Druid, 52, 9747, false, Config.EnableClassSpells }, --Demoralizing Roar (Rank 5)
            { 9830, Team.Universal, Race.Universal, Class.Druid, 54, 9829, false, Config.EnableClassSpells }, --Shred (Rank 5)
            { 9857, Team.Universal, Race.Universal, Class.Druid, 54, 9856, false, Config.EnableClassSpells }, --Regrowth (Rank 8)
            { 9901, Team.Universal, Race.Universal, Class.Druid, 54, 8955, false, Config.EnableClassSpells }, --Soothe Animal (Rank 3)
            { 9904, Team.Universal, Race.Universal, Class.Druid, 54, 1824, false, Config.EnableClassSpells }, --Rake (Rank 4)
            { 9908, Team.Universal, Race.Universal, Class.Druid, 54, 9754, false, Config.EnableClassSpells }, --Swipe (Bear) (Rank 5)
            { 9910, Team.Universal, Race.Universal, Class.Druid, 54, 9756, false, Config.EnableClassSpells }, --Thorns (Rank 6)
            { 9912, Team.Universal, Race.Universal, Class.Druid, 54, 8905, false, Config.EnableClassSpells }, --Wrath (Rank 8)
            { 9827, Team.Universal, Race.Universal, Class.Druid, 56, 9823, false, Config.EnableClassSpells }, --Pounce (Rank 3)
            { 9889, Team.Universal, Race.Universal, Class.Druid, 56, 9888, false, Config.EnableClassSpells }, --Healing Touch (Rank 10)
            { 22829, Team.Universal, Race.Universal, Class.Druid, 56, 22828, false, Config.EnableClassSpells }, --Ferocious Bite (Rank 4)
            { 9835, Team.Universal, Race.Universal, Class.Druid, 58, 9834, false, Config.EnableClassSpells }, --Moonfire (Rank 10)
            { 9841, Team.Universal, Race.Universal, Class.Druid, 58, 9840, false, Config.EnableClassSpells }, --Rejuvenation (Rank 10)
            { 9850, Team.Universal, Race.Universal, Class.Druid, 58, 9849, false, Config.EnableClassSpells }, --Claw (Rank 5)
            { 9853, Team.Universal, Race.Universal, Class.Druid, 58, 9852, false, Config.EnableClassSpells }, --Entangling Roots (Rank 6)
            { 9867, Team.Universal, Race.Universal, Class.Druid, 58, 9866, false, Config.EnableClassSpells }, --Ravage (Rank 4)
            { 9876, Team.Universal, Race.Universal, Class.Druid, 58, 9875, false, Config.EnableClassSpells }, --Starfire (Rank 6)
            { 9881, Team.Universal, Race.Universal, Class.Druid, 58, 9880, false, Config.EnableClassSpells }, --Maul (Rank 7)
            { 17329, Team.Universal, Race.Universal, Class.Druid, 58, 16813, false, Config.EnableClassSpells }, --Nature's Grasp (Rank 6)
            { 18658, Team.Universal, Race.Universal, Class.Druid, 58, 18657, false, Config.EnableClassSpells }, --Hibernate (Rank 3)
            { 9846, Team.Universal, Race.Universal, Class.Druid, 60, 9845, false, Config.EnableClassSpells }, --Tiger's Fury (Rank 4)
            { 9858, Team.Universal, Race.Universal, Class.Druid, 60, 9857, false, Config.EnableClassSpells }, --Regrowth (Rank 9)
            { 9863, Team.Universal, Race.Universal, Class.Druid, 60, 9862, false, Config.EnableClassSpells }, --Tranquility (Rank 4)
            { 9885, Team.Universal, Race.Universal, Class.Druid, 60, 9884, false, Config.EnableClassSpells }, --Mark of the Wild (Rank 7)
            { 9896, Team.Universal, Race.Universal, Class.Druid, 60, 9894, false, Config.EnableClassSpells }, --Rip (Rank 6)
            { 17402, Team.Universal, Race.Universal, Class.Druid, 60, 17401, false, Config.EnableClassSpells }, --Hurricane (Rank 3)
            { 20748, Team.Universal, Race.Universal, Class.Druid, 60, 20747, false, Config.EnableClassSpells }, --Rebirth (Rank 5)
            { 21850, Team.Universal, Race.Universal, Class.Druid, 60, 21849, false, Config.EnableClassSpells }, --Gift of the Wild (Rank 2)
            { 25297, Team.Universal, Race.Universal, Class.Druid, 60, 9889, false, Config.EnableClassSpells }, --Healing Touch (Rank 11)
            { 25298, Team.Universal, Race.Universal, Class.Druid, 60, 9876, false, Config.EnableClassSpells }, --Starfire (Rank 7)
            { 25299, Team.Universal, Race.Universal, Class.Druid, 60, 9841, false, Config.EnableClassSpells }, --Rejuvenation (Rank 11)
            { 31018, Team.Universal, Race.Universal, Class.Druid, 60, 22829, false, Config.EnableClassSpells }, --Ferocious Bite (Rank 5)
            { 31709, Team.Universal, Race.Universal, Class.Druid, 60, 9892, false, Config.EnableClassSpells }, --Cower (Rank 4)
            { 33943, Team.Universal, Race.Universal, Class.Druid, 60, 34090, false, Config.EnableClassSpells }, --Flight Form (Shapeshift)
            { 50765, Team.Universal, Race.Universal, Class.Druid, 60, 50766, false, Config.EnableClassSpells }, --Revive (Rank 5)
            { 26984, Team.Universal, Race.Universal, Class.Druid, 61, 9912, false, Config.EnableClassSpells }, --Wrath (Rank 9)
            { 27001, Team.Universal, Race.Universal, Class.Druid, 61, 9830, false, Config.EnableClassSpells }, --Shred (Rank 6)
            { 22570, Team.Universal, Race.Universal, Class.Druid, 62, -1, false, Config.EnableClassSpells }, --Maim (Rank 1)
            { 26978, Team.Universal, Race.Universal, Class.Druid, 62, 25297, false, Config.EnableClassSpells }, --Healing Touch (Rank 12)
            { 26998, Team.Universal, Race.Universal, Class.Druid, 62, 9898, false, Config.EnableClassSpells }, --Demoralizing Roar (Rank 6)
            { 24248, Team.Universal, Race.Universal, Class.Druid, 63, 31018, false, Config.EnableClassSpells }, --Ferocious Bite (Rank 6)
            { 26981, Team.Universal, Race.Universal, Class.Druid, 63, 25299, false, Config.EnableClassSpells }, --Rejuvenation (Rank 12)
            { 26987, Team.Universal, Race.Universal, Class.Druid, 63, 9835, false, Config.EnableClassSpells }, --Moonfire (Rank 11)
            { 26992, Team.Universal, Race.Universal, Class.Druid, 64, 9910, false, Config.EnableClassSpells }, --Thorns (Rank 7)
            { 26997, Team.Universal, Race.Universal, Class.Druid, 64, 9908, false, Config.EnableClassSpells }, --Swipe (Bear) (Rank 6)
            { 27003, Team.Universal, Race.Universal, Class.Druid, 64, 9904, false, Config.EnableClassSpells }, --Rake (Rank 5)
            { 33763, Team.Universal, Race.Universal, Class.Druid, 64, -1, false, Config.EnableClassSpells }, --Lifebloom (Rank 1)
            { 26980, Team.Universal, Race.Universal, Class.Druid, 65, 9858, false, Config.EnableClassSpells }, --Regrowth (Rank 10)
            { 33357, Team.Universal, Race.Universal, Class.Druid, 65, 9821, false, Config.EnableClassSpells }, --Dash (Rank 3)
            { 27005, Team.Universal, Race.Universal, Class.Druid, 66, 9867, false, Config.EnableClassSpells }, --Ravage (Rank 5)
            { 27006, Team.Universal, Race.Universal, Class.Druid, 66, 9827, false, Config.EnableClassSpells }, --Pounce (Rank 4)
            { 33745, Team.Universal, Race.Universal, Class.Druid, 66, -1, false, Config.EnableClassSpells }, --Lacerate (Rank 1)
            { 26986, Team.Universal, Race.Universal, Class.Druid, 67, 25298, false, Config.EnableClassSpells }, --Starfire (Rank 8)
            { 26996, Team.Universal, Race.Universal, Class.Druid, 67, 9881, false, Config.EnableClassSpells }, --Maul (Rank 8)
            { 27000, Team.Universal, Race.Universal, Class.Druid, 67, 9850, false, Config.EnableClassSpells }, --Claw (Rank 6)
            { 27008, Team.Universal, Race.Universal, Class.Druid, 67, 9896, false, Config.EnableClassSpells }, --Rip (Rank 7)
            { 26989, Team.Universal, Race.Universal, Class.Druid, 68, 9853, false, Config.EnableClassSpells }, --Entangling Roots (Rank 7)
            { 27009, Team.Universal, Race.Universal, Class.Druid, 68, 17329, false, Config.EnableClassSpells }, --Nature's Grasp (Rank 7)
            { 26979, Team.Universal, Race.Universal, Class.Druid, 69, 26978, false, Config.EnableClassSpells }, --Healing Touch (Rank 13)
            { 26982, Team.Universal, Race.Universal, Class.Druid, 69, 26981, false, Config.EnableClassSpells }, --Rejuvenation (Rank 13)
            { 26985, Team.Universal, Race.Universal, Class.Druid, 69, 26984, false, Config.EnableClassSpells }, --Wrath (Rank 10)
            { 26994, Team.Universal, Race.Universal, Class.Druid, 69, 20748, false, Config.EnableClassSpells }, --Rebirth (Rank 6)
            { 27004, Team.Universal, Race.Universal, Class.Druid, 69, 31709, false, Config.EnableClassSpells }, --Cower (Rank 5)
            { 50764, Team.Universal, Race.Universal, Class.Druid, 69, 50765, false, Config.EnableClassSpells }, --Revive (Rank 6)
            { 26983, Team.Universal, Race.Universal, Class.Druid, 70, 9863, false, Config.EnableClassSpells }, --Tranquility (Rank 5)
            { 26988, Team.Universal, Race.Universal, Class.Druid, 70, 26987, false, Config.EnableClassSpells }, --Moonfire (Rank 12)
            { 26990, Team.Universal, Race.Universal, Class.Druid, 70, 9885, false, Config.EnableClassSpells }, --Mark of the Wild (Rank 8)
            { 26991, Team.Universal, Race.Universal, Class.Druid, 70, 21850, false, Config.EnableClassSpells }, --Gift of the Wild (Rank 3)
            { 26995, Team.Universal, Race.Universal, Class.Druid, 70, 9901, false, Config.EnableClassSpells }, --Soothe Animal (Rank 4)
            { 27002, Team.Universal, Race.Universal, Class.Druid, 70, 27001, false, Config.EnableClassSpells }, --Shred (Rank 7)
            { 27012, Team.Universal, Race.Universal, Class.Druid, 70, 17402, false, Config.EnableClassSpells }, --Hurricane (Rank 4)
            { 33786, Team.Universal, Race.Universal, Class.Druid, 70, -1, false, Config.EnableClassSpells }, --Cyclone
            { 40120, Team.Universal, Race.Universal, Class.Druid, 71, 34091, false, Config.EnableClassSpells }, --Swift Flight Form (Shapeshift)
            { 48442, Team.Universal, Race.Universal, Class.Druid, 71, 26980, false, Config.EnableClassSpells }, --Regrowth (Rank 11)
            { 48559, Team.Universal, Race.Universal, Class.Druid, 71, 26998, false, Config.EnableClassSpells }, --Demoralizing Roar (Rank 7)
            { 49799, Team.Universal, Race.Universal, Class.Druid, 71, 27008, false, Config.EnableClassSpells }, --Rip (Rank 8)
            { 50212, Team.Universal, Race.Universal, Class.Druid, 71, 9846, false, Config.EnableClassSpells }, --Tiger's Fury (Rank 5)
            { 62078, Team.Universal, Race.Universal, Class.Druid, 71, -1, false, Config.EnableClassSpells }, --Swipe (Cat) (Rank 1)
            { 48450, Team.Universal, Race.Universal, Class.Druid, 72, 33763, false, Config.EnableClassSpells }, --Lifebloom (Rank 2)
            { 48464, Team.Universal, Race.Universal, Class.Druid, 72, 26986, false, Config.EnableClassSpells }, --Starfire (Rank 9)
            { 48561, Team.Universal, Race.Universal, Class.Druid, 72, 26997, false, Config.EnableClassSpells }, --Swipe (Bear) (Rank 7)
            { 48573, Team.Universal, Race.Universal, Class.Druid, 72, 27003, false, Config.EnableClassSpells }, --Rake (Rank 6)
            { 48576, Team.Universal, Race.Universal, Class.Druid, 72, 24248, false, Config.EnableClassSpells }, --Ferocious Bite (Rank 7)
            { 48479, Team.Universal, Race.Universal, Class.Druid, 73, 26996, false, Config.EnableClassSpells }, --Maul (Rank 9)
            { 48567, Team.Universal, Race.Universal, Class.Druid, 73, 33745, false, Config.EnableClassSpells }, --Lacerate (Rank 2)
            { 48569, Team.Universal, Race.Universal, Class.Druid, 73, 27000, false, Config.EnableClassSpells }, --Claw (Rank 7)
            { 48578, Team.Universal, Race.Universal, Class.Druid, 73, 27005, false, Config.EnableClassSpells }, --Ravage (Rank 6)
            { 48377, Team.Universal, Race.Universal, Class.Druid, 74, 26979, false, Config.EnableClassSpells }, --Healing Touch (Rank 14)
            { 48459, Team.Universal, Race.Universal, Class.Druid, 74, 26985, false, Config.EnableClassSpells }, --Wrath (Rank 11)
            { 49802, Team.Universal, Race.Universal, Class.Druid, 74, 22570, false, Config.EnableClassSpells }, --Maim (Rank 2)
            { 53307, Team.Universal, Race.Universal, Class.Druid, 74, 26992, false, Config.EnableClassSpells }, --Thorns (Rank 8)
            { 48440, Team.Universal, Race.Universal, Class.Druid, 75, 26982, false, Config.EnableClassSpells }, --Rejuvenation (Rank 14)
            { 48446, Team.Universal, Race.Universal, Class.Druid, 75, 26983, false, Config.EnableClassSpells }, --Tranquility (Rank 6)
            { 48462, Team.Universal, Race.Universal, Class.Druid, 75, 26988, false, Config.EnableClassSpells }, --Moonfire (Rank 13)
            { 48571, Team.Universal, Race.Universal, Class.Druid, 75, 27002, false, Config.EnableClassSpells }, --Shred (Rank 8)
            { 52610, Team.Universal, Race.Universal, Class.Druid, 75, -1, false, Config.EnableClassSpells }, --Savage Roar (Rank 1)
            { 48575, Team.Universal, Race.Universal, Class.Druid, 76, 27004, false, Config.EnableClassSpells }, --Cower (Rank 6)
            { 48443, Team.Universal, Race.Universal, Class.Druid, 77, 48442, false, Config.EnableClassSpells }, --Regrowth (Rank 12)
            { 48560, Team.Universal, Race.Universal, Class.Druid, 77, 48559, false, Config.EnableClassSpells }, --Demoralizing Roar (Rank 8)
            { 48562, Team.Universal, Race.Universal, Class.Druid, 77, 48561, false, Config.EnableClassSpells }, --Swipe (Bear) (Rank 8)
            { 49803, Team.Universal, Race.Universal, Class.Druid, 77, 27006, false, Config.EnableClassSpells }, --Pounce (Rank 5)
            { 48465, Team.Universal, Race.Universal, Class.Druid, 78, 48464, false, Config.EnableClassSpells }, --Starfire (Rank 10)
            { 48574, Team.Universal, Race.Universal, Class.Druid, 78, 48573, false, Config.EnableClassSpells }, --Rake (Rank 7)
            { 48577, Team.Universal, Race.Universal, Class.Druid, 78, 48576, false, Config.EnableClassSpells }, --Ferocious Bite (Rank 8)
            { 53308, Team.Universal, Race.Universal, Class.Druid, 78, 26989, false, Config.EnableClassSpells }, --Entangling Roots (Rank 8)
            { 53312, Team.Universal, Race.Universal, Class.Druid, 78, 27009, false, Config.EnableClassSpells }, --Nature's Grasp (Rank 8)
            { 48378, Team.Universal, Race.Universal, Class.Druid, 79, 48377, false, Config.EnableClassSpells }, --Healing Touch (Rank 15)
            { 48461, Team.Universal, Race.Universal, Class.Druid, 79, 48459, false, Config.EnableClassSpells }, --Wrath (Rank 12)
            { 48477, Team.Universal, Race.Universal, Class.Druid, 79, 26994, false, Config.EnableClassSpells }, --Rebirth (Rank 7)
            { 48480, Team.Universal, Race.Universal, Class.Druid, 79, 48479, false, Config.EnableClassSpells }, --Maul (Rank 10)
            { 48570, Team.Universal, Race.Universal, Class.Druid, 79, 48569, false, Config.EnableClassSpells }, --Claw (Rank 8)
            { 48579, Team.Universal, Race.Universal, Class.Druid, 79, 48578, false, Config.EnableClassSpells }, --Ravage (Rank 7)
            { 50213, Team.Universal, Race.Universal, Class.Druid, 79, 50212, false, Config.EnableClassSpells }, --Tiger's Fury (Rank 6)
            { 48441, Team.Universal, Race.Universal, Class.Druid, 80, 48440, false, Config.EnableClassSpells }, --Rejuvenation (Rank 15)
            { 48447, Team.Universal, Race.Universal, Class.Druid, 80, 48446, false, Config.EnableClassSpells }, --Tranquility (Rank 7)
            { 48451, Team.Universal, Race.Universal, Class.Druid, 80, 48450, false, Config.EnableClassSpells }, --Lifebloom (Rank 3)
            { 48463, Team.Universal, Race.Universal, Class.Druid, 80, 48462, false, Config.EnableClassSpells }, --Moonfire (Rank 14)
            { 48467, Team.Universal, Race.Universal, Class.Druid, 80, 27012, false, Config.EnableClassSpells }, --Hurricane (Rank 5)
            { 48469, Team.Universal, Race.Universal, Class.Druid, 80, 26990, false, Config.EnableClassSpells }, --Mark of the Wild (Rank 9)
            { 48470, Team.Universal, Race.Universal, Class.Druid, 80, 26991, false, Config.EnableClassSpells }, --Gift of the Wild (Rank 4)
            { 48568, Team.Universal, Race.Universal, Class.Druid, 80, 48567, false, Config.EnableClassSpells }, --Lacerate (Rank 3)
            { 48572, Team.Universal, Race.Universal, Class.Druid, 80, 48571, false, Config.EnableClassSpells }, --Shred (Rank 9)
            { 49800, Team.Universal, Race.Universal, Class.Druid, 80, 49799, false, Config.EnableClassSpells }, --Rip (Rank 9)
            { 50464, Team.Universal, Race.Universal, Class.Druid, 80, -1, false, Config.EnableClassSpells }, --Nourish (Rank 1)
            { 50763, Team.Universal, Race.Universal, Class.Druid, 80, 50764, false, Config.EnableClassSpells } -- Revive (Rank 7)
        }
    elseif (type == Type.Talents) then
        SpellList = {
            -- Warrior
            { 21551, Team.Universal, Race.Universal, Class.Warrior, 48, 12294, false, Config.EnableTalentRanks }, -- Mortal Strike (Rank 2)
            { 21552, Team.Universal, Race.Universal, Class.Warrior, 54, 21551, false, Config.EnableTalentRanks }, -- Mortal Strike (Rank 3)
            { 21553, Team.Universal, Race.Universal, Class.Warrior, 60, 21552, false, Config.EnableTalentRanks }, -- Mortal Strike (Rank 4)
            { 30016, Team.Universal, Race.Universal, Class.Warrior, 60, 20243, false, Config.EnableTalentRanks }, -- Devastate (Rank 2)
            { 25248, Team.Universal, Race.Universal, Class.Warrior, 66, 21553, false, Config.EnableTalentRanks }, -- Mortal Strike (Rank 5)
            { 30022, Team.Universal, Race.Universal, Class.Warrior, 70, 30016, false, Config.EnableTalentRanks }, -- Devastate (Rank 3)
            { 30330, Team.Universal, Race.Universal, Class.Warrior, 70, 25248, false, Config.EnableTalentRanks }, -- Mortal Strike (Rank 6)
            { 47485, Team.Universal, Race.Universal, Class.Warrior, 75, 30330, false, Config.EnableTalentRanks }, -- Mortal Strike (Rank 7)
            { 47497, Team.Universal, Race.Universal, Class.Warrior, 75, 30022, false, Config.EnableTalentRanks }, -- Devastate (Rank 4)
            { 47486, Team.Universal, Race.Universal, Class.Warrior, 80, 47485, false, Config.EnableTalentRanks }, -- Mortal Strike (Rank 8)
            { 47498, Team.Universal, Race.Universal, Class.Warrior, 80, 47497, false, Config.EnableTalentRanks }, -- Devastate (Rank 5)
            -- Paladin
            { 20929, Team.Universal, Race.Universal, Class.Paladin, 48, 20473, false, Config.EnableTalentRanks }, -- Holy Shock (Rank 2)
            { 20927, Team.Universal, Race.Universal, Class.Paladin, 50, 20925, false, Config.EnableTalentRanks }, -- Holy Shield (Rank 2)
            { 20930, Team.Universal, Race.Universal, Class.Paladin, 56, 20929, false, Config.EnableTalentRanks }, -- Holy Shock (Rank 3)
            { 20928, Team.Universal, Race.Universal, Class.Paladin, 60, 20927, false, Config.EnableTalentRanks }, -- Holy Shield (Rank 3)
            { 25899, Team.Universal, Race.Universal, Class.Paladin, 60, 20911, false, Config.EnableTalentRanks }, -- Greater Blessing of Sanctuary
            { 32699, Team.Universal, Race.Universal, Class.Paladin, 60, 31935, false, Config.EnableTalentRanks }, -- Avenger's Shield (Rank 2)
            { 27174, Team.Universal, Race.Universal, Class.Paladin, 64, 20930, false, Config.EnableTalentRanks }, -- Holy Shock (Rank 4)
            { 27179, Team.Universal, Race.Universal, Class.Paladin, 70, 20928, false, Config.EnableTalentRanks }, -- Holy Shield (Rank 4)
            { 32700, Team.Universal, Race.Universal, Class.Paladin, 70, 32699, false, Config.EnableTalentRanks }, -- Avenger's Shield (Rank 3)
            { 33072, Team.Universal, Race.Universal, Class.Paladin, 70, 27174, false, Config.EnableTalentRanks }, -- Holy Shock (Rank 5)
            { 48824, Team.Universal, Race.Universal, Class.Paladin, 75, 33072, false, Config.EnableTalentRanks }, -- Holy Shock (Rank 6)
            { 48826, Team.Universal, Race.Universal, Class.Paladin, 75, 32700, false, Config.EnableTalentRanks }, -- Avenger's Shield (Rank 4)
            { 48951, Team.Universal, Race.Universal, Class.Paladin, 75, 27179, false, Config.EnableTalentRanks }, -- Holy Shield (Rank 5)
            { 48825, Team.Universal, Race.Universal, Class.Paladin, 80, 48824, false, Config.EnableTalentRanks }, -- Holy Shock (Rank 7)
            { 48827, Team.Universal, Race.Universal, Class.Paladin, 80, 48826, false, Config.EnableTalentRanks }, -- Avenger's Shield (Rank 5)
            { 48952, Team.Universal, Race.Universal, Class.Paladin, 80, 48951, false, Config.EnableTalentRanks }, -- Holy Shield (Rank 6)
            -- Hunter
            { 20900, Team.Universal, Race.Universal, Class.Hunter, 28, 19434, false, Config.EnableTalentRanks }, -- Aimed Shot (Rank 2)
            { 20901, Team.Universal, Race.Universal, Class.Hunter, 36, 20900, false, Config.EnableTalentRanks }, -- Aimed Shot (Rank 3)
            { 20909, Team.Universal, Race.Universal, Class.Hunter, 42, 19306, false, Config.EnableTalentRanks }, -- Counterattack (Rank 2)
            { 20902, Team.Universal, Race.Universal, Class.Hunter, 44, 20901, false, Config.EnableTalentRanks }, -- Aimed Shot (Rank 4)
            { 24132, Team.Universal, Race.Universal, Class.Hunter, 50, 19386, false, Config.EnableTalentRanks }, -- Wyvern Sting (Rank 2)
            { 20903, Team.Universal, Race.Universal, Class.Hunter, 52, 20902, false, Config.EnableTalentRanks }, -- Aimed Shot (Rank 5)
            { 20910, Team.Universal, Race.Universal, Class.Hunter, 54, 20909, false, Config.EnableTalentRanks }, -- Counterattack (Rank 3)
            { 63668, Team.Universal, Race.Universal, Class.Hunter, 57, 3674, false, Config.EnableTalentRanks }, -- Black Arrow (Rank 2)
            { 20904, Team.Universal, Race.Universal, Class.Hunter, 60, 20903, false, Config.EnableTalentRanks }, -- Aimed Shot (Rank 6)
            { 24133, Team.Universal, Race.Universal, Class.Hunter, 60, 24132, false, Config.EnableTalentRanks }, -- Wyvern Sting (Rank 3)
            { 63669, Team.Universal, Race.Universal, Class.Hunter, 63, 63668, false, Config.EnableTalentRanks }, -- Black Arrow (Rank 3)
            { 27067, Team.Universal, Race.Universal, Class.Hunter, 66, 20910, false, Config.EnableTalentRanks }, -- Counterattack (Rank 4)
            { 63670, Team.Universal, Race.Universal, Class.Hunter, 69, 63669, false, Config.EnableTalentRanks }, -- Black Arrow (Rank 4)
            { 27065, Team.Universal, Race.Universal, Class.Hunter, 70, 20904, false, Config.EnableTalentRanks }, -- Aimed Shot (Rank 7)
            { 27068, Team.Universal, Race.Universal, Class.Hunter, 70, 24133, false, Config.EnableTalentRanks }, -- Wyvern Sting (Rank 4)
            { 60051, Team.Universal, Race.Universal, Class.Hunter, 70, 53301, false, Config.EnableTalentRanks }, -- Explosive Shot (Rank 2)
            { 48998, Team.Universal, Race.Universal, Class.Hunter, 72, 27067, false, Config.EnableTalentRanks }, -- Counterattack (Rank 5)
            { 49011, Team.Universal, Race.Universal, Class.Hunter, 75, 27068, false, Config.EnableTalentRanks }, -- Wyvern Sting (Rank 5)
            { 49049, Team.Universal, Race.Universal, Class.Hunter, 75, 27065, false, Config.EnableTalentRanks }, -- Aimed Shot (Rank 8)
            { 60052, Team.Universal, Race.Universal, Class.Hunter, 75, 60051, false, Config.EnableTalentRanks }, -- Explosive Shot (Rank 3)
            { 63671, Team.Universal, Race.Universal, Class.Hunter, 75, 63670, false, Config.EnableTalentRanks }, -- Black Arrow (Rank 5)
            { 48999, Team.Universal, Race.Universal, Class.Hunter, 78, 48998, false, Config.EnableTalentRanks }, -- Counterattack (Rank 6)
            { 49012, Team.Universal, Race.Universal, Class.Hunter, 80, 49011, false, Config.EnableTalentRanks }, -- Wyvern Sting (Rank 6)
            { 49050, Team.Universal, Race.Universal, Class.Hunter, 80, 49049, false, Config.EnableTalentRanks }, -- Aimed Shot (Rank 9)
            { 60053, Team.Universal, Race.Universal, Class.Hunter, 80, 60052, false, Config.EnableTalentRanks }, -- Explosive Shot (Rank 4)
            { 63672, Team.Universal, Race.Universal, Class.Hunter, 80, 63671, false, Config.EnableTalentRanks }, -- Black Arrow (Rank 6)
            -- Rogue
            { 17347, Team.Universal, Race.Universal, Class.Rogue, 46, 16511, false, Config.EnableTalentRanks }, -- Hemorrhage (Rank 2)
            { 34411, Team.Universal, Race.Universal, Class.Rogue, 50, 1329, false, Config.EnableTalentRanks }, -- Mutilate (Rank 2)
            { 17348, Team.Universal, Race.Universal, Class.Rogue, 58, 17347, false, Config.EnableTalentRanks }, -- Hemorrhage (Rank 3)
            { 34412, Team.Universal, Race.Universal, Class.Rogue, 60, 34411, false, Config.EnableTalentRanks }, -- Mutilate (Rank 3)
            { 26864, Team.Universal, Race.Universal, Class.Rogue, 70, 17348, false, Config.EnableTalentRanks }, -- Hemorrhage (Rank 4)
            { 34413, Team.Universal, Race.Universal, Class.Rogue, 70, 34412, false, Config.EnableTalentRanks }, -- Mutilate (Rank 4)
            { 48663, Team.Universal, Race.Universal, Class.Rogue, 75, 34413, false, Config.EnableTalentRanks }, -- Mutilate (Rank 5)
            { 48660, Team.Universal, Race.Universal, Class.Rogue, 80, 26864, false, Config.EnableTalentRanks }, -- Hemorrhage (Rank 5)
            { 48666, Team.Universal, Race.Universal, Class.Rogue, 80, 48663, false, Config.EnableTalentRanks }, -- Mutilate (Rank 6)
            -- Priest
            { 19238, Team.Universal, Race.Universal, Class.Priest, 26, 19236, false, Config.EnableTalentRanks }, -- Desperate Prayer (Rank 2)
            { 17311, Team.Universal, Race.Universal, Class.Priest, 28, 15407, false, Config.EnableTalentRanks }, -- Mind Flay (Rank 2)
            { 19240, Team.Universal, Race.Universal, Class.Priest, 34, 19238, false, Config.EnableTalentRanks }, -- Desperate Prayer (Rank 3)
            { 17312, Team.Universal, Race.Universal, Class.Priest, 36, 17311, false, Config.EnableTalentRanks }, -- Mind Flay (Rank 3)
            { 19241, Team.Universal, Race.Universal, Class.Priest, 42, 19240, false, Config.EnableTalentRanks }, -- Desperate Prayer (Rank 4)
            { 17313, Team.Universal, Race.Universal, Class.Priest, 44, 17312, false, Config.EnableTalentRanks }, -- Mind Flay (Rank 4)
            { 19242, Team.Universal, Race.Universal, Class.Priest, 50, 19241, false, Config.EnableTalentRanks }, -- Desperate Prayer (Rank 5)
            { 27870, Team.Universal, Race.Universal, Class.Priest, 50, 724, false, Config.EnableTalentRanks }, -- Lightwell (Rank 2)
            { 17314, Team.Universal, Race.Universal, Class.Priest, 52, 17313, false, Config.EnableTalentRanks }, -- Mind Flay (Rank 5)
            { 34863, Team.Universal, Race.Universal, Class.Priest, 56, 34861, false, Config.EnableTalentRanks }, -- Circle of Healing (Rank 2)
            { 19243, Team.Universal, Race.Universal, Class.Priest, 58, 19242, false, Config.EnableTalentRanks }, -- Desperate Prayer (Rank 6)
            { 18807, Team.Universal, Race.Universal, Class.Priest, 60, 17314, false, Config.EnableTalentRanks }, -- Mind Flay (Rank 6)
            { 27871, Team.Universal, Race.Universal, Class.Priest, 60, 27870, false, Config.EnableTalentRanks }, -- Lightwell (Rank 3)
            { 34864, Team.Universal, Race.Universal, Class.Priest, 60, 34863, false, Config.EnableTalentRanks }, -- Circle of Healing (Rank 3)
            { 34916, Team.Universal, Race.Universal, Class.Priest, 60, 34914, false, Config.EnableTalentRanks }, -- Vampiric Touch (Rank 2)
            { 34865, Team.Universal, Race.Universal, Class.Priest, 65, 34864, false, Config.EnableTalentRanks }, -- Circle of Healing (Rank 4)
            { 25437, Team.Universal, Race.Universal, Class.Priest, 66, 19243, false, Config.EnableTalentRanks }, -- Desperate Prayer (Rank 7)
            { 25387, Team.Universal, Race.Universal, Class.Priest, 68, 18807, false, Config.EnableTalentRanks }, -- Mind Flay (Rank 7)
            { 28275, Team.Universal, Race.Universal, Class.Priest, 70, 27871, false, Config.EnableTalentRanks }, -- Lightwell (Rank 4)
            { 34866, Team.Universal, Race.Universal, Class.Priest, 70, 34865, false, Config.EnableTalentRanks }, -- Circle of Healing (Rank 5)
            { 34917, Team.Universal, Race.Universal, Class.Priest, 70, 34916, false, Config.EnableTalentRanks }, -- Vampiric Touch (Rank 3)
            { 53005, Team.Universal, Race.Universal, Class.Priest, 70, 47540, false, Config.EnableTalentRanks }, -- Penance (Rank 2)
            { 48172, Team.Universal, Race.Universal, Class.Priest, 73, 25437, false, Config.EnableTalentRanks }, -- Desperate Prayer (Rank 8)
            { 48155, Team.Universal, Race.Universal, Class.Priest, 74, 25387, false, Config.EnableTalentRanks }, -- Mind Flay (Rank 8)
            { 48086, Team.Universal, Race.Universal, Class.Priest, 75, 28275, false, Config.EnableTalentRanks }, -- Lightwell (Rank 5)
            { 48088, Team.Universal, Race.Universal, Class.Priest, 75, 34866, false, Config.EnableTalentRanks }, -- Circle of Healing (Rank 6)
            { 48159, Team.Universal, Race.Universal, Class.Priest, 75, 34917, false, Config.EnableTalentRanks }, -- Vampiric Touch (Rank 4)
            { 53006, Team.Universal, Race.Universal, Class.Priest, 75, 53005, false, Config.EnableTalentRanks }, -- Penance (Rank 3)
            { 48087, Team.Universal, Race.Universal, Class.Priest, 80, 48086, false, Config.EnableTalentRanks }, -- Lightwell (Rank 6)
            { 48089, Team.Universal, Race.Universal, Class.Priest, 80, 48088, false, Config.EnableTalentRanks }, -- Circle of Healing (Rank 7)
            { 48156, Team.Universal, Race.Universal, Class.Priest, 80, 48155, false, Config.EnableTalentRanks }, -- Mind Flay (Rank 9)
            { 48160, Team.Universal, Race.Universal, Class.Priest, 80, 48159, false, Config.EnableTalentRanks }, -- Vampiric Touch (Rank 5)
            { 48173, Team.Universal, Race.Universal, Class.Priest, 80, 48172, false, Config.EnableTalentRanks }, -- Desperate Prayer (Rank 9)
            { 53007, Team.Universal, Race.Universal, Class.Priest, 80, 53006, false, Config.EnableTalentRanks }, -- Penance (Rank 4)
            -- Death Knight
            { 55258, Team.Universal, Race.Universal, Class.DeathKnight, 59, 55050, false, Config.EnableTalentRanks }, -- Heart Strike (Rank 2)
            { 51325, Team.Universal, Race.Universal, Class.DeathKnight, 60, 49158, false, Config.EnableTalentRanks }, -- Corpse Explosion (Rank 2)
            { 51416, Team.Universal, Race.Universal, Class.DeathKnight, 60, 49143, false, Config.EnableTalentRanks }, -- Frost Strike (Rank 2)
            { 55259, Team.Universal, Race.Universal, Class.DeathKnight, 64, 55258, false, Config.EnableTalentRanks }, -- Heart Strike (Rank 3)
            { 51417, Team.Universal, Race.Universal, Class.DeathKnight, 65, 51416, false, Config.EnableTalentRanks }, -- Frost Strike (Rank 3)
            { 55265, Team.Universal, Race.Universal, Class.DeathKnight, 67, 55090, false, Config.EnableTalentRanks }, -- Scourge Strike (Rank 2)
            { 55260, Team.Universal, Race.Universal, Class.DeathKnight, 69, 55259, false, Config.EnableTalentRanks }, -- Heart Strike (Rank 4)
            { 51326, Team.Universal, Race.Universal, Class.DeathKnight, 70, 51325, false, Config.EnableTalentRanks }, -- Corpse Explosion (Rank 3)
            { 51409, Team.Universal, Race.Universal, Class.DeathKnight, 70, 49184, false, Config.EnableTalentRanks }, -- Howling Blast (Rank 2)
            { 51418, Team.Universal, Race.Universal, Class.DeathKnight, 70, 51417, false, Config.EnableTalentRanks }, -- Frost Strike (Rank 4)
            { 55270, Team.Universal, Race.Universal, Class.DeathKnight, 73, 55265, false, Config.EnableTalentRanks }, -- Scourge Strike (Rank 3)
            { 55261, Team.Universal, Race.Universal, Class.DeathKnight, 74, 55260, false, Config.EnableTalentRanks }, -- Heart Strike (Rank 5)
            { 51327, Team.Universal, Race.Universal, Class.DeathKnight, 75, 51326, false, Config.EnableTalentRanks }, -- Corpse Explosion (Rank 4)
            { 51410, Team.Universal, Race.Universal, Class.DeathKnight, 75, 51409, false, Config.EnableTalentRanks }, -- Howling Blast (Rank 3)
            { 51419, Team.Universal, Race.Universal, Class.DeathKnight, 75, 51418, false, Config.EnableTalentRanks }, -- Frost Strike (Rank 5)
            { 55271, Team.Universal, Race.Universal, Class.DeathKnight, 79, 55270, false, Config.EnableTalentRanks }, -- Scourge Strike (Rank 4)
            { 51328, Team.Universal, Race.Universal, Class.DeathKnight, 80, 51327, false, Config.EnableTalentRanks }, -- Corpse Explosion (Rank 5)
            { 51411, Team.Universal, Race.Universal, Class.DeathKnight, 80, 51410, false, Config.EnableTalentRanks }, -- Howling Blast (Rank 4)
            { 55262, Team.Universal, Race.Universal, Class.DeathKnight, 80, 55261, false, Config.EnableTalentRanks }, -- Heart Strike (Rank 6)
            { 55268, Team.Universal, Race.Universal, Class.DeathKnight, 80, 51419, false, Config.EnableTalentRanks }, -- Frost Strike (Rank 6)
            -- Shaman
            { 32593, Team.Universal, Race.Universal, Class.Shaman, 60, 974, false, Config.EnableTalentRanks }, -- Earth Shield (Rank 2)
            { 57720, Team.Universal, Race.Universal, Class.Shaman, 60, 30706, false, Config.EnableTalentRanks }, -- Totem of Wrath (Rank 2)
            { 32594, Team.Universal, Race.Universal, Class.Shaman, 70, 32593, false, Config.EnableTalentRanks }, -- Earth Shield (Rank 3)
            { 57721, Team.Universal, Race.Universal, Class.Shaman, 70, 57720, false, Config.EnableTalentRanks }, -- Totem of Wrath (Rank 3)
            { 59156, Team.Universal, Race.Universal, Class.Shaman, 70, 51490, false, Config.EnableTalentRanks }, -- Thunderstorm (Rank 2)
            { 61299, Team.Universal, Race.Universal, Class.Shaman, 70, 61295, false, Config.EnableTalentRanks }, -- Riptide (Rank 2)
            { 49283, Team.Universal, Race.Universal, Class.Shaman, 75, 32594, false, Config.EnableTalentRanks }, -- Earth Shield (Rank 4)
            { 59158, Team.Universal, Race.Universal, Class.Shaman, 75, 59156, false, Config.EnableTalentRanks }, -- Thunderstorm (Rank 3)
            { 61300, Team.Universal, Race.Universal, Class.Shaman, 75, 61299, false, Config.EnableTalentRanks }, -- Riptide (Rank 3)
            { 49284, Team.Universal, Race.Universal, Class.Shaman, 80, 49283, false, Config.EnableTalentRanks }, -- Earth Shield (Rank 5)
            { 57722, Team.Universal, Race.Universal, Class.Shaman, 80, 57721, false, Config.EnableTalentRanks }, -- Totem of Wrath (Rank 4)
            { 59159, Team.Universal, Race.Universal, Class.Shaman, 80, 59158, false, Config.EnableTalentRanks }, -- Thunderstorm (Rank 4)
            { 61301, Team.Universal, Race.Universal, Class.Shaman, 80, 61300, false, Config.EnableTalentRanks }, -- Riptide (Rank 4)
            -- Mage
            { 12505, Team.Universal, Race.Universal, Class.Mage, 24, 11366, false, Config.EnableTalentRanks }, -- Pyroblast (Rank 2)
            { 12522, Team.Universal, Race.Universal, Class.Mage, 30, 12505, false, Config.EnableTalentRanks }, -- Pyroblast (Rank 3)
            { 12523, Team.Universal, Race.Universal, Class.Mage, 36, 12522, false, Config.EnableTalentRanks }, -- Pyroblast (Rank 4)
            { 13018, Team.Universal, Race.Universal, Class.Mage, 36, 11113, false, Config.EnableTalentRanks }, -- Blast Wave (Rank 2)
            { 12524, Team.Universal, Race.Universal, Class.Mage, 42, 12523, false, Config.EnableTalentRanks }, -- Pyroblast (Rank 5)
            { 13019, Team.Universal, Race.Universal, Class.Mage, 44, 13018, false, Config.EnableTalentRanks }, -- Blast Wave (Rank 3)
            { 13031, Team.Universal, Race.Universal, Class.Mage, 46, 11426, false, Config.EnableTalentRanks }, -- Ice Barrier (Rank 2)
            { 12525, Team.Universal, Race.Universal, Class.Mage, 48, 12524, false, Config.EnableTalentRanks }, -- Pyroblast (Rank 6)
            { 13020, Team.Universal, Race.Universal, Class.Mage, 52, 13019, false, Config.EnableTalentRanks }, -- Blast Wave (Rank 4)
            { 13032, Team.Universal, Race.Universal, Class.Mage, 52, 13031, false, Config.EnableTalentRanks }, -- Ice Barrier (Rank 3)
            { 12526, Team.Universal, Race.Universal, Class.Mage, 54, 12525, false, Config.EnableTalentRanks }, -- Pyroblast (Rank 7)
            { 33041, Team.Universal, Race.Universal, Class.Mage, 56, 31661, false, Config.EnableTalentRanks }, -- Dragon's Breath (Rank 2)
            { 13033, Team.Universal, Race.Universal, Class.Mage, 58, 13032, false, Config.EnableTalentRanks }, -- Ice Barrier (Rank 4)
            { 13021, Team.Universal, Race.Universal, Class.Mage, 60, 13020, false, Config.EnableTalentRanks }, -- Blast Wave (Rank 5)
            { 18809, Team.Universal, Race.Universal, Class.Mage, 60, 12526, false, Config.EnableTalentRanks }, -- Pyroblast (Rank 8)
            { 27134, Team.Universal, Race.Universal, Class.Mage, 64, 13033, false, Config.EnableTalentRanks }, -- Ice Barrier (Rank 5)
            { 33042, Team.Universal, Race.Universal, Class.Mage, 64, 33041, false, Config.EnableTalentRanks }, -- Dragon's Breath (Rank 3)
            { 27133, Team.Universal, Race.Universal, Class.Mage, 65, 13021, false, Config.EnableTalentRanks }, -- Blast Wave (Rank 6)
            { 27132, Team.Universal, Race.Universal, Class.Mage, 66, 18809, false, Config.EnableTalentRanks }, -- Pyroblast (Rank 9)
            { 33043, Team.Universal, Race.Universal, Class.Mage, 70, 33042, false, Config.EnableTalentRanks }, -- Dragon's Breath (Rank 4)
            { 33405, Team.Universal, Race.Universal, Class.Mage, 70, 27134, false, Config.EnableTalentRanks }, -- Ice Barrier (Rank 6)
            { 33933, Team.Universal, Race.Universal, Class.Mage, 70, 27133, false, Config.EnableTalentRanks }, -- Blast Wave (Rank 7)
            { 33938, Team.Universal, Race.Universal, Class.Mage, 70, 27132, false, Config.EnableTalentRanks }, -- Pyroblast (Rank 10)
            { 44780, Team.Universal, Race.Universal, Class.Mage, 70, 44425, false, Config.EnableTalentRanks }, -- Arcane Barrage (Rank 2)
            { 55359, Team.Universal, Race.Universal, Class.Mage, 70, 44457, false, Config.EnableTalentRanks }, -- Living Bomb (Rank 2)
            { 42890, Team.Universal, Race.Universal, Class.Mage, 73, 33938, false, Config.EnableTalentRanks }, -- Pyroblast (Rank 11)
            { 42944, Team.Universal, Race.Universal, Class.Mage, 75, 33933, false, Config.EnableTalentRanks }, -- Blast Wave (Rank 8)
            { 42949, Team.Universal, Race.Universal, Class.Mage, 75, 33043, false, Config.EnableTalentRanks }, -- Dragon's Breath (Rank 5)
            { 43038, Team.Universal, Race.Universal, Class.Mage, 75, 33405, false, Config.EnableTalentRanks }, -- Ice Barrier (Rank 7)
            { 42891, Team.Universal, Race.Universal, Class.Mage, 77, 42890, false, Config.EnableTalentRanks }, -- Pyroblast (Rank 12)
            { 42945, Team.Universal, Race.Universal, Class.Mage, 80, 42944, false, Config.EnableTalentRanks }, -- Blast Wave (Rank 9)
            { 42950, Team.Universal, Race.Universal, Class.Mage, 80, 42949, false, Config.EnableTalentRanks }, -- Dragon's Breath (Rank 6)
            { 43039, Team.Universal, Race.Universal, Class.Mage, 80, 43038, false, Config.EnableTalentRanks }, -- Ice Barrier (Rank 8)
            { 44781, Team.Universal, Race.Universal, Class.Mage, 80, 44780, false, Config.EnableTalentRanks }, -- Arcane Barrage (Rank 3)
            { 55360, Team.Universal, Race.Universal, Class.Mage, 80, 55359, false, Config.EnableTalentRanks }, -- Living Bomb (Rank 3)
            -- Warlock
            { 18867, Team.Universal, Race.Universal, Class.Warlock, 24, 17877, false, Config.EnableTalentRanks }, -- Shadowburn (Rank 2)
            { 18868, Team.Universal, Race.Universal, Class.Warlock, 32, 18867, false, Config.EnableTalentRanks }, -- Shadowburn (Rank 3)
            { 18869, Team.Universal, Race.Universal, Class.Warlock, 40, 18868, false, Config.EnableTalentRanks }, -- Shadowburn (Rank 4)
            { 18870, Team.Universal, Race.Universal, Class.Warlock, 48, 18869, false, Config.EnableTalentRanks }, -- Shadowburn (Rank 5)
            { 18937, Team.Universal, Race.Universal, Class.Warlock, 50, 18220, false, Config.EnableTalentRanks }, -- Dark Pact (Rank 2)
            { 18871, Team.Universal, Race.Universal, Class.Warlock, 56, 18870, false, Config.EnableTalentRanks }, -- Shadowburn (Rank 6)
            { 18938, Team.Universal, Race.Universal, Class.Warlock, 60, 18937, false, Config.EnableTalentRanks }, -- Dark Pact (Rank 3)
            { 30404, Team.Universal, Race.Universal, Class.Warlock, 60, 30108, false, Config.EnableTalentRanks }, -- Unstable Affliction (Rank 2)
            { 30413, Team.Universal, Race.Universal, Class.Warlock, 60, 30283, false, Config.EnableTalentRanks }, -- Shadowfury (Rank 2)
            { 27263, Team.Universal, Race.Universal, Class.Warlock, 63, 18871, false, Config.EnableTalentRanks }, -- Shadowburn (Rank 7)
            { 27265, Team.Universal, Race.Universal, Class.Warlock, 70, 18938, false, Config.EnableTalentRanks }, -- Dark Pact (Rank 4)
            { 30405, Team.Universal, Race.Universal, Class.Warlock, 70, 30404, false, Config.EnableTalentRanks }, -- Unstable Affliction (Rank 3)
            { 30414, Team.Universal, Race.Universal, Class.Warlock, 70, 30413, false, Config.EnableTalentRanks }, -- Shadowfury (Rank 3)
            { 30546, Team.Universal, Race.Universal, Class.Warlock, 70, 27263, false, Config.EnableTalentRanks }, -- Shadowburn (Rank 8)
            { 59161, Team.Universal, Race.Universal, Class.Warlock, 70, 48181, false, Config.EnableTalentRanks }, -- Haunt (Rank 2)
            { 59170, Team.Universal, Race.Universal, Class.Warlock, 70, 50796, false, Config.EnableTalentRanks }, -- Chaos Bolt (Rank 2)
            { 47826, Team.Universal, Race.Universal, Class.Warlock, 75, 30546, false, Config.EnableTalentRanks }, -- Shadowburn (Rank 9)
            { 47841, Team.Universal, Race.Universal, Class.Warlock, 75, 30405, false, Config.EnableTalentRanks }, -- Unstable Affliction (Rank 4)
            { 47846, Team.Universal, Race.Universal, Class.Warlock, 75, 30414, false, Config.EnableTalentRanks }, -- Shadowfury (Rank 4)
            { 59163, Team.Universal, Race.Universal, Class.Warlock, 75, 59161, false, Config.EnableTalentRanks }, -- Haunt (Rank 3)
            { 59171, Team.Universal, Race.Universal, Class.Warlock, 75, 59170, false, Config.EnableTalentRanks }, -- Chaos Bolt (Rank 3)
            { 47827, Team.Universal, Race.Universal, Class.Warlock, 80, 47826, false, Config.EnableTalentRanks }, -- Shadowburn (Rank 10)
            { 47843, Team.Universal, Race.Universal, Class.Warlock, 80, 47841, false, Config.EnableTalentRanks }, -- Unstable Affliction (Rank 5)
            { 47847, Team.Universal, Race.Universal, Class.Warlock, 80, 47846, false, Config.EnableTalentRanks }, -- Shadowfury (Rank 5)
            { 59092, Team.Universal, Race.Universal, Class.Warlock, 80, 27265, false, Config.EnableTalentRanks }, -- Dark Pact (Rank 5)
            { 59164, Team.Universal, Race.Universal, Class.Warlock, 80, 59163, false, Config.EnableTalentRanks }, -- Haunt (Rank 4)
            { 59172, Team.Universal, Race.Universal, Class.Warlock, 80, 59171, false, Config.EnableTalentRanks }, -- Chaos Bolt (Rank 4)
            -- Druid
            { 24974, Team.Universal, Race.Universal, Class.Druid, 30, 5570, false, Config.EnableTalentRanks }, -- Insect Swarm (Rank 2)
            { 24975, Team.Universal, Race.Universal, Class.Druid, 40, 24974, false, Config.EnableTalentRanks }, -- Insect Swarm (Rank 3)
            { 24976, Team.Universal, Race.Universal, Class.Druid, 50, 24975, false, Config.EnableTalentRanks }, -- Insect Swarm (Rank 4)
            { 33982, Team.Universal, Race.Universal, Class.Druid, 58, 33876, false, Config.EnableTalentRanks }, -- Mangle (Cat) (Rank 2)
            { 33986, Team.Universal, Race.Universal, Class.Druid, 58, 33878, false, Config.EnableTalentRanks }, -- Mangle (Bear) (Rank 2)
            { 24977, Team.Universal, Race.Universal, Class.Druid, 60, 24976, false, Config.EnableTalentRanks }, -- Insect Swarm (Rank 5)
            { 53223, Team.Universal, Race.Universal, Class.Druid, 60, 50516, false, Config.EnableTalentRanks }, -- Typhoon (Rank 2)
            { 33983, Team.Universal, Race.Universal, Class.Druid, 68, 33982, false, Config.EnableTalentRanks }, -- Mangle (Cat) (Rank 3)
            { 33987, Team.Universal, Race.Universal, Class.Druid, 68, 33986, false, Config.EnableTalentRanks }, -- Mangle (Bear) (Rank 3)
            { 27013, Team.Universal, Race.Universal, Class.Druid, 70, 24977, false, Config.EnableTalentRanks }, -- Insect Swarm (Rank 6)
            { 53199, Team.Universal, Race.Universal, Class.Druid, 70, 48505, false, Config.EnableTalentRanks }, -- Starfall (Rank 2)
            { 53225, Team.Universal, Race.Universal, Class.Druid, 70, 53223, false, Config.EnableTalentRanks }, -- Typhoon (Rank 3)
            { 53248, Team.Universal, Race.Universal, Class.Druid, 70, 48438, false, Config.EnableTalentRanks }, -- Wild Growth (Rank 2)
            { 48563, Team.Universal, Race.Universal, Class.Druid, 75, 33987, false, Config.EnableTalentRanks }, -- Mangle (Bear) (Rank 4)
            { 48565, Team.Universal, Race.Universal, Class.Druid, 75, 33983, false, Config.EnableTalentRanks }, -- Mangle (Cat) (Rank 4)
            { 53200, Team.Universal, Race.Universal, Class.Druid, 75, 53199, false, Config.EnableTalentRanks }, -- Starfall (Rank 3)
            { 53226, Team.Universal, Race.Universal, Class.Druid, 75, 53225, false, Config.EnableTalentRanks }, -- Typhoon (Rank 4)
            { 53249, Team.Universal, Race.Universal, Class.Druid, 75, 53248, false, Config.EnableTalentRanks }, -- Wild Growth (Rank 3)
            { 48468, Team.Universal, Race.Universal, Class.Druid, 80, 27013, false, Config.EnableTalentRanks }, -- Insect Swarm (Rank 7)
            { 48564, Team.Universal, Race.Universal, Class.Druid, 80, 48563, false, Config.EnableTalentRanks }, -- Mangle (Bear) (Rank 5)
            { 48566, Team.Universal, Race.Universal, Class.Druid, 80, 48565, false, Config.EnableTalentRanks }, -- Mangle (Cat) (Rank 5)
            { 53201, Team.Universal, Race.Universal, Class.Druid, 80, 53200, false, Config.EnableTalentRanks }, -- Starfall (Rank 4)
            { 53251, Team.Universal, Race.Universal, Class.Druid, 80, 53249, false, Config.EnableTalentRanks }, -- Wild Growth (Rank 4)
            { 61384, Team.Universal, Race.Universal, Class.Druid, 80, 53226, false, Config.EnableTalentRanks } -- Typhoon (Rank 5)
        }
    elseif (type == Type.Proficiencies) then
        SpellList = {
            -- Warrior
            { 196, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Axes
            { 197, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Axes
            { 198, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Maces
            { 199, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Maces
            { 200, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- Polearms
            { 201, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Swords
            { 202, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Swords
            { 227, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- Staves
            { 264, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- Bows
            { 266, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- Guns
            { 1180, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- Daggers
            { 5011, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- Crossbows
            { 15590, Team.Universal, Race.Universal, Class.Warrior, 0, -1, false, Config.EnableProficiencies }, -- Fist Weapons
            { 3127, Team.Universal, Race.Universal, Class.Warrior, 6, -1, false, Config.EnableProficiencies }, -- Parry (Passive)
            { 674, Team.Universal, Race.Universal, Class.Warrior, 20, -1, false, Config.EnableProficiencies }, -- Dual Wield (Passive)
            { 750, Team.Universal, Race.Universal, Class.Warrior, 40, -1, false, Config.EnableProficiencies }, -- Plate Mail
            -- Paladin
            { 196, Team.Universal, Race.Universal, Class.Paladin, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Axes
            { 197, Team.Universal, Race.Universal, Class.Paladin, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Axes
            { 198, Team.Universal, Race.Universal, Class.Paladin, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Maces
            { 199, Team.Universal, Race.Universal, Class.Paladin, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Maces
            { 200, Team.Universal, Race.Universal, Class.Paladin, 0, -1, false, Config.EnableProficiencies }, -- Polearms
            { 201, Team.Universal, Race.Universal, Class.Paladin, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Swords
            { 202, Team.Universal, Race.Universal, Class.Paladin, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Swords
            { 3127, Team.Universal, Race.Universal, Class.Paladin, 8, -1, false, Config.EnableProficiencies }, -- Parry (Passive)
            { 750, Team.Universal, Race.Universal, Class.Paladin, 40, -1, false, Config.EnableProficiencies }, -- Plate Mail
            -- Hunter
            { 196, Team.Universal, Race.Universal, Class.Hunter, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Axes
            { 197, Team.Universal, Race.Universal, Class.Hunter, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Axes
            { 200, Team.Universal, Race.Universal, Class.Hunter, 0, -1, false, Config.EnableProficiencies }, -- Polearms
            { 201, Team.Universal, Race.Universal, Class.Hunter, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Swords
            { 202, Team.Universal, Race.Universal, Class.Hunter, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Swords
            { 227, Team.Universal, Race.Universal, Class.Hunter, 0, -1, false, Config.EnableProficiencies }, -- Staves
            { 264, Team.Universal, Race.Universal, Class.Hunter, 0, -1, false, Config.EnableProficiencies }, -- Bows
            { 266, Team.Universal, Race.Universal, Class.Hunter, 0, -1, false, Config.EnableProficiencies }, -- Guns
            { 1180, Team.Universal, Race.Universal, Class.Hunter, 0, -1, false, Config.EnableProficiencies }, -- Daggers
            { 5011, Team.Universal, Race.Universal, Class.Hunter, 0, -1, false, Config.EnableProficiencies }, -- Crossbows
            { 15590, Team.Universal, Race.Universal, Class.Hunter, 0, -1, false, Config.EnableProficiencies }, -- Fist Weapons
            { 3127, Team.Universal, Race.Universal, Class.Hunter, 8, -1, false, Config.EnableProficiencies }, -- Parry (Passive)
            { 674, Team.Universal, Race.Universal, Class.Hunter, 20, -1, false, Config.EnableProficiencies }, -- Dual Wield (Passive)
            { 8737, Team.Universal, Race.Universal, Class.Hunter, 40, -1, false, Config.EnableProficiencies }, -- Mail
            -- Rogue
            { 196, Team.Universal, Race.Universal, Class.Rogue, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Axes
            { 198, Team.Universal, Race.Universal, Class.Rogue, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Maces
            { 201, Team.Universal, Race.Universal, Class.Rogue, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Swords
            { 264, Team.Universal, Race.Universal, Class.Rogue, 0, -1, false, Config.EnableProficiencies }, -- Bows
            { 266, Team.Universal, Race.Universal, Class.Rogue, 0, -1, false, Config.EnableProficiencies }, -- Guns
            { 1180, Team.Universal, Race.Universal, Class.Rogue, 0, -1, false, Config.EnableProficiencies }, -- Daggers
            { 5011, Team.Universal, Race.Universal, Class.Rogue, 0, -1, false, Config.EnableProficiencies }, -- Crossbows
            { 15590, Team.Universal, Race.Universal, Class.Rogue, 0, -1, false, Config.EnableProficiencies }, -- Fist Weapons
            { 674, Team.Universal, Race.Universal, Class.Rogue, 10, -1, false, Config.EnableProficiencies }, -- Dual Wield (Passive)
            { 3127, Team.Universal, Race.Universal, Class.Rogue, 12, -1, false, Config.EnableProficiencies }, -- Parry (Passive)
            -- Priest
            { 198, Team.Universal, Race.Universal, Class.Priest, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Maces
            { 227, Team.Universal, Race.Universal, Class.Priest, 0, -1, false, Config.EnableProficiencies }, -- Staves
            { 1180, Team.Universal, Race.Universal, Class.Priest, 0, -1, false, Config.EnableProficiencies }, -- Daggers
            { 5009, Team.Universal, Race.Universal, Class.Priest, 0, -1, false, Config.EnableProficiencies }, -- Wands
            -- Death Knight
            { 196, Team.Universal, Race.Universal, Class.DeathKnight, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Axes
            { 197, Team.Universal, Race.Universal, Class.DeathKnight, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Axes
            { 198, Team.Universal, Race.Universal, Class.DeathKnight, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Maces
            { 199, Team.Universal, Race.Universal, Class.DeathKnight, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Maces
            { 200, Team.Universal, Race.Universal, Class.DeathKnight, 0, -1, false, Config.EnableProficiencies }, -- Polearms
            { 201, Team.Universal, Race.Universal, Class.DeathKnight, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Swords
            { 202, Team.Universal, Race.Universal, Class.DeathKnight, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Swords
            { 3127, Team.Universal, Race.Universal, Class.DeathKnight, 12, -1, false, Config.EnableProficiencies }, -- Parry (Passive)
            { 674, Team.Universal, Race.Universal, Class.DeathKnight, 20, -1, false, Config.EnableProficiencies }, -- Dual Wield (Passive)
            { 750, Team.Universal, Race.Universal, Class.DeathKnight, 40, -1, false, Config.EnableProficiencies }, -- Plate Mail
            -- Shaman
            { 196, Team.Universal, Race.Universal, Class.Shaman, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Axes
            { 197, Team.Universal, Race.Universal, Class.Shaman, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Axes
            { 198, Team.Universal, Race.Universal, Class.Shaman, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Maces
            { 199, Team.Universal, Race.Universal, Class.Shaman, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Maces
            { 227, Team.Universal, Race.Universal, Class.Shaman, 0, -1, false, Config.EnableProficiencies }, -- Staves
            { 1180, Team.Universal, Race.Universal, Class.Shaman, 0, -1, false, Config.EnableProficiencies }, -- Daggers
            { 15590, Team.Universal, Race.Universal, Class.Shaman, 0, -1, false, Config.EnableProficiencies }, -- Fist Weapons
            { 8737, Team.Universal, Race.Universal, Class.Shaman, 40, -1, false, Config.EnableProficiencies }, -- Mail
            -- Mage
            { 201, Team.Universal, Race.Universal, Class.Mage, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Swords
            { 227, Team.Universal, Race.Universal, Class.Mage, 0, -1, false, Config.EnableProficiencies }, -- Staves
            { 1180, Team.Universal, Race.Universal, Class.Mage, 0, -1, false, Config.EnableProficiencies }, -- Daggers
            { 5009, Team.Universal, Race.Universal, Class.Mage, 0, -1, false, Config.EnableProficiencies }, -- Wands
            -- Warlock
            { 201, Team.Universal, Race.Universal, Class.Warlock, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Swords
            { 227, Team.Universal, Race.Universal, Class.Warlock, 0, -1, false, Config.EnableProficiencies }, -- Staves
            { 1180, Team.Universal, Race.Universal, Class.Warlock, 0, -1, false, Config.EnableProficiencies }, -- Daggers
            { 5009, Team.Universal, Race.Universal, Class.Warlock, 0, -1, false, Config.EnableProficiencies }, -- Wands
            -- Druid
            { 198, Team.Universal, Race.Universal, Class.Druid, 0, -1, false, Config.EnableProficiencies }, -- One-Handed Maces
            { 199, Team.Universal, Race.Universal, Class.Druid, 0, -1, false, Config.EnableProficiencies }, -- Two-Handed Maces
            { 200, Team.Universal, Race.Universal, Class.Druid, 0, -1, false, Config.EnableProficiencies }, -- Polearms
            { 227, Team.Universal, Race.Universal, Class.Druid, 0, -1, false, Config.EnableProficiencies }, -- Staves
            { 1180, Team.Universal, Race.Universal, Class.Druid, 0, -1, false, Config.EnableProficiencies }, -- Daggers
            { 15590, Team.Universal, Race.Universal, Class.Druid, 0, -1, false, Config.EnableProficiencies } -- Fist Weapons
        }
    elseif (type == Type.Riding) then
        SpellList = {
            -- Apprentice Riding
                { 33388, Team.Universal, Race.Universal, Class.Universal, 20, -1, false, Config.EnableApprenticeRiding }, -- Apprentice Riding
                { 458, Team.Alliance, Race.Human, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Brown Horse
                { 472, Team.Alliance, Race.Human, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Pinto
                { 580, Team.Horde, Race.Orc, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Timber Wolf
                { 5784, Team.Universal, Race.Universal, Class.Warlock, 20, 33388, false, Config.EnableApprenticeRiding }, -- Felsteed
                { 6648, Team.Alliance, Race.Human, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Chestnut Mare
                { 6653, Team.Horde, Race.Orc, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Dire Wolf
                { 6654, Team.Horde, Race.Orc, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Brown Wolf
                { 6777, Team.Alliance, Race.Dwarf, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Gray Ram
                { 6898, Team.Alliance, Race.Dwarf, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- White Ram
                { 6899, Team.Alliance, Race.Dwarf, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Brown Ram
                { 8394, Team.Alliance, Race.NightElf, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Striped Frostsaber
                { 8395, Team.Horde, Race.Troll, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Emerald Raptor
                { 10789, Team.Alliance, Race.NightElf, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Spotted Frostsaber
                { 10793, Team.Alliance, Race.NightElf, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Striped Nightsaber
                { 10796, Team.Horde, Race.Troll, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Turquoise Raptor
                { 10799, Team.Horde, Race.Troll, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Violet Raptor
                { 10873, Team.Alliance, Race.Gnome, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Red Mechanostrider
                { 10969, Team.Alliance, Race.Gnome, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Blue Mechanostrider
                { 13819, Team.Alliance, Race.Dwarf, Class.Paladin, 20, 33388, false, Config.EnableApprenticeRiding }, -- Summon Warhorse
                { 13819, Team.Alliance, Race.Human, Class.Paladin, 20, 33388, false, Config.EnableApprenticeRiding }, -- Summon Warhorse
                { 13819, Team.Alliance, Race.Draenei, Class.Paladin, 20, 33388, false, Config.EnableApprenticeRiding }, -- Summon Warhorse
                { 17453, Team.Alliance, Race.Gnome, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Green Mechanostrider
                { 17454, Team.Alliance, Race.Gnome, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Unpainted Mechanostrider
                { 17462, Team.Horde, Race.Undead, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Red Skeletal Horse
                { 17463, Team.Horde, Race.Undead, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Blue Skeletal Horse
                { 17464, Team.Horde, Race.Undead, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Brown Skeletal Horse
                { 18989, Team.Horde, Race.Tauren, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Gray Kodo
                { 18990, Team.Horde, Race.Tauren, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Brown Kodo
                { 34406, Team.Alliance, Race.Draenei, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Brown Elekk
                { 34769, Team.Horde, Race.BloodElf, Class.Paladin, 20, 33388, false, Config.EnableApprenticeRiding }, -- Warhorse
                { 34795, Team.Horde, Race.BloodElf, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Red Hawkstrider
                { 35018, Team.Horde, Race.BloodElf, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Purple Hawkstrider
                { 35020, Team.Horde, Race.BloodElf, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Blue Hawkstrider
                { 35022, Team.Horde, Race.BloodElf, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Black Hawkstrider
                { 35710, Team.Alliance, Race.Draenei, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Gray Elekk
                { 35711, Team.Alliance, Race.Draenei, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Purple Elekk
                { 64657, Team.Horde, Race.Tauren, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- White Kodo
                { 64658, Team.Horde, Race.Orc, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Black Wolf
                { 64977, Team.Horde, Race.Undead, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Black Skeletal Horse
                { 66847, Team.Alliance, Race.NightElf, Class.Universal, 20, 33388, false, Config.EnableApprenticeRiding }, -- Striped Dawnsaber
                -- Journeyman Riding
                { 33391, Team.Universal, Race.Universal, Class.Universal, 40, 33388, false, Config.EnableJourneymanRiding }, -- Journeyman Riding
                { 17465, Team.Horde, Race.Undead, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Green Skeletal Warhorse
                { 23161, Team.Universal, Race.Universal, Class.Warlock, 40, 33391, true, Config.EnableJourneymanRiding }, -- Dreadsteed
                { 23214, Team.Alliance, Race.Draenei, Class.Paladin, 40, 33391, true, Config.EnableJourneymanRiding }, -- Summon Charger
                { 23214, Team.Alliance, Race.Dwarf, Class.Paladin, 40, 33391, true, Config.EnableJourneymanRiding }, -- Summon Charger
                { 23214, Team.Alliance, Race.Human, Class.Paladin, 40, 33391, true, Config.EnableJourneymanRiding }, -- Summon Charger
                { 23219, Team.Alliance, Race.NightElf, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Mistsaber
                { 23221, Team.Alliance, Race.NightElf, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Frostsaber
                { 23222, Team.Alliance, Race.Gnome, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Yellow Mechanostrider
                { 23223, Team.Alliance, Race.Gnome, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift White Mechanostrider
                { 23225, Team.Alliance, Race.Gnome, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Green Mechanostrider
                { 23227, Team.Alliance, Race.Human, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Palomino
                { 23228, Team.Alliance, Race.Human, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift White Steed
                { 23229, Team.Alliance, Race.Human, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Brown Steed
                { 23238, Team.Alliance, Race.Dwarf, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Brown Ram
                { 23239, Team.Alliance, Race.Dwarf, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Gray Ram
                { 23240, Team.Alliance, Race.Dwarf, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift White Ram
                { 23241, Team.Horde, Race.Troll, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Blue Raptor
                { 23242, Team.Horde, Race.Troll, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Olive Raptor
                { 23243, Team.Horde, Race.Troll, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Orange Raptor
                { 23246, Team.Horde, Race.Undead, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Purple Skeletal Warhorse
                { 23247, Team.Horde, Race.Tauren, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Great White Kodo
                { 23248, Team.Horde, Race.Tauren, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Great Gray Kodo
                { 23249, Team.Horde, Race.Tauren, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Great Brown Kodo
                { 23250, Team.Horde, Race.Orc, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Brown Wolf
                { 23251, Team.Horde, Race.Orc, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Timber Wolf
                { 23252, Team.Horde, Race.Orc, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Gray Wolf
                { 23338, Team.Alliance, Race.NightElf, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Stormsaber
                { 33660, Team.Horde, Race.BloodElf, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Pink Hawkstrider
                { 34767, Team.Horde, Race.BloodElf, Class.Paladin, 40, 33391, true, Config.EnableJourneymanRiding }, -- Charger
                { 35025, Team.Horde, Race.BloodElf, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Green Hawkstrider
                { 35027, Team.Horde, Race.BloodElf, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Swift Purple Hawkstrider
                { 35712, Team.Alliance, Race.Draenei, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Great Green Elekk
                { 35713, Team.Alliance, Race.Draenei, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Great Blue Elekk
                { 35714, Team.Alliance, Race.Draenei, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Great Purple Elekk
                { 66846, Team.Horde, Race.Undead, Class.Universal, 40, 33391, false, Config.EnableJourneymanRiding }, -- Ochre Skeletal Warhorse
                { 48778, Team.Universal, Race.Universal, Class.DeathKnight, 60, 33391, false, Config.EnableJourneymanRiding }, -- Acherus Deathcharger
                -- Expert Riding
                { 34090, Team.Universal, Race.Universal, Class.Universal, 60, 33391, false, Config.EnableExpertRiding }, -- Expert Riding
                { 32235, Team.Alliance, Race.Universal, Class.Universal, 60, 34090, false, Config.EnableExpertRiding }, -- Golden Gryphon
                { 32239, Team.Alliance, Race.Universal, Class.Universal, 60, 34090, false, Config.EnableExpertRiding }, -- Ebon Gryphon
                { 32240, Team.Alliance, Race.Universal, Class.Universal, 60, 34090, false, Config.EnableExpertRiding }, -- Snowy Gryphon
                { 32243, Team.Horde, Race.Universal, Class.Universal, 60, 34090, false, Config.EnableExpertRiding }, -- Tawny Wind Rider
                { 32244, Team.Horde, Race.Universal, Class.Universal, 60, 34090, false, Config.EnableExpertRiding }, -- Blue Wind Rider
                { 32245, Team.Horde, Race.Universal, Class.Universal, 60, 34090, false, Config.EnableExpertRiding }, -- Green Wind Rider
                -- Artisan Riding
                { 34091, Team.Universal, Race.Universal, Class.Universal, 70, 34090, false, Config.EnableArtisanRiding }, -- Artisan Riding
                { 32242, Team.Alliance, Race.Universal, Class.Universal, 70, 34091, false, Config.EnableArtisanRiding }, -- Swift Blue Gryphon
                { 32246, Team.Horde, Race.Universal, Class.Universal, 70, 34091, false, Config.EnableArtisanRiding }, -- Swift Red Wind Rider
                { 32289, Team.Alliance, Race.Universal, Class.Universal, 70, 34091, false, Config.EnableArtisanRiding }, -- Swift Red Gryphon
                { 32290, Team.Alliance, Race.Universal, Class.Universal, 70, 34091, false, Config.EnableArtisanRiding }, -- Swift Green Gryphon
                { 32292, Team.Alliance, Race.Universal, Class.Universal, 70, 34091, false, Config.EnableArtisanRiding }, -- Swift Purple Gryphon
                { 32295, Team.Horde, Race.Universal, Class.Universal, 70, 34091, false, Config.EnableArtisanRiding }, -- Swift Green Wind Rider
                { 32296, Team.Horde, Race.Universal, Class.Universal, 70, 34091, false, Config.EnableArtisanRiding }, -- Swift Yellow Wind Rider
                { 32297, Team.Horde, Race.Universal, Class.Universal, 70, 34091, false, Config.EnableArtisanRiding }, -- Swift Purple Wind Rider
                --
                { 54197, Team.Universal, Race.Universal, Class.Universal, 77, 34090, Config.EnableColdWeatherFlying } -- Cold Weather Flying (Passive)
        }
    end

    return SpellList
end

function Player:LearnSpells(type)
    local SpellList = GetSpellList(type)
    for _, Spell in ipairs(SpellList) do
        if (((Spell[SpellColumn.Team] == Team.Universal or Spell[SpellColumn.Team] == self:GetTeam()) and (Spell[SpellColumn.Race] == Race.Universal or Spell[SpellColumn.Race] == self:GetRace()) and (Spell[SpellColumn.Class] == Class.Universal or Spell[SpellColumn.Class] == self:GetClass()) and (Spell[SpellColumn.RequiredLevel] <= self:GetLevel()) and (Spell[SpellColumn.RequiredSpell] == -1 or self:HasSpell(Spell[SpellColumn.RequiredSpell])) and (not Spell[SpellColumn.QuestRequired] or Config.EnableSpellsFromQuests)) and Spell[SpellColumn.Enabled]) then
            self:LearnSpell(Spell[SpellColumn.Id])
        end
    end
end

function Player:AddTotems()
    if (self:GetClass() == Class.Shaman) then
        for _, Totem in ipairs(Totems) do
            if (Totem[2] <= self:GetLevel() and not self:HasItem(Totem[1], 1, true) and Totem[3]) then
                self:AddItem(Totem[1], 1)
            end
        end
    end
end

function Player:LearnAllSpells()
    if (self:GetGMRank() == 0 or Config.EnableForGamemaster) then
        self:LearnSpells(Type.Class)
        self:LearnSpells(Type.Talents)
        self:LearnSpells(Type.Proficiencies)
        self:LearnSpells(Type.Riding)
        self:AddTotems()
    end
end

local function OnLogin(event, player)
    player:LearnAllSpells()
end
RegisterPlayerEvent(Event.OnLogin, OnLogin)

local function OnLevelChanged(event, player, oldLevel)
    player:LearnAllSpells()
end
RegisterPlayerEvent(Event.OnLevelChanged, OnLevelChanged)

local function OnTalentsChanged(event, player, points)
    player:LearnAllSpells()
end
RegisterPlayerEvent(Event.OnTalentsChanged, OnTalentsChanged)
