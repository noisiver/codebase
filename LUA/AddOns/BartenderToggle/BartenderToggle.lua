SLASH_TOGGLEBARS1 = '/togglebars';
local function toggler()
    Bartender4.Bar.barregistry["1"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["1"]:GetVisibilityOption("always"))
    Bartender4.Bar.barregistry["2"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["2"]:GetVisibilityOption("always"))
    Bartender4.Bar.barregistry["3"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["3"]:GetVisibilityOption("always"))
    Bartender4.Bar.barregistry["4"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["4"]:GetVisibilityOption("always"))
    Bartender4.Bar.barregistry["MicroMenu"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["MicroMenu"]:GetVisibilityOption("always"))

    if select(2, UnitClass("player")) == "PALADIN" or select(2, UnitClass("player")) == "WARRIOR" or select(2, UnitClass("player")) == "DRUID" or select(2, UnitClass("player")) == "DEATHKNIGHT" then
        Bartender4.Bar.barregistry["StanceBar"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["StanceBar"]:GetVisibilityOption("always"))
    end

    Bartender4.Bar.barregistry["PetBar"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["PetBar"]:GetVisibilityOption("always"))

    if select(2, UnitClass("player")) == "SHAMAN" then
        Bartender4.Bar.barregistry["MultiCast"]:SetVisibilityOption("always",not Bartender4.Bar.barregistry["MultiCast"]:GetVisibilityOption("always"))
    end
end
SlashCmdList["TOGGLEBARS"] = toggler;