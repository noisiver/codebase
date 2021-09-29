#!/bin/bash
ROOT=$(pwd)

CONFIG_FILE="$ROOT/azerothcore.xml"
MYSQL_CONFIG="$ROOT/mysql.cnf"

function generate_settings
{
    echo "<?xml version=\"1.0\"?>
    <config>
        <mysql>
            <!-- The ip-address or hostname used to connect to the database server -->
            <hostname>${1:-127.0.0.1}</hostname>
            <!-- The port used to connect to the database server -->
            <port>${2:-3306}</port>
            <!-- The username used to connect to the database server -->
            <username>${3:-acore}</username>
            <!-- The password used to connect to the database server -->
            <password>${4:-acore}</password>
            <database>
                <!-- The name of the auth database -->
                <auth>${5:-acore_auth}</auth>
                <!-- The name of the characters database -->
                <characters>${6:-acore_characters}</characters>
                <!-- The name of the world database -->
                <world>${7:-acore_world}</world>
            </database>
        </mysql>
        <core>
            <!-- The location where the source is located -->
            <directory>${8:-/opt/azerothcore}</directory>
            <!-- The required client data version -->
            <required_client_data>${9:-12}</required_client_data>
            <!-- The installed client data version. WARNING: DO NOT EDIT! -->
            <installed_client_data>${10:-0}</installed_client_data>
        </core>
        <world>
            <!-- The name of the realm as seen in the list in-game -->
            <name>${11:-AzerothCore}</name>
            <!-- Message of the Day, displayed at login. Use '@' for a newline and be sure to escape special characters -->
            <motd>${12:-Welcome to AzerothCore.}</motd>
            <!-- The id of the realm -->
            <id>${13:-1}</id>
            <!-- The ip or hostname used to connect to the world server. Use external ip if required -->
            <address>${14:-127.0.0.1}</address>
            <!-- Server realm type. 0 = normal, 1 = pvp, 6 = rp, 8 = rppvp -->
            <game_type>${15:-0}</game_type>
            <!-- Server realm zone. Set allowed alphabet in character, etc. names. 1 = development, 2 = united states, 6 = korea, 9 = german, 10 = french, 11 = spanish, 12 = russian, 14 = taiwan, 16 = china, 26 = test server -->
            <realm_zone>${16:-1}</realm_zone>
            <!-- Allow server to use content from expansions. Checks for expansion-related map files, client compatibility and class/race character creation. 0 = none, 1 = tbc, 2 = wotlk -->
            <expansion>${17:-2}</expansion>
            <!-- Maximum number of players in the world. Excluding Mods, GMs and Admins -->
            <player_limit>${18:-1000}</player_limit>
            <!-- Disable cinematic intro at first login after character creation. Prevents buggy intros in case of custom start location coordinates. 0 = Show intro for each new character, 1 = Show intro only for first character of selected race, 2 = Disable intro for all classes -->
            <skip_cinematics>${19:-0}</skip_cinematics>
            <!-- Maximum level that can be reached by players. Levels below 1 and above 80 will reset to 80 -->
            <max_level>${20:-80}</max_level>
            <!-- Starting level for characters after creation. Levels below 1 and above 80 will reset to 1 -->
            <start_level>${21:-1}</start_level>
            <!-- Amount of money (in Copper) that a character has after creation -->
            <start_money>${22:-0}</start_money>
            <!-- Players will automatically gain max skill level when logging in or leveling up. false = disabled, true = enabled -->
            <always_max_skill>${23:-false}</always_max_skill>
            <!-- Character knows all flight paths (of both factions) after creation. false = disabled, true = enabled -->
            <all_flight_paths>${24:-false}</all_flight_paths>
            <!-- Characters start with all maps explored. false = disabled, true = enabled -->
            <maps_explored>${25:-false}</maps_explored>
            <!-- Allow players to use commands. false = disabled, true = enabled -->
            <allow_commands>${26:-true}</allow_commands>
            <!-- Allow non-raid quests to be completed while in a raid group. false = disabled, true = enabled -->
            <quest_ignore_raid>${27:-false}</quest_ignore_raid>
            <!-- Prevent players AFK from being logged out. false = disabled, true = enabled -->
            <prevent_afk_logout>${28:-false}</prevent_afk_logout>
            <!-- Highest level up to which a character can benefit from the Recruit-A-Friend experience multiplier -->
            <raf_max_level>${29:-60}</raf_max_level>
            <!-- Preload all grids on all non-instanced maps. This will take a great amount of additional RAM (ca. 9 GB) and causes the server to take longer to start, but can increase performance if used on a server with a high amount of players. It will also activate all creatures which are set active (e.g. the Fel Reavers in Hellfire Peninsula) on server start. false = disabled, true = enabled -->
            <preload_map_grids>${30:-false}</preload_map_grids>
            <!-- Set all creatures with waypoint movement active. This means that they will start movement once they are loaded (which happens on grid load) and keep moving even when no player is near. This will increase CPU usage significantly and can be used with enabled preload_map_grids to start waypoint movement on server startup. false = disabled, true = enabled -->
            <set_all_waypoints_active>${31:-false}</set_all_waypoints_active>
            <!-- Enable/Disable Minigob Manabonk in Dalaran. false = disabled, true = enabled -->
            <enable_minigob_manabonk>${32:-true}</enable_minigob_manabonk>
            <rates>
                <!-- Experience rates (outside battleground) -->
                <experience>${33:-1}</experience>
                <!-- Resting points grow rates -->
                <rested_exp>${34:-1}</rested_exp>
                <!-- Reputation gain rate -->
                <reputation>${35:-1}</reputation>
                <!-- Drop rates for money -->
                <money>${36:-1}</money>
                <!-- Crafting skills gain rate -->
                <crafting>${37:-1}</crafting>
                <!-- Gathering skills gain rate -->
                <gathering>${38:-1}</gathering>
                <!-- Weapon skills gain rate -->
                <weapon_skill>${39:-1}</weapon_skill>
                <!-- Defense skills gain rate -->
                <defense_skill>${40:-1}</defense_skill>
            </rates>
            <gm>
                <!-- Set GM state when a GM character enters the world. false = disabled, true = enabled -->
                <login_state>${41:-true}</login_state>
                <!-- GM visibility at login. false = disabled, true = enabled -->
                <enable_visibility>${42:-false}</enable_visibility>
                <!-- GM chat mode at login. false = disabled, true = enabled -->
                <enable_chat>${43:-true}</enable_chat>
                <!-- Is GM accepting whispers from player by default or not. false = disabled, true = enabled -->
                <enable_whisper>${44:-false}</enable_whisper>
                <!-- Maximum GM level shown in GM list (if enabled) in non-GM state. 0 = only players, 1 = only moderators, 2 = only gamemasters, 3 = anyone -->
                <show_gm_list>${45:-0}</show_gm_list>
                <!-- Max GM level showed in who list (if visible). 0 = only players, 1 = only moderators, 2 = only gamemasters, 3 = anyone -->
                <show_who_list>${46:-0}</show_who_list>
                <!-- Allow players to add GM characters to their friends list. false = disabled, true = enabled -->
                <allow_friend>${47:-false}</allow_friend>
                <!-- Allow players to invite GM characters. false = disabled, true = enabled -->
                <allow_invite>${48:-false}</allow_invite>
                <!-- Allow lower security levels to use commands on higher security level characters. false = disabled, true = enabled -->
                <allow_lower_security>${49:-false}</allow_lower_security>
            </gm>
        </world>
        <module>
            <ahbot>
                <!-- Enable/Disable the use of the AHBot module -->
                <enabled>${50:-false}</enabled>
                <!-- Enable/Disable the part of AHBot that buys items from players -->
                <enable_buyer>${51:-false}</enable_buyer>
                <!-- Enable/Disable the part of AHBot that puts items up for auction -->
                <enable_seller>${52:-false}</enable_seller>
                <!-- Account id is the account number (auth->account) of the player you want to run as the auction bot -->
                <account_id>${53:-0}</account_id>
                <!-- Character guid is the GUID (characters->characters table) of the player you want to run as the auction bot -->
                <character_guid>${54:-0}</character_guid>
                <!-- Minimum amount of items the bot will keep on the auction house -->
                <min_items>${55:-0}</min_items>
                <!-- Maximum amount of items the bot will keep on the auction house -->
                <max_items>${56:-0}</max_items>
            </ahbot>
            <eluna>
                <!-- Enable/Disable the use of the Eluna LUA engine module -->
                <enabled>${57:-false}</enabled>
            </eluna>
        </module>
    </config>" | xmllint --format - > $CONFIG_FILE
}

function export_settings
{
    generate_settings \
    $MYSQL_HOSTNAME \
    $MYSQL_PORT \
    $MYSQL_USERNAME \
    $MYSQL_PASSWORD \
    $MYSQL_DATABASE_AUTH \
    $MYSQL_DATABASE_CHARACTERS \
    $MYSQL_DATABASE_WORLD \
    "$CORE_DIRECTORY" \
    $CORE_REQUIRED_CLIENT_DATA \
    $CORE_INSTALLED_CLIENT_DATA \
    "$WORLD_NAME" \
    "$WORLD_MOTD" \
    $WORLD_ID \
    $WORLD_ADDRESS \
    $WORLD_GAME_TYPE \
    $WORLD_REALM_ZONE \
    $WORLD_EXPANSION \
    $WORLD_PLAYER_LIMIT \
    $WORLD_SKIP_CINEMATICS \
    $WORLD_MAX_LEVEL \
    $WORLD_START_LEVEL \
    $WORLD_START_MONEY \
    $WORLD_ALWAYS_MAX_SKILL \
    $WORLD_ALL_FLIGHT_PATHS \
    $WORLD_MAPS_EXPLORED \
    $WORLD_ALLOW_COMMANDS \
    $WORLD_QUEST_IGNORE_RAID \
    $WORLD_PREVENT_AFK_LOGOUT \
    $WORLD_RAF_MAX_LEVEL \
    $WORLD_PRELOAD_MAP_GRIDS \
    $WORLD_SET_WAYPOINTS_ACTIVE \
    $WORLD_ENABLE_MINIGOB_MANABONK \
    $WORLD_RATE_EXPERIENCE \
    $WORLD_RATE_RESTED_EXP \
    $WORLD_RATE_REPUTATION \
    $WORLD_RATE_MONEY \
    $WORLD_RATE_CRAFTING \
    $WORLD_RATE_GATHERING \
    $WORLD_RATE_WEAPON_SKILL \
    $WORLD_RATE_DEFENSE_SKILL \
    $WORLD_GM_LOGIN_STATE \
    $WORLD_GM_ENABLE_VISIBILITY \
    $WORLD_GM_ENABLE_CHAT \
    $WORLD_GM_ENABLE_WHISPER \
    $WORLD_GM_SHOW_GM_LIST \
    $WORLD_GM_SHOW_WHO_LIST \
    $WORLD_GM_ALLOW_FRIEND \
    $WORLD_GM_ALLOW_INVITE \
    $WORLD_GM_ALLOW_LOWER_SECURITY \
    $MODULE_AHBOT_ENABLED \
    $MODULE_AHBOT_ENABLE_BUYER \
    $MODULE_AHBOT_ENABLE_SELLER \
    $MODULE_AHBOT_ACCOUNT_ID \
    $MODULE_AHBOT_CHARACTER_GUID \
    $MODULE_AHBOT_MIN_ITEMS \
    $MODULE_AHBOT_MAX_ITEMS \
    $MODULE_ELUNA_ENABLED
}

if [ ! -f $CONFIG_FILE ]; then
    clear
    printf "${COLOR_ORANGE}Generating default configuration${COLOR_END}\n"
    generate_settings
    exit $?
fi

clear

printf "${COLOR_GREEN}Loading configuration${COLOR_END}\n"

MYSQL_HOSTNAME="$(echo "cat /config/mysql/hostname/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_PORT="$(echo "cat /config/mysql/port/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_USERNAME="$(echo "cat /config/mysql/username/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_PASSWORD="$(echo "cat /config/mysql/password/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_AUTH="$(echo "cat /config/mysql/database/auth/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_CHARACTERS="$(echo "cat /config/mysql/database/characters/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_WORLD="$(echo "cat /config/mysql/database/world/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

CORE_DIRECTORY="$(echo "cat /config/core/directory/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
CORE_REQUIRED_CLIENT_DATA="$(echo "cat /config/core/required_client_data/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
CORE_INSTALLED_CLIENT_DATA="$(echo "cat /config/core/installed_client_data/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

WORLD_NAME="$(echo "cat /config/world/name/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_MOTD="$(echo "cat /config/world/motd/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_ID="$(echo "cat /config/world/id/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_ADDRESS="$(echo "cat /config/world/address/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_GAME_TYPE="$(echo "cat /config/world/game_type/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_REALM_ZONE="$(echo "cat /config/world/realm_zone/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_EXPANSION="$(echo "cat /config/world/expansion/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_PLAYER_LIMIT="$(echo "cat /config/world/player_limit/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_SKIP_CINEMATICS="$(echo "cat /config/world/skip_cinematics/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_MAX_LEVEL="$(echo "cat /config/world/max_level/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_START_LEVEL="$(echo "cat /config/world/start_level/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_START_MONEY="$(echo "cat /config/world/start_money/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_ALWAYS_MAX_SKILL="$(echo "cat /config/world/always_max_skill/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_ALL_FLIGHT_PATHS="$(echo "cat /config/world/all_flight_paths/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_MAPS_EXPLORED="$(echo "cat /config/world/maps_explored/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_ALLOW_COMMANDS="$(echo "cat /config/world/allow_commands/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_QUEST_IGNORE_RAID="$(echo "cat /config/world/quest_ignore_raid/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_PREVENT_AFK_LOGOUT="$(echo "cat /config/world/prevent_afk_logout/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_RAF_MAX_LEVEL="$(echo "cat /config/world/raf_max_level/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_PRELOAD_MAP_GRIDS="$(echo "cat /config/world/preload_map_grids/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_SET_WAYPOINTS_ACTIVE="$(echo "cat /config/world/set_all_waypoints_active/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_ENABLE_MINIGOB_MANABONK="$(echo "cat /config/world/enable_minigob_manabonk/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

WORLD_RATE_EXPERIENCE="$(echo "cat /config/world/rates/experience/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_RESTED_EXP="$(echo "cat /config/world/rates/rested_exp/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_REPUTATION="$(echo "cat /config/world/rates/reputation/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_MONEY="$(echo "cat /config/world/rates/money/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_CRAFTING="$(echo "cat /config/world/rates/crafting/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_GATHERING="$(echo "cat /config/world/rates/gathering/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_WEAPON_SKILL="$(echo "cat /config/world/rates/weapon_skill/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_DEFENSE_SKILL="$(echo "cat /config/world/rates/defense_skill/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

WORLD_GM_LOGIN_STATE="$(echo "cat /config/world/gm/login_state/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_GM_ENABLE_VISIBILITY="$(echo "cat /config/world/gm/enable_visibility/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_GM_ENABLE_CHAT="$(echo "cat /config/world/gm/enable_chat/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_GM_ENABLE_WHISPER="$(echo "cat /config/world/gm/enable_whisper/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_GM_SHOW_GM_LIST="$(echo "cat /config/world/gm/show_gm_list/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_GM_SHOW_WHO_LIST="$(echo "cat /config/world/gm/show_who_list/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_GM_ALLOW_FRIEND="$(echo "cat /config/world/gm/allow_friend/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_GM_ALLOW_INVITE="$(echo "cat /config/world/gm/allow_invite/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
WORLD_GM_ALLOW_LOWER_SECURITY="$(echo "cat /config/world/gm/allow_lower_security/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

MODULE_AHBOT_ENABLED="$(echo "cat /config/module/ahbot/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_ENABLE_BUYER="$(echo "cat /config/module/ahbot/enable_buyer/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_ENABLE_SELLER="$(echo "cat /config/module/ahbot/enable_seller/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_ACCOUNT_ID="$(echo "cat /config/module/ahbot/account_id/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_CHARACTER_GUID="$(echo "cat /config/module/ahbot/character_guid/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_MIN_ITEMS="$(echo "cat /config/module/ahbot/min_items/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_MAX_ITEMS="$(echo "cat /config/module/ahbot/max_items/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

MODULE_ELUNA_ENABLED="$(echo "cat /config/module/eluna/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

if [[ -z $MYSQL_HOSTNAME ]] || [[ $MYSQL_HOSTNAME == "" ]]; then
    MYSQL_HOSTNAME="127.0.0.1"
    REQUIRE_EXPORT=true
fi

if [[ -z $MYSQL_PORT ]] || [[ $MYSQL_PORT == "" ]] || [[ ! $MYSQL_PORT =~ ^[0-9]+$ ]]; then
    MYSQL_PORT="3306"
    REQUIRE_EXPORT=true
fi

if [[ -z $MYSQL_USERNAME ]] || [[ $MYSQL_USERNAME == "" ]]; then
    MYSQL_USERNAME="acore"
    REQUIRE_EXPORT=true
fi

if [[ -z $MYSQL_PASSWORD ]] || [[ $MYSQL_PASSWORD == "" ]]; then
    MYSQL_PASSWORD="acore"
    REQUIRE_EXPORT=true
fi

if [[ -z $MYSQL_DATABASE_AUTH ]] || [[ $MYSQL_DATABASE_AUTH == "" ]]; then
    MYSQL_DATABASE_AUTH="acore_auth"
    REQUIRE_EXPORT=true
fi

if [[ -z $MYSQL_DATABASE_CHARACTERS ]] || [[ $MYSQL_DATABASE_CHARACTERS == "" ]]; then
    MYSQL_DATABASE_CHARACTERS="acore_auth"
    REQUIRE_EXPORT=true
fi

if [[ -z $MYSQL_DATABASE_WORLD ]] || [[ $MYSQL_DATABASE_WORLD == "" ]]; then
    MYSQL_DATABASE_WORLD="acore_auth"
    REQUIRE_EXPORT=true
fi

if [[ -z $CORE_DIRECTORY ]] || [[ $CORE_DIRECTORY == "" ]]; then
    CORE_DIRECTORY="/opt/azerothcore"
    REQUIRE_EXPORT=true
fi

if [[ -z $CORE_REQUIRED_CLIENT_DATA ]] || [[ $CORE_REQUIRED_CLIENT_DATA == "" ]]; then
    CORE_REQUIRED_CLIENT_DATA="12"
    REQUIRE_EXPORT=true
fi

if [[ -z $CORE_INSTALLED_CLIENT_DATA ]] || [[ $CORE_INSTALLED_CLIENT_DATA == "" ]] || [[ $CORE_INSTALLED_CLIENT_DATA -gt $CORE_REQUIRED_CLIENT_DATA ]]; then
    CORE_INSTALLED_CLIENT_DATA="0"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_NAME ]] || [[ $WORLD_NAME == "" ]]; then
    WORLD_NAME="AzerothCore"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_MOTD ]] || [[ $WORLD_MOTD == "" ]]; then
    WORLD_MOTD="Welcome to AzerothCore."
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_ID ]] || [[ $WORLD_ID == "" ]] || [[ ! $WORLD_ID =~ ^[0-9]+$ ]]; then
    WORLD_ID="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_ADDRESS ]] || [[ $WORLD_ADDRESS == "" ]]; then
    WORLD_ADDRESS="127.0.0.1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_GAME_TYPE ]] || [[ $WORLD_GAME_TYPE == "" ]] || [[ ! $WORLD_GAME_TYPE =~ ^[0-9]+$ ]] || [[ $WORLD_GAME_TYPE != 0 && $WORLD_GAME_TYPE != 1 && $WORLD_GAME_TYPE != 6 && $WORLD_GAME_TYPE != 8 ]]; then
    WORLD_GAME_TYPE="0"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_REALM_ZONE ]] || [[ $WORLD_REALM_ZONE == "" ]] || [[ ! $WORLD_REALM_ZONE =~ ^[0-9]+$ ]] || [[ $WORLD_REALM_ZONE != 1 && $WORLD_REALM_ZONE != 2 && $WORLD_REALM_ZONE != 6 && $WORLD_REALM_ZONE != 9 && $WORLD_REALM_ZONE != 10 && $WORLD_REALM_ZONE != 11 && $WORLD_REALM_ZONE != 12 && $WORLD_REALM_ZONE != 14 && $WORLD_REALM_ZONE != 16 && $WORLD_REALM_ZONE != 26 ]]; then
    WORLD_REALM_ZONE="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_EXPANSION ]] || [[ $WORLD_EXPANSION == "" ]] || [[ ! $WORLD_EXPANSION =~ ^[0-9]+$ ]] || [[ $WORLD_EXPANSION != 0 && $WORLD_EXPANSION != 1 && $WORLD_EXPANSION != 2 ]]; then
    WORLD_EXPANSION="2"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_PLAYER_LIMIT ]] || [[ $WORLD_PLAYER_LIMIT == "" ]] || [[ ! $WORLD_PLAYER_LIMIT =~ ^[0-9]+$ ]]; then
    WORLD_PLAYER_LIMIT="1000"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_SKIP_CINEMATICS ]] || [[ $WORLD_SKIP_CINEMATICS == "" ]] || [[ ! $WORLD_SKIP_CINEMATICS =~ ^[0-9]+$ ]] || [[ $WORLD_SKIP_CINEMATICS != 0 && $WORLD_SKIP_CINEMATICS != 1 && $WORLD_SKIP_CINEMATICS != 2 ]]; then
    WORLD_SKIP_CINEMATICS="0"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_MAX_LEVEL ]] || [[ $WORLD_MAX_LEVEL == "" ]] || [[ ! $WORLD_MAX_LEVEL =~ ^[0-9]+$ ]] || [[ $WORLD_MAX_LEVEL < 1 || $WORLD_MAX_LEVEL > 80 ]]; then
    WORLD_MAX_LEVEL="80"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_START_LEVEL ]] || [[ $WORLD_START_LEVEL == "" ]] || [[ ! $WORLD_START_LEVEL =~ ^[0-9]+$ ]] || [[ $WORLD_START_LEVEL < 1 || $WORLD_START_LEVEL > 80 ]]; then
    WORLD_START_LEVEL="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_START_MONEY ]] || [[ $WORLD_START_MONEY == "" ]] || [[ ! $WORLD_START_MONEY =~ ^[0-9]+$ ]]; then
    WORLD_START_MONEY="0"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_ALWAYS_MAX_SKILL ]] || [[ $WORLD_ALWAYS_MAX_SKILL == "" ]] || [[ $WORLD_ALWAYS_MAX_SKILL != "true" && $WORLD_ALWAYS_MAX_SKILL != "false" ]]; then
    WORLD_ALWAYS_MAX_SKILL="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_ALL_FLIGHT_PATHS ]] || [[ $WORLD_ALL_FLIGHT_PATHS == "" ]] || [[ $WORLD_ALL_FLIGHT_PATHS != "true" && $WORLD_ALL_FLIGHT_PATHS != "false" ]]; then
    WORLD_ALL_FLIGHT_PATHS="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_MAPS_EXPLORED ]] || [[ $WORLD_MAPS_EXPLORED == "" ]] || [[ $WORLD_MAPS_EXPLORED != "true" && $WORLD_MAPS_EXPLORED != "false" ]]; then
    WORLD_MAPS_EXPLORED="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_ALLOW_COMMANDS ]] || [[ $WORLD_ALLOW_COMMANDS == "" ]] || [[ $WORLD_ALLOW_COMMANDS != "true" && $WORLD_ALLOW_COMMANDS != "false" ]]; then
    WORLD_ALLOW_COMMANDS="true"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_QUEST_IGNORE_RAID ]] || [[ $WORLD_QUEST_IGNORE_RAID == "" ]] || [[ $WORLD_QUEST_IGNORE_RAID != "true" && $WORLD_QUEST_IGNORE_RAID != "false" ]]; then
    WORLD_QUEST_IGNORE_RAID="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_PREVENT_AFK_LOGOUT ]] || [[ $WORLD_PREVENT_AFK_LOGOUT == "" ]] || [[ $WORLD_PREVENT_AFK_LOGOUT != "true" && $WORLD_PREVENT_AFK_LOGOUT != "false" ]]; then
    WORLD_PREVENT_AFK_LOGOUT="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_RAF_MAX_LEVEL ]] || [[ $WORLD_RAF_MAX_LEVEL == "" ]] || [[ ! $WORLD_RAF_MAX_LEVEL =~ ^[0-9]+$ ]] || [[ $WORLD_RAF_MAX_LEVEL < 1 || $WORLD_RAF_MAX_LEVEL > 80 ]]; then
    WORLD_RAF_MAX_LEVEL="60"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_PRELOAD_MAP_GRIDS ]] || [[ $WORLD_PRELOAD_MAP_GRIDS == "" ]] || [[ $WORLD_PRELOAD_MAP_GRIDS != "true" && $WORLD_PRELOAD_MAP_GRIDS != "false" ]]; then
    WORLD_PRELOAD_MAP_GRIDS="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_SET_WAYPOINTS_ACTIVE ]] || [[ $WORLD_SET_WAYPOINTS_ACTIVE == "" ]] || [[ $WORLD_SET_WAYPOINTS_ACTIVE != "true" && $WORLD_SET_WAYPOINTS_ACTIVE != "false" ]]; then
    WORLD_SET_WAYPOINTS_ACTIVE="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_ENABLE_MINIGOB_MANABONK ]] || [[ $WORLD_ENABLE_MINIGOB_MANABONK == "" ]] || [[ $WORLD_ENABLE_MINIGOB_MANABONK != "true" && $WORLD_ENABLE_MINIGOB_MANABONK != "false" ]]; then
    WORLD_ENABLE_MINIGOB_MANABONK="true"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_RATE_EXPERIENCE ]] || [[ $WORLD_RATE_EXPERIENCE == "" ]] || [[ ! $WORLD_RATE_EXPERIENCE =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_EXPERIENCE < 1 ]]; then
    WORLD_RATE_EXPERIENCE="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_RATE_RESTED_EXP ]] || [[ $WORLD_RATE_RESTED_EXP == "" ]] || [[ ! $WORLD_RATE_RESTED_EXP =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_RESTED_EXP < 1 ]]; then
    WORLD_RATE_RESTED_EXP="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_RATE_REPUTATION ]] || [[ $WORLD_RATE_REPUTATION == "" ]] || [[ ! $WORLD_RATE_REPUTATION =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_REPUTATION < 1 ]]; then
    WORLD_RATE_REPUTATION="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_RATE_MONEY ]] || [[ $WORLD_RATE_MONEY == "" ]] || [[ ! $WORLD_RATE_MONEY =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_MONEY < 1 ]]; then
    WORLD_RATE_MONEY="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_RATE_CRAFTING ]] || [[ $WORLD_RATE_CRAFTING == "" ]] || [[ ! $WORLD_RATE_CRAFTING =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_CRAFTING < 1 ]]; then
    WORLD_RATE_CRAFTING="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_RATE_GATHERING ]] || [[ $WORLD_RATE_GATHERING == "" ]] || [[ ! $WORLD_RATE_GATHERING =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_GATHERING < 1 ]]; then
    WORLD_RATE_GATHERING="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_RATE_WEAPON_SKILL ]] || [[ $WORLD_RATE_WEAPON_SKILL == "" ]] || [[ ! $WORLD_RATE_WEAPON_SKILL =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_WEAPON_SKILL < 1 ]]; then
    WORLD_RATE_WEAPON_SKILL="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_RATE_DEFENSE_SKILL ]] || [[ $WORLD_RATE_DEFENSE_SKILL == "" ]] || [[ ! $WORLD_RATE_DEFENSE_SKILL =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_DEFENSE_SKILL < 1 ]]; then
    WORLD_RATE_DEFENSE_SKILL="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_GM_LOGIN_STATE ]] || [[ $WORLD_GM_LOGIN_STATE == "" ]] || [[ $WORLD_GM_LOGIN_STATE != "true" && $WORLD_GM_LOGIN_STATE != "false" ]]; then
    WORLD_GM_LOGIN_STATE="true"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_GM_ENABLE_VISIBILITY ]] || [[ $WORLD_GM_ENABLE_VISIBILITY == "" ]] || [[ $WORLD_GM_ENABLE_VISIBILITY != "true" && $WORLD_GM_ENABLE_VISIBILITY != "false" ]]; then
    WORLD_GM_ENABLE_VISIBILITY="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_GM_ENABLE_CHAT ]] || [[ $WORLD_GM_ENABLE_CHAT == "" ]] || [[ $WORLD_GM_ENABLE_CHAT != "true" && $WORLD_GM_ENABLE_CHAT != "false" ]]; then
    WORLD_GM_ENABLE_CHAT="true"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_GM_ENABLE_WHISPER ]] || [[ $WORLD_GM_ENABLE_WHISPER == "" ]] || [[ $WORLD_GM_ENABLE_WHISPER != "true" && $WORLD_GM_ENABLE_WHISPER != "false" ]]; then
    WORLD_GM_ENABLE_WHISPER="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_GM_SHOW_GM_LIST ]] || [[ $WORLD_GM_SHOW_GM_LIST == "" ]] || [[ ! $WORLD_GM_SHOW_GM_LIST =~ ^[0-9]+$ ]] || [[ $WORLD_GM_SHOW_GM_LIST != 0 && $WORLD_GM_SHOW_GM_LIST != 1 && $WORLD_GM_SHOW_GM_LIST != 2 && $WORLD_GM_SHOW_GM_LIST != 3 ]]; then
    WORLD_GM_SHOW_GM_LIST="0"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_GM_SHOW_WHO_LIST ]] || [[ $WORLD_GM_SHOW_WHO_LIST == "" ]] || [[ ! $WORLD_GM_SHOW_WHO_LIST =~ ^[0-9]+$ ]] || [[ $WORLD_GM_SHOW_WHO_LIST != 0 && $WORLD_GM_SHOW_WHO_LIST != 1 && $WORLD_GM_SHOW_WHO_LIST != 2 && $WORLD_GM_SHOW_WHO_LIST != 3 ]]; then
    WORLD_GM_SHOW_WHO_LIST="0"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_GM_ALLOW_FRIEND ]] || [[ $WORLD_GM_ALLOW_FRIEND == "" ]] || [[ $WORLD_GM_ALLOW_FRIEND != "true" && $WORLD_GM_ALLOW_FRIEND != "false" ]]; then
    WORLD_GM_ALLOW_FRIEND="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_GM_ALLOW_INVITE ]] || [[ $WORLD_GM_ALLOW_INVITE == "" ]] || [[ $WORLD_GM_ALLOW_INVITE != "true" && $WORLD_GM_ALLOW_INVITE != "false" ]]; then
    WORLD_GM_ALLOW_INVITE="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_GM_ALLOW_LOWER_SECURITY ]] || [[ $WORLD_GM_ALLOW_LOWER_SECURITY == "" ]] || [[ $WORLD_GM_ALLOW_LOWER_SECURITY != "true" && $WORLD_GM_ALLOW_LOWER_SECURITY != "false" ]]; then
    WORLD_GM_ALLOW_LOWER_SECURITY="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $MODULE_AHBOT_ENABLED ]] || [[ $MODULE_AHBOT_ENABLED == "" ]] || [[ $MODULE_AHBOT_ENABLED != "true" && $MODULE_AHBOT_ENABLED != "false" ]]; then
    MODULE_AHBOT_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $MODULE_AHBOT_ENABLE_BUYER ]] || [[ $MODULE_AHBOT_ENABLE_BUYER == "" ]] || [[ $MODULE_AHBOT_ENABLE_BUYER != "true" && $MODULE_AHBOT_ENABLE_BUYER != "false" ]]; then
    MODULE_AHBOT_ENABLE_BUYER="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $MODULE_AHBOT_ENABLE_SELLER ]] || [[ $MODULE_AHBOT_ENABLE_SELLER == "" ]] || [[ $MODULE_AHBOT_ENABLE_SELLER != "true" && $MODULE_AHBOT_ENABLE_SELLER != "false" ]]; then
    MODULE_AHBOT_ENABLE_SELLER="false"
    REQUIRE_EXPORT=true
fi

if [[ -z $MODULE_AHBOT_ACCOUNT_ID ]] || [[ $MODULE_AHBOT_ACCOUNT_ID == "" ]] || [[ ! $MODULE_AHBOT_ACCOUNT_ID =~ ^[0-9]+$ ]]; then
    MODULE_AHBOT_ACCOUNT_ID="0"
    REQUIRE_EXPORT=true
fi

if [[ -z $MODULE_AHBOT_CHARACTER_GUID ]] || [[ $MODULE_AHBOT_CHARACTER_GUID == "" ]] || [[ ! $MODULE_AHBOT_CHARACTER_GUID =~ ^[0-9]+$ ]]; then
    MODULE_AHBOT_CHARACTER_GUID="0"
    REQUIRE_EXPORT=true
fi

if [[ -z $MODULE_AHBOT_MIN_ITEMS ]] || [[ $MODULE_AHBOT_MIN_ITEMS == "" ]] || [[ ! $MODULE_AHBOT_MIN_ITEMS =~ ^[0-9]+$ ]]; then
    MODULE_AHBOT_MIN_ITEMS="0"
    REQUIRE_EXPORT=true
fi

if [[ -z $MODULE_AHBOT_MAX_ITEMS ]] || [[ $MODULE_AHBOT_MAX_ITEMS == "" ]] || [[ ! $MODULE_AHBOT_MAX_ITEMS =~ ^[0-9]+$ ]]; then
    MODULE_AHBOT_MAX_ITEMS="0"
    REQUIRE_EXPORT=true
fi

if [[ -z $MODULE_ELUNA_ENABLED ]] || [[ $MODULE_ELUNA_ENABLED == "" ]] || [[ $MODULE_ELUNA_ENABLED != "true" && $MODULE_ELUNA_ENABLED != "false" ]]; then
    MODULE_ELUNA_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [ $REQUIRE_EXPORT ]; then
    printf "${COLOR_ORANGE}Invalid settings have been reset to their default values${COLOR_END}\n"
    export_settings
else
    printf "${COLOR_ORANGE}Successfully loaded all settings${COLOR_END}\n"
fi

function update_configuration
{
    clear

    printf "${COLOR_GREEN}Updating configuration files${COLOR_END}\n"

    if [[ $1 == 0 || $1 == 1 && -z $2 ]] || [[ $1 == 1 && $2 == 1 ]]; then
        if [ -f $CORE_DIRECTORY/etc/authserver.conf.dist ]; then
            printf "${COLOR_ORANGE}Updating authserver.conf${COLOR_END}\n"

            cp $CORE_DIRECTORY/etc/authserver.conf.dist $CORE_DIRECTORY/etc/authserver.conf

            sed -i 's/LoginDatabaseInfo =.*/LoginDatabaseInfo = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASE_AUTH'"/g' $CORE_DIRECTORY/etc/authserver.conf
            sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 0/g' $CORE_DIRECTORY/etc/authserver.conf
        fi
    fi

    if [[ $1 == 0 || $1 == 2 && -z $2 ]] || [[ $1 == 2 && $2 == 1 ]]; then
        if [ -f $CORE_DIRECTORY/etc/worldserver.conf.dist ]; then
            printf "${COLOR_ORANGE}Updating worldserver.conf${COLOR_END}\n"

            [ $WORLD_ALWAYS_MAX_SKILL == "true" ] && WORLD_MAX_SKILL_INT=1 || WORLD_MAX_SKILL_INT=0
            [ $WORLD_ALL_FLIGHT_PATHS == "true" ] && WORLD_ALL_FLIGHT_PATHS_INT=1 || WORLD_ALL_FLIGHT_PATHS_INT=0
            [ $WORLD_MAPS_EXPLORED == "true" ] && WORLD_MAPS_EXPLORED_INT=1 || WORLD_MAPS_EXPLORED_INT=0
            [ $WORLD_ALLOW_COMMANDS == "true" ] && WORLD_ALLOW_COMMANDS_INT=1 || WORLD_ALLOW_COMMANDS_INT=0
            [ $WORLD_QUEST_IGNORE_RAID == "true" ] && WORLD_QUEST_IGNORE_RAID_INT=1 || WORLD_QUEST_IGNORE_RAID_INT=0
            [ $WORLD_PREVENT_AFK_LOGOUT == "true" ] && WORLD_PREVENT_AFK_LOGOUT_INT=1 || WORLD_PREVENT_AFK_LOGOUT_INT=0
            [ $WORLD_PRELOAD_MAP_GRIDS == "true" ] && WORLD_PRELOAD_MAP_GRIDS_INT=1 || WORLD_PRELOAD_MAP_GRIDS_INT=0
            [ $WORLD_SET_WAYPOINTS_ACTIVE == "true" ] && WORLD_SET_WAYPOINTS_ACTIVE_INT=1 || WORLD_SET_WAYPOINTS_ACTIVE_INT=0
            [ $WORLD_ENABLE_MINIGOB_MANABONK == "true" ] && WORLD_ENABLE_MINIGOB_MANABONK_INT=1 || WORLD_ENABLE_MINIGOB_MANABONK_INT=0
            [ $WORLD_GM_LOGIN_STATE == "true" ] && WORLD_GM_LOGIN_STATE_INT=1 || WORLD_GM_LOGIN_STATE_INT=0
            [ $WORLD_GM_ENABLE_VISIBILITY == "true" ] && WORLD_GM_ENABLE_VISIBILITY_INT=1 || WORLD_GM_ENABLE_VISIBILITY_INT=0
            [ $WORLD_GM_ENABLE_CHAT == "true" ] && WORLD_GM_ENABLE_CHAT_INT=1 || WORLD_GM_ENABLE_CHAT_INT=0
            [ $WORLD_GM_ENABLE_WHISPER == "true" ] && WORLD_GM_ENABLE_WHISPER_INT=1 || WORLD_GM_ENABLE_WHISPER_INT=0
            [ $WORLD_GM_ALLOW_INVITE == "true" ] && WORLD_GM_ALLOW_INVITE_INT=1 || WORLD_GM_ALLOW_INVITE_INT=0
            [ $WORLD_GM_ALLOW_FRIEND == "true" ] && WORLD_GM_ALLOW_FRIEND_INT=1 || WORLD_GM_ALLOW_FRIEND_INT=0
            [ $WORLD_GM_ALLOW_LOWER_SECURITY == "true" ] && WORLD_GM_ALLOW_LOWER_SECURITY_INT=1 || WORLD_GM_ALLOW_LOWER_SECURITY_INT=0

            cp $CORE_DIRECTORY/etc/worldserver.conf.dist $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/LoginDatabaseInfo     =.*/LoginDatabaseInfo     = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASE_AUTH'"/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/WorldDatabaseInfo     =.*/WorldDatabaseInfo     = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASE_WORLD'"/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/CharacterDatabaseInfo =.*/CharacterDatabaseInfo = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASE_CHARACTERS'"/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 0/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Ra.Enable =.*/Ra.Enable = 1/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/RealmID =.*/RealmID = '$WORLD_ID'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GameType =.*/GameType = '$WORLD_GAME_TYPE'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/RealmZone =.*/RealmZone = '$WORLD_REALM_ZONE'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Expansion =.*/Expansion = '$WORLD_EXPANSION'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/PlayerLimit =.*/PlayerLimit = '$WORLD_PLAYER_LIMIT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/StrictPlayerNames =.*/StrictPlayerNames = 3/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/StrictCharterNames =.*/StrictCharterNames = 3/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/StrictPetNames =.*/StrictPetNames = 3/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Motd =.*/Motd = "'"$WORLD_MOTD"'"/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/SkipCinematics =.*/SkipCinematics = '$WORLD_SKIP_CINEMATICS'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/MaxPlayerLevel =.*/MaxPlayerLevel = '$WORLD_MAX_LEVEL'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/StartPlayerLevel =.*/StartPlayerLevel = '$WORLD_START_LEVEL'/g' $CORE_DIRECTORY/etc/worldserver.conf
            if [ $WORLD_START_LEVEL -ge 55 ]; then
                sed -i 's/StartHeroicPlayerLevel =.*/StartHeroicPlayerLevel = '$WORLD_START_LEVEL'/g' $CORE_DIRECTORY/etc/worldserver.conf
            fi
            sed -i 's/StartPlayerMoney =.*/StartPlayerMoney = '$WORLD_START_MONEY'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/AllFlightPaths =.*/AllFlightPaths = '$WORLD_ALL_FLIGHT_PATHS_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/AlwaysMaxSkillForLevel =.*/AlwaysMaxSkillForLevel = '$WORLD_MAX_SKILL_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/PlayerStart.MapsExplored =.*/PlayerStart.MapsExplored = '$WORLD_MAPS_EXPLORED_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/AllowPlayerCommands =.*/AllowPlayerCommands = '$WORLD_ALLOW_COMMANDS_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Quests.IgnoreRaid =.*/Quests.IgnoreRaid = '$WORLD_QUEST_IGNORE_RAID_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/PreventAFKLogout =.*/PreventAFKLogout = '$WORLD_PREVENT_AFK_LOGOUT_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/RecruitAFriend.MaxLevel =.*/RecruitAFriend.MaxLevel = '$WORLD_RAF_MAX_LEVEL'/g' $CORE_DIRECTORY/etc/worldserver.conf

            sed -i 's/PreloadAllNonInstancedMapGrids =.*/PreloadAllNonInstancedMapGrids = '$WORLD_PRELOAD_MAP_GRIDS_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/SetAllCreaturesWithWaypointMovementActive =.*/SetAllCreaturesWithWaypointMovementActive = '$WORLD_SET_WAYPOINTS_ACTIVE_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf

            sed -i 's/Minigob.Manabonk.Enable =.*/Minigob.Manabonk.Enable = '$WORLD_ENABLE_MINIGOB_MANABONK_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf

            sed -i 's/Rate.Drop.Money                 =.*/Rate.Drop.Money                 = '$WORLD_RATE_MONEY'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Rate.XP.Kill    =.*/Rate.XP.Kill    = '$WORLD_RATE_EXPERIENCE'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Rate.XP.Quest   =.*/Rate.XP.Quest   = '$WORLD_RATE_EXPERIENCE'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Rate.XP.Explore =.*/Rate.XP.Explore = '$WORLD_RATE_EXPERIENCE'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Rate.XP.Pet     =.*/Rate.XP.Pet     = '$WORLD_RATE_EXPERIENCE'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Rate.Reputation.Gain =.*/Rate.Reputation.Gain = '$WORLD_RATE_REPUTATION'/g' $CORE_DIRECTORY/etc/worldserver.conf

            sed -i 's/SkillGain.Crafting  =.*/SkillGain.Crafting  = '$WORLD_RATE_CRAFTING'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/SkillGain.Defense   =.*/SkillGain.Defense   = '$WORLD_RATE_DEFENSE_SKILL'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/SkillGain.Gathering =.*/SkillGain.Gathering = '$WORLD_RATE_GATHERING'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/SkillGain.Weapon    =.*/SkillGain.Weapon    = '$WORLD_RATE_WEAPON_SKILL'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Rate.Rest.InGame                 =.*/Rate.Rest.InGame                 = '$WORLD_RATE_RESTED_EXP'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Rate.Rest.Offline.InTavernOrCity =.*/Rate.Rest.Offline.InTavernOrCity = '$WORLD_RATE_RESTED_EXP'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Rate.Rest.Offline.InWilderness   =.*/Rate.Rest.Offline.InWilderness   = '$WORLD_RATE_RESTED_EXP'/g' $CORE_DIRECTORY/etc/worldserver.conf

            sed -i 's/GM.LoginState =.*/GM.LoginState = '$WORLD_GM_LOGIN_STATE_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.Visible =.*/GM.Visible = '$WORLD_GM_ENABLE_VISIBILITY_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.Chat =.*/GM.Chat = '$WORLD_GM_ENABLE_CHAT_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.WhisperingTo =.*/GM.WhisperingTo = '$WORLD_GM_ENABLE_WHISPER_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.InGMList.Level =.*/GM.InGMList.Level = '$WORLD_GM_SHOW_GM_LIST'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.InWhoList.Level =.*/GM.InWhoList.Level = '$WORLD_GM_SHOW_WHO_LIST'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.StartLevel = .*/GM.StartLevel = '$WORLD_START_LEVEL'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.AllowInvite =.*/GM.AllowInvite = '$WORLD_GM_ALLOW_INVITE_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.AllowFriend =.*/GM.AllowFriend = '$WORLD_GM_ALLOW_FRIEND_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.LowerSecurity =.*/GM.LowerSecurity = '$WORLD_GM_ALLOW_LOWER_SECURITY_INT'/g' $CORE_DIRECTORY/etc/worldserver.conf

            sed -i 's/Warden.Enabled =.*/Warden.Enabled = 0/g' $CORE_DIRECTORY/etc/worldserver.conf
        fi
    fi

    if [[ $1 == 0 || $1 == 2 && -z $2 ]] || [[ $1 == 2 && $2 == 2 ]]; then
        if [ $MODULE_AHBOT_ENABLED == "true" ]; then
            if [ -f $CORE_DIRECTORY/etc/modules/mod_ahbot.conf.dist ]; then
                printf "${COLOR_ORANGE}Updating mod_ahbot.conf${COLOR_END}\n"

                cp $CORE_DIRECTORY/etc/modules/mod_ahbot.conf.dist $CORE_DIRECTORY/etc/modules/mod_ahbot.conf

                [ $MODULE_AHBOT_ENABLE_BUYER == "true" ] && ENABLE_BUYER=1 || ENABLE_BUYER=0
                [ $MODULE_AHBOT_ENABLE_SELLER == "true" ] && ENABLE_SELLER=1 || ENABLE_SELLER=0

                sed -i 's/AuctionHouseBot.EnableBuyer =.*/AuctionHouseBot.EnableBuyer = '$ENABLE_BUYER'/g' $CORE_DIRECTORY/etc/modules/mod_ahbot.conf
                sed -i 's/AuctionHouseBot.EnableSeller =.*/AuctionHouseBot.EnableSeller = '$ENABLE_SELLER'/g' $CORE_DIRECTORY/etc/modules/mod_ahbot.conf
                sed -i 's/AuctionHouseBot.Account =.*/AuctionHouseBot.Account = '$MODULE_AHBOT_ACCOUNT_ID'/g' $CORE_DIRECTORY/etc/modules/mod_ahbot.conf
                sed -i 's/AuctionHouseBot.GUID =.*/AuctionHouseBot.GUID = '$MODULE_AHBOT_CHARACTER_GUID'/g' $CORE_DIRECTORY/etc/modules/mod_ahbot.conf
            fi
        else
            if [ -f $CORE_DIRECTORY/etc/modules/mod_ahbot.conf ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/mod_ahbot.conf
            fi

            if [ -f $CORE_DIRECTORY/etc/modules/mod_ahbot.conf.dist ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/mod_ahbot.conf.dist
            fi
        fi
    fi

    if [[ $1 == 0 || $1 == 2 && -z $2 ]] || [[ $1 == 2 && $2 == 3 ]]; then
        if [ $MODULE_ELUNA_ENABLED == "true" ]; then
            if [ -f $CORE_DIRECTORY/etc/modules/mod_LuaEngine.conf.dist ]; then
                printf "${COLOR_ORANGE}Updating mod_LuaEngine.conf${COLOR_END}\n"

                cp $CORE_DIRECTORY/etc/modules/mod_LuaEngine.conf.dist $CORE_DIRECTORY/etc/modules/mod_LuaEngine.conf
            fi
        else
            if [ -f $CORE_DIRECTORY/etc/modules/mod_LuaEngine.conf ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/mod_LuaEngine.conf
            fi

            if [ -f $CORE_DIRECTORY/etc/modules/mod_LuaEngine.conf.dist ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/mod_LuaEngine.conf.dist
            fi
        fi
    fi
}
