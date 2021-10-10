-- Events
local EVENT_ON_LOGIN             = 3
local EVENT_ON_GIVE_XP           = 12
local EVENT_ON_REPUTATION_CHANGE = 15

-- Check if it is a weekend
function isWeekend()
    if (os.date("*t").wday == 6 or os.date("*t").wday == 7 or os.date("*t").wday == 8) then
        return true
    end

    return false
end

-- Character gains experience
function bonusOnGiveXP(event, player, amount, victim)
    if (isWeekend()) then
        return amount * 2
    end
end

RegisterPlayerEvent(EVENT_ON_GIVE_XP, bonusOnGiveXP)

-- Character gains reputation
function bonusOnReputationChange(event, player, factionId, standing, incremenetal)
    if (isWeekend()) then
        return standing * 2
    end
end

RegisterPlayerEvent(EVENT_ON_REPUTATION_CHANGE, bonusOnReputationChange)

-- Character enters the world
function bonusOnLogin(event, player)
    if (isWeekend()) then
        player:SendBroadcastMessage("The weekend bonus is active, doubling the experience and reputation you receive!")
    end
end

RegisterPlayerEvent(EVENT_ON_LOGIN, bonusOnLogin)
