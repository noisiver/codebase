#!/bin/bash
ROOT=$(pwd)

CONFIG_FILE="ac.xml"
MYSQL_CONFIG="$ROOT/mysql.cnf"

if [ ! -f $ROOT/$CONFIG_FILE ]; then
    clear
    echo -e "\e[0;33mGenerating default configuration\e[0m"
    echo "<?xml version=\"1.0\"?><config><mysql><!-- Hostname of the MySQL server --><hostname>127.0.0.1</hostname><!-- Port of the MySQL server --><port>3306</port><!-- Username used to connect to the MySQL server --><username>acore</username><!-- Password used to connect to the MySQL server --><password>acore</password><database><!-- Name of the auth database --><auth>acore_auth</auth><!-- Name of the characters database --><characters>acore_characters</characters><!-- Name of the world database --><world>acore_world</world></database></mysql><core><!-- Directory where the cloned git repository is located --><directory>/opt/azerothcore</directory><!-- Selected git commit. Main means the latest available commit --><git_commit>main</git_commit><!-- Selected pull request. None means not using any pull request --><pull_request>none</pull_request></core><world><!-- Name shown to the player at the realm selection screen --><name>AzerothCore</name><!-- Message of the day to send the player when entering the world --><motd>Welcome to AzerothCore!</motd><!-- Realm id. If only one realm is used, it should be left as 1 --><id>1</id><!-- IP-address used to connect to the world server --><ip>127.0.0.1</ip><!-- Game type to use. 0 = PVE, 1 = PVP, 6 = RP --><game_type>1</game_type><!-- Realm zone to use. 1 = Development, 8 = English, 9 = German, 10 = French, 11 = Spanish, 12 = Russian, 13 = Tournament, 14 = Taiwan --><realm_zone>8</realm_zone><!-- Expansion to use. 0 = Vanilla, 1 = The Burning Crusade, 2 = Wrath of the Lich King --><expansion>2</expansion><!-- Max amount of players allowed to be in the world --><player_limit>1000</player_limit><!-- Skip opening cinematics. 0 = Show cinematics for every new characters, 1 = Show cinematics for characters of a new race, 2 = Never show cinematics --><skip_cinematics>0</skip_cinematics><!-- Max level a player can achieve --><max_level>80</max_level><!-- The level a character starts at --><start_level>1</start_level><!-- The amount of gold, in copper, that a character starts with --><start_money>0</start_money><!-- Always keep a characters skills maxed out --><always_max_skill>0</always_max_skill><!-- Give all players every flight path --><all_flight_paths>0</all_flight_paths><!-- Characters start with all maps explored --><maps_explored>0</maps_explored><!-- Allow players to use in-game commands --><allow_commands>0</allow_commands><!-- Quests can be done while in a raid gorup --><quest_ignore_raid>0</quest_ignore_raid><!-- Prevent a character from being logged out due to inactivity --><prevent_afk_logout>0</prevent_afk_logout><!-- Max level refer-a-friend will be active --><raf_max_level>60</raf_max_level><!-- Preload all map grids --><preload_map_grids>0</preload_map_grids><!-- Set all waypoints to be active --><set_all_waypoints_active>0</set_all_waypoints_active><!-- Allow a group to change the loot mode. Kind of hacky, it changes the source code --><allow_lfg_lootmode>false</allow_lfg_lootmode><!-- Enable Minigob Manabonk to roam Dalaran and turn characters into sheeps --><enable_minigob_manabonk>1</enable_minigob_manabonk><rates><!-- Experience gain multiplier --><experience>1</experience><!-- Rested exp gain multiplier --><rested_exp>1</rested_exp><!-- Reputation gain multiplier --><reputation>1</reputation><!-- Money gain multiplier --><money>1</money><!-- Crafting skill up multiplier --><crafting>1</crafting><!-- Gathering skill up multiplier --><gathering>1</gathering><!-- Weapon skill up multiplier --><weapon_skill>1</weapon_skill><!-- Defense skill up multiplier --><defense_skill>1</defense_skill></rates><gm><!-- GM state when entering the world. 0 = Off, 1 = On, 2 = The same state as when the character was online last --><login_state>1</login_state><!-- GM visibility state when entering the world. 0 = Off, 1 = On, 2 = The same state as when the character was online last --><visible>0</visible><!-- GM chat state when entering the world. 0 = Off, 1 = On, 2 = The same state as when the character was online last --><chat>0</chat><!-- GM whispers state when entering the world. 0 = Off, 1 = On, 2 = The same state as when the character was online last --><whisper>0</whisper><!-- GM shown in GM list when entering the world --><gm_list>0</gm_list><!-- GM shown in who list when entering the world --><who_list>0</who_list><!-- Allow players to add a GM as a friend. 0 = Off, 1 = On --><allow_friend>0</allow_friend><!-- Allow players to invite a GM to a group. 0 = Off, 1 = On --><allow_invite>0</allow_invite><!-- Allow lower security players to interact with a higher security player. 0 = Off, 1 = On --><lower_security>0</lower_security></gm></world><module><eluna><!-- Enable the Eluna module --><enabled>false</enabled></eluna><ahbot><!-- Enable the auction house bot module --><enabled>false</enabled><!-- Enable the auction house seller, it adds items to the auction house --><enable_seller>0</enable_seller><!-- Enable the AH bot buyer, it buys items posted on the auction house --><enable_buyer>0</enable_buyer><!-- Account id of the character posing as the auction house bot --><account_id>1</account_id><!-- Character id of the character posing as the auction house bot --><character_guid>1</character_guid><!-- Min amount of items to post on the auction house --><min_items>250</min_items><!-- Max amount of items to post on the action house --><max_items>250</max_items></ahbot><skip_dk_area><!-- Enable the skip DK area module --><enabled>false</enabled></skip_dk_area></module></config>" | xmllint --format - > $ROOT/$CONFIG_FILE
    exit $?
fi

AZEROTHCORE_URL="https://github.com/azerothcore/azerothcore-wotlk.git"
AZEROTHCORE_BRANCH="master"
MODULE_ELUNA_URL="https://github.com/azerothcore/mod-eluna-lua-engine.git"
MODULE_ELUNA_BRANCH="master"
MODULE_AHBOT_URL="https://github.com/azerothcore/mod-ah-bot.git"
MODULE_AHBOT_BRANCH="master"
MODULE_SKIPDKAREA_URL="https://github.com/Crypticaz/SkipDeathKnightStartingArea.git"
MODULE_SKIPDKAREA_BRANCH="master"

CLIENT_DATA="https://github.com/wowgaming/client-data/releases/download/v11/data.zip"

MYSQL_HOSTNAME="$(echo "cat /config/mysql/hostname/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_PORT="$(echo "cat /config/mysql/port/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_USERNAME="$(echo "cat /config/mysql/username/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_PASSWORD="$(echo "cat /config/mysql/password/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_AUTH="$(echo "cat /config/mysql/database/auth/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_CHARACTERS="$(echo "cat /config/mysql/database/characters/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_WORLD="$(echo "cat /config/mysql/database/world/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"

CORE_DIRECTORY="$(echo "cat /config/core/directory/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
GIT_COMMIT="$(echo "cat /config/core/git_commit/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
PULL_REQUEST="$(echo "cat /config/core/pull_request/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"

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
WORLD_ALLOW_LFG_LOOTMODE="$(echo "cat /config/world/allow_lfg_lootmode/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
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

MODULE_AHBOT_ENABLED="$(echo "cat /config/module/ahbot/enabled/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_ENABLE_SELLER="$(echo "cat /config/module/ahbot/enable_seller/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_ENABLE_BUYER="$(echo "cat /config/module/ahbot/enable_buyer/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_ACCOUNT_ID="$(echo "cat /config/module/ahbot/account_id/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_CHARACTER_GUID="$(echo "cat /config/module/ahbot/character_guid/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_MIN_ITEMS="$(echo "cat /config/module/ahbot/min_items/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MODULE_AHBOT_MAX_ITEMS="$(echo "cat /config/module/ahbot/max_items/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"

MODULE_SKIP_DK_AREA_ENABLED="$(echo "cat /config/module/skip_dk_area/enabled/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"

if [[ -z $MYSQL_HOSTNAME ]] || [[ $MYSQL_HOSTNAME == "" ]] || 
   [[ -z $MYSQL_PORT ]] || [[ $MYSQL_PORT == "" ]] || 
   [[ -z $MYSQL_USERNAME ]] || [[ $MYSQL_USERNAME == "" ]] || 
   [[ -z $MYSQL_PASSWORD ]] || [[ $MYSQL_PASSWORD == "" ]] || 
   [[ -z $MYSQL_DATABASE_AUTH ]] || [[ $MYSQL_DATABASE_AUTH == "" ]] || 
   [[ -z $MYSQL_DATABASE_CHARACTERS ]] || [[ $MYSQL_DATABASE_CHARACTERS == "" ]] || 
   [[ -z $MYSQL_DATABASE_WORLD ]] || [[ $MYSQL_DATABASE_WORLD == "" ]] || 
   [[ -z $CORE_DIRECTORY ]] || [[ $CORE_DIRECTORY == "" ]] || 
   [[ -z $GIT_COMMIT ]] || [[ $GIT_COMMIT == "" ]] || 
   [[ -z $PULL_REQUEST ]] || [[ $PULL_REQUEST == "" ]] || 
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
   [[ -z $WORLD_ALLOW_LFG_LOOTMODE ]] || [[ $WORLD_ALLOW_LFG_LOOTMODE == "" ]] || 
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
   [[ -z $MODULE_ELUNA_ENABLED ]] || [[ $MODULE_ELUNA_ENABLED == "" ]] || 
   [[ -z $MODULE_AHBOT_ENABLED ]] || [[ $MODULE_AHBOT_ENABLED == "" ]] || 
   [[ -z $MODULE_AHBOT_ENABLE_SELLER ]] || [[ $MODULE_AHBOT_ENABLE_SELLER == "" ]] || 
   [[ -z $MODULE_AHBOT_ENABLE_BUYER ]] || [[ $MODULE_AHBOT_ENABLE_BUYER == "" ]] || 
   [[ -z $MODULE_AHBOT_ACCOUNT_ID ]] || [[ $MODULE_AHBOT_ACCOUNT_ID == "" ]] || 
   [[ -z $MODULE_AHBOT_CHARACTER_GUID ]] || [[ $MODULE_AHBOT_CHARACTER_GUID == "" ]] || 
   [[ -z $MODULE_AHBOT_MIN_ITEMS ]] || [[ $MODULE_AHBOT_MIN_ITEMS == "" ]] || 
   [[ -z $MODULE_AHBOT_MAX_ITEMS ]] || [[ $MODULE_AHBOT_MAX_ITEMS == "" ]] || 
   [[ -z $MODULE_SKIP_DK_AREA_ENABLED ]] || [[ $MODULE_SKIP_DK_AREA_ENABLED == "" ]]; then
    clear
    echo -e "\e[0;31mAtleast one of the configuration options is missing or invalid\e[0m"
    exit $?
fi
