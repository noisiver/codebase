local INTERFACED, Interfaced = ...

BINDING_HEADER_INTERFACED = "Interfaced"
BINDING_NAME_SETUIPOINTS = "Set UI Points"
BINDING_NAME_TOGGLEBARTENDER = "Toggle Bartender Visibility"

function Interfaced_SetUIPoints()
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

    CastingBarFrameBorder:SetTexture(nil)
    CastingBarFrameFlash:SetTexture(nil)
end

function Interfaced_ToggleBartenderVisibility()
    Bartender4.Bar.barregistry["1"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["1"]:GetVisibilityOption("always"))
    Bartender4.Bar.barregistry["2"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["2"]:GetVisibilityOption("always"))
    Bartender4.Bar.barregistry["3"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["3"]:GetVisibilityOption("always"))
    Bartender4.Bar.barregistry["4"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["4"]:GetVisibilityOption("always"))
    Bartender4.Bar.barregistry["MicroMenu"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["MicroMenu"]:GetVisibilityOption("always"))
    Bartender4.Bar.barregistry["BagBar"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["BagBar"]:GetVisibilityOption("always"))

    if select(2, UnitClass("player")) == "PALADIN" or select(2, UnitClass("player")) == "WARRIOR" or select(2, UnitClass("player")) == "DRUID" or select(2, UnitClass("player")) == "DEATHKNIGHT" then
        Bartender4.Bar.barregistry["StanceBar"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["StanceBar"]:GetVisibilityOption("always"))
    end

    Bartender4.Bar.barregistry["PetBar"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["PetBar"]:GetVisibilityOption("always"))

    if select(2, UnitClass("player")) == "SHAMAN" then
        Bartender4.Bar.barregistry["MultiCast"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["MultiCast"]:GetVisibilityOption("always"))
    end
end

local ef = CreateFrame("FRAME")
    ef:RegisterEvent("PLAYER_ENTERING_WORLD")
    ef:SetScript("OnEvent", function(self)
    Interfaced_SetUIPoints()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:SetScript("OnEvent", nil)
end)
