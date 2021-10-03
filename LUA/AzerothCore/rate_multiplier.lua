-- Requires
require("events")

-- Configuration
ENABLE_EXPERIENCE_MULTIPLIER            = true -- Enable the experience multiplier
ENABLE_REPUTATION_MULTIPLIER            = true -- Enable the reputation multiplier
ENABLE_ANNOUNCE_ON_LOGIN                = true -- Enable to print a message to a player when entering the world
MULTIPLIER_ANNOUNCE_MAX_LEVEL           = 79 -- Max level a player will receive the printed values when entering the world
ENABLE_WEEKEND_MULTIPLIER               = true -- Changes the multiplier on friday, saturday and sunday
WEEKEND_MULTIPLIER                      = 2 -- Multiplier for all rates on weekends
RATE_MULTIPLIER                         = {
--    Min level  Max level  Multiplier
    { 1,         59,        1 },
    { 60,        69,        1 },
    { 70,        79,        1 },
    { 80,        80,        1 },
}

-- Check the day
function isWeekend()
    if (os.date("*t").wday == 6 or os.date("*t").wday == 7 or os.date("*t").wday == 8) then
        return true
    end

    return false
end

-- Calculate multiplier
function rateMultiplier(player)
    local multiplier = 1

    local count = 0
    for _ in pairs(RATE_MULTIPLIER) do count = count + 1 end

    for i=1,count do
        if (player:GetLevel() >= RATE_MULTIPLIER[i][1] and player:GetLevel() <= RATE_MULTIPLIER[i][2]) then
            multiplier = RATE_MULTIPLIER[i][3]
            break
        end
    end

    return multiplier
end

-- Character gains experience
function multiplierOnGiveXP(event, player, amount, victim)
    local multiplier = 1

    if (ENABLE_EXPERIENCE_MULTIPLIER) then
        multiplier = rateMultiplier(player)
    end

    if (ENABLE_WEEKEND_MULTIPLIER and isWeekend) then
        multiplier = multiplier * WEEKEND_MULTIPLIER
    end

    return amount * multiplier
end

RegisterPlayerEvent(EVENT_ON_GIVE_XP, multiplierOnGiveXP)

-- Character gains reputation
function multiplierOnReputationChange(event, player, factionId, standing, incremenetal)
    local multiplier = 1

    if (ENABLE_REPUTATION_MULTIPLIER) then
        multiplier = rateMultiplier(player)
    end

    if (ENABLE_WEEKEND_MULTIPLIER and isWeekend) then
        multiplier = multiplier * WEEKEND_MULTIPLIER
    end

    return standing * multiplier
end

RegisterPlayerEvent(EVENT_ON_REPUTATION_CHANGE, multiplierOnReputationChange)

-- Character performs a command
function multiplierOnCommand(event, player, command)
    if command == 'rates' then
        if (ENABLE_EXPERIENCE_MULTIPLIER) then
            player:SendBroadcastMessage("The experience you receive is "..(100 * rateMultiplier(player)).."% of the normal value.")
        end

        if (ENABLE_REPUTATION_MULTIPLIER) then
            player:SendBroadcastMessage("The reputation you receive is "..(100 * rateMultiplier(player)).."% of the normal value.")
        end

        if (ENABLE_WEEKEND_MULTIPLIER and (ENABLE_EXPERIENCE_MULTIPLIER or ENABLE_REPUTATION_MULTIPLIER) and isWeekend) then
            player:SendBroadcastMessage("The weekend bonus is active, giving you a bonus of "..(100 * WEEKEND_MULTIPLIER).."%.")
        end

        return false
    end
end

RegisterPlayerEvent(EVENT_ON_COMMAND, multiplierOnCommand)

-- Character enters the world
function multiplierOnLogin(event, player)
    if (ENABLE_ANNOUNCE_ON_LOGIN and (player:GetLevel() <= MULTIPLIER_ANNOUNCE_MAX_LEVEL)) then
        if (ENABLE_EXPERIENCE_MULTIPLIER) then
            player:SendBroadcastMessage("The experience you receive is "..(100 * rateMultiplier(player)).."% of the normal value.")
        end

        if (ENABLE_REPUTATION_MULTIPLIER) then
            player:SendBroadcastMessage("The reputation you receive is "..(100 * rateMultiplier(player)).."% of the normal value.")
        end

        if (ENABLE_WEEKEND_MULTIPLIER and (ENABLE_EXPERIENCE_MULTIPLIER or ENABLE_REPUTATION_MULTIPLIER) and isWeekend) then
            player:SendBroadcastMessage("The weekend bonus is active, giving you a bonus of "..(100 * WEEKEND_MULTIPLIER).."%.")
        end
    end
end

RegisterPlayerEvent(EVENT_ON_LOGIN, multiplierOnLogin)
