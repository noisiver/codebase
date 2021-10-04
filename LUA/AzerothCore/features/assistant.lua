-- Requires
require("config")
require("ids")
require("events")
require("equipment")
require("flags")
require("gossip")
require("proficiencies")

-- Ids for gossip selects
local INT_EQUIPMENT                  = 100
local INT_HEIRLOOMS                  = 200
local INT_GLYPHS                     = 300
local INT_GEMS                       = 600
local INT_CONTAINERS                 = 800
local INT_UTILITIES                  = 900
local INT_MISCELLANEOUS              = 1000
local INT_RETURN                     = 2000

-- Character enters the world
function assistantOnLogin(event, player)
    if (ENABLE_ASSISTANT and ((ENABLE_ASSISTANT_EQUIPMENT or ENABLE_ASSISTANT_EQUIPMENT_LEVEL_UP) or ENABLE_ASSISTANT_EQUIPMENT_MAX_SKILL or ENABLE_ASSISTANT_HEIRLOOMS or ENABLE_ASSISTANT_GLYPHS or ENABLE_ASSISTANT_GEMS or ENABLE_ASSISTANT_CONTAINERS or ENABLE_ASSISTANT_UTILITIES or ENABLE_ASSISTANT_MISCELLANEOUS)) then
        player:SendBroadcastMessage("This server uses an assistant to aid players. Type .assistant to access this feature.")
    end
end

RegisterPlayerEvent(EVENT_ON_LOGIN, assistantOnLogin)

-- Character performs a command
function assistantOnCommand(event, player, command)
    if (ENABLE_ASSISTANT and ((ENABLE_ASSISTANT_EQUIPMENT or ENABLE_ASSISTANT_EQUIPMENT_LEVEL_UP) or ENABLE_ASSISTANT_EQUIPMENT_MAX_SKILL or ENABLE_ASSISTANT_HEIRLOOMS or ENABLE_ASSISTANT_GLYPHS or ENABLE_ASSISTANT_GEMS or ENABLE_ASSISTANT_CONTAINERS or ENABLE_ASSISTANT_UTILITIES or ENABLE_ASSISTANT_MISCELLANEOUS)) then
        if command == 'assistant' then
            assistantOnGossipHello(event, player, player)
            return false
        end
    end
end

RegisterPlayerEvent(EVENT_ON_COMMAND, assistantOnCommand)

-- Gossip: Hello
function assistantOnGossipHello(event, player, object)
    player:GossipClearMenu()
    if (ENABLE_ASSISTANT_EQUIPMENT and (player:GetLevel() == 80 or ENABLE_ASSISTANT_EQUIPMENT_LEVEL_UP)) then
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want equipment", 1, INT_EQUIPMENT)
    end
    if (ENABLE_ASSISTANT_HEIRLOOMS) then
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want heirlooms", 1, INT_HEIRLOOMS)
    end
    if (ENABLE_ASSISTANT_GLYPHS) then
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want glyphs", 1, INT_GLYPHS)
    end
    if (ENABLE_ASSISTANT_GEMS) then
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want gems", 1, INT_GEMS)
    end
    if (ENABLE_ASSISTANT_CONTAINERS) then
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want containers", 1, INT_CONTAINERS)
    end
    if (ENABLE_ASSISTANT_UTILITIES) then
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want utilities", 1, INT_UTILITIES)
    end
    if (ENABLE_ASSISTANT_MISCELLANEOUS) then
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "What else can I get?", 1, INT_MISCELLANEOUS)
    end

    player:GossipSendMenu(0x7FFFFFFF, object, 1)
end

RegisterPlayerGossipEvent(1, 1, assistantOnGossipHello)

-- Gossip: Select
function assistantOnGossipSelect(event, player, object, sender, intid, code)
    if (intid == INT_RETURN) then
        assistantOnGossipHello(event, player, player)
    elseif (intid == INT_EQUIPMENT) then
        player:GossipClearMenu()

        if (player:GetLevel() == 80) then
            if (player:GetClass() == CLASS_WARRIOR) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_warrior_offensivestance:25:25:-19|tI want to use Arms", 1, INT_EQUIPMENT+2)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_racial_avatar:25:25:-19|tI want to use Fury", 1, INT_EQUIPMENT+3)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_warrior_defensivestance:25:25:-19|tI want to use Protection", 1, INT_EQUIPMENT+4)
            elseif (player:GetClass() == CLASS_PALADIN) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_paladin_beaconoflight:25:25:-19|tI want to use Holy", 1, INT_EQUIPMENT+5)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_paladin_hammeroftherighteous:25:25:-19|tI want to use Protection", 1, INT_EQUIPMENT+6)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_paladin_divinestorm:25:25:-19|tI want to use Retribution", 1, INT_EQUIPMENT+7)
            elseif (player:GetClass() == CLASS_HUNTER) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_hunter_beastmastery:25:25:-19|tI want to use Beast Mastery", 1, INT_EQUIPMENT+8)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_hunter_chimerashot2:25:25:-19|tI want to use Marksmanship", 1, INT_EQUIPMENT+9)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_hunter_explosiveshot:25:25:-19|tI want to use Survival", 1, INT_EQUIPMENT+10)
            elseif (player:GetClass() == CLASS_ROGUE) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_rogue_hungerforblood:25:25:-19|tI want to use Assassination", 1, INT_EQUIPMENT+11)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_rogue_murderspree:25:25:-19|tI want to use Combat", 1, INT_EQUIPMENT+12)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_rogue_shadowdance:25:25:-19|tI want to use Subtlety", 1, INT_EQUIPMENT+13)
            elseif (player:GetClass() == CLASS_PRIEST) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\spell_holy_penance:25:25:-19|tI want to use Discipline", 1, INT_EQUIPMENT+14)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\spell_holy_guardianspirit:25:25:-19|tI want to use Holy", 1, INT_EQUIPMENT+15)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\spell_shadow_dispersion:25:25:-19|tI want to use Shadow", 1, INT_EQUIPMENT+16)
            elseif (player:GetClass() == CLASS_DEATH_KNIGHT) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\spell_deathknight_bloodpresence:25:25:-19|tI want to use Blood", 1, INT_EQUIPMENT+17)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\spell_deathknight_frostpresence:25:25:-19|tI want to use Frost", 1, INT_EQUIPMENT+18)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\spell_deathknight_unholypresence:25:25:-19|tI want to use Unholy", 1, INT_EQUIPMENT+19)
            elseif (player:GetClass() == CLASS_SHAMAN) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\spell_shaman_thunderstorm:25:25:-19|tI want to use Elemental", 1, INT_EQUIPMENT+20)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\spell_shaman_feralspirit:25:25:-19|tI want to use Enhancement", 1, INT_EQUIPMENT+21)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\spell_nature_riptide:25:25:-19|tI want to use Restoration", 1, INT_EQUIPMENT+22)
            elseif (player:GetClass() == CLASS_MAGE) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_mage_arcanebarrage:25:25:-19|tI want to use Arcane", 1, INT_EQUIPMENT+23)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_mage_livingbomb:25:25:-19|tI want to use Fire", 1, INT_EQUIPMENT+24)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_mage_deepfreeze:25:25:-19|tI want to use Frost", 1, INT_EQUIPMENT+25)
            elseif (player:GetClass() == CLASS_WARLOCK) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_warlock_haunt:25:25:-19|tI want to use Affliction", 1, INT_EQUIPMENT+26)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\spell_shadow_demonform:25:25:-19|tI want to use Demonology", 1, INT_EQUIPMENT+27)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_warlock_chaosbolt:25:25:-19|tI want to use Destruction", 1, INT_EQUIPMENT+28)
            elseif (player:GetClass() == CLASS_DRUID) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_druid_starfall:25:25:-19|tI want to use Balance", 1, INT_EQUIPMENT+29)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_druid_berserk:25:25:-19|tI want to use Feral Combat", 1, INT_EQUIPMENT+30)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\ability_druid_flourish:25:25:-19|tI want to use Restoration", 1, INT_EQUIPMENT+31)
            end
        else
            player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want help to reach level 80", 1, INT_EQUIPMENT+1)
        end

        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_RETURN)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_EQUIPMENT+1) then
        player:GossipClearMenu()
        player:SetLevel(80)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+2) then -- Warrior: Arms
        player:GossipClearMenu()
        addEquipment(player, CLASS_WARRIOR, 1)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+3) then -- Warrior: Fury
        player:GossipClearMenu()
        addEquipment(player, CLASS_WARRIOR, 2)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+4) then -- Warrior: Protection
        player:GossipClearMenu()
        addEquipment(player, CLASS_WARRIOR, 3)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+5) then -- Paladin: Holy
        player:GossipClearMenu()
        addEquipment(player, CLASS_PALADIN, 1)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+6) then -- Paladin: Protection
        player:GossipClearMenu()
        addEquipment(player, CLASS_PALADIN, 2)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+7) then -- Paladin: Retribution
        player:GossipClearMenu()
        addEquipment(player, CLASS_PALADIN, 3)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+8) then -- Hunter: Beast Mastery
        player:GossipClearMenu()
        addEquipment(player, CLASS_HUNTER, 1)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+9) then -- Hunter: Marksmanship
        player:GossipClearMenu()
        addEquipment(player, CLASS_HUNTER, 2)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+10) then -- Hunter: Survival
        player:GossipClearMenu()
        addEquipment(player, CLASS_HUNTER, 3)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+11) then -- Rogue: Assassination
        player:GossipClearMenu()
        addEquipment(player, CLASS_ROGUE, 1)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+12) then -- Rogue: Combat
        player:GossipClearMenu()
        addEquipment(player, CLASS_ROGUE, 2)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+13) then -- Rogue: Subtlety
        player:GossipClearMenu()
        addEquipment(player, CLASS_ROGUE, 3)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+14) then -- Priest: Discipline
        player:GossipClearMenu()
        addEquipment(player, CLASS_PRIEST, 1)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+15) then -- Priest: Holy
        player:GossipClearMenu()
        addEquipment(player, CLASS_PRIEST, 2)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+16) then -- Priest: Shadow
        player:GossipClearMenu()
        addEquipment(player, CLASS_PRIEST, 3)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+17) then -- Death Knight: Blood
        player:GossipClearMenu()
        addEquipment(player, CLASS_DEATH_KNIGHT, 1)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+18) then -- Death Knight: Frost
        player:GossipClearMenu()
        addEquipment(player, CLASS_DEATH_KNIGHT, 2)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+19) then -- Death Knight: Unholy
        player:GossipClearMenu()
        addEquipment(player, CLASS_DEATH_KNIGHT, 3)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+20) then -- Shaman: Elemental
        player:GossipClearMenu()
        addEquipment(player, CLASS_SHAMAN, 1)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+21) then -- Shaman: Enhancement
        player:GossipClearMenu()
        addEquipment(player, CLASS_SHAMAN, 2)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+22) then -- Shaman: Restoration
        player:GossipClearMenu()
        addEquipment(player, CLASS_SHAMAN, 3)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+23) then -- Mage: Arcane
        player:GossipClearMenu()
        addEquipment(player, CLASS_MAGE, 1)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+24) then -- Mage: Fire
        player:GossipClearMenu()
        addEquipment(player, CLASS_MAGE, 2)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+25) then -- Mage: Frost
        player:GossipClearMenu()
        addEquipment(player, CLASS_MAGE, 3)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+26) then -- Warlock: Affliction
        player:GossipClearMenu()
        addEquipment(player, CLASS_WARLOCK, 1)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+27) then -- Warlock: Demonology
        player:GossipClearMenu()
        addEquipment(player, CLASS_WARLOCK, 2)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+28) then -- Warlock: Destruction
        player:GossipClearMenu()
        addEquipment(player, CLASS_WARLOCK, 3)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+29) then -- Druid: Balance
        player:GossipClearMenu()
        addEquipment(player, CLASS_DRUID, 1)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+30) then -- Druid: Feral Combat
        player:GossipClearMenu()
        addEquipment(player, CLASS_DRUID, 2)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_EQUIPMENT+31) then -- Druid: Restoration
        player:GossipClearMenu()
        addEquipment(player, CLASS_DRUID, 3)
        assistantOnGossipSelect(event, player, object, sender, INT_EQUIPMENT, code)
    elseif (intid == INT_HEIRLOOMS) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want some armor", 1, INT_HEIRLOOMS+1)
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want some weapons", 1, INT_HEIRLOOMS+2)
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want something else", 1, INT_HEIRLOOMS+3)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_RETURN)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_HEIRLOOMS+1) then
        player:GossipClearMenu()

        if (player:GetClass() == CLASS_WARRIOR or player:GetClass() == CLASS_PALADIN or player:GetClass() == CLASS_DEATH_KNIGHT) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_30:25:25:-19|tPolished Spaulders of Valor", 1, INT_HEIRLOOMS+4)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_chest_plate03:25:25:-19|tPolished Breastplate of Valor", 1, INT_HEIRLOOMS+5)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_20:25:25:-19|tStrengthened Stockade Pauldrons", 1, INT_HEIRLOOMS+6)

            if (player:GetClass() == CLASS_PALADIN) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_10:25:25:-19|tPristine Lightforge Spaulders", 1, INT_HEIRLOOMS+7)
            end
        elseif (player:GetClass() == CLASS_HUNTER or player:GetClass() == CLASS_SHAMAN) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_01:25:25:-19|tChampion Herod's Shoulder", 1, INT_HEIRLOOMS+8)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_chest_chain_07:25:25:-19|tChampion's Deathdealer Breastplate", 1, INT_HEIRLOOMS+9)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_10:25:25:-19|tPrized Beastmaster's Mantle", 1, INT_HEIRLOOMS+10)
            if (player:GetClass() == CLASS_SHAMAN) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_29:25:25:-19|tMystical Pauldrons of Elements", 1, INT_HEIRLOOMS+11)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_chest_chain_11:25:25:-19|tMystical Vest of Elements", 1, INT_HEIRLOOMS+12)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_29:25:25:-19|tAged Pauldrons of The Five Thunders", 1, INT_HEIRLOOMS+13)
            end
        elseif (player:GetClass() == CLASS_ROGUE or player:GetClass() == CLASS_DRUID) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_07:25:25:-19|tStained Shadowcraft Spaulders", 1, INT_HEIRLOOMS+14)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_chest_leather_07:25:25:-19|tStained Shadowcraft Tunic", 1, INT_HEIRLOOMS+15)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_05:25:25:-19|tExceptional Stormshroud Shoulders", 1, INT_HEIRLOOMS+16)

            if (player:GetClass() == CLASS_DRUID) then
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_06:25:25:-19|tPreened Ironfeather Shoulders", 1, INT_HEIRLOOMS+17)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_chest_leather_06:25:25:-19|tPreened Ironfeather Breastplate", 1, INT_HEIRLOOMS+18)
                player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_01:25:25:-19|tLasting Feralheart Spaulders", 1, INT_HEIRLOOMS+19)
            end
        elseif (player:GetClass() == CLASS_PRIEST or player:GetClass() == CLASS_MAGE or player:GetClass() == CLASS_WARLOCK) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_misc_bone_taurenskull_01:25:25:-19|tTattered Dreadmist Mantle", 1, INT_HEIRLOOMS+20)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_chest_cloth_49:25:25:-19|tTattered Dreadmist Robe", 1, INT_HEIRLOOMS+21)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_shoulder_02:25:25:-19|tExquisite Sunderseer Mantle", 1, INT_HEIRLOOMS+22)
        end

        player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_jewelry_ring_39:25:25:-19|tDread Pirate Ring", 1, INT_HEIRLOOMS+23)
        player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_jewelry_talisman_01:25:25:-19|tSwift Hand of Justice", 1, INT_HEIRLOOMS+24)

        if (player:GetClass() == CLASS_PALADIN or player:GetClass() == CLASS_HUNTER or player:GetClass() == CLASS_PRIEST or player:GetClass() == CLASS_SHAMAN or player:GetClass() == CLASS_MAGE or player:GetClass() == CLASS_WARLOCK or player:GetClass() == CLASS_DRUID) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_jewelry_talisman_08:25:25:-19|tDiscerning Eye of the Beast", 1, INT_HEIRLOOMS+25)
        end

        if (player:GetTeam() == TEAM_ALLIANCE) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_jewelry_trinketpvp_01:25:25:-19|tInherited Insignia of the Alliance", 1, INT_HEIRLOOMS+26)
        elseif (player:GetTeam() == TEAM_HORDE) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_jewelry_trinketpvp_02:25:25:-19|tInherited Insignia of the Horde", 1, INT_HEIRLOOMS+27)
        end

        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_HEIRLOOMS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_HEIRLOOMS+2) then
        player:GossipClearMenu()

        if (player:GetClass() == CLASS_WARRIOR or player:GetClass() == CLASS_PALADIN or player:GetClass() == CLASS_DEATH_KNIGHT) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_axe_09:25:25:-19|tBloodied Arcanite Reaper", 1, INT_HEIRLOOMS+28)
        end
        if (player:GetClass() == CLASS_HUNTER or player:GetClass() == CLASS_ROGUE or player:GetClass() == CLASS_SHAMAN) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_sword_17:25:25:-19|tBalanced Heartseeker", 1, INT_HEIRLOOMS+29)
        end
        if (player:GetClass() == CLASS_WARRIOR or player:GetClass() == CLASS_PALADIN or player:GetClass() == CLASS_HUNTER or player:GetClass() == CLASS_ROGUE or player:GetClass() == CLASS_DEATH_KNIGHT) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_sword_43:25:25:-19|tVenerable Dal'Rend's Sacred Charge", 1, INT_HEIRLOOMS+30)
        end
        if (player:GetClass() == CLASS_WARRIOR or player:GetClass() == CLASS_HUNTER or player:GetClass() == CLASS_ROGUE) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_weapon_bow_08:25:25:-19|tCharmed Ancient Bone Bow", 1, INT_HEIRLOOMS+31)
        end
        if (player:GetClass() == CLASS_PRIEST or player:GetClass() == CLASS_SHAMAN or player:GetClass() == CLASS_MAGE or player:GetClass() == CLASS_WARLOCK or player:GetClass() == CLASS_DRUID) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_jewelry_talisman_12:25:25:-19|tDignified Headmaster's Charge", 1, INT_HEIRLOOMS+32)
        end
        if (player:GetClass() == CLASS_PALADIN or player:GetClass() == CLASS_PRIEST or player:GetClass() == CLASS_SHAMAN or player:GetClass() == CLASS_DRUID) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_hammer_05:25:25:-19|tDevout Aurastone Hammer", 1, INT_HEIRLOOMS+33)
        end
        if (player:GetClass() == CLASS_WARRIOR or player:GetClass() == CLASS_HUNTER or player:GetClass() == CLASS_ROGUE or player:GetClass() == CLASS_SHAMAN) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_weapon_shortblade_03:25:25:-19|tSharpened Scarlet Kris", 1, INT_HEIRLOOMS+34)
        end
        if (player:GetClass() == CLASS_WARRIOR or player:GetClass() == CLASS_PALADIN or player:GetClass() == CLASS_DEATH_KNIGHT) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_sword_19:25:25:-19|tReforged Truesilver Champion", 1, INT_HEIRLOOMS+35)
        end
        if (player:GetClass() == CLASS_WARRIOR or player:GetClass() == CLASS_HUNTER or player:GetClass() == CLASS_ROGUE) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_weapon_rifle_09:25:25:-19|tUpgraded Dwarven Hand Cannon", 1, INT_HEIRLOOMS+36)
        end
        if (player:GetClass() == CLASS_PALADIN or player:GetClass() == CLASS_PRIEST or player:GetClass() == CLASS_SHAMAN or player:GetClass() == CLASS_DRUID) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_hammer_07:25:25:-19|tThe Blessed Hammer of Grace", 1, INT_HEIRLOOMS+37)
        end
        if (player:GetClass() == CLASS_PRIEST or player:GetClass() == CLASS_SHAMAN or player:GetClass() == CLASS_MAGE or player:GetClass() == CLASS_WARLOCK or player:GetClass() == CLASS_DRUID) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_staff_13:25:25:-19|tGrand Staff of Jordan", 1, INT_HEIRLOOMS+38)
        end
        if (player:GetClass() == CLASS_WARRIOR or player:GetClass() == CLASS_PALADIN or player:GetClass() == CLASS_HUNTER or player:GetClass() == CLASS_ROGUE or player:GetClass() == CLASS_DEATH_KNIGHT or player:GetClass() == CLASS_MAGE or player:GetClass() == CLASS_WARLOCK) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_sword_36:25:25:-19|tBattleworn Thrash Blade", 1, INT_HEIRLOOMS+39)
        end
        if (player:GetClass() == CLASS_ROGUE or player:GetClass() == CLASS_SHAMAN) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_hammer_17:25:25:-19|tVenerable Mass of McGowan", 1, INT_HEIRLOOMS+40)
        end
        if (player:GetClass() == CLASS_SHAMAN or player:GetClass() == CLASS_DRUID) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_gizmo_02:25:25:-19|tRepurposed Lava Dredger", 1, INT_HEIRLOOMS+41)
        end

        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_HEIRLOOMS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_HEIRLOOMS+3) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_misc_book_11:25:25:-19|tTome of Cold Weather Flight", 1, INT_HEIRLOOMS+42, false, "Do you wish to continue the transaction?", 10000000)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_HEIRLOOMS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_HEIRLOOMS+4) then
        player:AddItem(42949)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+5) then
        player:AddItem(48685)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+6) then
        player:AddItem(44099)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+7) then
        player:AddItem(44100)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+8) then
        player:AddItem(42950)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+9) then
        player:AddItem(48677)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+10) then
        player:AddItem(44101)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+11) then
        player:AddItem(42951)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+12) then
        player:AddItem(48683)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+13) then
        player:AddItem(44102)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+14) then
        player:AddItem(42952)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+15) then
        player:AddItem(48689)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+16) then
        player:AddItem(44103)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+17) then
        player:AddItem(42984)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+18) then
        player:AddItem(48687)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+19) then
        player:AddItem(44105)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+20) then
        player:AddItem(42985)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+21) then
        player:AddItem(48691)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+22) then
        player:AddItem(44107)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+23) then
        player:AddItem(50255)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+24) then
        player:AddItem(42991)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+25) then
        player:AddItem(42992)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+26) then
        player:AddItem(44098)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+27) then
        player:AddItem(44097)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+1, code)
    elseif (intid == INT_HEIRLOOMS+28) then
        player:AddItem(42943)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+29) then
        player:AddItem(42944)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+30) then
        player:AddItem(42945)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+31) then
        player:AddItem(42946)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+32) then
        player:AddItem(42947)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+33) then
        player:AddItem(42948)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+34) then
        player:AddItem(44091)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+35) then
        player:AddItem(44092)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+36) then
        player:AddItem(44093)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+37) then
        player:AddItem(44094)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+38) then
        player:AddItem(44095)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+39) then
        player:AddItem(44096)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+40) then
        player:AddItem(48716)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+41) then
        player:AddItem(48718)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+2, code)
    elseif (intid == INT_HEIRLOOMS+42) then
        player:ModifyMoney(-10000000)
        player:AddItem(49177)
        assistantOnGossipSelect(event, player, object, sender, INT_HEIRLOOMS+3, code)
    elseif (intid == INT_GLYPHS) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want some major glyphs", 1, INT_GLYPHS+1)
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want some minor glyphs", 1, INT_GLYPHS+2)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_RETURN)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GLYPHS+1) then
        player:GossipClearMenu()

        if (player:GetClass() == CLASS_WARRIOR) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Bloodthirst", 1, INT_GLYPHS+3)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Devastate", 1, INT_GLYPHS+4)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Intervene", 1, INT_GLYPHS+5)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Mortal Strike", 1, INT_GLYPHS+6)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Bladestorm", 1, INT_GLYPHS+7)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Shockwave", 1, INT_GLYPHS+8)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Vigilance", 1, INT_GLYPHS+9)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Enraged Regeneration", 1, INT_GLYPHS+10)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Spell Reflection", 1, INT_GLYPHS+11)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Shield Wall", 1, INT_GLYPHS+12)
        elseif (player:GetClass() == CLASS_PALADIN) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Hammer of Wrath", 1, INT_GLYPHS+13)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Avenging Wrath", 1, INT_GLYPHS+14)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Avenger's Shield", 1, INT_GLYPHS+15)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Holy Wrath", 1, INT_GLYPHS+16)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Seal of Righteousness", 1, INT_GLYPHS+17)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Seal of Vengeance", 1, INT_GLYPHS+18)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Beacon of Light", 1, INT_GLYPHS+19)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Hammer of the Righteous", 1, INT_GLYPHS+20)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Divine Storm", 1, INT_GLYPHS+21)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Shield of Righteousness", 1, INT_GLYPHS+22)
        elseif (player:GetClass() == CLASS_HUNTER) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Bestial Wrath", 1, INT_GLYPHS+23)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Snake Trap", 1, INT_GLYPHS+24)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Steady Shot", 1, INT_GLYPHS+25)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Trueshot Aura", 1, INT_GLYPHS+26)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Volley", 1, INT_GLYPHS+27)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Wyvern Sting", 1, INT_GLYPHS+28)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Chimera Shot", 1, INT_GLYPHS+29)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Explosive Shot", 1, INT_GLYPHS+30)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Kill Shot", 1, INT_GLYPHS+31)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Explosive Trap", 1, INT_GLYPHS+32)
        elseif (player:GetClass() == CLASS_ROGUE) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Adrenaline Rush", 1, INT_GLYPHS+33)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Deadly Throw", 1, INT_GLYPHS+34)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Vigor", 1, INT_GLYPHS+35)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Hunger for Blood", 1, INT_GLYPHS+36)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Killing Spree", 1, INT_GLYPHS+37)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Shadow Dance", 1, INT_GLYPHS+38)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Fan of Knives", 1, INT_GLYPHS+39)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Tricks of the Trade", 1, INT_GLYPHS+40)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Mutilate", 1, INT_GLYPHS+41)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Cloak of Shadows", 1, INT_GLYPHS+42)
        elseif (player:GetClass() == CLASS_PRIEST) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Circle of Healing", 1, INT_GLYPHS+43)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Lightwell", 1, INT_GLYPHS+44)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Mass Dispel", 1, INT_GLYPHS+45)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Shadow Word: Death", 1, INT_GLYPHS+46)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Dispersion", 1, INT_GLYPHS+47)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Guardian Spirit", 1, INT_GLYPHS+48)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Penance", 1, INT_GLYPHS+49)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Mind Sear", 1, INT_GLYPHS+50)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Hymn of Hope", 1, INT_GLYPHS+51)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Pain Suppression", 1, INT_GLYPHS+52)
        elseif (player:GetClass() == CLASS_DEATH_KNIGHT) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Anti-Magic Shell", 1, INT_GLYPHS+53)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Heart Strike", 1, INT_GLYPHS+54)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Bone Shield", 1, INT_GLYPHS+55)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Chains of Ice", 1, INT_GLYPHS+56)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Dark Command", 1, INT_GLYPHS+57)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Death Grip", 1, INT_GLYPHS+58)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Death and Decay", 1, INT_GLYPHS+59)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Frost Strike", 1, INT_GLYPHS+60)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Icebound Fortitude", 1, INT_GLYPHS+61)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Icy Touch", 1, INT_GLYPHS+62)
        elseif (player:GetClass() == CLASS_SHAMAN) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Chain Heal", 1, INT_GLYPHS+63)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Lava", 1, INT_GLYPHS+64)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Fire Elemental Totem", 1, INT_GLYPHS+65)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Mana Tide Totem", 1, INT_GLYPHS+66)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Stormstrike", 1, INT_GLYPHS+67)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Elemental Mastery", 1, INT_GLYPHS+68)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Thunder", 1, INT_GLYPHS+69)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Feral Spirit", 1, INT_GLYPHS+70)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Riptide", 1, INT_GLYPHS+71)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Earth Shield", 1, INT_GLYPHS+72)
        elseif (player:GetClass() == CLASS_MAGE) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Arcane Power", 1, INT_GLYPHS+73)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Deep Freeze", 1, INT_GLYPHS+74)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Living Bomb", 1, INT_GLYPHS+75)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Invisibility", 1, INT_GLYPHS+76)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Ice Lance", 1, INT_GLYPHS+77)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Molten Armor", 1, INT_GLYPHS+78)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Water Elemental", 1, INT_GLYPHS+79)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Frostfire", 1, INT_GLYPHS+80)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Arcane Blast", 1, INT_GLYPHS+81)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Eternal Water", 1, INT_GLYPHS+82)
        elseif (player:GetClass() == CLASS_WARLOCK) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Conflagrate", 1, INT_GLYPHS+83)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Death Coil", 1, INT_GLYPHS+84)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Felguard", 1, INT_GLYPHS+85)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Howl of Terror", 1, INT_GLYPHS+86)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Unstable Affliction", 1, INT_GLYPHS+87)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Haunt", 1, INT_GLYPHS+88)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Metamorphosis", 1, INT_GLYPHS+89)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Chaos Bolt", 1, INT_GLYPHS+90)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Demonic Circle", 1, INT_GLYPHS+91)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Shadowflame", 1, INT_GLYPHS+92)
        elseif (player:GetClass() == CLASS_DRUID) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Mangle", 1, INT_GLYPHS+93)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Swiftmend", 1, INT_GLYPHS+94)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Innervate", 1, INT_GLYPHS+95)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Lifebloom", 1, INT_GLYPHS+96)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Hurricane", 1, INT_GLYPHS+97)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Starfall", 1, INT_GLYPHS+98)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Focus", 1, INT_GLYPHS+99)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Berserk", 1, INT_GLYPHS+100)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Wild Growth", 1, INT_GLYPHS+101)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Nourish", 1, INT_GLYPHS+102)
        end

        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GLYPHS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GLYPHS+2) then
        player:GossipClearMenu()

        if (player:GetClass() == CLASS_WARRIOR) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Battle", 1, INT_GLYPHS+103)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Bloodrage", 1, INT_GLYPHS+104)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Charge", 1, INT_GLYPHS+105)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Mocking Blow", 1, INT_GLYPHS+106)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Thunder Clap", 1, INT_GLYPHS+107)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Enduring Victory", 1, INT_GLYPHS+108)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Command", 1, INT_GLYPHS+109)
        elseif (player:GetClass() == CLASS_PALADIN) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of Blessing of Might", 1, INT_GLYPHS+110)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of Blessing of Kings", 1, INT_GLYPHS+111)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of Blessing of Wisdom", 1, INT_GLYPHS+112)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of Lay on Hands", 1, INT_GLYPHS+113)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of Sense Undead", 1, INT_GLYPHS+114)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of the Wise", 1, INT_GLYPHS+115)
        elseif (player:GetClass() == CLASS_HUNTER) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of Revive Pet", 1, INT_GLYPHS+116)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of Mend Pet", 1, INT_GLYPHS+117)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of Feign Death", 1, INT_GLYPHS+118)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of Possessed Strength", 1, INT_GLYPHS+119)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of the Pack", 1, INT_GLYPHS+120)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of Scare Beast", 1, INT_GLYPHS+121)
        elseif (player:GetClass() == CLASS_ROGUE) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Pick Pocket", 1, INT_GLYPHS+122)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Distract", 1, INT_GLYPHS+123)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Pick Lock", 1, INT_GLYPHS+124)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Safe Fall", 1, INT_GLYPHS+125)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Blurred Speed", 1, INT_GLYPHS+126)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Vanish", 1, INT_GLYPHS+127)
        elseif (player:GetClass() == CLASS_PRIEST) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Fading", 1, INT_GLYPHS+128)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Levitate", 1, INT_GLYPHS+129)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Fortitude", 1, INT_GLYPHS+130)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Shadow Protection", 1, INT_GLYPHS+131)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Shackle Undead", 1, INT_GLYPHS+132)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Shadowfiend", 1, INT_GLYPHS+133)
        elseif (player:GetClass() == CLASS_DEATH_KNIGHT) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Blood Tap", 1, INT_GLYPHS+134)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Death's Embrace", 1, INT_GLYPHS+135)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Horn of Winter", 1, INT_GLYPHS+136)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Corpse Explosion", 1, INT_GLYPHS+137)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Pestilence", 1, INT_GLYPHS+138)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Raise Dead", 1, INT_GLYPHS+139)
        elseif (player:GetClass() == CLASS_SHAMAN) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Thunderstorm", 1, INT_GLYPHS+140)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Water Breathing", 1, INT_GLYPHS+141)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Astral Recall", 1, INT_GLYPHS+142)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Renewed Life", 1, INT_GLYPHS+143)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Water Shield", 1, INT_GLYPHS+144)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Water Walking", 1, INT_GLYPHS+145)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Ghost Wolf", 1, INT_GLYPHS+146)
        elseif (player:GetClass() == CLASS_MAGE) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Arcane Intellect", 1, INT_GLYPHS+147)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Fire Ward", 1, INT_GLYPHS+148)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Frost Armor", 1, INT_GLYPHS+149)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Frost Ward", 1, INT_GLYPHS+150)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of the Penguin", 1, INT_GLYPHS+151)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of the Bear Cub", 1, INT_GLYPHS+152)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Slow Fall", 1, INT_GLYPHS+153)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Blast Wave", 1, INT_GLYPHS+154)
        elseif (player:GetClass() == CLASS_WARLOCK) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Unending Breath", 1, INT_GLYPHS+155)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Drain Soul", 1, INT_GLYPHS+156)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Kilrogg", 1, INT_GLYPHS+157)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Curse of Exhaustion", 1, INT_GLYPHS+158)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Enslave Demon", 1, INT_GLYPHS+159)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Souls", 1, INT_GLYPHS+160)
        elseif (player:GetClass() == CLASS_DRUID) then
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Aquatic Form", 1, INT_GLYPHS+161)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Unburdened Rebirth", 1, INT_GLYPHS+162)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Thorns", 1, INT_GLYPHS+163)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Challenging Roar", 1, INT_GLYPHS+164)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of the Wild", 1, INT_GLYPHS+165)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Dash", 1, INT_GLYPHS+166)
            player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Typhoon", 1, INT_GLYPHS+167)
        end

        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GLYPHS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GLYPHS+3) then
        player:AddItem(43412)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+4) then
        player:AddItem(43415)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+5) then
        player:AddItem(43419)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+6) then
        player:AddItem(43421)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+7) then
        player:AddItem(45790)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+8) then
        player:AddItem(45792)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+9) then
        player:AddItem(45793)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+10) then
        player:AddItem(45794)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+11) then
        player:AddItem(45795)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+12) then
        player:AddItem(45797)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+13) then
        player:AddItem(41097)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+14) then
        player:AddItem(41107)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+15) then
        player:AddItem(41101)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+16) then
        player:AddItem(43867)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+17) then
        player:AddItem(43868)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+18) then
        player:AddItem(43869)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+19) then
        player:AddItem(45741)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+20) then
        player:AddItem(45742)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+21) then
        player:AddItem(45743)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+22) then
        player:AddItem(45744)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+23) then
        player:AddItem(43412)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+24) then
        player:AddItem(42913)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+25) then
        player:AddItem(42914)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+26) then
        player:AddItem(42915)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+27) then
        player:AddItem(42916)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+28) then
        player:AddItem(42917)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+29) then
        player:AddItem(45625)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+30) then
        player:AddItem(45731)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+31) then
        player:AddItem(45732)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+32) then
        player:AddItem(45733)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+33) then
        player:AddItem(42954)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+34) then
        player:AddItem(42959)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+35) then
        player:AddItem(42971)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+36) then
        player:AddItem(45761)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+37) then
        player:AddItem(45762)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+38) then
        player:AddItem(45764)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+39) then
        player:AddItem(45766)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+40) then
        player:AddItem(45767)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+41) then
        player:AddItem(45768)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+42) then
        player:AddItem(45769)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+43) then
        player:AddItem(42396)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+44) then
        player:AddItem(42403)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+45) then
        player:AddItem(42404)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+46) then
        player:AddItem(42414)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+47) then
        player:AddItem(45753)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+48) then
        player:AddItem(45755)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+49) then
        player:AddItem(45756)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+50) then
        player:AddItem(45757)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+51) then
        player:AddItem(45758)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+52) then
        player:AddItem(45760)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+53) then
        player:AddItem(43533)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+54) then
        player:AddItem(43534)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+55) then
        player:AddItem(43536)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+56) then
        player:AddItem(43537)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+57) then
        player:AddItem(43538)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+58) then
        player:AddItem(43541)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+59) then
        player:AddItem(43542)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+60) then
        player:AddItem(43543)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+61) then
        player:AddItem(43545)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+62) then
        player:AddItem(43546)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+63) then
        player:AddItem(41517)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+64) then
        player:AddItem(41524)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+65) then
        player:AddItem(41529)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+66) then
        player:AddItem(41538)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+67) then
        player:AddItem(41539)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+68) then
        player:AddItem(41552)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+69) then
        player:AddItem(45770)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+70) then
        player:AddItem(45771)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+71) then
        player:AddItem(45772)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+72) then
        player:AddItem(45775)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+73) then
        player:AddItem(42736)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+74) then
        player:AddItem(45736)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+75) then
        player:AddItem(45737)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+76) then
        player:AddItem(42748)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+77) then
        player:AddItem(42745)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+78) then
        player:AddItem(42751)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+79) then
        player:AddItem(42754)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+80) then
        player:AddItem(44684)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+81) then
        player:AddItem(44955)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+82) then
        player:AddItem(50045)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+83) then
        player:AddItem(42454)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+84) then
        player:AddItem(42457)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+85) then
        player:AddItem(42459)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+86) then
        player:AddItem(42463)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+87) then
        player:AddItem(42472)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+88) then
        player:AddItem(45779)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+89) then
        player:AddItem(45780)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+90) then
        player:AddItem(45781)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+91) then
        player:AddItem(45782)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+92) then
        player:AddItem(45783)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+93) then
        player:AddItem(40900)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+94) then
        player:AddItem(40906)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+95) then
        player:AddItem(40908)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+96) then
        player:AddItem(40915)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+97) then
        player:AddItem(40920)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+98) then
        player:AddItem(40921)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+99) then
        player:AddItem(44928)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+100) then
        player:AddItem(45601)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+101) then
        player:AddItem(45602)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+102) then
        player:AddItem(45603)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+1, code)
    elseif (intid == INT_GLYPHS+103) then
        player:AddItem(43395)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+104) then
        player:AddItem(43396)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+105) then
        player:AddItem(43397)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+106) then
        player:AddItem(43398)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+107) then
        player:AddItem(43399)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+108) then
        player:AddItem(43400)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+109) then
        player:AddItem(49084)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+110) then
        player:AddItem(43340)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+111) then
        player:AddItem(43365)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+112) then
        player:AddItem(43366)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+113) then
        player:AddItem(43367)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+114) then
        player:AddItem(43368)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+115) then
        player:AddItem(43369)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+116) then
        player:AddItem(43338)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+117) then
        player:AddItem(43350)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+118) then
        player:AddItem(43351)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+119) then
        player:AddItem(43354)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+120) then
        player:AddItem(43355)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+121) then
        player:AddItem(43356)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+122) then
        player:AddItem(43343)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+123) then
        player:AddItem(43376)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+124) then
        player:AddItem(43377)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+125) then
        player:AddItem(43378)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+126) then
        player:AddItem(43379)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+127) then
        player:AddItem(43380)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+128) then
        player:AddItem(43342)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+129) then
        player:AddItem(43370)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+130) then
        player:AddItem(43371)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+131) then
        player:AddItem(43372)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+132) then
        player:AddItem(43373)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+133) then
        player:AddItem(43374)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+134) then
        player:AddItem(43535)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+135) then
        player:AddItem(43539)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+136) then
        player:AddItem(43544)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+137) then
        player:AddItem(43671)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+138) then
        player:AddItem(43672)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+139) then
        player:AddItem(43673)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+140) then
        player:AddItem(44923)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+141) then
        player:AddItem(43344)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+142) then
        player:AddItem(43381)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+143) then
        player:AddItem(43385)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+144) then
        player:AddItem(43386)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+145) then
        player:AddItem(43388)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+146) then
        player:AddItem(43725)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+147) then
        player:AddItem(43339)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+148) then
        player:AddItem(43357)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+149) then
        player:AddItem(43359)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+150) then
        player:AddItem(43360)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+151) then
        player:AddItem(43361)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+152) then
        player:AddItem(43362)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+153) then
        player:AddItem(43364)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+154) then
        player:AddItem(44920)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+155) then
        player:AddItem(43389)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+156) then
        player:AddItem(43390)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+157) then
        player:AddItem(43391)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+158) then
        player:AddItem(43392)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+159) then
        player:AddItem(43393)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+160) then
        player:AddItem(43394)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+161) then
        player:AddItem(43316)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+162) then
        player:AddItem(43331)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+163) then
        player:AddItem(43332)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+164) then
        player:AddItem(43334)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+165) then
        player:AddItem(43335)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+166) then
        player:AddItem(43674)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GLYPHS+167) then
        player:AddItem(44922)
        assistantOnGossipSelect(event, player, object, sender, INT_GLYPHS+2, code)
    elseif (intid == INT_GEMS) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want some meta gems", 1, INT_GEMS+1)
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want some red gems", 1, INT_GEMS+40)
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want some blue gems", 1, INT_GEMS+49)
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want some yellow gems", 1, INT_GEMS+54)
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want some purple gems", 1, INT_GEMS+61)
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want some green gems", 1, INT_GEMS+76)
        player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want some orange gems", 1, INT_GEMS+97)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_RETURN)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+1) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|t+14 Crit Rating, 1% Spell Reflect (2 R, 2 B, 2 Y)", 1, INT_GEMS+5)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|tChance to Increase Spell Cast Speed (B > Y)", 1, INT_GEMS+6)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|t+24 Attack Power, Minor Run Speed (2 Y, 1 R)", 1, INT_GEMS+7)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|t+12 Crit Rating, -1% Snare/Root Duration (R > Y)", 1, INT_GEMS+8)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+18 Stamina, -15% Stun Duration (3 B)", 1, INT_GEMS+9)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+14 Spell Power, +2% Reduced Threat (R > B)", 1, INT_GEMS+10)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+12 Defense, Chance to Restore Health (5 B)", 1, INT_GEMS+11)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+3 Attack Dmg, Chance to Stun (2 R, 2 Y, 2 B)", 1, INT_GEMS+12)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+12 Intellect, Chance to Restore Mana (2 R, 2 Y, 2 B)", 1, INT_GEMS+13)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+12 Agility, +3% Crit Damage (2 R, 2 Y, 2 B)", 1, INT_GEMS+14)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Proceed to the next page", 1, INT_GEMS+2)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+2) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|tChance to Increase Attack Speed (2 R, 2 B, 2 Y)", 1, INT_GEMS+15)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|t+12 Crit Rating, +3% Crit Damage (2 B)", 1, INT_GEMS+16)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+12 Defense, +5% Block Value (2 B, 1 Y)", 1, INT_GEMS+17)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|t+14 Spell Power, +2% Intellect (3 R)", 1, INT_GEMS+18)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+21 Crit Rating, +3% Crit Damage (2 B)", 1, INT_GEMS+19)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+25 Crit Rating, +1% Spell Reflect (1 R, 1 Y, 1 B)", 1, INT_GEMS+20)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+25 Spell Power, +2% Intellect (3 R)", 1, INT_GEMS+21)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+21 Crit Rating, Reduced Snare/Root 10% (2 R, 1 Y)", 1, INT_GEMS+22)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+42 Attack Power, Minor Run Speed (2 Y, 1 R)", 1, INT_GEMS+23)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+25 Spell Power, Minor Run Speed (1 R, 1 B, 1 Y)", 1, INT_GEMS+24)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Proceed to the next page", 1, INT_GEMS+3)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS+1)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+3) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+11 Mana 5 Seconds, 3% Crit Healing (2 R)", 1, INT_GEMS+25)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+32 Stamina, -2% Spell Damage Taken (2 B, 1 R)", 1, INT_GEMS+26)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+25 Spell Power, -10% Silence Duration (2 Y, 1 B)", 1, INT_GEMS+27)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+21 Crit Rating, -10% Fear Duration", 1, INT_GEMS+28)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+32 Stamina, +2% Increase Armor (2 B, 1 R)", 1, INT_GEMS+29)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+42 Attack Power, -10% Stun Duration (2 Y, 1 B)", 1, INT_GEMS+30)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+25 Spell Power, -10% Stun Duration (1 R, 1 Y, 1 B)", 1, INT_GEMS+31)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+42 Attack Power, Sometimes Heal on Crit (2 B, 1 R)", 1, INT_GEMS+32)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+21 Crit Rating, +2% Mana (2 R, 1 Y)", 1, INT_GEMS+33)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+25 Spell Power, -2% Threat (2 R, 1 B)", 1, INT_GEMS+34)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Proceed to the next page", 1, INT_GEMS+4)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS+2)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+4) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+21 Defense Rating, +5% Block Value (2 R, 1 B)", 1, INT_GEMS+35)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+32 Stamina, -10% Stun Duration (3 B)", 1, INT_GEMS+36)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+21 Agility, +3% Crit Damage (1 R, 1 Y, 1 B)", 1, INT_GEMS+37)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|tChance to Increase Attack Speed (1 R, 1 Y, 1 B)", 1, INT_GEMS+38)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+21 Intellect, Chance to Restore Mana (1 R, 1 Y, 1 B)", 1, INT_GEMS+39)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS+3)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+5) then
        player:AddItem(25890)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+1, code)
    elseif (intid == INT_GEMS+6) then
        player:AddItem(25893)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+1, code)
    elseif (intid == INT_GEMS+7) then
        player:AddItem(25894)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+1, code)
    elseif (intid == INT_GEMS+8) then
        player:AddItem(25895)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+1, code)
    elseif (intid == INT_GEMS+9) then
        player:AddItem(25896)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+1, code)
    elseif (intid == INT_GEMS+10) then
        player:AddItem(25897)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+1, code)
    elseif (intid == INT_GEMS+11) then
        player:AddItem(25898)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+1, code)
    elseif (intid == INT_GEMS+12) then
        player:AddItem(25899)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+1, code)
    elseif (intid == INT_GEMS+13) then
        player:AddItem(25901)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+1, code)
    elseif (intid == INT_GEMS+14) then
        player:AddItem(32409)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+1, code)
    elseif (intid == INT_GEMS+15) then
        player:AddItem(32410)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+2, code)
    elseif (intid == INT_GEMS+16) then
        player:AddItem(34220)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+2, code)
    elseif (intid == INT_GEMS+17) then
        player:AddItem(35501)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+2, code)
    elseif (intid == INT_GEMS+18) then
        player:AddItem(35503)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+2, code)
    elseif (intid == INT_GEMS+19) then
        player:AddItem(41285)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+2, code)
    elseif (intid == INT_GEMS+20) then
        player:AddItem(41307)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+2, code)
    elseif (intid == INT_GEMS+21) then
        player:AddItem(41333)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+2, code)
    elseif (intid == INT_GEMS+22) then
        player:AddItem(41335)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+2, code)
    elseif (intid == INT_GEMS+23) then
        player:AddItem(41339)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+2, code)
    elseif (intid == INT_GEMS+24) then
        player:AddItem(41375)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+2, code)
    elseif (intid == INT_GEMS+25) then
        player:AddItem(41376)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+3, code)
    elseif (intid == INT_GEMS+26) then
        player:AddItem(41377)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+3, code)
    elseif (intid == INT_GEMS+27) then
        player:AddItem(41378)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+3, code)
    elseif (intid == INT_GEMS+28) then
        player:AddItem(41379)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+3, code)
    elseif (intid == INT_GEMS+29) then
        player:AddItem(41380)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+3, code)
    elseif (intid == INT_GEMS+30) then
        player:AddItem(41381)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+3, code)
    elseif (intid == INT_GEMS+31) then
        player:AddItem(41382)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+3, code)
    elseif (intid == INT_GEMS+32) then
        player:AddItem(41385)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+3, code)
    elseif (intid == INT_GEMS+33) then
        player:AddItem(41389)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+3, code)
    elseif (intid == INT_GEMS+34) then
        player:AddItem(41395)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+3, code)
    elseif (intid == INT_GEMS+35) then
        player:AddItem(41396)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+4, code)
    elseif (intid == INT_GEMS+36) then
        player:AddItem(41397)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+4, code)
    elseif (intid == INT_GEMS+37) then
        player:AddItem(41398)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+4, code)
    elseif (intid == INT_GEMS+38) then
        player:AddItem(41400)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+4, code)
    elseif (intid == INT_GEMS+39) then
        player:AddItem(41401)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+4, code)
    elseif (intid == INT_GEMS+40) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Strength", 1, INT_GEMS+41)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Agility", 1, INT_GEMS+42)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+23 Spell Power", 1, INT_GEMS+43)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+40 Attack Power", 1, INT_GEMS+44)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Dodge Rating", 1, INT_GEMS+45)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Parry Rating", 1, INT_GEMS+46)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Armor Penetration Rating", 1, INT_GEMS+47)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Expertise Rating", 1, INT_GEMS+48)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+41) then
        player:AddItem(40111)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+40, code)
    elseif (intid == INT_GEMS+42) then
        player:AddItem(40112)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+40, code)
    elseif (intid == INT_GEMS+43) then
        player:AddItem(40113)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+40, code)
    elseif (intid == INT_GEMS+44) then
        player:AddItem(40114)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+40, code)
    elseif (intid == INT_GEMS+45) then
        player:AddItem(40115)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+40, code)
    elseif (intid == INT_GEMS+46) then
        player:AddItem(40116)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+40, code)
    elseif (intid == INT_GEMS+47) then
        player:AddItem(40117)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+40, code)
    elseif (intid == INT_GEMS+48) then
        player:AddItem(40118)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+40, code)
    elseif (intid == INT_GEMS+49) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_42:25:25:-19|t+30 Stamina", 1, INT_GEMS+50)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_42:25:25:-19|t+20 Spirit", 1, INT_GEMS+51)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_42:25:25:-19|t+10 Mana Every 5 Seconds", 1, INT_GEMS+52)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_42:25:25:-19|t+25 Spell Penetration", 1, INT_GEMS+53)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+50) then
        player:AddItem(40119)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+49, code)
    elseif (intid == INT_GEMS+51) then
        player:AddItem(40120)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+49, code)
    elseif (intid == INT_GEMS+52) then
        player:AddItem(40121)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+49, code)
    elseif (intid == INT_GEMS+53) then
        player:AddItem(40122)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+49, code)
    elseif (intid == INT_GEMS+54) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Intellect", 1, INT_GEMS+55)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Critical Strike Rating", 1, INT_GEMS+56)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Hit Rating", 1, INT_GEMS+57)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Defense Rating", 1, INT_GEMS+58)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Resilience Rating", 1, INT_GEMS+59)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Haste Rating", 1, INT_GEMS+60)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+55) then
        player:AddItem(40123)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+54, code)
    elseif (intid == INT_GEMS+56) then
        player:AddItem(40124)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+54, code)
    elseif (intid == INT_GEMS+57) then
        player:AddItem(40125)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+54, code)
    elseif (intid == INT_GEMS+58) then
        player:AddItem(40126)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+54, code)
    elseif (intid == INT_GEMS+59) then
        player:AddItem(40127)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+54, code)
    elseif (intid == INT_GEMS+60) then
        player:AddItem(40128)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+54, code)
    elseif (intid == INT_GEMS+61) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Strength, +15 Stamina", 1, INT_GEMS+63)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Agility, +15 Stamina", 1, INT_GEMS+64)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Agility, +5 Mana Every 5 Seconds", 1, INT_GEMS+65)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+12 Spell Power, +15 Stamina", 1, INT_GEMS+66)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+12 Spell Power, +10 Spirit", 1, INT_GEMS+67)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+12 Spell Power, +5 Mana Every 5 Seconds", 1, INT_GEMS+68)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+12 Spell Power, +13 Spell Penetration", 1, INT_GEMS+69)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+20 Attack Power, +15 Stamina", 1, INT_GEMS+70)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+20 Attack Power, +5 Mana Every 5 Seconds", 1, INT_GEMS+71)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Dodge Rating, +15 Stamina", 1, INT_GEMS+72)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Proceed to the next page", 1, INT_GEMS+62)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+62) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Parry Rating, +15 Stamina", 1, INT_GEMS+73)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Armor Penetration Rating, +15 Stamina", 1, INT_GEMS+74)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Expertise Rating, +15 Stamina", 1, INT_GEMS+75)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS+61)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+63) then
        player:AddItem(40129)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+61, code)
    elseif (intid == INT_GEMS+64) then
        player:AddItem(40130)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+61, code)
    elseif (intid == INT_GEMS+65) then
        player:AddItem(40131)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+61, code)
    elseif (intid == INT_GEMS+66) then
        player:AddItem(40132)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+61, code)
    elseif (intid == INT_GEMS+67) then
        player:AddItem(40133)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+61, code)
    elseif (intid == INT_GEMS+68) then
        player:AddItem(40134)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+61, code)
    elseif (intid == INT_GEMS+69) then
        player:AddItem(40135)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+61, code)
    elseif (intid == INT_GEMS+70) then
        player:AddItem(40136)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+61, code)
    elseif (intid == INT_GEMS+71) then
        player:AddItem(40137)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+61, code)
    elseif (intid == INT_GEMS+72) then
        player:AddItem(40138)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+61, code)
    elseif (intid == INT_GEMS+73) then
        player:AddItem(40139)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+62, code)
    elseif (intid == INT_GEMS+74) then
        player:AddItem(40140)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+62, code)
    elseif (intid == INT_GEMS+75) then
        player:AddItem(40141)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+62, code)
    elseif (intid == INT_GEMS+76) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Intellect, +15 Stamina", 1, INT_GEMS+78)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Critical Strike Rating, +15 Stamina", 1, INT_GEMS+79)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Hit Rating, +15 Stamina", 1, INT_GEMS+80)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Defense Rating, +15 Stamina", 1, INT_GEMS+81)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Resilience Rating, +15 Stamina", 1, INT_GEMS+82)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Haste Rating, +15 Stamina", 1, INT_GEMS+83)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Intellect, +10 Spirit", 1, INT_GEMS+84)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Critical Strike Rating, +10 Spirit", 1, INT_GEMS+85)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Hit Rating, +10 Spirit", 1, INT_GEMS+86)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Resilience Rating, +10 Spirit", 1, INT_GEMS+87)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Proceed to the next page", 1, INT_GEMS+77)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+77) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Haste Rating, +10 Spirit", 1, INT_GEMS+88)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Intellect, +5 Mana Every 5 Seconds", 1, INT_GEMS+89)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Critical Strike Rating, +5 Mana Every 5 Seconds", 1, INT_GEMS+90)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Hit rating, +5 Mana Every 5 Seconds", 1, INT_GEMS+91)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Resilience Rating, +5 Mana Every 5 Seconds", 1, INT_GEMS+92)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Haste Rating, +5 Mana Every 5 Seconds", 1, INT_GEMS+93)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Critical Strike Rating, +13 Spell Penetration", 1, INT_GEMS+94)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Hit Rating, +13 Spell Penetration", 1, INT_GEMS+95)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Haste Rating, +13 Spell Penetration", 1, INT_GEMS+96)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS+76)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+78) then
        player:AddItem(40164)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+76, code)
    elseif (intid == INT_GEMS+79) then
        player:AddItem(40165)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+76, code)
    elseif (intid == INT_GEMS+80) then
        player:AddItem(40166)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+76, code)
    elseif (intid == INT_GEMS+81) then
        player:AddItem(40167)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+76, code)
    elseif (intid == INT_GEMS+82) then
        player:AddItem(40168)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+76, code)
    elseif (intid == INT_GEMS+83) then
        player:AddItem(40169)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+76, code)
    elseif (intid == INT_GEMS+84) then
        player:AddItem(40170)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+76, code)
    elseif (intid == INT_GEMS+85) then
        player:AddItem(40171)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+76, code)
    elseif (intid == INT_GEMS+86) then
        player:AddItem(40172)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+76, code)
    elseif (intid == INT_GEMS+87) then
        player:AddItem(40173)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+76, code)
    elseif (intid == INT_GEMS+88) then
        player:AddItem(40174)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+77, code)
    elseif (intid == INT_GEMS+89) then
        player:AddItem(40175)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+77, code)
    elseif (intid == INT_GEMS+90) then
        player:AddItem(40176)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+77, code)
    elseif (intid == INT_GEMS+91) then
        player:AddItem(40177)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+77, code)
    elseif (intid == INT_GEMS+92) then
        player:AddItem(40178)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+77, code)
    elseif (intid == INT_GEMS+93) then
        player:AddItem(40179)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+77, code)
    elseif (intid == INT_GEMS+94) then
        player:AddItem(40180)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+77, code)
    elseif (intid == INT_GEMS+95) then
        player:AddItem(40181)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+77, code)
    elseif (intid == INT_GEMS+96) then
        player:AddItem(40182)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+77, code)
    elseif (intid == INT_GEMS+97) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Strength, +10 Critical Strike Rating", 1, INT_GEMS+100)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Strength, +10 Hit Rating", 1, INT_GEMS+101)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Strength, +10 Defense Rating", 1, INT_GEMS+102)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Strength, 10 Resilience Rating", 1, INT_GEMS+103)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Strength, +10 Haste Rating", 1, INT_GEMS+104)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Agility, +10 Critical Strike Rating", 1, INT_GEMS+105)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Agility, +10 Hit Rating", 1, INT_GEMS+106)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Agility, +10 Resilience Rating", 1, INT_GEMS+107)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Agility, +10 Haste Rating", 1, INT_GEMS+108)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+12 Spell Power, +10 Intellect", 1, INT_GEMS+109)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Proceed to the next page", 1, INT_GEMS+98)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+98) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+12 Spell Power, +10 Critical Strike Rating", 1, INT_GEMS+110)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+12 Spell Power, +10 Hit Rating", 1, INT_GEMS+111)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+12 Spell Power, +10 Resilience Rating", 1, INT_GEMS+112)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+12 Spell Power, +10 Haste Rating", 1, INT_GEMS+113)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+20 Attack Power, +10 Critical Strike Rating", 1, INT_GEMS+114)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+20 Attack Power, +10 Hit Rating", 1, INT_GEMS+115)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+20 Attack Power, +10 Resilience Rating", 1, INT_GEMS+116)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+20 Attack Power, +10 Haste Rating", 1, INT_GEMS+117)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Dodge Rating, +10 Defense Rating", 1, INT_GEMS+118)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Parry Rating, +10 Defense Rating", 1, INT_GEMS+119)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Proceed to the next page", 1, INT_GEMS+99)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS+97)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+99) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Expertise Rating, +10 Hit Rating", 1, INT_GEMS+120)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Expertise Rating, +10 Defense Rating", 1, INT_GEMS+121)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_GEMS+98)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_GEMS+100) then
        player:AddItem(40142)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+97, code)
    elseif (intid == INT_GEMS+101) then
        player:AddItem(40143)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+97, code)
    elseif (intid == INT_GEMS+102) then
        player:AddItem(40144)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+97, code)
    elseif (intid == INT_GEMS+103) then
        player:AddItem(40145)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+97, code)
    elseif (intid == INT_GEMS+104) then
        player:AddItem(40146)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+97, code)
    elseif (intid == INT_GEMS+105) then
        player:AddItem(40147)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+97, code)
    elseif (intid == INT_GEMS+106) then
        player:AddItem(40148)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+97, code)
    elseif (intid == INT_GEMS+107) then
        player:AddItem(40149)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+97, code)
    elseif (intid == INT_GEMS+108) then
        player:AddItem(40150)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+97, code)
    elseif (intid == INT_GEMS+109) then
        player:AddItem(40151)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+97, code)
    elseif (intid == INT_GEMS+110) then
        player:AddItem(40152)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+98, code)
    elseif (intid == INT_GEMS+111) then
        player:AddItem(40153)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+98, code)
    elseif (intid == INT_GEMS+112) then
        player:AddItem(40154)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+98, code)
    elseif (intid == INT_GEMS+113) then
        player:AddItem(40155)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+98, code)
    elseif (intid == INT_GEMS+114) then
        player:AddItem(40156)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+98, code)
    elseif (intid == INT_GEMS+115) then
        player:AddItem(40157)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+98, code)
    elseif (intid == INT_GEMS+116) then
        player:AddItem(40158)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+98, code)
    elseif (intid == INT_GEMS+117) then
        player:AddItem(40159)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+98, code)
    elseif (intid == INT_GEMS+118) then
        player:AddItem(40160)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+98, code)
    elseif (intid == INT_GEMS+119) then
        player:AddItem(40161)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+98, code)
    elseif (intid == INT_GEMS+120) then
        player:AddItem(40162)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+99, code)
    elseif (intid == INT_GEMS+121) then
        player:AddItem(40163)
        assistantOnGossipSelect(event, player, object, sender, INT_GEMS+99, code)
    elseif (intid == INT_CONTAINERS) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_VENDOR, "|TInterface\\icons\\inv_crate_04:25:25:-19|tForor's Crate of Endless Resist Gear Storage", 1, INT_CONTAINERS+1)
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_RETURN)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_CONTAINERS+1) then
        player:AddItem(ASSISTANT_CONTAINER_BAG)
        assistantOnGossipSelect(event, player, object, sender, INT_CONTAINERS, code)
    elseif (intid == INT_UTILITIES) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(GOSSIP_ICON_MONEY_BAG, "I want to change my name", 1, INT_UTILITIES+1, false, "Do you wish to continue the transaction?", (ASSISTANT_UTILITIES_COST_RENAME * 10000))
        player:GossipMenuAddItem(GOSSIP_ICON_MONEY_BAG, "I want to change my appearance", 1, INT_UTILITIES+2, false, "Do you wish to continue the transaction?", (ASSISTANT_UTILITIES_COST_CUSTOMIZE * 10000))
        player:GossipMenuAddItem(GOSSIP_ICON_MONEY_BAG, "I want to change my faction", 1, INT_UTILITIES+3, false, "Do you wish to continue the transaction?", (ASSISTANT_UTILITIES_COST_FACTION_CHANGE * 10000))
        player:GossipMenuAddItem(GOSSIP_ICON_MONEY_BAG, "I want to change my race", 1, INT_UTILITIES+4, false, "Do you wish to continue the transaction?", (ASSISTANT_UTILITIES_COST_RACE_CHANGE * 10000))
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_RETURN)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_UTILITIES+1) then
        if (player:HasAtLoginFlag(AT_LOGIN_RENAME) or player:HasAtLoginFlag(AT_LOGIN_CUSTOMIZE) or player:HasAtLoginFlag(AT_LOGIN_CHANGE_FACTION) or player:HasAtLoginFlag(AT_LOGIN_CHANGE_RACE)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            assistantOnGossipSelect(event, player, object, sender, INT_UTILITIES, code)
        else
            player:ModifyMoney(-(ASSISTANT_UTILITIES_COST_RENAME * 10000))
            player:SetAtLoginFlag(AT_LOGIN_RENAME)
            player:SendBroadcastMessage("You can now log out to apply the name change.")
            player:GossipComplete()
        end
    elseif (intid == INT_UTILITIES+2) then
        if (player:HasAtLoginFlag(AT_LOGIN_RENAME) or player:HasAtLoginFlag(AT_LOGIN_CUSTOMIZE) or player:HasAtLoginFlag(AT_LOGIN_CHANGE_FACTION) or player:HasAtLoginFlag(AT_LOGIN_CHANGE_RACE)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            assistantOnGossipSelect(event, player, object, sender, INT_UTILITIES, code)
        else
            player:ModifyMoney(-(ASSISTANT_UTILITIES_COST_CUSTOMIZE * 10000))
            player:SetAtLoginFlag(AT_LOGIN_CUSTOMIZE)
            player:SendBroadcastMessage("You can now log out to apply the customization.")
            player:GossipComplete()
        end
    elseif (intid == INT_UTILITIES+3) then
        if (player:HasAtLoginFlag(AT_LOGIN_RENAME) or player:HasAtLoginFlag(AT_LOGIN_CUSTOMIZE) or player:HasAtLoginFlag(AT_LOGIN_CHANGE_FACTION) or player:HasAtLoginFlag(AT_LOGIN_CHANGE_RACE)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            assistantOnGossipSelect(event, player, object, sender, INT_UTILITIES, code)
        else
            player:ModifyMoney(-(ASSISTANT_UTILITIES_COST_FACTION_CHANGE * 10000))
            player:SetAtLoginFlag(AT_LOGIN_CHANGE_FACTION)
            player:SendBroadcastMessage("You can now log out to apply the faction change.")
            player:GossipComplete()
        end
    elseif (intid == INT_UTILITIES+4) then
        if (player:HasAtLoginFlag(AT_LOGIN_RENAME) or player:HasAtLoginFlag(AT_LOGIN_CUSTOMIZE) or player:HasAtLoginFlag(AT_LOGIN_CHANGE_FACTION) or player:HasAtLoginFlag(AT_LOGIN_CHANGE_RACE)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            assistantOnGossipSelect(event, player, object, sender, INT_UTILITIES, code)
        else
            player:ModifyMoney(-(ASSISTANT_UTILITIES_COST_RACE_CHANGE * 10000))
            player:SetAtLoginFlag(AT_LOGIN_CHANGE_RACE)
            player:SendBroadcastMessage("You can now log out to apply the race change.")
            player:GossipComplete()
        end
    elseif (intid == INT_MISCELLANEOUS) then
        player:GossipClearMenu()

        if (ENABLE_MISCELLANOUS_UNBIND_INSTANCES) then
            player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want to unbind my instances", 1, INT_MISCELLANEOUS+1)
        end

        if (ENABLE_MISCELLANOUS_TOTEMS and player:GetClass() == CLASS_SHAMAN) then
            player:GossipMenuAddItem(GOSSIP_ICON_TALK, "I want totems", 1, INT_MISCELLANEOUS+2)
        end

        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "Return to previous page", 1, INT_RETURN)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == INT_MISCELLANEOUS+1) then
        local unbound = 0
        local count = 0
        for _ in pairs(INSTANCE_MAP_ID) do count = count + 1 end

        for i=1,count do
            if (INSTANCE_MAP_ID[i][4]) then
                player:UnbindInstance(INSTANCE_MAP_ID[i][1], INSTANCE_MAP_ID[i][2])
                unbound = unbound + 1
            end
        end

        player:SendBroadcastMessage(unbound.." instance difficulties have been reset.")

        assistantOnGossipSelect(event, player, object, sender, INT_MISCELLANEOUS, code)
    elseif (intid == INT_MISCELLANEOUS+2) then
        local TOTEM_EARTHEN_RING = 46978
        local TOTEM_EARTH        = 5175
        local TOTEM_FIRE         = 5176
        local TOTEM_WATER        = 5177
        local TOTEM_AIR          = 5178

        if not (player:HasItem(TOTEM_EARTHEN_RING, 1, true)) then
            if not (player:HasItem(TOTEM_EARTH, 1, true)) then
                player:AddItem(TOTEM_EARTH)
            end

            if not (player:HasItem(TOTEM_FIRE, 1, true)) then
                player:AddItem(TOTEM_FIRE)
            end

            if not (player:HasItem(TOTEM_WATER, 1, true)) then
                player:AddItem(TOTEM_WATER)
            end

            if not (player:HasItem(TOTEM_AIR, 1, true)) then
                player:AddItem(TOTEM_AIR)
            end
        end

        assistantOnGossipSelect(event, player, object, sender, INT_MISCELLANEOUS, code)
    end
end

RegisterPlayerGossipEvent(1, 2, assistantOnGossipSelect)
