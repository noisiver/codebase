#!/bin/bash
[[ -f $CORE_DIRECTORY/bin/auth.sh && -f $CORE_DIRECTORY/bin/authserver ]] && ENABLE_AUTHSERVER=1 || ENABLE_AUTHSERVER=0
[[ -f $CORE_DIRECTORY/bin/world.sh && -f $CORE_DIRECTORY/bin/worldserver ]] && ENABLE_WORLDSERVER=1 || ENABLE_WORLDSERVER=0
[ ! -f $CORE_DIRECTORY/bin/start.sh ] && ENABLE_AUTHSERVER=1 ENABLE_WORLDSERVER=1

function show_menu
{
    clear

    if [[ -z $1 && -z $2 ]]; then
        printf "${COLOR_PURPLE}AzerothCore${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the source code${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Manage the databases${COLOR_END}\n"
        printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Manage the configuration options${COLOR_END}\n"
        if [[ -f $CORE_DIRECTORY/bin/authserver && -f $CORE_DIRECTORY/bin/worldserver ]] && [[ -f $CORE_DIRECTORY/bin/auth.sh || -f $CORE_DIRECTORY/bin/world.sh ]]; then
            if [ $(dpkg-query -W -f='${Status}' screen 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
                if [[ -z `screen -list | grep -E "auth"` ]] && [[ -z `screen -list | grep -E "world"` ]]; then
                    printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Start the compiled binaries${COLOR_END}\n"
                else
                    printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Stop all running processes${COLOR_END}\n"
                fi
            fi
        fi
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Exit${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            [1-3]) show_menu $s;;
            4) if [[ -z `screen -list | grep -E "auth"` ]] && [[ -z `screen -list | grep -E "world"` ]]; then start_process; sleep 1; else stop_process; fi; show_menu;;
            0) print_quote;;
            *) show_menu;;
        esac
    elif [[ $1 == 1 ]]; then
        if [[ -z $2 ]]; then
            printf "${COLOR_PURPLE}Manage the source code${COLOR_END}\n"
            printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Download the latest version of the repository${COLOR_END}\n"
            printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Compile the source code into binaries${COLOR_END}\n"
            if [[ -f $CORE_DIRECTORY/bin/authserver && -f $CORE_DIRECTORY/bin/worldserver ]] && [[ -f $CORE_DIRECTORY/bin/world.sh ]] && [[ $CORE_INSTALLED_CLIENT_DATA != $CORE_REQUIRED_CLIENT_DATA ]]; then
                printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Download the client data files${COLOR_END}\n"
            fi
            printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
            printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
            read -s -n 1 s

            case $s in
                1) stop_process; clone_source; show_menu $1;;
                2) show_menu $1 $s;;
                3) fetch_client_data; show_menu $1 $2;;
                0) show_menu;;
                *) show_menu $1;;
            esac
        elif [[ $2 == 2 ]]; then
            if [ -d $CORE_DIRECTORY ]; then
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
                    1) [ $ENABLE_AUTHSERVER == 0 ] && ENABLE_AUTHSERVER=1 || ENABLE_AUTHSERVER=0; show_menu $1 $2;;
                    2) [ $ENABLE_WORLDSERVER == 0 ] && ENABLE_WORLDSERVER=1 || ENABLE_WORLDSERVER=0; show_menu $1 $2;;
                    3) if [[ $ENABLE_AUTHSERVER == 1 && $ENABLE_WORLDSERVER == 1 ]]; then compile_source 0; elif [[ $ENABLE_AUTHSERVER == 1 && $ENABLE_WORLDSERVER == 0 ]]; then compile_source 1; elif [[ $ENABLE_AUTHSERVER == 0 && $ENABLE_WORLDSERVER == 1 ]]; then compile_source 2; fi; show_menu $1 $2;;
                    0) show_menu $1;;
                    *) show_menu $1 $2;;
                esac
            else
                printf "${COLOR_PURPLE}Compile the source code into binaries${COLOR_END}\n"
                printf "${COLOR_ORANGE}The source code is not accessible${COLOR_END}\n"
                printf "${COLOR_ORANGE}Make sure to download the source code first${COLOR_END}\n"
                printf "\n${COLOR_GREEN}Press any key to continue...${COLOR_END}"
                read -s -n 1
                show_menu $1
            fi
        fi
    elif [[ $1 == 2 ]]; then
        if [[ -z $2 ]]; then
            printf "${COLOR_PURPLE}Manage the databases${COLOR_END}\n"
            printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the auth database${COLOR_END}\n"
            printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Manage the characters database${COLOR_END}\n"
            printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Manage the world database${COLOR_END}\n"
            printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
            printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
            read -s -n 1 s

            case $s in
                [1-3]) show_menu $1 $s;;
                0) show_menu;;
                *) show_menu $1;;
            esac
        else
            [ $2 == 1 ] && DB="auth"
            [ $2 == 2 ] && DB="characters"
            [ $2 == 3 ] && DB="world"

            printf "${COLOR_PURPLE}Manage the ${DB} database${COLOR_END}\n"
            printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Import all tables and data${COLOR_END}\n"
            printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Import all available updates${COLOR_END}\n"
            if [ $2 == 1 ]; then
                printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Update the realm list${COLOR_END}\n"
            elif [ $2 == 3 ] && [ -d $ROOT/sql/world ] && [ ! -z "$(ls -A $ROOT/sql/world/)" ]; then
                printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Import any custom content${COLOR_END}\n"
            fi
            printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
            printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
            read -s -n 1 s

            case $s in
                [1-2]) import_database $2 $s; show_menu $1 $2;;
                3) if [ $2 == 1 ]; then import_database $2 $s; sleep 1; else import_database $2 $s; fi; show_menu $1 $2;;
                0) show_menu $1;;
                *) show_menu $1 $2;;
            esac
        fi
    elif [[ $1 == 3 ]]; then
        if [[ -z $2 ]]; then
            printf "${COLOR_PURPLE}Manage the configuration options${COLOR_END}\n"
            printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the database options${COLOR_END}\n"
            printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Manage the core options${COLOR_END}\n"
            printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Manage the world options${COLOR_END}\n"
            printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Manage the available modules${COLOR_END}\n"
            if [ -f $CORE_DIRECTORY/etc/authserver.conf.dist ] && [ -f $CORE_DIRECTORY/etc/worldserver.conf.dist ]; then
                printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Write to configuration files${COLOR_END}\n"
            fi
            printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
            printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
            read -s -n 1 s

            case $s in
                [1-4]) show_menu $1 $s;;
                5) if [[ $ENABLE_AUTHSERVER == 1 && $ENABLE_WORLDSERVER == 1 ]]; then update_configuration 0; elif [[ $ENABLE_AUTHSERVER == 1 && $ENABLE_WORLDSERVER == 0 ]]; then update_configuration 1; elif [[ $ENABLE_AUTHSERVER == 0 && $ENABLE_WORLDSERVER == 1 ]]; then update_configuration 2; fi; sleep 1; show_menu $1;;
                0) show_menu;;
                *) show_menu $1;;
            esac
        elif [ $2 == 1 ]; then
            printf "${COLOR_PURPLE}Manage the database options${COLOR_END}\n"
            printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Hostname: ${MYSQL_HOSTNAME}${COLOR_END}\n"
            printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Port: ${MYSQL_PORT}${COLOR_END}\n"
            printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Username: ${MYSQL_USERNAME}${COLOR_END}\n"
            printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Password: ${MYSQL_PASSWORD//?/*}${COLOR_END}\n"
            printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Auth database: ${MYSQL_DATABASE_AUTH}${COLOR_END}\n"
            printf "${COLOR_CYAN}6) ${COLOR_ORANGE}Characters database: ${MYSQL_DATABASE_CHARACTERS}${COLOR_END}\n"
            printf "${COLOR_CYAN}7) ${COLOR_ORANGE}World database: ${MYSQL_DATABASE_WORLD}${COLOR_END}\n"
            printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
            printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
            read -s -n 1 s

            case $s in
                1) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_HOSTNAME}" i; if [ ! -z $i ]; then MYSQL_HOSTNAME=$i; fi; export_settings; show_menu $1 $2;;
                2) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_PORT}" i; if [[ ! -z $i && $i =~ ^[0-9]+$ ]]; then MYSQL_PORT=$i; fi; export_settings; show_menu $1 $2;;
                3) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_USERNAME}" i; if [ ! -z $i ]; then MYSQL_USERNAME=$i; fi; export_settings; show_menu $1 $2;;
                4) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_PASSWORD}" i; if [ ! -z $i ]; then MYSQL_PASSWORD=$i; fi; export_settings; show_menu $1 $2;;
                5) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_DATABASE_AUTH}" i; if [ ! -z $i ]; then MYSQL_DATABASE_AUTH=$i; fi; export_settings; show_menu $1 $2;;
                6) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_DATABASE_CHARACTERS}" i; if [ ! -z $i ]; then MYSQL_DATABASE_CHARACTERS=$i; fi; export_settings; show_menu $1 $2;;
                7) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${MYSQL_DATABASE_WORLD}" i; if [ ! -z $i ]; then MYSQL_DATABASE_WORLD=$i; fi; export_settings; show_menu $1 $2;;
                0) show_menu $1;;
                *) show_menu $1 $2;;
            esac
        elif [ $2 == 2 ]; then
            printf "${COLOR_PURPLE}Manage the core options${COLOR_END}\n"
            printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Location of the source code: ${COLOR_GREEN}${CORE_DIRECTORY}${COLOR_END}\n"
            printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Required client data version: ${COLOR_GREEN}${CORE_REQUIRED_CLIENT_DATA}${COLOR_END}\n"
            printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Check for a new version of the client data files${COLOR_END}\n"
            printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
            printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
            read -s -n 1 s

            case $s in
                1) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${CORE_DIRECTORY}" i; if [ ! -z $i ]; then CORE_DIRECTORY=$i; fi; export_settings; show_menu $1 $2;;
                2) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${CORE_REQUIRED_CLIENT_DATA}" i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]]; then CORE_REQUIRED_CLIENT_DATA=$i; fi; export_settings; show_menu $1 $2;;
                3) update_client_data; sleep 1; show_menu $1 $2;;
                0) show_menu $1;;
                *) show_menu $1 $2;;
            esac
        elif [ $2 == 3 ]; then
            if [ -z $3 ]; then
                [ $WORLD_GAME_TYPE == 0 ] && WORLD_GAME_TYPE_TEXT="${COLOR_YELLOW}Normal"
                [ $WORLD_GAME_TYPE == 1 ] && WORLD_GAME_TYPE_TEXT="${COLOR_RED}Player vs Player"
                [ $WORLD_GAME_TYPE == 6 ] && WORLD_GAME_TYPE_TEXT="${COLOR_GREEN}Role Playing"
                [ $WORLD_GAME_TYPE == 8 ] && WORLD_GAME_TYPE_TEXT="${COLOR_RED}Role Playing plus Player vs Player"
                [ $WORLD_REALM_ZONE == 1 ] && WORLD_REALM_ZONE_TEXT="${COLOR_GREEN}Development"
                [ $WORLD_REALM_ZONE == 2 ] && WORLD_REALM_ZONE_TEXT="${COLOR_GREEN}United States"
                [ $WORLD_REALM_ZONE == 6 ] && WORLD_REALM_ZONE_TEXT="${COLOR_GREEN}Korea"
                [ $WORLD_REALM_ZONE == 9 ] && WORLD_REALM_ZONE_TEXT="${COLOR_GREEN}German"
                [ $WORLD_REALM_ZONE == 10 ] && WORLD_REALM_ZONE_TEXT="${COLOR_GREEN}French"
                [ $WORLD_REALM_ZONE == 11 ] && WORLD_REALM_ZONE_TEXT="${COLOR_GREEN}Spanish"
                [ $WORLD_REALM_ZONE == 12 ] && WORLD_REALM_ZONE_TEXT="${COLOR_GREEN}Russian"
                [ $WORLD_REALM_ZONE == 14 ] && WORLD_REALM_ZONE_TEXT="${COLOR_GREEN}Taiwan"
                [ $WORLD_REALM_ZONE == 16 ] && WORLD_REALM_ZONE_TEXT="${COLOR_GREEN}China"
                [ $WORLD_REALM_ZONE == 26 ] && WORLD_REALM_ZONE_TEXT="${COLOR_GREEN}Test Server"
                [ $WORLD_EXPANSION == 0 ] && WORLD_EXPANSION_TEXT="${COLOR_RED}None"
                [ $WORLD_EXPANSION == 1 ] && WORLD_EXPANSION_TEXT="${COLOR_GREEN}The Burning Crusade"
                [ $WORLD_EXPANSION == 2 ] && WORLD_EXPANSION_TEXT="${COLOR_CYAN}Wrath of the Lich King"

                printf "${COLOR_PURPLE}Manage the world options (Page 1 of 5)${COLOR_END}\n"
                printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Name of the realm: ${COLOR_GREEN}${WORLD_NAME}${COLOR_END}\n"
                printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Message of the day: ${COLOR_GREEN}${WORLD_MOTD}${COLOR_END}\n"
                printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Realm id: ${COLOR_GREEN}${WORLD_ID}${COLOR_END}\n"
                printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Realm address: ${COLOR_GREEN}${WORLD_ADDRESS}${COLOR_END}\n"
                printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Game type: ${WORLD_GAME_TYPE_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}6) ${COLOR_ORANGE}Realm zone: ${WORLD_REALM_ZONE_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}7) ${COLOR_ORANGE}Active expansion: ${WORLD_EXPANSION_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}8) ${COLOR_ORANGE}Player limit: ${COLOR_GREEN}${WORLD_PLAYER_LIMIT}${COLOR_END}\n"
                printf "${COLOR_CYAN}9) ${COLOR_ORANGE}Go to the next page${COLOR_END}\n"
                printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
                printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
                read -s -n 1 s

                case $s in
                    1) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${WORLD_NAME}" i; if [ ! -z $i ]; then WORLD_NAME=$i; fi; export_settings; show_menu $1 $2;;
                    2) clear; printf "${COLOR_PURPLE}Message of the day${COLOR_END}\n${COLOR_ORANGE}This option can only be modified manually due to limitations of the terminal\nPress any key to continue...${COLOR_END}";read -s -n 1; show_menu $1 $2;;
                    3) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${WORLD_ID}" i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]]; then WORLD_ID=$i; fi; export_settings; show_menu $1 $2;;
                    4) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${WORLD_ADDRESS}" i; if [ ! -z $i ]; then WORLD_ADDRESS=$i; fi; export_settings; show_menu $1 $2;;
                    5) if [[ $WORLD_GAME_TYPE == 0 ]]; then WORLD_GAME_TYPE=1; elif [[ $WORLD_GAME_TYPE == 1 ]]; then WORLD_GAME_TYPE=6; elif [[ $WORLD_GAME_TYPE == 6 ]]; then WORLD_GAME_TYPE=8; else WORLD_GAME_TYPE=0; fi; export_settings; show_menu $1 $2;;
                    6) if [[ $WORLD_REALM_ZONE == 1 ]]; then WORLD_REALM_ZONE=2; elif [[ $WORLD_REALM_ZONE == 2 ]]; then WORLD_REALM_ZONE=6; elif [[ $WORLD_REALM_ZONE == 6 ]]; then WORLD_REALM_ZONE=9; elif [[ $WORLD_REALM_ZONE == 9 ]]; then WORLD_REALM_ZONE=10; elif [[ $WORLD_REALM_ZONE == 10 ]]; then WORLD_REALM_ZONE=11; elif [[ $WORLD_REALM_ZONE == 11 ]]; then WORLD_REALM_ZONE=12; elif [[ $WORLD_REALM_ZONE == 12 ]]; then WORLD_REALM_ZONE=14; elif [[ $WORLD_REALM_ZONE == 14 ]]; then WORLD_REALM_ZONE=16; elif [[ $WORLD_REALM_ZONE == 16 ]]; then WORLD_REALM_ZONE=26; else WORLD_REALM_ZONE=1; fi; export_settings; show_menu $1 $2;;
                    7) if [[ $WORLD_EXPANSION == 2 ]]; then WORLD_EXPANSION=0; else WORLD_EXPANSION=$(($WORLD_EXPANSION+1)); fi; export_settings; show_menu $1 $2;;
                    8) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${WORLD_PLAYER_LIMIT}" i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ $i > 0 ]]; then WORLD_PLAYER_LIMIT=$i; fi; export_settings; show_menu $1 $2;;
                    0) show_menu $1;;
                    9) show_menu $1 $2 $(($3+1));;
                    *) show_menu $1 $2;;
                esac
            elif [ $3 == 1 ]; then
                [ $WORLD_SKIP_CINEMATICS == 0 ] && WORLD_SKIP_CINEMATICS_TEXT="${COLOR_GREEN}Show for all characters"
                [ $WORLD_SKIP_CINEMATICS == 1 ] && WORLD_SKIP_CINEMATICS_TEXT="${COLOR_YELLOW}Show only for new races"
                [ $WORLD_SKIP_CINEMATICS == 2 ] && WORLD_SKIP_CINEMATICS_TEXT="${COLOR_RED}Never show"
                [ $WORLD_ALWAYS_MAX_SKILL == "false" ] && WORLD_ALWAYS_MAX_SKILL_TEXT="${COLOR_RED}Disabled" || WORLD_ALWAYS_MAX_SKILL_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_ALL_FLIGHT_PATHS == "false" ] && WORLD_ALL_FLIGHT_PATHS_TEXT="${COLOR_RED}Disabled" || WORLD_ALL_FLIGHT_PATHS_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_MAPS_EXPLORED == "false" ] && WORLD_MAPS_EXPLORED_TEXT="${COLOR_RED}Disabled" || WORLD_MAPS_EXPLORED_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_ALLOW_COMMANDS == "false" ] && WORLD_ALLOW_COMMANDS_TEXT="${COLOR_RED}Disabled" || WORLD_ALLOW_COMMANDS_TEXT="${COLOR_GREEN}Enabled"

                printf "${COLOR_PURPLE}Manage the world options (Page 2 of 5)${COLOR_END}\n"
                printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Intro cinematics: ${WORLD_SKIP_CINEMATICS_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Max level: ${COLOR_GREEN}${WORLD_MAX_LEVEL}${COLOR_END}\n"
                printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Starting level: ${COLOR_GREEN}${WORLD_START_LEVEL}${COLOR_END}\n"
                printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Starting money: ${COLOR_GREEN}${WORLD_START_MONEY} copper${COLOR_END}\n"
                printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Always max player skills: ${WORLD_ALWAYS_MAX_SKILL_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}6) ${COLOR_ORANGE}All flight paths: ${WORLD_ALL_FLIGHT_PATHS_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}7) ${COLOR_ORANGE}All maps explored: ${WORLD_MAPS_EXPLORED_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}8) ${COLOR_ORANGE}Allow player commands: ${WORLD_ALLOW_COMMANDS_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}9) ${COLOR_ORANGE}Go to the next page${COLOR_END}\n"
                printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous page${COLOR_END}\n"
                printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
                read -s -n 1 s

                case $s in
                    1) if [[ $WORLD_SKIP_CINEMATICS == 2 ]]; then WORLD_SKIP_CINEMATICS=0; else WORLD_SKIP_CINEMATICS=$(($WORLD_SKIP_CINEMATICS+1)); fi; export_settings; show_menu $1 $2 $3;;
                    2) printf "\r${COLOR_GREEN}Enter the new value [1-80]:${COLOR_END} "; read -e -i "${WORLD_MAX_LEVEL}" i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ ${#i} -lt 3 ]] && [[ $i > 0 ]] && [[ $i < 81 ]]; then WORLD_MAX_LEVEL=$i; fi; export_settings; show_menu $1 $2 $3;;
                    3) printf "\r${COLOR_GREEN}Enter the new value [1-80]:${COLOR_END} "; read -e -i "${WORLD_START_LEVEL}" i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ ${#i} -lt 3 ]] && [[ $i > 0 ]] && [[ $i < 81 ]]; then WORLD_START_LEVEL=$i; fi; export_settings; show_menu $1 $2 $3;;
                    4) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e -i "${WORLD_START_MONEY}" i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]]; then WORLD_START_MONEY=$i; fi; export_settings; show_menu $1 $2 $3;;
                    5) if [[ $WORLD_ALWAYS_MAX_SKILL == "false" ]]; then WORLD_ALWAYS_MAX_SKILL="true"; else WORLD_ALWAYS_MAX_SKILL="false"; fi; export_settings; show_menu $1 $2 $3;;
                    6) if [[ $WORLD_ALL_FLIGHT_PATHS == "false" ]]; then WORLD_ALL_FLIGHT_PATHS="true"; else WORLD_ALL_FLIGHT_PATHS="false"; fi; export_settings; show_menu $1 $2 $3;;
                    7) if [[ $WORLD_MAPS_EXPLORED == "false" ]]; then WORLD_MAPS_EXPLORED="true"; else WORLD_MAPS_EXPLORED="false"; fi; export_settings; show_menu $1 $2 $3;;
                    8) if [[ $WORLD_ALLOW_COMMANDS == "false" ]]; then WORLD_ALLOW_COMMANDS="true"; else WORLD_ALLOW_COMMANDS="false"; fi; export_settings; show_menu $1 $2 $3;;
                    0) show_menu $1 $2;;
                    9) show_menu $1 $2 $(($3+1));;
                    *) show_menu $1 $2 $3;;
                esac
            elif [ $3 == 2 ]; then
                [ $WORLD_QUEST_IGNORE_RAID == "false" ] && WORLD_QUEST_IGNORE_RAID_TEXT="${COLOR_RED}Disabled" || WORLD_QUEST_IGNORE_RAID_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_PREVENT_AFK_LOGOUT == "false" ] && WORLD_PREVENT_AFK_LOGOUT_TEXT="${COLOR_RED}Disabled" || WORLD_PREVENT_AFK_LOGOUT_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_PRELOAD_MAP_GRIDS == "false" ] && WORLD_PRELOAD_MAP_GRIDS_TEXT="${COLOR_RED}Disabled" || WORLD_PRELOAD_MAP_GRIDS_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_SET_WAYPOINTS_ACTIVE == "false" ] && WORLD_SET_WAYPOINTS_ACTIVE_TEXT="${COLOR_RED}Disabled" || WORLD_SET_WAYPOINTS_ACTIVE_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_ENABLE_MINIGOB_MANABONK == "false" ] && WORLD_ENABLE_MINIGOB_MANABONK_TEXT="${COLOR_RED}Disabled" || WORLD_ENABLE_MINIGOB_MANABONK_TEXT="${COLOR_GREEN}Enabled"

                printf "${COLOR_PURPLE}Manage the world options (Page 3 of 5)${COLOR_END}\n"
                printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Allow questing in a raid group: ${WORLD_QUEST_IGNORE_RAID_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Prevent AFK logout: ${WORLD_PREVENT_AFK_LOGOUT_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Max level to benefit from refer-a-friend: ${COLOR_GREEN}${WORLD_RAF_MAX_LEVEL}${COLOR_END}\n"
                printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Preload map grids: ${WORLD_PRELOAD_MAP_GRIDS_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Set all waypoints as active: ${WORLD_SET_WAYPOINTS_ACTIVE_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}6) ${COLOR_ORANGE}Enable Minigob Manabonk: ${WORLD_ENABLE_MINIGOB_MANABONK_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}7) ${COLOR_ORANGE}Rate of experience gain: ${COLOR_GREEN}${WORLD_RATE_EXPERIENCE}x${COLOR_END}\n"
                printf "${COLOR_CYAN}8) ${COLOR_ORANGE}Rate of rested experience gain: ${COLOR_GREEN}${WORLD_RATE_RESTED_EXP}x${COLOR_END}\n"
                printf "${COLOR_CYAN}9) ${COLOR_ORANGE}Go to the next page${COLOR_END}\n"
                printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous page${COLOR_END}\n"
                printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
                read -s -n 1 s

                case $s in
                    1) if [[ $WORLD_QUEST_IGNORE_RAID == "false" ]]; then WORLD_QUEST_IGNORE_RAID="true"; else WORLD_QUEST_IGNORE_RAID="false"; fi; export_settings; show_menu $1 $2 $3;;
                    2) if [[ $WORLD_PREVENT_AFK_LOGOUT == "false" ]]; then WORLD_PREVENT_AFK_LOGOUT="true"; else WORLD_PREVENT_AFK_LOGOUT="false"; fi; export_settings; show_menu $1 $2 $3;;
                    3) printf "\r${COLOR_GREEN}Enter the new value [1-80]:${COLOR_END} "; read -e -i "${WORLD_RAF_MAX_LEVEL}" i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ ${#i} -lt 3 ]] && [[ $i > 0 ]] && [[ $i < 81 ]]; then WORLD_RAF_MAX_LEVEL=$i; fi; export_settings; show_menu $1 $2 $3;;
                    4) if [[ $WORLD_PRELOAD_MAP_GRIDS == "false" ]]; then WORLD_PRELOAD_MAP_GRIDS="true"; else WORLD_PRELOAD_MAP_GRIDS="false"; fi; export_settings; show_menu $1 $2 $3;;
                    5) if [[ $WORLD_SET_WAYPOINTS_ACTIVE == "false" ]]; then WORLD_SET_WAYPOINTS_ACTIVE="true"; else WORLD_SET_WAYPOINTS_ACTIVE="false"; fi; export_settings; show_menu $1 $2 $3;;
                    6) if [[ $WORLD_ENABLE_MINIGOB_MANABONK == "false" ]]; then WORLD_ENABLE_MINIGOB_MANABONK="true"; else WORLD_ENABLE_MINIGOB_MANABONK="false"; fi; export_settings; show_menu $1 $2 $3;;
                    7) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ $i > 0 ]]; then WORLD_RATE_EXPERIENCE=$i; fi; export_settings; show_menu $1 $2 $3;;
                    8) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ $i > 0 ]]; then WORLD_RATE_RESTED_EXP=$i; fi; export_settings; show_menu $1 $2 $3;;
                    0) show_menu $1 $2 $(($3-1));;
                    9) show_menu $1 $2 $(($3+1));;
                    *) show_menu $1 $2 $3;;
                esac
            elif [ $3 == 3 ]; then
                [ $WORLD_GM_LOGIN_STATE == "false" ] && WORLD_GM_LOGIN_STATE_TEXT="${COLOR_RED}Inactive" || WORLD_GM_LOGIN_STATE_TEXT="${COLOR_GREEN}Active"
                [ $WORLD_GM_ENABLE_VISIBILITY == "false" ] && WORLD_GM_VISIBLE_TEXT="${COLOR_RED}Invisible" || WORLD_GM_VISIBLE_TEXT="${COLOR_GREEN}Visible"

                printf "${COLOR_PURPLE}Manage the world options (Page 4 of 5)${COLOR_END}\n"
                printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Rate of reputation gain: ${COLOR_GREEN}${WORLD_RATE_REPUTATION}x${COLOR_END}\n"
                printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Rate of gold gain: ${COLOR_GREEN}${WORLD_RATE_MONEY}x${COLOR_END}\n"
                printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Rate of crafting skill ups: ${COLOR_GREEN}${WORLD_RATE_CRAFTING}x${COLOR_END}\n"
                printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Rate of gathering skill ups: ${COLOR_GREEN}${WORLD_RATE_GATHERING}x${COLOR_END}\n"
                printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Rate of weapon skill ups: ${COLOR_GREEN}${WORLD_RATE_WEAPON_SKILL}x${COLOR_END}\n"
                printf "${COLOR_CYAN}6) ${COLOR_ORANGE}Rate of defense skill ups: ${COLOR_GREEN}${WORLD_RATE_DEFENSE_SKILL}x${COLOR_END}\n"
                printf "${COLOR_CYAN}7) ${COLOR_ORANGE}Set GM state when entering the world: ${WORLD_GM_LOGIN_STATE_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}8) ${COLOR_ORANGE}Set GM visibility when entering the world: ${WORLD_GM_VISIBLE_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}9) ${COLOR_ORANGE}Go to the next page${COLOR_END}\n"
                printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous page${COLOR_END}\n"
                printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
                read -s -n 1 s

                case $s in
                    1) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ $i > 0 ]]; then WORLD_RATE_REPUTATION=$i; fi; export_settings; show_menu $1 $2 $3;;
                    2) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ $i > 0 ]]; then WORLD_RATE_MONEY=$i; fi; export_settings; show_menu $1 $2 $3;;
                    3) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ $i > 0 ]]; then WORLD_RATE_CRAFTING=$i; fi; export_settings; show_menu $1 $2 $3;;
                    4) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ $i > 0 ]]; then WORLD_RATE_GATHERING=$i; fi; export_settings; show_menu $1 $2 $3;;
                    5) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ $i > 0 ]]; then WORLD_RATE_WEAPON_SKILL=$i; fi; export_settings; show_menu $1 $2 $3;;
                    6) printf "\r${COLOR_GREEN}Enter the new value:${COLOR_END} "; read -e i; if [[ ! -z $i ]] && [[ $i =~ ^[0-9]+$ ]] && [[ $i > 0 ]]; then WORLD_RATE_DEFENSE_SKILL=$i; fi; export_settings; show_menu $1 $2 $3;;
                    7) if [[ $WORLD_GM_LOGIN_STATE == "false" ]]; then WORLD_GM_LOGIN_STATE="true"; else WORLD_GM_LOGIN_STATE="false"; fi; export_settings; show_menu $1 $2 $3;;
                    8) if [[ $WORLD_GM_ENABLE_VISIBILITY == "false" ]]; then WORLD_GM_ENABLE_VISIBILITY="true"; else WORLD_GM_ENABLE_VISIBILITY="false"; fi; export_settings; show_menu $1 $2 $3;;
                    0) show_menu $1 $2 $(($3-1));;
                    9) show_menu $1 $2 $(($3+1));;
                    *) show_menu $1 $2 $3;;
                esac
            elif [ $3 == 4 ]; then
                [ $WORLD_GM_ENABLE_CHAT == "false" ] && WORLD_GM_CHAT_TEXT="${COLOR_RED}Disabled" || WORLD_GM_CHAT_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_GM_ENABLE_WHISPER == "false" ] && WORLD_GM_WHISPER_TEXT="${COLOR_RED}Disabled" || WORLD_GM_WHISPER_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_GM_SHOW_GM_LIST == 0 ] && WORLD_GM_GM_LIST_TEXT="${COLOR_RED}Disabled" || WORLD_GM_GM_LIST_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_GM_SHOW_WHO_LIST == 0 ] && WORLD_GM_WHO_LIST_TEXT="${COLOR_RED}Disabled" || WORLD_GM_WHO_LIST_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_GM_ALLOW_FRIEND == "false" ] && WORLD_GM_ALLOW_FRIEND_TEXT="${COLOR_RED}Disabled" || WORLD_GM_ALLOW_FRIEND_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_GM_ALLOW_INVITE == "false" ] && WORLD_GM_ALLOW_INVITE_TEXT="${COLOR_RED}Disabled" || WORLD_GM_ALLOW_INVITE_TEXT="${COLOR_GREEN}Enabled"
                [ $WORLD_GM_ALLOW_LOWER_SECURITY == "false" ] && WORLD_GM_LOWER_SECURITY_TEXT="${COLOR_RED}Disabled" || WORLD_GM_LOWER_SECURITY_TEXT="${COLOR_GREEN}Enabled"

                printf "${COLOR_PURPLE}Manage the world options (Page 5 of 5)${COLOR_END}\n"
                printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Set GM chat mode when entering the world: ${WORLD_GM_CHAT_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Allow GM whispers when entering the world: ${WORLD_GM_WHISPER_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Show GM in GM list: ${WORLD_GM_GM_LIST_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Show GM in who list: ${WORLD_GM_WHO_LIST_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}5) ${COLOR_ORANGE}Allow players to add a GM to the list of friends: ${WORLD_GM_ALLOW_FRIEND_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}6) ${COLOR_ORANGE}Allow players to invite a GM: ${WORLD_GM_ALLOW_INVITE_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}7) ${COLOR_ORANGE}Allow lower security GM to interact with higher security: ${WORLD_GM_LOWER_SECURITY_TEXT}${COLOR_END}\n"
                printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous page${COLOR_END}\n"
                printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
                read -s -n 1 s

                case $s in
                    1) if [[ $WORLD_GM_ENABLE_CHAT == "false" ]]; then WORLD_GM_ENABLE_CHAT="true"; else WORLD_GM_ENABLE_CHAT="false"; fi; export_settings; show_menu $1 $2 $3;;
                    2) if [[ $WORLD_GM_ENABLE_WHISPER == "false" ]]; then WORLD_GM_ENABLE_WHISPER="true"; else WORLD_GM_ENABLE_WHISPER="false"; fi; export_settings; show_menu $1 $2 $3;;
                    3) if [[ $WORLD_GM_SHOW_GM_LIST == 0 ]]; then WORLD_GM_SHOW_GM_LIST=3; else WORLD_GM_SHOW_GM_LIST=0; fi; export_settings; show_menu $1 $2 $3;;
                    4) if [[ $WORLD_GM_SHOW_WHO_LIST == 0 ]]; then WORLD_GM_SHOW_WHO_LIST=3; else WORLD_GM_SHOW_WHO_LIST=0; fi; export_settings; show_menu $1 $2 $3;;
                    5) if [[ $WORLD_GM_ALLOW_FRIEND == "false" ]]; then WORLD_GM_ALLOW_FRIEND="true"; else WORLD_GM_ALLOW_FRIEND="false"; fi; export_settings; show_menu $1 $2 $3;;
                    6) if [[ $WORLD_GM_ALLOW_INVITE == "false" ]]; then WORLD_GM_ALLOW_INVITE="true"; else WORLD_GM_ALLOW_INVITE="false"; fi; export_settings; show_menu $1 $2 $3;;
                    7) if [[ $WORLD_GM_ALLOW_LOWER_SECURITY == "false" ]]; then WORLD_GM_ALLOW_LOWER_SECURITY="true"; else WORLD_GM_ALLOW_LOWER_SECURITY="false"; fi; export_settings; show_menu $1 $2 $3;;
                    0) show_menu $1 $2 $(($3-1));;
                    *) show_menu $1 $2 $3;;
                esac
            fi
        elif [ $2 == 4 ]; then
            printf "${COLOR_PURPLE}Manage the available modules${COLOR_END}\n"
            printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Auction House Bot: ${COLOR_END}"
            [ $MODULE_AHBOT_ENABLED == "true" ] && printf "${COLOR_GREEN}Enabled${COLOR_END}\n" || printf "${COLOR_RED}Disabled${COLOR_END}\n"
            printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Eluna LUA Engine: ${COLOR_END}"
            [ $MODULE_ELUNA_ENABLED == "true" ] && printf "${COLOR_GREEN}Enabled${COLOR_END}\n" || printf "${COLOR_RED}Disabled${COLOR_END}\n"
            printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
            printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
            read -s -n 1 s

            case $s in
                1) if [ $MODULE_AHBOT_ENABLED == "true" ]; then MODULE_AHBOT_ENABLED="false"; else MODULE_AHBOT_ENABLED="true"; fi; export_settings; show_menu $1 $2;;
                2) if [ $MODULE_ELUNA_ENABLED == "true" ]; then MODULE_ELUNA_ENABLED="false"; else MODULE_ELUNA_ENABLED="true"; fi; export_settings; show_menu $1 $2;;
                0) show_menu $1;;
                *) show_menu $1 $2 $3;;
            esac
        fi
    fi
}
