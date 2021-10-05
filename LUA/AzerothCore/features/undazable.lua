-- Requires
require("config")
require("events")

function unDazableOnLogin(event, player)
    if (ENABLE_DAZE_IMMUNITY and not player:HasAura(57416)) then
        player:AddAura(57416, player)
    elseif (not ENABLE_DAZE_IMMUNITY and player:HasAura(57416)) then
        player:RemoveAura(57416)
    end
end

RegisterPlayerEvent(EVENT_ON_LOGIN, unDazableOnLogin)
