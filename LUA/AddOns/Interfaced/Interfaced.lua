local waitTable = {};
local waitFrame = nil;

function Interfaced_Wait(delay, func, ...)
    if (type(delay)~="number" or type(func)~="function") then
        return false;
    end

    if (waitFrame == nil) then
        waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
        waitFrame:SetScript("onUpdate",function (self,elapse)
            local count = #waitTable;
            local i = 1;
            while (i<=count) do
                local waitRecord = tremove(waitTable,i);
                local d = tremove(waitRecord,1);
                local f = tremove(waitRecord,1);
                local p = tremove(waitRecord,1);
                if (d>elapse) then
                    tinsert(waitTable,i,{d-elapse,f,p});
                    i = i + 1;
                else
                    count = count - 1;
                    f(unpack(p));
                end
            end
        end);
    end

    tinsert(waitTable,{delay,func,{...}});
    return true;
end

local function main()
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("CENTER", -350, 100)

    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("CENTER", 350, 100)

    for i = 1, 4 do
        local frame = _G["PartyMemberFrame"..i]
        frame:SetScript("OnShow", frame.Hide)
    end

    if (PetFrame) then
        PetFrame:ClearAllPoints()
        PetFrame:SetPoint("CENTER", PlayerFrame, "CENTER", 59, 52)
    end

    if (TotemFrame) then
        TotemFrame:ClearAllPoints()
        TotemFrame:SetPoint("CENTER", PlayerFrame, "CENTER", 45, 48)
    end

    --CastingBarFrame:SetScale(0.65)
    CastingBarFrameBorder:SetTexture(nil)
    CastingBarFrameFlash:SetTexture(nil)
    --CastingBarFrame:ClearAllPoints()
    --if select(2, UnitClass("player")) == "DEATHKNIGHT" then
        --CastingBarFrame:SetPoint("CENTER", PlayerFrame, "CENTER", 75, 60)
    --else
        --CastingBarFrame:SetPoint("CENTER", PlayerFrame, "CENTER", 75, -40)
    --end
    --CastingBarFrame.SetPoint = function() end
end

local ef = CreateFrame("FRAME")
    ef:RegisterEvent("PLAYER_ENTERING_WORLD")
    ef:SetScript("OnEvent", function(self)
    main()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:SetScript("OnEvent", nil)
end)

local uf = CreateFrame("FRAME")
    uf:RegisterEvent("UNIT_ENTERED_VEHICLE")
    uf:RegisterEvent("UNIT_EXITED_VEHICLE")
    uf:SetScript("OnEvent", function(self)
    Interfaced_Wait(0.5, main);
end)

SLASH_UPDATEUI1 = "/updateui"
SlashCmdList["UPDATEUI"] = main
