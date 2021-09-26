#!/bin/bash
[[ -f $CORE_DIRECTORY/bin/auth.sh && -f $CORE_DIRECTORY/bin/authserver ]] && ENABLE_AUTHSERVER=1 || ENABLE_AUTHSERVER=0
[[ -f $CORE_DIRECTORY/bin/world.sh && -f $CORE_DIRECTORY/bin/worldserver ]] && ENABLE_WORLDSERVER=1 || ENABLE_WORLDSERVER=0
[ ! -f $CORE_DIRECTORY/bin/start.sh ] && ENABLE_AUTHSERVER=1 ENABLE_WORLDSERVER=1

function main_menu
{
    clear
    printf "${COLOR_PURPLE}AzerothCore${COLOR_END}\n"
    printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the source code${COLOR_END}\n"
    printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Manage the databases${COLOR_END}\n"
    printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Manage the configuration options${COLOR_END}\n"
    if [[ -f $CORE_DIRECTORY/bin/start.sh && -f $CORE_DIRECTORY/bin/stop.sh ]] && [[ -f $CORE_DIRECTORY/bin/auth.sh || -f $CORE_DIRECTORY/bin/world.sh ]] && [[ -f $CORE_DIRECTORY/bin/authserver && -f $CORE_DIRECTORY/bin/worldserver ]]; then
        printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Manage the compiled binaries${COLOR_END}\n"
    fi
    printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Exit${COLOR_END}\n"
    printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
    read -s -n 1 s

    case $s in
        1) source_menu;;
        2) database_menu;;
        3) configuration_menu;;
        4) binary_menu;;
        0) exit_menu;;
        *) main_menu;;
    esac
}

function source_menu
{
    clear

    if [ -z $1 ]; then
        printf "${COLOR_PURPLE}Manage the cource code${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the available modules${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Download the latest version of the repository${COLOR_END}\n"
        printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Compile the source code into binaries${COLOR_END}\n"
        if [[ -d $CORE_DIRECTORY/bin ]] && [[ $CORE_INSTALLED_CLIENT_DATA != $CORE_REQUIRED_CLIENT_DATA ]]; then
            printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Download the client data files${COLOR_END}\n"
        fi
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            1) source_menu 1;;
            2) source_menu 2;;
            3) source_menu 3;;
            4) fetch_client_data; source_menu;;
            0) main_menu;;
            *) source_menu;;
        esac
    elif [ $1 == 1 ]; then
        printf "${COLOR_PURPLE}Manage the available modules${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Auction House Bot: ${COLOR_END}"
        [ $MODULE_AHBOT_ENABLED == "true" ] && printf "${COLOR_GREEN}Enabled${COLOR_END}\n" || printf "${COLOR_RED}Disabled${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Eluna LUA Engine: ${COLOR_END}"
        [ $MODULE_ELUNA_ENABLED == "true" ] && printf "${COLOR_GREEN}Enabled${COLOR_END}\n" || printf "${COLOR_RED}Disabled${COLOR_END}\n"
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            1) if [ $MODULE_AHBOT_ENABLED == "true" ]; then MODULE_AHBOT_ENABLED="false"; else MODULE_AHBOT_ENABLED="true"; fi; generate_settings; source_menu 1;;
            2) if [ $MODULE_ELUNA_ENABLED == "true" ]; then MODULE_ELUNA_ENABLED="false"; else MODULE_ELUNA_ENABLED="true"; fi; generate_settings; source_menu 1;;
            0) source_menu;;
            *) source_menu 1;;
        esac
    elif [ $1 == 2 ]; then
        stop_process
        clone_source
        source_menu
    elif [ $1 == 3 ]; then
        printf "${COLOR_PURPLE}Compile the source code into binaries${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Authserver: ${COLOR_END}"
        [ $ENABLE_AUTHSERVER == 1 ] && printf "${COLOR_GREEN}Enabled${COLOR_END}\n" || printf "${COLOR_RED}Disabled${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Worldserver: ${COLOR_END}"
        [ $ENABLE_WORLDSERVER == 1 ] && printf "${COLOR_GREEN}Enabled${COLOR_END}\n" || printf "${COLOR_RED}Disabled${COLOR_END}\n"
        printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Compile with these settings${COLOR_END}\n"
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            1) [ $ENABLE_AUTHSERVER == 0 ] && ENABLE_AUTHSERVER=1 || ENABLE_AUTHSERVER=0; source_menu 3;;
            2) [ $ENABLE_WORLDSERVER == 0 ] && ENABLE_WORLDSERVER=1 || ENABLE_WORLDSERVER=0; source_menu 3;;
            3) if [[ $ENABLE_AUTHSERVER == 1 && $ENABLE_WORLDSERVER == 1 ]]; then compile_source 0; elif [[ $ENABLE_AUTHSERVER == 1 && $ENABLE_WORLDSERVER == 0 ]]; then compile_source 1; elif [[ $ENABLE_AUTHSERVER == 0 && $ENABLE_WORLDSERVER == 1 ]]; then compile_source 2; fi; source_menu 3;;
            0) source_menu;;
            *) source_menu 3;;
        esac
    fi
}

function database_menu
{
    clear

    if [ -z $1 ]; then
        printf "${COLOR_PURPLE}Manage the databases${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the auth database${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Manage the characters database${COLOR_END}\n"
        printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Manage the world database${COLOR_END}\n"
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            1) database_menu 1;;
            2) database_menu 2;;
            3) database_menu 3;;
            0) main_menu;;
            *) database_menu;;
        esac
    else
        [ $1 == 1 ] && DB="auth"
        [ $1 == 2 ] && DB="characters"
        [ $1 == 3 ] && DB="world"

        printf "${COLOR_PURPLE}Manage the ${DB} database${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Import all tables and data${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Import all available updates${COLOR_END}\n"
        if [[ $1 == 3 ]] && [[ -d $ROOT/sql/world ]] && [[ ! -z "$(ls -A $ROOT/sql/world/)" ]]; then
            printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Import all custom content${COLOR_END}\n"
        fi
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            1) import_database $1 $s; database_menu $1;;
            2) update_database $1 $s; database_menu $1;;
            3) update_database $1 $s; database_menu $1;;
            0) database_menu;;
            *) database_menu $1;;
        esac
    fi
}

function configuration_menu
{
    clear

    if [ -z $1 ]; then
        printf "${COLOR_PURPLE}Manage the configuration options${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the database options${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Manage the server options${COLOR_END}\n"
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            1) configuration_menu 1;;
            2) configuration_menu 2;;
            0) main_menu;;
            *) configuration_menu;;
        esac
    elif [ $1 == 1 ]; then
        printf "${COLOR_PURPLE}Manage the database options${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Hostname: ${MYSQL_HOSTNAME}${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Port: ${MYSQL_PORT}${COLOR_END}\n"
        printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Username: ${MYSQL_USERNAME}${COLOR_END}\n"
        printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Password: ${MYSQL_PASSWORD//?/*}${COLOR_END}\n\n"
        printf "${COLOR_PURPLE}Specified databases${COLOR_END}\n"
        printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Auth: ${MYSQL_DATABASE_AUTH}${COLOR_END}\n"
        printf "${COLOR_CYAN}6) ${COLOR_ORANGE}Characters: ${MYSQL_DATABASE_CHARACTERS}${COLOR_END}\n"
        printf "${COLOR_CYAN}7) ${COLOR_ORANGE}World: ${MYSQL_DATABASE_WORLD}${COLOR_END}\n\n"
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            1) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_HOSTNAME}" i; if [ ! -z $i ]; then MYSQL_HOSTNAME=$i; fi; generate_settings; configuration_menu 1;;
            2) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_PORT}" i; if [ ! -z $i ]; then MYSQL_PORT=$i; fi; generate_settings; configuration_menu 1;;
            3) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_USERNAME}" i; if [ ! -z $i ]; then MYSQL_USERNAME=$i; fi; generate_settings; configuration_menu 1;;
            4) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_PASSWORD}" i; if [ ! -z $i ]; then MYSQL_PASSWORD=$i; fi; generate_settings; configuration_menu 1;;
            5) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_DATABASE_AUTH}" i; if [ ! -z $i ]; then MYSQL_DATABASE_AUTH=$i; fi; generate_settings; configuration_menu 1;;
            6) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_DATABASE_CHARACTERS}" i; if [ ! -z $i ]; then MYSQL_DATABASE_CHARACTERS=$i; fi; generate_settings; configuration_menu 1;;
            7) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_DATABASE_WORLD}" i; if [ ! -z $i ]; then MYSQL_DATABASE_WORLD=$i; fi; generate_settings; configuration_menu 1;;
            0) configuration_menu;;
            *) configuration_menu 1;;
        esac
    elif [ $1 == 2 ]; then
        [ $WORLD_GAME_TYPE == 0 ] && WORLD_GAME_TYPE_TEXT="${COLOR_YELLOW}Normal"
        [ $WORLD_GAME_TYPE == 1 ] && WORLD_GAME_TYPE_TEXT="${COLOR_RED}PVP"
        [ $WORLD_GAME_TYPE == 6 ] && WORLD_GAME_TYPE_TEXT="${COLOR_GREEN}RP"
        [ $WORLD_GAME_TYPE == 8 ] && WORLD_GAME_TYPE_TEXT="${COLOR_GREEN}RPPVP"
        [ $WORLD_REALM_ZONE == 1 ] && WORLD_REALM_ZONE_TEXT="${COLOR_RED}Development"
        [ $WORLD_REALM_ZONE == 8 ] && WORLD_REALM_ZONE_TEXT="${COLOR_GREEN}English"

        printf "${COLOR_PURPLE}Manage the server options - Page 1 of 5${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Location of the source code: ${COLOR_GREEN}${CORE_DIRECTORY}${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Required client data version: ${COLOR_GREEN}${CORE_REQUIRED_CLIENT_DATA}${COLOR_END}\n"
        printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Name of the realm: ${COLOR_GREEN}${WORLD_NAME}${COLOR_END}\n"
        printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Message of the day: ${COLOR_GREEN}${WORLD_MOTD}${COLOR_END}\n"
        printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Realm id: ${COLOR_GREEN}${WORLD_ID}${COLOR_END}\n"
        printf "${COLOR_CYAN}6) ${COLOR_ORANGE}Realm address: ${COLOR_GREEN}${WORLD_IP}${COLOR_END}\n"
        printf "${COLOR_CYAN}7) ${COLOR_ORANGE}Game type: ${WORLD_GAME_TYPE_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}8) ${COLOR_ORANGE}Realm zone: ${WORLD_REALM_ZONE_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}9) ${COLOR_ORANGE}Go to the next page${COLOR_END}\n"
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            9) configuration_menu 3;;
            0) configuration_menu;;
            *) configuration_menu 2;;
        esac
    elif [ $1 == 3 ]; then
        [ $WORLD_EXPANSION == 0 ] && WORLD_EXPANSION_TEXT="${COLOR_RED}None"
        [ $WORLD_EXPANSION == 1 ] && WORLD_EXPANSION_TEXT="${COLOR_GREEN}The Burning Crusade"
        [ $WORLD_EXPANSION == 2 ] && WORLD_EXPANSION_TEXT="${COLOR_CYAN}Wrath of the Lich King"
        [ $WORLD_SKIP_CINEMATICS == 0 ] && WORLD_SKIP_CINEMATICS_TEXT="${COLOR_GREEN}Show for all characters"
        [ $WORLD_SKIP_CINEMATICS == 1 ] && WORLD_SKIP_CINEMATICS_TEXT="${COLOR_YELLOW}Show only for new races"
        [ $WORLD_SKIP_CINEMATICS == 2 ] && WORLD_SKIP_CINEMATICS_TEXT="${COLOR_RED}Never show"
        [ $WORLD_ALWAYS_MAX_SKILL == 0 ] && WORLD_ALWAYS_MAX_SKILL_TEXT="${COLOR_RED}Disabled" || WORLD_ALWAYS_MAX_SKILL_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_ALL_FLIGHT_PATHS == 0 ] && WORLD_ALL_FLIGHT_PATHS_TEXT="${COLOR_RED}Disabled" || WORLD_ALL_FLIGHT_PATHS_TEXT="${COLOR_GREEN}Enabled"

        printf "${COLOR_PURPLE}Manage the server options - Page 2 of 5${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Active expansion: ${WORLD_EXPANSION_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Player limit: ${COLOR_GREEN}${WORLD_PLAYER_LIMIT}${COLOR_END}\n"
        printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Intro cinematics: ${WORLD_SKIP_CINEMATICS_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Max level: ${COLOR_GREEN}${WORLD_MAX_LEVEL}${COLOR_END}\n"
        printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Starting level: ${COLOR_GREEN}${WORLD_START_LEVEL}${COLOR_END}\n"
        printf "${COLOR_CYAN}6) ${COLOR_ORANGE}Starting money: ${COLOR_GREEN}${WORLD_START_MONEY} copper${COLOR_END}\n"
        printf "${COLOR_CYAN}7) ${COLOR_ORANGE}Always max player skills: ${WORLD_ALWAYS_MAX_SKILL_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}8) ${COLOR_ORANGE}All flight paths: ${WORLD_ALL_FLIGHT_PATHS_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}9) ${COLOR_ORANGE}Go to the next page${COLOR_END}\n"
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            9) configuration_menu 4;;
            0) configuration_menu 2;;
            *) configuration_menu 3;;
        esac
    elif [ $1 == 4 ]; then
        [ $WORLD_MAPS_EXPLORED == 0 ] && WORLD_MAPS_EXPLORED_TEXT="${COLOR_RED}Disabled" || WORLD_MAPS_EXPLORED_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_ALLOW_COMMANDS == 0 ] && WORLD_ALLOW_COMMANDS_TEXT="${COLOR_RED}Disabled" || WORLD_ALLOW_COMMANDS_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_QUEST_IGNORE_RAID == 0 ] && WORLD_QUEST_IGNORE_RAID_TEXT="${COLOR_RED}Disabled" || WORLD_QUEST_IGNORE_RAID_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_PREVENT_AFK_LOGOUT == 0 ] && WORLD_PREVENT_AFK_LOGOUT_TEXT="${COLOR_RED}Disabled" || WORLD_PREVENT_AFK_LOGOUT_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_PRELOAD_MAP_GRIDS == 0 ] && WORLD_PRELOAD_MAP_GRIDS_TEXT="${COLOR_RED}Disabled" || WORLD_PRELOAD_MAP_GRIDS_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_SET_WAYPOINTS_ACTIVE == 0 ] && WORLD_SET_WAYPOINTS_ACTIVE_TEXT="${COLOR_RED}Disabled" || WORLD_SET_WAYPOINTS_ACTIVE_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_ENABLE_MINIGOB_MANABONK == 0 ] && WORLD_ENABLE_MINIGOB_MANABONK_TEXT="${COLOR_RED}Disabled" || WORLD_ENABLE_MINIGOB_MANABONK_TEXT="${COLOR_GREEN}Enabled"

        printf "${COLOR_PURPLE}Manage the server options - Page 3 of 5${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}All maps explored: ${WORLD_MAPS_EXPLORED_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Allow player commands: ${WORLD_ALLOW_COMMANDS_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Allow questing in a raid group: ${WORLD_QUEST_IGNORE_RAID_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Prevent AFK logout: ${WORLD_PREVENT_AFK_LOGOUT_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Max level to benefit from refer-a-friend: ${COLOR_GREEN}${WORLD_RAF_MAX_LEVEL}${COLOR_END}\n"
        printf "${COLOR_CYAN}6) ${COLOR_ORANGE}Preload map grids: ${WORLD_PRELOAD_MAP_GRIDS_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}7) ${COLOR_ORANGE}Set all waypoints as active: ${WORLD_SET_WAYPOINTS_ACTIVE_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}8) ${COLOR_ORANGE}Enable Minigob Manabonk: ${WORLD_ENABLE_MINIGOB_MANABONK_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}9) ${COLOR_ORANGE}Go to the next page${COLOR_END}\n"
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            9) configuration_menu 5;;
            0) configuration_menu 3;;
            *) configuration_menu 4;;
        esac
    elif [ $1 == 5 ]; then
        printf "${COLOR_PURPLE}Manage the server options - Page 4 of 5${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Rate of experience gain: ${COLOR_GREEN}${WORLD_RATE_EXPERIENCE}x${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Rate of rested experience gain: ${COLOR_GREEN}${WORLD_RATE_RESTED_EXP}x${COLOR_END}\n"
        printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Rate of reputation gain: ${COLOR_GREEN}${WORLD_RATE_REPUTATION}x${COLOR_END}\n"
        printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Rate of gold gain: ${COLOR_GREEN}${WORLD_RATE_MONEY}x${COLOR_END}\n"
        printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Rate of crafting skill ups: ${COLOR_GREEN}${WORLD_RATE_CRAFTING}x${COLOR_END}\n"
        printf "${COLOR_CYAN}6) ${COLOR_ORANGE}Rate of gathering skill ups: ${COLOR_GREEN}${WORLD_RATE_GATHERING}x${COLOR_END}\n"
        printf "${COLOR_CYAN}7) ${COLOR_ORANGE}Rate of weapon skill ups: ${COLOR_GREEN}${WORLD_RATE_WEAPON_SKILL}x${COLOR_END}\n"
        printf "${COLOR_CYAN}8) ${COLOR_ORANGE}Rate of defense skill ups: ${COLOR_GREEN}${WORLD_RATE_DEFENSE_SKILL}x${COLOR_END}\n"
        printf "${COLOR_CYAN}9) ${COLOR_ORANGE}Go to the next page${COLOR_END}\n"
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            9) configuration_menu 6;;
            0) configuration_menu 4;;
            *) configuration_menu 5;;
        esac
    elif [ $1 == 6 ]; then
        [ $WORLD_GM_LOGIN_STATE == 0 ] && WORLD_GM_LOGIN_STATE_TEXT="${COLOR_RED}Inactive" || WORLD_GM_LOGIN_STATE_TEXT="${COLOR_GREEN}Active"
        [ $WORLD_GM_VISIBLE == 0 ] && WORLD_GM_VISIBLE_TEXT="${COLOR_RED}Invisible" || WORLD_GM_VISIBLE_TEXT="${COLOR_GREEN}Visible"
        [ $WORLD_GM_CHAT == 0 ] && WORLD_GM_CHAT_TEXT="${COLOR_RED}Disabled" || WORLD_GM_CHAT_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_GM_WHISPER == 0 ] && WORLD_GM_WHISPER_TEXT="${COLOR_RED}Disabled" || WORLD_GM_WHISPER_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_GM_GM_LIST == 0 ] && WORLD_GM_GM_LIST_TEXT="${COLOR_RED}Disabled" || WORLD_GM_GM_LIST_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_GM_WHO_LIST == 0 ] && WORLD_GM_WHO_LIST_TEXT="${COLOR_RED}Disabled" || WORLD_GM_WHO_LIST_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_GM_ALLOW_FRIEND == 0 ] && WORLD_GM_ALLOW_FRIEND_TEXT="${COLOR_RED}Disabled" || WORLD_GM_ALLOW_FRIEND_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_GM_ALLOW_INVITE == 0 ] && WORLD_GM_ALLOW_INVITE_TEXT="${COLOR_RED}Disabled" || WORLD_GM_ALLOW_INVITE_TEXT="${COLOR_GREEN}Enabled"
        [ $WORLD_GM_LOWER_SECURITY == 0 ] && WORLD_GM_LOWER_SECURITY_TEXT="${COLOR_RED}Disabled" || WORLD_GM_LOWER_SECURITY_TEXT="${COLOR_GREEN}Enabled"

        printf "${COLOR_PURPLE}Manage the server options - Page 5 of 5${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Set GM state when entering the world: ${WORLD_GM_LOGIN_STATE_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Set GM visibility when entering the world: ${WORLD_GM_VISIBLE_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Set GM chat mode when entering the world: ${WORLD_GM_CHAT_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Allow GM whispers when entering the world: ${WORLD_GM_WHISPER_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Show GM in GM list: ${WORLD_GM_GM_LIST_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}6) ${COLOR_ORANGE}Show GM in who list: ${WORLD_GM_WHO_LIST_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}7) ${COLOR_ORANGE}Allow players to add a GM to the list of friends: ${WORLD_GM_ALLOW_FRIEND_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}8) ${COLOR_ORANGE}Allow players to invite a GM: ${WORLD_GM_ALLOW_INVITE_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}9) ${COLOR_ORANGE}Allow lower security GM to interact with higher security: ${WORLD_GM_LOWER_SECURITY_TEXT}${COLOR_END}\n"
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            0) configuration_menu 5;;
            *) configuration_menu 6;;
        esac
    fi
}

function binary_menu
{
    clear
}

function exit_menu
{
    print_quote
}
