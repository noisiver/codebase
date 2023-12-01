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

if [[ ! -f $ROOT/config.sh ]]; then
    printf "${COLOR_RED}The config file is missing. Generating one with default values.${COLOR_END}\n"
    printf "${COLOR_RED}Make sure to edit it before running this script again.${COLOR_END}\n"

    echo "MYSQL_HOSTNAME=\"127.0.0.1\"" >> $ROOT/config.sh
    echo "MYSQL_PORT=\"3306\"" >> $ROOT/config.sh
    echo "MYSQL_USERNAME=\"acore\"" >> $ROOT/config.sh
    echo "MYSQL_PASSWORD=\"acore\"" >> $ROOT/config.sh
    echo "MYSQL_DATABASES_AUTH=\"acore_auth\"" >> $ROOT/config.sh
    echo "MYSQL_DATABASES_CHARACTERS=\"acore_characters\"" >> $ROOT/config.sh
    echo "MYSQL_DATABASES_WORLD=\"acore_world\"" >> $ROOT/config.sh
    echo "WORLD_NAME=\"AzerothCore\"" >> $ROOT/config.sh
    echo "WORLD_MOTD=\"Welcome to AzerothCore.\"" >> $ROOT/config.sh
    echo "WORLD_ADDRESS=\"127.0.0.1\" # SET THIS TO THE ADDRESS THE CLIENT CONNECTS TO" >> $ROOT/config.sh
    echo "WORLD_PORT=\"9644\" # CHANGE THIS TO BE UNIQUE IF MULTIPLE WORLD SERVERS ARE RUNNING ON THE SAME SYSTEM" >> $ROOT/config.sh
    echo "AUTH_ADDRESS=\"127.0.0.1\" # SET THIS TO THE ADDRESS OF THE SERVER RUNNING THE TOCLOUD9 PROCESSES" >> $ROOT/config.sh
    echo "LOCAL_ADDRESS=\"127.0.0.1\" # SET THIS TO THE ADDRESS OF THIS SYSTEM" >> $ROOT/config.sh
    echo "NODE_ID=\"1\" # CHANGE THIS TO BE UNIQUE IF MULTIPLE WORLD SERVERS ARE RUNNING ON THE SAME SYSTEM" >> $ROOT/config.sh
    echo "PRELOAD_MAP_GRIDS=\"false\"" >> $ROOT/config.sh
    echo "SET_CREATURES_ACTIVE=\"false\"" >> $ROOT/config.sh
    echo "PROGRESSION_ACTIVE_PATCH=\"21\"" >> $ROOT/config.sh
    echo "PROGRESSION_ICECROWN_CITADEL_AURA=\"0\"" >> $ROOT/config.sh
    echo "ACCOUNT_BOUND_ENABLED=\"false\"" >> $ROOT/config.sh
    echo "AHBOT_ENABLED=\"false\"" >> config.sh
    echo "AHBOT_MIN_ITEMS=\"200\"" >> config.sh
    echo "AHBOT_MAX_ITEMS=\"200\"" >> config.sh
    echo "APPRECIATION_ENABLED=\"false\"" >> config.sh
    echo "ASSISTANT_ENABLED=\"false\"" >> config.sh
    echo "GUILD_FUNDS_ENABLED=\"false\"" >> config.sh
    echo "GROUP_QUESTS_ENABLED=\"false\"" >> config.sh
    echo "JUNK_TO_GOLD_ENABLED=\"false\"" >> config.sh
    echo "LEARN_SPELLS_ENABLED=\"false\"" >> config.sh
    echo "RECRUIT_A_FRIEND_ENABLED=\"false\"" >> config.sh
    echo "WEEKEND_BONUS_ENABLED=\"false\"" >> config.sh
    echo "# Eastern Kingdoms, Kalimdor, Outland, Northrend and Deeprun Tram: 0,1,369,530,571" >> $ROOT/config.sh
    echo "# All dungeon, raid, battleground and arena maps: 30,33,34,36,43,44,47,48,70,90,109,129,169,189,209,229,230,249,269,289,309,329,349,389,409,429,469,489,509,529,531,532,533,534,540,542,543,544,545,546,547,548,550,552,553,554,555,556,557,558,559,560,562,564,565,566,568,572,574,575,576,578,580,585,595,598,599,600,601,602,603,604,607,608,615,616,617,618,619,624,628,631,632,649,650,658,668,724" >> $ROOT/config.sh
    echo "AVAILABLE_MAPS=\"\"" >> $ROOT/config.sh
    echo "# DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING" >> $ROOT/config.sh
    echo "SOURCE_AZEROTHCORE_REPOSITORY=\"https://github.com/walkline/azerothcore-wotlk.git\"" >> $ROOT/config.sh
    echo "SOURCE_AZEROTHCORE_BRANCH=\"cluster-mode\"" >> $ROOT/config.sh
    echo "SOURCE_TOCLOUD9_REPOSITORY=\"https://github.com/walkline/ToCloud9.git\"" >> $ROOT/config.sh
    echo "SOURCE_TOCLOUD9_BRANCH=\"master\"" >> $ROOT/config.sh
    echo "WORLD_ID=\"1\"" >> $ROOT/config.sh
    echo "DEFAULT_WORLD_PORT=\"8085\"" >> $ROOT/config.sh

    exit $?
fi

source "$ROOT/config.sh"

if [[ $PROGRESSION_ACTIVE_PATCH -lt 12 ]]; then
    AHBOT_MAX_ITEM_LEVEL="92"
elif [[ $PROGRESSION_ACTIVE_PATCH -lt 17 ]]; then
    AHBOT_MAX_ITEM_LEVEL="164"
elif [[ $PROGRESSION_ACTIVE_PATCH -lt 18 ]]; then
    AHBOT_MAX_ITEM_LEVEL="213"
elif [[ $PROGRESSION_ACTIVE_PATCH -lt 19 ]]; then
    AHBOT_MAX_ITEM_LEVEL="226"
elif [[ $PROGRESSION_ACTIVE_PATCH -lt 20 ]]; then
    AHBOT_MAX_ITEM_LEVEL="245"
else
    AHBOT_MAX_ITEM_LEVEL="0"
fi

if [[ $PROGRESSION_ACTIVE_PATCH -lt 15 ]]; then
    GUILD_FUNDS_ENABLED="false"
fi

if [[ $PROGRESSION_ACTIVE_PATCH -lt 17 ]]; then
    ACCOUNT_BOUND_ENABLED="false"
    RECRUIT_A_FRIEND_ENABLED="false"
fi

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

    if [[ ! -d $ROOT/source/tocloud9 ]]; then
        git clone --recursive --depth 1 --branch $SOURCE_TOCLOUD9_BRANCH $SOURCE_TOCLOUD9_REPOSITORY $ROOT/source/tocloud9
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    else
        cd $ROOT/source/tocloud9

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

    if [[ ! -d $ROOT/source/azerothcore ]]; then
        git clone --recursive --depth 1 --branch $SOURCE_AZEROTHCORE_BRANCH $SOURCE_AZEROTHCORE_REPOSITORY $ROOT/source/azerothcore
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    else
        cd $ROOT/source/azerothcore

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

    if [[ $ACCOUNT_BOUND_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/modules/mod-accountbound ]]; then
            git clone --depth 1 --branch master https://github.com/noisiver/mod-accountbound.git $ROOT/source/modules/mod-accountbound
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to download the source code of mod-accountbound"
                exit $?
            fi
        else
            cd $ROOT/source/modules/mod-accountbound

            git pull
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to update the source code of mod-accountbound"
                exit $?
            fi

            git reset --hard origin/master
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to update the source code of mod-accountbound"
                exit $?
            fi
        fi
    else
        if [[ -d $ROOT/source/modules/mod-accountbound ]]; then
            rm -rf $ROOT/source/modules/mod-accountbound

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi

    if [[ $AHBOT_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-ah-bot ]]; then
            git clone --depth 1 --branch master https://github.com/azerothcore/mod-ah-bot.git $ROOT/source/azerothcore/modules/mod-ah-bot
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        else
            cd $ROOT/source/azerothcore/modules/mod-ah-bot

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
        if [[ -d $ROOT/source/azerothcore/modules/mod-ah-bot ]]; then
            rm -rf $ROOT/source/azerothcore/modules/mod-ah-bot

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi

    : 'if [[ $APPRECIATION_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-appreciation ]]; then
            git clone --depth 1 --branch master https://github.com/noisiver/mod-appreciation.git $ROOT/source/azerothcore/modules/mod-appreciation
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        else
            cd $ROOT/source/azerothcore/modules/mod-appreciation

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
        if [[ -d $ROOT/source/azerothcore/modules/mod-appreciation ]]; then
            rm -rf $ROOT/source/azerothcore/modules/mod-appreciation

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi'

    if [[ $ASSISTANT_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-assistant ]]; then
            git clone --depth 1 --branch master https://github.com/noisiver/mod-assistant.git $ROOT/source/azerothcore/modules/mod-assistant
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        else
            cd $ROOT/source/azerothcore/modules/mod-assistant

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
        if [[ -d $ROOT/source/azerothcore/modules/mod-assistant ]]; then
            rm -rf $ROOT/source/azerothcore/modules/mod-assistant

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi

    if [[ $GUILD_FUNDS_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-guildfunds ]]; then
            git clone --depth 1 --branch master https://github.com/noisiver/mod-guildfunds.git $ROOT/source/azerothcore/modules/mod-guildfunds
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        else
            cd $ROOT/source/azerothcore/modules/mod-guildfunds

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
        if [[ -d $ROOT/source/azerothcore/modules/mod-guildfunds ]]; then
            rm -rf $ROOT/source/azerothcore/modules/mod-guildfunds

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi

    if [[ $GROUP_QUESTS_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-groupquests ]]; then
            git clone --depth 1 --branch master https://github.com/noisiver/mod-groupquests.git $ROOT/source/azerothcore/modules/mod-groupquests
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        else
            cd $ROOT/source/azerothcore/modules/mod-groupquests

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
        if [[ -d $ROOT/source/azerothcore/modules/mod-groupquests ]]; then
            rm -rf $ROOT/source/azerothcore/modules/mod-groupquests

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi

    if [[ $JUNK_TO_GOLD_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-junk-to-gold ]]; then
            git clone --depth 1 --branch master https://github.com/noisiver/mod-junk-to-gold.git $ROOT/source/azerothcore/modules/mod-junk-to-gold
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        else
            cd $ROOT/source/azerothcore/modules/mod-junk-to-gold

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
        if [[ -d $ROOT/source/azerothcore/modules/mod-junk-to-gold ]]; then
            rm -rf $ROOT/source/azerothcore/modules/mod-junk-to-gold

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi

    if [[ $LEARN_SPELLS_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-learnspells ]]; then
            git clone --depth 1 --branch master https://github.com/noisiver/mod-learnspells.git $ROOT/source/azerothcore/modules/mod-learnspells
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        else
            cd $ROOT/source/azerothcore/modules/mod-learnspells

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
        if [[ -d $ROOT/source/azerothcore/modules/mod-learnspells ]]; then
            rm -rf $ROOT/source/azerothcore/modules/mod-learnspells

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi

    if [[ $RECRUIT_A_FRIEND_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-recruitafriend ]]; then
            git clone --depth 1 --branch master https://github.com/noisiver/mod-recruitafriend.git $ROOT/source/azerothcore/modules/mod-recruitafriend
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        else
            cd $ROOT/source/azerothcore/modules/mod-recruitafriend

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
        if [[ -d $ROOT/source/azerothcore/modules/mod-recruitafriend ]]; then
            rm -rf $ROOT/source/azerothcore/modules/mod-recruitafriend

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi

    if [[ $WEEKEND_BONUS_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-weekendbonus ]]; then
            git clone --depth 1 --branch master https://github.com/noisiver/mod-weekendbonus.git $ROOT/source/azerothcore/modules/mod-weekendbonus
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        else
            cd $ROOT/source/azerothcore/modules/mod-weekendbonus

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
        if [[ -d $ROOT/source/azerothcore/modules/mod-weekendbonus ]]; then
            rm -rf $ROOT/source/azerothcore/modules/mod-weekendbonus

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi

    printf "${COLOR_GREEN}Finished downloading the source code...${COLOR_END}\n"
}

function compile_source
{
    printf "${COLOR_GREEN}Compiling the source code...${COLOR_END}\n"

    cd $ROOT/source/tocloud9

    printf "${COLOR_ORANGE}Building libsidecar.${COLOR_END}\n"

    go build -o bin/libsidecar.so -buildmode=c-shared ./game-server/libsidecar/
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    cp $ROOT/source/tocloud9/bin/libsidecar.so $ROOT/source/azerothcore/deps/libsidecar/libsidecar.so
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    if [[ $EUID != 0 ]]; then
        sudo cp $ROOT/source/tocloud9/bin/libsidecar.so /usr/lib/libsidecar.so
    else
        cp $ROOT/source/tocloud9/bin/libsidecar.so /usr/lib/libsidecar.so
    fi
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    printf "${COLOR_ORANGE}Building worldserver.${COLOR_END}\n"

    mkdir -p $ROOT/source/azerothcore/build && cd $_

    for i in {1..2}; do
        cmake ../ -DCMAKE_INSTALL_PREFIX=$ROOT/source/azerothcore -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DSCRIPTS=static -DAPPS_BUILD="world-only" -DUSE_REAL_LIBSIDECAR=ON
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

    echo "#!/bin/bash" > $ROOT/source/azerothcore/bin/start.sh
    echo "screen -AmdS world-$NODE_ID ./world.sh" >> $ROOT/source/azerothcore/bin/start.sh
    chmod +x $ROOT/source/azerothcore/bin/start.sh

    echo "#!/bin/bash" > $ROOT/source/azerothcore/bin/stop.sh
    echo "screen -X -S \"world-$NODE_ID\" quit" >> $ROOT/source/azerothcore/bin/stop.sh
    chmod +x $ROOT/source/azerothcore/bin/stop.sh

    echo "#!/bin/bash" > $ROOT/source/azerothcore/bin/world.sh
    echo "while :; do" >> $ROOT/source/azerothcore/bin/world.sh
    echo "  TC9_CONFIG_FILE=$ROOT/source/azerothcore/bin/config.yml AC_WORLD_SERVER_PORT="$WORLD_PORT" ./worldserver" >> $ROOT/source/azerothcore/bin/world.sh
    echo "  if [[ \$? == 0 ]]; then" >> $ROOT/source/azerothcore/bin/world.sh
    echo "    break" >> $ROOT/source/azerothcore/bin/world.sh
    echo "  fi" >> $ROOT/source/azerothcore/bin/world.sh
    echo "  sleep 5" >> $ROOT/source/azerothcore/bin/world.sh
    echo "done" >> $ROOT/source/azerothcore/bin/world.sh
    chmod +x $ROOT/source/azerothcore/bin/world.sh

    printf "${COLOR_GREEN}Finished compiling the source code...${COLOR_END}\n"
}

function get_client_files
{
    if [[ ! -f $ROOT/client.version ]]; then
        VERSION="0"
    else
        VERSION=$(<$ROOT/client.version)
    fi

    if [[ ! -d $ROOT/source/azerothcore/bin/Cameras ]] || [[ ! -d $ROOT/source/azerothcore/bin/dbc ]] || [[ ! -d $ROOT/source/azerothcore/bin/maps ]] || [[ ! -d $ROOT/source/azerothcore/bin/mmaps ]] || [[ ! -d $ROOT/source/azerothcore/bin/vmaps ]]; then
        VERSION=0
    fi

    AVAILABLE_VERSION=$(git ls-remote --tags --sort="v:refname" https://github.com/wowgaming/client-data.git | tail -n1 | cut --delimiter='/' --fields=3 | sed 's/v//')

    if [[ $VERSION != $AVAILABLE_VERSION ]]; then
        printf "${COLOR_GREEN}Downloading the client data files...${COLOR_END}\n"

        if [[ -d $ROOT/source/azerothcore/bin/Cameras ]]; then
            rm -rf $ROOT/source/azerothcore/bin/Cameras
        fi
        if [[ -d $ROOT/source/azerothcore/bin/dbc ]]; then
            rm -rf $ROOT/source/azerothcore/bin/dbc
        fi
        if [[ -d $ROOT/source/azerothcore/bin/maps ]]; then
            rm -rf $ROOT/source/azerothcore/bin/maps
        fi
        if [[ -d $ROOT/source/azerothcore/bin/mmaps ]]; then
            rm -rf $ROOT/source/azerothcore/bin/mmaps
        fi
        if [[ -d $ROOT/source/azerothcore/bin/vmaps ]]; then
            rm -rf $ROOT/source/azerothcore/bin/vmaps
        fi

        curl -f -L https://github.com/wowgaming/client-data/releases/download/v${AVAILABLE_VERSION}/data.zip -o $ROOT/source/azerothcore/bin/data.zip
        if [[ $? -ne 0 ]]; then
            rm -rf $ROOT/source/azerothcore/bin/data.zip
            exit $?
        fi

        unzip -o "$ROOT/source/azerothcore/bin/data.zip" -d "$ROOT/source/azerothcore/bin/"
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        rm -rf $ROOT/source/azerothcore/bin/data.zip

        echo $AVAILABLE_VERSION > $ROOT/client.version

        printf "${COLOR_GREEN}Finished downloading the client data files...${COLOR_END}\n"
    fi
}

function import_database_files
{
    printf "${COLOR_GREEN}Importing the database files...${COLOR_END}\n"

    MYSQL_CNF="$ROOT/mysql.cnf"
    echo "[client]" > $MYSQL_CNF
    echo "host=\"$MYSQL_HOSTNAME\"" >> $MYSQL_CNF
    echo "port=\"$MYSQL_PORT\"" >> $MYSQL_CNF
    echo "user=\"$MYSQL_USERNAME\"" >> $MYSQL_CNF
    echo "password=\"$MYSQL_PASSWORD\"" >> $MYSQL_CNF

    if [[ -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names -e "SHOW DATABASES LIKE '$MYSQL_DATABASES_AUTH'"` ]]; then
        printf "${COLOR_RED}The database named $MYSQL_DATABASES_AUTH is inaccessible by the user named $MYSQL_USERNAME.${COLOR_END}\n"
        rm -rf $MYSQL_CNF
        exit $?
    fi

    if [[ -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names -e "SHOW DATABASES LIKE '$MYSQL_DATABASES_CHARACTERS'"` ]]; then
        printf "${COLOR_RED}The database named $MYSQL_DATABASES_CHARACTERS is inaccessible by the user named $MYSQL_USERNAME.${COLOR_END}\n"
        rm -rf $MYSQL_CNF
        exit $?
    fi

    if [[ -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names -e "SHOW DATABASES LIKE '$MYSQL_DATABASES_WORLD'"` ]] && [[ $1 == "world" || $1 == "both" ]]; then
        printf "${COLOR_RED}The database named $MYSQL_DATABASES_WORLD is inaccessible by the user named $MYSQL_USERNAME.${COLOR_END}\n"
        rm -rf $MYSQL_CNF
        exit $?
    fi

    if [[ ! -d $ROOT/source/azerothcore/data/sql/base/db_auth ]] || [[ ! -d $ROOT/source/azerothcore/data/sql/updates/db_auth ]] || [[ ! -d $ROOT/source/azerothcore/data/sql/custom/db_auth ]] || [[ ! -d $ROOT/source/azerothcore/data/sql/base/db_characters ]] || [[ ! -d $ROOT/source/azerothcore/data/sql/updates/db_characters ]] || [[ ! -d $ROOT/source/azerothcore/data/sql/custom/db_characters ]] || [[ ! -d $ROOT/source/azerothcore/data/sql/base/db_world ]] || [[ ! -d $ROOT/source/azerothcore/data/sql/updates/db_world ]] || [[ ! -d $ROOT/source/azerothcore/data/sql/custom/db_world ]]; then
        printf "${COLOR_RED}There are no database files where there should be.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
        rm -rf $MYSQL_CNF
        exit $?
    fi

    if [[ ! -d $ROOT/sql/auth ]]; then
        mkdir -p $ROOT/sql/auth
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi

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

    # A temporary workaround
    printf "${COLOR_ORANGE}Downloading 000001_create_guild_invites_table.down.sql${COLOR_END}\n"
    curl -s -S -f https://github.com/walkline/ToCloud9/raw/master/sql/characters/mysql/000001_create_guild_invites_table.down.sql -o $ROOT/source/azerothcore/data/sql/custom/db_characters/000001_create_guild_invites_table.down.sql
    if [[ $? -ne 0 ]]; then
        rm -rf $MYSQL_CNF
        exit $?
    fi

    printf "${COLOR_ORANGE}Downloading 000001_create_guild_invites_table.up.sql${COLOR_END}\n"
    curl -s -S -f https://github.com/walkline/ToCloud9/raw/master/sql/characters/mysql/000001_create_guild_invites_table.up.sql -o $ROOT/source/azerothcore/data/sql/custom/db_characters/000001_create_guild_invites_table.up.sql
    if [[ $? -ne 0 ]]; then
        rm -rf $MYSQL_CNF
        exit $?
    fi

    printf "${COLOR_ORANGE}Downloading 000002_add_auto_increment_to_mail.up.sql${COLOR_END}\n"
    curl -s -S -f https://github.com/walkline/ToCloud9/raw/master/sql/characters/mysql/000002_add_auto_increment_to_mail.up.sql -o $ROOT/source/azerothcore/data/sql/custom/db_characters/000002_add_auto_increment_to_mail.up.sql
    if [[ $? -ne 0 ]]; then
        rm -rf $MYSQL_CNF
        exit $?
    fi

    if [[ `ls -1 $ROOT/source/azerothcore/data/sql/base/db_auth/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/azerothcore/data/sql/base/db_auth/*.sql; do
            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_AUTH -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    else
        printf "${COLOR_RED}The required files for the auth database are missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
    fi

    if [[ `ls -1 $ROOT/source/azerothcore/data/sql/updates/db_auth/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/azerothcore/data/sql/updates/db_auth/*.sql; do
            FILENAME=$(basename $f)
            HASH=($(sha1sum $f))

            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_AUTH -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi

            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi

    if [[ `ls -1 $ROOT/source/azerothcore/data/sql/custom/db_auth/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/azerothcore/data/sql/custom/db_auth/*.sql; do
            FILENAME=$(basename $f)
            HASH=($(sha1sum $f))

            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_AUTH -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi

            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi

    if [[ `ls -1 $ROOT/sql/auth/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/sql/auth/*.sql; do
            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi

    if [[ `ls -1 $ROOT/source/azerothcore/data/sql/base/db_characters/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/azerothcore/data/sql/base/db_characters/*.sql; do
            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_CHARACTERS -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_CHARACTERS < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    else
        printf "${COLOR_RED}The required files for the characters database are missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
    fi

    if [[ `ls -1 $ROOT/source/azerothcore/data/sql/updates/db_characters/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/azerothcore/data/sql/updates/db_characters/*.sql; do
            FILENAME=$(basename $f)
            HASH=($(sha1sum $f))

            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_CHARACTERS -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_CHARACTERS < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi

            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_CHARACTERS -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi

    if [[ `ls -1 $ROOT/source/azerothcore/data/sql/custom/db_characters/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/azerothcore/data/sql/custom/db_characters/*.sql; do
            FILENAME=$(basename $f)
            HASH=($(sha1sum $f))

            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_CHARACTERS -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_CHARACTERS < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi

            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_CHARACTERS -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi

    if [[ `ls -1 $ROOT/sql/characters/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/sql/characters/*.sql; do
            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_CHARACTERS < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi

    if [[ `ls -1 $ROOT/source/azerothcore/data/sql/base/db_world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/azerothcore/data/sql/base/db_world/*.sql; do
            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    else
        printf "${COLOR_RED}The required files for the world database are missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
    fi

    if [[ `ls -1 $ROOT/source/azerothcore/data/sql/updates/db_world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/azerothcore/data/sql/updates/db_world/*.sql; do
            FILENAME=$(basename $f)
            HASH=($(sha1sum $f))

            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi

            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi

    if [[ `ls -1 $ROOT/source/azerothcore/data/sql/custom/db_world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/azerothcore/data/sql/custom/db_world/*.sql; do
            FILENAME=$(basename $f)
            HASH=($(sha1sum $f))

            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi

            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi

    if [[ `ls -1 $ROOT/sql/world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/sql/world/*.sql; do
            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi

    if [[ $ACCOUNT_BOUND_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/modules/mod-accountbound/data/sql/db-auth/base ]] || [[ ! -d $ROOT/source/modules/mod-accountbound/data/sql/db-world/base ]]; then
            printf "${COLOR_RED}The account bound module is enabled but the files aren't where they should be.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            notify_telegram "An error occurred while trying to import the database files"
            exit $?
        fi

        if [[ `ls -1 $ROOT/source/modules/mod-accountbound/data/sql/db-auth/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $ROOT/source/modules/mod-accountbound/data/sql/db-auth/base/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_AUTH -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                    continue;
                fi

                printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH < $f
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf $MYSQL_CNF
                    exit $?
                fi

                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf $MYSQL_CNF
                    exit $?
                fi
            done
        fi

        if [[ `ls -1 $ROOT/source/modules/mod-accountbound/data/sql/db-world/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $ROOT/source/modules/mod-accountbound/data/sql/db-world/base/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                    continue;
                fi

                printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf $MYSQL_CNF
                    exit $?
                fi

                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf $MYSQL_CNF
                    exit $?
                fi
            done
        fi

        mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "UPDATE mod_auctionhousebot SET minitems='$AHBOT_MIN_ITEMS', maxitems='$AHBOT_MAX_ITEMS'"
        if [[ $? -ne 0 ]]; then
            notify_telegram "An error occurred while trying to import the database files"
            rm -rf $MYSQL_CNF
            exit $?
        fi
    fi

    if [[ $AHBOT_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-ah-bot/data/sql/db-world/base ]]; then
            printf "${COLOR_RED}The auction house bot module is enabled but the files aren't where they should be.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        if [[ `ls -1 $ROOT/source/azerothcore/modules/mod-ah-bot/data/sql/db-world/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $ROOT/source/azerothcore/modules/mod-ah-bot/data/sql/db-world/base/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                    continue;
                fi

                printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi

                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi
            done
        fi

        mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "UPDATE mod_auctionhousebot SET minitems='$AHBOT_MIN_ITEMS', maxitems='$AHBOT_MAX_ITEMS'"
        if [[ $? -ne 0 ]]; then
            rm -rf $MYSQL_CNF
            exit $?
        fi
    fi

    if [[ $APPRECIATION_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-appreciation/data/sql/db-world/base ]]; then
            printf "${COLOR_RED}The appreciation module is enabled but the files aren't where they should be.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        if [[ `ls -1 $ROOT/source/azerothcore/modules/mod-appreciation/data/sql/db-world/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $ROOT/source/azerothcore/modules/mod-appreciation/data/sql/db-world/base/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                    continue;
                fi

                printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi

                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi
            done
        fi
    fi

    if [[ $ASSISTANT_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-assistant/data/sql/db-world/base ]]; then
            printf "${COLOR_RED}The assistant module is enabled but the files aren't where they should be.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        if [[ `ls -1 $ROOT/source/azerothcore/modules/mod-assistant/data/sql/db-world/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $ROOT/source/azerothcore/modules/mod-assistant/data/sql/db-world/base/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                    continue;
                fi

                printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi

                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi
            done
        fi
    fi

    if [[ $GROUP_QUESTS_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-groupquests/data/sql/db-world/base ]]; then
            printf "${COLOR_RED}The group quests module is enabled but the files aren't where they should be.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        if [[ `ls -1 $ROOT/source/azerothcore/modules/mod-groupquests/data/sql/db-world/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $ROOT/source/azerothcore/modules/mod-groupquests/data/sql/db-world/base/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                    continue;
                fi

                printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi

                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi
            done
        fi
    fi

    if [[ $RECRUIT_A_FRIEND_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/azerothcore/modules/mod-recruitafriend/data/sql/db-auth/base ]]; then
            printf "${COLOR_RED}The recruit-a-friend module is enabled but the files aren't where they should be.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        if [[ `ls -1 $ROOT/source/azerothcore/modules/mod-recruitafriend/data/sql/db-auth/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $ROOT/source/azerothcore/modules/mod-recruitafriend/data/sql/db-auth/base/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_AUTH -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                    continue;
                fi

                printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH < $f
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi

                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi
            done
        fi
    fi

    printf "${COLOR_ORANGE}Adding to the realmlist (id: $WORLD_ID, name: $WORLD_NAME, address $WORLD_ADDRESS, port $WORLD_PORT)${COLOR_END}\n"
    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH -e "DELETE FROM realmlist WHERE id='$WORLD_ID';INSERT INTO realmlist (id, name, address, localAddress, localSubnetMask, port) VALUES ('$WORLD_ID', '$WORLD_NAME', '$WORLD_ADDRESS', '$WORLD_ADDRESS', '255.255.255.0', '$DEFAULT_WORLD_PORT')"
    if [[ $? -ne 0 ]]; then
        rm -rf $MYSQL_CNF
        exit $?
    fi

    printf "${COLOR_ORANGE}Updating message of the day${COLOR_END}\n"
    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_AUTH -e "DELETE FROM motd WHERE realmid='$WORLD_ID';INSERT INTO motd (realmid, text) VALUES ('$WORLD_ID', '$WORLD_MOTD')"
    if [[ $? -ne 0 ]]; then
        rm -rf $MYSQL_CNF
        exit $?
    fi

    rm -rf $MYSQL_CNF

    printf "${COLOR_GREEN}Finished importing the database files...${COLOR_END}\n"
}

function copy_dbc_files
{
    printf "${COLOR_GREEN}Copying modified client data files...${COLOR_END}\n"

    if [[ ! -d $ROOT/dbc ]]; then
        mkdir $ROOT/dbc
    fi

    if [[ `ls -1 $ROOT/dbc/*.dbc 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/dbc/*.dbc; do
            printf "${COLOR_ORANGE}Copying "$(basename $f)"${COLOR_END}\n"
            cp $f $ROOT/source/azerothcore/bin/dbc/$(basename $f)
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        done
    else
        printf "${COLOR_ORANGE}No files found in the directory${COLOR_END}\n"
    fi

    printf "${COLOR_GREEN}Finished copying modified client data files...${COLOR_END}\n"
}

function set_config
{
    printf "${COLOR_GREEN}Updating the config files...${COLOR_END}\n"

    if [[ ! -f $ROOT/source/tocloud9/config.yml.example ]]; then
        printf "${COLOR_RED}The config file config.yml.example is missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
        exit $?
    fi

    printf "${COLOR_ORANGE}Updating config.yml${COLOR_END}\n"

    cp $ROOT/source/tocloud9/config.yml.example $ROOT/source/azerothcore/bin/config.yml

    sed -i 's/  auth: \&defaultAuthDB.*/  auth: \&defaultAuthDB "'$MYSQL_USERNAME':'$MYSQL_PASSWORD'@tcp('$MYSQL_HOSTNAME':'$MYSQL_PORT')\/'$MYSQL_DATABASE_AUTH'"/g' $ROOT/source/azerothcore/bin/config.yml
    sed -i 's/  characters: \&defaultCharactersDB.*/  characters: \&defaultCharactersDB "'$MYSQL_USERNAME':'$MYSQL_PASSWORD'@tcp('$MYSQL_HOSTNAME':'$MYSQL_PORT')\/'$MYSQL_DATABASE_CHARACTERS'"/g' $ROOT/source/azerothcore/bin/config.yml
    sed -i 's/  world: \&defaultWorldDB.*/  world: \&defaultWorldDB "'$MYSQL_USERNAME':'$MYSQL_PASSWORD'@tcp('$MYSQL_HOSTNAME':'$MYSQL_PORT')\/'$MYSQL_DATABASE_WORLD'"/g' $ROOT/source/azerothcore/bin/config.yml
    sed -i 's/  schemaType: \&defaultSchemaType.*/  schemaType: \&defaultSchemaType "ac"/g' $ROOT/source/azerothcore/bin/config.yml
    sed -i 's/nats: \&defaultNatsUrl.*/nats: \&defaultNatsUrl "nats:\/\/'$AUTH_ADDRESS':4222"/g' $ROOT/source/azerothcore/bin/config.yml
    sed -i 's/  serversRegistryServiceAddress:.*/  serversRegistryServiceAddress: '$AUTH_ADDRESS':8999/g' $ROOT/source/azerothcore/bin/config.yml
    sed -i 's/  charactersServiceAddress:.*/  charactersServiceAddress: "'$AUTH_ADDRESS':8991"/g' $ROOT/source/azerothcore/bin/config.yml
    sed -i 's/  chatServiceAddress:.*/  chatServiceAddress: "'$AUTH_ADDRESS':8992"/g' $ROOT/source/azerothcore/bin/config.yml
    sed -i 's/  guildsServiceAddress:.*/  guildsServiceAddress: "'$AUTH_ADDRESS':8995"/g' $ROOT/source/azerothcore/bin/config.yml
    sed -i 's/  mailServiceAddress:.*/  mailServiceAddress: "'$AUTH_ADDRESS':8997"/g' $ROOT/source/azerothcore/bin/config.yml
    sed -i 's/  preferredHostname:.*/  preferredHostname: "'$LOCAL_ADDRESS'"/g' $ROOT/source/azerothcore/bin/config.yml
    sed -i 's/  guidProviderServiceAddress:.*/  guidProviderServiceAddress: "'$AUTH_ADDRESS':8996"/g' $ROOT/source/azerothcore/bin/config.yml

    if [[ ! -f $ROOT/source/azerothcore/etc/worldserver.conf.dist ]]; then
        printf "${COLOR_RED}The config file worldserver.conf.dist is missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
        exit $?
    fi

    printf "${COLOR_ORANGE}Updating worldserver.conf${COLOR_END}\n"

    cp $ROOT/source/azerothcore/etc/worldserver.conf.dist $ROOT/source/azerothcore/etc/worldserver.conf

    sed -i 's/LoginDatabaseInfo     =.*/LoginDatabaseInfo     = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASES_AUTH'"/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/WorldDatabaseInfo     =.*/WorldDatabaseInfo     = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASES_WORLD'"/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/CharacterDatabaseInfo =.*/CharacterDatabaseInfo = "'$MYSQL_HOSTNAME';'$MYSQL_PORT';'$MYSQL_USERNAME';'$MYSQL_PASSWORD';'$MYSQL_DATABASES_CHARACTERS'"/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/RealmID =.*/RealmID = '$WORLD_ID'/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/WorldServerPort =.*/WorldServerPort = '$DEFAULT_WORLD_PORT'/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/GameType =.*/GameType = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/RealmZone =.*/RealmZone = 2/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Expansion =.*/Expansion = 2/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/PlayerLimit =.*/PlayerLimit = 1000/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/StrictPlayerNames =.*/StrictPlayerNames = 3/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/StrictCharterNames =.*/StrictCharterNames = 3/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/StrictPetNames =.*/StrictPetNames = 3/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/AllowPlayerCommands =.*/AllowPlayerCommands = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Quests.IgnoreRaid =.*/Quests.IgnoreRaid = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    if [[ $PRELOAD_MAP_GRIDS == "true" ]]; then
        sed -i 's/PreloadAllNonInstancedMapGrids =.*/PreloadAllNonInstancedMapGrids = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
        sed -i 's/GridUnload =.*/GridUnload = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf

        if [[ $SET_CREATURES_ACTIVE == "true" ]]; then
            sed -i 's/SetAllCreaturesWithWaypointMovementActive =.*/SetAllCreaturesWithWaypointMovementActive = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
        else
            sed -i 's/SetAllCreaturesWithWaypointMovementActive =.*/SetAllCreaturesWithWaypointMovementActive = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
        fi
    else
        sed -i 's/PreloadAllNonInstancedMapGrids =.*/PreloadAllNonInstancedMapGrids = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
        sed -i 's/SetAllCreaturesWithWaypointMovementActive =.*/SetAllCreaturesWithWaypointMovementActive = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
        sed -i 's/GridUnload =.*/GridUnload = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    fi
    sed -i 's/Minigob.Manabonk.Enable =.*/Minigob.Manabonk.Enable = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.XP.Kill      =.*/Rate.XP.Kill      = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.XP.Quest     =.*/Rate.XP.Quest     = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.XP.Quest.DF  =.*/Rate.XP.Quest.DF  = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.XP.Explore   =.*/Rate.XP.Explore   = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.XP.Pet       =.*/Rate.XP.Pet       = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.Rest.InGame                 =.*/Rate.Rest.InGame                 = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.Rest.Offline.InTavernOrCity =.*/Rate.Rest.Offline.InTavernOrCity = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Rate.Rest.Offline.InWilderness   =.*/Rate.Rest.Offline.InWilderness   = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/GM.LoginState =.*/GM.LoginState = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/GM.Visible =.*/GM.Visible = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/GM.Chat =.*/GM.Chat = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/GM.WhisperingTo =.*/GM.WhisperingTo = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/GM.InGMList.Level =.*/GM.InGMList.Level = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/GM.InWhoList.Level =.*/GM.InWhoList.Level = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/GM.StartLevel = .*/GM.StartLevel = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/GM.AllowInvite =.*/GM.AllowInvite = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/GM.AllowFriend =.*/GM.AllowFriend = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/GM.LowerSecurity =.*/GM.LowerSecurity = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/LeaveGroupOnLogout.Enabled =.*/LeaveGroupOnLogout.Enabled = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Group.Raid.LevelRestriction =.*/Group.Raid.LevelRestriction = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Progression.Patch =.*/Progression.Patch = '$PROGRESSION_ACTIVE_PATCH'/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Progression.IcecrownCitadel.Aura =.*/Progression.IcecrownCitadel.Aura = '$PROGRESSION_ICECROWN_CITADEL_AURA'/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Progression.QuestInfo.Enforced =.*/Progression.QuestInfo.Enforced = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Progression.DungeonFinder.Enforced =.*/Progression.DungeonFinder.Enforced = 1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/DBC.EnforceItemAttributes =.*/DBC.EnforceItemAttributes = 0/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/MapUpdate.Threads =.*/MapUpdate.Threads = '$(nproc)'/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/MinWorldUpdateTime =.*/MinWorldUpdateTime = 10/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/MapUpdateInterval =.*/MapUpdateInterval = 100/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Cluster.Enabled=.*/Cluster.Enabled=1/g' $ROOT/source/azerothcore/etc/worldserver.conf
    sed -i 's/Cluster.AvailableMaps=.*/Cluster.AvailableMaps="'$AVAILABLE_MAPS'"/g' $ROOT/source/azerothcore/etc/worldserver.conf

    if [[ $ACCOUNT_BOUND_ENABLED == "true" ]]; then
        if [[ ! -f $ROOT/source/etc/modules/mod_accountbound.conf.dist ]]; then
            printf "${COLOR_RED}The config file mod_accountbound.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            notify_telegram "An error occurred while trying to update the config files"
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating mod_accountbound.conf${COLOR_END}\n"

        cp $ROOT/source/etc/modules/mod_accountbound.conf.dist $ROOT/source/etc/modules/mod_accountbound.conf

        sed -i 's/AccountBound.Heirlooms =.*/AccountBound.Heirlooms = 1/g' $ROOT/source/etc/modules/mod_accountbound.conf
    else
        if [[ -f $ROOT/source/etc/modules/mod_accountbound.conf.dist ]]; then
            rm -rf $ROOT/source/etc/modules/mod_accountbound.conf.dist
        fi

        if [[ -f $ROOT/source/etc/modules/mod_accountbound.conf ]]; then
            rm -rf $ROOT/source/etc/modules/mod_accountbound.conf
        fi
    fi

    if [[ $AHBOT_ENABLED == "true" ]]; then
        if [[ ! -f $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf.dist ]]; then
            printf "${COLOR_RED}The config file mod_ahbot.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating mod_ahbot.conf${COLOR_END}\n"

        cp $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf.dist $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf

        sed -i 's/AuctionHouseBot.EnableBuyer =.*/AuctionHouseBot.EnableBuyer = 1/g' $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf
        sed -i 's/AuctionHouseBot.EnableSeller =.*/AuctionHouseBot.EnableSeller = 1/g' $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf
        sed -i 's/AuctionHouseBot.UseBuyPriceForBuyer =.*/AuctionHouseBot.UseBuyPriceForBuyer = 1/g' $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf
        sed -i 's/AuctionHouseBot.Account =.*/AuctionHouseBot.Account = 1/g' $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf
        sed -i 's/AuctionHouseBot.GUID =.*/AuctionHouseBot.GUID = 1/g' $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf
        sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = '$AHBOT_MAX_ITEM_LEVEL'/g' $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf
    else
        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf.dist ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf.dist
        fi

        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_ahbot.conf
        fi
    fi

    if [[ $APPRECIATION_ENABLED == "true" ]]; then
        if [[ ! -f $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf.dist ]]; then
            printf "${COLOR_RED}The config file mod_appreciation.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating mod_appreciation.conf${COLOR_END}\n"

        cp $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf.dist $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf

        if [[ $PROGRESSION_ACTIVE_PATCH -lt 12 ]]; then
            sed -i 's/Appreciation.LevelBoost.TargetLevel =.*/Appreciation.LevelBoost.TargetLevel = 60/g' $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf
            sed -i 's/Appreciation.LevelBoost.IncludedCopper =.*/Appreciation.LevelBoost.IncludedCopper = 2500000/g' $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf
        elif [[ $PROGRESSION_ACTIVE_PATCH -lt 17 ]]; then
            sed -i 's/Appreciation.LevelBoost.TargetLevel =.*/Appreciation.LevelBoost.TargetLevel = 70/g' $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf
            sed -i 's/Appreciation.LevelBoost.IncludedCopper =.*/Appreciation.LevelBoost.IncludedCopper = 5000000/g' $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf
        else
            sed -i 's/Appreciation.LevelBoost.TargetLevel =.*/Appreciation.LevelBoost.TargetLevel = 80/g' $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf
            sed -i 's/Appreciation.LevelBoost.IncludedCopper =.*/Appreciation.LevelBoost.IncludedCopper = 10000000/g' $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf
        fi

        sed -i 's/Appreciation.RewardAtMaxLevel.Enabled =.*/Appreciation.RewardAtMaxLevel.Enabled = 1/g' $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf
    else
        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf.dist ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf.dist
        fi

        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_appreciation.conf
        fi
    fi

    if [[ $ASSISTANT_ENABLED == "true" ]]; then
        if [[ ! -f $ROOT/source/azerothcore/etc/modules/mod_assistant.conf.dist ]]; then
            printf "${COLOR_RED}The config file mod_assistant.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating mod_assistant.conf${COLOR_END}\n"

        cp $ROOT/source/azerothcore/etc/modules/mod_assistant.conf.dist $ROOT/source/azerothcore/etc/modules/mod_assistant.conf

        sed -i 's/Assistant.Heirlooms.Enabled  =.*/Assistant.Heirlooms.Enabled  = 0/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        if [[ $PROGRESSION_ACTIVE_PATCH -lt 17 ]]; then
            sed -i 's/Assistant.Glyphs.Enabled     =.*/Assistant.Glyphs.Enabled     = 0/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Gems.Enabled       =.*/Assistant.Gems.Enabled       = 0/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        else
            sed -i 's/Assistant.Glyphs.Enabled     =.*/Assistant.Glyphs.Enabled     = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
            sed -i 's/Assistant.Gems.Enabled       =.*/Assistant.Gems.Enabled       = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        fi
        sed -i 's/Assistant.Containers.Enabled =.*/Assistant.Containers.Enabled = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Utilities.Enabled            =.*/Assistant.Utilities.Enabled            = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Utilities.NameChange.Cost    =.*/Assistant.Utilities.NameChange.Cost    = 100000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Utilities.Customize.Cost     =.*/Assistant.Utilities.Customize.Cost     = 500000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Utilities.RaceChange.Cost    =.*/Assistant.Utilities.RaceChange.Cost    = 5000000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Utilities.FactionChange.Cost =.*/Assistant.Utilities.FactionChange.Cost = 10000000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.FlightPaths.Vanilla.Enabled                  =.*/Assistant.FlightPaths.Vanilla.Enabled                  = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.FlightPaths.Vanilla.RequiredLevel            =.*/Assistant.FlightPaths.Vanilla.RequiredLevel            = 60/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.FlightPaths.Vanilla.Cost                     =.*/Assistant.FlightPaths.Vanilla.Cost                     = 250000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        if [[ $PROGRESSION_ACTIVE_PATCH -lt 12 ]]; then
            sed -i 's/Assistant.FlightPaths.BurningCrusade.Enabled           =.*/Assistant.FlightPaths.BurningCrusade.Enabled           = 0/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        else
            sed -i 's/Assistant.FlightPaths.BurningCrusade.Enabled           =.*/Assistant.FlightPaths.BurningCrusade.Enabled           = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        fi
        sed -i 's/Assistant.FlightPaths.BurningCrusade.RequiredLevel     =.*/Assistant.FlightPaths.BurningCrusade.RequiredLevel     = 70/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.FlightPaths.BurningCrusade.Cost              =.*/Assistant.FlightPaths.BurningCrusade.Cost              = 1000000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        if [[ $PROGRESSION_ACTIVE_PATCH -lt 17 ]]; then
            sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       =.*/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       = 0/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        else
            sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       =.*/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        fi
        sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.RequiredLevel =.*/Assistant.FlightPaths.WrathOfTheLichKing.RequiredLevel = 80/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.Cost          =.*/Assistant.FlightPaths.WrathOfTheLichKing.Cost          = 2500000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.Apprentice.Enabled  =.*/Assistant.Professions.Apprentice.Enabled  = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.Apprentice.Cost     =.*/Assistant.Professions.Apprentice.Cost     = 1000000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.Journeyman.Enabled  =.*/Assistant.Professions.Journeyman.Enabled  = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.Journeyman.Cost     =.*/Assistant.Professions.Journeyman.Cost     = 2500000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.Expert.Enabled      =.*/Assistant.Professions.Expert.Enabled      = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.Expert.Cost         =.*/Assistant.Professions.Expert.Cost         = 5000000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.Artisan.Enabled     =.*/Assistant.Professions.Artisan.Enabled     = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.Artisan.Cost        =.*/Assistant.Professions.Artisan.Cost        = 7500000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.Master.Enabled      =.*/Assistant.Professions.Master.Enabled      = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.Master.Cost         =.*/Assistant.Professions.Master.Cost         = 12500000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.GrandMaster.Enabled =.*/Assistant.Professions.GrandMaster.Enabled = 1/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        sed -i 's/Assistant.Professions.GrandMaster.Cost    =.*/Assistant.Professions.GrandMaster.Cost    = 25000000/g' $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
    else
        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_assistant.conf.dist ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_assistant.conf.dist
        fi

        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_assistant.conf ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_assistant.conf
        fi
    fi

    if [[ $GUILD_FUNDS_ENABLED == "true" ]]; then
        if [[ ! -f $ROOT/source/azerothcore/etc/modules/mod_guildfunds.conf.dist ]]; then
            printf "${COLOR_RED}The config file mod_guildfunds.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating mod_guildfunds.conf${COLOR_END}\n"

        cp $ROOT/source/azerothcore/etc/modules/mod_guildfunds.conf.dist $ROOT/source/azerothcore/etc/modules/mod_guildfunds.conf

        sed -i 's/GuildFunds.Looted =.*/GuildFunds.Looted = 10/g' $ROOT/source/azerothcore/etc/modules/mod_guildfunds.conf
        sed -i 's/GuildFunds.Quests =.*/GuildFunds.Quests = 3/g' $ROOT/source/azerothcore/etc/modules/mod_guildfunds.conf
    else
        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_guildfunds.conf.dist ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_guildfunds.conf.dist
        fi

        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_guildfunds.conf ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_guildfunds.conf
        fi
    fi

    if [[ $LEARN_SPELLS_ENABLED == "true" ]]; then
        if [[ ! -f $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf.dist ]]; then
            printf "${COLOR_RED}The config file mod_learnspells.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating mod_learnspells.conf${COLOR_END}\n"

        cp $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf.dist $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf

        sed -i 's/LearnSpells.ClassSpells =.*/LearnSpells.ClassSpells = 1/g' $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf
        sed -i 's/LearnSpells.TalentRanks =.*/LearnSpells.TalentRanks = 1/g' $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf
        sed -i 's/LearnSpells.Proficiencies =.*/LearnSpells.Proficiencies = 1/g' $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf
        sed -i 's/LearnSpells.SpellsFromQuests =.*/LearnSpells.SpellsFromQuests = 1/g' $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf
        sed -i 's/LearnSpells.Riding.Apprentice =.*/LearnSpells.Riding.Apprentice = 0/g' $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf
        sed -i 's/LearnSpells.Riding.Journeyman =.*/LearnSpells.Riding.Journeyman = 0/g' $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf
        sed -i 's/LearnSpells.Riding.Expert =.*/LearnSpells.Riding.Expert = 0/g' $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf
        sed -i 's/LearnSpells.Riding.Artisan =.*/LearnSpells.Riding.Artisan = 0/g' $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf
        sed -i 's/LearnSpells.Riding.ColdWeatherFlying =.*/LearnSpells.Riding.ColdWeatherFlying = 0/g' $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf
    else
        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf.dist ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf.dist
        fi

        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_learnspells.conf
        fi
    fi

    if [[ $RECRUIT_A_FRIEND_ENABLED == "true" ]]; then
        if [[ ! -f $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf.dist ]]; then
            printf "${COLOR_RED}The config file mod_recruitafriend.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating mod_recruitafriend.conf${COLOR_END}\n"

        cp $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf.dist $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf

        sed -i 's/RecruitAFriend.Duration =.*/RecruitAFriend.Duration = 90/g' $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf
        sed -i 's/RecruitAFriend.MaxAccountAge =.*/RecruitAFriend.MaxAccountAge = 7/g' $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf
        sed -i 's/RecruitAFriend.Rewards.Days =.*/RecruitAFriend.Rewards.Days = 30/g' $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf
        sed -i 's/RecruitAFriend.Rewards.SwiftZhevra =.*/RecruitAFriend.Rewards.SwiftZhevra = 1/g' $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf
        sed -i 's/RecruitAFriend.Rewards.TouringRocket =.*/RecruitAFriend.Rewards.TouringRocket = 1/g' $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf
        sed -i 's/RecruitAFriend.Rewards.CelestialSteed =.*/RecruitAFriend.Rewards.CelestialSteed = 1/g' $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf
    else
        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf.dist ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf.dist
        fi

        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_recruitafriend.conf
        fi
    fi

    if [[ $WEEKEND_BONUS_ENABLED == "true" ]]; then
        if [[ ! -f $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf.dist ]]; then
            printf "${COLOR_RED}The config file mod_weekendbonus.conf.dist is missing.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        printf "${COLOR_ORANGE}Updating mod_weekendbonus.conf${COLOR_END}\n"

        cp $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf.dist $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf

        sed -i 's/WeekendBonus.Multiplier.Experience =.*/WeekendBonus.Multiplier.Experience = 2.0/g' $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf
        sed -i 's/WeekendBonus.Multiplier.Money =.*/WeekendBonus.Multiplier.Money = 2.0/g' $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf
        sed -i 's/WeekendBonus.Multiplier.Professions =.*/WeekendBonus.Multiplier.Professions = 2/g' $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf
        sed -i 's/WeekendBonus.Multiplier.Reputation =.*/WeekendBonus.Multiplier.Reputation = 2.0/g' $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf
        sed -i 's/WeekendBonus.Multiplier.Proficiencies =.*/WeekendBonus.Multiplier.Proficiencies = 2/g' $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf
    else
        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf.dist ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf.dist
        fi

        if [[ -f $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf ]]; then
            rm -rf $ROOT/source/azerothcore/etc/modules/mod_weekendbonus.conf
        fi
    fi

    printf "${COLOR_GREEN}Finished updating the config files...${COLOR_END}\n"
}

function start_server
{
    printf "${COLOR_GREEN}Starting the server...${COLOR_END}\n"

    if [[ ! -f $ROOT/source/azerothcore/bin/start.sh ]] || [[ ! -f $ROOT/source/azerothcore/bin/stop.sh ]]; then
        printf "${COLOR_RED}The required binaries are missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
    else
        if [[ ! -z `screen -list | grep -E "world-$NODE_ID"` ]]; then
            printf "${COLOR_RED}The server is already running.${COLOR_END}\n"
        else
            cd $ROOT/source/azerothcore/bin && ./start.sh

            if [[ ! -z `screen -list | grep -E "world-$NODE_ID"` ]]; then
                printf "${COLOR_ORANGE}To access the screen of the worldserver, use the command ${COLOR_BLUE}screen -r world-$NODE_ID${COLOR_ORANGE}.${COLOR_END}\n"
            fi
        fi
    fi

    printf "${COLOR_GREEN}Finished starting the server...${COLOR_END}\n"
}

function stop_server
{
    printf "${COLOR_GREEN}Stopping the server...${COLOR_END}\n"

    if [[ -z `screen -list | grep -E "world-$NODE_ID"` ]]; then
        printf "${COLOR_RED}The server is not running.${COLOR_END}\n"
    else
        printf "${COLOR_ORANGE}Telling the world server to shut down.${COLOR_END}\n"

        PID=$(screen -ls | grep -oE "[0-9]+\.world-$NODE_ID" | sed -e "s/\..*$//g")

        if [[ $PID != "" ]]; then
            if [[ $1 == "restart" ]]; then
                screen -S world-$NODE_ID -p 0 -X stuff "server restart 10^m"
            else
                screen -S world-$NODE_ID -p 0 -X stuff "server shutdown 10^m"
            fi

            timeout 30 tail --pid=$PID -f /dev/null
        fi

        if [[ -f $ROOT/source/azerothcore/bin/stop.sh ]]; then
            cd $ROOT/source/azerothcore/bin && ./stop.sh
        fi
    fi

    printf "${COLOR_GREEN}Finished stopping the server...${COLOR_END}\n"
}

function parameters
{
    printf "${COLOR_GREEN}Available parameters${COLOR_END}\n"
    printf "${COLOR_ORANGE}install/setup/update             ${COLOR_WHITE}| ${COLOR_BLUE}Downloads the source code and compiles it. Also downloads client files${COLOR_END}\n"
    printf "${COLOR_ORANGE}database/db                      ${COLOR_WHITE}| ${COLOR_BLUE}Import all files to the specified databases${COLOR_END}\n"
    printf "${COLOR_ORANGE}dbc                              ${COLOR_WHITE}| ${COLOR_BLUE}Copy modified client data files to the proper folder${COLOR_END}\n"
    printf "${COLOR_ORANGE}config/conf/cfg/settings/options ${COLOR_WHITE}| ${COLOR_BLUE}Updates all config files with options specified${COLOR_END}\n"
    printf "${COLOR_ORANGE}start                            ${COLOR_WHITE}| ${COLOR_BLUE}Starts the compiled processes${COLOR_END}\n"
    printf "${COLOR_ORANGE}stop                             ${COLOR_WHITE}| ${COLOR_BLUE}Stops the compiled process${COLOR_END}\n"
    printf "${COLOR_ORANGE}restart                          ${COLOR_WHITE}| ${COLOR_BLUE}Stops and then starts the compiled process${COLOR_END}\n\n"
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
        import_database_files
    elif [[ $1 == "dbc" ]]; then
        copy_dbc_files
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
        import_database_files
        get_client_files
        copy_dbc_files
        set_config
        start_server
    else
        parameters
    fi
else
    parameters
fi
