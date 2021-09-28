$root = Get-Location
$configFile = "$root\azerothcore.xml"
$mysqlConfig = "$root\mysql.cnf"

Clear-Host
Write-Host -ForegroundColor Green "Loading configuration options"

function Check-Configuration
{
    if (-Not (Test-Path -Path $configFile))
    {
        Write-Host -ForegroundColor Yellow "Generating default configuration"


        $xmlObjectsettings = New-Object System.Xml.XmlWriterSettings
        $xmlObjectsettings.Indent = $true
        $xmlObjectsettings.IndentChars = "    "

        $XmlObjectWriter = [System.XML.XmlWriter]::Create($configFile, $xmlObjectsettings)
        $XmlObjectWriter.WriteStartDocument()

        $XmlObjectWriter.WriteStartElement("config")

        $XmlObjectWriter.WriteStartElement("mysql")
        $XmlObjectWriter.WriteComment("The ip-address or hostname used to connect to the mysql-database")
        $XmlObjectWriter.WriteElementString("hostname","127.0.0.1")
        $XmlObjectWriter.WriteComment("The port used to connect to the mysql-database")
        $XmlObjectWriter.WriteElementString("port","3306")
        $XmlObjectWriter.WriteComment("The username used to connect to the mysql-database")
        $XmlObjectWriter.WriteElementString("username","acore")
        $XmlObjectWriter.WriteComment("The password used to connect to the mysql-database")
        $XmlObjectWriter.WriteElementString("password","acore")
        $XmlObjectWriter.WriteStartElement("database")
        $XmlObjectWriter.WriteComment("The database used for auth")
        $XmlObjectWriter.WriteElementString("auth","acore_auth")
        $XmlObjectWriter.WriteComment("The database used for characters")
        $XmlObjectWriter.WriteElementString("characters","acore_characters")
        $XmlObjectWriter.WriteComment("The database used for world")
        $XmlObjectWriter.WriteElementString("world","acore_world")
        $XmlObjectWriter.WriteEndElement()
        $XmlObjectWriter.WriteEndElement()

        $XmlObjectWriter.WriteStartElement("core")
        $XmlObjectWriter.WriteComment("The location where the source is located")
        $XmlObjectWriter.WriteElementString("directory","C:\AzerothCore")
        $XmlObjectWriter.WriteComment("The required client data version")
        $XmlObjectWriter.WriteElementString("required_client_data","12")
        $XmlObjectWriter.WriteComment("The installed client data version")
        $XmlObjectWriter.WriteElementString("installed_client_data","0")
        $XmlObjectWriter.WriteEndElement()

        $XmlObjectWriter.WriteStartElement("world")
        $XmlObjectWriter.WriteComment("The name of the realm as seen in the list in-game")
        $XmlObjectWriter.WriteElementString("name","AzerothCore")
        $XmlObjectWriter.WriteComment("Message of the Day, displayed at login. Use '@' for a newline and be sure to escape special characters")
        $XmlObjectWriter.WriteElementString("motd","Welcome to AzerothCore.")
        $XmlObjectWriter.WriteComment("The id of the realm")
        $XmlObjectWriter.WriteElementString("id","1")
        $XmlObjectWriter.WriteComment("The ip or hostname used to connect to the world server. Use external ip if required")
        $XmlObjectWriter.WriteElementString("address","127.0.0.1")
        $XmlObjectWriter.WriteComment("Server realm type. 0 = normal, 1 = pvp, 6 = rp, 8 = rppvp")
        $XmlObjectWriter.WriteElementString("game_type","0")
        $XmlObjectWriter.WriteComment("Server realm zone. Set allowed alphabet in character, etc. names. 1 = development, 2 = united states, 6 = korea, 9 = german, 10 = french, 11 = spanish, 12 = russian, 14 = taiwan, 16 = china, 26 = test server")
        $XmlObjectWriter.WriteElementString("realm_zone","1")
        $XmlObjectWriter.WriteComment("Allow server to use content from expansions. Checks for expansion-related map files, client compatibility and class/race character creation. 0 = none, 1 = tbc, 2 = wotlk")
        $XmlObjectWriter.WriteElementString("expansion","2")
        $XmlObjectWriter.WriteComment("Maximum number of players in the world. Excluding Mods, GMs and Admins")
        $XmlObjectWriter.WriteElementString("player_limit","1000")
        $XmlObjectWriter.WriteComment("Disable cinematic intro at first login after character creation. Prevents buggy intros in case of custom start location coordinates. 0 = Show intro for each new character, 1 = Show intro only for first character of selected race, 2 = Disable intro for all classes")
        $XmlObjectWriter.WriteElementString("skip_cinematics","0")
        $XmlObjectWriter.WriteComment("Maximum level that can be reached by players. Levels beyond 100 are not recommended at all")
        $XmlObjectWriter.WriteElementString("max_level","80")
        $XmlObjectWriter.WriteComment("Starting level for characters after creation")
        $XmlObjectWriter.WriteElementString("start_level","1")
        $XmlObjectWriter.WriteComment("Amount of money (in Copper) that a character has after creation")
        $XmlObjectWriter.WriteElementString("start_money","0")
        $XmlObjectWriter.WriteComment("Players will automatically gain max skill level when logging in or leveling up. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("always_max_skill","0")
        $XmlObjectWriter.WriteComment("Character knows all flight paths (of both factions) after creation. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("all_flight_paths","0")
        $XmlObjectWriter.WriteComment("Characters start with all maps explored. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("maps_explored","0")
        $XmlObjectWriter.WriteComment("Allow players to use commands. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("allow_commands","1")
        $XmlObjectWriter.WriteComment("Allow non-raid quests to be completed while in a raid group. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("quest_ignore_raids","0")
        $XmlObjectWriter.WriteComment("Prevent players AFK from being logged out. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("prevent_afk_logout","0")
        $XmlObjectWriter.WriteComment("Highest level up to which a character can benefit from the Recruit-A-Friend experience multiplier")
        $XmlObjectWriter.WriteElementString("raf_max_level","60")
        $XmlObjectWriter.WriteComment("Preload all grids on all non-instanced maps. This will take a great amount of additional RAM (ca. 9 GB) and causes the server to take longer to start, but can increase performance if used on a server with a high amount of players. It will also activate all creatures which are set active (e.g. the Fel Reavers in Hellfire Peninsula) on server start. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("preload_map_grids","0")
        $XmlObjectWriter.WriteComment("Set all creatures with waypoint movement active. This means that they will start movement once they are loaded (which happens on grid load) and keep moving even when no player is near. This will increase CPU usage significantly and can be used with enabled preload_map_grids to start waypoint movement on server startup. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("set_all_waypoints_active","0")
        $XmlObjectWriter.WriteComment("Enable/Disable Minigob Manabonk in Dalaran. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("enable_minigob_manabonk","1")
        $XmlObjectWriter.WriteStartElement("rates")
        $XmlObjectWriter.WriteComment("Experience rates (outside battleground)")
        $XmlObjectWriter.WriteElementString("experience","1")
        $XmlObjectWriter.WriteComment("Resting points grow rates")
        $XmlObjectWriter.WriteElementString("rested_exp","1")
        $XmlObjectWriter.WriteComment("Reputation gain rate")
        $XmlObjectWriter.WriteElementString("reputation","1")
        $XmlObjectWriter.WriteComment("Drop rates for money")
        $XmlObjectWriter.WriteElementString("money","1")
        $XmlObjectWriter.WriteComment("Crafting skills gain rate")
        $XmlObjectWriter.WriteElementString("crafting","1")
        $XmlObjectWriter.WriteComment("Gathering skills gain rate")
        $XmlObjectWriter.WriteElementString("gathering","1")
        $XmlObjectWriter.WriteComment("Weapon skills gain rate")
        $XmlObjectWriter.WriteElementString("weapon_skill","1")
        $XmlObjectWriter.WriteComment("Defense skills gain rate")
        $XmlObjectWriter.WriteElementString("defense_skill","1")
        $XmlObjectWriter.WriteEndElement()
        $XmlObjectWriter.WriteStartElement("gm")
        $XmlObjectWriter.WriteComment("Set GM state when a GM character enters the world. 0 = disabled, 1 = enabled, 2 = last save state")
        $XmlObjectWriter.WriteElementString("login_state","1")
        $XmlObjectWriter.WriteComment("GM visibility at login. 0 = disabled, 1 = enabled, 2 = last save state")
        $XmlObjectWriter.WriteElementString("visible","0")
        $XmlObjectWriter.WriteComment("GM chat mode at login. 0 = disabled, 1 = enabled, 2 = last save state")
        $XmlObjectWriter.WriteElementString("chat","1")
        $XmlObjectWriter.WriteComment("Is GM accepting whispers from player by default or not. 0 = disabled, 1 = enabled, 2 = last save state")
        $XmlObjectWriter.WriteElementString("whisper","0")
        $XmlObjectWriter.WriteComment("Maximum GM level shown in GM list (if enabled) in non-GM state. 0 = only players, 1 = only moderators, 2 = only gamemasters, 3 = anyone")
        $XmlObjectWriter.WriteElementString("gm_list","0")
        $XmlObjectWriter.WriteComment("Max GM level showed in who list (if visible). 0 = only players, 1 = only moderators, 2 = only gamemasters, 3 = anyone")
        $XmlObjectWriter.WriteElementString("who_list","0")
        $XmlObjectWriter.WriteComment("Allow players to add GM characters to their friends list. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("allow_friend","0")
        $XmlObjectWriter.WriteComment("Allow players to invite GM characters. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("allow_invite","0")
        $XmlObjectWriter.WriteComment("Allow lower security levels to use commands on higher security level characters. 0 = disabled, 1 = enabled")
        $XmlObjectWriter.WriteElementString("lower_security","0")
        $XmlObjectWriter.WriteEndElement()

        $XmlObjectWriter.WriteStartElement("module")
        $XmlObjectWriter.WriteStartElement("ahbot")
        $XmlObjectWriter.WriteComment("Enable/Disable the use of the AHBot module")
        $XmlObjectWriter.WriteElementString("enabled","false")
        $XmlObjectWriter.WriteComment("Enable/Disable the part of AHBot that buys items from players")
        $XmlObjectWriter.WriteElementString("enable_buyer","false")
        $XmlObjectWriter.WriteComment("Enable/Disable the part of AHBot that puts items up for auction")
        $XmlObjectWriter.WriteElementString("enable_seller","false")
        $XmlObjectWriter.WriteComment("Account id is the account number (auth->account) of the player you want to run as the auction bot")
        $XmlObjectWriter.WriteElementString("account_id","0")
        $XmlObjectWriter.WriteComment("Character guid is the GUID (characters->characters table) of the player you want to run as the auction bot")
        $XmlObjectWriter.WriteElementString("character_guid","0")
        $XmlObjectWriter.WriteComment("Minimum amount of items the bot will keep on the auction house")
        $XmlObjectWriter.WriteElementString("min_items","0")
        $XmlObjectWriter.WriteComment("Maximum amount of items the bot will keep on the auction house")
        $XmlObjectWriter.WriteElementString("max_items","0")
        $XmlObjectWriter.WriteEndElement()
        $XmlObjectWriter.WriteStartElement("eluna")
        $XmlObjectWriter.WriteComment("Enable/Disable the use of the Eluna LUA engine module")
        $XmlObjectWriter.WriteElementString("enabled","false")
        $XmlObjectWriter.WriteEndElement()
        $XmlObjectWriter.WriteEndElement()

        $XmlObjectWriter.WriteEndElement()

        $XmlObjectWriter.WriteEndDocument()
        $XmlObjectWriter.Flush()
        $XmlObjectWriter.Close()

        exit
    }
}

[XML]$xml = Get-Content $configFile

$error_occured = $false

if ($xml.config.mysql.hostname -eq "") { $xml.config.mysql.hostname = "127.0.0.1"; $error_occured = $true }
if (-not ($xml.config.mysql.port -match "^[\d\.]+$")) { $xml.config.mysql.port = "3306"; $error_occured = $true }
if ($xml.config.mysql.username -eq "") { $xml.config.mysql.username = "acore"; $error_occured = $true }
if ($xml.config.mysql.password -eq "") { $xml.config.mysql.password = "acore"; $error_occured = $true }
if ($xml.config.mysql.database.auth -eq "") { $xml.config.mysql.database.auth = "acore_auth"; $error_occured = $true }
if ($xml.config.mysql.database.characters -eq "") { $xml.config.mysql.database.characters = "acore_characters"; $error_occured = $true }
if ($xml.config.mysql.database.world -eq "") { $xml.config.mysql.database.world = "acore_world"; $error_occured = $true }

if ($xml.config.core.directory -eq "") { $xml.config.core.directory = "C:\AzerothCore"; $error_occured = $true }
if (-not ($xml.config.core.required_client_data -match "^[\d\.]+$")) { $xml.config.core.required_client_data = "12"; $error_occured = $true }
if (-not ($xml.config.core.installed_client_data -match "^[\d\.]+$")) { $xml.config.core.installed_client_data = "0"; $error_occured = $true }

if ($xml.config.world.name -eq "") { $xml.config.world.name = "AzerothCore"; $error_occured = $true }
if ($xml.config.world.motd -eq "") { $xml.config.world.motd = "Welcome to AzerothCore."; $error_occured = $true }
if (-not ($xml.config.world.id -match "^[\d\.]+$")) { $xml.config.world.id = "1"; $error_occured = $true }
if ($xml.config.world.address -eq "") { $xml.config.world.address = "127.0.0.1"; $error_occured = $true }
if ($xml.config.world.game_type -notin 0, 1, 6, 8) { $xml.config.world.game_type = "0"; $error_occured = $true }
if ($xml.config.world.realm_zone -notin 1, 2, 6, 9, 10, 11, 12, 14,16, 26) { $xml.config.world.realm_zone = "1"; $error_occured = $true }
if ($xml.config.world.expansion -notin 0..2) { $xml.config.world.expansion = "2"; $error_occured = $true }
if (-not ($xml.config.world.player_limit -match "^[\d\.]+$")) { $xml.config.world.player_limit = "1000"; $error_occured = $true }
if ($xml.config.world.skip_cinematics -notin 0..2) { $xml.config.world.skip_cinematics = "0"; $error_occured = $true }
if ($xml.config.world.max_level -notin 1..80) { $xml.config.world.max_level = "80"; $error_occured = $true }
if ($xml.config.world.start_level -notin 1..80) { $xml.config.world.start_level = "1"; $error_occured = $true }
if (-not ($xml.config.world.start_money -match "^[\d\.]+$")) { $xml.config.world.start_money = "0"; $error_occured = $true }
if ($xml.config.world.always_max_skill -notin 0, 1) { $xml.config.world.always_max_skill = "0"; $error_occured = $true }
if ($xml.config.world.all_flight_paths -notin 0, 1) { $xml.config.world.all_flight_paths = "0"; $error_occured = $true }
if ($xml.config.world.maps_explored -notin 0, 1) { $xml.config.world.maps_explored = "0"; $error_occured = $true }
if ($xml.config.world.allow_commands -notin 0, 1) { $xml.config.world.allow_commands = "1"; $error_occured = $true }
if ($xml.config.world.quest_ignore_raids -notin 0, 1) { $xml.config.world.quest_ignore_raids = "0"; $error_occured = $true }
if ($xml.config.world.prevent_afk_logout -notin 0, 1) { $xml.config.world.prevent_afk_logout = "0"; $error_occured = $true }
if ($xml.config.world.raf_max_level -notin 1..80) { $xml.config.world.raf_max_level = "60"; $error_occured = $true }
if ($xml.config.world.preload_map_grids -notin 0, 1) { $xml.config.world.preload_map_grids = "0"; $error_occured = $true }
if ($xml.config.world.set_all_waypoints_active -notin 0, 1) { $xml.config.world.set_all_waypoints_active = "0"; $error_occured = $true }
if ($xml.config.world.enable_minigob_manabonk -notin 0, 1) { $xml.config.world.enable_minigob_manabonk = "1"; $error_occured = $true }

if (-not ($xml.config.world.rates.experience -match "^[\d\.]+$")) { $xml.config.world.rates.experience = "1"; $error_occured = $true }
if (-not ($xml.config.world.rates.rested_exp -match "^[\d\.]+$")) { $xml.config.world.rates.rested_exp = "1"; $error_occured = $true }
if (-not ($xml.config.world.rates.reputation -match "^[\d\.]+$")) { $xml.config.world.rates.reputation = "1"; $error_occured = $true }
if (-not ($xml.config.world.rates.money -match "^[\d\.]+$")) { $xml.config.world.rates.money = "1"; $error_occured = $true }
if (-not ($xml.config.world.rates.crafting -match "^[\d\.]+$")) { $xml.config.world.rates.crafting = "1"; $error_occured = $true }
if (-not ($xml.config.world.rates.gathering -match "^[\d\.]+$")) { $xml.config.world.rates.gathering = "1"; $error_occured = $true }
if (-not ($xml.config.world.rates.weapon_skill -match "^[\d\.]+$")) { $xml.config.world.rates.weapon_skill = "1"; $error_occured = $true }
if (-not ($xml.config.world.rates.defense_skill -match "^[\d\.]+$")) { $xml.config.world.rates.defense_skill = "1"; $error_occured = $true }

if ($xml.config.world.gm.login_state -notin 0..2) { $xml.config.world.gm.login_state = "1"; $error_occured = $true }
if ($xml.config.world.gm.visible -notin 0..2) { $xml.config.world.gm.visible = "0"; $error_occured = $true }
if ($xml.config.world.gm.chat -notin 0..2) { $xml.config.world.gm.chat = "1"; $error_occured = $true }
if ($xml.config.world.gm.whisper -notin 0..2) { $xml.config.world.gm.whisper = "0"; $error_occured = $true }
if ($xml.config.world.gm.gm_list -notin 0..3) { $xml.config.world.gm.gm_list = "0"; $error_occured = $true }
if ($xml.config.world.gm.who_list -notin 0..3) { $xml.config.world.gm.who_list = "0"; $error_occured = $true }
if ($xml.config.world.gm.allow_friend -notin 0, 1) { $xml.config.world.gm.allow_friend = "0"; $error_occured = $true }
if ($xml.config.world.gm.allow_invite -notin 0, 1) { $xml.config.world.gm.allow_invite = "0"; $error_occured = $true }
if ($xml.config.world.gm.lower_security -notin 0, 1) { $xml.config.world.gm.lower_security = "0"; $error_occured = $true }

if ($xml.config.world.module.ahbot.enabled -notin "true", "false") { $xml.config.world.module.ahbot.enabled = "false"; $error_occured = $true }
if ($xml.config.world.module.ahbot.enable_buyer -notin "true", "false") { $xml.config.world.module.ahbot.enable_buyer = "false"; $error_occured = $true }
if ($xml.config.world.module.ahbot.enable_seller -notin "true", "false") { $xml.config.world.module.ahbot.enable_seller = "false"; $error_occured = $true }
if (-not ($xml.config.world.module.ahbot.account_id -match "^[\d\.]+$")) { $xml.config.world.module.ahbot.account_id = "0"; $error_occured = $true }
if (-not ($xml.config.world.module.ahbot.character_guid -match "^[\d\.]+$")) { $xml.config.world.module.ahbot.character_guid = "0"; $error_occured = $true }
if (-not ($xml.config.world.module.ahbot.min_items -match "^[\d\.]+$")) { $xml.config.world.module.ahbot.min_items = "0"; $error_occured = $true }
if (-not ($xml.config.world.module.ahbot.max_items -match "^[\d\.]+$")) { $xml.config.world.module.ahbot.max_items = "0"; $error_occured = $true }

if ($xml.config.world.module.eluna.enabled -notin "true", "false") { $xml.config.world.module.eluna.enabled = "false"; $error_occured = $true }

if ($error_occured)
{
    Write-Host -ForegroundColor Yellow "Invalid settings have been reset to their default values"
    $xml.Save($configFile)
}
else
{
    Write-Host -ForegroundColor Yellow "Successfully loaded all settings"
}
