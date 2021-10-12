-- Config
local ENABLE_SPAWN_POINT_DEATH_KNIGHT = true

-- Events
local EVENT_ON_FIRST_LOGIN = 30

-- Ids
TEAM_ALLIANCE      = 0
TEAM_HORDE         = 1
CLASS_DEATH_KNIGHT = 6

-- Character logs in for the first time
function spawnOnFirstLogin(event, player)
    if (player:GetClass() == CLASS_DEATH_KNIGHT and not ENABLE_SPAWN_POINT_DEATH_KNIGHT) then
        return
    end

    if (player:GetTeam() == TEAM_ALLIANCE) then
        player:Teleport(0, -8830.438477, 626.666199, 93.982887, 0.682076)
    elseif (player:GetTeam() == TEAM_HORDE) then
        player:Teleport(1, 1630.776001, -4412.993652, 16.567701, 0.080535)
    end
end

RegisterPlayerEvent(EVENT_ON_FIRST_LOGIN, spawnOnFirstLogin)
