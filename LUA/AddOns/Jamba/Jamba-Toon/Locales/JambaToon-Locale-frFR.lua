--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

local L = LibStub( "AceLocale-3.0" ):NewLocale( "Jamba-Toon", "frFR" )
if L then
L["Slash Commands"] = true
L["Toon: Warnings"] = "Personnage : Alertes"
L["Push Settings"] = "Transférer"
L["Push the toon settings to all characters in the team."] = "Transférer les réglages de personnages à tous les personnages de l'équipe."
L["Settings received from A."] = function( characterName )
    return string.format( "Réglages reçus de %s.", characterName )
end
L["Toon"] = "Personnage"
L[": "] = " : "
L["I'm Attacked!"] = "Je suis attaqué !"
L["Not Targeting!"] = "Pas de cible !"
L["Not Focus!"] = "Pas de focus !"
L["Low Health!"] = "Vie faible !"
L["Low Mana!"] = "Mana faible !"
L["Merchant"] = "Marchand"
L["Auto Repair"] = "Réparation automatique"
L["Auto Repair With Guild Funds"] = "Réparer automatiquement avec les fonds de la guilde"
L["Send Request Message Area"] = "Zone d'envoi de message de requête"
L["Requests"] = "Requêtes"
L["Auto Deny Duels"] = "Automatiquement refuser les duels"
L["Auto Deny Guild Invites"] = "Automatiquement refuser les invitations dans une guilde"
L["Auto Accept Resurrect Request"] = "Automatiquement accepter les résurections"
L["Send Request Message Area"] = "Zone d'envoi de message de requête"
L["Combat"] = "Combat"
L["Health / Mana"] = "Vie / Mana"
L["Bag Space"] = "Emplacement de sac"
L["Bags Full!"] = "Sacs pleins !"
L["Warn If All Regular Bags Are Full"] = "Avertir si tous les sacs ordinaires sont pleins"
L["Bags Full Message"] = "Message de sacs pleins"
L["Warn If Hit First Time In Combat (Slave)"] = "Avertir la 1ère fois si touché en combat"
L["Hit First Time Message"] = "Message d'avertissement"
L["Warn If Target Not Master On Combat (Slave)"] = "Avertir si la cible d'un esclave n'est pas le maître"
L["Warn Target Not Master Message"] = "Message d'avertissement"
L["Warn If Focus Not Master On Combat (Slave)"] = "Avertir si le focus d'un esclave n'est pas le maître"
L["Warn Focus Not Master Message"] = "Message d'avertissement"
L["Warn If My Health Drops Below"] = "Avertir si ma vie tombe sous"
L["Health Amount - Percentage Allowed Before Warning"] = "Pourcentage minimum de vie avant avertissement"
L["Warn Health Drop Message"] = "Message d'avertissement de vie basse"
L["Warn If My Mana Drops Below"] = "Avertir si ma mana tombe sous"
L["Mana Amount - Percentage Allowed Before Warning"] = "Pourcentage minimum de mana avant avertissement"
L["Warn Mana Drop Message"] = "Message d'avertissement de mana basse"
L["Send Warning Area"]  = "Zone d'envoi d'avertissement"
L["I refused a guild invite to: X from: Y"] = function( guild, inviter )
    return string.format( "J'ai refusé une invitation dans la guilde %s par %s", guild, inviter )
end
L["I refused a duel from: X"] = function( challenger )
    return string.format( "J'ai refusé un duel de %s", challenger )
end
L["I do not have enough money to repair all my items."] = "Je n'ai pas assez d'argent pour réparer tout mon équipement."
L["Repairing cost me: X"] = function( costString )
    return string.format( "Les réparations m'ont coûté %s", costString )
end
L["I am inactive!"] = "Je suis inactif !"
L["Warn If Toon Goes Inactive (PVP)"] = "Avertir si un perosnnage devient inactif (pvp) !"
L["Inactive Message"] = "Message d'inactivité"
-- Brgin special.
-- This is the inactive buff - you need to make sure it is localized correctly.
-- http://www.wowhead.com/spell=43681
L["Inactive"] = "Inactif" -- checked wowhead - Daeri
-- End special.
L["Currency"] = true
L["Show Currency"] = true
L["Show the current toon the currency values for all members in the team."] = true
L["Blizzard Tooltip"] = true
L["Blizzard Dialog Background"] = true
L["Curr"] = true
L["Jamba Currency"] = true
L["Update"] = true
L["Gold"] = true
L["Include Gold In Guild Bank"] = true
L["Total"] = true
L["Guild"] = true
L["Emblem of Frost"] = true
L["EoF"] = true
L["Emblem of Triumph"] = true
L["EoT"] = true
L["Emblem of Conquest"] = true
L["EoC"] = true
L["Emblem of Valor"] = true
L["EoV"] = true
L["Emblem of Heroism"] = true
L["EoH"] = true
L["Honor Points"] = true
L["HP"] = true
L["Arena Points"] = true
L["AP"] = true
L[" ("] = true
L[")"] = true
L["Currency Selection"] = true
L["Scale"] = true
L["Transparency"] = true
L["Border Style"] = true
L["Border Colour"] = true
L["Background"] = true
L["Background Colour"] = true
L["Appearance & Layout"] = true
L["Space For Name"] = true
L["Space For Gold"] = true
L["Space For Points"] = true
L["Space Between Values"] = true
L["Lock Currency List (enables mouse click-through)"] = true
L["Open Currency List On Start Up (Master Only)"] = true
L["Currency"] = true
L["Show Currency"] = true
L["Show the current toon the currency values for all members in the team."] = true
L["Blizzard Tooltip"] = true
L["Blizzard Dialog Background"] = true
L["Curr"] = true
L["Jamba Currency"] = true
L["Update"] = true
L["Gold"] = true
L["Include Gold In Guild Bank"] = true
L["Total"] = true
L["Guild"] = true
L["Emblem of Frost"] = true
L["EoF"] = true
L["Emblem of Triumph"] = true
L["EoT"] = true
L["Emblem of Conquest"] = true
L["EoC"] = true
L["Emblem of Valor"] = true
L["EoV"] = true
L["Emblem of Heroism"] = true
L["EoH"] = true
L["Honor Points"] = true
L["HP"] = true
L["Arena Points"] = true
L["AP"] = true
L[" ("] = true
L[")"] = true
L["Currency Selection"] = true
L["Scale"] = true
L["Transparency"] = true
L["Border Style"] = true
L["Border Colour"] = true
L["Background"] = true
L["Background Colour"] = true
L["Appearance & Layout"] = true
L["Space For Name"] = true
L["Space For Gold"] = true
L["Space For Points"] = true
L["Space Between Values"] = true
L["Lock Currency List (enables mouse click-through)"] = true
L["Open Currency List On Start Up (Master Only)"] = true
end
