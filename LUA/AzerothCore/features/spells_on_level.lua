-- Requires
require("config")
require("ids")
require("spells")
require("events")
require("proficiencies")

-- Learn class spells
function classSpells(player)
    if (ENABLE_SPELLS_ON_LEVEL_UP) then
        local count = 0
        for _ in pairs(CLASS_SPELL_LIST[player:GetClass()]) do count = count + 1 end

        for i=1,count do
            if (CLASS_SPELL_LIST[player:GetClass()][i][2] <= player:GetLevel()) then
                if not (player:HasSpell(CLASS_SPELL_LIST[player:GetClass()][i][1])) then
                    player:LearnSpell(CLASS_SPELL_LIST[player:GetClass()][i][1])
                end
            end
        end
    end
end

-- Learn class talent ranks
function classTalents(player)
    if (ENABLE_TALENTS_ON_LEVEL_UP) then
        local count = 0
        for _ in pairs(CLASS_TALENT_LIST[player:GetClass()]) do count = count + 1 end

        for i=1,count do
            if (CLASS_TALENT_LIST[player:GetClass()][i][2] <= player:GetLevel() and player:HasSpell(CLASS_TALENT_LIST[player:GetClass()][i][3])) then
                if not (player:HasSpell(CLASS_TALENT_LIST[player:GetClass()][i][1])) then
                    player:LearnSpell(CLASS_TALENT_LIST[player:GetClass()][i][1])
                end
            end
        end
    end
end

-- Learn class proficiencies
function classProficiencies(player)
    if (ENABLE_PROFICIENCY_ON_LEVEL_UP) then
        local count = 0
        for _ in pairs(CLASS_PROFICIENCY_LIST[player:GetClass()]) do count = count + 1 end

        for i=1,count do
            if (CLASS_PROFICIENCY_LIST[player:GetClass()][i][2] <= player:GetLevel()) then
                if not (player:HasSpell(CLASS_PROFICIENCY_LIST[player:GetClass()][i][1])) then
                    player:LearnSpell(CLASS_PROFICIENCY_LIST[player:GetClass()][i][1])
                end
            end
        end
    end
end

-- Set skills to max
function classMaxSkill(player)
    if (ENABLE_MAX_SKILL_ON_LEVEL) then
        if (player:GetLevel() <= MAX_SKILL_MAX_LEVEL) then
            player:AdvanceSkillsToMax()
        end
    end
end

function classMounts(player)
    local count = 0
    for _ in pairs(RIDING_SPELL) do count = count + 1 end

    for i=1,count do
        if (RIDING_SPELL[i][2] <= player:GetLevel() and RIDING_SPELL[i][3] and (RIDING_SPELL[i][4] == 0 or player:HasSpell(RIDING_SPELL[i][4]))) then
            if not (player:HasSpell(RIDING_SPELL[i][1])) then
                player:LearnSpell(RIDING_SPELL[i][1])
            end
        end
    end

    local count = 0
    for _ in pairs(MOUNT_SPELL[player:GetRace()]) do count = count + 1 end

    for i=1,count do
        if (MOUNT_SPELL[player:GetRace()][i][2] <= player:GetLevel() and MOUNT_SPELL[player:GetRace()][i][3] and player:HasSpell(MOUNT_SPELL[player:GetRace()][i][4])) then
            if not (player:HasSpell(MOUNT_SPELL[player:GetRace()][i][1])) then
                player:LearnSpell(MOUNT_SPELL[player:GetRace()][i][1])
            end
        end
    end
end

function classCollection(player)
    classSpells(player)
    classTalents(player)
    classProficiencies(player)
    classMaxSkill(player)
    classMounts(player)
end

-- Character logs in for the first time
function classOnFirstLogin(event, player)
    classCollection(player)
end

RegisterPlayerEvent(EVENT_ON_FIRST_LOGIN, classOnFirstLogin)

-- Player levels up
function classOnLevelChanged(event, player, oldLevel)
    classCollection(player)
end

RegisterPlayerEvent(EVENT_ON_LEVEL_CHANGED, classOnLevelChanged)

-- Character performs a command
function spellsOnCommand(event, player, command)
    if (ENABLE_SPELLS_ON_LEVEL_UP or ENABLE_TALENTS_ON_LEVEL_UP or ENABLE_PROFICIENCY_ON_LEVEL_UP or ENABLE_APPRENTICE_MOUNT_ON_LEVEL_UP or ENABLE_JOURNEYMAN_MOUNT_ON_LEVEL_UP or ENABLE_EXPERT_MOUNT_ON_LEVEL_UP or ENABLE_ARTISAN_MOUNT_ON_LEVEL_UP or ENABLE_COLD_WEATHER_FLYING_ON_LEVEL_UP or ENABLE_MAX_SKILL_ON_LEVEL) then
        if command == 'learnspells' then
            classCollection(player)
            return false
        end
    end
end

RegisterPlayerEvent(EVENT_ON_COMMAND, spellsOnCommand)
