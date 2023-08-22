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
SOURCE_REPOSITORY="https://github.com/azerothcore/azerothcore-wotlk.git"
SOURCE_BRANCH="master"
SOURCE_LOCATION="$ROOT/source"
WORLD_NAME="AzerothCore"
WORLD_MOTD="Welcome to AzerothCore."
WORLD_ID="1"
WORLD_ADDRESS="127.0.0.1"
WORLD_PORT="8085"
PROGRESSION_ACTIVE_PATCH="21"
AHBOT_ENABLED="false"
AHBOT_MIN_ITEMS="250"
AHBOT_MAX_ITEMS="250"
AHBOT_MAX_ITEM_LEVEL="0"
ASSISTANT_ENABLED="false"
GUILD_FUNDS_ENABLED="false"
GROUP_QUESTS_ENABLED="false"
LEARN_SPELLS_ENABLED="false"
RECRUIT_A_FRIEND_ENABLED="false"
WEEKEND_BONUS_ENABLED="false"

function install_packages
{
    PACKAGES=("git" "cmake" "make" "gcc" "clang" "screen" "curl" "unzip" "g++" "libssl-dev" "libbz2-dev" "libreadline-dev" "libncurses-dev" "libmysqlclient-dev" "mysql-client")

    if [[ $VERSION != "20.04" ]]; then
        PACKAGES="${PACKAGES} libboost1.74-all-dev"
    fi

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

    if [[ ! -d $SOURCE_LOCATION ]]; then
        git clone --recursive --depth 1 --branch $SOURCE_BRANCH $SOURCE_REPOSITORY $SOURCE_LOCATION
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    else
        cd $SOURCE_LOCATION

        git pull
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        git reset --hard origin/$SOURCE_BRANCH
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        git submodule update
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi

    if [[ $1 == "both" ]] || [[ $1 == "world" ]]; then
        if [[ $ACCOUNT_BOUND_ENABLED == "true" ]]; then
            if [[ ! -d $SOURCE_LOCATION/modules/mod-accountbound ]]; then
                git clone --depth 1 --branch master https://github.com/noisiver/mod-accountbound.git $SOURCE_LOCATION/modules/mod-accountbound
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            else
                cd $SOURCE_LOCATION/modules/mod-accountbound

                git pull
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi

                git reset --hard origin/master
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            fi
        else
            if [[ -d $SOURCE_LOCATION/modules/mod-accountbound ]]; then
                rm -rf $SOURCE_LOCATION/modules/mod-accountbound

                if [[ -d $SOURCE_LOCATION/build ]]; then
                    rm -rf $SOURCE_LOCATION/build
                fi
            fi
        fi

        if [[ $AHBOT_ENABLED == "true" ]]; then
            if [[ ! -d $SOURCE_LOCATION/modules/mod-ah-bot ]]; then
                git clone --depth 1 --branch master https://github.com/azerothcore/mod-ah-bot.git $SOURCE_LOCATION/modules/mod-ah-bot
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            else
                cd $SOURCE_LOCATION/modules/mod-ah-bot

                git pull
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi

                git reset --hard origin/master
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            fi
        else
            if [[ -d $SOURCE_LOCATION/modules/mod-ah-bot ]]; then
                rm -rf $SOURCE_LOCATION/modules/mod-ah-bot

                if [[ -d $SOURCE_LOCATION/build ]]; then
                    rm -rf $SOURCE_LOCATION/build
                fi
            fi
        fi

        if [[ $ASSISTANT_ENABLED == "true" ]]; then
            if [[ ! -d $SOURCE_LOCATION/modules/mod-assistant ]]; then
                git clone --depth 1 --branch master https://github.com/noisiver/mod-assistant.git $SOURCE_LOCATION/modules/mod-assistant
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            else
                cd $SOURCE_LOCATION/modules/mod-assistant

                git pull
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi

                git reset --hard origin/master
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            fi
        else
            if [[ -d $SOURCE_LOCATION/modules/mod-assistant ]]; then
                rm -rf $SOURCE_LOCATION/modules/mod-assistant

                if [[ -d $SOURCE_LOCATION/build ]]; then
                    rm -rf $SOURCE_LOCATION/build
                fi
            fi
        fi

        if [[ $GUILD_FUNDS_ENABLED == "true" ]]; then
            if [[ ! -d $SOURCE_LOCATION/modules/mod-guildfunds ]]; then
                git clone --depth 1 --branch master https://github.com/noisiver/mod-guildfunds.git $SOURCE_LOCATION/modules/mod-guildfunds
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            else
                cd $SOURCE_LOCATION/modules/mod-guildfunds

                git pull
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi

                git reset --hard origin/master
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            fi
        else
            if [[ -d $SOURCE_LOCATION/modules/mod-guildfunds ]]; then
                rm -rf $SOURCE_LOCATION/modules/mod-guildfunds

                if [[ -d $SOURCE_LOCATION/build ]]; then
                    rm -rf $SOURCE_LOCATION/build
                fi
            fi
        fi

        if [[ $GROUP_QUESTS_ENABLED == "true" ]]; then
            if [[ ! -d $SOURCE_LOCATION/modules/mod-groupquests ]]; then
                git clone --depth 1 --branch master https://github.com/noisiver/mod-groupquests.git $SOURCE_LOCATION/modules/mod-groupquests
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            else
                cd $SOURCE_LOCATION/modules/mod-groupquests

                git pull
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi

                git reset --hard origin/master
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            fi
        else
            if [[ -d $SOURCE_LOCATION/modules/mod-groupquests ]]; then
                rm -rf $SOURCE_LOCATION/modules/mod-groupquests

                if [[ -d $SOURCE_LOCATION/build ]]; then
                    rm -rf $SOURCE_LOCATION/build
                fi
            fi
        fi

        if [[ $LEARN_SPELLS_ENABLED == "true" ]]; then
            if [[ ! -d $SOURCE_LOCATION/modules/mod-learnspells ]]; then
                git clone --depth 1 --branch master https://github.com/noisiver/mod-learnspells.git $SOURCE_LOCATION/modules/mod-learnspells
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            else
                cd $SOURCE_LOCATION/modules/mod-learnspells

                git pull
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi

                git reset --hard origin/master
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            fi
        else
            if [[ -d $SOURCE_LOCATION/modules/mod-learnspells ]]; then
                rm -rf $SOURCE_LOCATION/modules/mod-learnspells

                if [[ -d $SOURCE_LOCATION/build ]]; then
                    rm -rf $SOURCE_LOCATION/build
                fi
            fi
        fi

        if [[ $RECRUIT_A_FRIEND_ENABLED == "true" ]]; then
            if [[ ! -d $SOURCE_LOCATION/modules/mod-recruitafriend ]]; then
                git clone --depth 1 --branch master https://github.com/noisiver/mod-recruitafriend.git $SOURCE_LOCATION/modules/mod-recruitafriend
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            else
                cd $SOURCE_LOCATION/modules/mod-recruitafriend

                git pull
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi

                git reset --hard origin/master
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            fi
        else
            if [[ -d $SOURCE_LOCATION/modules/mod-recruitafriend ]]; then
                rm -rf $SOURCE_LOCATION/modules/mod-recruitafriend

                if [[ -d $SOURCE_LOCATION/build ]]; then
                    rm -rf $SOURCE_LOCATION/build
                fi
            fi
        fi

        if [[ $WEEKEND_BONUS_ENABLED == "true" ]]; then
            if [[ ! -d $SOURCE_LOCATION/modules/mod-weekendbonus ]]; then
                git clone --depth 1 --branch master https://github.com/noisiver/mod-weekendbonus.git $SOURCE_LOCATION/modules/mod-weekendbonus
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            else
                cd $SOURCE_LOCATION/modules/mod-weekendbonus

                git pull
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi

                git reset --hard origin/master
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            fi
        else
            if [[ -d $SOURCE_LOCATION/modules/mod-weekendbonus ]]; then
                rm -rf $SOURCE_LOCATION/modules/mod-weekendbonus

                if [[ -d $SOURCE_LOCATION/build ]]; then
                    rm -rf $SOURCE_LOCATION/build
                fi
            fi
        fi
    fi

    printf "${COLOR_GREEN}Finished downloading the source code...${COLOR_END}\n"
}

function compile_source
{
    printf "${COLOR_GREEN}Compiling the source code...${COLOR_END}\n"

    mkdir -p $SOURCE_LOCATION/build && cd $_

    if [[ $1 == "auth" ]]; then
        APPS_BUILD="auth-only"
    elif [[ $1 == "world" ]]; then
        APPS_BUILD="world-only"
    else
        APPS_BUILD="all"
    fi

    for i in {1..2}; do
        cmake ../ -DCMAKE_INSTALL_PREFIX=$SOURCE_LOCATION -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DSCRIPTS=static -DAPPS_BUILD="$APPS_BUILD"
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

    echo "#!/bin/bash" > $SOURCE_LOCATION/bin/start.sh
    echo "#!/bin/bash" > $SOURCE_LOCATION/bin/stop.sh

    if [[ $1 == "both" ]] || [[ $1 == "auth" ]]; then
        echo "screen -AmdS auth ./auth.sh" >> $SOURCE_LOCATION/bin/start.sh
        echo "screen -X -S \"auth\" quit" >> $SOURCE_LOCATION/bin/stop.sh

        echo "#!/bin/bash" > $SOURCE_LOCATION/bin/auth.sh
        echo "while :; do" >> $SOURCE_LOCATION/bin/auth.sh
        echo "./authserver" >> $SOURCE_LOCATION/bin/auth.sh
        echo "sleep 5" >> $SOURCE_LOCATION/bin/auth.sh
        echo "done" >> $SOURCE_LOCATION/bin/auth.sh

        chmod +x $SOURCE_LOCATION/bin/auth.sh
    else
        if [[ -f $SOURCE_LOCATION/bin/auth.sh ]]; then
            rm -rf $SOURCE_LOCATION/bin/auth.sh
        fi
    fi

    if [[ $1 == "both" ]] || [[ $1 == "world" ]]; then
        echo "screen -AmdS world ./world.sh" >> $SOURCE_LOCATION/bin/start.sh
        echo "screen -X -S \"world\" quit" >> $SOURCE_LOCATION/bin/stop.sh

        echo "#!/bin/bash" > $SOURCE_LOCATION/bin/world.sh
        echo "while :; do" >> $SOURCE_LOCATION/bin/world.sh
        echo "./worldserver" >> $SOURCE_LOCATION/bin/world.sh
        echo "if [[ \$? == 0 ]]; then" >> $SOURCE_LOCATION/bin/world.sh
        echo "break" >> $SOURCE_LOCATION/bin/world.sh
        echo "fi" >> $SOURCE_LOCATION/bin/world.sh
        echo "sleep 5" >> $SOURCE_LOCATION/bin/world.sh
        echo "done" >> $SOURCE_LOCATION/bin/world.sh

        chmod +x $SOURCE_LOCATION/bin/world.sh
    else
        if [[ -f $SOURCE_LOCATION/bin/world.sh ]]; then
            rm -rf $SOURCE_LOCATION/bin/world.sh
        fi
    fi

    chmod +x $SOURCE_LOCATION/bin/start.sh
    chmod +x $SOURCE_LOCATION/bin/stop.sh

    printf "${COLOR_GREEN}Finished compiling the source code...${COLOR_END}\n"
}

function get_client_files
{
    if [[ $1 == "both" ]] || [[ $1 == "world" ]]; then
        if [[ ! -f $ROOT/client.version ]]; then
            VERSION="0"
        else
            VERSION=$(<$ROOT/client.version)
        fi

        if [[ ! -d $SOURCE_LOCATION/bin/Cameras ]] || [[ ! -d $SOURCE_LOCATION/bin/dbc ]] || [[ ! -d $SOURCE_LOCATION/bin/maps ]] || [[ ! -d $SOURCE_LOCATION/bin/mmaps ]] || [[ ! -d $SOURCE_LOCATION/bin/vmaps ]]; then
            VERSION=0
        fi

        AVAILABLE_VERSION=$(git ls-remote --tags --sort="v:refname" https://github.com/wowgaming/client-data.git | tail -n1 | cut --delimiter='/' --fields=3 | sed 's/v//')

        if [[ $AVAILABLE_VERSION != $AVAILABLE_VERSION ]]; then
            AVAILABLE_VERSION=$AVAILABLE_VERSION
        fi

        if [[ $VERSION != $AVAILABLE_VERSION ]]; then
            printf "${COLOR_GREEN}Downloading the client data files...${COLOR_END}\n"

            if [[ -d $SOURCE_LOCATION/bin/Cameras ]]; then
                rm -rf $SOURCE_LOCATION/bin/Cameras
            fi
            if [[ -d $SOURCE_LOCATION/bin/dbc ]]; then
                rm -rf $SOURCE_LOCATION/bin/dbc
            fi
            if [[ -d $SOURCE_LOCATION/bin/maps ]]; then
                rm -rf $SOURCE_LOCATION/bin/maps
            fi
            if [[ -d $SOURCE_LOCATION/bin/mmaps ]]; then
                rm -rf $SOURCE_LOCATION/bin/mmaps
            fi
            if [[ -d $SOURCE_LOCATION/bin/vmaps ]]; then
                rm -rf $SOURCE_LOCATION/bin/vmaps
            fi

            curl -L https://github.com/wowgaming/client-data/releases/download/v${AVAILABLE_VERSION}/data.zip > $SOURCE_LOCATION/bin/data.zip
            if [[ $? -ne 0 ]]; then
                exit $?
            fi

            unzip -o "$SOURCE_LOCATION/bin/data.zip" -d "$SOURCE_LOCATION/bin/"
            if [[ $? -ne 0 ]]; then
                exit $?
            fi

            rm -rf $SOURCE_LOCATION/bin/data.zip

            echo $AVAILABLE_VERSION > $ROOT/client.version

            printf "${COLOR_GREEN}Finished downloading the client data files...${COLOR_END}\n"
        fi
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
    echo "INSERT INTO \`realmlist\` (\`id\`, \`name\`, \`address\`, \`localAddress\`, \`port\`) VALUES ("$WORLD_ID", '"$WORLD_NAME"', '"$WORLD_ADDRESS"', '"$WORLD_ADDRESS"', "$WORLD_PORT");" >> $ROOT/sql/auth/realmlist_id_$WORLD_ID.sql
    echo "DELETE FROM \`motd\` WHERE \`realmid\`="$WORLD_ID";" > $ROOT/sql/auth/motd_id_$WORLD_ID.sql
    echo "INSERT INTO \`motd\` (\`realmid\`, \`text\`) VALUES (1, '"$WORLD_MOTD"');" >> $ROOT/sql/auth/motd_id_$WORLD_ID.sql

    if [[ ! -d $ROOT/sql/characters ]]; then
        mkdir -p $ROOT/sql/characters
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi

    if [[ ! -d $ROOT/sql/world ]]; then
        mkdir -p $ROOT/sql/world
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi

    echo "UPDATE \`mod_auctionhousebot\` SET \`minitems\`="$AHBOT_MIN_ITEMS", \`maxitems\`="$AHBOT_MAX_ITEMS"" > $ROOT/sql/world/ahbot_id_$WORLD_ID.sql

    if [[ -d $SOURCE_LOCATION/data/sql/custom/db_auth ]]; then
        if [[ ! -z "$(ls -A $SOURCE_LOCATION/data/sql/custom/db_auth/)" ]]; then
            for f in $SOURCE_LOCATION/data/sql/custom/db_auth/*.sql; do
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

                cp $f $SOURCE_LOCATION/data/sql/custom/db_auth/$(basename $f)
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            done
        fi
    fi

    if [[ -d $SOURCE_LOCATION/data/sql/custom/db_characters ]]; then
        if [[ ! -z "$(ls -A $SOURCE_LOCATION/data/sql/custom/db_characters/)" ]]; then
            for f in $SOURCE_LOCATION/data/sql/custom/db_characters/*.sql; do
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

                cp $f $SOURCE_LOCATION/data/sql/custom/db_characters/$(basename $f)
                if [[ $? -ne 0 ]]; then
                    exit $?
                fi
            done
        fi
    fi

    if [[ -d $SOURCE_LOCATION/data/sql/custom/db_world ]]; then
        if [[ ! -z "$(ls -A $SOURCE_LOCATION/data/sql/custom/db_world/)" ]]; then
            for f in $SOURCE_LOCATION/data/sql/custom/db_world/*.sql; do
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

                cp $f $SOURCE_LOCATION/data/sql/custom/db_world/$(basename $f)
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

    if [[ $1 == "both" ]] || [[ $1 == "auth" ]]; then
        if [[ ! -f $SOURCE_LOCATION/etc/authserver.conf.dist ]]; then
            printf "${COLOR_RED}The config file authserver.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            rm -rf $MYSQL_CNF
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating authserver.conf${COLOR_END}\n"

        cp $SOURCE_LOCATION/etc/authserver.conf.dist $SOURCE_LOCATION/etc/authserver.conf

        sed -i 's/LoginDatabaseInfo =.*/LoginDatabaseInfo = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASES_AUTH'"/g' $SOURCE_LOCATION/etc/authserver.conf
        sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 1/g' $SOURCE_LOCATION/etc/authserver.conf
    fi

    if [[ $1 == "both" ]] || [[ $1 == "world" ]]; then
        if [[ ! -f $SOURCE_LOCATION/etc/worldserver.conf.dist ]]; then
            printf "${COLOR_RED}The config file worldserver.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            rm -rf $MYSQL_CNF
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating worldserver.conf${COLOR_END}\n"

        cp $SOURCE_LOCATION/etc/worldserver.conf.dist $SOURCE_LOCATION/etc/worldserver.conf

        sed -i 's/LoginDatabaseInfo     =.*/LoginDatabaseInfo     = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASES_AUTH'"/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/WorldDatabaseInfo     =.*/WorldDatabaseInfo     = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASES_WORLD'"/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/CharacterDatabaseInfo =.*/CharacterDatabaseInfo = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASES_CHARACTERS'"/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 7/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/RealmID =.*/RealmID = '$WORLD_ID'/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/WorldServerPort =.*/WorldServerPort = '$WORLD_PORT'/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GameType =.*/GameType = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/RealmZone =.*/RealmZone = 2/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Expansion =.*/Expansion = 2/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/PlayerLimit =.*/PlayerLimit = 1000/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/StrictPlayerNames =.*/StrictPlayerNames = 3/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/StrictCharterNames =.*/StrictCharterNames = 3/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/StrictPetNames =.*/StrictPetNames = 3/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/AllowPlayerCommands =.*/AllowPlayerCommands = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Quests.IgnoreRaid =.*/Quests.IgnoreRaid = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/PreloadAllNonInstancedMapGrids =.*/PreloadAllNonInstancedMapGrids = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/SetAllCreaturesWithWaypointMovementActive =.*/SetAllCreaturesWithWaypointMovementActive = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Minigob.Manabonk.Enable =.*/Minigob.Manabonk.Enable = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.XP.Kill      =.*/Rate.XP.Kill      = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.XP.Quest     =.*/Rate.XP.Quest     = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.XP.Quest.DF  =.*/Rate.XP.Quest.DF  = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.XP.Explore   =.*/Rate.XP.Explore   = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.XP.Pet       =.*/Rate.XP.Pet       = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.Rest.InGame                 =.*/Rate.Rest.InGame                 = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.Rest.Offline.InTavernOrCity =.*/Rate.Rest.Offline.InTavernOrCity = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Rate.Rest.Offline.InWilderness   =.*/Rate.Rest.Offline.InWilderness   = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.LoginState =.*/GM.LoginState = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.Visible =.*/GM.Visible = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.Chat =.*/GM.Chat = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.WhisperingTo =.*/GM.WhisperingTo = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.InGMList.Level =.*/GM.InGMList.Level = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.InWhoList.Level =.*/GM.InWhoList.Level = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.StartLevel = .*/GM.StartLevel = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.AllowInvite =.*/GM.AllowInvite = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.AllowFriend =.*/GM.AllowFriend = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/GM.LowerSecurity =.*/GM.LowerSecurity = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/LeaveGroupOnLogout.Enabled =.*/LeaveGroupOnLogout.Enabled = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Progression.Patch =.*/Progression.Patch = '$PROGRESSION_ACTIVE_PATCH'/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Progression.IcecrownCitadel.Aura =.*/Progression.IcecrownCitadel.Aura = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/Progression.QuestInfo.Enforced =.*/Progression.QuestInfo.Enforced = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/DBC.EnforceItemAttributes =.*/DBC.EnforceItemAttributes = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/MapUpdate.Threads =.*/MapUpdate.Threads = '$(nproc)'/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/MinWorldUpdateTime =.*/MinWorldUpdateTime = 10/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/MapUpdateInterval =.*/MapUpdateInterval = 100/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.MaxBots =.*/NpcBot.MaxBots = 39/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Botgiver.FilterRaces =.*/NpcBot.Botgiver.FilterRaces = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.TankTargetIconMask =.*/NpcBot.TankTargetIconMask = 128/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.OffTankTargetIconMask =.*/NpcBot.OffTankTargetIconMask = 64/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Enable.Raid          =.*/NpcBot.Enable.Raid          = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Enable.BG            =.*/NpcBot.Enable.BG            = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Enable.Arena         =.*/NpcBot.Enable.Arena         = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Cost =.*/NpcBot.Cost = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.EngageDelay.DPS  =.*/NpcBot.EngageDelay.DPS  = 3/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.EngageDelay.Heal =.*/NpcBot.EngageDelay.Heal = 3/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Classes.ObsidianDestroyer.Enable =.*/NpcBot.Classes.ObsidianDestroyer.Enable = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Classes.Archmage.Enable          =.*/NpcBot.Classes.Archmage.Enable          = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Classes.Dreadlord.Enable         =.*/NpcBot.Classes.Dreadlord.Enable         = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Classes.SpellBreaker.Enable      =.*/NpcBot.Classes.SpellBreaker.Enable      = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Classes.DarkRanger.Enable        =.*/NpcBot.Classes.DarkRanger.Enable        = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Classes.Necromancer.Enable       =.*/NpcBot.Classes.Necromancer.Enable       = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Classes.SeaWitch.Enable          =.*/NpcBot.Classes.SeaWitch.Enable          = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.Classes.CryptLord.Enable         =.*/NpcBot.Classes.CryptLord.Enable         = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.EnrageOnDismiss =.*/NpcBot.EnrageOnDismiss = 0/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.WanderingBots.BG.Enable =.*/NpcBot.WanderingBots.BG.Enable = 1/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.WanderingBots.BG.TargetTeamPlayersCount.AV =.*/NpcBot.WanderingBots.BG.TargetTeamPlayersCount.AV = 39/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.WanderingBots.BG.TargetTeamPlayersCount.WS =.*/NpcBot.WanderingBots.BG.TargetTeamPlayersCount.WS = 9/g' $SOURCE_LOCATION/etc/worldserver.conf
        sed -i 's/NpcBot.WanderingBots.BG.TargetTeamPlayersCount.AB =.*/NpcBot.WanderingBots.BG.TargetTeamPlayersCount.AB = 14/g' $SOURCE_LOCATION/etc/worldserver.conf

        if [[ $ACCOUNT_BOUND_ENABLED == "true" ]]; then
            if [[ ! -f $SOURCE_LOCATION/etc/modules/mod_accountbound.conf.dist ]]; then
                printf "${COLOR_RED}The config file mod_accountbound.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
                rm -rf $MYSQL_CNF
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_accountbound.conf${COLOR_END}\n"

            cp $SOURCE_LOCATION/etc/modules/mod_accountbound.conf.dist $SOURCE_LOCATION/etc/modules/mod_accountbound.conf

            sed -i 's/AccountBound.Companions =.*/AccountBound.Companions = 1/g' $SOURCE_LOCATION/etc/modules/mod_accountbound.conf
            sed -i 's/AccountBound.Heirlooms =.*/AccountBound.Heirlooms = 1/g' $SOURCE_LOCATION/etc/modules/mod_accountbound.conf
            sed -i 's/AccountBound.Mounts =.*/AccountBound.Mounts = 1/g' $SOURCE_LOCATION/etc/modules/mod_accountbound.conf
            sed -i 's/AccountBound.LinkedAccounts =.*/AccountBound.LinkedAccounts = 0/g' $SOURCE_LOCATION/etc/modules/mod_accountbound.conf
        else
            if [[ -f $SOURCE_LOCATION/etc/modules/mod_accountbound.conf.dist ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_accountbound.conf.dist
            fi

            if [[ -f $SOURCE_LOCATION/etc/modules/mod_accountbound.conf ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_accountbound.conf
            fi
        fi

        if [[ $AHBOT_ENABLED == "true" ]]; then
            if [[ ! -f $SOURCE_LOCATION/etc/modules/mod_ahbot.conf.dist ]]; then
                printf "${COLOR_RED}The config file mod_ahbot.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
                rm -rf $MYSQL_CNF
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_ahbot.conf${COLOR_END}\n"

            cp $SOURCE_LOCATION/etc/modules/mod_ahbot.conf.dist $SOURCE_LOCATION/etc/modules/mod_ahbot.conf

            sed -i 's/AuctionHouseBot.EnableBuyer =.*/AuctionHouseBot.EnableBuyer = 1/g' $SOURCE_LOCATION/etc/modules/mod_ahbot.conf
            sed -i 's/AuctionHouseBot.EnableSeller =.*/AuctionHouseBot.EnableSeller = 1/g' $SOURCE_LOCATION/etc/modules/mod_ahbot.conf
            sed -i 's/AuctionHouseBot.Account =.*/AuctionHouseBot.Account = 1/g' $SOURCE_LOCATION/etc/modules/mod_ahbot.conf
            sed -i 's/AuctionHouseBot.GUID =.*/AuctionHouseBot.GUID = 1/g' $SOURCE_LOCATION/etc/modules/mod_ahbot.conf
            sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = '$AHBOT_MAX_ITEM_LEVEL'/g' $SOURCE_LOCATION/etc/modules/mod_ahbot.conf
        else
            if [[ -f $SOURCE_LOCATION/etc/modules/mod_ahbot.conf.dist ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_ahbot.conf.dist
            fi

            if [[ -f $SOURCE_LOCATION/etc/modules/mod_ahbot.conf ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_ahbot.conf
            fi
        fi

        if [[ $ASSISTANT_ENABLED == "true" ]]; then
            if [[ ! -f $SOURCE_LOCATION/etc/modules/mod_assistant.conf.dist ]]; then
                printf "${COLOR_RED}The config file mod_assistant.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
                rm -rf $MYSQL_CNF
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_assistant.conf${COLOR_END}\n"

            cp $SOURCE_LOCATION/etc/modules/mod_assistant.conf.dist $SOURCE_LOCATION/etc/modules/mod_assistant.conf

            sed -i 's/Assistant.Heirlooms.Enabled  =.*/Assistant.Heirlooms.Enabled  = 0/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Glyphs.Enabled     =.*/Assistant.Glyphs.Enabled     = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Gems.Enabled       =.*/Assistant.Gems.Enabled       = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Containers.Enabled =.*/Assistant.Containers.Enabled = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Utilities.Enabled            =.*/Assistant.Utilities.Enabled            = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Utilities.NameChange.Cost    =.*/Assistant.Utilities.NameChange.Cost    = 100000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Utilities.Customize.Cost     =.*/Assistant.Utilities.Customize.Cost     = 500000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Utilities.RaceChange.Cost    =.*/Assistant.Utilities.RaceChange.Cost    = 5000000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Utilities.FactionChange.Cost =.*/Assistant.Utilities.FactionChange.Cost = 10000000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.FlightPaths.Vanilla.Enabled                  =.*/Assistant.FlightPaths.Vanilla.Enabled                  = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.FlightPaths.Vanilla.RequiredLevel            =.*/Assistant.FlightPaths.Vanilla.RequiredLevel            = 60/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.FlightPaths.Vanilla.Cost                     =.*/Assistant.FlightPaths.Vanilla.Cost                     = 250000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.FlightPaths.BurningCrusade.Enabled           =.*/Assistant.FlightPaths.BurningCrusade.Enabled           = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.FlightPaths.BurningCrusade.RequiredLevel     =.*/Assistant.FlightPaths.BurningCrusade.RequiredLevel     = 70/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.FlightPaths.BurningCrusade.Cost              =.*/Assistant.FlightPaths.BurningCrusade.Cost              = 1000000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       =.*/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.RequiredLevel =.*/Assistant.FlightPaths.WrathOfTheLichKing.RequiredLevel = 80/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.Cost          =.*/Assistant.FlightPaths.WrathOfTheLichKing.Cost          = 2500000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Apprentice.Enabled  =.*/Assistant.Professions.Apprentice.Enabled  = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Apprentice.Cost     =.*/Assistant.Professions.Apprentice.Cost     = 1000000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Journeyman.Enabled  =.*/Assistant.Professions.Journeyman.Enabled  = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Journeyman.Cost     =.*/Assistant.Professions.Journeyman.Cost     = 2500000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Expert.Enabled      =.*/Assistant.Professions.Expert.Enabled      = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Expert.Cost         =.*/Assistant.Professions.Expert.Cost         = 5000000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Artisan.Enabled     =.*/Assistant.Professions.Artisan.Enabled     = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Artisan.Cost        =.*/Assistant.Professions.Artisan.Cost        = 7500000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Master.Enabled      =.*/Assistant.Professions.Master.Enabled      = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.Master.Cost         =.*/Assistant.Professions.Master.Cost         = 12500000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.GrandMaster.Enabled =.*/Assistant.Professions.GrandMaster.Enabled = 1/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Professions.GrandMaster.Cost    =.*/Assistant.Professions.GrandMaster.Cost    = 25000000/g' $SOURCE_LOCATION/etc/modules/mod_assistant.conf
        else
            if [[ -f $SOURCE_LOCATION/etc/modules/mod_assistant.conf.dist ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_assistant.conf.dist
            fi

            if [[ -f $SOURCE_LOCATION/etc/modules/mod_assistant.conf ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_assistant.conf
            fi
        fi

        if [[ $GUILD_FUNDS_ENABLED == "true" ]]; then
            if [[ ! -f $SOURCE_LOCATION/etc/modules/mod_guildfunds.conf.dist ]]; then
                printf "${COLOR_RED}The config file mod_guildfunds.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
                rm -rf $MYSQL_CNF
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_guildfunds.conf${COLOR_END}\n"

            cp $SOURCE_LOCATION/etc/modules/mod_guildfunds.conf.dist $SOURCE_LOCATION/etc/modules/mod_guildfunds.conf

            sed -i 's/GuildFunds.Looted =.*/GuildFunds.Looted = 10/g' $SOURCE_LOCATION/etc/modules/mod_guildfunds.conf
            sed -i 's/GuildFunds.Quests =.*/GuildFunds.Quests = 3/g' $SOURCE_LOCATION/etc/modules/mod_guildfunds.conf
        else
            if [[ -f $SOURCE_LOCATION/etc/modules/mod_guildfunds.conf.dist ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_guildfunds.conf.dist
            fi

            if [[ -f $SOURCE_LOCATION/etc/modules/mod_guildfunds.conf ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_guildfunds.conf
            fi
        fi

        if [[ $LEARN_SPELLS_ENABLED == "true" ]]; then
            if [[ ! -f $SOURCE_LOCATION/etc/modules/mod_learnspells.conf.dist ]]; then
                printf "${COLOR_RED}The config file mod_learnspells.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
                rm -rf $MYSQL_CNF
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_learnspells.conf${COLOR_END}\n"

            cp $SOURCE_LOCATION/etc/modules/mod_learnspells.conf.dist $SOURCE_LOCATION/etc/modules/mod_learnspells.conf

            sed -i 's/LearnSpells.ClassSpells =.*/LearnSpells.ClassSpells = 1/g' $SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.TalentRanks =.*/LearnSpells.TalentRanks = 1/g' $SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Proficiencies =.*/LearnSpells.Proficiencies = 1/g' $SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.SpellsFromQuests =.*/LearnSpells.SpellsFromQuests = 1/g' $SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Riding.Apprentice =.*/LearnSpells.Riding.Apprentice = 0/g' $SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Riding.Journeyman =.*/LearnSpells.Riding.Journeyman = 0/g' $SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Riding.Expert =.*/LearnSpells.Riding.Expert = 0/g' $SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Riding.Artisan =.*/LearnSpells.Riding.Artisan = 0/g' $SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            sed -i 's/LearnSpells.Riding.ColdWeatherFlying =.*/LearnSpells.Riding.ColdWeatherFlying = 0/g' $SOURCE_LOCATION/etc/modules/mod_learnspells.conf
        else
            if [[ -f $SOURCE_LOCATION/etc/modules/mod_learnspells.conf.dist ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_learnspells.conf.dist
            fi

            if [[ -f $SOURCE_LOCATION/etc/modules/mod_learnspells.conf ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_learnspells.conf
            fi
        fi

        if [[ $RECRUIT_A_FRIEND_ENABLED == "true" ]]; then
            if [[ ! -f $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf.dist ]]; then
                printf "${COLOR_RED}The config file mod_recruitafriend.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
                rm -rf $MYSQL_CNF
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_recruitafriend.conf${COLOR_END}\n"

            cp $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf.dist $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf

            sed -i 's/RecruitAFriend.Duration =.*/RecruitAFriend.Duration = 90/g' $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
            sed -i 's/RecruitAFriend.MaxAccountAge =.*/RecruitAFriend.MaxAccountAge = 7/g' $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
            sed -i 's/RecruitAFriend.Rewards.Days =.*/RecruitAFriend.Rewards.Days = 30/g' $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
            sed -i 's/RecruitAFriend.Rewards.SwiftZhevra =.*/RecruitAFriend.Rewards.SwiftZhevra = 1/g' $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
            sed -i 's/RecruitAFriend.Rewards.TouringRocket =.*/RecruitAFriend.Rewards.TouringRocket = 1/g' $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
            sed -i 's/RecruitAFriend.Rewards.CelestialSteed =.*/RecruitAFriend.Rewards.CelestialSteed = 1/g' $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
        else
            if [[ -f $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf.dist ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf.dist
            fi

            if [[ -f $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_recruitafriend.conf
            fi
        fi

        if [[ $WEEKEND_BONUS_ENABLED == "true" ]]; then
            if [[ ! -f $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf.dist ]]; then
                printf "${COLOR_RED}The config file mod_weekendbonus.conf.dist is missing.${COLOR_END}\n"
                printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
                rm -rf $MYSQL_CNF
                exit $?
            fi

            printf "${COLOR_ORANGE}Updating mod_weekendbonus.conf${COLOR_END}\n"

            cp $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf.dist $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf

            sed -i 's/WeekendBonus.Multiplier.Experience =.*/WeekendBonus.Multiplier.Experience = 2.0/g' $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
            sed -i 's/WeekendBonus.Multiplier.Money =.*/WeekendBonus.Multiplier.Money = 2.0/g' $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
            sed -i 's/WeekendBonus.Multiplier.Professions =.*/WeekendBonus.Multiplier.Professions = 2/g' $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
            sed -i 's/WeekendBonus.Multiplier.Reputation =.*/WeekendBonus.Multiplier.Reputation = 2.0/g' $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
            sed -i 's/WeekendBonus.Multiplier.Proficiencies =.*/WeekendBonus.Multiplier.Proficiencies = 2/g' $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
        else
            if [[ -f $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf.dist ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf.dist
            fi

            if [[ -f $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf ]]; then
                rm -rf $SOURCE_LOCATION/etc/modules/mod_weekendbonus.conf
            fi
        fi
    fi

    printf "${COLOR_GREEN}Finished updating the config files...${COLOR_END}\n"
}

function start_server
{
    printf "${COLOR_GREEN}Starting the server...${COLOR_END}\n"

    if [[ ! -f $SOURCE_LOCATION/bin/start.sh ]] || [[ ! -f $SOURCE_LOCATION/bin/stop.sh ]]; then
        printf "${COLOR_RED}The required binaries are missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
        exit $?
    fi

    if [[ ! -z `screen -list | grep -E "auth"` ]] || [[ ! -z `screen -list | grep -E "world"` ]]; then
        printf "${COLOR_RED}The server is already running.${COLOR_END}\n"
        exit $?
    fi

    cd $SOURCE_LOCATION/bin && ./start.sh

    if [[ ! -z `screen -list | grep -E "auth"` ]]; then
        printf "${COLOR_ORANGE}To access the screen of the authserver, use the command ${COLOR_BLUE}screen -r auth${COLOR_ORANGE}.${COLOR_END}\n"
    fi

    if [[ ! -z `screen -list | grep -E "world"` ]]; then
        printf "${COLOR_ORANGE}To access the screen of the worldserver, use the command ${COLOR_BLUE}screen -r world${COLOR_ORANGE}.${COLOR_END}\n"
    fi

    printf "${COLOR_GREEN}Finished starting the server...${COLOR_END}\n"
}

function stop_server
{
    printf "${COLOR_GREEN}Stopping the server...${COLOR_END}\n"

    if [[ -z `screen -list | grep -E "auth"` ]] && [[ -z `screen -list | grep -E "world"` ]]; then
        printf "${COLOR_RED}The server is not running.${COLOR_END}\n"
    fi

    if [[ ! -z `screen -list | grep -E "world"` ]]; then
        printf "${COLOR_ORANGE}Telling the world server to shut down.${COLOR_END}\n"

        PID=$(pgrep worldserver)

        if [[ $PID != "" ]]; then
            if [[ $2 == "restart" ]]; then
                screen -S world -p 0 -X stuff "server restart 10^m"
            else
                screen -S world -p 0 -X stuff "server shutdown 10^m"
            fi

            timeout 30 tail --pid=$PID -f /dev/null
        fi
    fi

    if [[ -f $SOURCE_LOCATION/bin/stop.sh ]]; then
        if [[ ! -z `screen -list | grep -E "auth"` ]] || [[ ! -z `screen -list | grep -E "world"` ]]; then
            cd $SOURCE_LOCATION/bin && ./stop.sh
        fi
    fi

    printf "${COLOR_GREEN}Finished stopping the server...${COLOR_END}\n"
}

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
    printf "${COLOR_ORANGE}database/db ${COLOR_WHITE}| ${COLOR_BLUE}Copy all custom sql files to the core${COLOR_END}\n"
    printf "${COLOR_ORANGE}config/conf    ${COLOR_WHITE}| ${COLOR_BLUE}Updates all config files, including enabled modules, with options specified${COLOR_END}\n"
    printf "${COLOR_ORANGE}all            ${COLOR_WHITE}| ${COLOR_BLUE}Run all subparameters listed above, including stop and start${COLOR_END}\n"

    exit $?
}

if [[ $# -gt 0 ]]; then
    if [[ $1 == "both" ]] || [[ $1 == "auth" ]] || [[ $1 == "world" ]]; then
        if [[ $2 == "install" ]] || [[ $2 == "update" ]]; then
            stop_server
            install_packages
            get_source $1
            compile_source $1
            get_client_files $1
        elif [[ $2 == "database" ]] || [[ $2 == "db" ]]; then
            copy_database_files
        elif [[ $2 == "config" ]] || [[ $2 == "conf" ]]; then
            set_config $1
        elif [[ $2 == "all" ]]; then
            stop_server
            install_packages
            get_source $1
            compile_source $1
            copy_database_files
            get_client_files $1
            set_config $1
            start_server
        else
            parameters
        fi
    elif [[ $1 == "start" ]]; then
        start_server
    elif [[ $1 == "stop" ]]; then
        stop_server
    elif [[ $1 == "restart" ]]; then
        stop_server
        start_server
    else
        parameters
    fi
else
    parameters
fi
