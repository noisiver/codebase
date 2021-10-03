-- Requires
require("ids")
require("events")

-- Configuration
ENABLE_SET_SPAWN_POINT                  = true -- Set spawn point and hearthstone to stormwind for alliance and orgrimmar for horde. Does not include death knight
SET_SPAWN_POINT                         = {
--   X             Y             Z          Orientation Map Area
    {-8830.438477, 626.666199,   93.982887, 0.682076,   0,  1519}, -- Alliance
    {1630.776001,  -4412.993652, 16.567701, 0.080535,   1,  1637} -- Horde
}

-- Character logs in for the first time
function spawnOnFirstLogin(event, player)
    if (ENABLE_SET_SPAWN_POINT) then
        if not (player:GetClass() == CLASS_DEATH_KNIGHT) then
            if (player:GetTeam() == TEAM_ALLIANCE) then
                player:Teleport(SET_SPAWN_POINT[1][5], SET_SPAWN_POINT[1][1], SET_SPAWN_POINT[1][2], SET_SPAWN_POINT[1][3], SET_SPAWN_POINT[1][4])
                --player:SetBindPoint(SET_SPAWN_POINT[1][1], SET_SPAWN_POINT[1][2], SET_SPAWN_POINT[1][3], SET_SPAWN_POINT[1][4], SET_SPAWN_POINT[1][5], SET_SPAWN_POINT[1][6])
            elseif (player:GetTeam() == TEAM_HORDE) then
                player:Teleport(SET_SPAWN_POINT[2][5], SET_SPAWN_POINT[2][1], SET_SPAWN_POINT[2][2], SET_SPAWN_POINT[2][3], SET_SPAWN_POINT[2][4])
                --player:SetBindPoint(SET_SPAWN_POINT[2][1], SET_SPAWN_POINT[2][2], SET_SPAWN_POINT[2][3], SET_SPAWN_POINT[2][4], SET_SPAWN_POINT[2][5], SET_SPAWN_POINT[2][6])
            end
        end
    end
end

RegisterPlayerEvent(EVENT_ON_FIRST_LOGIN, spawnOnFirstLogin)
