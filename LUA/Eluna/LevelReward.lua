local Config = {}
Config.Reward = {
    { 10, 5 * 10000, 'Congratulations on reaching level 10! Take this reward of gold, let it aid you in your travels.' },
    { 20, 15 * 10000, 'Congratulations on reaching level 20! Take this reward of gold, let it aid you in your travels.' },
    { 30, 30 * 10000, 'Congratulations on reaching level 30! Take this reward of gold, let it aid you in your travels.' },
    { 40, 45 * 10000, 'Congratulations on reaching level 40! Take this reward of gold, let it aid you in your travels.' },
    { 50, 60 * 10000, 'Congratulations on reaching level 50! Take this reward of gold, let it aid you in your travels.' },
    { 60, 80 * 10000, 'Congratulations on reaching level 60! Take this reward of gold, let it aid you in your travels.' },
    { 70, 125 * 10000, 'Congratulations on reaching level 70! Take this reward of gold, let it aid you in your travels.' },
    { 80, 250 * 10000, 'Congratulations on reaching level 80! Take this reward of gold, let it aid you in your travels.' },
}

local Event        = {
    OnLevelChanged = 13,
}

local function LevelRewardOnLevelChanged(event, player, oldLevel)
    local count = 0
    for _ in pairs(Config.Reward) do count = count + 1 end

    for i=1, count do
        if (player:GetLevel() == Config.Reward[i][1]) then
            player:SendBroadcastMessage(Config.Reward[i][3])
            player:ModifyMoney(Config.Reward[i][2])
        end
    end
end
RegisterPlayerEvent(Event.OnLevelChanged, LevelRewardOnLevelChanged)
