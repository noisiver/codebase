#!/bin/bash
ROOT=$(pwd)

CONFIG_FILE="azerothcore.xml"
MYSQL_CONFIG="$ROOT/mysql.cnf"

function export_settings
{
    echo "<?xml version=\"1.0\"?>
    <config>
        <mysql>
            <hostname>${1:-127.0.0.1}</hostname>
            <port>${2:-3306}</port>
            <username>${3:-acore}</username>
            <password>${4:-acore}</password>
            <database>
                <auth>${5:-acore_auth}</auth>
                <characters>${6:-acore_characters}</characters>
                <world>${7:-acore_world}</world>
            </database>
        </mysql>
        <core>
            <directory>${8:-/opt/azerothcore}</directory>
            <required_client_data>${9:-11}</required_client_data>
            <installed_client_data>${10:-0}</installed_client_data>
        </core>
        <world>
            <name>${11:-AzerothCore}</name>
            <motd>${12:-Welcome to AzerothCore.}</motd>
            <id>${13:-1}</id>
            <ip>${14:-127.0.0.1}</ip>
            <game_type>${15:-0}</game_type>
            <realm_zone>${16:-0}</realm_zone>
            <expansion>${17:-2}</expansion>
            <player_limit>${18:-1000}</player_limit>
            <skip_cinematics>${19:-0}</skip_cinematics>
            <max_level>${20:-80}</max_level>
            <start_level>${21:-1}</start_level>
            <start_money>${22:-0}</start_money>
            <always_max_skill>${23:-0}</always_max_skill>
            <all_flight_paths>${24:-0}</all_flight_paths>
            <maps_explored>${25:-0}</maps_explored>
            <allow_commands>${26:-1}</allow_commands>
            <quest_ignore_raid>${27:-0}</quest_ignore_raid>
            <prevent_afk_logout>${28:-0}</prevent_afk_logout>
            <raf_max_level>${29:-60}</raf_max_level>
            <preload_map_grids>${30:-0}</preload_map_grids>
            <set_all_waypoints_active>${31:-0}</set_all_waypoints_active>
            <enable_minigob_manabonk>${32:-1}</enable_minigob_manabonk>
            <rates>
                <experience>${33:-1}</experience>
                <rested_exp>${34:-1}</rested_exp>
                <reputation>${35:-1}</reputation>
                <money>${36:-1}</money>
                <crafting>${37:-1}</crafting>
                <gathering>${38:-1}</gathering>
                <weapon_skill>${39:-1}</weapon_skill>
                <defense_skill>${40:-1}</defense_skill>
            </rates>
            <gm>
                <login_state>${41:-1}</login_state>
                <visible>${42:-0}</visible>
                <chat>${43:-0}</chat>
                <whisper>${44:-0}</whisper>
                <gm_list>${45:-0}</gm_list>
                <who_list>${46:-0}</who_list>
                <allow_friend>${47:-0}</allow_friend>
                <allow_invite>${48:-0}</allow_invite>
                <lower_security>${49:-0}</lower_security>
            </gm>
        </world>
        <module>
            <eluna>
                <enabled>${50:-true}</enabled>
            </eluna>
        </module>
    </config>" | xmllint --format - > $ROOT/$CONFIG_FILE
}

function generate_settings
{
    export_settings \
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
    $WORLD_IP \
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
    $WORLD_GM_VISIBLE \
    $WORLD_GM_CHAT \
    $WORLD_GM_WHISPER \
    $WORLD_GM_GM_LIST \
    $WORLD_GM_WHO_LIST \
    $WORLD_GM_ALLOW_FRIEND \
    $WORLD_GM_ALLOW_INVITE \
    $WORLD_GM_LOWER_SECURITY \
    $MODULE_ELUNA_ENABLED
}

if [ ! -f $ROOT/$CONFIG_FILE ]; then
    clear
    echo -e "\e[0;33mGenerating default configuration\e[0m"
    export_settings
    exit $?
fi

MYSQL_HOSTNAME="$(echo "cat /config/mysql/hostname/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_PORT="$(echo "cat /config/mysql/port/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_USERNAME="$(echo "cat /config/mysql/username/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_PASSWORD="$(echo "cat /config/mysql/password/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_AUTH="$(echo "cat /config/mysql/database/auth/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_CHARACTERS="$(echo "cat /config/mysql/database/characters/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_WORLD="$(echo "cat /config/mysql/database/world/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"

CORE_DIRECTORY="$(echo "cat /config/core/directory/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
CORE_REQUIRED_CLIENT_DATA="$(echo "cat /config/core/required_client_data/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
CORE_INSTALLED_CLIENT_DATA="$(echo "cat /config/core/installed_client_data/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"

WORLD_NAME="$(echo "cat /config/world/name/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_MOTD="$(echo "cat /config/world/motd/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_ID="$(echo "cat /config/world/id/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_IP="$(echo "cat /config/world/ip/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_GAME_TYPE="$(echo "cat /config/world/game_type/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_REALM_ZONE="$(echo "cat /config/world/realm_zone/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_EXPANSION="$(echo "cat /config/world/expansion/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_PLAYER_LIMIT="$(echo "cat /config/world/player_limit/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_SKIP_CINEMATICS="$(echo "cat /config/world/skip_cinematics/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_MAX_LEVEL="$(echo "cat /config/world/max_level/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_START_LEVEL="$(echo "cat /config/world/start_level/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_START_MONEY="$(echo "cat /config/world/start_money/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_ALWAYS_MAX_SKILL="$(echo "cat /config/world/always_max_skill/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_ALL_FLIGHT_PATHS="$(echo "cat /config/world/all_flight_paths/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_MAPS_EXPLORED="$(echo "cat /config/world/maps_explored/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_ALLOW_COMMANDS="$(echo "cat /config/world/allow_commands/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_QUEST_IGNORE_RAID="$(echo "cat /config/world/quest_ignore_raid/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_PREVENT_AFK_LOGOUT="$(echo "cat /config/world/prevent_afk_logout/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_RAF_MAX_LEVEL="$(echo "cat /config/world/raf_max_level/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_PRELOAD_MAP_GRIDS="$(echo "cat /config/world/preload_map_grids/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_SET_WAYPOINTS_ACTIVE="$(echo "cat /config/world/set_all_waypoints_active/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_ENABLE_MINIGOB_MANABONK="$(echo "cat /config/world/enable_minigob_manabonk/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_EXPERIENCE="$(echo "cat /config/world/rates/experience/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_RESTED_EXP="$(echo "cat /config/world/rates/rested_exp/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_REPUTATION="$(echo "cat /config/world/rates/reputation/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_MONEY="$(echo "cat /config/world/rates/money/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_CRAFTING="$(echo "cat /config/world/rates/crafting/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_GATHERING="$(echo "cat /config/world/rates/gathering/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_WEAPON_SKILL="$(echo "cat /config/world/rates/weapon_skill/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_RATE_DEFENSE_SKILL="$(echo "cat /config/world/rates/defense_skill/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_GM_LOGIN_STATE="$(echo "cat /config/world/gm/login_state/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_GM_VISIBLE="$(echo "cat /config/world/gm/visible/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_GM_CHAT="$(echo "cat /config/world/gm/chat/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_GM_WHISPER="$(echo "cat /config/world/gm/whisper/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_GM_GM_LIST="$(echo "cat /config/world/gm/gm_list/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_GM_WHO_LIST="$(echo "cat /config/world/gm/who_list/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_GM_ALLOW_FRIEND="$(echo "cat /config/world/gm/allow_friend/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_GM_ALLOW_INVITE="$(echo "cat /config/world/gm/allow_invite/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
WORLD_GM_LOWER_SECURITY="$(echo "cat /config/world/gm/lower_security/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"

MODULE_ELUNA_ENABLED="$(echo "cat /config/module/eluna/enabled/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"

if [[ -z $MYSQL_HOSTNAME ]] || [[ $MYSQL_HOSTNAME == "" ]] || 
   [[ -z $MYSQL_PORT ]] || [[ $MYSQL_PORT == "" ]] || 
   [[ -z $MYSQL_USERNAME ]] || [[ $MYSQL_USERNAME == "" ]] || 
   [[ -z $MYSQL_PASSWORD ]] || [[ $MYSQL_PASSWORD == "" ]] || 
   [[ -z $MYSQL_DATABASE_AUTH ]] || [[ $MYSQL_DATABASE_AUTH == "" ]] || 
   [[ -z $MYSQL_DATABASE_CHARACTERS ]] || [[ $MYSQL_DATABASE_CHARACTERS == "" ]] || 
   [[ -z $MYSQL_DATABASE_WORLD ]] || [[ $MYSQL_DATABASE_WORLD == "" ]] || 
   [[ -z $CORE_DIRECTORY ]] || [[ $CORE_DIRECTORY == "" ]] || 
   [[ -z $CORE_REQUIRED_CLIENT_DATA ]] || [[ $CORE_REQUIRED_CLIENT_DATA == "" ]] || 
   [[ -z $CORE_INSTALLED_CLIENT_DATA ]] || [[ $CORE_INSTALLED_CLIENT_DATA == "" ]] || 
   [[ -z $WORLD_NAME ]] || [[ $WORLD_NAME == "" ]] || 
   [[ -z $WORLD_MOTD ]] || [[ $WORLD_MOTD == "" ]] || 
   [[ -z $WORLD_ID ]] || [[ $WORLD_ID == "" ]] || 
   [[ -z $WORLD_IP ]] || [[ $WORLD_IP == "" ]] || 
   [[ -z $WORLD_GAME_TYPE ]] || [[ $WORLD_GAME_TYPE == "" ]] || 
   [[ -z $WORLD_REALM_ZONE ]] || [[ $WORLD_REALM_ZONE == "" ]] || 
   [[ -z $WORLD_EXPANSION ]] || [[ $WORLD_EXPANSION == "" ]] || 
   [[ -z $WORLD_PLAYER_LIMIT ]] || [[ $WORLD_PLAYER_LIMIT == "" ]] || 
   [[ -z $WORLD_SKIP_CINEMATICS ]] || [[ $WORLD_SKIP_CINEMATICS == "" ]] || 
   [[ -z $WORLD_MAX_LEVEL ]] || [[ $WORLD_MAX_LEVEL == "" ]] || 
   [[ -z $WORLD_START_LEVEL ]] || [[ $WORLD_START_LEVEL == "" ]] || 
   [[ -z $WORLD_START_MONEY ]] || [[ $WORLD_START_MONEY == "" ]] || 
   [[ -z $WORLD_ALWAYS_MAX_SKILL ]] || [[ $WORLD_ALWAYS_MAX_SKILL == "" ]] || 
   [[ -z $WORLD_ALL_FLIGHT_PATHS ]] || [[ $WORLD_ALL_FLIGHT_PATHS == "" ]] || 
   [[ -z $WORLD_MAPS_EXPLORED ]] || [[ $WORLD_MAPS_EXPLORED == "" ]] || 
   [[ -z $WORLD_ALLOW_COMMANDS ]] || [[ $WORLD_ALLOW_COMMANDS == "" ]] || 
   [[ -z $WORLD_QUEST_IGNORE_RAID ]] || [[ $WORLD_QUEST_IGNORE_RAID == "" ]] || 
   [[ -z $WORLD_PREVENT_AFK_LOGOUT ]] || [[ $WORLD_PREVENT_AFK_LOGOUT == "" ]] || 
   [[ -z $WORLD_RAF_MAX_LEVEL ]] || [[ $WORLD_RAF_MAX_LEVEL == "" ]] || 
   [[ -z $WORLD_PRELOAD_MAP_GRIDS ]] || [[ $WORLD_PRELOAD_MAP_GRIDS == "" ]] || 
   [[ -z $WORLD_SET_WAYPOINTS_ACTIVE ]] || [[ $WORLD_SET_WAYPOINTS_ACTIVE == "" ]] || 
   [[ -z $WORLD_ENABLE_MINIGOB_MANABONK ]] || [[ $WORLD_ENABLE_MINIGOB_MANABONK == "" ]] || 
   [[ -z $WORLD_RATE_EXPERIENCE ]] || [[ $WORLD_RATE_EXPERIENCE == "" ]] || 
   [[ -z $WORLD_RATE_RESTED_EXP ]] || [[ $WORLD_RATE_RESTED_EXP == "" ]] || 
   [[ -z $WORLD_RATE_REPUTATION ]] || [[ $WORLD_RATE_REPUTATION == "" ]] || 
   [[ -z $WORLD_RATE_MONEY ]] || [[ $WORLD_RATE_MONEY == "" ]] || 
   [[ -z $WORLD_RATE_CRAFTING ]] || [[ $WORLD_RATE_CRAFTING == "" ]] || 
   [[ -z $WORLD_RATE_GATHERING ]] || [[ $WORLD_RATE_GATHERING == "" ]] || 
   [[ -z $WORLD_RATE_WEAPON_SKILL ]] || [[ $WORLD_RATE_WEAPON_SKILL == "" ]] || 
   [[ -z $WORLD_RATE_DEFENSE_SKILL ]] || [[ $WORLD_RATE_DEFENSE_SKILL == "" ]] || 
   [[ -z $WORLD_GM_LOGIN_STATE ]] || [[ $WORLD_GM_LOGIN_STATE == "" ]] || 
   [[ -z $WORLD_GM_VISIBLE ]] || [[ $WORLD_GM_VISIBLE == "" ]] || 
   [[ -z $WORLD_GM_CHAT ]] || [[ $WORLD_GM_CHAT == "" ]] || 
   [[ -z $WORLD_GM_WHISPER ]] || [[ $WORLD_GM_WHISPER == "" ]] || 
   [[ -z $WORLD_GM_GM_LIST ]] || [[ $WORLD_GM_GM_LIST == "" ]] || 
   [[ -z $WORLD_GM_WHO_LIST ]] || [[ $WORLD_GM_WHO_LIST == "" ]] || 
   [[ -z $WORLD_GM_ALLOW_FRIEND ]] || [[ $WORLD_GM_ALLOW_FRIEND == "" ]] || 
   [[ -z $WORLD_GM_ALLOW_INVITE ]] || [[ $WORLD_GM_ALLOW_INVITE == "" ]] || 
   [[ -z $WORLD_GM_LOWER_SECURITY ]] || [[ $WORLD_GM_LOWER_SECURITY == "" ]] || 
   [[ -z $MODULE_ELUNA_ENABLED ]] || [[ $MODULE_ELUNA_ENABLED == "" ]]; then
    clear
    echo -e "\e[0;31mAtleast one of the configuration options is missing or invalid\e[0m"
    exit $?
fi

function update_configuration
{
    clear

    echo -e "\e[0;32mUpdating configuration files\e[0m"

    if [ $1 == 0 ] || [ $1 == 1 ]; then
        if [ -f $CORE_DIRECTORY/etc/authserver.conf.dist ]; then
            echo -e "\e[0;33mUpdating authserver.conf\e[0m"

            cp $CORE_DIRECTORY/etc/authserver.conf.dist $CORE_DIRECTORY/etc/authserver.conf

            sed -i 's/LoginDatabaseInfo =.*/LoginDatabaseInfo = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASE_AUTH'"/g' $CORE_DIRECTORY/etc/authserver.conf
            sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 0/g' $CORE_DIRECTORY/etc/authserver.conf
        fi
    fi

    if [ $1 == 0 ] || [ $1 == 2 ]; then
        if [ -f $CORE_DIRECTORY/etc/worldserver.conf.dist ]; then
            echo -e "\e[0;33mUpdating worldserver.conf\e[0m"

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
            sed -i 's/AllFlightPaths =.*/AllFlightPaths = '$WORLD_ALL_FLIGHT_PATHS'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/AlwaysMaxSkillForLevel =.*/AlwaysMaxSkillForLevel = '$WORLD_ALWAYS_MAX_SKILL'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/PlayerStart.MapsExplored =.*/PlayerStart.MapsExplored = '$WORLD_MAPS_EXPLORED'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/AllowPlayerCommands =.*/AllowPlayerCommands = '$WORLD_ALLOW_COMMANDS'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/Quests.IgnoreRaid =.*/Quests.IgnoreRaid = '$WORLD_QUEST_IGNORE_RAID'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/PreventAFKLogout =.*/PreventAFKLogout = '$WORLD_PREVENT_AFK_LOGOUT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/RecruitAFriend.MaxLevel =.*/RecruitAFriend.MaxLevel = '$WORLD_RAF_MAX_LEVEL'/g' $CORE_DIRECTORY/etc/worldserver.conf

            sed -i 's/PreloadAllNonInstancedMapGrids =.*/PreloadAllNonInstancedMapGrids = '$WORLD_PRELOAD_MAP_GRIDS'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/SetAllCreaturesWithWaypointMovementActive =.*/SetAllCreaturesWithWaypointMovementActive = '$WORLD_SET_WAYPOINTS_ACTIVE'/g' $CORE_DIRECTORY/etc/worldserver.conf

            sed -i 's/Minigob.Manabonk.Enable =.*/Minigob.Manabonk.Enable = '$WORLD_ENABLE_MINIGOB_MANABONK'/g' $CORE_DIRECTORY/etc/worldserver.conf

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

            sed -i 's/GM.LoginState =.*/GM.LoginState = '$WORLD_GM_LOGIN_STATE'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.Visible =.*/GM.Visible = '$WORLD_GM_VISIBLE'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.Chat =.*/GM.Chat = '$WORLD_GM_CHAT'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.WhisperingTo =.*/GM.WhisperingTo = '$WORLD_GM_WHISPER'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.InGMList.Level =.*/GM.InGMList.Level = '$WORLD_GM_GM_LIST'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.InWhoList.Level =.*/GM.InWhoList.Level = '$WORLD_GM_WHO_LIST'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.StartLevel = .*/GM.StartLevel = '$WORLD_START_LEVEL'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.AllowInvite =.*/GM.AllowInvite = '$WORLD_GM_ALLOW_INVITE'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.AllowFriend =.*/GM.AllowFriend = '$WORLD_GM_ALLOW_FRIEND'/g' $CORE_DIRECTORY/etc/worldserver.conf
            sed -i 's/GM.LowerSecurity =.*/GM.LowerSecurity = '$WORLD_GM_LOWER_SECURITY'/g' $CORE_DIRECTORY/etc/worldserver.conf

            sed -i 's/Warden.Enabled =.*/Warden.Enabled = 0/g' $CORE_DIRECTORY/etc/worldserver.conf
        fi
    fi

    if [ $1 == 0 ] || [ $1 == 3 ]; then
        if [ -f $CORE_DIRECTORY/etc/modules/mod_LuaEngine.conf.dist ]; then
            echo -e "\e[0;33mUpdating mod_LuaEngine.conf\e[0m"

            cp $CORE_DIRECTORY/etc/modules/mod_LuaEngine.conf.dist $CORE_DIRECTORY/etc/modules/mod_LuaEngine.conf
        fi
    fi
}
