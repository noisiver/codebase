-- Requires
require("config")
require("events")

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

    if (ENABLE_WEEKEND_MULTIPLIER) then
        if (os.date("*t").wday == 6 or os.date("*t").wday == 7 or os.date("*t").wday == 8) then
            multiplier = multiplier * WEEKEND_MULTIPLIER
        end
    end

    return multiplier
end

-- Character gains experience
function multiplierOnGiveXP(event, player, amount, victim)
    if (ENABLE_EXPERIENCE_MULTIPLIER) then
        return amount * rateMultiplier(player)
    end
end

RegisterPlayerEvent(EVENT_ON_GIVE_XP, multiplierOnGiveXP)

-- Character gains reputation
function multiplierOnReputationChange(event, player, factionId, standing, incremenetal)
    if (ENABLE_REPUTATION_MULTIPLIER) then
        return standing * rateMultiplier(player)
    end
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

        if (ENABLE_WEEKEND_MULTIPLIER and (ENABLE_EXPERIENCE_MULTIPLIER or ENABLE_REPUTATION_MULTIPLIER)) then
            if (os.date("*t").wday == 6 or os.date("*t").wday == 7 or os.date("*t").wday == 1) then
                player:SendBroadcastMessage("The weekend multiplier is currently active, increasing the above values.")
            end
        end

        return false
    end
end

RegisterPlayerEvent(EVENT_ON_COMMAND, multiplierOnCommand)
