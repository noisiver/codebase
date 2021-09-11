-- Requires
require("config")
require("events")

-- Player levels up
function playerLevelRewards(event, player, oldLevel)
    if (ENABLE_PLAYER_LEVEL_MONEY_REWARD) then
        local count = 0
        for _ in pairs(PLAYER_LEVEL_MONEY_REWARD) do count = count + 1 end

        for i=1,count do
            if (player:GetLevel() == PLAYER_LEVEL_MONEY_REWARD[i][1]) then
                player:SendBroadcastMessage(PLAYER_LEVEL_MONEY_REWARD[i][3])
                player:ModifyMoney(PLAYER_LEVEL_MONEY_REWARD[i][2])
            end
        end
    end
end

RegisterPlayerEvent(EVENT_ON_LEVEL_CHANGED, playerLevelRewards)
