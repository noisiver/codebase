-- Config
local PLAYER_LEVEL_MONEY_REWARD = {
--    Level  Money        Text sent to the player
    { 10,    10 * 10000,  "Congratulations on reaching level 10! Take this gift of gold, let it aid you in your travels." },
    { 20,    25 * 10000,  "Congratulations on reaching level 20! Take this gift of gold, let it aid you in your travels." },
    { 30,    40 * 10000,  "Congratulations on reaching level 30! Take this gift of gold, let it aid you in your travels." },
    { 40,    55 * 10000,  "Congratulations on reaching level 40! Take this gift of gold, let it aid you in your travels." },
    { 50,    70 * 10000,  "Congratulations on reaching level 50! Take this gift of gold, let it aid you in your travels." },
    { 60,    85 * 10000,  "Congratulations on reaching level 60! Take this gift of gold, let it aid you in your travels." },
    { 70,    100 * 10000, "Congratulations on reaching level 70! Take this gift of gold, let it aid you in your travels." },
    { 80,    250 * 10000, "Congratulations on reaching level 80! Take this gift of gold, let it aid you in your travels." },
}

-- Events
local EVENT_ON_LEVEL_CHANGED = 13

-- Player levels up
function playerLevelRewards(event, player, oldLevel)
    local count = 0
    for _ in pairs(PLAYER_LEVEL_MONEY_REWARD) do count = count + 1 end

    for i=1,count do
        if (player:GetLevel() == PLAYER_LEVEL_MONEY_REWARD[i][1]) then
            player:SendBroadcastMessage(PLAYER_LEVEL_MONEY_REWARD[i][3])
            player:ModifyMoney(PLAYER_LEVEL_MONEY_REWARD[i][2])
        end
    end
end

RegisterPlayerEvent(EVENT_ON_LEVEL_CHANGED, playerLevelRewards)
