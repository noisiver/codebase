#!/bin/bash
DISTRIBUTION=("debian11" "ubuntu20.04" "ubuntu20.10" "ubuntu21.04" "ubuntu21.10")

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID

    if [[ ! " ${DISTRIBUTION[@]} " =~ " ${OS}${VERSION} " ]]; then
        echo -e "\e[0;31mThis distribution is currently not supported\e[0m"
        exit $?
    fi
fi

# Define colors for easier access
COLOR_BLACK="\e[0;30m"
COLOR_RED="\e[0;31m"
COLOR_GREEN="\e[0;32m"
COLOR_ORANGE="\e[0;33m"
COLOR_BLUE="\e[0;34m"
COLOR_PURPLE="\e[0;35m"
COLOR_CYAN="\e[0;36m"
COLOR_LIGHT_GRAY="\e[0;37m"
COLOR_DARK_GRAY="\e[1;30m"
COLOR_LIGHT_RED="\e[1;31m"
COLOR_LIGHT_GREEN="\e[1;32m"
COLOR_YELLOW="\e[1;33m"
COLOR_LIGHT_BLUE="\e[1;34m"
COLOR_LIGHT_PURPLE="\e[1;35m"
COLOR_LIGHT_CYAN="\e[1;36m"
COLOR_WHITE="\e[1;37m"
COLOR_END="\e[0m"

ROOT=$(pwd)

# A function to install the options package
function options_package
{
    # Different distributions are handled in their own way. This is unnecessary but will help if other distributions are added in the future
    if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
        # Check if the package is installed
        if [ $(dpkg-query -W -f='${Status}' libxml2-utils 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            clear

            # Perform an update to make sure nothing is missing
            apt-get --yes update
            if [ $? -ne 0 ]; then
                exit $?
            fi

            # Install the package that is missing
            apt-get --yes install libxml2-utils
            if [ $? -ne 0 ]; then
                exit $?
            fi
        fi
    fi
}

# A function to install the git package
function git_package
{
    # Different distributions are handled in their own way. This is unnecessary but will help if other distributions are added in the future
    if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
        # Check if the package is installed
        if [ $(dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            clear

            # Perform an update to make sure nothing is missing
            apt-get --yes update
            if [ $? -ne 0 ]; then
                exit $?
            fi

            # Install the package that is missing
            apt-get --yes install git
            if [ $? -ne 0 ]; then
                exit $?
            fi
        fi
    fi
}

# A function to install all required packages for compilation of and to run the core
function source_packages
{
    # Different distributions are handled in their own way. This is unnecessary but will help if other distributions are added in the future
    if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
        # An array of all required packages
        PACKAGES=("cmake" "make" "gcc" "clang" "screen" "curl" "unzip" "g++" "libssl-dev" "libbz2-dev" "libreadline-dev" "libncurses-dev" "libace-6.*" "libace-dev" "libboost1.74-all-dev" "libmariadb-dev-compat" "mariadb-client")

        # Handle each distribution properly as some require different packages
        if [[ $OS == "ubuntu" ]]; then
            if [[ $VERSION == "20.04" ]] || [[ $VERSION == "20.10" ]]; then
                PACKAGES="${PACKAGES} libmariadbclient-dev"
            fi
        fi

        # Loop through each member of the array and add them to the list of packages to be installed
        for p in "${PACKAGES[@]}"; do
            # Check if the package is installed
            if [ $(dpkg-query -W -f='${Status}' $p 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
                INSTALL+=($p)
            fi
        done

        # Check if there actually are packages to install
        if [ ${#INSTALL[@]} -gt 0 ]; then
            clear

            # Perform an update to make sure nothing is missing
            apt-get --yes update
            if [ $? -ne 0 ]; then
                exit $?
            fi

            # Install all packages that are missing
            apt-get --yes install ${INSTALL[*]}
            if [ $? -ne 0 ]; then
                exit $?
            fi
        fi
    fi
}

# A function to install the mariadb client package
function database_package
{
    # Different distributions are handled in their own way. This is unnecessary but will help if other distributions are added in the future
    if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
        # Check if the package is installed
        if [ $(dpkg-query -W -f='${Status}' mariadb-client 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            clear

            # Perform an update to make sure nothing is missing
            apt-get --yes update
            if [ $? -ne 0 ]; then
                exit $?
            fi

            # Install the package that is missing
            apt-get --yes install mariadb-client
            if [ $? -ne 0 ]; then
                exit $?
            fi
        fi
    fi
}

# A function to save all options to the file
function store_options
{
    echo "<?xml version=\"1.0\"?>
    <options>
        <mysql>
            <!-- The ip-address or hostname used to connect to the database server -->
            <hostname>${1:-127.0.0.1}</hostname>
            <!-- The port used to connect to the database server -->
            <port>${2:-3306}</port>
            <!-- The username used to connect to the database server -->
            <username>${3:-acore}</username>
            <!-- The password used to connect to the database server -->
            <password>${4:-acore}</password>
            <databases>
                <!-- The name of the auth database -->
                <auth>${5:-acore_auth}</auth>
                <!-- The name of the characters database -->
                <characters>${6:-acore_characters}</characters>
                <!-- The name of the world database -->
                <world>${7:-acore_world}</world>
            </databases>
        </mysql>
        <source>
            <!-- The location where the source is located -->
            <location>${8:-/opt/azerothcore}</location>
            <!-- The required client data version -->
            <required_client_data>${9:-12}</required_client_data>
            <!-- The installed client data version. WARNING: DO NOT EDIT -->
            <installed_client_data>${10:-0}</installed_client_data>
        </source>
        <world>
            <!-- The name of the realm as seen in the list -->
            <name>${11:-AzerothCore}</name>
            <!-- Message of the Day, displayed at login. Use '@' for a newline and make sure to escape special characters -->
            <motd>${12:-Welcome to AzerothCore.}</motd>
            <!-- The id of the realm -->
            <id>${13:-1}</id>
            <!-- The ip or hostname used to connect to the world server. Use external ip if required -->
            <address>${14:-127.0.0.1}</address>
            <!-- Server game type. 0 = normal, 1 = pvp, 6 = rp, 8 = rppvp -->
            <game_type>${15:-0}</game_type>
            <!-- Server realm zone. Set allowed alphabet in character names etc. 1 = development, 2 = united states, 6 = korea, 9 = german, 10 = french, 11 = spanish, 12 = russian, 14 = taiwan, 16 = china, 26 = test server -->
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
            <!-- Enable Warden anti-cheat system. false = disabled, true = enabled -->
            <enable_warden>${33:-true}</enable_warden>
            <!-- Allow players to stay in regular groups when logging off. This only affects normal groups and not raids or dungeon finder groups. false = players will leave their group when logging off, true = players will stay in their groups -->
            <disable_leave_group>${34:-false}</disable_leave_group>
            <rates>
                <!-- Experience rates (outside battleground) -->
                <experience>${35:-1}</experience>
                <!-- Resting points grow rates -->
                <rested_experience>${36:-1}</rested_experience>
                <!-- Reputation gain rate -->
                <reputation>${37:-1}</reputation>
                <!-- Drop rates for money -->
                <money>${38:-1}</money>
                <!-- Crafting skills gain rate -->
                <crafting>${39:-1}</crafting>
                <!-- Gathering skills gain rate -->
                <gathering>${40:-1}</gathering>
                <!-- Weapon skills gain rate -->
                <weapon_skill>${41:-1}</weapon_skill>
                <!-- Defense skills gain rate -->
                <defense_skill>${42:-1}</defense_skill>
            </rates>
            <gm>
                <!-- Set GM state when a GM character enters the world. false = disabled, true = enabled -->
                <login_state>${43:-true}</login_state>
                <!-- GM visibility at login. false = disabled, true = enabled -->
                <enable_visibility>${44:-false}</enable_visibility>
                <!-- GM chat mode at login. false = disabled, true = enabled -->
                <enable_chat>${45:-true}</enable_chat>
                <!-- Is GM accepting whispers from player by default or not. false = disabled, true = enabled -->
                <enable_whisper>${46:-false}</enable_whisper>
                <!-- Maximum GM level shown in GM list (if enabled) in non-GM state. 0 = only players, 1 = only moderators, 2 = only gamemasters, 3 = anyone -->
                <show_gm_list>${47:-1}</show_gm_list>
                <!-- Max GM level showed in who list (if visible). 0 = only players, 1 = only moderators, 2 = only gamemasters, 3 = anyone -->
                <show_who_list>${48:-0}</show_who_list>
                <!-- Allow players to add GM characters to their friends list. false = disabled, true = enabled -->
                <allow_friend>${49:-false}</allow_friend>
                <!-- Allow players to invite GM characters. false = disabled, true = enabled -->
                <allow_invite>${50:-false}</allow_invite>
                <!-- Allow lower security levels to use commands on higher security level characters. false = disabled, true = enabled -->
                <allow_lower_security>${51:-false}</allow_lower_security>
            </gm>
        </world>
        <modules>
            <ahbot>
                <!-- Enable/Disable the use of the AHBot module -->
                <enabled>${52:-false}</enabled>
                <!-- Enable/Disable the part of AHBot that buys items from players -->
                <enable_buyer>${53:-false}</enable_buyer>
                <!-- Enable/Disable the part of AHBot that puts items up for auction -->
                <enable_seller>${54:-false}</enable_seller>
                <!-- Account id is the account number (account) of the player you want to use as the auction bot -->
                <account_id>${55:-0}</account_id>
                <!-- Character guid is the GUID (characters table) of the player you want to use as the auction bot -->
                <character_guid>${56:-0}</character_guid>
                <!-- Minimum amount of items the bot will keep on the auction house. 0 = use the same value as max_items -->
                <min_items>${57:-250}</min_items>
                <!-- Maximum amount of items the bot will keep on the auction house -->
                <max_items>${58:-250}</max_items>
            </ahbot>
            <assistant>
                <!-- Enable/Disable the use of the Assistant module. It adds an NPC that players can obtain certain items from -->
                <enabled>${59:-false}</enabled>
                <features>
                    <!-- Enable/Disable obtaining heirlooms from the assistant -->
                    <heirlooms>${60:-false}</heirlooms>
                    <!-- Enable/Disable obtaining glyphs from the assistant -->
                    <glyphs>${61:-false}</glyphs>
                    <!-- Enable/Disable obtaining gems from the assistant -->
                    <gems>${62:-false}</gems>
                    <!-- Enable/Disable obtaining containers from the assistant -->
                    <containers>${63:-false}</containers>
                    <utilities>
                        <!-- Enable/Disable obtaining utilities from the assistant -->
                        <enabled>${64:-false}</enabled>
                        <!-- Cost in gold required to perform a name change -->
                        <name_change>${65:-10}</name_change>
                        <!-- Cost in gold required to perform a customization -->
                        <customization>${66:-50}</customization>
                        <!-- Cost in gold to perform a race change -->
                        <race_change>${67:-500}</race_change>
                        <!-- Cost in gold to perform a faction change -->
                        <faction_change>${68:-1000}</faction_change>
                    </utilities>
                    <professions>
                        <!-- Enable/Disable increasing profession skills levels at the assistant -->
                        <enabled>${69:-false}</enabled>
                        <apprentice>
                            <!-- Enable/Disable increasing apprentice rank to level 75 -->
                            <enabled>${70:-false}</enabled>
                            <!-- The amount of gold required to increase this rank -->
                            <cost>${71:-100}</cost>
                        </apprentice>
                        <journeyman>
                            <!-- Enable/Disable increasing journeyman rank to level 150 -->
                            <enabled>${72:-false}</enabled>
                            <!-- The amount of gold required to increase this rank -->
                            <cost>${73:-250}</cost>
                        </journeyman>
                        <expert>
                            <!-- Enable/Disable increasing expert rank to level 225 -->
                            <enabled>${74:-false}</enabled>
                            <!-- The amount of gold required to increase this rank -->
                            <cost>${75:-500}</cost>
                        </expert>
                        <artisan>
                            <!-- Enable/Disable increasing artisan rank to level 300 -->
                            <enabled>${76:-false}</enabled>
                            <!-- The amount of gold required to increase this rank -->
                            <cost>${77:-750}</cost>
                        </artisan>
                        <master>
                            <!-- Enable/Disable increasing master rank to level 375 -->
                            <enabled>${78:-false}</enabled>
                            <!-- The amount of gold required to increase this rank -->
                            <cost>${79:-1250}</cost>
                        </master>
                        <grand_master>
                            <!-- Enable/Disable increasing grand master rank to level 450 -->
                            <enabled>${80:-false}</enabled>
                            <!-- The amount of gold required to increase this rank -->
                            <cost>${81:-2500}</cost>
                        </grand_master>
                    </professions>
                </features>
            </assistant>
            <eluna>
                <!-- Enable/Disable the use of the Eluna LUA engine module -->
                <enabled>${82:-false}</enabled>
            </eluna>
            <group_quests>
                <!-- Enable/Disable the use of the Group Quests module. It changes items dropped by creatures to be lootable by all members of a group, changes the respawn time of objects to help groups loot the same object, changes scripts to give credit to all members of a group etc -->
                <enabled>${83:-false}</enabled>
            </group_quests>
            <learn_spells>
                <!-- Enable/Disable the use of the Learn Spells module. It teaches players all specified spells when entering the world or when leveling up -->
                <enabled>${84:-false}</enabled>
                <spells>
                    <!-- Enable/Disable learning spells when entering the world -->
                    <on_login>${85:-false}</on_login>
                    <!-- Enable/Disable learning spells when leveling up -->
                    <on_levelup>${86:-false}</on_levelup>
                    <!-- Enable/Disable learning class-specific spells when leveling up or entering the world -->
                    <class_spells>${87:-false}</class_spells>
                    <!-- Enable/Disable learning new talent ranks when leveling up or entering the world -->
                    <talent_ranks>${88:-false}</talent_ranks>
                    <!-- Enable/Disable learning new weapon and armor skills when leveling up -->
                    <proficiencies>${89:-false}</proficiencies>
                    <!-- Enable/Disable spells that are normally obtained through quests -->
                    <from_quests>${90:-false}</from_quests>
                    <max_skill>
                        <!-- Enable/Disable setting weapon skills to their max value when leveling up or entering the world -->
                        <enabled>${91:-false}</enabled>
                        <!-- The max level where weapon skills will be set to their max value -->
                        <max_level>${92:-60}</max_level>
                    </max_skill>
                    <riding>
                        <!-- Enable/Disable learning riding skills when leveling up or entering the world -->
                        <enabled>${93:-false}</enabled>
                        <!-- Enable/Disable learning the apprentice (75%) riding skill and mounts when leveling up or entering the world -->
                        <apprentice>${94:-false}</apprentice>
                        <!-- Enable/Disable learning the journeyman (150%) riding skill and mounts when leveling up or entering the world -->
                        <journeyman>${95:-false}</journeyman>
                        <!-- Enable/Disable learning the journeyman (225%) riding skill and mounts when leveling up or entering the world -->
                        <expert>${96:-false}</expert>
                        <!-- Enable/Disable learning the artisan (300%) riding skill and mounts when leveling up or entering the world -->
                        <artisan>${97:-false}</artisan>
                        <!-- Enable/Disable learning the cold weather flying skill (level 77) when leveling up or entering the world -->
                        <cold_weather>${98:-false}</cold_weather>
                    </riding>
                </spells>
            </learn_spells>
            <level_reward>
                <!-- Enable/Disable the use of the Level Reward module. It will give players a reward of gold when reaching specific levels -->
                <enabled>${99:-false}</enabled>
                <gold>
                    <!-- The amount of gold given at level 10 -->
                    <level_10>${100:-5}</level_10>
                    <!-- The amount of gold given at level 20 -->
                    <level_20>${101:-15}</level_20>
                    <!-- The amount of gold given at level 30 -->
                    <level_30>${102:-30}</level_30>
                    <!-- The amount of gold given at level 40 -->
                    <level_40>${103:-45}</level_40>
                    <!-- The amount of gold given at level 50 -->
                    <level_50>${104:-60}</level_50>
                    <!-- The amount of gold given at level 60 -->
                    <level_60>${105:-80}</level_60>
                    <!-- The amount of gold given at level 70 -->
                    <level_70>${106:-125}</level_70>
                    <!-- The amount of gold given at level 80 -->
                    <level_80>${107:-250}</level_80>
                </gold>
            </level_reward>
            <recruit_a_friend>
                <!-- Enable/Disable the use of the Recruit-A-Friend module. Players can recruit other players by using a simple in-game command -->
                <enabled>${108:-false}</enabled>
                <!-- The amount of days that recruit-a-friend stays active. 0 = never expires -->
                <duration>${109:-90}</duration>
                <!-- The amount of days since the account was created where it can still be recruited. 0 = no limit -->
                <account_age>${110:-7}</account_age>
                <rewards>
                    <!-- The amount of days that has to pass before the accounts receive rewards. 0 = never give rewards -->
                    <days>${111:-30}</days>
                    <!-- Give the Swift Zhevra item as a reward -->
                    <swift_zhevra>${112:-true}</swift_zhevra>
                    <!-- Give the X-53 Touring Rocket item as a reward -->
                    <touring_rocket>${113:-true}</touring_rocket>
                </rewards>
            </recruit_a_friend>
            <skip_dk_starting_area>
                <!-- Enable/Disable the use of the Skip DK Starting Area module -->
                <enabled>${114:-false}</enabled>
                <!-- The level that death knight starts at -->
                <starting_level>${115:-58}</starting_level>
            </skip_dk_starting_area>
            <spawn_points>
                <!-- Enable/Disable the use of the Spawn Points module. It will spawn new characters in specified locations -->
                <enabled>${116:-false}</enabled>
            </spawn_points>
            <weekend_bonus>
                <!-- Enable/Disable the use of the Weekend Bonus module. It will increase the experience and reputation gains on friday, saturday and sunday -->
                <enabled>${117:-false}</enabled>
                <!-- The multiplier for experience on weekends -->
                <experience_multiplier>${118:-2.0}</experience_multiplier>
                <!-- The multiplier for money looted and rewarded from quests on weekends -->
                <money_multiplier>${119:-2.0}</money_multiplier>
                <!-- The multiplier for profession skill ups on weekends -->
                <professions_multiplier>${120:-2}</professions_multiplier>
                <!-- The multiplier for reputation on weekends -->
                <reputation_multiplier>${121:-2.0}</reputation_multiplier>
                <!-- The multiplier for weapons and defense skill ups on weekends -->
                <proficiencies_multiplier>${122:-2}</proficiencies_multiplier>
            </weekend_bonus>
        </modules>
    </options>" | xmllint --format - > $OPTIONS
}

# A function that sends all variables to the store_options function
function save_options
{
    store_options \
    $OPTION_MYSQL_HOSTNAME \
    $OPTION_MYSQL_PORT \
    $OPTION_MYSQL_USERNAME \
    $OPTION_MYSQL_PASSWORD \
    $OPTION_MYSQL_DATABASES_AUTH \
    $OPTION_MYSQL_DATABASES_CHARACTERS \
    $OPTION_MYSQL_DATABASES_WORLD \
    "$OPTION_SOURCE_LOCATION" \
    $OPTION_SOURCE_REQUIRED_CLIENT_DATA \
    $OPTION_SOURCE_INSTALLED_CLIENT_DATA \
    "$OPTION_WORLD_NAME" \
    "$OPTION_WORLD_MOTD" \
    $OPTION_WORLD_ID \
    $OPTION_WORLD_ADDRESS \
    $OPTION_WORLD_GAME_TYPE \
    $OPTION_WORLD_REALM_ZONE \
    $OPTION_WORLD_EXPANSION \
    $OPTION_WORLD_PLAYER_LIMIT \
    $OPTION_WORLD_SKIP_CINEMATICS \
    $OPTION_WORLD_MAX_LEVEL \
    $OPTION_WORLD_START_LEVEL \
    $OPTION_WORLD_START_MONEY \
    $OPTION_WORLD_ALWAYS_MAX_SKILL \
    $OPTION_WORLD_ALL_FLIGHT_PATHS \
    $OPTION_WORLD_MAPS_EXPLORED \
    $OPTION_WORLD_ALLOW_COMMANDS \
    $OPTION_WORLD_QUEST_IGNORE_RAID \
    $OPTION_WORLD_PREVENT_AFK_LOGOUT \
    $OPTION_WORLD_RAF_MAX_LEVEL \
    $OPTION_WORLD_PRELOAD_MAP_GRIDS \
    $OPTION_WORLD_SET_ALL_WAYPOINTS_ACTIVE \
    $OPTION_WORLD_ENABLE_MINIGOB_MANABONK \
    $OPTION_WORLD_ENABLE_WARDEN \
    $OPTION_WORLD_DISABLE_LEAVE_GROUP \
    $OPTION_WORLD_RATES_EXPERIENCE \
    $OPTION_WORLD_RATES_RESTED_EXPERIENCE \
    $OPTION_WORLD_RATES_REPUTATION \
    $OPTION_WORLD_RATES_MONEY \
    $OPTION_WORLD_RATES_CRAFTING \
    $OPTION_WORLD_RATES_GATHERING \
    $OPTION_WORLD_RATES_WEAPON_SKILL \
    $OPTION_WORLD_RATES_DEFENSE_SKILL \
    $OPTION_WORLD_GM_LOGIN_STATE \
    $OPTION_WORLD_GM_ENABLE_VISIBILITY \
    $OPTION_WORLD_GM_ENABLE_CHAT \
    $OPTION_WORLD_GM_ENABLE_WHISPER \
    $OPTION_WORLD_GM_SHOW_GM_LIST \
    $OPTION_WORLD_GM_SHOW_WHO_LIST \
    $OPTION_WORLD_GM_ALLOW_FRIEND \
    $OPTION_WORLD_GM_ALLOW_INVITE \
    $OPTION_WORLD_GM_ALLOW_LOWER_SECURITY \
    $OPTION_MODULES_AHBOT_ENABLED \
    $OPTION_MODULES_AHBOT_ENABLE_BUYER \
    $OPTION_MODULES_AHBOT_ENABLE_SELLER \
    $OPTION_MODULES_AHBOT_ACCOUNT_ID \
    $OPTION_MODULES_AHBOT_CHARACTER_GUID \
    $OPTION_MODULES_AHBOT_MIN_ITEMS \
    $OPTION_MODULES_AHBOT_MAX_ITEMS \
    $OPTION_MODULES_ASSISTANT_ENABLED \
    $OPTION_MODULES_ASSISTANT_FEATURES_HEIRLOOMS \
    $OPTION_MODULES_ASSISTANT_FEATURES_GLYPHS \
    $OPTION_MODULES_ASSISTANT_FEATURES_GEMS \
    $OPTION_MODULES_ASSISTANT_FEATURES_CONTAINERS \
    $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_ENABLED \
    $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_NAME_CHANGE \
    $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_CUSTOMIZATION \
    $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_RACE_CHANGE \
    $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_FACTION_CHANGE \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ENABLED \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_ENABLED \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_COST \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_ENABLED \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_COST \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_ENABLED \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_COST \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_ENABLED \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_COST \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_ENABLED \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_COST \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_ENABLED \
    $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_COST \
    $OPTION_MODULES_ELUNA_ENABLED \
    $OPTION_MODULES_GROUP_QUESTS_ENABLED \
    $OPTION_MODULES_LEARN_SPELLS_ENABLED \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LOGIN \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LEVELUP \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_CLASS_SPELLS \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_TALENT_RANKS \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_PROFICIENCIES \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_FROM_QUESTS \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_ENABLED \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_MAX_LEVEL \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ENABLED \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_APPRENTICE \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_JOURNEYMAN \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_EXPERT \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ARTISAN \
    $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_COLD_WEATHER \
    $OPTION_MODULES_LEVEL_REWARD_ENABLED \
    $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_10 \
    $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_20 \
    $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_30 \
    $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_40 \
    $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_50 \
    $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_60 \
    $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_70 \
    $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_80 \
    $OPTION_MODULES_RECRUIT_A_FRIEND_ENABLED \
    $OPTION_MODULES_RECRUIT_A_FRIEND_DURATION \
    $OPTION_MODULES_RECRUIT_A_FRIEND_ACCOUNT_AGE \
    $OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_DAYS \
    $OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_SWIFT_ZHEVRA \
    $OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_TOURING_ROCKET \
    $OPTION_MODULES_SKIP_DK_STARTING_AREA_ENABLED \
    $OPTION_MODULES_SKIP_DK_STARTING_AREA_STARTING_LEVEL \
    $OPTION_MODULES_SPAWN_POINTS_ENABLED \
    $OPTION_MODULES_WEEKEND_BONUS_ENABLED \
    $OPTION_MODULES_WEEKEND_BONUS_EXPERIENCE_MULTIPLIER \
    $OPTION_MODULES_WEEKEND_BONUS_MONEY_MULTIPLIER \
    $OPTION_MODULES_WEEKEND_BONUS_PROFESSIONS_MULTIPLIER \
    $OPTION_MODULES_WEEKEND_BONUS_REPUTATION_MULTIPLIER \
    $OPTION_MODULES_WEEKEND_BONUS_PROFICIENCIES_MULTIPLIER
}

# A function that loads options from the file
function load_options
{
    # Install required package
    options_package

    # The file where all options are stored
    OPTIONS="$ROOT/options.xml"

    # Check if the file is missing
    if [ ! -f $OPTIONS ]; then
        # Create the file with the default options
        printf "${COLOR_RED}The options file is missing. Creating one with the default options.${COLOR_END}\n"
        printf "${COLOR_RED}Make sure to edit it to prevent issues that might occur otherwise.${COLOR_END}\n"
        store_options
        exit $?
    fi

    # Load the /options/mysql/hostname option
    OPTION_MYSQL_HOSTNAME="$(echo "cat /options/mysql/hostname/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_MYSQL_HOSTNAME ] || [[ $OPTION_MYSQL_HOSTNAME == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/mysql/hostname is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MYSQL_HOSTNAME="127.0.0.1"
        RESET=true
    fi

    # Load the /options/mysql/port option
    OPTION_MYSQL_PORT="$(echo "cat /options/mysql/port/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MYSQL_PORT =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/mysql/port is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MYSQL_PORT="3306"
        RESET=true
    fi

    # Load the /options/mysql/username option
    OPTION_MYSQL_USERNAME="$(echo "cat /options/mysql/username/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_MYSQL_USERNAME ] || [[ $OPTION_MYSQL_USERNAME == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/mysql/username is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MYSQL_USERNAME="acore"
        RESET=true
    fi

    # Load the /options/mysql/password option
    OPTION_MYSQL_PASSWORD="$(echo "cat /options/mysql/password/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_MYSQL_PASSWORD ] || [[ $OPTION_MYSQL_PASSWORD == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/mysql/password is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MYSQL_PASSWORD="acore"
        RESET=true
    fi

    # Load the /options/mysql/databases/auth option
    OPTION_MYSQL_DATABASES_AUTH="$(echo "cat /options/mysql/databases/auth/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_MYSQL_DATABASES_AUTH ] || [[ $OPTION_MYSQL_DATABASES_AUTH == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/mysql/databases/auth is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MYSQL_DATABASES_AUTH="acore_auth"
        RESET=true
    fi

    # Load the /options/mysql/databases/characters option
    OPTION_MYSQL_DATABASES_CHARACTERS="$(echo "cat /options/mysql/databases/characters/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_MYSQL_DATABASES_CHARACTERS ] || [[ $OPTION_MYSQL_DATABASES_CHARACTERS == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/mysql/databases/characters is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MYSQL_DATABASES_CHARACTERS="acore_characters"
        RESET=true
    fi

    # Load the /options/mysql/databases/world option
    OPTION_MYSQL_DATABASES_WORLD="$(echo "cat /options/mysql/databases/world/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_MYSQL_DATABASES_WORLD ] || [[ $OPTION_MYSQL_DATABASES_WORLD == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/mysql/databases/world is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MYSQL_DATABASES_WORLD="acore_world"
        RESET=true
    fi

    # Load the /options/source/location option
    OPTION_SOURCE_LOCATION="$(echo "cat /options/source/location/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [ -z $OPTION_SOURCE_LOCATION ] || [[ $OPTION_SOURCE_LOCATION == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/source/location is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_SOURCE_LOCATION="/opt/azerothcore"
        RESET=true
    fi

    # Load the /options/source/required_client_data option
    OPTION_SOURCE_REQUIRED_CLIENT_DATA="$(echo "cat /options/source/required_client_data/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_SOURCE_REQUIRED_CLIENT_DATA =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/source/required_client_data is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_SOURCE_REQUIRED_CLIENT_DATA="14"
        RESET=true
    fi

    # Load the /options/source/installed_client_data option
    OPTION_SOURCE_INSTALLED_CLIENT_DATA="$(echo "cat /options/source/installed_client_data/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_SOURCE_INSTALLED_CLIENT_DATA =~ ^[0-9]+$ ]] || [ $OPTION_SOURCE_INSTALLED_CLIENT_DATA -gt $OPTION_SOURCE_REQUIRED_CLIENT_DATA ]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/source/installed_client_data is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_SOURCE_INSTALLED_CLIENT_DATA="0"
        RESET=true
    fi

    # Load the /options/world/name option
    OPTION_WORLD_NAME="$(echo "cat /options/world/name/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ -z $OPTION_WORLD_NAME ]] || [[ $OPTION_WORLD_NAME == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/name is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_NAME="AzerothCore"
        RESET=true
    fi

    # Load the /options/world/motd option
    OPTION_WORLD_MOTD="$(echo "cat /options/world/motd/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ -z $OPTION_WORLD_MOTD ]] || [[ $OPTION_WORLD_MOTD == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/motd is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_MOTD="Welcome to AzerothCore."
        RESET=true
    fi

    # Load the /options/world/id option
    OPTION_WORLD_ID="$(echo "cat /options/world/id/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_ID =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/id is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_ID="1"
        RESET=true
    fi

    # Load the /options/world/address option
    OPTION_WORLD_ADDRESS="$(echo "cat /options/world/address/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ -z $OPTION_WORLD_ADDRESS ]] || [[ $OPTION_WORLD_ADDRESS == "" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/address is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_ADDRESS="127.0.0.1"
        RESET=true
    fi

    # Load the /options/world/game_type option
    OPTION_WORLD_GAME_TYPE="$(echo "cat /options/world/game_type/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_GAME_TYPE =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_GAME_TYPE != 0 && $OPTION_WORLD_GAME_TYPE != 1 && $OPTION_WORLD_GAME_TYPE != 6 && $OPTION_WORLD_GAME_TYPE != 8 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/game_type is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_GAME_TYPE="0"
        RESET=true
    fi

    # Load the /options/world/realm_zone option
    OPTION_WORLD_REALM_ZONE="$(echo "cat /options/world/realm_zone/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_REALM_ZONE =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_REALM_ZONE != 1 && $OPTION_WORLD_REALM_ZONE != 2 && $OPTION_WORLD_REALM_ZONE != 6 && $OPTION_WORLD_REALM_ZONE != 9 && $OPTION_WORLD_REALM_ZONE != 10 && $OPTION_WORLD_REALM_ZONE != 11 && $OPTION_WORLD_REALM_ZONE != 12 && $OPTION_WORLD_REALM_ZONE != 14 && $OPTION_WORLD_REALM_ZONE != 16 && $OPTION_WORLD_REALM_ZONE != 26 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/realm_zone is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_REALM_ZONE="1"
        RESET=true
    fi

    # Load the /options/world/expansion option
    OPTION_WORLD_EXPANSION="$(echo "cat /options/world/expansion/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_EXPANSION =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_EXPANSION != 0 && $OPTION_WORLD_EXPANSION != 1 && $OPTION_WORLD_EXPANSION != 2 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/expansion is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_EXPANSION="2"
        RESET=true
    fi

    # Load the /options/world/player_limit option
    OPTION_WORLD_PLAYER_LIMIT="$(echo "cat /options/world/player_limit/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_PLAYER_LIMIT =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/player_limit is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_PLAYER_LIMIT="1000"
        RESET=true
    fi

    # Load the /options/world/skip_cinematics option
    OPTION_WORLD_SKIP_CINEMATICS="$(echo "cat /options/world/skip_cinematics/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_SKIP_CINEMATICS =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_SKIP_CINEMATICS != 0 && $OPTION_WORLD_SKIP_CINEMATICS != 1 && $OPTION_WORLD_SKIP_CINEMATICS != 2 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/skip_cinematics is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_SKIP_CINEMATICS="0"
        RESET=true
    fi

    # Load the /options/world/max_level option
    OPTION_WORLD_MAX_LEVEL="$(echo "cat /options/world/max_level/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_MAX_LEVEL =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_MAX_LEVEL < 1 || $OPTION_WORLD_MAX_LEVEL > 80 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/max_level is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_MAX_LEVEL="80"
        RESET=true
    fi

    # Load the /options/world/start_level option
    OPTION_WORLD_START_LEVEL="$(echo "cat /options/world/start_level/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_START_LEVEL =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_START_LEVEL < 1 || $OPTION_WORLD_START_LEVEL > 80 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/start_level is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_START_LEVEL="1"
        RESET=true
    fi

    # Load the /options/world/start_money option
    OPTION_WORLD_START_MONEY="$(echo "cat /options/world/start_money/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_START_MONEY =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/start_money is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_START_MONEY="0"
        RESET=true
    fi

    # Load the /options/world/always_max_skill option
    OPTION_WORLD_ALWAYS_MAX_SKILL="$(echo "cat /options/world/always_max_skill/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_ALWAYS_MAX_SKILL != "true" && $OPTION_WORLD_ALWAYS_MAX_SKILL != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/always_max_skill is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_ALWAYS_MAX_SKILL="false"
        RESET=true
    fi

    # Load the /options/world/all_flight_paths option
    OPTION_WORLD_ALL_FLIGHT_PATHS="$(echo "cat /options/world/all_flight_paths/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_ALL_FLIGHT_PATHS != "true" && $OPTION_WORLD_ALL_FLIGHT_PATHS != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/all_flight_paths is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_ALL_FLIGHT_PATHS="false"
        RESET=true
    fi

    # Load the /options/world/maps_explored option
    OPTION_WORLD_MAPS_EXPLORED="$(echo "cat /options/world/maps_explored/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_MAPS_EXPLORED != "true" && $OPTION_WORLD_MAPS_EXPLORED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/maps_explored is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_MAPS_EXPLORED="false"
        RESET=true
    fi

    # Load the /options/world/allow_commands option
    OPTION_WORLD_ALLOW_COMMANDS="$(echo "cat /options/world/allow_commands/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_ALLOW_COMMANDS != "true" && $OPTION_WORLD_ALLOW_COMMANDS != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/allow_commands is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_ALLOW_COMMANDS="true"
        RESET=true
    fi

    # Load the /options/world/quest_ignore_raid option
    OPTION_WORLD_QUEST_IGNORE_RAID="$(echo "cat /options/world/quest_ignore_raid/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_QUEST_IGNORE_RAID != "true" && $OPTION_WORLD_QUEST_IGNORE_RAID != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/quest_ignore_raid is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_QUEST_IGNORE_RAID="false"
        RESET=true
    fi

    # Load the /options/world/prevent_afk_logout option
    OPTION_WORLD_PREVENT_AFK_LOGOUT="$(echo "cat /options/world/prevent_afk_logout/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_PREVENT_AFK_LOGOUT != "true" && $OPTION_WORLD_PREVENT_AFK_LOGOUT != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/prevent_afk_logout is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_PREVENT_AFK_LOGOUT="false"
        RESET=true
    fi

    # Load the /options/world/raf_max_level option
    OPTION_WORLD_RAF_MAX_LEVEL="$(echo "cat /options/world/raf_max_level/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_RAF_MAX_LEVEL =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_RAF_MAX_LEVEL < 1 || $OPTION_WORLD_RAF_MAX_LEVEL > 80 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/raf_max_level is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_RAF_MAX_LEVEL="60"
        RESET=true
    fi

    # Load the /options/world/preload_map_grids option
    OPTION_WORLD_PRELOAD_MAP_GRIDS="$(echo "cat /options/world/preload_map_grids/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_PRELOAD_MAP_GRIDS != "true" && $OPTION_WORLD_PRELOAD_MAP_GRIDS != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/preload_map_grids is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_PRELOAD_MAP_GRIDS="false"
        RESET=true
    fi

    # Load the /options/world/set_all_waypoints_active option
    OPTION_WORLD_SET_ALL_WAYPOINTS_ACTIVE="$(echo "cat /options/world/set_all_waypoints_active/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_SET_ALL_WAYPOINTS_ACTIVE != "true" && $OPTION_WORLD_SET_ALL_WAYPOINTS_ACTIVE != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/set_all_waypoints_active is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_SET_ALL_WAYPOINTS_ACTIVE="false"
        RESET=true
    fi

    # Load the /options/world/enable_minigob_manabonk option
    OPTION_WORLD_ENABLE_MINIGOB_MANABONK="$(echo "cat /options/world/enable_minigob_manabonk/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_ENABLE_MINIGOB_MANABONK != "true" && $OPTION_WORLD_ENABLE_MINIGOB_MANABONK != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/enable_minigob_manabonk is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_ENABLE_MINIGOB_MANABONK="true"
        RESET=true
    fi

    # Load the /options/world/enable_warden option
    OPTION_WORLD_ENABLE_WARDEN="$(echo "cat /options/world/enable_warden/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_ENABLE_WARDEN != "true" && $OPTION_WORLD_ENABLE_WARDEN != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/enable_warden is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_ENABLE_WARDEN="true"
        RESET=true
    fi

    # Load the /options/world/disable_leave_group option
    OPTION_WORLD_DISABLE_LEAVE_GROUP="$(echo "cat /options/world/disable_leave_group/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_DISABLE_LEAVE_GROUP != "true" && $OPTION_WORLD_DISABLE_LEAVE_GROUP != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/disable_leave_group is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_DISABLE_LEAVE_GROUP="false"
        RESET=true
    fi

    # Load the /options/world/rates/experience option
    OPTION_WORLD_RATES_EXPERIENCE="$(echo "cat /options/world/rates/experience/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_RATES_EXPERIENCE =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_RATES_EXPERIENCE < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/rates/experience is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_RATES_EXPERIENCE="1"
        RESET=true
    fi

    # Load the /options/world/rates/rested_experience option
    OPTION_WORLD_RATES_RESTED_EXPERIENCE="$(echo "cat /options/world/rates/rested_experience/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_RATES_RESTED_EXPERIENCE =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/rates/rested_experience is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_RATES_RESTED_EXPERIENCE="1"
        RESET=true
    fi

    # Load the /options/world/rates/reputation option
    OPTION_WORLD_RATES_REPUTATION="$(echo "cat /options/world/rates/reputation/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_RATES_REPUTATION =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_RATES_REPUTATION < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/rates/reputation is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_RATES_REPUTATION="1"
        RESET=true
    fi

    # Load the /options/world/rates/money option
    OPTION_WORLD_RATES_MONEY="$(echo "cat /options/world/rates/money/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_RATES_MONEY =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_RATES_MONEY < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/rates/money is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_RATES_MONEY="1"
        RESET=true
    fi

    # Load the /options/world/rates/crafting option
    OPTION_WORLD_RATES_CRAFTING="$(echo "cat /options/world/rates/crafting/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_RATES_CRAFTING =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_RATES_CRAFTING < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/rates/crafting is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_RATES_CRAFTING="1"
        RESET=true
    fi

    # Load the /options/world/rates/gathering option
    OPTION_WORLD_RATES_GATHERING="$(echo "cat /options/world/rates/gathering/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_RATES_GATHERING =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_RATES_GATHERING < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/rates/gathering is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_RATES_GATHERING="1"
        RESET=true
    fi

    # Load the /options/world/rates/weapon_skill option
    OPTION_WORLD_RATES_WEAPON_SKILL="$(echo "cat /options/world/rates/weapon_skill/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_RATES_WEAPON_SKILL =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_RATES_WEAPON_SKILL < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/rates/weapon_skill is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_RATES_WEAPON_SKILL="1"
        RESET=true
    fi

    # Load the /options/world/rates/defense_skill option
    OPTION_WORLD_RATES_DEFENSE_SKILL="$(echo "cat /options/world/rates/defense_skill/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_RATES_DEFENSE_SKILL =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_RATES_DEFENSE_SKILL < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/rates/defense_skill is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_RATES_DEFENSE_SKILL="1"
        RESET=true
    fi

    # Load the /options/world/gm/login_state option
    OPTION_WORLD_GM_LOGIN_STATE="$(echo "cat /options/world/gm/login_state/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_GM_LOGIN_STATE != "true" && $OPTION_WORLD_GM_LOGIN_STATE != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/gm/login_state is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_GM_LOGIN_STATE="true"
        RESET=true
    fi

    # Load the /options/world/gm/enable_visibility option
    OPTION_WORLD_GM_ENABLE_VISIBILITY="$(echo "cat /options/world/gm/enable_visibility/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_GM_ENABLE_VISIBILITY != "true" && $OPTION_WORLD_GM_ENABLE_VISIBILITY != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/gm/enable_visibility is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_GM_ENABLE_VISIBILITY="false"
        RESET=true
    fi

    # Load the /options/world/gm/enable_chat option
    OPTION_WORLD_GM_ENABLE_CHAT="$(echo "cat /options/world/gm/enable_chat/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_GM_ENABLE_CHAT != "true" && $OPTION_WORLD_GM_ENABLE_CHAT != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/gm/enable_chat is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_GM_ENABLE_CHAT="true"
        RESET=true
    fi

    # Load the /options/world/gm/enable_whisper option
    OPTION_WORLD_GM_ENABLE_WHISPER="$(echo "cat /options/world/gm/enable_whisper/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_GM_ENABLE_WHISPER != "true" && $OPTION_WORLD_GM_ENABLE_WHISPER != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/gm/enable_whisper is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_GM_ENABLE_WHISPER="false"
        RESET=true
    fi

    # Load the /options/world/gm/show_gm_list option
    OPTION_WORLD_GM_SHOW_GM_LIST="$(echo "cat /options/world/gm/show_gm_list/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_GM_SHOW_GM_LIST =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_GM_SHOW_GM_LIST != 0 && $OPTION_WORLD_GM_SHOW_GM_LIST != 1 && $OPTION_WORLD_GM_SHOW_GM_LIST != 2 && $OPTION_WORLD_GM_SHOW_GM_LIST != 3 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/gm/show_gm_list is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_GM_SHOW_GM_LIST="1"
        RESET=true
    fi

    # Load the /options/world/gm/show_who_list option
    OPTION_WORLD_GM_SHOW_WHO_LIST="$(echo "cat /options/world/gm/show_who_list/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_WORLD_GM_SHOW_WHO_LIST =~ ^[0-9]+$ ]] || [[ $OPTION_WORLD_GM_SHOW_WHO_LIST != 0 && $OPTION_WORLD_GM_SHOW_WHO_LIST != 1 && $OPTION_WORLD_GM_SHOW_WHO_LIST != 2 && $OPTION_WORLD_GM_SHOW_WHO_LIST != 3 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/gm/show_who_list is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_GM_SHOW_WHO_LIST="0"
        RESET=true
    fi

    # Load the /options/world/gm/allow_friend option
    OPTION_WORLD_GM_ALLOW_FRIEND="$(echo "cat /options/world/gm/allow_friend/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_GM_ALLOW_FRIEND != "true" && $OPTION_WORLD_GM_ALLOW_FRIEND != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/gm/allow_friend is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_GM_ALLOW_FRIEND="false"
        RESET=true
    fi

    # Load the /options/world/gm/allow_invite option
    OPTION_WORLD_GM_ALLOW_INVITE="$(echo "cat /options/world/gm/allow_invite/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_GM_ALLOW_INVITE != "true" && $OPTION_WORLD_GM_ALLOW_INVITE != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/gm/allow_invite is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_GM_ALLOW_INVITE="false"
        RESET=true
    fi

    # Load the /options/world/gm/allow_lower_security option
    OPTION_WORLD_GM_ALLOW_LOWER_SECURITY="$(echo "cat /options/world/gm/allow_lower_security/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_WORLD_GM_ALLOW_LOWER_SECURITY != "true" && $OPTION_WORLD_GM_ALLOW_LOWER_SECURITY != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/world/gm/allow_lower_security is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_WORLD_GM_ALLOW_LOWER_SECURITY="false"
        RESET=true
    fi

    # Load the /options/modules/ahbot/enabled option
    OPTION_MODULES_AHBOT_ENABLED="$(echo "cat /options/modules/ahbot/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_AHBOT_ENABLED != "true" && $OPTION_MODULES_AHBOT_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/ahbot/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_AHBOT_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/ahbot/enable_buyer option
    OPTION_MODULES_AHBOT_ENABLE_BUYER="$(echo "cat /options/modules/ahbot/enable_buyer/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_AHBOT_ENABLE_BUYER != "true" && $OPTION_MODULES_AHBOT_ENABLE_BUYER != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/ahbot/enable_buyer is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_AHBOT_ENABLE_BUYER="false"
        RESET=true
    fi

    # Load the /options/modules/ahbot/enable_seller option
    OPTION_MODULES_AHBOT_ENABLE_SELLER="$(echo "cat /options/modules/ahbot/enable_seller/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_AHBOT_ENABLE_SELLER != "true" && $OPTION_MODULES_AHBOT_ENABLE_SELLER != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/ahbot/enable_seller is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_AHBOT_ENABLE_SELLER="false"
        RESET=true
    fi

    # Load the /options/modules/ahbot/account_id option
    OPTION_MODULES_AHBOT_ACCOUNT_ID="$(echo "cat /options/modules/ahbot/account_id/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_AHBOT_ACCOUNT_ID =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/ahbot/account_id is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_AHBOT_ACCOUNT_ID="1"
        RESET=true
    fi

    # Load the /options/modules/ahbot/character_guid option
    OPTION_MODULES_AHBOT_CHARACTER_GUID="$(echo "cat /options/modules/ahbot/character_guid/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_AHBOT_CHARACTER_GUID =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/ahbot/character_guid is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_AHBOT_CHARACTER_GUID="1"
        RESET=true
    fi

    # Load the /options/modules/ahbot/min_items option
    OPTION_MODULES_AHBOT_MIN_ITEMS="$(echo "cat /options/modules/ahbot/min_items/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_AHBOT_MIN_ITEMS =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/ahbot/min_items is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_AHBOT_MIN_ITEMS="250"
        RESET=true
    fi

    # Load the /options/modules/ahbot/max_items option
    OPTION_MODULES_AHBOT_MAX_ITEMS="$(echo "cat /options/modules/ahbot/max_items/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_AHBOT_MAX_ITEMS =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/ahbot/max_items is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_AHBOT_MAX_ITEMS="250"
        RESET=true
    fi

    # Load the /options/modules/assistant/enabled option
    OPTION_MODULES_ASSISTANT_ENABLED="$(echo "cat /options/modules/assistant/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_ENABLED != "true" && $OPTION_MODULES_ASSISTANT_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/heirlooms option
    OPTION_MODULES_ASSISTANT_FEATURES_HEIRLOOMS="$(echo "cat /options/modules/assistant/features/heirlooms/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_HEIRLOOMS != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_HEIRLOOMS != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/heirlooms is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_HEIRLOOMS="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/glyphs option
    OPTION_MODULES_ASSISTANT_FEATURES_GLYPHS="$(echo "cat /options/modules/assistant/features/glyphs/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_GLYPHS != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_GLYPHS != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/glyphs is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_GLYPHS="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/gems option
    OPTION_MODULES_ASSISTANT_FEATURES_GEMS="$(echo "cat /options/modules/assistant/features/gems/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_GEMS != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_GEMS != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/gems is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_GEMS="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/containers option
    OPTION_MODULES_ASSISTANT_FEATURES_CONTAINERS="$(echo "cat /options/modules/assistant/features/containers/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_CONTAINERS != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_CONTAINERS != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/containers is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_CONTAINERS="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/utilities/enabled option
    OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_ENABLED="$(echo "cat /options/modules/assistant/features/utilities/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_ENABLED != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/utilities/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/utilities/name_change option
    OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_NAME_CHANGE="$(echo "cat /options/modules/assistant/features/utilities/name_change/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_NAME_CHANGE =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_NAME_CHANGE < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/utilities/name_change is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_NAME_CHANGE="10"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/utilities/customization option
    OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_CUSTOMIZATION="$(echo "cat /options/modules/assistant/features/utilities/customization/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_CUSTOMIZATION =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_CUSTOMIZATION < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/utilities/customization is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_CUSTOMIZATION="50"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/utilities/race_change option
    OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_RACE_CHANGE="$(echo "cat /options/modules/assistant/features/utilities/race_change/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_RACE_CHANGE =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_RACE_CHANGE < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/utilities/race_change is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_RACE_CHANGE="500"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/utilities/faction_change option
    OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_FACTION_CHANGE="$(echo "cat /options/modules/assistant/features/utilities/faction_change/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_FACTION_CHANGE =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_FACTION_CHANGE < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/utilities/faction_change is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_FACTION_CHANGE="1000"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/enabled option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ENABLED="$(echo "cat /options/modules/assistant/features/professions/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ENABLED != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/apprentice/enabled option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_ENABLED="$(echo "cat /options/modules/assistant/features/professions/apprentice/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_ENABLED != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/apprentice/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/apprentice/cost option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_COST="$(echo "cat /options/modules/assistant/features/professions/apprentice/cost/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_COST =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_COST < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/apprentice/cost is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_COST="100"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/journeyman/enabled option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_ENABLED="$(echo "cat /options/modules/assistant/features/professions/journeyman/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_ENABLED != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/journeyman/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/journeyman/cost option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_COST="$(echo "cat /options/modules/assistant/features/professions/journeyman/cost/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_COST =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_COST < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/journeyman/cost is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_COST="250"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/expert/enabled option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_ENABLED="$(echo "cat /options/modules/assistant/features/professions/expert/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_ENABLED != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/expert/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/expert/cost option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_COST="$(echo "cat /options/modules/assistant/features/professions/expert/cost/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_COST =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_COST < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/expert/cost is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_COST="500"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/artisan/enabled option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_ENABLED="$(echo "cat /options/modules/assistant/features/professions/artisan/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_ENABLED != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/artisan/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/artisan/cost option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_COST="$(echo "cat /options/modules/assistant/features/professions/artisan/cost/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_COST =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_COST < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/artisan/cost is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_COST="750"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/master/enabled option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_ENABLED="$(echo "cat /options/modules/assistant/features/professions/master/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_ENABLED != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/master/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/master/cost option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_COST="$(echo "cat /options/modules/assistant/features/professions/master/cost/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_COST =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_COST < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/master/cost is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_COST="1250"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/grand_master/enabled option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_ENABLED="$(echo "cat /options/modules/assistant/features/professions/grand_master/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_ENABLED != "true" && $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/grand_master/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/assistant/features/professions/grand_master/cost option
    OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_COST="$(echo "cat /options/modules/assistant/features/professions/grand_master/cost/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_COST =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_COST < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/assistant/features/professions/grand_master/cost is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_COST="2500"
        RESET=true
    fi

    # Load the /options/modules/eluna/enabled option
    OPTION_MODULES_ELUNA_ENABLED="$(echo "cat /options/modules/eluna/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_ELUNA_ENABLED != "true" && $OPTION_MODULES_ELUNA_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/eluna/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_ELUNA_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/group_quests/enabled option
    OPTION_MODULES_GROUP_QUESTS_ENABLED="$(echo "cat /options/modules/group_quests/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_GROUP_QUESTS_ENABLED != "true" && $OPTION_MODULES_GROUP_QUESTS_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/group_quests/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_GROUP_QUESTS_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/enabled option
    OPTION_MODULES_LEARN_SPELLS_ENABLED="$(echo "cat /options/modules/learn_spells/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_ENABLED != "true" && $OPTION_MODULES_LEARN_SPELLS_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/on_login option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LOGIN="$(echo "cat /options/modules/learn_spells/spells/on_login/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LOGIN != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LOGIN != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/on_login is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LOGIN="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/on_levelup option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LEVELUP="$(echo "cat /options/modules/learn_spells/spells/on_levelup/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LEVELUP != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LEVELUP != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/on_levelup is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LEVELUP="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/class_spells option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_CLASS_SPELLS="$(echo "cat /options/modules/learn_spells/spells/class_spells/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_CLASS_SPELLS != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_CLASS_SPELLS != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/class_spells is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_CLASS_SPELLS="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/talent_ranks option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_TALENT_RANKS="$(echo "cat /options/modules/learn_spells/spells/talent_ranks/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_TALENT_RANKS != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_TALENT_RANKS != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/talent_ranks is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_TALENT_RANKS="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/proficiencies option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_PROFICIENCIES="$(echo "cat /options/modules/learn_spells/spells/proficiencies/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_PROFICIENCIES != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_PROFICIENCIES != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/proficiencies is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_PROFICIENCIES="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/from_quests option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_FROM_QUESTS="$(echo "cat /options/modules/learn_spells/spells/from_quests/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_FROM_QUESTS != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_FROM_QUESTS != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/from_quests is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_FROM_QUESTS="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/max_skill/enabled option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_ENABLED="$(echo "cat /options/modules/learn_spells/spells/max_skill/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_ENABLED != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/max_skill/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/max_skill/max_level option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_MAX_LEVEL="$(echo "cat /options/modules/learn_spells/spells/max_skill/max_level/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_MAX_LEVEL =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_MAX_LEVEL < 1 || $OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_MAX_LEVEL > 80 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/max_skill/max_level is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_MAX_LEVEL="60"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/riding/enabled option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ENABLED="$(echo "cat /options/modules/learn_spells/spells/riding/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ENABLED != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/riding/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/riding/apprentice option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_APPRENTICE="$(echo "cat /options/modules/learn_spells/spells/riding/apprentice/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_APPRENTICE != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_APPRENTICE != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/riding/apprentice is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_APPRENTICE="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/riding/journeyman option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_JOURNEYMAN="$(echo "cat /options/modules/learn_spells/spells/riding/journeyman/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_JOURNEYMAN != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_JOURNEYMAN != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/riding/journeyman is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_JOURNEYMAN="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/riding/expert option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_EXPERT="$(echo "cat /options/modules/learn_spells/spells/riding/expert/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_EXPERT != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_EXPERT != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/riding/expert is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_EXPERT="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/riding/artisan option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ARTISAN="$(echo "cat /options/modules/learn_spells/spells/riding/artisan/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ARTISAN != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ARTISAN != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/riding/artisan is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ARTISAN="false"
        RESET=true
    fi

    # Load the /options/modules/learn_spells/spells/riding/cold_weather option
    OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_COLD_WEATHER="$(echo "cat /options/modules/learn_spells/spells/riding/cold_weather/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_COLD_WEATHER != "true" && $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_COLD_WEATHER != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/learn_spells/spells/riding/cold_weather is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_COLD_WEATHER="false"
        RESET=true
    fi

    # Load the /options/modules/level_reward/enabled option
    OPTION_MODULES_LEVEL_REWARD_ENABLED="$(echo "cat /options/modules/level_reward/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_LEVEL_REWARD_ENABLED != "true" && $OPTION_MODULES_LEVEL_REWARD_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/level_reward/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEVEL_REWARD_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/level_reward/gold/level_10 option
    OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_10="$(echo "cat /options/modules/level_reward/gold/level_10/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_10 =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_10 < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/level_reward/gold/level_10 is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_10="5"
        RESET=true
    fi

    # Load the /options/modules/level_reward/gold/level_20 option
    OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_20="$(echo "cat /options/modules/level_reward/gold/level_20/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_20 =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_20 < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/level_reward/gold/level_20 is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_20="15"
        RESET=true
    fi

    # Load the /options/modules/level_reward/gold/level_30 option
    OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_30="$(echo "cat /options/modules/level_reward/gold/level_30/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_30 =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_30 < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/level_reward/gold/level_30 is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_30="30"
        RESET=true
    fi

    # Load the /options/modules/level_reward/gold/level_40 option
    OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_40="$(echo "cat /options/modules/level_reward/gold/level_40/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_40 =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_40 < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/level_reward/gold/level_40 is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_40="45"
        RESET=true
    fi

    # Load the /options/modules/level_reward/gold/level_50 option
    OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_50="$(echo "cat /options/modules/level_reward/gold/level_50/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_50 =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_50 < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/level_reward/gold/level_50 is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_50="60"
        RESET=true
    fi

    # Load the /options/modules/level_reward/gold/level_60 option
    OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_60="$(echo "cat /options/modules/level_reward/gold/level_60/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_60 =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_60 < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/level_reward/gold/level_60 is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_60="80"
        RESET=true
    fi

    # Load the /options/modules/level_reward/gold/level_70 option
    OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_70="$(echo "cat /options/modules/level_reward/gold/level_70/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_70 =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_70 < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/level_reward/gold/level_70 is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_70="125"
        RESET=true
    fi

    # Load the /options/modules/level_reward/gold/level_80 option
    OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_80="$(echo "cat /options/modules/level_reward/gold/level_80/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_80 =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_80 < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/level_reward/gold/level_80 is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_80="250"
        RESET=true
    fi

    # Load the /options/modules/recruit_a_friend/enabled option
    OPTION_MODULES_RECRUIT_A_FRIEND_ENABLED="$(echo "cat /options/modules/recruit_a_friend/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_RECRUIT_A_FRIEND_ENABLED != "true" && $OPTION_MODULES_RECRUIT_A_FRIEND_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/recruit_a_friend/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_RECRUIT_A_FRIEND_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/recruit_a_friend/duration option
    OPTION_MODULES_RECRUIT_A_FRIEND_DURATION="$(echo "cat /options/modules/recruit_a_friend/duration/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_RECRUIT_A_FRIEND_DURATION =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/recruit_a_friend/duration is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_RECRUIT_A_FRIEND_DURATION="90"
        RESET=true
    fi

    # Load the /options/modules/recruit_a_friend/account_age option
    OPTION_MODULES_RECRUIT_A_FRIEND_ACCOUNT_AGE="$(echo "cat /options/modules/recruit_a_friend/account_age/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_RECRUIT_A_FRIEND_ACCOUNT_AGE =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/recruit_a_friend/account_age is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_RECRUIT_A_FRIEND_ACCOUNT_AGE="7"
        RESET=true
    fi

    # Load the /options/modules/recruit_a_friend/rewards/days option
    OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_DAYS="$(echo "cat /options/modules/recruit_a_friend/rewards/days/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_DAYS =~ ^[0-9]+$ ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/recruit_a_friend/rewards/days is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_DAYS="30"
        RESET=true
    fi

    # Load the /options/modules/recruit_a_friend/rewards/swift_zhevra option
    OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_SWIFT_ZHEVRA="$(echo "cat /options/modules/recruit_a_friend/rewards/swift_zhevra/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_SWIFT_ZHEVRA != "true" && $OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_SWIFT_ZHEVRA != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/recruit_a_friend/rewards/swift_zhevra is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_SWIFT_ZHEVRA="true"
        RESET=true
    fi

    # Load the /options/modules/recruit_a_friend/rewards/touring_rocket option
    OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_TOURING_ROCKET="$(echo "cat /options/modules/recruit_a_friend/rewards/touring_rocket/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_TOURING_ROCKET != "true" && $OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_TOURING_ROCKET != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/recruit_a_friend/rewards/touring_rocket is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_TOURING_ROCKET="true"
        RESET=true
    fi

    # Load the /options/modules/skip_dk_starting_area/enabled option
    OPTION_MODULES_SKIP_DK_STARTING_AREA_ENABLED="$(echo "cat /options/modules/skip_dk_starting_area/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_SKIP_DK_STARTING_AREA_ENABLED != "true" && $OPTION_MODULES_SKIP_DK_STARTING_AREA_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/skip_dk_starting_area/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_SKIP_DK_STARTING_AREA_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/skip_dk_starting_area/starting_level option
    OPTION_MODULES_SKIP_DK_STARTING_AREA_STARTING_LEVEL="$(echo "cat /options/modules/skip_dk_starting_area/starting_level/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_SKIP_DK_STARTING_AREA_STARTING_LEVEL =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_SKIP_DK_STARTING_AREA_STARTING_LEVEL < 1 || $OPTION_MODULES_SKIP_DK_STARTING_AREA_STARTING_LEVEL > 80 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/skip_dk_starting_area/starting_level is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_SKIP_DK_STARTING_AREA_STARTING_LEVEL="58"
        RESET=true
    fi

    # Load the /options/modules/spawn_points/enabled option
    OPTION_MODULES_SPAWN_POINTS_ENABLED="$(echo "cat /options/modules/spawn_points/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_SPAWN_POINTS_ENABLED != "true" && $OPTION_MODULES_SPAWN_POINTS_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/spawn_points/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_SPAWN_POINTS_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/weekend_bonus/enabled option
    OPTION_MODULES_WEEKEND_BONUS_ENABLED="$(echo "cat /options/modules/weekend_bonus/enabled/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_WEEKEND_BONUS_ENABLED != "true" && $OPTION_MODULES_WEEKEND_BONUS_ENABLED != "false" ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/weekend_bonus/enabled is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_WEEKEND_BONUS_ENABLED="false"
        RESET=true
    fi

    # Load the /options/modules/weekend_bonus/experience_multiplier option
    OPTION_MODULES_WEEKEND_BONUS_EXPERIENCE_MULTIPLIER="$(echo "cat /options/modules/weekend_bonus/experience_multiplier/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_WEEKEND_BONUS_EXPERIENCE_MULTIPLIER < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/weekend_bonus/experience_multiplier is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_WEEKEND_BONUS_EXPERIENCE_MULTIPLIER="2.0"
        RESET=true
    fi

    # Load the /options/modules/weekend_bonus/money_multiplier option
    OPTION_MODULES_WEEKEND_BONUS_MONEY_MULTIPLIER="$(echo "cat /options/modules/weekend_bonus/money_multiplier/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_WEEKEND_BONUS_MONEY_MULTIPLIER < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/weekend_bonus/money_multiplier is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_WEEKEND_BONUS_MONEY_MULTIPLIER="2.0"
        RESET=true
    fi

    # Load the /options/modules/weekend_bonus/professions_multiplier option
    OPTION_MODULES_WEEKEND_BONUS_PROFESSIONS_MULTIPLIER="$(echo "cat /options/modules/weekend_bonus/professions_multiplier/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_WEEKEND_BONUS_PROFESSIONS_MULTIPLIER =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_WEEKEND_BONUS_PROFESSIONS_MULTIPLIER < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/weekend_bonus/professions_multiplier is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_WEEKEND_BONUS_PROFESSIONS_MULTIPLIER="2"
        RESET=true
    fi

    # Load the /options/modules/weekend_bonus/reputation_multiplier option
    OPTION_MODULES_WEEKEND_BONUS_REPUTATION_MULTIPLIER="$(echo "cat /options/modules/weekend_bonus/reputation_multiplier/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ $OPTION_MODULES_WEEKEND_BONUS_REPUTATION_MULTIPLIER < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/weekend_bonus/reputation_multiplier is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_WEEKEND_BONUS_REPUTATION_MULTIPLIER="2.0"
        RESET=true
    fi

    # Load the /options/modules/weekend_bonus/proficiencies_multiplier option
    OPTION_MODULES_WEEKEND_BONUS_PROFICIENCIES_MULTIPLIER="$(echo "cat /options/modules/weekend_bonus/proficiencies_multiplier/text()" | xmllint --nocdata --shell $OPTIONS | sed '1d;$d')"
    if [[ ! $OPTION_MODULES_WEEKEND_BONUS_PROFICIENCIES_MULTIPLIER =~ ^[0-9]+$ ]] || [[ $OPTION_MODULES_WEEKEND_BONUS_PROFICIENCIES_MULTIPLIER < 1 ]]; then
        # The value is invalid so it will be reset to the default value
        printf "${COLOR_RED}The option at /options/modules/weekend_bonus/proficiencies_multiplier is invalid. It has been reset to the default value.${COLOR_END}\n"
        OPTION_MODULES_WEEKEND_BONUS_PROFICIENCIES_MULTIPLIER="2"
        RESET=true
    fi

    # Check if any option calls for a reset
    if [ $RESET ]; then
        # Tell the user that the invalid options should be changed, then terminate the script
        printf "${COLOR_RED}Make sure to change the options listed above to prevent any unwanted issues.${COLOR_END}\n"
        save_options
        exit $?
    fi
}

# A function that downloads the latest version of the source code
function get_source
{
    # Make sure all required packages are installed
    git_package

    printf "${COLOR_GREEN}Downloading the source code...${COLOR_END}\n"

    # Check if the source is already downloaded
    if [ ! -d $OPTION_SOURCE_LOCATION ]; then
        # Download the source code
        git clone --recursive --branch master https://github.com/azerothcore/azerothcore-wotlk.git $OPTION_SOURCE_LOCATION

        # Check to make sure there weren't any errors
        if [ $? -ne 0 ]; then
            # Terminate script on errors
            exit $?
        fi
    else
        # Go into the source folder to update it
        cd $OPTION_SOURCE_LOCATION

        # Fetch all available updates
        git fetch --all

        # Check to make sure there weren't any errors
        if [ $? -ne 0 ]; then
            # Terminate script on errors
            exit $?
        fi

        # Reset the source code, removing all local changes
        git reset --hard origin/master

        # Check to make sure there weren't any errors
        if [ $? -ne 0 ]; then
            # Terminate script on errors
            exit $?
        fi

        # Update any submodule
        git submodule update

        # Check to make sure there weren't any errors
        if [ $? -ne 0 ]; then
            # Terminate script on errors
            exit $?
        fi
    fi

    # Check if either both or world is used as the first parameter
    if [[ $1 == "both" ]] || [[ $1 == "world" ]]; then
        # Check if the ahbot module should be installed
        if [[ $OPTION_MODULES_AHBOT_ENABLED == "true" ]]; then
            # Check if the source is already downloaded
            if [ ! -d $OPTION_SOURCE_LOCATION/modules/mod-ah-bot ]; then
                # Download the source code
                git clone --branch master https://github.com/azerothcore/mod-ah-bot.git $OPTION_SOURCE_LOCATION/modules/mod-ah-bot

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            else
                # Go into the source folder to update it
                cd $OPTION_SOURCE_LOCATION/modules/mod-ah-bot

                # Fetch all available updates
                git fetch --all

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi

                # Reset the source code, removing any local changes
                git reset --hard origin/master

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            fi
        else
            # Check if the source is downloaded
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-ah-bot ]; then
                # Remove it so it won't be included
                rm -rf $OPTION_SOURCE_LOCATION/modules/mod-ah-bot

                # Check if the source has been compiled
                if [ -d $OPTION_SOURCE_LOCATION/build ]; then
                    # Remove the build folder to make sure there are no errors during the compile
                    rm -rf $OPTION_SOURCE_LOCATION/build
                fi
            fi
        fi

        # Check if the assistant module should be installed
        if [[ $OPTION_MODULES_ASSISTANT_ENABLED == "true" ]]; then
            # Check if the source is already downloaded
            if [ ! -d $OPTION_SOURCE_LOCATION/modules/mod-assistant ]; then
                # Download the source code
                git clone --branch master https://github.com/tkn963/mod-assistant.git $OPTION_SOURCE_LOCATION/modules/mod-assistant

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            else
                # Go into the source folder to update it
                cd $OPTION_SOURCE_LOCATION/modules/mod-assistant

                # Fetch all available updates
                git fetch --all

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi

                # Reset the source code, removing any local changes
                git reset --hard origin/master

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            fi
        else
            # Check if the source is downloaded
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-assistant ]; then
                # Remove it so it won't be included
                rm -rf $OPTION_SOURCE_LOCATION/modules/mod-assistant

                # Check if the source has been compiled
                if [ -d $OPTION_SOURCE_LOCATION/build ]; then
                    # Remove the build folder to make sure there are no errors during the compile
                    rm -rf $OPTION_SOURCE_LOCATION/build
                fi
            fi
        fi

        # Check if the eluna module should be installed
        if [[ $OPTION_MODULES_ELUNA_ENABLED == "true" ]]; then
            # Check if the source is already downloaded
            if [ ! -d $OPTION_SOURCE_LOCATION/modules/mod-eluna-lua-engine ]; then
                # Download the source code
                git clone --recursive --branch master https://github.com/azerothcore/mod-eluna-lua-engine.git $OPTION_SOURCE_LOCATION/modules/mod-eluna-lua-engine

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            else
                # Go into the source folder to update it
                cd $OPTION_SOURCE_LOCATION/modules/mod-eluna-lua-engine

                # Fetch all available updates
                git fetch --all

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi

                # Reset the source code, removing any local changes
                git reset --hard origin/master

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi

                # Update any submodule
                git submodule update

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            fi
        else
            # Check if the source is downloaded
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-eluna-lua-engine ]; then
                # Remove it so it won't be included
                rm -rf $OPTION_SOURCE_LOCATION/modules/mod-eluna-lua-engine

                # Check if the source has been compiled
                if [ -d $OPTION_SOURCE_LOCATION/build ]; then
                    # Remove the build folder to make sure there are no errors during the compile
                    rm -rf $OPTION_SOURCE_LOCATION/build
                fi
            fi
        fi

        # Check if the group quests module should be installed
        if [[ $OPTION_MODULES_GROUP_QUESTS_ENABLED == "true" ]]; then
            # Check if the source is already downloaded
            if [ ! -d $OPTION_SOURCE_LOCATION/modules/mod-groupquests ]; then
                # Download the source code
                git clone --branch master https://github.com/tkn963/mod-groupquests.git $OPTION_SOURCE_LOCATION/modules/mod-groupquests

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            else
                # Go into the source folder to update it
                cd $OPTION_SOURCE_LOCATION/modules/mod-groupquests

                # Fetch all available updates
                git fetch --all

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi

                # Reset the source code, removing any local changes
                git reset --hard origin/master

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            fi
        else
            # Check if the source is downloaded
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-groupquests ]; then
                # Remove it so it won't be included
                rm -rf $OPTION_SOURCE_LOCATION/modules/mod-groupquests

                # Check if the source has been compiled
                if [ -d $OPTION_SOURCE_LOCATION/build ]; then
                    # Remove the build folder to make sure there are no errors during the compile
                    rm -rf $OPTION_SOURCE_LOCATION/build
                fi
            fi
        fi

        # Check if the level reward module should be installed
        if [[ $OPTION_MODULES_LEARN_SPELLS_ENABLED == "true" ]]; then
            # Check if the source is already downloaded
            if [ ! -d $OPTION_SOURCE_LOCATION/modules/mod-learnspells ]; then
                # Download the source code
                git clone --branch master https://github.com/tkn963/mod-learnspells.git $OPTION_SOURCE_LOCATION/modules/mod-learnspells

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            else
                # Go into the source folder to update it
                cd $OPTION_SOURCE_LOCATION/modules/mod-learnspells

                # Fetch all available updates
                git fetch --all

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi

                # Reset the source code, removing any local changes
                git reset --hard origin/master

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            fi
        else
            # Check if the source is downloaded
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-learnspells ]; then
                # Remove it so it won't be included
                rm -rf $OPTION_SOURCE_LOCATION/modules/mod-learnspells

                # Check if the source has been compiled
                if [ -d $OPTION_SOURCE_LOCATION/build ]; then
                    # Remove the build folder to make sure there are no errors during the compile
                    rm -rf $OPTION_SOURCE_LOCATION/build
                fi
            fi
        fi

        # Check if the level reward module should be installed
        if [[ $OPTION_MODULES_LEVEL_REWARD_ENABLED == "true" ]]; then
            # Check if the source is already downloaded
            if [ ! -d $OPTION_SOURCE_LOCATION/modules/mod-levelreward ]; then
                # Download the source code
                git clone --branch master https://github.com/tkn963/mod-levelreward.git $OPTION_SOURCE_LOCATION/modules/mod-levelreward

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            else
                # Go into the source folder to update it
                cd $OPTION_SOURCE_LOCATION/modules/mod-levelreward

                # Fetch all available updates
                git fetch --all

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi

                # Reset the source code, removing any local changes
                git reset --hard origin/master

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            fi
        else
            # Check if the source is downloaded
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-levelreward ]; then
                # Remove it so it won't be included
                rm -rf $OPTION_SOURCE_LOCATION/modules/mod-levelreward

                # Check if the source has been compiled
                if [ -d $OPTION_SOURCE_LOCATION/build ]; then
                    # Remove the build folder to make sure there are no errors during the compile
                    rm -rf $OPTION_SOURCE_LOCATION/build
                fi
            fi
        fi

        # Check if the recruit-a-friend module should be installed
        if [[ $OPTION_MODULES_RECRUIT_A_FRIEND_ENABLED == "true" ]]; then
            # Check if the source is already downloaded
            if [ ! -d $OPTION_SOURCE_LOCATION/modules/mod-recruitafriend ]; then
                # Download the source code
                git clone --branch master https://github.com/tkn963/mod-recruitafriend.git $OPTION_SOURCE_LOCATION/modules/mod-recruitafriend

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            else
                # Go into the source folder to update it
                cd $OPTION_SOURCE_LOCATION/modules/mod-recruitafriend

                # Fetch all available updates
                git fetch --all

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi

                # Reset the source code, removing any local changes
                git reset --hard origin/master

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            fi
        else
            # Check if the source is downloaded
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-recruitafriend ]; then
                # Remove it so it won't be included
                rm -rf $OPTION_SOURCE_LOCATION/modules/mod-recruitafriend

                # Check if the source has been compiled
                if [ -d $OPTION_SOURCE_LOCATION/build ]; then
                    # Remove the build folder to make sure there are no errors during the compile
                    rm -rf $OPTION_SOURCE_LOCATION/build
                fi
            fi
        fi

        # Check if the skip dk starting area module should be installed
        if [[ $OPTION_MODULES_SKIP_DK_STARTING_AREA_ENABLED == "true" ]]; then
            # Check if the source is already downloaded
            if [ ! -d $OPTION_SOURCE_LOCATION/modules/mod-skip-dk-starting-area ]; then
                # Download the source code
                git clone --branch master https://github.com/azerothcore/mod-skip-dk-starting-area.git $OPTION_SOURCE_LOCATION/modules/mod-skip-dk-starting-area

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            else
                # Go into the source folder to update it
                cd $OPTION_SOURCE_LOCATION/modules/mod-skip-dk-starting-area

                # Fetch all available updates
                git fetch --all

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi

                # Reset the source code, removing any local changes
                git reset --hard origin/master

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            fi
        else
            # Check if the source is downloaded
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-skip-dk-starting-area ]; then
                # Remove it so it won't be included
                rm -rf $OPTION_SOURCE_LOCATION/modules/mod-skip-dk-starting-area

                # Check if the source has been compiled
                if [ -d $OPTION_SOURCE_LOCATION/build ]; then
                    # Remove the build folder to make sure there are no errors during the compile
                    rm -rf $OPTION_SOURCE_LOCATION/build
                fi
            fi
        fi

        # Check if the spawn points module should be installed
        if [[ $OPTION_MODULES_SPAWN_POINTS_ENABLED == "true" ]]; then
            # Check if the source is already downloaded
            if [ ! -d $OPTION_SOURCE_LOCATION/modules/mod-spawnpoints ]; then
                # Download the source code
                git clone --branch master https://github.com/tkn963/mod-spawnpoints.git $OPTION_SOURCE_LOCATION/modules/mod-spawnpoints

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            else
                # Go into the source folder to update it
                cd $OPTION_SOURCE_LOCATION/modules/mod-spawnpoints

                # Fetch all available updates
                git fetch --all

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi

                # Reset the source code, removing any local changes
                git reset --hard origin/master

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            fi
        else
            # Check if the source is downloaded
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-spawnpoints ]; then
                # Remove it so it won't be included
                rm -rf $OPTION_SOURCE_LOCATION/modules/mod-spawnpoints

                # Check if the source has been compiled
                if [ -d $OPTION_SOURCE_LOCATION/build ]; then
                    # Remove the build folder to make sure there are no errors during the compile
                    rm -rf $OPTION_SOURCE_LOCATION/build
                fi
            fi
        fi

        # Check if the weekend bonus module should be installed
        if [[ $OPTION_MODULES_WEEKEND_BONUS_ENABLED == "true" ]]; then
            # Check if the source is already downloaded
            if [ ! -d $OPTION_SOURCE_LOCATION/modules/mod-weekendbonus ]; then
                # Download the source code
                git clone --branch master https://github.com/tkn963/mod-weekendbonus.git $OPTION_SOURCE_LOCATION/modules/mod-weekendbonus

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            else
                # Go into the source folder to update it
                cd $OPTION_SOURCE_LOCATION/modules/mod-weekendbonus

                # Fetch all available updates
                git fetch --all

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi

                # Reset the source code, removing any local changes
                git reset --hard origin/master

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Terminate script on errors
                    exit $?
                fi
            fi
        else
            # Check if the source is downloaded
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-weekendbonus ]; then
                # Remove it so it won't be included
                rm -rf $OPTION_SOURCE_LOCATION/modules/mod-weekendbonus

                # Check if the source has been compiled
                if [ -d $OPTION_SOURCE_LOCATION/build ]; then
                    # Remove the build folder to make sure there are no errors during the compile
                    rm -rf $OPTION_SOURCE_LOCATION/build
                fi
            fi
        fi
    fi

    printf "${COLOR_GREEN}Finished downloading the source code...${COLOR_END}\n"
}

# A function that compiles the source code into binaries
function compile_source
{
    # Make sure all required packages are installed
    source_packages

    printf "${COLOR_GREEN}Compiling the source code...${COLOR_END}\n"

    # Create the build folder and cd into it
    mkdir -p $OPTION_SOURCE_LOCATION/build && cd $_

    # Generate the build files
    cmake ../ -DCMAKE_INSTALL_PREFIX=$OPTION_SOURCE_LOCATION -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS=0 -DSCRIPTS=static

    # Check to make sure there weren't any errors
    if [ $? -ne 0 ]; then
        # Terminate script on errors
        exit $?
    fi

    # Build the source code
    make -j $(nproc)

    # Check to make sure there weren't any errors
    if [ $? -ne 0 ]; then
        # Terminate script on errors
        exit $?
    fi

    # Copy the binaries and other required files to their designated directories
    make install

    # Check to make sure there weren't any errors
    if [ $? -ne 0 ]; then
        # Terminate script on errors
        exit $?
    fi

    # Create the scripts used to start and stop the server
    echo "#!/bin/bash" > $OPTION_SOURCE_LOCATION/bin/start.sh
    echo "#!/bin/bash" > $OPTION_SOURCE_LOCATION/bin/stop.sh

    # Check if the authserver should be enabled
    if [[ $1 == "both" ]] || [[ $1 == "auth" ]]; then
        # Add authserver to the start and stop scripts
        echo "screen -AmdS auth ./auth.sh" >> $OPTION_SOURCE_LOCATION/bin/start.sh
        echo "screen -X -S \"auth\" quit" >> $OPTION_SOURCE_LOCATION/bin/stop.sh

        # Create the script used to start and stop the authserver
        echo "#!/bin/bash" > $OPTION_SOURCE_LOCATION/bin/auth.sh
        echo "while :; do" >> $OPTION_SOURCE_LOCATION/bin/auth.sh
        echo "./authserver" >> $OPTION_SOURCE_LOCATION/bin/auth.sh
        echo "sleep 5" >> $OPTION_SOURCE_LOCATION/bin/auth.sh
        echo "done" >> $OPTION_SOURCE_LOCATION/bin/auth.sh

        # Make the script runnable
        chmod +x $OPTION_SOURCE_LOCATION/bin/auth.sh
    else
        # Check if the script for authserver already exists
        if [ -f $OPTION_SOURCE_LOCATION/bin/auth.sh ]; then
            # Remove the script if authserver is not used
            rm -rf $OPTION_SOURCE_LOCATION/bin/auth.sh
        fi
    fi

    # Check if the worldserver should be enabled
    if [[ $1 == "both" ]] || [[ $1 == "world" ]]; then
        # Add worldserver to the start and stop scripts
        echo "screen -AmdS world ./world.sh" >> $OPTION_SOURCE_LOCATION/bin/start.sh
        echo "screen -X -S \"world\" quit" >> $OPTION_SOURCE_LOCATION/bin/stop.sh

        # Create the script used to start and stop the worldserver
        echo "#!/bin/bash" > $OPTION_SOURCE_LOCATION/bin/world.sh
        echo "while :; do" >> $OPTION_SOURCE_LOCATION/bin/world.sh
        echo "./worldserver" >> $OPTION_SOURCE_LOCATION/bin/world.sh
        echo "if [[ \$? == 0 ]]; then" >> $OPTION_SOURCE_LOCATION/bin/world.sh
        echo "break" >> $OPTION_SOURCE_LOCATION/bin/world.sh
        echo "fi" >> $OPTION_SOURCE_LOCATION/bin/world.sh
        echo "sleep 5" >> $OPTION_SOURCE_LOCATION/bin/world.sh
        echo "done" >> $OPTION_SOURCE_LOCATION/bin/world.sh

        # Make the script runnable
        chmod +x $OPTION_SOURCE_LOCATION/bin/world.sh
    else
        # Check if the script for worldserver already exists
        if [ -f $OPTION_SOURCE_LOCATION/bin/world.sh ]; then
            # Remove the script if worldserver is not used
            rm -rf $OPTION_SOURCE_LOCATION/bin/world.sh
        fi
    fi

    # Make the start and stop scripts runnable
    chmod +x $OPTION_SOURCE_LOCATION/bin/start.sh
    chmod +x $OPTION_SOURCE_LOCATION/bin/stop.sh

    printf "${COLOR_GREEN}Finished compiling the source code...${COLOR_END}\n"
}

# A function that downloads the client data files
function get_client_files
{
    # Make sure this is only used with the both or world subparameters
    if [[ $1 == "both" ]] || [[ $1 == "world" ]]; then
        # Check if any of the folders are missing
        if [ ! -d $OPTION_SOURCE_LOCATION/bin/Cameras ] || [ ! -d $OPTION_SOURCE_LOCATION/bin/dbc ] || [ ! -d $OPTION_SOURCE_LOCATION/bin/maps ] || [ ! -d $OPTION_SOURCE_LOCATION/bin/mmaps ] || [ ! -d $OPTION_SOURCE_LOCATION/bin/vmaps ]; then
            # Set installed client data to 0 if any folder is missing
            OPTION_SOURCE_INSTALLED_CLIENT_DATA=0
        fi

        # Grab the latest version available on github
        AVAILABLE_VERSION=$(git ls-remote --tags --sort="v:refname" https://github.com/wowgaming/client-data.git | tail -n1 | cut --delimiter='/' --fields=3 | sed 's/v//')

        # Check if the latest version differ from the required version
        if [ $OPTION_SOURCE_REQUIRED_CLIENT_DATA != $AVAILABLE_VERSION ]; then
            # Update the required version with this version
            OPTION_SOURCE_REQUIRED_CLIENT_DATA=$AVAILABLE_VERSION

            # Save the required version to the options file
            save_options
        fi

        # Check if the installed version differ from the required version
        if [ $OPTION_SOURCE_INSTALLED_CLIENT_DATA != $OPTION_SOURCE_REQUIRED_CLIENT_DATA ]; then
            printf "${COLOR_GREEN}Downloading the client data files...${COLOR_END}\n"

            # Check all folders included in the data files and remove them
            if [ -d $OPTION_SOURCE_LOCATION/bin/Cameras ]; then
                rm -rf $OPTION_SOURCE_LOCATION/bin/Cameras
            fi
            if [ -d $OPTION_SOURCE_LOCATION/bin/dbc ]; then
                rm -rf $OPTION_SOURCE_LOCATION/bin/dbc
            fi
            if [ -d $OPTION_SOURCE_LOCATION/bin/maps ]; then
                rm -rf $OPTION_SOURCE_LOCATION/bin/maps
            fi
            if [ -d $OPTION_SOURCE_LOCATION/bin/mmaps ]; then
                rm -rf $OPTION_SOURCE_LOCATION/bin/mmaps
            fi
            if [ -d $OPTION_SOURCE_LOCATION/bin/vmaps ]; then
                rm -rf $OPTION_SOURCE_LOCATION/bin/vmaps
            fi

            # Download the client data files archive
            curl -L https://github.com/wowgaming/client-data/releases/download/v${OPTION_SOURCE_REQUIRED_CLIENT_DATA}/data.zip > $OPTION_SOURCE_LOCATION/bin/data.zip

            # Check to make sure there weren't any errors
            if [ $? -ne 0 ]; then
                # Terminate script on errors
                exit $?
            fi

            # Unzip the archive into the proper folders
            unzip -o "$OPTION_SOURCE_LOCATION/bin/data.zip" -d "$OPTION_SOURCE_LOCATION/bin/"

            # Check to make sure there weren't any errors
            if [ $? -ne 0 ]; then
                # Terminate script on errors
                exit $?
            fi

            # Remove the archive since it's no longer needed
            rm -rf $OPTION_SOURCE_LOCATION/bin/data.zip

            # Set the installed version to the same as the required version
            OPTION_SOURCE_INSTALLED_CLIENT_DATA=$OPTION_SOURCE_REQUIRED_CLIENT_DATA

            # Save the version to the options file
            save_options

            printf "${COLOR_GREEN}Finished downloading the client data files...${COLOR_END}\n"
        fi

        # Allow copying custom dbc files to the dbc folder
        if [ -d $ROOT/dbc ]; then
            # Check if the folder is empty
            if [[ ! -z "$(ls -A $ROOT/dbc/)" ]]; then
                printf "${COLOR_GREEN}Copying modified dbc files...${COLOR_END}\n"

                # Loop through all dbc files inside the folder
                for f in $ROOT/dbc/*.dbc; do
                    printf "${COLOR_ORANGE}Copying "$(basename $f)"${COLOR_END}\n"

                    # Copy the file
                    cp -r $f "$OPTION_SOURCE_LOCATION/bin/dbc/$(basename $f)"
                done

                printf "${COLOR_GREEN}Finished copying custom dbc files...${COLOR_END}\n"
            fi
        fi
    fi
}

# A function that imports all database files
function import_database
{
    # Create the mysql.cnf file to prevent warnings during import
    MYSQL_CNF="$ROOT/mysql.cnf"
    echo "[client]" > $MYSQL_CNF
    echo "host=\"$OPTION_MYSQL_HOSTNAME\"" >> $MYSQL_CNF
    echo "port=\"$OPTION_MYSQL_PORT\"" >> $MYSQL_CNF
    echo "user=\"$OPTION_MYSQL_USERNAME\"" >> $MYSQL_CNF
    echo "password=\"$OPTION_MYSQL_PASSWORD\"" >> $MYSQL_CNF

    # Make sure the auth database exists and is accessible
    if [ -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names -e "SHOW DATABASES LIKE '$OPTION_MYSQL_DATABASES_AUTH'"` ]; then
        # We can't access the required database, so terminate the script
        printf "${COLOR_RED}The database named $OPTION_MYSQL_DATABASES_AUTH is inaccessible by the user named $OPTION_MYSQL_USERNAME.${COLOR_END}\n"

        # Remove the mysql conf
        rm -rf $MYSQL_CNF

        # Terminate script on error
        exit $?
    fi

    # Check if either both or auth is used as the first parameter
    if [[ $1 == "both" ]] || [[ $1 == "auth" ]]; then
        # Make sure the database folders exists
        if [ ! -d $OPTION_SOURCE_LOCATION/data/sql/base/db_auth ] || [ ! -d $OPTION_SOURCE_LOCATION/data/sql/updates/db_auth ]; then
            # The files are missing, so terminate the script
            printf "${COLOR_RED}There are no database files where there should be.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

            # Remove the mysql conf
            rm -rf $MYSQL_CNF

            # Terminate script on error
            exit $?
        fi
    fi

    # Check if either both or world is used as the first parameter
    if [[ $1 == "both" ]] || [[ $1 == "world" ]]; then
        # Make sure the characters database exists and is accessible
        if [ -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names -e "SHOW DATABASES LIKE '$OPTION_MYSQL_DATABASES_CHARACTERS'"` ]; then
            # We can't access the required database, so terminate the script
            printf "${COLOR_RED}The database named $OPTION_MYSQL_DATABASES_CHARACTERS is inaccessible by the user named $OPTION_MYSQL_USERNAME.${COLOR_END}\n"

            # Remove the mysql conf
            rm -rf $MYSQL_CNF

            # Terminate script on error
            exit $?
        fi

        # Make sure the world database exists and is accessible
        if [ -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names -e "SHOW DATABASES LIKE '$OPTION_MYSQL_DATABASES_WORLD'"` ]; then
            # We can't access the required database, so terminate the script
            printf "${COLOR_RED}The database named $OPTION_MYSQL_DATABASES_WORLD is inaccessible by the user named $OPTION_MYSQL_USERNAME.${COLOR_END}\n"

            # Remove the mysql conf
            rm -rf $MYSQL_CNF

            # Terminate script on error
            exit $?
        fi

        # Make sure the database folders exists
        if [ ! -d $OPTION_SOURCE_LOCATION/data/sql/base/db_characters ] || [ ! -d $OPTION_SOURCE_LOCATION/data/sql/updates/db_characters ] || [ ! -d $OPTION_SOURCE_LOCATION/data/sql/base/db_world ] || [ ! -d $OPTION_SOURCE_LOCATION/data/sql/updates/db_world ]; then
            # The files are missing, so terminate the script
            printf "${COLOR_RED}There are no database files where there should be.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

            # Remove the mysql conf
            rm -rf $MYSQL_CNF

            # Terminate script on error
            exit $?
        fi
    fi

    # No errors occured so we can proceed
    printf "${COLOR_GREEN}Importing the database files...${COLOR_END}\n"

    # Check if either both or auth is used as the first parameter
    if [[ $1 == "both" ]] || [[ $1 == "auth" ]]; then
        # Loop through all sql files inside the auth base folder
        for f in $OPTION_SOURCE_LOCATION/data/sql/base/db_auth/*.sql; do
            # Check if the table already exists
            if [ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_AUTH -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"

                # Skip the file since it's already imported
                continue;
            fi

            # Check to make sure there weren't any errors
            if [ $? -ne 0 ]; then
                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi

            # Import the sql file
            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_AUTH < $f

            # Check to make sure there weren't any errors
            if [ $? -ne 0 ]; then
                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi
        done

        # Loop through all sql files inside the auth updates folder
        for f in $OPTION_SOURCE_LOCATION/data/sql/updates/db_auth/*.sql; do
            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"

            # Import the sql file
            mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_AUTH < $f

            # Check to make sure there weren't any errors
            if [ $? -ne 0 ]; then
                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi
        done
    fi

    # Check if either both or world is used as the first parameter
    if [[ $1 == "both" ]] || [[ $1 == "world" ]]; then
        # Loop through all sql files inside the characters base folder
        for f in $OPTION_SOURCE_LOCATION/data/sql/base/db_characters/*.sql; do
            # Check if the table already exists
            if [ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_CHARACTERS -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"

                # Skip the file since it's already imported
                continue;
            fi

            # Check to make sure there weren't any errors
            if [ $? -ne 0 ]; then
                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi

            # Import the sql file
            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_CHARACTERS < $f

            # Check to make sure there weren't any errors
            if [ $? -ne 0 ]; then
                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi
        done

        # Loop through all sql files inside the characters updates folder
        for f in $OPTION_SOURCE_LOCATION/data/sql/updates/db_characters/*.sql; do
            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"

            # Import the sql file
            mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_CHARACTERS < $f

            # Check to make sure there weren't any errors
            if [ $? -ne 0 ]; then
                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi
        done

        # Loop through all sql files inside the world base folder
        for f in $OPTION_SOURCE_LOCATION/data/sql/base/db_world/*.sql; do
            # Check if the table already exists
            if [ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_WORLD -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"

                # Skip the file since it's already imported
                continue;
            fi

            # Check to make sure there weren't any errors
            if [ $? -ne 0 ]; then
                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi

            # Import the sql file
            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

            # Check to make sure there weren't any errors
            if [ $? -ne 0 ]; then
                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi
        done

        # Loop through all sql files inside the world updates folder
        for f in $OPTION_SOURCE_LOCATION/data/sql/updates/db_world/*.sql; do
            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"

            # Import the sql file
            mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

            # Check to make sure there weren't any errors
            if [ $? -ne 0 ]; then
                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi
        done

        printf "${COLOR_ORANGE}Adding to the realmlist (id: $OPTION_WORLD_ID, name: $OPTION_WORLD_NAME, address $OPTION_WORLD_ADDRESS)${COLOR_END}\n"
        # Update the realmlist with the id, name and address specified
        mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_AUTH -e "DELETE FROM realmlist WHERE id='$OPTION_WORLD_ID';INSERT INTO realmlist (id, name, address, localAddress, localSubnetMask, port) VALUES ('$OPTION_WORLD_ID', '$OPTION_WORLD_NAME', '$OPTION_WORLD_ADDRESS', '$OPTION_WORLD_ADDRESS', '255.255.255.0', '8085')"

        # Check to make sure there weren't any errors
        if [ $? -ne 0 ]; then
            # Remove the mysql conf
            rm -rf $MYSQL_CNF

            # Terminate script on error
            exit $?
        fi

        # Check if the ahbot module is enabled
        if [[ $OPTION_MODULES_AHBOT_ENABLED == "true" ]]; then
            # Make sure the database folder exists
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-ah-bot/sql/world/base ]; then
                # Loop through all sql files inside the folder
                for f in $OPTION_SOURCE_LOCATION/modules/mod-ah-bot/sql/world/base/*.sql; do
                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"

                    # Import the sql file
                    mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

                    # Check to make sure there weren't any errors
                    if [ $? -ne 0 ]; then
                        # Remove the mysql conf
                        rm -rf $MYSQL_CNF

                        # Terminate script on error
                        exit $?
                    fi
                done

                # Update the mod_auctionhousebot table with specified values
                mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD -e "UPDATE mod_auctionhousebot SET minitems='$OPTION_MODULES_AHBOT_MIN_ITEMS', maxitems='$OPTION_MODULES_AHBOT_MAX_ITEMS'"

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Remove the mysql conf
                    rm -rf $MYSQL_CNF

                    # Terminate script on error
                    exit $?
                fi
            fi
        else
            # Check if the mod_auctionhousebot table exists when the module is not enabled
            if [ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_WORLD -e "SHOW TABLES LIKE 'mod_auctionhousebot'"` ]; then
                # Drop the table
                mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD -e "DROP TABLE mod_auctionhousebot"

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Remove the mysql conf
                    rm -rf $MYSQL_CNF

                    # Terminate script on error
                    exit $?
                fi
            fi

            # Check if the mod_auctionhousebot_disabled_items table exists when the module is not enabled
            if [ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_WORLD -e "SHOW TABLES LIKE 'mod_auctionhousebot_disabled_items'"` ]; then
                # Drop the table
                mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD -e "DROP TABLE mod_auctionhousebot_disabled_items"

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Remove the mysql conf
                    rm -rf $MYSQL_CNF

                    # Terminate script on error
                    exit $?
                fi
            fi
        fi

        # Check if the assistant module is enabled
        if [[ $OPTION_MODULES_ASSISTANT_ENABLED == "true" ]]; then
            # Make sure the database folder exists
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-assistant/sql/world/base ]; then
                # Loop through all sql files inside the folder
                for f in $OPTION_SOURCE_LOCATION/modules/mod-assistant/sql/world/base/*.sql; do
                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"

                    # Import the sql file
                    mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

                    # Check to make sure there weren't any errors
                    if [ $? -ne 0 ]; then
                        # Remove the mysql conf
                        rm -rf $MYSQL_CNF

                        # Terminate script on error
                        exit $?
                    fi
                done
            fi
        fi

        # Check if the group quests module is enabled
        if [[ $OPTION_MODULES_GROUP_QUESTS_ENABLED == "true" ]]; then
            # Make sure the database folder exists
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-groupquests/sql/world/base ]; then
                # Loop through all sql files inside the folder
                for f in $OPTION_SOURCE_LOCATION/modules/mod-groupquests/sql/world/base/*.sql; do
                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"

                    # Import the sql file
                    mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

                    # Check to make sure there weren't any errors
                    if [ $? -ne 0 ]; then
                        # Remove the mysql conf
                        rm -rf $MYSQL_CNF

                        # Terminate script on error
                        exit $?
                    fi
                done
            fi
        fi

        # Check if the learn spells module is enabled
        if [[ $OPTION_MODULES_LEARN_SPELLS_ENABLED == "true" ]]; then
            # Make sure the database folder exists
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-learnspells/sql/world/base ]; then
                # Loop through all sql files inside the folder
                for f in $OPTION_SOURCE_LOCATION/modules/mod-learnspells/sql/world/base/*.sql; do
                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"

                    # Import the sql file
                    mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

                    # Check to make sure there weren't any errors
                    if [ $? -ne 0 ]; then
                        # Remove the mysql conf
                        rm -rf $MYSQL_CNF

                        # Terminate script on error
                        exit $?
                    fi
                done
            fi
        else
            # Check if the mod_learnspells table exists when the module is not enabled
            if [ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_WORLD -e "SHOW TABLES LIKE 'mod_learnspells'"` ]; then
                # Drop the table
                mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD -e "DROP TABLE mod_learnspells"

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Remove the mysql conf
                    rm -rf $MYSQL_CNF

                    # Terminate script on error
                    exit $?
                fi
            fi
        fi

        # Check if the recruit-a-friend module is enabled
        if [[ $OPTION_MODULES_RECRUIT_A_FRIEND_ENABLED == "true" ]]; then
            # Make sure the database folder exists
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-recruitafriend/sql/auth/base ]; then
                # Loop through all sql files inside the folder
                for f in $OPTION_SOURCE_LOCATION/modules/mod-recruitafriend/sql/auth/base/*.sql; do
                    if [ -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_AUTH -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]; then
                        printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"

                        # Import the sql file
                        mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_AUTH < $f

                        # Check to make sure there weren't any errors
                        if [ $? -ne 0 ]; then
                            # Remove the mysql conf
                            rm -rf $MYSQL_CNF

                            # Terminate script on error
                            exit $?
                        fi
                    fi
                done
            fi

            # Make sure the database folder exists
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-recruitafriend/sql/characters/base ]; then
                # Loop through all sql files inside the folder
                for f in $OPTION_SOURCE_LOCATION/modules/mod-recruitafriend/sql/characters/base/*.sql; do
                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"

                    # Import the sql file
                    mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_CHARACTERS < $f

                    # Check to make sure there weren't any errors
                    if [ $? -ne 0 ]; then
                        # Remove the mysql conf
                        rm -rf $MYSQL_CNF

                        # Terminate script on error
                        exit $?
                    fi
                done
            fi
        fi

        # Check if the spawn points module is enabled
        if [[ $OPTION_MODULES_SPAWN_POINTS_ENABLED == "true" ]]; then
            # Make sure the database folder exists
            if [ -d $OPTION_SOURCE_LOCATION/modules/mod-spawnpoints/sql/world/base ]; then
                # Loop through all sql files inside the folder
                for f in $OPTION_SOURCE_LOCATION/modules/mod-spawnpoints/sql/world/base/*.sql; do
                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"

                    # Import the sql file
                    mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

                    # Check to make sure there weren't any errors
                    if [ $? -ne 0 ]; then
                        # Remove the mysql conf
                        rm -rf $MYSQL_CNF

                        # Terminate script on error
                        exit $?
                    fi
                done
            fi
        else
            # Check if the mod_learnspells table exists when the module is not enabled
            if [ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_WORLD -e "SHOW TABLES LIKE 'mod_spawnpoints'"` ]; then
                # Drop the table
                mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD -e "DROP TABLE mod_spawnpoints"

                # Check to make sure there weren't any errors
                if [ $? -ne 0 ]; then
                    # Remove the mysql conf
                    rm -rf $MYSQL_CNF

                    # Terminate script on error
                    exit $?
                fi
            fi
        fi

        # Check if there is a folder for custom content
        if [ -d $ROOT/sql/world ]; then
            # Check if the folder is empty
            if [[ ! -z "$(ls -A $ROOT/sql/world/)" ]]; then
                # Loop through all sql files inside the folder
                for f in $ROOT/sql/world/*.sql; do
                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"

                    # Import the sql file
                    mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

                    # Check to make sure there weren't any errors
                    if [ $? -ne 0 ]; then
                        # Remove the mysql conf
                        rm -rf $MYSQL_CNF

                        # Terminate script on error
                        exit $?
                    fi
                done
            fi
        fi
    fi

    # Remove the mysql conf
    rm -rf $MYSQL_CNF

    printf "${COLOR_GREEN}Finished importing the database files...${COLOR_END}\n"
}

# A function that changes config files to values specified in the options
function set_config
{
    printf "${COLOR_GREEN}Updating the config files...${COLOR_END}\n"

    # Check if either both or auth is used as the first parameter
    if [[ $1 == "both" ]] || [[ $1 == "auth" ]]; then
        # Check to make sure the config file exists
        if [ ! -f $OPTION_SOURCE_LOCATION/etc/authserver.conf.dist ]; then
            # The file is missing, so terminate the script
            printf "${COLOR_RED}The config file authserver.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

            # Remove the mysql conf
            rm -rf $MYSQL_CNF

            # Terminate script on error
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating authserver.conf${COLOR_END}\n"

        # Copy the file before editing it
        cp $OPTION_SOURCE_LOCATION/etc/authserver.conf.dist $OPTION_SOURCE_LOCATION/etc/authserver.conf

        # Update authserver.conf with values specified in the options
        sed -i 's/LoginDatabaseInfo =.*/LoginDatabaseInfo = "'$OPTION_MYSQL_HOSTNAME';'$OPTION_MYSQL_PORT';'$OPTION_MYSQL_USERNAME';'$OPTION_MYSQL_PASSWORD';'$OPTION_MYSQL_DATABASES_AUTH'"/g' $OPTION_SOURCE_LOCATION/etc/authserver.conf
        sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 0/g' $OPTION_SOURCE_LOCATION/etc/authserver.conf
    fi

    # Check if either both or world is used as the first parameter
    if [[ $1 == "both" ]] || [[ $1 == "world" ]]; then
        # Check to make sure the config file exists
        if [ ! -f $OPTION_SOURCE_LOCATION/etc/worldserver.conf.dist ]; then
            # The file is missing, so terminate the script
            printf "${COLOR_RED}The config file worldserver.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

            # Remove the mysql conf
            rm -rf $MYSQL_CNF

            # Terminate script on error
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating worldserver.conf${COLOR_END}\n"

        # Convert boolean values to integers
        [ $OPTION_WORLD_ALWAYS_MAX_SKILL == "true" ] && WORLD_ALWAYS_MAX_SKILL=1 || WORLD_ALWAYS_MAX_SKILL=0
        [ $OPTION_WORLD_ALL_FLIGHT_PATHS == "true" ] && WORLD_ALL_FLIGHT_PATHS=1 || WORLD_ALL_FLIGHT_PATHS=0
        [ $OPTION_WORLD_MAPS_EXPLORED == "true" ] && WORLD_MAPS_EXPLORED=1 || WORLD_MAPS_EXPLORED=0
        [ $OPTION_WORLD_ALLOW_COMMANDS == "true" ] && WORLD_ALLOW_COMMANDS=1 || WORLD_ALLOW_COMMANDS=0
        [ $OPTION_WORLD_QUEST_IGNORE_RAID == "true" ] && WORLD_QUEST_IGNORE_RAID=1 || WORLD_QUEST_IGNORE_RAID=0
        [ $OPTION_WORLD_PREVENT_AFK_LOGOUT == "true" ] && WORLD_PREVENT_AFK_LOGOUT=1 || WORLD_PREVENT_AFK_LOGOUT=0
        [ $OPTION_WORLD_PRELOAD_MAP_GRIDS == "true" ] && WORLD_PRELOAD_MAP_GRIDS=1 || WORLD_PRELOAD_MAP_GRIDS=0
        [ $OPTION_WORLD_SET_ALL_WAYPOINTS_ACTIVE == "true" ] && WORLD_SET_ALL_WAYPOINTS_ACTIVE=1 || WORLD_SET_ALL_WAYPOINTS_ACTIVE=0
        [ $OPTION_WORLD_ENABLE_MINIGOB_MANABONK == "true" ] && WORLD_ENABLE_MINIGOB_MANABONK=1 || WORLD_ENABLE_MINIGOB_MANABONK=0
        [ $OPTION_WORLD_ENABLE_WARDEN == "true" ] && WORLD_ENABLE_WARDEN=1 || WORLD_ENABLE_WARDEN=0
        [ $OPTION_WORLD_GM_LOGIN_STATE == "true" ] && WORLD_GM_LOGIN_STATE=1 || WORLD_GM_LOGIN_STATE=0
        [ $OPTION_WORLD_GM_ENABLE_VISIBILITY == "true" ] && WORLD_GM_ENABLE_VISIBILITY=1 || WORLD_GM_ENABLE_VISIBILITY=0
        [ $OPTION_WORLD_GM_ENABLE_CHAT == "true" ] && WORLD_GM_ENABLE_CHAT=1 || WORLD_GM_ENABLE_CHAT=0
        [ $OPTION_WORLD_GM_ENABLE_WHISPER == "true" ] && WORLD_GM_ENABLE_WHISPER=1 || WORLD_GM_ENABLE_WHISPER=0
        [ $OPTION_WORLD_GM_ALLOW_INVITE == "true" ] && WORLD_GM_ALLOW_INVITE=1 || WORLD_GM_ALLOW_INVITE=0
        [ $OPTION_WORLD_GM_ALLOW_FRIEND == "true" ] && WORLD_GM_ALLOW_FRIEND=1 || WORLD_GM_ALLOW_FRIEND=0
        [ $OPTION_WORLD_GM_ALLOW_LOWER_SECURITY == "true" ] && WORLD_GM_ALLOW_LOWER_SECURITY=1 || WORLD_GM_ALLOW_LOWER_SECURITY=0
        [ $OPTION_WORLD_DISABLE_LEAVE_GROUP == "true" ] && WORLD_DISABLE_LEAVE_GROUP=0 || WORLD_DISABLE_LEAVE_GROUP=1

        # Copy the file before editing it
        cp $OPTION_SOURCE_LOCATION/etc/worldserver.conf.dist $OPTION_SOURCE_LOCATION/etc/worldserver.conf

        # Update worldserver.conf with values specified in the options
        sed -i 's/LoginDatabaseInfo     =.*/LoginDatabaseInfo     = "'$OPTION_MYSQL_HOSTNAME';'$OPTION_MYSQL_PORT';'$OPTION_MYSQL_USERNAME';'$OPTION_MYSQL_PASSWORD';'$OPTION_MYSQL_DATABASES_AUTH'"/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/WorldDatabaseInfo     =.*/WorldDatabaseInfo     = "'$OPTION_MYSQL_HOSTNAME';'$OPTION_MYSQL_PORT';'$OPTION_MYSQL_USERNAME';'$OPTION_MYSQL_PASSWORD';'$OPTION_MYSQL_DATABASES_WORLD'"/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/CharacterDatabaseInfo =.*/CharacterDatabaseInfo = "'$OPTION_MYSQL_HOSTNAME';'$OPTION_MYSQL_PORT';'$OPTION_MYSQL_USERNAME';'$OPTION_MYSQL_PASSWORD';'$OPTION_MYSQL_DATABASES_CHARACTERS'"/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 0/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/RealmID =.*/RealmID = '$OPTION_WORLD_ID'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GameType =.*/GameType = '$OPTION_WORLD_GAME_TYPE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/RealmZone =.*/RealmZone = '$OPTION_WORLD_REALM_ZONE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Expansion =.*/Expansion = '$OPTION_WORLD_EXPANSION'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/PlayerLimit =.*/PlayerLimit = '$OPTION_WORLD_PLAYER_LIMIT'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/StrictPlayerNames =.*/StrictPlayerNames = 3/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/StrictCharterNames =.*/StrictCharterNames = 3/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/StrictPetNames =.*/StrictPetNames = 3/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Motd =.*/Motd = "'"$OPTION_WORLD_MOTD"'"/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/SkipCinematics =.*/SkipCinematics = '$OPTION_WORLD_SKIP_CINEMATICS'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/MaxPlayerLevel =.*/MaxPlayerLevel = '$OPTION_WORLD_MAX_LEVEL'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/StartPlayerLevel =.*/StartPlayerLevel = '$OPTION_WORLD_START_LEVEL'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/StartPlayerMoney =.*/StartPlayerMoney = '$OPTION_WORLD_START_MONEY'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/AllFlightPaths =.*/AllFlightPaths = '$WORLD_ALL_FLIGHT_PATHS'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/AlwaysMaxSkillForLevel =.*/AlwaysMaxSkillForLevel = '$WORLD_ALWAYS_MAX_SKILL'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/PlayerStart.MapsExplored =.*/PlayerStart.MapsExplored = '$WORLD_MAPS_EXPLORED'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/AllowPlayerCommands =.*/AllowPlayerCommands = '$WORLD_ALLOW_COMMANDS'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Quests.IgnoreRaid =.*/Quests.IgnoreRaid = '$WORLD_QUEST_IGNORE_RAID'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/PreventAFKLogout =.*/PreventAFKLogout = '$WORLD_PREVENT_AFK_LOGOUT'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/RecruitAFriend.MaxLevel =.*/RecruitAFriend.MaxLevel = '$OPTION_WORLD_RAF_MAX_LEVEL'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/PreloadAllNonInstancedMapGrids =.*/PreloadAllNonInstancedMapGrids = '$WORLD_PRELOAD_MAP_GRIDS'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/SetAllCreaturesWithWaypointMovementActive =.*/SetAllCreaturesWithWaypointMovementActive = '$WORLD_SET_ALL_WAYPOINTS_ACTIVE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Minigob.Manabonk.Enable =.*/Minigob.Manabonk.Enable = '$WORLD_ENABLE_MINIGOB_MANABONK'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.Drop.Money                 =.*/Rate.Drop.Money                 = '$OPTION_WORLD_RATES_MONEY'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.XP.Kill      =.*/Rate.XP.Kill      = '$OPTION_WORLD_RATES_EXPERIENCE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.XP.Quest     =.*/Rate.XP.Quest     = '$OPTION_WORLD_RATES_EXPERIENCE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.XP.Quest.DF  =.*/Rate.XP.Quest.DF  = '$OPTION_WORLD_RATES_EXPERIENCE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.XP.Explore   =.*/Rate.XP.Explore   = '$OPTION_WORLD_RATES_EXPERIENCE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.XP.Pet       =.*/Rate.XP.Pet       = '$OPTION_WORLD_RATES_EXPERIENCE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.Reputation.Gain =.*/Rate.Reputation.Gain = '$OPTION_WORLD_RATES_REPUTATION'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/SkillGain.Crafting  =.*/SkillGain.Crafting  = '$OPTION_WORLD_RATES_CRAFTING'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/SkillGain.Defense   =.*/SkillGain.Defense   = '$OPTION_WORLD_RATES_DEFENSE_SKILL'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/SkillGain.Gathering =.*/SkillGain.Gathering = '$OPTION_WORLD_RATES_GATHERING'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/SkillGain.Weapon    =.*/SkillGain.Weapon    = '$OPTION_WORLD_RATES_WEAPON_SKILL'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.Rest.InGame                 =.*/Rate.Rest.InGame                 = '$OPTION_WORLD_RATES_RESTED_EXPERIENCE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.Rest.Offline.InTavernOrCity =.*/Rate.Rest.Offline.InTavernOrCity = '$OPTION_WORLD_RATES_RESTED_EXPERIENCE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.Rest.Offline.InWilderness   =.*/Rate.Rest.Offline.InWilderness   = '$OPTION_WORLD_RATES_RESTED_EXPERIENCE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.LoginState =.*/GM.LoginState = '$WORLD_GM_LOGIN_STATE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.Visible =.*/GM.Visible = '$WORLD_GM_ENABLE_VISIBILITY'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.Chat =.*/GM.Chat = '$WORLD_GM_ENABLE_CHAT'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.WhisperingTo =.*/GM.WhisperingTo = '$WORLD_GM_ENABLE_WHISPER'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.InGMList.Level =.*/GM.InGMList.Level = '$OPTION_WORLD_GM_SHOW_GM_LIST'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.InWhoList.Level =.*/GM.InWhoList.Level = '$OPTION_WORLD_GM_SHOW_WHO_LIST'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.StartLevel = .*/GM.StartLevel = '$OPTION_WORLD_START_LEVEL'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.AllowInvite =.*/GM.AllowInvite = '$WORLD_GM_ALLOW_INVITE'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.AllowFriend =.*/GM.AllowFriend = '$WORLD_GM_ALLOW_FRIEND'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.LowerSecurity =.*/GM.LowerSecurity = '$WORLD_GM_ALLOW_LOWER_SECURITY'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Warden.Enabled =.*/Warden.Enabled = '$WORLD_ENABLE_WARDEN'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/LeaveGroupOnLogout.Enabled =.*/LeaveGroupOnLogout.Enabled = '$WORLD_DISABLE_LEAVE_GROUP'/g' $OPTION_SOURCE_LOCATION/etc/worldserver.conf

        # Check if the ahbot module is enabled
        if [[ $OPTION_MODULES_AHBOT_ENABLED == "true" ]]; then
            # Check to make sure the config file exists
            if [ ! -f $OPTION_SOURCE_LOCATION/etc/modules/mod_ahbot.conf.dist ]; then
                # The file is missing, so terminate the script
                printf "${COLOR_RED}The config file mod_ahbot.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_ahbot.conf${COLOR_END}\n"

            # Convert boolean values to integers
            [ $OPTION_MODULES_AHBOT_ENABLE_BUYER == "true" ] && MODULES_AHBOT_ENABLE_BUYER=1 || MODULES_AHBOT_ENABLE_BUYER=0
            [ $OPTION_MODULES_AHBOT_ENABLE_SELLER == "true" ] && MODULES_AHBOT_ENABLE_SELLER=1 || MODULES_AHBOT_ENABLE_SELLER=0

            # Copy the file before editing it
            cp $OPTION_SOURCE_LOCATION/etc/modules/mod_ahbot.conf.dist $OPTION_SOURCE_LOCATION/etc/modules/mod_ahbot.conf

            # Update mod_ahbot.conf with values specified in the options
            sed -i 's/AuctionHouseBot.EnableBuyer =.*/AuctionHouseBot.EnableBuyer = '$MODULES_AHBOT_ENABLE_BUYER'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_ahbot.conf
            sed -i 's/AuctionHouseBot.EnableSeller =.*/AuctionHouseBot.EnableSeller = '$MODULES_AHBOT_ENABLE_SELLER'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_ahbot.conf
            sed -i 's/AuctionHouseBot.Account =.*/AuctionHouseBot.Account = '$OPTION_MODULES_AHBOT_ACCOUNT_ID'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_ahbot.conf
            sed -i 's/AuctionHouseBot.GUID =.*/AuctionHouseBot.GUID = '$OPTION_MODULES_AHBOT_CHARACTER_GUID'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_ahbot.conf
        else
            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_ahbot.conf.dist ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_ahbot.conf.dist
            fi

            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_ahbot.conf ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_ahbot.conf
            fi
        fi

        # Check if the assistant module is enabled
        if [[ $OPTION_MODULES_ASSISTANT_ENABLED == "true" ]]; then
            # Check to make sure the config file exists
            if [ ! -f $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf.dist ]; then
                # The file is missing, so terminate the script
                printf "${COLOR_RED}The config file mod_assistant.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_assistant.conf${COLOR_END}\n"

            # Convert boolean values to integers
            [ $OPTION_MODULES_ASSISTANT_FEATURES_HEIRLOOMS == "true" ] && MODULES_ASSISTANT_FEATURES_HEIRLOOMS=1 || MODULES_ASSISTANT_FEATURES_HEIRLOOMS=0
            [ $OPTION_MODULES_ASSISTANT_FEATURES_GLYPHS == "true" ] && MODULES_ASSISTANT_FEATURES_GLYPHS=1 || MODULES_ASSISTANT_FEATURES_GLYPHS=0
            [ $OPTION_MODULES_ASSISTANT_FEATURES_GEMS == "true" ] && MODULES_ASSISTANT_FEATURES_GEMS=1 || MODULES_ASSISTANT_FEATURES_GEMS=0
            [ $OPTION_MODULES_ASSISTANT_FEATURES_CONTAINERS == "true" ] && MODULES_ASSISTANT_FEATURES_CONTAINERS=1 || MODULES_ASSISTANT_FEATURES_CONTAINERS=0
            [ $OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_ENABLED == "true" ] && MODULES_ASSISTANT_FEATURES_UTILITIES_ENABLED=1 || MODULES_ASSISTANT_FEATURES_UTILITIES_ENABLED=0
            [ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ENABLED == "true" ] && MODULES_ASSISTANT_FEATURES_PROFESSIONS_ENABLED=1 || MODULES_ASSISTANT_FEATURES_PROFESSIONS_ENABLED=0
            [ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_ENABLED == "true" ] && MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_ENABLED=1 || MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_ENABLED=0
            [ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_ENABLED == "true" ] && MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_ENABLED=1 || MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_ENABLED=0
            [ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_ENABLED == "true" ] && MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_ENABLED=1 || MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_ENABLED=0
            [ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_ENABLED == "true" ] && MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_ENABLED=1 || MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_ENABLED=0
            [ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_ENABLED == "true" ] && MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_ENABLED=1 || MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_ENABLED=0
            [ $OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_ENABLED == "true" ] && MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_ENABLED=1 || MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_ENABLED=0

            # Copy the file before editing it
            cp $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf.dist $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf

            # Update mod_assistant.conf with values specified in the options
            sed -i 's/Assistant.Heirlooms =.*/Assistant.Heirlooms = '$MODULES_ASSISTANT_FEATURES_HEIRLOOMS'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Glyphs =.*/Assistant.Glyphs = '$MODULES_ASSISTANT_FEATURES_GLYPHS'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Gems =.*/Assistant.Gems = '$MODULES_ASSISTANT_FEATURES_GEMS'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Containers =.*/Assistant.Containers = '$MODULES_ASSISTANT_FEATURES_CONTAINERS'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Utilities =.*/Assistant.Utilities = '$MODULES_ASSISTANT_FEATURES_UTILITIES_ENABLED'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Utilities.NameChange =.*/Assistant.Utilities.NameChange = '$OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_NAME_CHANGE'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Utilities.Customization =.*/Assistant.Utilities.Customization = '$OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_CUSTOMIZATION'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Utilities.RaceChange =.*/Assistant.Utilities.RaceChange = '$OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_RACE_CHANGE'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Utilities.FactionChange =.*/Assistant.Utilities.FactionChange = '$OPTION_MODULES_ASSISTANT_FEATURES_UTILITIES_FACTION_CHANGE'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions =.*/Assistant.Professions = '$MODULES_ASSISTANT_FEATURES_PROFESSIONS_ENABLED'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Apprentice.Enabled =.*/Assistant.Professions.Apprentice.Enabled = '$MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_ENABLED'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Journeyman.Enabled =.*/Assistant.Professions.Journeyman.Enabled = '$MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_ENABLED'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Expert.Enabled =.*/Assistant.Professions.Expert.Enabled = '$MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_ENABLED'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Artisan.Enabled =.*/Assistant.Professions.Artisan.Enabled = '$MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_ENABLED'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Master.Enabled =.*/Assistant.Professions.Master.Enabled = '$MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_ENABLED'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.GrandMaster.Enabled =.*/Assistant.Professions.GrandMaster.Enabled = '$MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_ENABLED'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Apprentice.Cost =.*/Assistant.Professions.Apprentice.Cost = '$OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_APPRENTICE_COST'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Journeyman.Cost =.*/Assistant.Professions.Journeyman.Cost = '$OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_JOURNEYMAN_COST'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Expert.Cost =.*/Assistant.Professions.Expert.Cost = '$OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_EXPERT_COST'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Artisan.Cost =.*/Assistant.Professions.Artisan.Cost = '$OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_ARTISAN_COST'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Master.Cost =.*/Assistant.Professions.Master.Cost = '$OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_MASTER_COST'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.GrandMaster.Cost =.*/Assistant.Professions.GrandMaster.Cost = '$OPTION_MODULES_ASSISTANT_FEATURES_PROFESSIONS_GRAND_MASTER_COST'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
        else
            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf.dist ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf.dist
            fi

            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_assistant.conf
            fi
        fi

        # Check if the learn spells module is enabled
        if [[ $OPTION_MODULES_LEARN_SPELLS_ENABLED == "true" ]]; then
            # Check to make sure the config file exists
            if [ ! -f $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf.dist ]; then
                # The file is missing, so terminate the script
                printf "${COLOR_RED}The config file mod_learnspells.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_learnspells.conf${COLOR_END}\n"

            # Convert boolean values to integers
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LOGIN == "true" ] && MODULES_LEARN_SPELLS_SPELLS_ON_LOGIN=1 || MODULES_LEARN_SPELLS_SPELLS_ON_LOGIN=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_ON_LEVELUP == "true" ] && MODULES_LEARN_SPELLS_SPELLS_ON_LEVELUP=1 || MODULES_LEARN_SPELLS_SPELLS_ON_LEVELUP=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_CLASS_SPELLS == "true" ] && MODULES_LEARN_SPELLS_SPELLS_CLASS_SPELLS=1 || MODULES_LEARN_SPELLS_SPELLS_CLASS_SPELLS=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_TALENT_RANKS == "true" ] && MODULES_LEARN_SPELLS_SPELLS_TALENT_RANKS=1 || MODULES_LEARN_SPELLS_SPELLS_TALENT_RANKS=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_PROFICIENCIES == "true" ] && MODULES_LEARN_SPELLS_SPELLS_PROFICIENCIES=1 || MODULES_LEARN_SPELLS_SPELLS_PROFICIENCIES=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_FROM_QUESTS == "true" ] && MODULES_LEARN_SPELLS_SPELLS_FROM_QUESTS=1 || MODULES_LEARN_SPELLS_SPELLS_FROM_QUESTS=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_ENABLED == "true" ] && MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_ENABLED=1 || MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_ENABLED=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ENABLED == "true" ] && MODULES_LEARN_SPELLS_SPELLS_RIDING_ENABLED=1 || MODULES_LEARN_SPELLS_SPELLS_RIDING_ENABLED=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_APPRENTICE == "true" ] && MODULES_LEARN_SPELLS_SPELLS_RIDING_APPRENTICE=1 || MODULES_LEARN_SPELLS_SPELLS_RIDING_APPRENTICE=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_JOURNEYMAN == "true" ] && MODULES_LEARN_SPELLS_SPELLS_RIDING_JOURNEYMAN=1 || MODULES_LEARN_SPELLS_SPELLS_RIDING_JOURNEYMAN=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_EXPERT == "true" ] && MODULES_LEARN_SPELLS_SPELLS_RIDING_EXPERT=1 || MODULES_LEARN_SPELLS_SPELLS_RIDING_EXPERT=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_ARTISAN == "true" ] && MODULES_LEARN_SPELLS_SPELLS_RIDING_ARTISAN=1 || MODULES_LEARN_SPELLS_SPELLS_RIDING_ARTISAN=0
            [ $OPTION_MODULES_LEARN_SPELLS_SPELLS_RIDING_COLD_WEATHER == "true" ] && MODULES_LEARN_SPELLS_SPELLS_RIDING_COLD_WEATHER=1 || MODULES_LEARN_SPELLS_SPELLS_RIDING_COLD_WEATHER=0

            # Copy the file before editing it
            cp $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf.dist $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf

            # Update mod_learnspells.conf with values specified in the options
            sed -i 's/LearnSpells.OnLogin.Enabled =.*/LearnSpells.OnLogin.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_ON_LOGIN'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.OnLevelUp.Enabled =.*/LearnSpells.OnLevelUp.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_ON_LEVELUP'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.ClassSpells.Enabled =.*/LearnSpells.ClassSpells.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_CLASS_SPELLS'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.TalentRanks.Enabled =.*/LearnSpells.TalentRanks.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_TALENT_RANKS'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Proficiencies.Enabled =.*/LearnSpells.Proficiencies.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_PROFICIENCIES'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.SpellsFromQuests.Enabled =.*/LearnSpells.SpellsFromQuests.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_FROM_QUESTS'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.MaxSkill.Enabled =.*/LearnSpells.MaxSkill.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_ENABLED'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.MaxSkill.MaxLevel =.*/LearnSpells.MaxSkill.MaxLevel = '$OPTION_MODULES_LEARN_SPELLS_SPELLS_MAX_SKILL_MAX_LEVEL'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Riding.Enabled =.*/LearnSpells.Riding.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_RIDING_ENABLED'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Riding.Apprentice.Enabled =.*/LearnSpells.Riding.Apprentice.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_RIDING_APPRENTICE'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Riding.Journeyman.Enabled =.*/LearnSpells.Riding.Journeyman.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_RIDING_JOURNEYMAN'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Riding.Expert.Enabled =.*/LearnSpells.Riding.Expert.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_RIDING_EXPERT'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Riding.Artisan.Enabled =.*/LearnSpells.Riding.Artisan.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_RIDING_ARTISAN'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Riding.ColdWeather.Enabled =.*/LearnSpells.Riding.ColdWeather.Enabled = '$MODULES_LEARN_SPELLS_SPELLS_RIDING_COLD_WEATHER'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
        else
            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf.dist ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf.dist
            fi

            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            fi
        fi

        # Check if the learn spells module is enabled
        if [[ $OPTION_MODULES_LEVEL_REWARD_ENABLED == "true" ]]; then
            # Check to make sure the config file exists
            if [ ! -f $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf.dist ]; then
                # The file is missing, so terminate the script
                printf "${COLOR_RED}The config file mod_levelreward.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_levelreward.conf${COLOR_END}\n"

            # Copy the file before editing it
            cp $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf.dist $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf

            # Update mod_levelreward.conf with values specified in the options
            sed -i 's/LevelReward.Level.10 =.*/LevelReward.Level.10 = '$OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_10'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf
            sed -i 's/LevelReward.Level.20 =.*/LevelReward.Level.20 = '$OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_20'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf
            sed -i 's/LevelReward.Level.30 =.*/LevelReward.Level.30 = '$OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_30'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf
            sed -i 's/LevelReward.Level.40 =.*/LevelReward.Level.40 = '$OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_40'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf
            sed -i 's/LevelReward.Level.50 =.*/LevelReward.Level.50 = '$OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_50'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf
            sed -i 's/LevelReward.Level.60 =.*/LevelReward.Level.60 = '$OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_60'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf
            sed -i 's/LevelReward.Level.70 =.*/LevelReward.Level.70 = '$OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_70'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf
            sed -i 's/LevelReward.Level.80 =.*/LevelReward.Level.80 = '$OPTION_MODULES_LEVEL_REWARD_GOLD_LEVEL_80'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf
        else
            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf.dist ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf.dist
            fi

            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_levelreward.conf
            fi
        fi

        # Check if the recruit-a-friend module is enabled
        if [[ $OPTION_MODULES_RECRUIT_A_FRIEND_ENABLED == "true" ]]; then
            # Check to make sure the config file exists
            if [ ! -f $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf.dist ]; then
                # The file is missing, so terminate the script
                printf "${COLOR_RED}The config file mod_recruitafriend.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_recruitafriend.conf${COLOR_END}\n"

            # Convert boolean values to integers
            [ $OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_SWIFT_ZHEVRA == "true" ] && MODULES_RECRUIT_A_FRIEND_REWARDS_SWIFT_ZHEVRA=1 || MODULES_RECRUIT_A_FRIEND_REWARDS_SWIFT_ZHEVRA=0
            [ $OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_TOURING_ROCKET == "true" ] && MODULES_RECRUIT_A_FRIEND_REWARDS_TOURING_ROCKET=1 || MODULES_RECRUIT_A_FRIEND_REWARDS_TOURING_ROCKET=0

            # Copy the file before editing it
            cp $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf.dist $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf

            # Update mod_recruitafriend.conf with values specified in the options
            sed -i 's/RecruitAFriend.Duration =.*/RecruitAFriend.Duration = '$OPTION_MODULES_RECRUIT_A_FRIEND_DURATION'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
            sed -i 's/RecruitAFriend.AccountAge =.*/RecruitAFriend.AccountAge = '$OPTION_MODULES_RECRUIT_A_FRIEND_ACCOUNT_AGE'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
            sed -i 's/RecruitAFriend.Rewards.Days =.*/RecruitAFriend.Rewards.Days = '$OPTION_MODULES_RECRUIT_A_FRIEND_REWARDS_DAYS'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
            sed -i 's/RecruitAFriend.Rewards.SwiftZhevra =.*/RecruitAFriend.Rewards.SwiftZhevra = '$MODULES_RECRUIT_A_FRIEND_REWARDS_SWIFT_ZHEVRA'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
            sed -i 's/RecruitAFriend.Rewards.TouringRocket =.*/RecruitAFriend.Rewards.TouringRocket = '$MODULES_RECRUIT_A_FRIEND_REWARDS_TOURING_ROCKET'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
        else
            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf.dist ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf.dist
            fi

            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
            fi
        fi

        # Check if the skip dk starting area module is enabled
        if [[ $OPTION_MODULES_SKIP_DK_STARTING_AREA_ENABLED == "true" ]]; then
            # Check to make sure the config file exists
            if [ ! -f $OPTION_SOURCE_LOCATION/etc/modules/SkipDKModule.conf.dist ]; then
                # The file is missing, so terminate the script
                printf "${COLOR_RED}The config file SkipDKModule.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating SkipDKModule.conf${COLOR_END}\n"

            # Copy the file before editing it
            cp $OPTION_SOURCE_LOCATION/etc/modules/SkipDKModule.conf.dist $OPTION_SOURCE_LOCATION/etc/modules/SkipDKModule.conf

            # Update SkipDKModule.conf with values specified in the options
            sed -i 's/Skip.Deathknight.Starter.Enable =.*/Skip.Deathknight.Starter.Enable = 1/g' $OPTION_SOURCE_LOCATION/etc/modules/SkipDKModule.conf
            sed -i 's/GM.Skip.Deathknight.Starter.Enable =.*/GM.Skip.Deathknight.Starter.Enable = 1/g' $OPTION_SOURCE_LOCATION/etc/modules/SkipDKModule.conf
            sed -i 's/Skip.Deathknight.Start.Level =.*/Skip.Deathknight.Start.Level = '$OPTION_MODULES_SKIP_DK_STARTING_AREA_STARTING_LEVEL'/g' $OPTION_SOURCE_LOCATION/etc/modules/SkipDKModule.conf
        else
            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/SkipDKModule.conf.dist ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/SkipDKModule.conf.dist
            fi

            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/SkipDKModule.conf ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/SkipDKModule.conf
            fi
        fi

        # Check if the weekend bonus module is enabled
        if [[ $OPTION_MODULES_WEEKEND_BONUS_ENABLED == "true" ]]; then
            # Check to make sure the config file exists
            if [ ! -f $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf.dist ]; then
                # The file is missing, so terminate the script
                printf "${COLOR_RED}The config file mod_weekendbonus.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

                # Remove the mysql conf
                rm -rf $MYSQL_CNF

                # Terminate script on error
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_weekendbonus.conf${COLOR_END}\n"

            # Copy the file before editing it
            cp $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf.dist $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf

            # Update mod_weekendbonus.conf with values specified in the options
            sed -i 's/WeekendBonus.Multiplier.Experience =.*/WeekendBonus.Multiplier.Experience = '$OPTION_MODULES_WEEKEND_BONUS_EXPERIENCE_MULTIPLIER'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
            sed -i 's/WeekendBonus.Multiplier.Money =.*/WeekendBonus.Multiplier.Money = '$OPTION_MODULES_WEEKEND_BONUS_MONEY_MULTIPLIER'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
            sed -i 's/WeekendBonus.Multiplier.Professions =.*/WeekendBonus.Multiplier.Professions = '$OPTION_MODULES_WEEKEND_BONUS_PROFESSIONS_MULTIPLIER'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
            sed -i 's/WeekendBonus.Multiplier.Reputation =.*/WeekendBonus.Multiplier.Reputation = '$OPTION_MODULES_WEEKEND_BONUS_REPUTATION_MULTIPLIER'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
            sed -i 's/WeekendBonus.Multiplier.Proficiencies =.*/WeekendBonus.Multiplier.Proficiencies = '$OPTION_MODULES_WEEKEND_BONUS_PROFICIENCIES_MULTIPLIER'/g' $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
        else
            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf.dist ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf.dist
            fi

            # Check if the config file exists
            if [ -f $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf ]; then
                # Remove the file since the module is disabled
                rm -rf $OPTION_SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
            fi
        fi
    fi

    printf "${COLOR_GREEN}Finished updating the config files...${COLOR_END}\n"
}

# A function that starts the compiled server
function start_server
{
    printf "${COLOR_GREEN}Starting the server...${COLOR_END}\n"

    # Check if the required binaries exist
    if [ ! -f $OPTION_SOURCE_LOCATION/bin/start.sh ] || [ ! -f $OPTION_SOURCE_LOCATION/bin/stop.sh ] || [ ! -f $OPTION_SOURCE_LOCATION/bin/authserver ] || [ ! -f $OPTION_SOURCE_LOCATION/bin/worldserver ]; then
        printf "${COLOR_RED}The required binaries are missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"

        # Terminate the script
        exit $?
    fi

    # Check if the process is already running
    if [[ ! -z `screen -list | grep -E "auth"` ]] || [[ ! -z `screen -list | grep -E "world"` ]]; then
        printf "${COLOR_RED}The server is already running.${COLOR_END}\n"

        # Terminate the script
        exit $?
    fi

    # Start the server
    cd $OPTION_SOURCE_LOCATION/bin && ./start.sh

    # Check of the authserver is running
    if [[ ! -z `screen -list | grep -E "auth"` ]]; then
        # Give some information about accessing the screen
        printf "${COLOR_ORANGE}To access the screen of the authserver, use the command ${COLOR_BLUE}screen -r auth${COLOR_ORANGE}.${COLOR_END}\n"
    fi

    # Check of the worldserver is running
    if [[ ! -z `screen -list | grep -E "world"` ]]; then
        # Give some information about accessing the screen
        printf "${COLOR_ORANGE}To access the screen of the worldserver, use the command ${COLOR_BLUE}screen -r world${COLOR_ORANGE}.${COLOR_END}\n"
    fi

    printf "${COLOR_GREEN}Finished starting the server...${COLOR_END}\n"
}

# A function that stops the running server
function stop_server
{
    printf "${COLOR_GREEN}Stopping the server...${COLOR_END}\n"

    # Check if the process is running
    if [[ -z `screen -list | grep -E "auth"` ]] && [[ -z `screen -list | grep -E "world"` ]]; then
        printf "${COLOR_RED}The server is not running.${COLOR_END}\n"
    fi

    # Check if the worldserver is running
    if [[ ! -z `screen -list | grep -E "world"` ]]; then
        printf "${COLOR_ORANGE}Telling the world server to save before shutting down.${COLOR_END}\n"

        # Send the saveall command to the worldserver
        screen -S world -p 0 -X stuff "saveall^m"

        # Sleep for 3 seconds to let the server save
        sleep 3
    fi

    # Check if the file exists
    if [ -f $OPTION_SOURCE_LOCATION/bin/stop.sh ]; then
        # Check if the server is running
        if [[ ! -z `screen -list | grep -E "auth"` ]] || [[ ! -z `screen -list | grep -E "world"` ]]; then
            # Stop the server
            cd $OPTION_SOURCE_LOCATION/bin && ./stop.sh
        fi
    fi

    printf "${COLOR_GREEN}Finished stopping the server...${COLOR_END}\n"
}

# A function that prints available parameters and subparameters when none are supplied or if they are invalid
function parameters
{
    printf "${COLOR_GREEN}Available parameters${COLOR_END}\n"
    printf "${COLOR_ORANGE}both           ${COLOR_WHITE}| ${COLOR_BLUE}Use chosen subparameters for the auth and worldserver${COLOR_END}\n"
    printf "${COLOR_ORANGE}auth           ${COLOR_WHITE}| ${COLOR_BLUE}Use chosen subparameters only for the authserver${COLOR_END}\n"
    printf "${COLOR_ORANGE}world          ${COLOR_WHITE}| ${COLOR_BLUE}Use chosen subparameters only for the worldserver${COLOR_END}\n"
    printf "${COLOR_ORANGE}start          ${COLOR_WHITE}| ${COLOR_BLUE}Starts the compiled processes, based off of the choice for compilation${COLOR_END}\n"
    printf "${COLOR_ORANGE}stop           ${COLOR_WHITE}| ${COLOR_BLUE}Stops the compiled processes, based off of the choice for compilation${COLOR_END}\n"
    printf "${COLOR_ORANGE}restart        ${COLOR_WHITE}| ${COLOR_BLUE}Stops and then starts the compiled processes, based off of the choice for compilation${COLOR_END}\n\n"

    printf "${COLOR_GREEN}Available subparameters${COLOR_END}\n"
    printf "${COLOR_ORANGE}install/update ${COLOR_WHITE}| ${COLOR_BLUE}Downloads the source code, with enabled modules, and compiles it. Also downloads client files${COLOR_END}\n"
    printf "${COLOR_ORANGE}database/db    ${COLOR_WHITE}| ${COLOR_BLUE}Imports all database files, including enabled modules, to the specified server${COLOR_END}\n"
    printf "${COLOR_ORANGE}config/conf    ${COLOR_WHITE}| ${COLOR_BLUE}Updates all config files, including enabled modules, with options specified${COLOR_END}\n"
    printf "${COLOR_ORANGE}all            ${COLOR_WHITE}| ${COLOR_BLUE}Run all subparameters listed above, including stop and start${COLOR_END}\n"

    exit $?
}

# Load all options from the file
load_options

# Check for provided parameters
if [ $# -gt 0 ]; then
    # Check the parameter
    if [[ $1 == "both" ]] || [[ $1 == "auth" ]] || [[ $1 == "world" ]]; then
        # Check the subparameter
        if [[ $2 == "install" ]] || [[ $2 == "update" ]]; then
            # Stop the enabled processes
            stop_server

            # Download the source code
            get_source $1

            # Compile the source code
            compile_source $1

            # Download the client data files
            get_client_files $1
        elif [[ $2 == "database" ]] || [[ $2 == "db" ]]; then
            # Import the database files
            import_database $1
        elif [[ $2 == "config" ]] || [[ $2 == "conf" ]]; then
            # Update the config files
            set_config $1
        elif [[ $2 == "all" ]]; then
            # Stop the enabled processes
            stop_server

            # Download the source code
            get_source $1

            # Compile the source code
            compile_source $1

            # Download the client data files
            get_client_files $1

            # Import the database files
            import_database $1

            # Update the config files
            set_config $1

            # Start the enabled processes
            start_server
        else
            # The provided subparameter is invalid
            parameters
        fi
    elif [[ $1 == "start" ]]; then
        # Start the enabled processes
        start_server
    elif [[ $1 == "stop" ]]; then
        # Stop the enabled processes
        stop_server
    elif [[ $1 == "restart" ]]; then
        # Stop the enabled processes
        stop_server

        # Start the enabled processes
        start_server
    else
        # The provided parameter is invalid
        parameters
    fi
else
    # No parameters provided
    parameters
fi
