local Config = {}
Config.EnableHeirlooms             = true -- Allow players to obtain heirlooms
Config.EnableGlyphs                = true -- Allow players to obtain glyphs
Config.EnableGems                  = true -- Allow players to obtain gems
Config.EnableUtilities             = true -- Allow players to perform name change, race change, customization and faction change
Config.EnableApprenticeProfession  = true -- Allow players to increase their profession to skill level 75 of 75
Config.EnableJourneymanProfession  = true -- Allow players to increase their profession to skill level 150 of 150
Config.EnableExpertProfession      = true -- Allow players to increase their profession to skill level 225 of 225
Config.EnableArtisanProfession     = true -- Allow players to increase their profession to skill level 300 of 300
Config.EnableMasterProfession      = true -- Allow players to increase their profession to skill level 375 of 375
Config.EnableGrandMasterProfession = true -- Allow players to increase their profession to skill level 450 of 450
Config.ApprenticeProfessionCost    = 100 -- The cost in gold to increase a profession skill level to 75
Config.JourneymanProfessionCost    = 250 -- The cost in gold to increase a profession skill level to 150
Config.ExpertProfessionCost        = 500 -- The cost in gold to increase a profession skill level to 225
Config.ArtisanProfessionCost       = 750 -- The cost in gold to increase a profession skill level to 300
Config.MasterProfessionCost        = 1250 -- The cost in gold to increase a profession skill level to 375
Config.GrandMasterProfessionCost   = 2500 -- The cost in gold to increase a profession skill level to 450
Config.NameChangeCost              = 10 -- The cost in gold to perform a name change
Config.CustomizeCost               = 50 -- The cost in gold to perform a customization or appearance change
Config.RaceChangeCost              = 500 -- The cost in gold to perform a race chang
Config.FactionChangeCost           = 1000 -- The cost in gold to perform a faction change

local Id        = {
    Return      = 50,
    Heirlooms   = 100,
    Glyphs      = 200,
    Gems        = 500,
    Utilities   = 800,
    Professions = 900,
}

local Icon   = {
    Chat     = 0, -- white chat bubble
    Vendor   = 1, -- brown bag
    Taxi     = 2, -- flightmarker (paperplane)
    Trainer  = 3, -- brown book (trainer)
    Interact = 4, -- golden interaction wheel
    MoneyBag = 6, -- brown bag (with gold coin in lower corner)
    Talk     = 7, -- white chat bubble (with "..." inside)
    Tabard   = 8, -- white tabard
    Battle   = 9, -- two crossed swords
    Dot      = 10, -- yellow dot/point
}

local Flag        = {
    Rename        = 0x01,
    Customize     = 0x08,
    ChangeFaction = 0x40,
    ChangeRace    = 0x80,
}

local Event        = {
    OnGossipHello  = 1,
    OnGossipSelect = 2,
    OnLogin        = 3,
    OnConfigLoad   = 9,
    OnCommand      = 42,
}

local Class     = {
    Universal   = -1,
    Warrior     = 1,
    Paladin     = 2,
    Hunter      = 3,
    Rogue       = 4,
    Priest      = 5,
    DeathKnight = 6,
    Shaman      = 7,
    Mage        = 8,
    Warlock     = 9,
    Druid       = 11,
}

local Skill        = {
    FirstAid       = 129,
    Blacksmithing  = 164,
    Leatherworking = 165,
    Alchemy        = 171,
    Herbalism      = 182,
    Cooking        = 185,
    Mining         = 186,
    Tailoring      = 197,
    Engineering    = 202,
    Enchanting     = 333,
    Fishing        = 356,
    Skinning       = 393,
    Inscription    = 773,
    Jewelcrafting  = 755,
}

local SkillLevel = {
    Apprentice   = 75,
    Journeyman   = 150,
    Expert       = 225,
    Artisan      = 300,
    Master       = 375,
    GrandMaster  = 450,
}

if (Config.EnableGlyphs) then
    WorldDBQuery('UPDATE `item_template` SET `SellPrice`=0 WHERE `entry` IN (43412, 43415, 43419, 43421, 45790, 45792, 45793, 45794, 45795, 45797, 41097, 41107, 41101, 43867, 43868, 43869, 45741, 45742, 45743, 45744, 43412, 42913, 42914, 42915, 42916, 42917, 45625, 45731, 45732, 45733, 42954, 42959, 42971, 45761, 45762, 45764, 45766, 45767, 45768, 45769, 42396, 42403, 42404, 42414, 45753, 45755, 45756, 45757, 45758, 45760, 43533, 43534, 43536, 43537, 43538, 43541, 43542, 43543, 43545, 43546, 41517, 41524, 41529, 41538, 41539, 41552, 45770, 45771, 45772, 45775, 42736, 45736, 45737, 42748, 42745, 42751, 42754, 44684, 44955, 50045, 42454, 42457, 42459, 42463, 42472, 45779, 45780, 45781, 45782, 45783, 40900, 40906, 40908, 40915, 40920, 40921, 44928, 45601, 45602, 45603, 43395, 43396, 43397, 43398, 43399, 43400, 49084, 43340, 43365, 43366, 43367, 43368, 43369, 43338, 43350, 43351, 43354, 43355, 43356, 43343, 43376, 43377, 43378, 43379, 43380, 43342, 43370, 43371, 43372, 43373, 43374, 43535, 43539, 43544, 43671, 43672, 43673, 44923, 43344, 43381, 43385, 43386, 43388, 43725, 43339, 43357, 43359, 43360, 43361, 43362, 43364, 44920, 43389, 43390, 43391, 43392, 43393, 43394, 43316, 43331, 43332, 43334, 43335, 43674, 44922);')
end

if (Config.EnableGems) then
    WorldDBQuery('UPDATE `item_template` SET `SellPrice`=0 WHERE `entry` IN (25890, 25893, 25894, 25895, 25896, 25897, 25898, 25899, 25901, 32409, 32410, 34220, 35501, 35503, 41285, 41307, 41333, 41335, 41339, 41375, 41376, 41377, 41378, 41379, 41380, 41381, 41382, 41385, 41389, 41395, 41396, 41397, 41398, 41400, 41401, 40111, 40112, 40113, 40114, 40115, 40116, 40117, 40118, 40119, 40120, 40121, 40122, 40123, 40124, 40125, 40126, 40127, 40128, 40129, 40130, 40131, 40132, 40133, 40134, 40135, 40136, 40137, 40138, 40139, 40140, 40141, 40164, 40165, 40166, 40167, 40168, 40169, 40170, 40171, 40172, 40173, 40174, 40175, 40176, 40177, 40178, 40179, 40180, 40181, 40182, 40142, 40143, 40144, 40145, 40146, 40147, 40148, 40149, 40150, 40151, 40152, 40153, 40154, 40155, 40156, 40157, 40158, 40159, 40160, 40161, 40162, 40163);')
end

function Player:HasValidProfession()
    if (Config.EnableApprenticeProfession or Config.EnableJourneymanProfession or Config.EnableExpertProfession or Config.EnableArtisanProfession or Config.EnableMasterProfession or Config.EnableGrandMasterProfession) then
        if (self:IsValidProfession(Skill.FirstAid) or self:IsValidProfession(Skill.Blacksmithing) or self:IsValidProfession(Skill.Leatherworking) or self:IsValidProfession(Skill.Alchemy) or self:IsValidProfession(Skill.Herbalism) or self:IsValidProfession(Skill.Cooking) or self:IsValidProfession(Skill.Mining) or self:IsValidProfession(Skill.Tailoring) or self:IsValidProfession(Skill.Engineering) or self:IsValidProfession(Skill.Enchanting) or self:IsValidProfession(Skill.Fishing) or self:IsValidProfession(Skill.Skinning) or self:IsValidProfession(Skill.Inscription) or self:IsValidProfession(Skill.Jewelcrafting)) then
            return true
        end
    end

    return false
end

function Player:IsValidProfession(skill)
    if (self:HasSkill(skill) and ((self:GetPureSkillValue(skill) < SkillLevel.Apprentice and self:GetPureMaxSkillValue(skill) == SkillLevel.Apprentice and Config.EnableApprenticeProfession) or (self:GetPureSkillValue(skill) < SkillLevel.Journeyman and self:GetPureMaxSkillValue(skill) == SkillLevel.Journeyman and Config.EnableJourneymanProfession) or (self:GetPureSkillValue(skill) < SkillLevel.Expert and self:GetPureMaxSkillValue(skill) == SkillLevel.Expert and Config.EnableExpertProfession) or (self:GetPureSkillValue(skill) < SkillLevel.Artisan and self:GetPureMaxSkillValue(skill) == SkillLevel.Artisan and Config.EnableArtisanProfession) or (self:GetPureSkillValue(skill) < SkillLevel.Master and self:GetPureMaxSkillValue(skill) == SkillLevel.Master and Config.EnableMasterProfession) or (self:GetPureSkillValue(skill) < SkillLevel.GrandMaster and self:GetPureMaxSkillValue(skill) == SkillLevel.GrandMaster and Config.EnableGrandMasterProfession))) then
        return true
    end

    return false
end

function Player:GetProfessionCost(skill)
    local cost = 0
    if (self:GetPureMaxSkillValue(skill) == SkillLevel.Apprentice) then
        cost = Config.ApprenticeProfessionCost
    elseif (self:GetPureMaxSkillValue(skill) == SkillLevel.Journeyman) then
        cost = Config.JourneymanProfessionCost
    elseif (self:GetPureMaxSkillValue(skill) == SkillLevel.Expert) then
        cost = Config.ExpertProfessionCost
    elseif (self:GetPureMaxSkillValue(skill) == SkillLevel.Artisan) then
        cost = Config.ArtisanProfessionCost
    elseif (self:GetPureMaxSkillValue(skill) == SkillLevel.Master) then
        cost = Config.MasterProfessionCost
    elseif (self:GetPureMaxSkillValue(skill) == SkillLevel.GrandMaster) then
        cost = Config.GrandMasterProfessionCost
    end

    return cost * 10000
end

local function AssistantCommand(event, player, command, chatHandler)
    if (Config.EnableHeirlooms or Config.EnableGlyphs or Config.EnableGems or Config.EnableUtilities or Config.EnableProfessions) then
        if (command ~= 'assistant') then
            return
        end

        AssistantOnGossipHello(event, player, player)
        return false
    end
end
RegisterPlayerEvent(Event.OnCommand, AssistantCommand)

function AssistantOnGossipHello(event, player, object)
    player:GossipClearMenu()
    if (Config.EnableHeirlooms) then
        player:GossipMenuAddItem(Icon.Talk, "I want some heirlooms", 1, Id.Heirlooms)
    end
    if (Config.EnableGlyphs) then
        player:GossipMenuAddItem(Icon.Talk, "I want some glyphs", 1, Id.Glyphs)
    end
    if (Config.EnableGems) then
        player:GossipMenuAddItem(Icon.Talk, "I want some gems", 1, Id.Gems)
    end
    if (Config.EnableUtilities) then
        player:GossipMenuAddItem(Icon.Talk, "I want utilities", 1, Id.Utilities)
    end
    if (player:HasValidProfession()) then
        player:GossipMenuAddItem(Icon.Talk, "I need help with my professions", 1, Id.Professions)
    end
    player:GossipSendMenu(0x7FFFFFFF, object, 1)
end
RegisterPlayerGossipEvent(1, Event.OnGossipHello, AssistantOnGossipHello)

function AssistantOnGossipSelect(event, player, object, sender, intid, code)
    if (intid == Id.Return) then
        AssistantOnGossipHello(event, player, player)
    elseif (intid == Id.Heirlooms) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Talk, "I want some armor", 1, Id.Heirlooms+1)
        player:GossipMenuAddItem(Icon.Talk, "I want some weapons", 1, Id.Heirlooms+2)
        player:GossipMenuAddItem(Icon.Talk, "I want something else", 1, Id.Heirlooms+3)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Return)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Heirlooms+1) then
        player:GossipClearMenu()

        if (player:GetClass() == Class.Warrior or player:GetClass() == Class.Paladin or player:GetClass() == Class.DeathKnight) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_30:25:25:-19|tPolished Spaulders of Valor", 1, Id.Heirlooms+4)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_chest_plate03:25:25:-19|tPolished Breastplate of Valor", 1, Id.Heirlooms+5)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_20:25:25:-19|tStrengthened Stockade Pauldrons", 1, Id.Heirlooms+6)

            if (player:GetClass() == Class.Paladin) then
                player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_10:25:25:-19|tPristine Lightforge Spaulders", 1, Id.Heirlooms+7)
            end
        elseif (player:GetClass() == Class.Hunter or player:GetClass() == Class.Shaman) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_01:25:25:-19|tChampion Herod's Shoulder", 1, Id.Heirlooms+8)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_chest_chain_07:25:25:-19|tChampion's Deathdealer Breastplate", 1, Id.Heirlooms+9)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_10:25:25:-19|tPrized Beastmaster's Mantle", 1, Id.Heirlooms+10)
            if (player:GetClass() == Class.Shaman) then
                player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_29:25:25:-19|tMystical Pauldrons of Elements", 1, Id.Heirlooms+11)
                player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_chest_chain_11:25:25:-19|tMystical Vest of Elements", 1, Id.Heirlooms+12)
                player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_29:25:25:-19|tAged Pauldrons of The Five Thunders", 1, Id.Heirlooms+13)
            end
        elseif (player:GetClass() == Class.Rogue or player:GetClass() == Class.Druid) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_07:25:25:-19|tStained Shadowcraft Spaulders", 1, Id.Heirlooms+14)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_chest_leather_07:25:25:-19|tStained Shadowcraft Tunic", 1, Id.Heirlooms+15)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_05:25:25:-19|tExceptional Stormshroud Shoulders", 1, Id.Heirlooms+16)

            if (player:GetClass() == Class.Druid) then
                player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_06:25:25:-19|tPreened Ironfeather Shoulders", 1, Id.Heirlooms+17)
                player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_chest_leather_06:25:25:-19|tPreened Ironfeather Breastplate", 1, Id.Heirlooms+18)
                player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_01:25:25:-19|tLasting Feralheart Spaulders", 1, Id.Heirlooms+19)
            end
        elseif (player:GetClass() == Class.Priest or player:GetClass() == Class.Mage or player:GetClass() == Class.Warlock) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_misc_bone_taurenskull_01:25:25:-19|tTattered Dreadmist Mantle", 1, Id.Heirlooms+20)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_chest_cloth_49:25:25:-19|tTattered Dreadmist Robe", 1, Id.Heirlooms+21)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_shoulder_02:25:25:-19|tExquisite Sunderseer Mantle", 1, Id.Heirlooms+22)
        end

        player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_jewelry_ring_39:25:25:-19|tDread Pirate Ring", 1, Id.Heirlooms+23)
        player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_jewelry_talisman_01:25:25:-19|tSwift Hand of Justice", 1, Id.Heirlooms+24)

        if (player:GetClass() == Class.Paladin or player:GetClass() == Class.Hunter or player:GetClass() == Class.Priest or player:GetClass() == Class.Shaman or player:GetClass() == Class.Mage or player:GetClass() == Class.Warlock or player:GetClass() == Class.Druid) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_jewelry_talisman_08:25:25:-19|tDiscerning Eye of the Beast", 1, Id.Heirlooms+25)
        end

        if (player:GetTeam() == TEAM_ALLIANCE) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_jewelry_trinketpvp_01:25:25:-19|tInherited Insignia of the Alliance", 1, Id.Heirlooms+26)
        elseif (player:GetTeam() == TEAM_HORDE) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_jewelry_trinketpvp_02:25:25:-19|tInherited Insignia of the Horde", 1, Id.Heirlooms+27)
        end

        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Heirlooms)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Heirlooms+2) then
        player:GossipClearMenu()

        if (player:GetClass() == Class.Warrior or player:GetClass() == Class.Paladin or player:GetClass() == Class.DeathKnight) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_axe_09:25:25:-19|tBloodied Arcanite Reaper", 1, Id.Heirlooms+28)
        end
        if (player:GetClass() == Class.Hunter or player:GetClass() == Class.Rogue or player:GetClass() == Class.Shaman) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_sword_17:25:25:-19|tBalanced Heartseeker", 1, Id.Heirlooms+29)
        end
        if (player:GetClass() == Class.Warrior or player:GetClass() == Class.Paladin or player:GetClass() == Class.Hunter or player:GetClass() == Class.Rogue or player:GetClass() == Class.DeathKnight) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_sword_43:25:25:-19|tVenerable Dal'Rend's Sacred Charge", 1, Id.Heirlooms+30)
        end
        if (player:GetClass() == Class.Warrior or player:GetClass() == Class.Hunter or player:GetClass() == Class.Rogue) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_weapon_bow_08:25:25:-19|tCharmed Ancient Bone Bow", 1, Id.Heirlooms+31)
        end
        if (player:GetClass() == Class.Priest or player:GetClass() == Class.Shaman or player:GetClass() == Class.Mage or player:GetClass() == Class.Warlock or player:GetClass() == Class.Druid) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_jewelry_talisman_12:25:25:-19|tDignified Headmaster's Charge", 1, Id.Heirlooms+32)
        end
        if (player:GetClass() == Class.Paladin or player:GetClass() == Class.Priest or player:GetClass() == Class.Shaman or player:GetClass() == Class.Druid) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_hammer_05:25:25:-19|tDevout Aurastone Hammer", 1, Id.Heirlooms+33)
        end
        if (player:GetClass() == Class.Warrior or player:GetClass() == Class.Hunter or player:GetClass() == Class.Rogue or player:GetClass() == Class.Shaman) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_weapon_shortblade_03:25:25:-19|tSharpened Scarlet Kris", 1, Id.Heirlooms+34)
        end
        if (player:GetClass() == Class.Warrior or player:GetClass() == Class.Paladin or player:GetClass() == Class.DeathKnight) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_sword_19:25:25:-19|tReforged Truesilver Champion", 1, Id.Heirlooms+35)
        end
        if (player:GetClass() == Class.Warrior or player:GetClass() == Class.Hunter or player:GetClass() == Class.Rogue) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_weapon_rifle_09:25:25:-19|tUpgraded Dwarven Hand Cannon", 1, Id.Heirlooms+36)
        end
        if (player:GetClass() == Class.Paladin or player:GetClass() == Class.Priest or player:GetClass() == Class.Shaman or player:GetClass() == Class.Druid) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_hammer_07:25:25:-19|tThe Blessed Hammer of Grace", 1, Id.Heirlooms+37)
        end
        if (player:GetClass() == Class.Priest or player:GetClass() == Class.Shaman or player:GetClass() == Class.Mage or player:GetClass() == Class.Warlock or player:GetClass() == Class.Druid) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_staff_13:25:25:-19|tGrand Staff of Jordan", 1, Id.Heirlooms+38)
        end
        if (player:GetClass() == Class.Warrior or player:GetClass() == Class.Paladin or player:GetClass() == Class.Hunter or player:GetClass() == Class.Rogue or player:GetClass() == Class.DeathKnight or player:GetClass() == Class.Mage or player:GetClass() == Class.Warlock) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_sword_36:25:25:-19|tBattleworn Thrash Blade", 1, Id.Heirlooms+39)
        end
        if (player:GetClass() == Class.Rogue or player:GetClass() == Class.Shaman) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_hammer_17:25:25:-19|tVenerable Mass of McGowan", 1, Id.Heirlooms+40)
        end
        if (player:GetClass() == Class.Shaman or player:GetClass() == Class.Druid) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_gizmo_02:25:25:-19|tRepurposed Lava Dredger", 1, Id.Heirlooms+41)
        end

        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Heirlooms)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Heirlooms+3) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_misc_book_11:25:25:-19|tTome of Cold Weather Flight", 1, Id.Heirlooms+42, false, "Do you wish to continue the transaction?", 10000000)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Heirlooms)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Heirlooms+4) then
        player:AddItem(42949)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+5) then
        player:AddItem(48685)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+6) then
        player:AddItem(44099)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+7) then
        player:AddItem(44100)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+8) then
        player:AddItem(42950)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+9) then
        player:AddItem(48677)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+10) then
        player:AddItem(44101)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+11) then
        player:AddItem(42951)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+12) then
        player:AddItem(48683)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+13) then
        player:AddItem(44102)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+14) then
        player:AddItem(42952)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+15) then
        player:AddItem(48689)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+16) then
        player:AddItem(44103)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+17) then
        player:AddItem(42984)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+18) then
        player:AddItem(48687)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+19) then
        player:AddItem(44105)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+20) then
        player:AddItem(42985)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+21) then
        player:AddItem(48691)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+22) then
        player:AddItem(44107)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+23) then
        player:AddItem(50255)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+24) then
        player:AddItem(42991)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+25) then
        player:AddItem(42992)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+26) then
        player:AddItem(44098)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+27) then
        player:AddItem(44097)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+1, code)
    elseif (intid == Id.Heirlooms+28) then
        player:AddItem(42943)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+29) then
        player:AddItem(42944)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+30) then
        player:AddItem(42945)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+31) then
        player:AddItem(42946)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+32) then
        player:AddItem(42947)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+33) then
        player:AddItem(42948)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+34) then
        player:AddItem(44091)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+35) then
        player:AddItem(44092)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+36) then
        player:AddItem(44093)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+37) then
        player:AddItem(44094)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+38) then
        player:AddItem(44095)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+39) then
        player:AddItem(44096)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+40) then
        player:AddItem(48716)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+41) then
        player:AddItem(48718)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+2, code)
    elseif (intid == Id.Heirlooms+42) then
        player:ModifyMoney(-10000000)
        player:AddItem(49177)
        AssistantOnGossipSelect(event, player, object, sender, Id.Heirlooms+3, code)
    elseif (intid == Id.Glyphs) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Talk, "I want some major glyphs", 1, Id.Glyphs+1)
        player:GossipMenuAddItem(Icon.Talk, "I want some minor glyphs", 1, Id.Glyphs+2)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Return)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Glyphs+1) then
        player:GossipClearMenu()

        if (player:GetClass() == Class.Warrior) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Bloodthirst", 1, Id.Glyphs+3)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Devastate", 1, Id.Glyphs+4)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Intervene", 1, Id.Glyphs+5)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Mortal Strike", 1, Id.Glyphs+6)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Bladestorm", 1, Id.Glyphs+7)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Shockwave", 1, Id.Glyphs+8)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Vigilance", 1, Id.Glyphs+9)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Enraged Regeneration", 1, Id.Glyphs+10)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Spell Reflection", 1, Id.Glyphs+11)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarrior:25:25:-19|tGlyph of Shield Wall", 1, Id.Glyphs+12)
        elseif (player:GetClass() == Class.Paladin) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Hammer of Wrath", 1, Id.Glyphs+13)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Avenging Wrath", 1, Id.Glyphs+14)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Avenger's Shield", 1, Id.Glyphs+15)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Holy Wrath", 1, Id.Glyphs+16)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Seal of Righteousness", 1, Id.Glyphs+17)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Seal of Vengeance", 1, Id.Glyphs+18)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Beacon of Light", 1, Id.Glyphs+19)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Hammer of the Righteous", 1, Id.Glyphs+20)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Divine Storm", 1, Id.Glyphs+21)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpaladin:25:25:-19|tGlyph of Shield of Righteousness", 1, Id.Glyphs+22)
        elseif (player:GetClass() == Class.Hunter) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Bestial Wrath", 1, Id.Glyphs+23)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Snake Trap", 1, Id.Glyphs+24)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Steady Shot", 1, Id.Glyphs+25)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Trueshot Aura", 1, Id.Glyphs+26)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Volley", 1, Id.Glyphs+27)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Wyvern Sting", 1, Id.Glyphs+28)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Chimera Shot", 1, Id.Glyphs+29)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Explosive Shot", 1, Id.Glyphs+30)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Kill Shot", 1, Id.Glyphs+31)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorhunter:25:25:-19|tGlyph of Explosive Trap", 1, Id.Glyphs+32)
        elseif (player:GetClass() == Class.Rogue) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Adrenaline Rush", 1, Id.Glyphs+33)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Deadly Throw", 1, Id.Glyphs+34)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Vigor", 1, Id.Glyphs+35)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Hunger for Blood", 1, Id.Glyphs+36)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Killing Spree", 1, Id.Glyphs+37)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Shadow Dance", 1, Id.Glyphs+38)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Fan of Knives", 1, Id.Glyphs+39)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Tricks of the Trade", 1, Id.Glyphs+40)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Mutilate", 1, Id.Glyphs+41)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorrogue:25:25:-19|tGlyph of Cloak of Shadows", 1, Id.Glyphs+42)
        elseif (player:GetClass() == Class.Priest) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Circle of Healing", 1, Id.Glyphs+43)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Lightwell", 1, Id.Glyphs+44)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Mass Dispel", 1, Id.Glyphs+45)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Shadow Word: Death", 1, Id.Glyphs+46)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Dispersion", 1, Id.Glyphs+47)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Guardian Spirit", 1, Id.Glyphs+48)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Penance", 1, Id.Glyphs+49)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Mind Sear", 1, Id.Glyphs+50)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Hymn of Hope", 1, Id.Glyphs+51)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorpriest:25:25:-19|tGlyph of Pain Suppression", 1, Id.Glyphs+52)
        elseif (player:GetClass() == Class.DeathKnight) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Anti-Magic Shell", 1, Id.Glyphs+53)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Heart Strike", 1, Id.Glyphs+54)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Bone Shield", 1, Id.Glyphs+55)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Chains of Ice", 1, Id.Glyphs+56)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Dark Command", 1, Id.Glyphs+57)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Death Grip", 1, Id.Glyphs+58)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Death and Decay", 1, Id.Glyphs+59)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Frost Strike", 1, Id.Glyphs+60)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Icebound Fortitude", 1, Id.Glyphs+61)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordeathknight:25:25:-19|tGlyph of Icy Touch", 1, Id.Glyphs+62)
        elseif (player:GetClass() == Class.Shaman) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Chain Heal", 1, Id.Glyphs+63)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Lava", 1, Id.Glyphs+64)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Fire Elemental Totem", 1, Id.Glyphs+65)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Mana Tide Totem", 1, Id.Glyphs+66)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Stormstrike", 1, Id.Glyphs+67)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Elemental Mastery", 1, Id.Glyphs+68)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Thunder", 1, Id.Glyphs+69)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Feral Spirit", 1, Id.Glyphs+70)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Riptide", 1, Id.Glyphs+71)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorshaman:25:25:-19|tGlyph of Earth Shield", 1, Id.Glyphs+72)
        elseif (player:GetClass() == Class.Mage) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Arcane Power", 1, Id.Glyphs+73)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Deep Freeze", 1, Id.Glyphs+74)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Living Bomb", 1, Id.Glyphs+75)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Invisibility", 1, Id.Glyphs+76)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Ice Lance", 1, Id.Glyphs+77)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Molten Armor", 1, Id.Glyphs+78)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Water Elemental", 1, Id.Glyphs+79)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Frostfire", 1, Id.Glyphs+80)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Arcane Blast", 1, Id.Glyphs+81)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majormage:25:25:-19|tGlyph of Eternal Water", 1, Id.Glyphs+82)
        elseif (player:GetClass() == Class.Warlock) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Conflagrate", 1, Id.Glyphs+83)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Death Coil", 1, Id.Glyphs+84)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Felguard", 1, Id.Glyphs+85)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Howl of Terror", 1, Id.Glyphs+86)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Unstable Affliction", 1, Id.Glyphs+87)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Haunt", 1, Id.Glyphs+88)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Metamorphosis", 1, Id.Glyphs+89)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Chaos Bolt", 1, Id.Glyphs+90)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Demonic Circle", 1, Id.Glyphs+91)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majorwarlock:25:25:-19|tGlyph of Shadowflame", 1, Id.Glyphs+92)
        elseif (player:GetClass() == Class.Druid) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Mangle", 1, Id.Glyphs+93)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Swiftmend", 1, Id.Glyphs+94)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Innervate", 1, Id.Glyphs+95)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Lifebloom", 1, Id.Glyphs+96)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Hurricane", 1, Id.Glyphs+97)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Starfall", 1, Id.Glyphs+98)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Focus", 1, Id.Glyphs+99)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Berserk", 1, Id.Glyphs+100)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Wild Growth", 1, Id.Glyphs+101)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_majordruid:25:25:-19|tGlyph of Nourish", 1, Id.Glyphs+102)
        end

        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Glyphs)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Glyphs+2) then
        player:GossipClearMenu()

        if (player:GetClass() == Class.Warrior) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Battle", 1, Id.Glyphs+103)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Bloodrage", 1, Id.Glyphs+104)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Charge", 1, Id.Glyphs+105)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Mocking Blow", 1, Id.Glyphs+106)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Thunder Clap", 1, Id.Glyphs+107)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Enduring Victory", 1, Id.Glyphs+108)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarrior:25:25:-19|tGlyph of Command", 1, Id.Glyphs+109)
        elseif (player:GetClass() == Class.Paladin) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of Blessing of Might", 1, Id.Glyphs+110)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of Blessing of Kings", 1, Id.Glyphs+111)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of Blessing of Wisdom", 1, Id.Glyphs+112)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of Lay on Hands", 1, Id.Glyphs+113)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of Sense Undead", 1, Id.Glyphs+114)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpaladin:25:25:-19|tGlyph of the Wise", 1, Id.Glyphs+115)
        elseif (player:GetClass() == Class.Hunter) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of Revive Pet", 1, Id.Glyphs+116)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of Mend Pet", 1, Id.Glyphs+117)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of Feign Death", 1, Id.Glyphs+118)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of Possessed Strength", 1, Id.Glyphs+119)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of the Pack", 1, Id.Glyphs+120)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorhunter:25:25:-19|tGlyph of Scare Beast", 1, Id.Glyphs+121)
        elseif (player:GetClass() == Class.Rogue) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Pick Pocket", 1, Id.Glyphs+122)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Distract", 1, Id.Glyphs+123)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Pick Lock", 1, Id.Glyphs+124)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Safe Fall", 1, Id.Glyphs+125)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Blurred Speed", 1, Id.Glyphs+126)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorrogue:25:25:-19|tGlyph of Vanish", 1, Id.Glyphs+127)
        elseif (player:GetClass() == Class.Priest) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Fading", 1, Id.Glyphs+128)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Levitate", 1, Id.Glyphs+129)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Fortitude", 1, Id.Glyphs+130)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Shadow Protection", 1, Id.Glyphs+131)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Shackle Undead", 1, Id.Glyphs+132)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorpriest:25:25:-19|tGlyph of Shadowfiend", 1, Id.Glyphs+133)
        elseif (player:GetClass() == Class.DeathKnight) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Blood Tap", 1, Id.Glyphs+134)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Death's Embrace", 1, Id.Glyphs+135)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Horn of Winter", 1, Id.Glyphs+136)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Corpse Explosion", 1, Id.Glyphs+137)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Pestilence", 1, Id.Glyphs+138)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordeathknight:25:25:-19|tGlyph of Raise Dead", 1, Id.Glyphs+139)
        elseif (player:GetClass() == Class.Shaman) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Thunderstorm", 1, Id.Glyphs+140)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Water Breathing", 1, Id.Glyphs+141)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Astral Recall", 1, Id.Glyphs+142)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Renewed Life", 1, Id.Glyphs+143)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Water Shield", 1, Id.Glyphs+144)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Water Walking", 1, Id.Glyphs+145)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorshaman:25:25:-19|tGlyph of Ghost Wolf", 1, Id.Glyphs+146)
        elseif (player:GetClass() == Class.Mage) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Arcane Intellect", 1, Id.Glyphs+147)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Fire Ward", 1, Id.Glyphs+148)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Frost Armor", 1, Id.Glyphs+149)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Frost Ward", 1, Id.Glyphs+150)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of the Penguin", 1, Id.Glyphs+151)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of the Bear Cub", 1, Id.Glyphs+152)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Slow Fall", 1, Id.Glyphs+153)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minormage:25:25:-19|tGlyph of Blast Wave", 1, Id.Glyphs+154)
        elseif (player:GetClass() == Class.Warlock) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Unending Breath", 1, Id.Glyphs+155)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Drain Soul", 1, Id.Glyphs+156)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Kilrogg", 1, Id.Glyphs+157)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Curse of Exhaustion", 1, Id.Glyphs+158)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Enslave Demon", 1, Id.Glyphs+159)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minorwarlock:25:25:-19|tGlyph of Souls", 1, Id.Glyphs+160)
        elseif (player:GetClass() == Class.Druid) then
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Aquatic Form", 1, Id.Glyphs+161)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Unburdened Rebirth", 1, Id.Glyphs+162)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Thorns", 1, Id.Glyphs+163)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Challenging Roar", 1, Id.Glyphs+164)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of the Wild", 1, Id.Glyphs+165)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Dash", 1, Id.Glyphs+166)
            player:GossipMenuAddItem(Icon.Vendor, "|TInterface\\icons\\inv_glyph_minordruid:25:25:-19|tGlyph of Typhoon", 1, Id.Glyphs+167)
        end

        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Glyphs)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Glyphs+3) then
        player:AddItem(43412)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+4) then
        player:AddItem(43415)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+5) then
        player:AddItem(43419)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+6) then
        player:AddItem(43421)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+7) then
        player:AddItem(45790)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+8) then
        player:AddItem(45792)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+9) then
        player:AddItem(45793)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+10) then
        player:AddItem(45794)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+11) then
        player:AddItem(45795)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+12) then
        player:AddItem(45797)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+13) then
        player:AddItem(41097)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+14) then
        player:AddItem(41107)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+15) then
        player:AddItem(41101)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+16) then
        player:AddItem(43867)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+17) then
        player:AddItem(43868)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+18) then
        player:AddItem(43869)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+19) then
        player:AddItem(45741)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+20) then
        player:AddItem(45742)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+21) then
        player:AddItem(45743)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+22) then
        player:AddItem(45744)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+23) then
        player:AddItem(43412)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+24) then
        player:AddItem(42913)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+25) then
        player:AddItem(42914)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+26) then
        player:AddItem(42915)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+27) then
        player:AddItem(42916)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+28) then
        player:AddItem(42917)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+29) then
        player:AddItem(45625)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+30) then
        player:AddItem(45731)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+31) then
        player:AddItem(45732)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+32) then
        player:AddItem(45733)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+33) then
        player:AddItem(42954)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+34) then
        player:AddItem(42959)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+35) then
        player:AddItem(42971)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+36) then
        player:AddItem(45761)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+37) then
        player:AddItem(45762)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+38) then
        player:AddItem(45764)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+39) then
        player:AddItem(45766)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+40) then
        player:AddItem(45767)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+41) then
        player:AddItem(45768)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+42) then
        player:AddItem(45769)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+43) then
        player:AddItem(42396)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+44) then
        player:AddItem(42403)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+45) then
        player:AddItem(42404)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+46) then
        player:AddItem(42414)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+47) then
        player:AddItem(45753)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+48) then
        player:AddItem(45755)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+49) then
        player:AddItem(45756)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+50) then
        player:AddItem(45757)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+51) then
        player:AddItem(45758)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+52) then
        player:AddItem(45760)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+53) then
        player:AddItem(43533)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+54) then
        player:AddItem(43534)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+55) then
        player:AddItem(43536)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+56) then
        player:AddItem(43537)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+57) then
        player:AddItem(43538)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+58) then
        player:AddItem(43541)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+59) then
        player:AddItem(43542)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+60) then
        player:AddItem(43543)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+61) then
        player:AddItem(43545)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+62) then
        player:AddItem(43546)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+63) then
        player:AddItem(41517)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+64) then
        player:AddItem(41524)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+65) then
        player:AddItem(41529)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+66) then
        player:AddItem(41538)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+67) then
        player:AddItem(41539)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+68) then
        player:AddItem(41552)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+69) then
        player:AddItem(45770)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+70) then
        player:AddItem(45771)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+71) then
        player:AddItem(45772)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+72) then
        player:AddItem(45775)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+73) then
        player:AddItem(42736)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+74) then
        player:AddItem(45736)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+75) then
        player:AddItem(45737)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+76) then
        player:AddItem(42748)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+77) then
        player:AddItem(42745)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+78) then
        player:AddItem(42751)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+79) then
        player:AddItem(42754)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+80) then
        player:AddItem(44684)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+81) then
        player:AddItem(44955)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+82) then
        player:AddItem(50045)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+83) then
        player:AddItem(42454)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+84) then
        player:AddItem(42457)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+85) then
        player:AddItem(42459)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+86) then
        player:AddItem(42463)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+87) then
        player:AddItem(42472)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+88) then
        player:AddItem(45779)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+89) then
        player:AddItem(45780)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+90) then
        player:AddItem(45781)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+91) then
        player:AddItem(45782)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+92) then
        player:AddItem(45783)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+93) then
        player:AddItem(40900)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+94) then
        player:AddItem(40906)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+95) then
        player:AddItem(40908)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+96) then
        player:AddItem(40915)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+97) then
        player:AddItem(40920)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+98) then
        player:AddItem(40921)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+99) then
        player:AddItem(44928)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+100) then
        player:AddItem(45601)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+101) then
        player:AddItem(45602)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+102) then
        player:AddItem(45603)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+1, code)
    elseif (intid == Id.Glyphs+103) then
        player:AddItem(43395)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+104) then
        player:AddItem(43396)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+105) then
        player:AddItem(43397)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+106) then
        player:AddItem(43398)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+107) then
        player:AddItem(43399)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+108) then
        player:AddItem(43400)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+109) then
        player:AddItem(49084)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+110) then
        player:AddItem(43340)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+111) then
        player:AddItem(43365)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+112) then
        player:AddItem(43366)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+113) then
        player:AddItem(43367)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+114) then
        player:AddItem(43368)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+115) then
        player:AddItem(43369)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+116) then
        player:AddItem(43338)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+117) then
        player:AddItem(43350)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+118) then
        player:AddItem(43351)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+119) then
        player:AddItem(43354)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+120) then
        player:AddItem(43355)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+121) then
        player:AddItem(43356)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+122) then
        player:AddItem(43343)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+123) then
        player:AddItem(43376)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+124) then
        player:AddItem(43377)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+125) then
        player:AddItem(43378)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+126) then
        player:AddItem(43379)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+127) then
        player:AddItem(43380)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+128) then
        player:AddItem(43342)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+129) then
        player:AddItem(43370)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+130) then
        player:AddItem(43371)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+131) then
        player:AddItem(43372)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+132) then
        player:AddItem(43373)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+133) then
        player:AddItem(43374)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+134) then
        player:AddItem(43535)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+135) then
        player:AddItem(43539)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+136) then
        player:AddItem(43544)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+137) then
        player:AddItem(43671)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+138) then
        player:AddItem(43672)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+139) then
        player:AddItem(43673)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+140) then
        player:AddItem(44923)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+141) then
        player:AddItem(43344)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+142) then
        player:AddItem(43381)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+143) then
        player:AddItem(43385)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+144) then
        player:AddItem(43386)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+145) then
        player:AddItem(43388)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+146) then
        player:AddItem(43725)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+147) then
        player:AddItem(43339)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+148) then
        player:AddItem(43357)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+149) then
        player:AddItem(43359)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+150) then
        player:AddItem(43360)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+151) then
        player:AddItem(43361)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+152) then
        player:AddItem(43362)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+153) then
        player:AddItem(43364)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+154) then
        player:AddItem(44920)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+155) then
        player:AddItem(43389)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+156) then
        player:AddItem(43390)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+157) then
        player:AddItem(43391)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+158) then
        player:AddItem(43392)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+159) then
        player:AddItem(43393)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+160) then
        player:AddItem(43394)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+161) then
        player:AddItem(43316)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+162) then
        player:AddItem(43331)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+163) then
        player:AddItem(43332)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+164) then
        player:AddItem(43334)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+165) then
        player:AddItem(43335)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+166) then
        player:AddItem(43674)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Glyphs+167) then
        player:AddItem(44922)
        AssistantOnGossipSelect(event, player, object, sender, Id.Glyphs+2, code)
    elseif (intid == Id.Gems) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Talk, "I want some meta gems", 1, Id.Gems+1)
        player:GossipMenuAddItem(Icon.Talk, "I want some red gems", 1, Id.Gems+40)
        player:GossipMenuAddItem(Icon.Talk, "I want some blue gems", 1, Id.Gems+49)
        player:GossipMenuAddItem(Icon.Talk, "I want some yellow gems", 1, Id.Gems+54)
        player:GossipMenuAddItem(Icon.Talk, "I want some purple gems", 1, Id.Gems+61)
        player:GossipMenuAddItem(Icon.Talk, "I want some green gems", 1, Id.Gems+76)
        player:GossipMenuAddItem(Icon.Talk, "I want some orange gems", 1, Id.Gems+97)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Return)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+1) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|t+14 Crit Rating, 1% Spell Reflect (2 R, 2 B, 2 Y)", 1, Id.Gems+5)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|tChance to Increase Spell Cast Speed (B > Y)", 1, Id.Gems+6)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|t+24 Attack Power, Minor Run Speed (2 Y, 1 R)", 1, Id.Gems+7)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|t+12 Crit Rating, -1% Snare/Root Duration (R > Y)", 1, Id.Gems+8)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+18 Stamina, -15% Stun Duration (3 B)", 1, Id.Gems+9)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+14 Spell Power, +2% Reduced Threat (R > B)", 1, Id.Gems+10)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+12 Defense, Chance to Restore Health (5 B)", 1, Id.Gems+11)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+3 Attack Dmg, Chance to Stun (2 R, 2 Y, 2 B)", 1, Id.Gems+12)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+12 Intellect, Chance to Restore Mana (2 R, 2 Y, 2 B)", 1, Id.Gems+13)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+12 Agility, +3% Crit Damage (2 R, 2 Y, 2 B)", 1, Id.Gems+14)
        player:GossipMenuAddItem(Icon.Chat, "Proceed to the next page", 1, Id.Gems+2)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+2) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|tChance to Increase Attack Speed (2 R, 2 B, 2 Y)", 1, Id.Gems+15)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|t+12 Crit Rating, +3% Crit Damage (2 B)", 1, Id.Gems+16)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_06:25:25:-19|t+12 Defense, +5% Block Value (2 B, 1 Y)", 1, Id.Gems+17)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_misc_gem_diamond_07:25:25:-19|t+14 Spell Power, +2% Intellect (3 R)", 1, Id.Gems+18)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+21 Crit Rating, +3% Crit Damage (2 B)", 1, Id.Gems+19)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+25 Crit Rating, +1% Spell Reflect (1 R, 1 Y, 1 B)", 1, Id.Gems+20)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+25 Spell Power, +2% Intellect (3 R)", 1, Id.Gems+21)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+21 Crit Rating, Reduced Snare/Root 10% (2 R, 1 Y)", 1, Id.Gems+22)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+42 Attack Power, Minor Run Speed (2 Y, 1 R)", 1, Id.Gems+23)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+25 Spell Power, Minor Run Speed (1 R, 1 B, 1 Y)", 1, Id.Gems+24)
        player:GossipMenuAddItem(Icon.Chat, "Proceed to the next page", 1, Id.Gems+3)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems+1)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+3) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+11 Mana 5 Seconds, 3% Crit Healing (2 R)", 1, Id.Gems+25)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+32 Stamina, -2% Spell Damage Taken (2 B, 1 R)", 1, Id.Gems+26)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+25 Spell Power, -10% Silence Duration (2 Y, 1 B)", 1, Id.Gems+27)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_icediamond_02:25:25:-19|t+21 Crit Rating, -10% Fear Duration", 1, Id.Gems+28)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+32 Stamina, +2% Increase Armor (2 B, 1 R)", 1, Id.Gems+29)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+42 Attack Power, -10% Stun Duration (2 Y, 1 B)", 1, Id.Gems+30)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+25 Spell Power, -10% Stun Duration (1 R, 1 Y, 1 B)", 1, Id.Gems+31)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+42 Attack Power, Sometimes Heal on Crit (2 B, 1 R)", 1, Id.Gems+32)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+21 Crit Rating, +2% Mana (2 R, 1 Y)", 1, Id.Gems+33)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+25 Spell Power, -2% Threat (2 R, 1 B)", 1, Id.Gems+34)
        player:GossipMenuAddItem(Icon.Chat, "Proceed to the next page", 1, Id.Gems+4)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems+2)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+4) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+21 Defense Rating, +5% Block Value (2 R, 1 B)", 1, Id.Gems+35)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+32 Stamina, -10% Stun Duration (3 B)", 1, Id.Gems+36)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+21 Agility, +3% Crit Damage (1 R, 1 Y, 1 B)", 1, Id.Gems+37)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|tChance to Increase Attack Speed (1 R, 1 Y, 1 B)", 1, Id.Gems+38)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_shadowspirit_02:25:25:-19|t+21 Intellect, Chance to Restore Mana (1 R, 1 Y, 1 B)", 1, Id.Gems+39)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems+3)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+5) then
        player:AddItem(25890)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+1, code)
    elseif (intid == Id.Gems+6) then
        player:AddItem(25893)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+1, code)
    elseif (intid == Id.Gems+7) then
        player:AddItem(25894)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+1, code)
    elseif (intid == Id.Gems+8) then
        player:AddItem(25895)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+1, code)
    elseif (intid == Id.Gems+9) then
        player:AddItem(25896)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+1, code)
    elseif (intid == Id.Gems+10) then
        player:AddItem(25897)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+1, code)
    elseif (intid == Id.Gems+11) then
        player:AddItem(25898)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+1, code)
    elseif (intid == Id.Gems+12) then
        player:AddItem(25899)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+1, code)
    elseif (intid == Id.Gems+13) then
        player:AddItem(25901)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+1, code)
    elseif (intid == Id.Gems+14) then
        player:AddItem(32409)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+1, code)
    elseif (intid == Id.Gems+15) then
        player:AddItem(32410)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+2, code)
    elseif (intid == Id.Gems+16) then
        player:AddItem(34220)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+2, code)
    elseif (intid == Id.Gems+17) then
        player:AddItem(35501)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+2, code)
    elseif (intid == Id.Gems+18) then
        player:AddItem(35503)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+2, code)
    elseif (intid == Id.Gems+19) then
        player:AddItem(41285)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+2, code)
    elseif (intid == Id.Gems+20) then
        player:AddItem(41307)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+2, code)
    elseif (intid == Id.Gems+21) then
        player:AddItem(41333)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+2, code)
    elseif (intid == Id.Gems+22) then
        player:AddItem(41335)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+2, code)
    elseif (intid == Id.Gems+23) then
        player:AddItem(41339)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+2, code)
    elseif (intid == Id.Gems+24) then
        player:AddItem(41375)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+2, code)
    elseif (intid == Id.Gems+25) then
        player:AddItem(41376)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+3, code)
    elseif (intid == Id.Gems+26) then
        player:AddItem(41377)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+3, code)
    elseif (intid == Id.Gems+27) then
        player:AddItem(41378)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+3, code)
    elseif (intid == Id.Gems+28) then
        player:AddItem(41379)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+3, code)
    elseif (intid == Id.Gems+29) then
        player:AddItem(41380)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+3, code)
    elseif (intid == Id.Gems+30) then
        player:AddItem(41381)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+3, code)
    elseif (intid == Id.Gems+31) then
        player:AddItem(41382)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+3, code)
    elseif (intid == Id.Gems+32) then
        player:AddItem(41385)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+3, code)
    elseif (intid == Id.Gems+33) then
        player:AddItem(41389)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+3, code)
    elseif (intid == Id.Gems+34) then
        player:AddItem(41395)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+3, code)
    elseif (intid == Id.Gems+35) then
        player:AddItem(41396)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+4, code)
    elseif (intid == Id.Gems+36) then
        player:AddItem(41397)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+4, code)
    elseif (intid == Id.Gems+37) then
        player:AddItem(41398)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+4, code)
    elseif (intid == Id.Gems+38) then
        player:AddItem(41400)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+4, code)
    elseif (intid == Id.Gems+39) then
        player:AddItem(41401)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+4, code)
    elseif (intid == Id.Gems+40) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Strength", 1, Id.Gems+41)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Agility", 1, Id.Gems+42)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+23 Spell Power", 1, Id.Gems+43)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+40 Attack Power", 1, Id.Gems+44)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Dodge Rating", 1, Id.Gems+45)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Parry Rating", 1, Id.Gems+46)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Armor Penetration Rating", 1, Id.Gems+47)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_37:25:25:-19|t+20 Expertise Rating", 1, Id.Gems+48)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+41) then
        player:AddItem(40111)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+40, code)
    elseif (intid == Id.Gems+42) then
        player:AddItem(40112)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+40, code)
    elseif (intid == Id.Gems+43) then
        player:AddItem(40113)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+40, code)
    elseif (intid == Id.Gems+44) then
        player:AddItem(40114)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+40, code)
    elseif (intid == Id.Gems+45) then
        player:AddItem(40115)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+40, code)
    elseif (intid == Id.Gems+46) then
        player:AddItem(40116)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+40, code)
    elseif (intid == Id.Gems+47) then
        player:AddItem(40117)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+40, code)
    elseif (intid == Id.Gems+48) then
        player:AddItem(40118)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+40, code)
    elseif (intid == Id.Gems+49) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_42:25:25:-19|t+30 Stamina", 1, Id.Gems+50)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_42:25:25:-19|t+20 Spirit", 1, Id.Gems+51)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_42:25:25:-19|t+10 Mana Every 5 Seconds", 1, Id.Gems+52)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_42:25:25:-19|t+25 Spell Penetration", 1, Id.Gems+53)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+50) then
        player:AddItem(40119)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+49, code)
    elseif (intid == Id.Gems+51) then
        player:AddItem(40120)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+49, code)
    elseif (intid == Id.Gems+52) then
        player:AddItem(40121)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+49, code)
    elseif (intid == Id.Gems+53) then
        player:AddItem(40122)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+49, code)
    elseif (intid == Id.Gems+54) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Intellect", 1, Id.Gems+55)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Critical Strike Rating", 1, Id.Gems+56)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Hit Rating", 1, Id.Gems+57)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Defense Rating", 1, Id.Gems+58)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Resilience Rating", 1, Id.Gems+59)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_38:25:25:-19|t+20 Haste Rating", 1, Id.Gems+60)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+55) then
        player:AddItem(40123)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+54, code)
    elseif (intid == Id.Gems+56) then
        player:AddItem(40124)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+54, code)
    elseif (intid == Id.Gems+57) then
        player:AddItem(40125)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+54, code)
    elseif (intid == Id.Gems+58) then
        player:AddItem(40126)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+54, code)
    elseif (intid == Id.Gems+59) then
        player:AddItem(40127)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+54, code)
    elseif (intid == Id.Gems+60) then
        player:AddItem(40128)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+54, code)
    elseif (intid == Id.Gems+61) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Strength, +15 Stamina", 1, Id.Gems+63)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Agility, +15 Stamina", 1, Id.Gems+64)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Agility, +5 Mana Every 5 Seconds", 1, Id.Gems+65)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+12 Spell Power, +15 Stamina", 1, Id.Gems+66)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+12 Spell Power, +10 Spirit", 1, Id.Gems+67)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+12 Spell Power, +5 Mana Every 5 Seconds", 1, Id.Gems+68)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+12 Spell Power, +13 Spell Penetration", 1, Id.Gems+69)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+20 Attack Power, +15 Stamina", 1, Id.Gems+70)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+20 Attack Power, +5 Mana Every 5 Seconds", 1, Id.Gems+71)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Dodge Rating, +15 Stamina", 1, Id.Gems+72)
        player:GossipMenuAddItem(Icon.Chat, "Proceed to the next page", 1, Id.Gems+62)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+62) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Parry Rating, +15 Stamina", 1, Id.Gems+73)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Armor Penetration Rating, +15 Stamina", 1, Id.Gems+74)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_40:25:25:-19|t+10 Expertise Rating, +15 Stamina", 1, Id.Gems+75)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems+61)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+63) then
        player:AddItem(40129)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+61, code)
    elseif (intid == Id.Gems+64) then
        player:AddItem(40130)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+61, code)
    elseif (intid == Id.Gems+65) then
        player:AddItem(40131)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+61, code)
    elseif (intid == Id.Gems+66) then
        player:AddItem(40132)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+61, code)
    elseif (intid == Id.Gems+67) then
        player:AddItem(40133)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+61, code)
    elseif (intid == Id.Gems+68) then
        player:AddItem(40134)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+61, code)
    elseif (intid == Id.Gems+69) then
        player:AddItem(40135)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+61, code)
    elseif (intid == Id.Gems+70) then
        player:AddItem(40136)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+61, code)
    elseif (intid == Id.Gems+71) then
        player:AddItem(40137)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+61, code)
    elseif (intid == Id.Gems+72) then
        player:AddItem(40138)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+61, code)
    elseif (intid == Id.Gems+73) then
        player:AddItem(40139)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+62, code)
    elseif (intid == Id.Gems+74) then
        player:AddItem(40140)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+62, code)
    elseif (intid == Id.Gems+75) then
        player:AddItem(40141)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+62, code)
    elseif (intid == Id.Gems+76) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Intellect, +15 Stamina", 1, Id.Gems+78)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Critical Strike Rating, +15 Stamina", 1, Id.Gems+79)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Hit Rating, +15 Stamina", 1, Id.Gems+80)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Defense Rating, +15 Stamina", 1, Id.Gems+81)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Resilience Rating, +15 Stamina", 1, Id.Gems+82)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Haste Rating, +15 Stamina", 1, Id.Gems+83)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Intellect, +10 Spirit", 1, Id.Gems+84)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Critical Strike Rating, +10 Spirit", 1, Id.Gems+85)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Hit Rating, +10 Spirit", 1, Id.Gems+86)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Resilience Rating, +10 Spirit", 1, Id.Gems+87)
        player:GossipMenuAddItem(Icon.Chat, "Proceed to the next page", 1, Id.Gems+77)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+77) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Haste Rating, +10 Spirit", 1, Id.Gems+88)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Intellect, +5 Mana Every 5 Seconds", 1, Id.Gems+89)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Critical Strike Rating, +5 Mana Every 5 Seconds", 1, Id.Gems+90)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Hit rating, +5 Mana Every 5 Seconds", 1, Id.Gems+91)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Resilience Rating, +5 Mana Every 5 Seconds", 1, Id.Gems+92)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Haste Rating, +5 Mana Every 5 Seconds", 1, Id.Gems+93)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Critical Strike Rating, +13 Spell Penetration", 1, Id.Gems+94)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Hit Rating, +13 Spell Penetration", 1, Id.Gems+95)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_41:25:25:-19|t+10 Haste Rating, +13 Spell Penetration", 1, Id.Gems+96)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems+76)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+78) then
        player:AddItem(40164)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+76, code)
    elseif (intid == Id.Gems+79) then
        player:AddItem(40165)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+76, code)
    elseif (intid == Id.Gems+80) then
        player:AddItem(40166)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+76, code)
    elseif (intid == Id.Gems+81) then
        player:AddItem(40167)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+76, code)
    elseif (intid == Id.Gems+82) then
        player:AddItem(40168)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+76, code)
    elseif (intid == Id.Gems+83) then
        player:AddItem(40169)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+76, code)
    elseif (intid == Id.Gems+84) then
        player:AddItem(40170)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+76, code)
    elseif (intid == Id.Gems+85) then
        player:AddItem(40171)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+76, code)
    elseif (intid == Id.Gems+86) then
        player:AddItem(40172)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+76, code)
    elseif (intid == Id.Gems+87) then
        player:AddItem(40173)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+76, code)
    elseif (intid == Id.Gems+88) then
        player:AddItem(40174)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+77, code)
    elseif (intid == Id.Gems+89) then
        player:AddItem(40175)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+77, code)
    elseif (intid == Id.Gems+90) then
        player:AddItem(40176)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+77, code)
    elseif (intid == Id.Gems+91) then
        player:AddItem(40177)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+77, code)
    elseif (intid == Id.Gems+92) then
        player:AddItem(40178)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+77, code)
    elseif (intid == Id.Gems+93) then
        player:AddItem(40179)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+77, code)
    elseif (intid == Id.Gems+94) then
        player:AddItem(40180)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+77, code)
    elseif (intid == Id.Gems+95) then
        player:AddItem(40181)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+77, code)
    elseif (intid == Id.Gems+96) then
        player:AddItem(40182)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+77, code)
    elseif (intid == Id.Gems+97) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Strength, +10 Critical Strike Rating", 1, Id.Gems+100)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Strength, +10 Hit Rating", 1, Id.Gems+101)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Strength, +10 Defense Rating", 1, Id.Gems+102)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Strength, 10 Resilience Rating", 1, Id.Gems+103)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Strength, +10 Haste Rating", 1, Id.Gems+104)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Agility, +10 Critical Strike Rating", 1, Id.Gems+105)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Agility, +10 Hit Rating", 1, Id.Gems+106)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Agility, +10 Resilience Rating", 1, Id.Gems+107)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Agility, +10 Haste Rating", 1, Id.Gems+108)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+12 Spell Power, +10 Intellect", 1, Id.Gems+109)
        player:GossipMenuAddItem(Icon.Chat, "Proceed to the next page", 1, Id.Gems+98)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+98) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+12 Spell Power, +10 Critical Strike Rating", 1, Id.Gems+110)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+12 Spell Power, +10 Hit Rating", 1, Id.Gems+111)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+12 Spell Power, +10 Resilience Rating", 1, Id.Gems+112)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+12 Spell Power, +10 Haste Rating", 1, Id.Gems+113)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+20 Attack Power, +10 Critical Strike Rating", 1, Id.Gems+114)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+20 Attack Power, +10 Hit Rating", 1, Id.Gems+115)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+20 Attack Power, +10 Resilience Rating", 1, Id.Gems+116)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+20 Attack Power, +10 Haste Rating", 1, Id.Gems+117)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Dodge Rating, +10 Defense Rating", 1, Id.Gems+118)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Parry Rating, +10 Defense Rating", 1, Id.Gems+119)
        player:GossipMenuAddItem(Icon.Chat, "Proceed to the next page", 1, Id.Gems+99)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems+97)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+99) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Expertise Rating, +10 Hit Rating", 1, Id.Gems+120)
        player:GossipMenuAddItem(Icon.Chat, "|TInterface\\icons\\inv_jewelcrafting_gem_39:25:25:-19|t+10 Expertise Rating, +10 Defense Rating", 1, Id.Gems+121)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Gems+98)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+100) then
        player:AddItem(40142)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+97, code)
    elseif (intid == Id.Gems+101) then
        player:AddItem(40143)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+97, code)
    elseif (intid == Id.Gems+102) then
        player:AddItem(40144)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+97, code)
    elseif (intid == Id.Gems+103) then
        player:AddItem(40145)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+97, code)
    elseif (intid == Id.Gems+104) then
        player:AddItem(40146)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+97, code)
    elseif (intid == Id.Gems+105) then
        player:AddItem(40147)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+97, code)
    elseif (intid == Id.Gems+106) then
        player:AddItem(40148)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+97, code)
    elseif (intid == Id.Gems+107) then
        player:AddItem(40149)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+97, code)
    elseif (intid == Id.Gems+108) then
        player:AddItem(40150)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+97, code)
    elseif (intid == Id.Gems+109) then
        player:AddItem(40151)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+97, code)
    elseif (intid == Id.Gems+110) then
        player:AddItem(40152)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+98, code)
    elseif (intid == Id.Gems+111) then
        player:AddItem(40153)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+98, code)
    elseif (intid == Id.Gems+112) then
        player:AddItem(40154)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+98, code)
    elseif (intid == Id.Gems+113) then
        player:AddItem(40155)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+98, code)
    elseif (intid == Id.Gems+114) then
        player:AddItem(40156)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+98, code)
    elseif (intid == Id.Gems+115) then
        player:AddItem(40157)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+98, code)
    elseif (intid == Id.Gems+116) then
        player:AddItem(40158)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+98, code)
    elseif (intid == Id.Gems+117) then
        player:AddItem(40159)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+98, code)
    elseif (intid == Id.Gems+118) then
        player:AddItem(40160)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+98, code)
    elseif (intid == Id.Gems+119) then
        player:AddItem(40161)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+98, code)
    elseif (intid == Id.Gems+120) then
        player:AddItem(40162)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+99, code)
    elseif (intid == Id.Gems+121) then
        player:AddItem(40163)
        AssistantOnGossipSelect(event, player, object, sender, Id.Gems+99, code)
    elseif (intid == Id.Utilities) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.MoneyBag, "I want to change my name", 1, Id.Utilities+1, false, "Do you wish to continue the transaction?", (Config.NameChangeCost * 10000))
        player:GossipMenuAddItem(Icon.MoneyBag, "I want to change my appearance", 1, Id.Utilities+2, false, "Do you wish to continue the transaction?", (Config.CustomizeCost * 10000))
        player:GossipMenuAddItem(Icon.MoneyBag, "I want to change my race", 1, Id.Utilities+3, false, "Do you wish to continue the transaction?", (Config.RaceChangeCost * 10000))
        player:GossipMenuAddItem(Icon.MoneyBag, "I want to change my faction", 1, Id.Utilities+4, false, "Do you wish to continue the transaction?", (Config.FactionChangeCost * 10000))
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Return)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Utilities+1) then
        if (player:HasAtLoginFlag(Flag.Rename) or player:HasAtLoginFlag(Flag.Customize) or player:HasAtLoginFlag(Flag.ChangeRace) or player:HasAtLoginFlag(Flag.ChangeFaction)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            AssistantOnGossipSelect(event, player, object, sender, Id.Utilities, code)
        else
            player:ModifyMoney(-(Config.NameChangeCost * 10000))
            player:SetAtLoginFlag(Flag.Rename)
            player:SendBroadcastMessage("You can now log out to apply the name change.")
            player:GossipComplete()
        end
    elseif (intid == Id.Utilities+2) then
        if (player:HasAtLoginFlag(Flag.Rename) or player:HasAtLoginFlag(Flag.Customize) or player:HasAtLoginFlag(Flag.ChangeRace) or player:HasAtLoginFlag(Flag.ChangeFaction)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            AssistantOnGossipSelect(event, player, object, sender, Id.Utilities, code)
        else
            player:ModifyMoney(-(Config.CustomizeCost * 10000))
            player:SetAtLoginFlag(Flag.Customize)
            player:SendBroadcastMessage("You can now log out to apply the customization.")
            player:GossipComplete()
        end
    elseif (intid == Id.Utilities+3) then
        if (player:HasAtLoginFlag(Flag.Rename) or player:HasAtLoginFlag(Flag.Customize) or player:HasAtLoginFlag(Flag.ChangeRace) or player:HasAtLoginFlag(Flag.ChangeFaction)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            AssistantOnGossipSelect(event, player, object, sender, Id.Utilities, code)
        else
            player:ModifyMoney(-(Config.RaceChangeCost * 10000))
            player:SetAtLoginFlag(Flag.ChangeRace)
            player:SendBroadcastMessage("You can now log out to apply the race change.")
            player:GossipComplete()
        end
    elseif (intid == Id.Utilities+4) then
        if (player:HasAtLoginFlag(Flag.Rename) or player:HasAtLoginFlag(Flag.Customize) or player:HasAtLoginFlag(Flag.ChangeRace) or player:HasAtLoginFlag(Flag.ChangeFaction)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            AssistantOnGossipSelect(event, player, object, sender, Id.Utilities, code)
        else
            player:ModifyMoney(-(Config.FactionChangeCost * 10000))
            player:SetAtLoginFlag(Flag.ChangeFaction)
            player:SendBroadcastMessage("You can now log out to apply the faction change.")
            player:GossipComplete()
        end
    elseif (intid == Id.Professions) then
        player:GossipClearMenu()

        if (player:IsValidProfession(Skill.FirstAid)) then
            local cost = player:GetProfessionCost(Skill.FirstAid)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with First Aid", 1, Id.Professions+1, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Blacksmithing)) then
            local cost = player:GetProfessionCost(Skill.Blacksmithing)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Blacksmithing", 1, Id.Professions+2, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Leatherworking)) then
            local cost = player:GetProfessionCost(Skill.Leatherworking)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Leatherworking", 1, Id.Professions+3, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Alchemy)) then
            local cost = player:GetProfessionCost(Skill.Alchemy)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Alchemy", 1, Id.Professions+4, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Herbalism)) then
            local cost = player:GetProfessionCost(Skill.Herbalism)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Herbalism", 1, Id.Professions+5, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Cooking)) then
            local cost = player:GetProfessionCost(Skill.Cooking)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Cooking", 1, Id.Professions+6, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Mining)) then
            local cost = player:GetProfessionCost(Skill.Mining)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Mining", 1, Id.Professions+7, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Tailoring)) then
            local cost = player:GetProfessionCost(Skill.Tailoring)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Tailoring", 1, Id.Professions+8, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Engineering)) then
            local cost = player:GetProfessionCost(Skill.Engineering)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Engineering", 1, Id.Professions+9, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Enchanting)) then
            local cost = player:GetProfessionCost(Skill.Enchanting)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Enchanting", 1, Id.Professions+10, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Fishing)) then
            local cost = player:GetProfessionCost(Skill.Fishing)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Fishing", 1, Id.Professions+11, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Skinning)) then
            local cost = player:GetProfessionCost(Skill.Skinning)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Skinning", 1, Id.Professions+12, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Inscription)) then
            local cost = player:GetProfessionCost(Skill.Inscription)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Inscription", 1, Id.Professions+13, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Jewelcrafting)) then
            local cost = player:GetProfessionCost(Skill.Jewelcrafting)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Jewelcrafting", 1, Id.Professions+14, false, "Do you wish to continue the transaction?", cost)
        end

        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Return)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Professions+1) then
        local cost = player:GetProfessionCost(Skill.FirstAid)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.FirstAid, 0, player:GetMaxSkillValue(Skill.FirstAid), player:GetMaxSkillValue(Skill.FirstAid))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+2) then
        local cost = player:GetProfessionCost(Skill.Blacksmithing)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Blacksmithing, 0, player:GetMaxSkillValue(Skill.Blacksmithing), player:GetMaxSkillValue(Skill.Blacksmithing))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+3) then
        local cost = player:GetProfessionCost(Skill.Leatherworking)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Leatherworking, 0, player:GetMaxSkillValue(Skill.Leatherworking), player:GetMaxSkillValue(Skill.Leatherworking))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+4) then
        local cost = player:GetProfessionCost(Skill.Alchemy)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Alchemy, 0, player:GetMaxSkillValue(Skill.Alchemy), player:GetMaxSkillValue(Skill.Alchemy))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+5) then
        local cost = player:GetProfessionCost(Skill.Herbalism)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Herbalism, 0, player:GetMaxSkillValue(Skill.Herbalism), player:GetMaxSkillValue(Skill.Herbalism))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+6) then
        local cost = player:GetProfessionCost(Skill.Cooking)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Cooking, 0, player:GetMaxSkillValue(Skill.Cooking), player:GetMaxSkillValue(Skill.Cooking))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+7) then
        local cost = player:GetProfessionCost(Skill.Mining)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Mining, 0, player:GetMaxSkillValue(Skill.Mining), player:GetMaxSkillValue(Skill.Mining))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+8) then
        local cost = player:GetProfessionCost(Skill.Tailoring)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Tailoring, 0, player:GetMaxSkillValue(Skill.Tailoring), player:GetMaxSkillValue(Skill.Tailoring))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+9) then
        local cost = player:GetProfessionCost(Skill.Engineering)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Engineering, 0, player:GetMaxSkillValue(Skill.Engineering), player:GetMaxSkillValue(Skill.Engineering))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+10) then
        local cost = player:GetProfessionCost(Skill.Enchanting)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Enchanting, 0, player:GetMaxSkillValue(Skill.Enchanting), player:GetMaxSkillValue(Skill.Enchanting))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+11) then
        local cost = player:GetProfessionCost(Skill.Fishing)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Fishing, 0, player:GetMaxSkillValue(Skill.Fishing), player:GetMaxSkillValue(Skill.Fishing))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+12) then
        local cost = player:GetProfessionCost(Skill.Skinning)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Skinning, 0, player:GetMaxSkillValue(Skill.Skinning), player:GetMaxSkillValue(Skill.Skinning))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+13) then
        local cost = player:GetProfessionCost(Skill.Inscription)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Inscription, 0, player:GetMaxSkillValue(Skill.Inscription), player:GetMaxSkillValue(Skill.Inscription))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    elseif (intid == Id.Professions+14) then
        local cost = player:GetProfessionCost(Skill.Jewelcrafting)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Jewelcrafting, 0, player:GetMaxSkillValue(Skill.Jewelcrafting), player:GetMaxSkillValue(Skill.Jewelcrafting))
        AssistantOnGossipSelect(event, player, object, sender, Id.Return, code)
    end
end
RegisterPlayerGossipEvent(1, Event.OnGossipSelect, AssistantOnGossipSelect)

local function AssistantOnLogin(event, player)
    if (Config.EnableHeirlooms or Config.EnableGlyphs or Config.EnableGems or Config.EnableUtilities or player:HasValidProfession()) then
        player:SendBroadcastMessage('This server uses an assistant to aid players. Use the command |cff4CFF00.assistant|r to get started!')
    end
end
RegisterPlayerEvent(Event.OnLogin, AssistantOnLogin)
