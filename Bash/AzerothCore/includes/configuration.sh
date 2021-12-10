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
            <!-- The pull request to use. 0 = disabled -->
            <pull_request>${9:-0}</pull_request>
            <!-- The required client data version -->
            <required_client_data>${10:-12}</required_client_data>
            <!-- The installed client data version. WARNING: DO NOT EDIT! -->
            <installed_client_data>${11:-0}</installed_client_data>
        </core>
        <world>
            <!-- The name of the realm as seen in the list in-game -->
            <name>${12:-AzerothCore}</name>
            <!-- Message of the Day, displayed at login. Use '@' for a newline and be sure to escape special characters -->
            <motd>${13:-Welcome to AzerothCore.}</motd>
            <!-- The id of the realm -->
            <id>${14:-1}</id>
            <!-- The ip or hostname used to connect to the world server. Use external ip if required -->
            <address>${15:-127.0.0.1}</address>
            <!-- Server realm type. 0 = normal, 1 = pvp, 6 = rp, 8 = rppvp -->
            <game_type>${16:-0}</game_type>
            <!-- Server realm zone. Set allowed alphabet in character, etc. names. 1 = development, 2 = united states, 6 = korea, 9 = german, 10 = french, 11 = spanish, 12 = russian, 14 = taiwan, 16 = china, 26 = test server -->
            <realm_zone>${17:-1}</realm_zone>
            <!-- Allow server to use content from expansions. Checks for expansion-related map files, client compatibility and class/race character creation. 0 = none, 1 = tbc, 2 = wotlk -->
            <expansion>${18:-2}</expansion>
            <!-- Maximum number of players in the world. Excluding Mods, GMs and Admins -->
            <player_limit>${19:-1000}</player_limit>
            <!-- Disable cinematic intro at first login after character creation. Prevents buggy intros in case of custom start location coordinates. 0 = Show intro for each new character, 1 = Show intro only for first character of selected race, 2 = Disable intro for all classes -->
            <skip_cinematics>${20:-0}</skip_cinematics>
            <!-- Maximum level that can be reached by players. Levels below 1 and above 80 will reset to 80 -->
            <max_level>${21:-80}</max_level>
            <!-- Starting level for characters after creation. Levels below 1 and above 80 will reset to 1 -->
            <start_level>${22:-1}</start_level>
            <!-- Amount of money (in Copper) that a character has after creation -->
            <start_money>${23:-0}</start_money>
            <!-- Players will automatically gain max skill level when logging in or leveling up. false = disabled, true = enabled -->
            <always_max_skill>${24:-false}</always_max_skill>
            <!-- Character knows all flight paths (of both factions) after creation. false = disabled, true = enabled -->
            <all_flight_paths>${25:-false}</all_flight_paths>
            <!-- Characters start with all maps explored. false = disabled, true = enabled -->
            <maps_explored>${26:-false}</maps_explored>
            <!-- Allow players to use commands. false = disabled, true = enabled -->
            <allow_commands>${27:-true}</allow_commands>
            <!-- Allow non-raid quests to be completed while in a raid group. false = disabled, true = enabled -->
            <quest_ignore_raid>${28:-false}</quest_ignore_raid>
            <!-- Prevent players AFK from being logged out. false = disabled, true = enabled -->
            <prevent_afk_logout>${29:-false}</prevent_afk_logout>
            <!-- Highest level up to which a character can benefit from the Recruit-A-Friend experience multiplier -->
            <raf_max_level>${30:-60}</raf_max_level>
            <!-- Preload all grids on all non-instanced maps. This will take a great amount of additional RAM (ca. 9 GB) and causes the server to take longer to start, but can increase performance if used on a server with a high amount of players. It will also activate all creatures which are set active (e.g. the Fel Reavers in Hellfire Peninsula) on server start. false = disabled, true = enabled -->
            <preload_map_grids>${31:-false}</preload_map_grids>
            <!-- Set all creatures with waypoint movement active. This means that they will start movement once they are loaded (which happens on grid load) and keep moving even when no player is near. This will increase CPU usage significantly and can be used with enabled preload_map_grids to start waypoint movement on server startup. false = disabled, true = enabled -->
            <set_all_waypoints_active>${32:-false}</set_all_waypoints_active>
            <!-- Enable/Disable Minigob Manabonk in Dalaran. false = disabled, true = enabled -->
            <enable_minigob_manabonk>${33:-true}</enable_minigob_manabonk>
            <rates>
                <!-- Experience rates (outside battleground) -->
                <experience>${34:-1}</experience>
                <!-- Resting points grow rates -->
                <rested_exp>${35:-1}</rested_exp>
                <!-- Reputation gain rate -->
                <reputation>${36:-1}</reputation>
                <!-- Drop rates for money -->
                <money>${37:-1}</money>
                <!-- Crafting skills gain rate -->
                <crafting>${38:-1}</crafting>
                <!-- Gathering skills gain rate -->
                <gathering>${39:-1}</gathering>
                <!-- Weapon skills gain rate -->
                <weapon_skill>${40:-1}</weapon_skill>
                <!-- Defense skills gain rate -->
                <defense_skill>${41:-1}</defense_skill>
            </rates>
            <gm>
                <!-- Set GM state when a GM character enters the world. false = disabled, true = enabled -->
                <login_state>${42:-true}</login_state>
                <!-- GM visibility at login. false = disabled, true = enabled -->
                <enable_visibility>${43:-false}</enable_visibility>
                <!-- GM chat mode at login. false = disabled, true = enabled -->
                <enable_chat>${44:-true}</enable_chat>
                <!-- Is GM accepting whispers from player by default or not. false = disabled, true = enabled -->
                <enable_whisper>${45:-false}</enable_whisper>
                <!-- Maximum GM level shown in GM list (if enabled) in non-GM state. 0 = only players, 1 = only moderators, 2 = only gamemasters, 3 = anyone -->
                <show_gm_list>${46:-0}</show_gm_list>
                <!-- Max GM level showed in who list (if visible). 0 = only players, 1 = only moderators, 2 = only gamemasters, 3 = anyone -->
                <show_who_list>${47:-0}</show_who_list>
                <!-- Allow players to add GM characters to their friends list. false = disabled, true = enabled -->
                <allow_friend>${48:-false}</allow_friend>
                <!-- Allow players to invite GM characters. false = disabled, true = enabled -->
                <allow_invite>${49:-false}</allow_invite>
                <!-- Allow lower security levels to use commands on higher security level characters. false = disabled, true = enabled -->
                <allow_lower_security>${50:-false}</allow_lower_security>
            </gm>
        </world>
        <module>
            <ahbot>
                <!-- Enable/Disable the use of the AHBot module -->
                <enabled>${51:-false}</enabled>
                <!-- Enable/Disable the part of AHBot that buys items from players -->
                <enable_buyer>${52:-false}</enable_buyer>
                <!-- Enable/Disable the part of AHBot that puts items up for auction -->
                <enable_seller>${53:-false}</enable_seller>
                <!-- Account id is the account number (auth->account) of the player you want to run as the auction bot -->
                <account_id>${54:-0}</account_id>
                <!-- Character guid is the GUID (characters->characters table) of the player you want to run as the auction bot -->
                <character_guid>${55:-0}</character_guid>
                <!-- Minimum amount of items the bot will keep on the auction house -->
                <min_items>${56:-0}</min_items>
                <!-- Maximum amount of items the bot will keep on the auction house -->
                <max_items>${57:-0}</max_items>
            </ahbot>
            <activate_zones>
                <!-- Enable/Disable the use of the Activate Zones module -->
                <enabled>${58:-false}</enabled>
            </activate_zones>
            <assistant>
                <!-- Enable/Disable the use of the Assistant module -->
                <enabled>${59:-false}</enabled>
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
                <!-- Enable/Disable obtaining shaman totems from the assistant -->
                <totems>${69:-false}</totems>
            </assistant>
            <eluna>
                <!-- Enable/Disable the use of the Eluna LUA engine module -->
                <enabled>${70:-false}</enabled>
            </eluna>
            <learn_spells>
                <!-- Enable/Disable the use of the Learn Spells module -->
                <enabled>${71:-false}</enabled>
                <spells>
                    <!-- Enable/Disable obtaining spells when entering the world -->
                    <on_login>${72:-false}</on_login>
                    <!-- Enable/Disable obtaining spells when leveling up -->
                    <on_levelup>${73:-false}</on_levelup>
                    <!-- Enable/Disable obtaining class-specific spells when leveling up or entering the world -->
                    <class_spells>${74:-false}</class_spells>
                    <!-- Enable/Disable obtaining new talent ranks when leveling up or entering the world -->
                    <talent_ranks>${75:-false}</talent_ranks>
                    <!-- Enable/Disable obtaining new weapon and armor skills when leveling up -->
                    <proficiencies>${76:-false}</proficiencies>
                    <!-- Enable/Disable spells that are normally obtained through quests -->
                    <from_quests>${77:-false}</from_quests>
                    <max_skill>
                        <!-- Enable/Disable setting weapon skills to their max value when leveling up or entering the world -->
                        <enabled>${78:-false}</enabled>
                        <!-- The max level where weapon skills will be set to their max value -->
                        <max_level>${79:-60}</max_level>
                    </max_skill>
                    <riding>
                        <!-- Enable/Disable obtaining riding skills when leveling up or entering the world -->
                        <enabled>${80:-false}</enabled>
                        <!-- Enable/Disable obtaining the apprentice (75%) riding skill and mounts when leveling up or entering the world -->
                        <apprentice>${81:-false}</apprentice>
                        <!-- Enable/Disable obtaining the journeyman (150%) riding skill and mounts when leveling up or entering the world -->
                        <journeyman>${82:-false}</journeyman>
                        <!-- Enable/Disable obtaining the journeyman (225%) riding skill and mounts when leveling up or entering the world -->
                        <expert>${83:-false}</expert>
                        <!-- Enable/Disable obtaining the artisan (300%) riding skill and mounts when leveling up or entering the world -->
                        <artisan>${84:-false}</artisan>
                        <!-- Enable/Disable obtaining the cold weather flying skill (level 77) when leveling up or entering the world -->
                        <cold_weather>${85:-false}</cold_weather>
                    </riding>
                </spells>
            </learn_spells>
            <level_reward>
                <!-- Enable/Disable the use of the Level Reward module -->
                <enabled>${86:-false}</enabled>
                <!-- The amount of gold given at level 10 -->
                <level_10>${87:-5}</level_10>
                <!-- The amount of gold given at level 20 -->
                <level_20>${88:-15}</level_20>
                <!-- The amount of gold given at level 30 -->
                <level_30>${89:-30}</level_30>
                <!-- The amount of gold given at level 40 -->
                <level_40>${90:-45}</level_40>
                <!-- The amount of gold given at level 50 -->
                <level_50>${91:-60}</level_50>
                <!-- The amount of gold given at level 60 -->
                <level_60>${92:-80}</level_60>
                <!-- The amount of gold given at level 70 -->
                <level_70>${93:-125}</level_70>
                <!-- The amount of gold given at level 80 -->
                <level_80>${94:-250}</level_80>
            </level_reward>
            <recruit_a_friend>
                <!-- Enable/Disable the use of the Recruit A Friend module -->
                <enabled>${95:-false}</enabled>
                <!-- The amount of days that recruit a friend stays active. 0 = never expires -->
                <duration>${96:-90}</duration>
            </recruit_a_friend>
            <skip_dk_starting_area>
                <!-- Enable/Disable the use of the Skip DK Starting Area module -->
                <enabled>${97:-false}</enabled>
                <!-- The level that death knight starts at -->
                <starting_level>${98:-58}</starting_level>
            </skip_dk_starting_area>
            <spawn_points>
                <!-- Enable/Disable the use of the Spawn Points module -->
                <enabled>${99:-false}</enabled>
            </spawn_points>
            <weekend_bonus>
                <!-- Enable/Disable the use of the Weekend Bonus module -->
                <enabled>${100:-false}</enabled>
                <!-- The multiplier for experience on weekends -->
                <experience_multiplier>${101:-1}</experience_multiplier>
                <!-- The multiplier for reputation on weekends -->
                <reputation_multiplier>${102:-1}</reputation_multiplier>
            </weekend_bonus>
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
    $CORE_PULL_REQUEST \
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
    $MODULE_ACTIVATE_ZONES_ENABLED \
    $MODULE_ASSISTANT_ENABLED \
    $MODULE_ASSISTANT_HEIRLOOMS \
    $MODULE_ASSISTANT_GLYPHS \
    $MODULE_ASSISTANT_GEMS \
    $MODULE_ASSISTANT_CONTAINERS \
    $MODULE_ASSISTANT_UTILITIES_ENABLED \
    $MODULE_ASSISTANT_UTILITIES_NAME_CHANGE \
    $MODULE_ASSISTANT_UTILITIES_CUSTOMIZATION \
    $MODULE_ASSISTANT_UTILITIES_RACE_CHANGE \
    $MODULE_ASSISTANT_UTILITIES_FACTION_CHANGE \
    $MODULE_ASSISTANT_TOTEMS \
    $MODULE_ELUNA_ENABLED \
    $MODULE_LEARN_SPELLS_ENABLED \
    $MODULE_LEARN_SPELLS_ON_LOGIN \
    $MODULE_LEARN_SPELLS_ON_LEVELUP \
    $MODULE_LEARN_SPELLS_CLASS_SPELLS \
    $MODULE_LEARN_SPELLS_TALENT_RANKS \
    $MODULE_LEARN_SPELLS_PROFICIENCIES \
    $MODULE_LEARN_SPELLS_FROM_QUESTS \
    $MODULE_LEARN_SPELLS_MAX_SKILL_ENABLED \
    $MODULE_LEARN_SPELLS_MAX_SKILL_MAX_LEVEL \
    $MODULE_LEARN_SPELLS_RIDING_ENABLED \
    $MODULE_LEARN_SPELLS_RIDING_APPRENTICE \
    $MODULE_LEARN_SPELLS_RIDING_JOURNEYMAN \
    $MODULE_LEARN_SPELLS_RIDING_EXPERT \
    $MODULE_LEARN_SPELLS_RIDING_ARTISAN \
    $MODULE_LEARN_SPELLS_RIDING_COLD_WEATHER \
    $MODULE_LEVEL_REWARD_ENABLED \
    $MODULE_LEVEL_REWARD_LEVEL_10 \
    $MODULE_LEVEL_REWARD_LEVEL_20 \
    $MODULE_LEVEL_REWARD_LEVEL_30 \
    $MODULE_LEVEL_REWARD_LEVEL_40 \
    $MODULE_LEVEL_REWARD_LEVEL_50 \
    $MODULE_LEVEL_REWARD_LEVEL_60 \
    $MODULE_LEVEL_REWARD_LEVEL_70 \
    $MODULE_LEVEL_REWARD_LEVEL_80 \
    $MODULE_RECRUIT_A_FRIEND_ENABLED \
    $MODULE_RECRUIT_A_FRIEND_DURATION \
    $MODULE_SKIP_DK_STARTING_AREA_ENABLED \
    $MODULE_SKIP_DK_STARTING_AREA_LEVEL \
    $MODULE_SPAWN_POINTS_ENABLED \
    $MODULE_WEEKEND_BONUS_ENABLED \
    $MODULE_WEEKEND_BONUS_EXPERIENCE_MULTIPLIER \
    $MODULE_WEEKEND_BONUS_REPUTATION_MULTIPLIER
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
CORE_PULL_REQUEST="$(echo "cat /config/core/pull_request/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
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

MODULE_ACTIVATE_ZONES_ENABLED="$(echo "cat /config/module/activate_zones/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

MODULE_ASSISTANT_ENABLED="$(echo "cat /config/module/assistant/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_ASSISTANT_HEIRLOOMS="$(echo "cat /config/module/assistant/heirlooms/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_ASSISTANT_GLYPHS="$(echo "cat /config/module/assistant/glyphs/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_ASSISTANT_GEMS="$(echo "cat /config/module/assistant/gems/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_ASSISTANT_CONTAINERS="$(echo "cat /config/module/assistant/containers/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_ASSISTANT_UTILITIES_ENABLED="$(echo "cat /config/module/assistant/utilities/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_ASSISTANT_UTILITIES_NAME_CHANGE="$(echo "cat /config/module/assistant/utilities/name_change/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_ASSISTANT_UTILITIES_CUSTOMIZATION="$(echo "cat /config/module/assistant/utilities/customization/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_ASSISTANT_UTILITIES_RACE_CHANGE="$(echo "cat /config/module/assistant/utilities/race_change/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_ASSISTANT_UTILITIES_FACTION_CHANGE="$(echo "cat /config/module/assistant/utilities/faction_change/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_ASSISTANT_TOTEMS="$(echo "cat /config/module/assistant/totems/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

MODULE_ELUNA_ENABLED="$(echo "cat /config/module/eluna/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

MODULE_LEARN_SPELLS_ENABLED="$(echo "cat /config/module/learn_spells/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_ON_LOGIN="$(echo "cat /config/module/learn_spells/spells/on_login/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_ON_LEVELUP="$(echo "cat /config/module/learn_spells/spells/on_levelup/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_CLASS_SPELLS="$(echo "cat /config/module/learn_spells/spells/class_spells/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_TALENT_RANKS="$(echo "cat /config/module/learn_spells/spells/talent_ranks/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_PROFICIENCIES="$(echo "cat /config/module/learn_spells/spells/proficiencies/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_FROM_QUESTS="$(echo "cat /config/module/learn_spells/spells/from_quests/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_MAX_SKILL_ENABLED="$(echo "cat /config/module/learn_spells/spells/max_skill/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_MAX_SKILL_MAX_LEVEL="$(echo "cat /config/module/learn_spells/spells/max_skill/max_level/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_RIDING_ENABLED="$(echo "cat /config/module/learn_spells/spells/riding/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_RIDING_APPRENTICE="$(echo "cat /config/module/learn_spells/spells/riding/apprentice/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_RIDING_JOURNEYMAN="$(echo "cat /config/module/learn_spells/spells/riding/journeyman/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_RIDING_EXPERT="$(echo "cat /config/module/learn_spells/spells/riding/expert/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_RIDING_ARTISAN="$(echo "cat /config/module/learn_spells/spells/riding/artisan/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEARN_SPELLS_RIDING_COLD_WEATHER="$(echo "cat /config/module/learn_spells/spells/riding/cold_weather/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

MODULE_LEVEL_REWARD_ENABLED="$(echo "cat /config/module/level_reward/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEVEL_REWARD_LEVEL_10="$(echo "cat /config/module/level_reward/level_10/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEVEL_REWARD_LEVEL_20="$(echo "cat /config/module/level_reward/level_20/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEVEL_REWARD_LEVEL_30="$(echo "cat /config/module/level_reward/level_30/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEVEL_REWARD_LEVEL_40="$(echo "cat /config/module/level_reward/level_40/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEVEL_REWARD_LEVEL_50="$(echo "cat /config/module/level_reward/level_50/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEVEL_REWARD_LEVEL_60="$(echo "cat /config/module/level_reward/level_60/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEVEL_REWARD_LEVEL_70="$(echo "cat /config/module/level_reward/level_70/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_LEVEL_REWARD_LEVEL_80="$(echo "cat /config/module/level_reward/level_80/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

MODULE_RECRUIT_A_FRIEND_ENABLED="$(echo "cat /config/module/recruit_a_friend/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_RECRUIT_A_FRIEND_DURATION="$(echo "cat /config/module/recruit_a_friend/duration/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

MODULE_SKIP_DK_STARTING_AREA_ENABLED="$(echo "cat /config/module/skip_dk_starting_area/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_SKIP_DK_STARTING_AREA_LEVEL="$(echo "cat /config/module/skip_dk_starting_area/starting_level/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

MODULE_SPAWN_POINTS_ENABLED="$(echo "cat /config/module/spawn_points/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

MODULE_WEEKEND_BONUS_ENABLED="$(echo "cat /config/module/weekend_bonus/enabled/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_WEEKEND_BONUS_EXPERIENCE_MULTIPLIER="$(echo "cat /config/module/weekend_bonus/experience_multiplier/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MODULE_WEEKEND_BONUS_REPUTATION_MULTIPLIER="$(echo "cat /config/module/weekend_bonus/reputation_multiplier/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

if [[ -z $MYSQL_HOSTNAME ]] || [[ $MYSQL_HOSTNAME == "" ]]; then
    MYSQL_HOSTNAME="127.0.0.1"
    REQUIRE_EXPORT=true
fi

if [[ ! $MYSQL_PORT =~ ^[0-9]+$ ]]; then
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
    MYSQL_DATABASE_CHARACTERS="acore_characters"
    REQUIRE_EXPORT=true
fi

if [[ -z $MYSQL_DATABASE_WORLD ]] || [[ $MYSQL_DATABASE_WORLD == "" ]]; then
    MYSQL_DATABASE_WORLD="acore_world"
    REQUIRE_EXPORT=true
fi

if [[ -z $CORE_DIRECTORY ]] || [[ $CORE_DIRECTORY == "" ]]; then
    CORE_DIRECTORY="/opt/azerothcore"
    REQUIRE_EXPORT=true
fi

if [[ ! $CORE_PULL_REQUEST =~ ^[0-9]+$ ]]; then
    CORE_PULL_REQUEST="0"
    REQUIRE_EXPORT=true
fi

if [[ ! $CORE_REQUIRED_CLIENT_DATA =~ ^[0-9]+$ ]]; then
    CORE_REQUIRED_CLIENT_DATA="12"
    REQUIRE_EXPORT=true
fi

if [[ ! $CORE_INSTALLED_CLIENT_DATA =~ ^[0-9]+$ ]] || [[ $CORE_INSTALLED_CLIENT_DATA -gt $CORE_REQUIRED_CLIENT_DATA ]]; then
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

if [[ ! $WORLD_ID =~ ^[0-9]+$ ]] || [[ $WORLD_ID < 1 ]]; then
    WORLD_ID="1"
    REQUIRE_EXPORT=true
fi

if [[ -z $WORLD_ADDRESS ]] || [[ $WORLD_ADDRESS == "" ]]; then
    WORLD_ADDRESS="127.0.0.1"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_GAME_TYPE =~ ^[0-9]+$ ]] || [[ $WORLD_GAME_TYPE != 0 && $WORLD_GAME_TYPE != 1 && $WORLD_GAME_TYPE != 6 && $WORLD_GAME_TYPE != 8 ]]; then
    WORLD_GAME_TYPE="0"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_REALM_ZONE =~ ^[0-9]+$ ]] || [[ $WORLD_REALM_ZONE != 1 && $WORLD_REALM_ZONE != 2 && $WORLD_REALM_ZONE != 6 && $WORLD_REALM_ZONE != 9 && $WORLD_REALM_ZONE != 10 && $WORLD_REALM_ZONE != 11 && $WORLD_REALM_ZONE != 12 && $WORLD_REALM_ZONE != 14 && $WORLD_REALM_ZONE != 16 && $WORLD_REALM_ZONE != 26 ]]; then
    WORLD_REALM_ZONE="1"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_EXPANSION =~ ^[0-9]+$ ]] || [[ $WORLD_EXPANSION != 0 && $WORLD_EXPANSION != 1 && $WORLD_EXPANSION != 2 ]]; then
    WORLD_EXPANSION="2"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_PLAYER_LIMIT =~ ^[0-9]+$ ]]; then
    WORLD_PLAYER_LIMIT="1000"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_SKIP_CINEMATICS =~ ^[0-9]+$ ]] || [[ $WORLD_SKIP_CINEMATICS != 0 && $WORLD_SKIP_CINEMATICS != 1 && $WORLD_SKIP_CINEMATICS != 2 ]]; then
    WORLD_SKIP_CINEMATICS="0"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_MAX_LEVEL =~ ^[0-9]+$ ]] || [[ $WORLD_MAX_LEVEL < 1 || $WORLD_MAX_LEVEL > 80 ]]; then
    WORLD_MAX_LEVEL="80"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_START_LEVEL =~ ^[0-9]+$ ]] || [[ $WORLD_START_LEVEL < 1 || $WORLD_START_LEVEL > 80 ]]; then
    WORLD_START_LEVEL="1"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_START_MONEY =~ ^[0-9]+$ ]]; then
    WORLD_START_MONEY="0"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_ALWAYS_MAX_SKILL != "true" && $WORLD_ALWAYS_MAX_SKILL != "false" ]]; then
    WORLD_ALWAYS_MAX_SKILL="false"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_ALL_FLIGHT_PATHS != "true" && $WORLD_ALL_FLIGHT_PATHS != "false" ]]; then
    WORLD_ALL_FLIGHT_PATHS="false"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_MAPS_EXPLORED != "true" && $WORLD_MAPS_EXPLORED != "false" ]]; then
    WORLD_MAPS_EXPLORED="false"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_ALLOW_COMMANDS != "true" && $WORLD_ALLOW_COMMANDS != "false" ]]; then
    WORLD_ALLOW_COMMANDS="true"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_QUEST_IGNORE_RAID != "true" && $WORLD_QUEST_IGNORE_RAID != "false" ]]; then
    WORLD_QUEST_IGNORE_RAID="false"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_PREVENT_AFK_LOGOUT != "true" && $WORLD_PREVENT_AFK_LOGOUT != "false" ]]; then
    WORLD_PREVENT_AFK_LOGOUT="false"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_RAF_MAX_LEVEL =~ ^[0-9]+$ ]] || [[ $WORLD_RAF_MAX_LEVEL < 1 || $WORLD_RAF_MAX_LEVEL > 80 ]]; then
    WORLD_RAF_MAX_LEVEL="60"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_PRELOAD_MAP_GRIDS != "true" && $WORLD_PRELOAD_MAP_GRIDS != "false" ]]; then
    WORLD_PRELOAD_MAP_GRIDS="false"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_SET_WAYPOINTS_ACTIVE != "true" && $WORLD_SET_WAYPOINTS_ACTIVE != "false" ]]; then
    WORLD_SET_WAYPOINTS_ACTIVE="false"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_ENABLE_MINIGOB_MANABONK != "true" && $WORLD_ENABLE_MINIGOB_MANABONK != "false" ]]; then
    WORLD_ENABLE_MINIGOB_MANABONK="true"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_RATE_EXPERIENCE =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_EXPERIENCE < 1 ]]; then
    WORLD_RATE_EXPERIENCE="1"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_RATE_RESTED_EXP =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_RESTED_EXP < 1 ]]; then
    WORLD_RATE_RESTED_EXP="1"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_RATE_REPUTATION =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_REPUTATION < 1 ]]; then
    WORLD_RATE_REPUTATION="1"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_RATE_MONEY =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_MONEY < 1 ]]; then
    WORLD_RATE_MONEY="1"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_RATE_CRAFTING =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_CRAFTING < 1 ]]; then
    WORLD_RATE_CRAFTING="1"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_RATE_GATHERING =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_GATHERING < 1 ]]; then
    WORLD_RATE_GATHERING="1"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_RATE_WEAPON_SKILL =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_WEAPON_SKILL < 1 ]]; then
    WORLD_RATE_WEAPON_SKILL="1"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_RATE_DEFENSE_SKILL =~ ^[0-9]+$ ]] || [[ $WORLD_RATE_DEFENSE_SKILL < 1 ]]; then
    WORLD_RATE_DEFENSE_SKILL="1"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_GM_LOGIN_STATE != "true" && $WORLD_GM_LOGIN_STATE != "false" ]]; then
    WORLD_GM_LOGIN_STATE="true"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_GM_ENABLE_VISIBILITY != "true" && $WORLD_GM_ENABLE_VISIBILITY != "false" ]]; then
    WORLD_GM_ENABLE_VISIBILITY="false"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_GM_ENABLE_CHAT != "true" && $WORLD_GM_ENABLE_CHAT != "false" ]]; then
    WORLD_GM_ENABLE_CHAT="true"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_GM_ENABLE_WHISPER != "true" && $WORLD_GM_ENABLE_WHISPER != "false" ]]; then
    WORLD_GM_ENABLE_WHISPER="false"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_GM_SHOW_GM_LIST =~ ^[0-9]+$ ]] || [[ $WORLD_GM_SHOW_GM_LIST != 0 && $WORLD_GM_SHOW_GM_LIST != 1 && $WORLD_GM_SHOW_GM_LIST != 2 && $WORLD_GM_SHOW_GM_LIST != 3 ]]; then
    WORLD_GM_SHOW_GM_LIST="0"
    REQUIRE_EXPORT=true
fi

if [[ ! $WORLD_GM_SHOW_WHO_LIST =~ ^[0-9]+$ ]] || [[ $WORLD_GM_SHOW_WHO_LIST != 0 && $WORLD_GM_SHOW_WHO_LIST != 1 && $WORLD_GM_SHOW_WHO_LIST != 2 && $WORLD_GM_SHOW_WHO_LIST != 3 ]]; then
    WORLD_GM_SHOW_WHO_LIST="0"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_GM_ALLOW_FRIEND != "true" && $WORLD_GM_ALLOW_FRIEND != "false" ]]; then
    WORLD_GM_ALLOW_FRIEND="false"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_GM_ALLOW_INVITE != "true" && $WORLD_GM_ALLOW_INVITE != "false" ]]; then
    WORLD_GM_ALLOW_INVITE="false"
    REQUIRE_EXPORT=true
fi

if [[ $WORLD_GM_ALLOW_LOWER_SECURITY != "true" && $WORLD_GM_ALLOW_LOWER_SECURITY != "false" ]]; then
    WORLD_GM_ALLOW_LOWER_SECURITY="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_AHBOT_ENABLED != "true" && $MODULE_AHBOT_ENABLED != "false" ]]; then
    MODULE_AHBOT_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_AHBOT_ENABLE_BUYER != "true" && $MODULE_AHBOT_ENABLE_BUYER != "false" ]]; then
    MODULE_AHBOT_ENABLE_BUYER="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_AHBOT_ENABLE_SELLER != "true" && $MODULE_AHBOT_ENABLE_SELLER != "false" ]]; then
    MODULE_AHBOT_ENABLE_SELLER="false"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_AHBOT_ACCOUNT_ID =~ ^[0-9]+$ ]]; then
    MODULE_AHBOT_ACCOUNT_ID="0"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_AHBOT_CHARACTER_GUID =~ ^[0-9]+$ ]]; then
    MODULE_AHBOT_CHARACTER_GUID="0"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_AHBOT_MIN_ITEMS =~ ^[0-9]+$ ]]; then
    MODULE_AHBOT_MIN_ITEMS="0"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_AHBOT_MAX_ITEMS =~ ^[0-9]+$ ]]; then
    MODULE_AHBOT_MAX_ITEMS="0"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_ACTIVATE_ZONES_ENABLED != "true" && $MODULE_ACTIVATE_ZONES_ENABLED != "false" ]]; then
    MODULE_ACTIVATE_ZONES_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_ASSISTANT_ENABLED != "true" && $MODULE_ASSISTANT_ENABLED != "false" ]]; then
    MODULE_ASSISTANT_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_ASSISTANT_HEIRLOOMS != "true" && $MODULE_ASSISTANT_HEIRLOOMS != "false" ]]; then
    MODULE_ASSISTANT_HEIRLOOMS="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_ASSISTANT_GLYPHS != "true" && $MODULE_ASSISTANT_GLYPHS != "false" ]]; then
    MODULE_ASSISTANT_GLYPHS="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_ASSISTANT_GEMS != "true" && $MODULE_ASSISTANT_GEMS != "false" ]]; then
    MODULE_ASSISTANT_GEMS="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_ASSISTANT_CONTAINERS != "true" && $MODULE_ASSISTANT_CONTAINERS != "false" ]]; then
    MODULE_ASSISTANT_CONTAINERS="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_ASSISTANT_UTILITIES_ENABLED != "true" && $MODULE_ASSISTANT_UTILITIES_ENABLED != "false" ]]; then
    MODULE_ASSISTANT_UTILITIES_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_ASSISTANT_UTILITIES_NAME_CHANGE =~ ^[0-9]+$ ]] || [[ $MODULE_ASSISTANT_UTILITIES_NAME_CHANGE < 1 ]]; then
    MODULE_ASSISTANT_UTILITIES_NAME_CHANGE="10"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_ASSISTANT_UTILITIES_CUSTOMIZATION =~ ^[0-9]+$ ]] || [[ $MODULE_ASSISTANT_UTILITIES_CUSTOMIZATION < 1 ]]; then
    MODULE_ASSISTANT_UTILITIES_CUSTOMIZATION="10"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_ASSISTANT_UTILITIES_RACE_CHANGE =~ ^[0-9]+$ ]] || [[ $MODULE_ASSISTANT_UTILITIES_RACE_CHANGE < 1 ]]; then
    MODULE_ASSISTANT_UTILITIES_RACE_CHANGE="10"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_ASSISTANT_UTILITIES_FACTION_CHANGE =~ ^[0-9]+$ ]] || [[ $MODULE_ASSISTANT_UTILITIES_FACTION_CHANGE < 1 ]]; then
    MODULE_ASSISTANT_UTILITIES_FACTION_CHANGE="10"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_ASSISTANT_TOTEMS != "true" && $MODULE_ASSISTANT_TOTEMS != "false" ]]; then
    MODULE_ASSISTANT_TOTEMS="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_ELUNA_ENABLED != "true" && $MODULE_ELUNA_ENABLED != "false" ]]; then
    MODULE_ELUNA_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_ENABLED != "true" && $MODULE_LEARN_SPELLS_ENABLED != "false" ]]; then
    MODULE_LEARN_SPELLS_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_ON_LOGIN != "true" && $MODULE_LEARN_SPELLS_ON_LOGIN != "false" ]]; then
    MODULE_LEARN_SPELLS_ON_LOGIN="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_ON_LEVELUP != "true" && $MODULE_LEARN_SPELLS_ON_LEVELUP != "false" ]]; then
    MODULE_LEARN_SPELLS_ON_LEVELUP="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_CLASS_SPELLS != "true" && $MODULE_LEARN_SPELLS_CLASS_SPELLS != "false" ]]; then
    MODULE_LEARN_SPELLS_CLASS_SPELLS="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_TALENT_RANKS != "true" && $MODULE_LEARN_SPELLS_TALENT_RANKS != "false" ]]; then
    MODULE_LEARN_SPELLS_TALENT_RANKS="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_PROFICIENCIES != "true" && $MODULE_LEARN_SPELLS_PROFICIENCIES != "false" ]]; then
    MODULE_LEARN_SPELLS_PROFICIENCIES="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_FROM_QUESTS != "true" && $MODULE_LEARN_SPELLS_FROM_QUESTS != "false" ]]; then
    MODULE_LEARN_SPELLS_FROM_QUESTS="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_MAX_SKILL_ENABLED != "true" && $MODULE_LEARN_SPELLS_MAX_SKILL_ENABLED != "false" ]]; then
    MODULE_LEARN_SPELLS_MAX_SKILL_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_LEARN_SPELLS_MAX_SKILL_MAX_LEVEL =~ ^[0-9]+$ ]] || [[ $MODULE_LEARN_SPELLS_MAX_SKILL_MAX_LEVEL < 1 || $MODULE_LEARN_SPELLS_MAX_SKILL_MAX_LEVEL > 80 ]]; then
    MODULE_LEARN_SPELLS_MAX_SKILL_MAX_LEVEL="60"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_RIDING_ENABLED != "true" && $MODULE_LEARN_SPELLS_RIDING_ENABLED != "false" ]]; then
    MODULE_LEARN_SPELLS_RIDING_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_RIDING_APPRENTICE != "true" && $MODULE_LEARN_SPELLS_RIDING_APPRENTICE != "false" ]]; then
    MODULE_LEARN_SPELLS_RIDING_APPRENTICE="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_RIDING_JOURNEYMAN != "true" && $MODULE_LEARN_SPELLS_RIDING_JOURNEYMAN != "false" ]]; then
    MODULE_LEARN_SPELLS_RIDING_JOURNEYMAN="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_RIDING_EXPERT != "true" && $MODULE_LEARN_SPELLS_RIDING_EXPERT != "false" ]]; then
    MODULE_LEARN_SPELLS_RIDING_EXPERT="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_RIDING_ARTISAN != "true" && $MODULE_LEARN_SPELLS_RIDING_ARTISAN != "false" ]]; then
    MODULE_LEARN_SPELLS_RIDING_ARTISAN="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEARN_SPELLS_RIDING_COLD_WEATHER != "true" && $MODULE_LEARN_SPELLS_RIDING_COLD_WEATHER != "false" ]]; then
    MODULE_LEARN_SPELLS_RIDING_COLD_WEATHER="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_LEVEL_REWARD_ENABLED != "true" && $MODULE_LEVEL_REWARD_ENABLED != "false" ]]; then
    MODULE_LEVEL_REWARD_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_LEVEL_REWARD_LEVEL_10 =~ ^[0-9]+$ ]] || [[ $MODULE_LEVEL_REWARD_LEVEL_10 < 1 ]]; then
    MODULE_LEVEL_REWARD_LEVEL_10="5"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_LEVEL_REWARD_LEVEL_20 =~ ^[0-9]+$ ]] || [[ $MODULE_LEVEL_REWARD_LEVEL_20 < 1 ]]; then
    MODULE_LEVEL_REWARD_LEVEL_20="15"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_LEVEL_REWARD_LEVEL_30 =~ ^[0-9]+$ ]] || [[ $MODULE_LEVEL_REWARD_LEVEL_30 < 1 ]]; then
    MODULE_LEVEL_REWARD_LEVEL_30="30"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_LEVEL_REWARD_LEVEL_40 =~ ^[0-9]+$ ]] || [[ $MODULE_LEVEL_REWARD_LEVEL_40 < 1 ]]; then
    MODULE_LEVEL_REWARD_LEVEL_40="45"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_LEVEL_REWARD_LEVEL_50 =~ ^[0-9]+$ ]] || [[ $MODULE_LEVEL_REWARD_LEVEL_50 < 1 ]]; then
    MODULE_LEVEL_REWARD_LEVEL_50="60"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_LEVEL_REWARD_LEVEL_60 =~ ^[0-9]+$ ]] || [[ $MODULE_LEVEL_REWARD_LEVEL_60 < 1 ]]; then
    MODULE_LEVEL_REWARD_LEVEL_60="80"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_LEVEL_REWARD_LEVEL_70 =~ ^[0-9]+$ ]] || [[ $MODULE_LEVEL_REWARD_LEVEL_70 < 1 ]]; then
    MODULE_LEVEL_REWARD_LEVEL_70="125"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_LEVEL_REWARD_LEVEL_80 =~ ^[0-9]+$ ]] || [[ $MODULE_LEVEL_REWARD_LEVEL_80 < 1 ]]; then
    MODULE_LEVEL_REWARD_LEVEL_80="250"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_RECRUIT_A_FRIEND_ENABLED != "true" && $MODULE_RECRUIT_A_FRIEND_ENABLED != "false" ]]; then
    MODULE_RECRUIT_A_FRIEND_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_RECRUIT_A_FRIEND_DURATION =~ ^[0-9]+$ ]]; then
    MODULE_RECRUIT_A_FRIEND_DURATION="90"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_SKIP_DK_STARTING_AREA_ENABLED != "true" && $MODULE_SKIP_DK_STARTING_AREA_ENABLED != "false" ]]; then
    MODULE_SKIP_DK_STARTING_AREA_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_SKIP_DK_STARTING_AREA_LEVEL =~ ^[0-9]+$ ]] || [[ $MODULE_SKIP_DK_STARTING_AREA_LEVEL < 1 || $MODULE_SKIP_DK_STARTING_AREA_LEVEL > 80 ]]; then
    MODULE_SKIP_DK_STARTING_AREA_LEVEL="58"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_SPAWN_POINTS_ENABLED != "true" && $MODULE_SPAWN_POINTS_ENABLED != "false" ]]; then
    MODULE_SPAWN_POINTS_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ $MODULE_WEEKEND_BONUS_ENABLED != "true" && $MODULE_WEEKEND_BONUS_ENABLED != "false" ]]; then
    MODULE_WEEKEND_BONUS_ENABLED="false"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_WEEKEND_BONUS_EXPERIENCE_MULTIPLIER =~ ^[0-9]+$ ]] || [[ $MODULE_WEEKEND_BONUS_EXPERIENCE_MULTIPLIER < 1 ]]; then
    MODULE_WEEKEND_BONUS_EXPERIENCE_MULTIPLIER="1"
    REQUIRE_EXPORT=true
fi

if [[ ! $MODULE_WEEKEND_BONUS_REPUTATION_MULTIPLIER =~ ^[0-9]+$ ]] || [[ $MODULE_WEEKEND_BONUS_REPUTATION_MULTIPLIER < 1 ]]; then
    MODULE_WEEKEND_BONUS_REPUTATION_MULTIPLIER="1"
    REQUIRE_EXPORT=true
fi

if [ $REQUIRE_EXPORT ]; then
    printf "${COLOR_ORANGE}Invalid settings have been reset to their default values${COLOR_END}\n"
    export_settings
    exit 1
else
    printf "${COLOR_ORANGE}Successfully loaded all settings${COLOR_END}\n"
fi

function update_configuration
{
    clear

    printf "${COLOR_GREEN}Updating configuration files${COLOR_END}\n"

    if [[ $1 == 0 || $1 == 1 ]]; then
        if [ -f $CORE_DIRECTORY/etc/authserver.conf.dist ]; then
            printf "${COLOR_ORANGE}Updating authserver.conf${COLOR_END}\n"

            cp $CORE_DIRECTORY/etc/authserver.conf.dist $CORE_DIRECTORY/etc/authserver.conf

            sed -i 's/LoginDatabaseInfo =.*/LoginDatabaseInfo = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASE_AUTH'"/g' $CORE_DIRECTORY/etc/authserver.conf
            sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 0/g' $CORE_DIRECTORY/etc/authserver.conf
        fi
    fi

    if [[ $1 == 0 || $1 == 2 ]]; then
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

    if [[ $1 == 0 || $1 == 2 ]]; then
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

    if [[ $1 == 0 || $1 == 2 ]]; then
        if [ $MODULE_ASSISTANT_ENABLED == "true" ]; then
            if [ -f $CORE_DIRECTORY/etc/modules/Assistant.conf.dist ]; then
                printf "${COLOR_ORANGE}Updating Assistant.conf${COLOR_END}\n"

                cp $CORE_DIRECTORY/etc/modules/Assistant.conf.dist $CORE_DIRECTORY/etc/modules/Assistant.conf

                [ $MODULE_ASSISTANT_HEIRLOOMS == "true" ] && ENABLE_HEIRLOOM=1 || ENABLE_HEIRLOOM=0
                [ $MODULE_ASSISTANT_GLYPHS == "true" ] && ENABLE_GLYPHS=1 || ENABLE_GLYPHS=0
                [ $MODULE_ASSISTANT_GEMS == "true" ] && ENABLE_GEMS=1 || ENABLE_GEMS=0
                [ $MODULE_ASSISTANT_CONTAINERS == "true" ] && ENABLE_CONTAINERS=1 || ENABLE_CONTAINERS=0
                [ $MODULE_ASSISTANT_UTILITIES_ENABLED == "true" ] && ENABLE_UTILITIES=1 || ENABLE_UTILITIES=0
                [ $MODULE_ASSISTANT_TOTEMS == "true" ] && ENABLE_TOTEMS=1 || ENABLE_TOTEMS=0

                sed -i 's/Assistant.Heirlooms =.*/Assistant.Heirlooms = '$ENABLE_HEIRLOOM'/g' $CORE_DIRECTORY/etc/modules/Assistant.conf
                sed -i 's/Assistant.Glyphs =.*/Assistant.Glyphs = '$ENABLE_GLYPHS'/g' $CORE_DIRECTORY/etc/modules/Assistant.conf
                sed -i 's/Assistant.Gems =.*/Assistant.Gems = '$ENABLE_GEMS'/g' $CORE_DIRECTORY/etc/modules/Assistant.conf
                sed -i 's/Assistant.Containers =.*/Assistant.Containers = '$ENABLE_CONTAINERS'/g' $CORE_DIRECTORY/etc/modules/Assistant.conf
                sed -i 's/Assistant.Utilities =.*/Assistant.Utilities = '$ENABLE_UTILITIES'/g' $CORE_DIRECTORY/etc/modules/Assistant.conf
                sed -i 's/Assistant.Utilities.NameChange =.*/Assistant.Utilities.NameChange = '$MODULE_ASSISTANT_UTILITIES_NAME_CHANGE'/g' $CORE_DIRECTORY/etc/modules/Assistant.conf
                sed -i 's/Assistant.Utilities.Customization =.*/Assistant.Utilities.Customization = '$MODULE_ASSISTANT_UTILITIES_CUSTOMIZATION'/g' $CORE_DIRECTORY/etc/modules/Assistant.conf
                sed -i 's/Assistant.Utilities.RaceChange =.*/Assistant.Utilities.RaceChange = '$MODULE_ASSISTANT_UTILITIES_RACE_CHANGE'/g' $CORE_DIRECTORY/etc/modules/Assistant.conf
                sed -i 's/Assistant.Utilities.FactionChange =.*/Assistant.Utilities.FactionChange = '$MODULE_ASSISTANT_UTILITIES_FACTION_CHANGE'/g' $CORE_DIRECTORY/etc/modules/Assistant.conf
                sed -i 's/Assistant.Totems =.*/Assistant.Totems = '$ENABLE_TOTEMS'/g' $CORE_DIRECTORY/etc/modules/Assistant.conf
            fi
        else
            if [ -f $CORE_DIRECTORY/etc/modules/Assistant.conf ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/Assistant.conf
            fi

            if [ -f $CORE_DIRECTORY/etc/modules/Assistant.conf.dist ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/Assistant.conf.dist
            fi
        fi
    fi

    if [[ $1 == 0 || $1 == 2 ]]; then
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

    if [[ $1 == 0 || $1 == 2 ]]; then
        if [ $MODULE_LEARN_SPELLS_ENABLED == "true" ]; then
            if [ -f $CORE_DIRECTORY/etc/modules/LearnSpells.conf.dist ]; then
                printf "${COLOR_ORANGE}Updating LearnSpells.conf${COLOR_END}\n"

                cp $CORE_DIRECTORY/etc/modules/LearnSpells.conf.dist $CORE_DIRECTORY/etc/modules/LearnSpells.conf

                [ $MODULE_LEARN_SPELLS_ON_LOGIN == "true" ] && ENABLE_ON_LOGIN=1 || ENABLE_ON_LOGIN=0
                [ $MODULE_LEARN_SPELLS_ON_LEVELUP == "true" ] && ENABLE_ON_LEVELUP=1 || ENABLE_ON_LEVELUP=0
                [ $MODULE_LEARN_SPELLS_CLASS_SPELLS == "true" ] && ENABLE_CLASS_SPELLS=1 || ENABLE_CLASS_SPELLS=0
                [ $MODULE_LEARN_SPELLS_TALENT_RANKS == "true" ] && ENABLE_TALENT_RANKS=1 || ENABLE_TALENT_RANKS=0
                [ $MODULE_LEARN_SPELLS_PROFICIENCIES == "true" ] && ENABLE_PROFICIENCIES=1 || ENABLE_PROFICIENCIES=0
                [ $MODULE_LEARN_SPELLS_FROM_QUESTS == "true" ] && ENABLE_FROM_QUESTS=1 || ENABLE_FROM_QUESTS=0
                [ $MODULE_LEARN_SPELLS_MAX_SKILL_ENABLED == "true" ] && ENABLE_MAX_SKILL=1 || ENABLE_MAX_SKILL=0
                [ $MODULE_LEARN_SPELLS_RIDING_ENABLED == "true" ] && ENABLE_RIDING=1 || ENABLE_RIDING=0
                [ $MODULE_LEARN_SPELLS_RIDING_APPRENTICE == "true" ] && ENABLE_APPRENTICE_RIDING=1 || ENABLE_APPRENTICE_RIDING=0
                [ $MODULE_LEARN_SPELLS_RIDING_JOURNEYMAN == "true" ] && ENABLE_JOURNEYMAN_RIDING=1 || ENABLE_JOURNEYMAN_RIDING=0
                [ $MODULE_LEARN_SPELLS_RIDING_EXPERT == "true" ] && ENABLE_EXPERT_RIDING=1 || ENABLE_EXPERT_RIDING=0
                [ $MODULE_LEARN_SPELLS_RIDING_ARTISAN == "true" ] && ENABLE_ARTISAN_RIDING=1 || ENABLE_ARTISAN_RIDING=0
                [ $MODULE_LEARN_SPELLS_RIDING_COLD_WEATHER == "true" ] && ENABLE_COLD_WEATHER_RIDING=1 || ENABLE_COLD_WEATHER_RIDING=0

                sed -i 's/OnLogin.Enabled =.*/OnLogin.Enabled = '$ENABLE_ON_LOGIN'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/OnLevelUp.Enabled =.*/OnLevelUp.Enabled = '$ENABLE_ON_LEVELUP'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/ClassSpells.Enabled =.*/ClassSpells.Enabled = '$ENABLE_CLASS_SPELLS'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/TalentRanks.Enabled =.*/TalentRanks.Enabled = '$ENABLE_TALENT_RANKS'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/Proficiencies.Enabled =.*/Proficiencies.Enabled = '$ENABLE_PROFICIENCIES'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/SpellsFromQuests.Enabled =.*/SpellsFromQuests.Enabled = '$ENABLE_FROM_QUESTS'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/MaxSkill.Enabled =.*/MaxSkill.Enabled = '$ENABLE_MAX_SKILL'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/MaxSkill.MaxLevel =.*/MaxSkill.MaxLevel = '$MODULE_LEARN_SPELLS_MAX_SKILL_MAX_LEVEL'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/Riding.Enabled =.*/Riding.Enabled = '$ENABLE_RIDING'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/Riding.Apprentice.Enabled =.*/Riding.Apprentice.Enabled = '$ENABLE_APPRENTICE_RIDING'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/Riding.Journeyman.Enabled =.*/Riding.Journeyman.Enabled = '$ENABLE_JOURNEYMAN_RIDING'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/Riding.Expert.Enabled =.*/Riding.Expert.Enabled = '$ENABLE_EXPERT_RIDING'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/Riding.Artisan.Enabled =.*/Riding.Artisan.Enabled = '$ENABLE_ARTISAN_RIDING'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
                sed -i 's/Riding.ColdWeather.Enabled =.*/Riding.ColdWeather.Enabled = '$ENABLE_COLD_WEATHER_RIDING'/g' $CORE_DIRECTORY/etc/modules/LearnSpells.conf
            fi
        else
            if [ -f $CORE_DIRECTORY/etc/modules/LearnSpells.conf ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/LearnSpells.conf
            fi

            if [ -f $CORE_DIRECTORY/etc/modules/LearnSpells.conf.dist ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/LearnSpells.conf.dist
            fi
        fi
    fi

    if [[ $1 == 0 || $1 == 2 ]]; then
        if [ $MODULE_LEVEL_REWARD_ENABLED == "true" ]; then
            if [ -f $CORE_DIRECTORY/etc/modules/LevelReward.conf.dist ]; then
                printf "${COLOR_ORANGE}Updating LevelReward.conf${COLOR_END}\n"

                cp $CORE_DIRECTORY/etc/modules/LevelReward.conf.dist $CORE_DIRECTORY/etc/modules/LevelReward.conf

                sed -i 's/Reward.Gold.Level.10 =.*/Reward.Gold.Level.10 = '$MODULE_LEVEL_REWARD_LEVEL_10'/g' $CORE_DIRECTORY/etc/modules/LevelReward.conf
                sed -i 's/Reward.Gold.Level.20 =.*/Reward.Gold.Level.20 = '$MODULE_LEVEL_REWARD_LEVEL_20'/g' $CORE_DIRECTORY/etc/modules/LevelReward.conf
                sed -i 's/Reward.Gold.Level.30 =.*/Reward.Gold.Level.30 = '$MODULE_LEVEL_REWARD_LEVEL_30'/g' $CORE_DIRECTORY/etc/modules/LevelReward.conf
                sed -i 's/Reward.Gold.Level.40 =.*/Reward.Gold.Level.40 = '$MODULE_LEVEL_REWARD_LEVEL_40'/g' $CORE_DIRECTORY/etc/modules/LevelReward.conf
                sed -i 's/Reward.Gold.Level.50 =.*/Reward.Gold.Level.50 = '$MODULE_LEVEL_REWARD_LEVEL_50'/g' $CORE_DIRECTORY/etc/modules/LevelReward.conf
                sed -i 's/Reward.Gold.Level.60 =.*/Reward.Gold.Level.60 = '$MODULE_LEVEL_REWARD_LEVEL_60'/g' $CORE_DIRECTORY/etc/modules/LevelReward.conf
                sed -i 's/Reward.Gold.Level.70 =.*/Reward.Gold.Level.70 = '$MODULE_LEVEL_REWARD_LEVEL_70'/g' $CORE_DIRECTORY/etc/modules/LevelReward.conf
                sed -i 's/Reward.Gold.Level.80 =.*/Reward.Gold.Level.80 = '$MODULE_LEVEL_REWARD_LEVEL_80'/g' $CORE_DIRECTORY/etc/modules/LevelReward.conf
            fi
        else
            if [ -f $CORE_DIRECTORY/etc/modules/LevelReward.conf ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/LevelReward.conf
            fi

            if [ -f $CORE_DIRECTORY/etc/modules/LevelReward.conf.dist ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/LevelReward.conf.dist
            fi
        fi
    fi

    if [[ $1 == 0 || $1 == 2 ]]; then
        if [ $MODULE_RECRUIT_A_FRIEND_ENABLED == "true" ]; then
            if [ -f $CORE_DIRECTORY/etc/modules/RecruitAFriend.conf.dist ]; then
                printf "${COLOR_ORANGE}Updating RecruitAFriend.conf${COLOR_END}\n"

                cp $CORE_DIRECTORY/etc/modules/RecruitAFriend.conf.dist $CORE_DIRECTORY/etc/modules/RecruitAFriend.conf

                sed -i 's/RecruitAFriend.Duration =.*/RecruitAFriend.Duration = '$MODULE_RECRUIT_A_FRIEND_DURATION'/g' $CORE_DIRECTORY/etc/modules/RecruitAFriend.conf
            fi
        else
            if [ -f $CORE_DIRECTORY/etc/modules/RecruitAFriend.conf ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/RecruitAFriend.conf
            fi

            if [ -f $CORE_DIRECTORY/etc/modules/RecruitAFriend.conf.dist ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/RecruitAFriend.conf.dist
            fi
        fi
    fi

    if [[ $1 == 0 || $1 == 2 ]]; then
        if [ $MODULE_SKIP_DK_STARTING_AREA_ENABLED == "true" ]; then
            if [ -f $CORE_DIRECTORY/etc/modules/SkipDKModule.conf.dist ]; then
                printf "${COLOR_ORANGE}Updating mod_ahbot.conf${COLOR_END}\n"

                cp $CORE_DIRECTORY/etc/modules/SkipDKModule.conf.dist $CORE_DIRECTORY/etc/modules/SkipDKModule.conf

                sed -i 's/Skip.Deathknight.Starter.Enable =.*/Skip.Deathknight.Starter.Enable = 1/g' $CORE_DIRECTORY/etc/modules/SkipDKModule.conf
                sed -i 's/GM.Skip.Deathknight.Starter.Enable =.*/GM.Skip.Deathknight.Starter.Enable = 1/g' $CORE_DIRECTORY/etc/modules/SkipDKModule.conf
                sed -i 's/Skip.Deathknight.Start.Level =.*/Skip.Deathknight.Start.Level = '$MODULE_SKIP_DK_STARTING_AREA_LEVEL'/g' $CORE_DIRECTORY/etc/modules/SkipDKModule.conf
            fi
        else
            if [ -f $CORE_DIRECTORY/etc/modules/SkipDKModule.conf ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/SkipDKModule.conf
            fi

            if [ -f $CORE_DIRECTORY/etc/modules/SkipDKModule.conf.dist ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/SkipDKModule.conf.dist
            fi
        fi
    fi

    if [[ $1 == 0 || $1 == 2 ]]; then
        if [ $MODULE_WEEKEND_BONUS_ENABLED == "true" ]; then
            if [ -f $CORE_DIRECTORY/etc/modules/WeekendBonus.conf.dist ]; then
                printf "${COLOR_ORANGE}Updating WeekendBonus.conf${COLOR_END}\n"

                cp $CORE_DIRECTORY/etc/modules/WeekendBonus.conf.dist $CORE_DIRECTORY/etc/modules/WeekendBonus.conf

                sed -i 's/Multiplier.Experience =.*/Multiplier.Experience = '$MODULE_WEEKEND_BONUS_EXPERIENCE_MULTIPLIER'/g' $CORE_DIRECTORY/etc/modules/WeekendBonus.conf
                sed -i 's/Multiplier.Reputation =.*/Multiplier.Reputation = '$MODULE_WEEKEND_BONUS_REPUTATION_MULTIPLIER'/g' $CORE_DIRECTORY/etc/modules/WeekendBonus.conf
            fi
        else
            if [ -f $CORE_DIRECTORY/etc/modules/WeekendBonus.conf ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/WeekendBonus.conf
            fi

            if [ -f $CORE_DIRECTORY/etc/modules/WeekendBonus.conf.dist ]; then
                rm -rf $CORE_DIRECTORY/etc/modules/WeekendBonus.conf.dist
            fi
        fi
    fi
}
