#!/bin/bash
DISTRIBUTION=("ubuntu22.04")

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID

    if [[ ! " ${DISTRIBUTION[@]} " =~ " ${OS}${VERSION} " ]]; then
        echo -e "\e[0;31mThis distribution is currently not supported\e[0m"
        exit $?
    fi
else
    echo -e "\e[0;31mUnable to determine the distribution\e[0m"
    exit $?
fi

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

MYSQL_HOSTNAME="127.0.0.1"
MYSQL_PORT="3306"
MYSQL_USERNAME="acore"
MYSQL_PASSWORD="acore"
MYSQL_DATABASES_AUTH="acore_auth"
MYSQL_DATABASES_CHARACTERS="acore_characters"
MYSQL_DATABASES_WORLD="acore_world"
WORLD_NAME="AzerothCore"
WORLD_MOTD="Welcome to AzerothCore."
WORLD_ADDRESS="127.0.0.1" # SET THIS TO THE ADDRESS THE CLIENT CONNECTS TO
WORLD_PORT="9644" # CHANGE IF MULTIPLE WORLDSERVERS ARE RUNNING ON THE SAME SYSTEM
AUTH_ADDRESS="127.0.0.1" # SET THIS TO THE ADDRESS OF THE SERVER RUNNING THE TOCLOUD9 PROCESSES
PROGRESSION_ACTIVE_PATCH="21"
# Eastern Kingdoms, Kalimdor, Outland, Northrend and Deeprun Tram: 0,1,369,530,571
# All dungeon, raid, battleground and arena maps: 30,33,34,36,43,44,47,48,70,90,109,129,169,189,209,229,230,249,269,289,309,329,349,389,409,429,469,489,509,529,531,532,533,534,540,542,543,544,545,546,547,548,550,552,553,554,555,556,557,558,559,560,562,564,565,566,568,572,574,575,576,578,580,585,595,598,599,600,601,602,603,604,607,608,615,616,617,618,619,624,628,631,632,649,650,658,668,724
AVAILABLE_MAPS=""

# DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING
SOURCE_AZEROTHCORE_REPOSITORY="https://github.com/walkline/azerothcore-wotlk.git"
SOURCE_AZEROTHCORE_BRANCH="cluster-mode"
SOURCE_LOCATION="$ROOT/source"
SOURCE_TOCLOUD9_REPOSITORY="https://github.com/walkline/ToCloud9.git"
SOURCE_TOCLOUD9_BRANCH="master"
WORLD_ID="1"
DEFAULT_WORLD_PORT="8085"

function install_packages
{
    PACKAGES=("git" "cmake" "make" "gcc" "clang" "screen" "curl" "unzip" "g++" "libssl-dev" "libbz2-dev" "libreadline-dev" "libncurses-dev" "libboost1.74-all-dev" "libmysqlclient-dev" "mysql-client" "golang-go" "redis")

    for p in "${PACKAGES[@]}"; do
        if [[ $(dpkg-query -W -f='${Status}' $p 2>/dev/null | grep -c "ok installed") -eq 0 ]]; then
            INSTALL+=($p)
        fi
    done

    if [[ ${#INSTALL[@]} -gt 0 ]]; then
        clear

        if [[ $EUID != 0 ]]; then
            sudo apt-get --yes update
        else
            apt-get --yes update
        fi
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        if [[ $EUID != 0 ]]; then
            sudo apt-get --yes install ${INSTALL[*]}
        else
            apt-get --yes install ${INSTALL[*]}
        fi
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi
}

function get_source
{
    printf "${COLOR_GREEN}Downloading the source code...${COLOR_END}\n"

    if [[ ! -d $SOURCE_LOCATION/tocloud9 ]]; then
        git clone --recursive --depth 1 --branch $SOURCE_TOCLOUD9_BRANCH $SOURCE_TOCLOUD9_REPOSITORY $SOURCE_LOCATION/tocloud9
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    else
        cd $SOURCE_LOCATION/tocloud9

        git pull
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        git reset --hard origin/$SOURCE_TOCLOUD9_BRANCH
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        git submodule update
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi

    if [[ ! -d $SOURCE_LOCATION/azerothcore ]]; then
        git clone --recursive --depth 1 --branch $SOURCE_AZEROTHCORE_BRANCH $SOURCE_AZEROTHCORE_REPOSITORY $SOURCE_LOCATION/azerothcore
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    else
        cd $SOURCE_LOCATION/azerothcore

        git pull
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        git reset --hard origin/$SOURCE_AZEROTHCORE_BRANCH
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        git submodule update
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi

    printf "${COLOR_GREEN}Finished downloading the source code...${COLOR_END}\n"
}

function compile_source
{
    printf "${COLOR_GREEN}Compiling the source code...${COLOR_END}\n"

    cd $SOURCE_LOCATION/tocloud9

    printf "${COLOR_ORANGE}Building libsidecar.${COLOR_END}\n"

    go build -o bin/libsidecar.so -buildmode=c-shared ./game-server/libsidecar/
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    cp $SOURCE_LOCATION/tocloud9/bin/libsidecar.so $SOURCE_LOCATION/azerothcore/deps/libsidecar/libsidecar.so
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    if [[ $EUID != 0 ]]; then
        sudo cp $SOURCE_LOCATION/tocloud9/bin/libsidecar.so /usr/lib/libsidecar.so
    else
        cp $SOURCE_LOCATION/tocloud9/bin/libsidecar.so /usr/lib/libsidecar.so
    fi
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    printf "${COLOR_ORANGE}Building worldserver.${COLOR_END}\n"

    mkdir -p $SOURCE_LOCATION/azerothcore/build && cd $_

    for i in {1..2}; do
        cmake ../ -DCMAKE_INSTALL_PREFIX=$SOURCE_LOCATION/azerothcore -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DSCRIPTS=static -DAPPS_BUILD="world-only" -DUSE_REAL_LIBSIDECAR=ON
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        make -j $(nproc)
        if [[ $? -ne 0 ]]; then
            if [[ $i == 1 ]]; then
                make clean
            else
                exit $?
            fi
        else
            break
        fi
    done

    make install
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    echo "#!/bin/bash" > $SOURCE_LOCATION/azerothcore/bin/start.sh
    echo "screen -AmdS world ./world.sh" >> $SOURCE_LOCATION/azerothcore/bin/start.sh
    chmod +x $SOURCE_LOCATION/azerothcore/bin/start.sh

    echo "#!/bin/bash" > $SOURCE_LOCATION/azerothcore/bin/stop.sh
    echo "screen -X -S \"world\" quit" >> $SOURCE_LOCATION/azerothcore/bin/stop.sh
    chmod +x $SOURCE_LOCATION/azerothcore/bin/stop.sh

    echo "#!/bin/bash" > $SOURCE_LOCATION/azerothcore/bin/world.sh
    echo "while :; do" >> $SOURCE_LOCATION/azerothcore/bin/world.sh
    echo "  TC9_CONFIG_FILE=$SOURCE_LOCATION/azerothcore/bin/config.yml AC_WORLD_SERVER_PORT="$WORLD_PORT" ./worldserver" >> $SOURCE_LOCATION/azerothcore/bin/world.sh
    echo "  if [[ \$? == 0 ]]; then" >> $SOURCE_LOCATION/azerothcore/bin/world.sh
    echo "    break" >> $SOURCE_LOCATION/azerothcore/bin/world.sh
    echo "  fi" >> $SOURCE_LOCATION/azerothcore/bin/world.sh
    echo "  sleep 5" >> $SOURCE_LOCATION/azerothcore/bin/world.sh
    echo "done" >> $SOURCE_LOCATION/azerothcore/bin/world.sh
    chmod +x $SOURCE_LOCATION/azerothcore/bin/world.sh

    printf "${COLOR_GREEN}Finished compiling the source code...${COLOR_END}\n"
}

function get_client_files
{
    if [[ ! -f $ROOT/client.version ]]; then
        VERSION="0"
    else
        VERSION=$(<$ROOT/client.version)
    fi

    if [[ ! -d $SOURCE_LOCATION/azerothcore/bin/Cameras ]] || [[ ! -d $SOURCE_LOCATION/azerothcore/bin/dbc ]] || [[ ! -d $SOURCE_LOCATION/azerothcore/bin/maps ]] || [[ ! -d $SOURCE_LOCATION/azerothcore/bin/mmaps ]] || [[ ! -d $SOURCE_LOCATION/azerothcore/bin/vmaps ]]; then
        VERSION=0
    fi

    AVAILABLE_VERSION=$(git ls-remote --tags --sort="v:refname" https://github.com/wowgaming/client-data.git | tail -n1 | cut --delimiter='/' --fields=3 | sed 's/v//')

    if [[ $VERSION != $AVAILABLE_VERSION ]]; then
        printf "${COLOR_GREEN}Downloading the client data files...${COLOR_END}\n"

        if [[ -d $SOURCE_LOCATION/azerothcore/bin/Cameras ]]; then
            rm -rf $SOURCE_LOCATION/azerothcore/bin/Cameras
        fi
        if [[ -d $SOURCE_LOCATION/azerothcore/bin/dbc ]]; then
            rm -rf $SOURCE_LOCATION/azerothcore/bin/dbc
        fi
        if [[ -d $SOURCE_LOCATION/azerothcore/bin/maps ]]; then
            rm -rf $SOURCE_LOCATION/azerothcore/bin/maps
        fi
        if [[ -d $SOURCE_LOCATION/azerothcore/bin/mmaps ]]; then
            rm -rf $SOURCE_LOCATION/azerothcore/bin/mmaps
        fi
        if [[ -d $SOURCE_LOCATION/azerothcore/bin/vmaps ]]; then
            rm -rf $SOURCE_LOCATION/azerothcore/bin/vmaps
        fi

        curl -L https://github.com/wowgaming/client-data/releases/download/v${AVAILABLE_VERSION}/data.zip > $SOURCE_LOCATION/azerothcore/bin/data.zip
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        unzip -o "$SOURCE_LOCATION/azerothcore/bin/data.zip" -d "$SOURCE_LOCATION/azerothcore/bin/"
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        rm -rf $SOURCE_LOCATION/azerothcore/bin/data.zip

        echo $AVAILABLE_VERSION > $ROOT/client.version

        printf "${COLOR_GREEN}Finished downloading the client data files...${COLOR_END}\n"
    fi
}

function copy_database_files
{
    if [[ ! -d $ROOT/sql/auth ]]; then
        mkdir -p $ROOT/sql/auth
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi

    echo "DELETE FROM \`realmlist\` WHERE \`id\`="$WORLD_ID";" > $ROOT/sql/auth/realmlist_id_$WORLD_ID.sql
    echo "INSERT INTO \`realmlist\` (\`id\`, \`name\`, \`address\`, \`localAddress\`, \`port\`) VALUES ("$WORLD_ID", '"$WORLD_NAME"', '"$WORLD_ADDRESS"', '"$WORLD_ADDRESS"', "$DEFAULT_WORLD_PORT");" >> $ROOT/sql/auth/realmlist_id_$WORLD_ID.sql
    echo "DELETE FROM \`motd\` WHERE \`realmid\`="$WORLD_ID";" > $ROOT/sql/auth/motd_id_$WORLD_ID.sql
    echo "INSERT INTO \`motd\` (\`realmid\`, \`text\`) VALUES ("$WORLD_ID", '"$WORLD_MOTD"');" >> $ROOT/sql/auth/motd_id_$WORLD_ID.sql

    if [[ ! -d $ROOT/sql/characters ]]; then
        mkdir -p $ROOT/sql/characters
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi

    # A temporary workaround
    curl -L https://github.com/walkline/ToCloud9/raw/master/sql/characters/mysql/000001_create_guild_invites_table.down.sql > $ROOT/sql/characters/000001_create_guild_invites_table.down.sql
    curl -L https://github.com/walkline/ToCloud9/raw/master/sql/characters/mysql/000001_create_guild_invites_table.up.sql > $ROOT/sql/characters/000001_create_guild_invites_table.up.sql
    curl -L https://github.com/walkline/ToCloud9/raw/master/sql/characters/mysql/000002_add_auto_increment_to_mail.up.sql > $ROOT/sql/characters/000002_add_auto_increment_to_mail.up.sql

    if [[ ! -d $ROOT/sql/world ]]; then
        mkdir -p $ROOT/sql/world
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi

    if [[ -d $SOURCE_LOCATION/azerothcore/data/sql/custom/db_auth ]]; then
        if [[ ! -z "$(ls -A $SOURCE_LOCATION/azerothcore/data/sql/custom/db_auth/)" ]]; then
            for f in $SOURCE_LOCATION/azerothcore/data/sql/custom/db_auth/*.sql; do
                rm -rf $f
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            done
        fi
    fi

    if [[ -d $ROOT/sql/auth ]]; then
        if [[ ! -z "$(ls -A $ROOT/sql/auth/)" ]]; then
            for f in $ROOT/sql/auth/*.sql; do
                printf "${COLOR_ORANGE}Copying "$(basename $f)"${COLOR_END}\n"

                cp $f $SOURCE_LOCATION/azerothcore/data/sql/custom/db_auth/$(basename $f)
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            done
        fi
    fi

    if [[ -d $SOURCE_LOCATION/azerothcore/data/sql/custom/db_characters ]]; then
        if [[ ! -z "$(ls -A $SOURCE_LOCATION/azerothcore/data/sql/custom/db_characters/)" ]]; then
            for f in $SOURCE_LOCATION/azerothcore/data/sql/custom/db_characters/*.sql; do
                rm -rf $f
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            done
        fi
    fi

    if [[ -d $ROOT/sql/characters ]]; then
        if [[ ! -z "$(ls -A $ROOT/sql/characters/)" ]]; then
            for f in $ROOT/sql/characters/*.sql; do
                printf "${COLOR_ORANGE}Copying "$(basename $f)"${COLOR_END}\n"

                cp $f $SOURCE_LOCATION/azerothcore/data/sql/custom/db_characters/$(basename $f)
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            done
        fi
    fi

    if [[ -d $SOURCE_LOCATION/azerothcore/data/sql/custom/db_world ]]; then
        if [[ ! -z "$(ls -A $SOURCE_LOCATION/azerothcore/data/sql/custom/db_world/)" ]]; then
            for f in $SOURCE_LOCATION/azerothcore/data/sql/custom/db_world/*.sql; do
                rm -rf $f
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            done
        fi
    fi

    if [[ -d $ROOT/sql/world ]]; then
        if [[ ! -z "$(ls -A $ROOT/sql/world/)" ]]; then
            for f in $ROOT/sql/world/*.sql; do
                printf "${COLOR_ORANGE}Copying "$(basename $f)"${COLOR_END}\n"

                cp $f $SOURCE_LOCATION/azerothcore/data/sql/custom/db_world/$(basename $f)
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            done
        fi
    fi
}

function set_config
{
    printf "${COLOR_GREEN}Updating the config files...${COLOR_END}\n"

    if [[ ! -f $SOURCE_LOCATION/tocloud9/config.yml.example ]]; then
        printf "${COLOR_RED}The config file config.yml.example is missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
        exit $?
    fi

    printf "${COLOR_ORANGE}Updating config.yml${COLOR_END}\n"

    cp $SOURCE_LOCATION/tocloud9/config.yml.example $SOURCE_LOCATION/azerothcore/bin/config.yml

    sed -i 's/  auth: \&defaultAuthDB.*/  auth: \&defaultAuthDB "'$MYSQL_USERNAME':'$MYSQL_PASSWORD'@tcp('$MYSQL_HOSTNAME':'$MYSQL_PORT')\/'$MYSQL_DATABASE_AUTH'"/g' $SOURCE_LOCATION/azerothcore/bin/config.yml
    sed -i 's/  characters: \&defaultCharactersDB.*/  characters: \&defaultCharactersDB "'$MYSQL_USERNAME':'$MYSQL_PASSWORD'@tcp('$MYSQL_HOSTNAME':'$MYSQL_PORT')\/'$MYSQL_DATABASE_CHARACTERS'"/g' $SOURCE_LOCATION/azerothcore/bin/config.yml
    sed -i 's/  world: \&defaultWorldDB.*/  world: \&defaultWorldDB "'$MYSQL_USERNAME':'$MYSQL_PASSWORD'@tcp('$MYSQL_HOSTNAME':'$MYSQL_PORT')\/'$MYSQL_DATABASE_WORLD'"/g' $SOURCE_LOCATION/azerothcore/bin/config.yml
    sed -i 's/  schemaType: \&defaultSchemaType.*/  schemaType: \&defaultSchemaType "ac"/g' $SOURCE_LOCATION/azerothcore/bin/config.yml
    sed -i 's/nats: \&defaultNatsUrl.*/nats: \&defaultNatsUrl "nats:\/\/'$AUTH_ADDRESS':4222"/g' $SOURCE_LOCATION/azerothcore/bin/config.yml
    sed -i 's/  serversRegistryServiceAddress:.*/  serversRegistryServiceAddress: '$AUTH_ADDRESS':8999/g' $SOURCE_LOCATION/azerothcore/bin/config.yml
    sed -i 's/  charactersServiceAddress:.*/  charactersServiceAddress: "'$AUTH_ADDRESS':8991"/g' $SOURCE_LOCATION/azerothcore/bin/config.yml
    sed -i 's/  chatServiceAddress:.*/  chatServiceAddress: "'$AUTH_ADDRESS':8992"/g' $SOURCE_LOCATION/azerothcore/bin/config.yml
    sed -i 's/  guildsServiceAddress:.*/  guildsServiceAddress: "'$AUTH_ADDRESS':8995"/g' $SOURCE_LOCATION/azerothcore/bin/config.yml
    sed -i 's/  mailServiceAddress:.*/  mailServiceAddress: "'$AUTH_ADDRESS':8997"/g' $SOURCE_LOCATION/azerothcore/bin/config.yml
    sed -i 's/  preferredHostname:.*/  preferredHostname: "'$WORLD_ADDRESS'"/g' $SOURCE_LOCATION/azerothcore/bin/config.yml
    sed -i 's/  guidProviderServiceAddress:.*/  guidProviderServiceAddress: "'$AUTH_ADDRESS':8996"/g' $SOURCE_LOCATION/azerothcore/bin/config.yml

    if [[ ! -f $SOURCE_LOCATION/azerothcore/etc/worldserver.conf.dist ]]; then
        printf "${COLOR_RED}The config file worldserver.conf.dist is missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
        exit $?
    fi

    printf "${COLOR_ORANGE}Updating worldserver.conf${COLOR_END}\n"

    cp $SOURCE_LOCATION/azerothcore/etc/worldserver.conf.dist $SOURCE_LOCATION/azerothcore/etc/worldserver.conf

    sed -i 's/LoginDatabaseInfo     =.*/LoginDatabaseInfo     = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASES_AUTH'"/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/WorldDatabaseInfo     =.*/WorldDatabaseInfo     = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASES_WORLD'"/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/CharacterDatabaseInfo =.*/CharacterDatabaseInfo = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASES_CHARACTERS'"/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 7/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/RealmID =.*/RealmID = '$WORLD_ID'/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/WorldServerPort =.*/WorldServerPort = '$DEFAULT_WORLD_PORT'/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/GameType =.*/GameType = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/RealmZone =.*/RealmZone = 2/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Expansion =.*/Expansion = 2/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/PlayerLimit =.*/PlayerLimit = 1000/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/StrictPlayerNames =.*/StrictPlayerNames = 3/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/StrictCharterNames =.*/StrictCharterNames = 3/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/StrictPetNames =.*/StrictPetNames = 3/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/AllowPlayerCommands =.*/AllowPlayerCommands = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Quests.IgnoreRaid =.*/Quests.IgnoreRaid = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/PreloadAllNonInstancedMapGrids =.*/PreloadAllNonInstancedMapGrids = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/SetAllCreaturesWithWaypointMovementActive =.*/SetAllCreaturesWithWaypointMovementActive = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Minigob.Manabonk.Enable =.*/Minigob.Manabonk.Enable = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.XP.Kill      =.*/Rate.XP.Kill      = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.XP.Quest     =.*/Rate.XP.Quest     = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.XP.Quest.DF  =.*/Rate.XP.Quest.DF  = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.XP.Explore   =.*/Rate.XP.Explore   = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.XP.Pet       =.*/Rate.XP.Pet       = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.Rest.InGame                 =.*/Rate.Rest.InGame                 = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.Rest.Offline.InTavernOrCity =.*/Rate.Rest.Offline.InTavernOrCity = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.Rest.Offline.InWilderness   =.*/Rate.Rest.Offline.InWilderness   = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/GM.LoginState =.*/GM.LoginState = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/GM.Visible =.*/GM.Visible = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/GM.Chat =.*/GM.Chat = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/GM.WhisperingTo =.*/GM.WhisperingTo = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/GM.InGMList.Level =.*/GM.InGMList.Level = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/GM.InWhoList.Level =.*/GM.InWhoList.Level = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/GM.StartLevel = .*/GM.StartLevel = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/GM.AllowInvite =.*/GM.AllowInvite = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/GM.AllowFriend =.*/GM.AllowFriend = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/GM.LowerSecurity =.*/GM.LowerSecurity = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/LeaveGroupOnLogout.Enabled =.*/LeaveGroupOnLogout.Enabled = 1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Progression.Patch =.*/Progression.Patch = '$PROGRESSION_ACTIVE_PATCH'/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Progression.IcecrownCitadel.Aura =.*/Progression.IcecrownCitadel.Aura = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Progression.QuestInfo.Enforced =.*/Progression.QuestInfo.Enforced = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Progression.DungeonFinder.Enforced =.*/Progression.DungeonFinder.Enforced = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/DBC.EnforceItemAttributes =.*/DBC.EnforceItemAttributes = 0/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/MapUpdate.Threads =.*/MapUpdate.Threads = '$(nproc)'/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/MinWorldUpdateTime =.*/MinWorldUpdateTime = 10/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/MapUpdateInterval =.*/MapUpdateInterval = 100/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Cluster.Enabled=.*/Cluster.Enabled=1/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf
    sed -i 's/Cluster.AvailableMaps=.*/Cluster.AvailableMaps="'$AVAILABLE_MAPS'"/g' $SOURCE_LOCATION/azerothcore/etc/worldserver.conf

    printf "${COLOR_GREEN}Finished updating the config files...${COLOR_END}\n"
}

function start_server
{
    printf "${COLOR_GREEN}Starting the server...${COLOR_END}\n"

    if [[ ! -f $SOURCE_LOCATION/azerothcore/bin/start.sh ]] || [[ ! -f $SOURCE_LOCATION/azerothcore/bin/stop.sh ]]; then
        printf "${COLOR_RED}The required binaries are missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
    else
        if [[ ! -z `screen -list | grep -E "world"` ]]; then
            printf "${COLOR_RED}The server is already running.${COLOR_END}\n"
        else
            cd $SOURCE_LOCATION/azerothcore/bin && ./start.sh

            if [[ ! -z `screen -list | grep -E "world"` ]]; then
                printf "${COLOR_ORANGE}To access the screen of the worldserver, use the command ${COLOR_BLUE}screen -r world${COLOR_ORANGE}.${COLOR_END}\n"
            fi
        fi
    fi

    printf "${COLOR_GREEN}Finished starting the server...${COLOR_END}\n"
}

function stop_server
{
    printf "${COLOR_GREEN}Stopping the server...${COLOR_END}\n"

    if [[ -z `screen -list | grep -E "world"` ]]; then
        printf "${COLOR_RED}The server is not running.${COLOR_END}\n"
    else
        printf "${COLOR_ORANGE}Telling the world server to shut down.${COLOR_END}\n"

        PID=$(pgrep worldserver)

        if [[ $PID != "" ]]; then
            if [[ $1 == "restart" ]]; then
                screen -S world -p 0 -X stuff "server restart 10^m"
            else
                screen -S world -p 0 -X stuff "server shutdown 10^m"
            fi

            timeout 30 tail --pid=$PID -f /dev/null
        fi

        if [[ -f $SOURCE_LOCATION/azerothcore/bin/stop.sh ]]; then
            cd $SOURCE_LOCATION/azerothcore/bin && ./stop.sh
        fi
    fi

    printf "${COLOR_GREEN}Finished stopping the server...${COLOR_END}\n"
}

function parameters
{
    printf "${COLOR_GREEN}Available parameters${COLOR_END}\n"

    printf "${COLOR_GREEN}Available subparameters${COLOR_END}\n"
    printf "${COLOR_ORANGE}install/setup/update             ${COLOR_WHITE}| ${COLOR_BLUE}Downloads the source code and compiles it. Also downloads client files${COLOR_END}\n"
    printf "${COLOR_ORANGE}database/db                      ${COLOR_WHITE}| ${COLOR_BLUE}Copy all custom sql files to the core${COLOR_END}\n"
    printf "${COLOR_ORANGE}config/conf/cfg/settings/options ${COLOR_WHITE}| ${COLOR_BLUE}Updates all config files with options specified${COLOR_END}\n"
    printf "${COLOR_ORANGE}start                            ${COLOR_WHITE}| ${COLOR_BLUE}Starts the compiled processes, based off of the choice for compilation${COLOR_END}\n"
    printf "${COLOR_ORANGE}stop                             ${COLOR_WHITE}| ${COLOR_BLUE}Stops the compiled processes, based off of the choice for compilation${COLOR_END}\n"
    printf "${COLOR_ORANGE}restart                          ${COLOR_WHITE}| ${COLOR_BLUE}Stops and then starts the compiled processes, based off of the choice for compilation${COLOR_END}\n\n"
    printf "${COLOR_ORANGE}all                              ${COLOR_WHITE}| ${COLOR_BLUE}Run all subparameters listed above, including stop and start${COLOR_END}\n"

    exit $?
}

if [[ $# -gt 0 ]]; then
    if [[ $1 == "install" ]] || [[ $1 == "setup" ]] || [[ $1 == "update" ]]; then
        stop_server
        install_packages
        get_source
        compile_source
        get_client_files
    elif [[ $1 == "database" ]] || [[ $1 == "db" ]]; then
        copy_database_files
    elif [[ $1 == "config" ]] || [[ $1 == "conf" ]] || [[ $1 == "cfg" ]] || [[ $1 == "settings" ]] || [[ $1 == "options" ]]; then
        set_config
    elif [[ $1 == "start" ]]; then
        start_server
    elif [[ $1 == "stop" ]]; then
        stop_server
    elif [[ $1 == "restart" ]]; then
        stop_server $1
        start_server
    elif [[ $1 == "all" ]]; then
        stop_server
        install_packages
        get_source
        compile_source
        copy_database_files
        get_client_files
        set_config
        start_server
    else
        parameters
    fi
else
    parameters
fi
