local INTERFACED, Interfaced = ...

BINDING_HEADER_INTERFACED = "Interfaced"
BINDING_NAME_TOGGLEBARTENDER = "Toggle Bartender Visibility"

local playerPositionX = -350
local playerPositionY = 100
local targetPositionX = 350
local targetPositionY = 100
local petPositionX = 59
local petPositionY = 52
local totemPositionX = 45
local totemPositionY = 48

local function round(num)
    return num + (2^52 + 2^51) - (2^52 + 2^51)
end

local function Interfaced_SetUIPoints()
    local point, relativeTo, relativePoint, xOfs, yOfs = PlayerFrame:GetPoint()
    if ((not (round(xOfs) == playerPositionX)) or (not (round(yOfs) == playerPositionY))) then
        PlayerFrame:ClearAllPoints()
        PlayerFrame:SetPoint("CENTER", playerPositionX, playerPositionY)
    end

    local point, relativeTo, relativePoint, xOfs, yOfs = TargetFrame:GetPoint()
    if ((not (round(xOfs) == targetPositionX)) or (not (round(yOfs) == targetPositionY))) then
        TargetFrame:ClearAllPoints()
        TargetFrame:SetPoint("CENTER", targetPositionX, targetPositionY)
    end

    for i = 1, 4 do
        local frame = _G["PartyMemberFrame"..i]
        if (frame:IsVisible()) then
            frame:Hide()
            print("Frame "..frame:GetName().." is hidden")
        end
    end

    if (PetFrame) then
        local point, relativeTo, relativePoint, xOfs, yOfs = PetFrame:GetPoint()
        if ((not (round(xOfs) == petPositionX)) or (not (round(yOfs) == petPositionY))) then
            PetFrame:ClearAllPoints()
            PetFrame:SetPoint("CENTER", PlayerFrame, "CENTER", petPositionX, petPositionY)
        end
    end

    if (TotemFrame) then
        local point, relativeTo, relativePoint, xOfs, yOfs = TotemFrame:GetPoint()
        if ((not (round(xOfs) == totemPositionX)) or (not (round(yOfs) == totemPositionY))) then
            TotemFrame:ClearAllPoints()
            TotemFrame:SetPoint("CENTER", PlayerFrame, "CENTER", totemPositionX, totemPositionY)
        end
    end

    if (CastingBarFrameBorder:GetTexture() ~= nil) then
        CastingBarFrameBorder:SetTexture(nil)
    end

    if (CastingBarFrameFlash:GetTexture() ~= nil) then
        CastingBarFrameFlash:SetTexture(nil)
    end
end

function Interfaced_ToggleBartenderVisibility()
    local visibility = Bartender4.Bar.barregistry["1"]:GetVisibilityOption("always")

    Bartender4.Bar.barregistry["1"]:SetVisibilityOption("always", not visibility)
    Bartender4.Bar.barregistry["2"]:SetVisibilityOption("always", not visibility)
    Bartender4.Bar.barregistry["3"]:SetVisibilityOption("always", not visibility)
    Bartender4.Bar.barregistry["4"]:SetVisibilityOption("always", not visibility)
    Bartender4.Bar.barregistry["MicroMenu"]:SetVisibilityOption("always", not visibility)
    -- Bartender4.Bar.barregistry["BagBar"]:SetVisibilityOption("always", not visibility)

    if select(2, UnitClass("player")) == "PALADIN" or select(2, UnitClass("player")) == "WARRIOR" or select(2, UnitClass("player")) == "DRUID" or select(2, UnitClass("player")) == "DEATHKNIGHT" then
        Bartender4.Bar.barregistry["StanceBar"]:SetVisibilityOption("always", not visibility)
    end

    Bartender4.Bar.barregistry["PetBar"]:SetVisibilityOption("always", not visibility)

    if select(2, UnitClass("player")) == "SHAMAN" then
        Bartender4.Bar.barregistry["MultiCast"]:SetVisibilityOption("always", not visibility)
    end
end

local uf = CreateFrame("FRAME")
local time = 0
uf:SetScript("OnUpdate", function(self, elapsed)
    time = time + elapsed
    if (time > 1) then
        Interfaced_SetUIPoints()
        time = 0
    end
end)

uf:RegisterEvent("PLAYER_ENTERING_WORLD")
uf:SetScript("OnEvent", function(self)
    Interfaced_SetUIPoints()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:SetScript("OnEvent", nil)
end)
