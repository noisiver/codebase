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
    echo "MYSQL_DATABASE_AUTH=\"acore_auth\"" >> $ROOT/config.sh
    echo "MYSQL_DATABASE_CHARACTERS=\"acore_characters\"" >> $ROOT/config.sh
    echo "MYSQL_DATABASE_WORLD=\"acore_world\"" >> $ROOT/config.sh
    echo "LOCAL_ADDRESS=\"127.0.0.1\" # SET THIS TO THE ADDRESS THE CLIENT CONNECTS TO" >> $ROOT/config.sh
    echo "# DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING" >> $ROOT/config.sh
    echo "SOURCE_REPOSITORY=\"https://github.com/walkline/ToCloud9.git\"" >> $ROOT/config.sh
    echo "SOURCE_BRANCH=\"master\"" >> $ROOT/config.sh

    exit $?
fi

source "$ROOT/config.sh"

function install_packages
{
    PACKAGES=("git" "screen" "golang-go" "redis")

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

    if [[ $(dpkg-query -W -f='${Status}' nats-server 2>/dev/null | grep -c "ok installed") -eq 0 ]]; then
        wget https://github.com/nats-io/nats-server/releases/download/v2.9.21/nats-server-v2.9.21-amd64.deb
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        if [[ $EUID != 0 ]]; then
            sudo apt-get install ./nats-server-v2.9.21-amd64.deb
        else
            apt-get install ./nats-server-v2.9.21-amd64.deb
        fi
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi
}

function get_source
{
    printf "${COLOR_GREEN}Downloading the source code...${COLOR_END}\n"

    if [[ ! -d $ROOT/source ]]; then
        git clone --recursive --depth 1 --branch $SOURCE_BRANCH $SOURCE_REPOSITORY $ROOT/source
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    else
        cd $ROOT/source

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

    printf "${COLOR_GREEN}Finished downloading the source code...${COLOR_END}\n"
}

function compile_source
{
    printf "${COLOR_GREEN}Compiling the source code...${COLOR_END}\n"

    cd $ROOT/source

    printf "${COLOR_ORANGE}Building authserver.${COLOR_END}\n"
    go build -o bin/authserver apps/authserver/cmd/authserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    printf "${COLOR_ORANGE}Building charserver.${COLOR_END}\n"
    go build -o bin/charserver apps/charserver/cmd/charserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    printf "${COLOR_ORANGE}Building chatserver.${COLOR_END}\n"
    go build -o bin/chatserver apps/chatserver/cmd/chatserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    printf "${COLOR_ORANGE}Building game-load-balancer.${COLOR_END}\n"
    go build -o bin/game-load-balancer apps/game-load-balancer/cmd/game-load-balancer/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    printf "${COLOR_ORANGE}Building servers-registry.${COLOR_END}\n"
    go build -o bin/servers-registry apps/servers-registry/cmd/servers-registry/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    printf "${COLOR_ORANGE}Building guidserver.${COLOR_END}\n"
    go build -o bin/guidserver apps/guidserver/cmd/guidserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    printf "${COLOR_ORANGE}Building guildserver.${COLOR_END}\n"
    go build -o bin/guildserver apps/guildserver/cmd/guildserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    printf "${COLOR_ORANGE}Building mailserver.${COLOR_END}\n"
    go build -o bin/mailserver apps/mailserver/cmd/mailserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    echo "#!/bin/bash" > $ROOT/source/bin/start.sh
    echo "screen -L -Logfile nats-server.log -dmS nats-server ./nats-server.sh" >> $ROOT/source/bin/start.sh
    echo "screen -L -Logfile servers-registry.log -dmS servers-registry ./servers-registry.sh" >> $ROOT/source/bin/start.sh
    echo "screen -L -Logfile guidserver.log -dmS guidserver ./guidserver.sh" >> $ROOT/source/bin/start.sh
    echo "screen -L -Logfile authserver.log -dmS authserver ./authserver.sh" >> $ROOT/source/bin/start.sh
    echo "screen -L -Logfile charserver.log -dmS charserver ./charserver.sh" >> $ROOT/source/bin/start.sh
    echo "screen -L -Logfile chatserver.log -dmS chatserver ./chatserver.sh" >> $ROOT/source/bin/start.sh
    echo "screen -L -Logfile game-load-balancer.log -dmS game-load-balancer ./game-load-balancer.sh" >> $ROOT/source/bin/start.sh
    echo "screen -L -Logfile guildserver.log -dmS guildserver ./guildserver.sh" >> $ROOT/source/bin/start.sh
    echo "screen -L -Logfile mailserver.log -dmS mailserver ./mailserver.sh" >> $ROOT/source/bin/start.sh
    chmod +x $ROOT/source/bin/start.sh

    echo "#!/bin/bash" > $ROOT/source/bin/nats-server.sh
    echo "while :; do" >> $ROOT/source/bin/nats-server.sh
    echo "    nats-server" >> $ROOT/source/bin/nats-server.sh
    echo "    sleep 5" >> $ROOT/source/bin/nats-server.sh
    echo "done" >> $ROOT/source/bin/nats-server.sh
    chmod +x $ROOT/source/bin/nats-server.sh

    echo "#!/bin/bash" > $ROOT/source/bin/servers-registry.sh
    echo "while :; do" >> $ROOT/source/bin/servers-registry.sh
    echo "    ./servers-registry" >> $ROOT/source/bin/servers-registry.sh
    echo "    sleep 5" >> $ROOT/source/bin/servers-registry.sh
    echo "done" >> $ROOT/source/bin/servers-registry.sh
    chmod +x $ROOT/source/bin/servers-registry.sh

    echo "#!/bin/bash" > $ROOT/source/bin/guidserver.sh
    echo "while :; do" >> $ROOT/source/bin/guidserver.sh
    echo "    ./guidserver" >> $ROOT/source/bin/guidserver.sh
    echo "    sleep 5" >> $ROOT/source/bin/guidserver.sh
    echo "done" >> $ROOT/source/bin/guidserver.sh
    chmod +x $ROOT/source/bin/guidserver.sh

    echo "#!/bin/bash" > $ROOT/source/bin/authserver.sh
    echo "while :; do" >> $ROOT/source/bin/authserver.sh
    echo "    ./authserver" >> $ROOT/source/bin/authserver.sh
    echo "    sleep 5" >> $ROOT/source/bin/authserver.sh
    echo "done" >> $ROOT/source/bin/authserver.sh
    chmod +x $ROOT/source/bin/authserver.sh

    echo "#!/bin/bash" > $ROOT/source/bin/charserver.sh
    echo "while :; do" >> $ROOT/source/bin/charserver.sh
    echo "    ./charserver" >> $ROOT/source/bin/charserver.sh
    echo "    sleep 5" >> $ROOT/source/bin/charserver.sh
    echo "done" >> $ROOT/source/bin/charserver.sh
    chmod +x $ROOT/source/bin/charserver.sh

    echo "#!/bin/bash" > $ROOT/source/bin/chatserver.sh
    echo "while :; do" >> $ROOT/source/bin/chatserver.sh
    echo "    ./chatserver" >> $ROOT/source/bin/chatserver.sh
    echo "    sleep 5" >> $ROOT/source/bin/chatserver.sh
    echo "done" >> $ROOT/source/bin/chatserver.sh
    chmod +x $ROOT/source/bin/chatserver.sh

    echo "#!/bin/bash" > $ROOT/source/bin/game-load-balancer.sh
    echo "while :; do" >> $ROOT/source/bin/game-load-balancer.sh
    echo "    ./game-load-balancer" >> $ROOT/source/bin/game-load-balancer.sh
    echo "    sleep 5" >> $ROOT/source/bin/game-load-balancer.sh
    echo "done" >> $ROOT/source/bin/game-load-balancer.sh
    chmod +x $ROOT/source/bin/game-load-balancer.sh

    echo "#!/bin/bash" > $ROOT/source/bin/guildserver.sh
    echo "while :; do" >> $ROOT/source/bin/guildserver.sh
    echo "    ./guildserver" >> $ROOT/source/bin/guildserver.sh
    echo "    sleep 5" >> $ROOT/source/bin/guildserver.sh
    echo "done" >> $ROOT/source/bin/guildserver.sh
    chmod +x $ROOT/source/bin/guildserver.sh

    echo "#!/bin/bash" > $ROOT/source/bin/mailserver.sh
    echo "while :; do" >> $ROOT/source/bin/mailserver.sh
    echo "    ./mailserver" >> $ROOT/source/bin/mailserver.sh
    echo "    sleep 5" >> $ROOT/source/bin/mailserver.sh
    echo "done" >> $ROOT/source/bin/mailserver.sh
    chmod +x $ROOT/source/bin/mailserver.sh

    echo "#!/bin/bash" > $ROOT/source/bin/stop.sh
    echo "screen -X -S \"nats-server\" quit && pkill \"nats-server\"" >> $ROOT/source/bin/stop.sh
    echo "screen -X -S \"servers-registry\" quit" >> $ROOT/source/bin/stop.sh
    echo "screen -X -S \"guidserver\" quit" >> $ROOT/source/bin/stop.sh
    echo "screen -X -S \"authserver\" quit" >> $ROOT/source/bin/stop.sh
    echo "screen -X -S \"charserver\" quit" >> $ROOT/source/bin/stop.sh
    echo "screen -X -S \"chatserver\" quit" >> $ROOT/source/bin/stop.sh
    echo "screen -X -S \"game-load-balancer\" quit" >> $ROOT/source/bin/stop.sh
    echo "screen -X -S \"guildserver\" quit" >> $ROOT/source/bin/stop.sh
    echo "screen -X -S \"mailserver\" quit" >> $ROOT/source/bin/stop.sh
    chmod +x $ROOT/source/bin/stop.sh

    printf "${COLOR_GREEN}Finished compiling the source code...${COLOR_END}\n"
}

function set_config
{
    printf "${COLOR_GREEN}Updating the config files...${COLOR_END}\n"

    if [[ ! -f $ROOT/source/config.yml.example ]]; then
        printf "${COLOR_RED}The config file config.yml.example is missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
        exit $?
    fi

    printf "${COLOR_ORANGE}Updating config.yml${COLOR_END}\n"

    cp $ROOT/source/config.yml.example $ROOT/source/bin/config.yml

    sed -i 's/  auth: \&defaultAuthDB.*/  auth: \&defaultAuthDB "'$MYSQL_USERNAME':'$MYSQL_PASSWORD'@tcp('$MYSQL_HOSTNAME':'$MYSQL_PORT')\/'$MYSQL_DATABASE_AUTH'"/g' $ROOT/source/bin/config.yml
    sed -i 's/  characters: \&defaultCharactersDB.*/  characters: \&defaultCharactersDB "'$MYSQL_USERNAME':'$MYSQL_PASSWORD'@tcp('$MYSQL_HOSTNAME':'$MYSQL_PORT')\/'$MYSQL_DATABASE_CHARACTERS'"/g' $ROOT/source/bin/config.yml
    sed -i 's/  world: \&defaultWorldDB.*/  world: \&defaultWorldDB "'$MYSQL_USERNAME':'$MYSQL_PASSWORD'@tcp('$MYSQL_HOSTNAME':'$MYSQL_PORT')\/'$MYSQL_DATABASE_WORLD'"/g' $ROOT/source/bin/config.yml
    sed -i 's/  schemaType: \&defaultSchemaType.*/  schemaType: \&defaultSchemaType "ac"/g' $ROOT/source/bin/config.yml
    sed -i 's/  serversRegistryServiceAddress:.*/  serversRegistryServiceAddress: '$LOCAL_ADDRESS':8999/g' $ROOT/source/bin/config.yml
    sed -i 's/  charactersServiceAddress:.*/  charactersServiceAddress: "'$LOCAL_ADDRESS':8991"/g' $ROOT/source/bin/config.yml
    sed -i 's/  chatServiceAddress:.*/  chatServiceAddress: "'$LOCAL_ADDRESS':8992"/g' $ROOT/source/bin/config.yml
    sed -i 's/  guildsServiceAddress:.*/  guildsServiceAddress: "'$LOCAL_ADDRESS':8995"/g' $ROOT/source/bin/config.yml
    sed -i 's/  mailServiceAddress:.*/  mailServiceAddress: "'$LOCAL_ADDRESS':8997"/g' $ROOT/source/bin/config.yml
    sed -i 's/  preferredHostname:.*/  preferredHostname: "'$LOCAL_ADDRESS'"/g' $ROOT/source/bin/config.yml
    sed -i 's/  guidProviderServiceAddress:.*/  guidProviderServiceAddress: "'$LOCAL_ADDRESS':8996"/g' $ROOT/source/bin/config.yml

    printf "${COLOR_GREEN}Finished updating the config files...${COLOR_END}\n"
}

function start_server
{
    printf "${COLOR_GREEN}Starting the server...${COLOR_END}\n"

    if [[ ! -f $ROOT/source/bin/start.sh ]] || [[ ! -f $ROOT/source/bin/stop.sh ]]; then
        printf "${COLOR_RED}The required binaries are missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
    else
        if [[ ! -z `screen -list | grep -E "nats-server"` ]] || [[ ! -z `screen -list | grep -E "servers-registry"` ]] || [[ ! -z `screen -list | grep -E "guidserver"` ]] || [[ ! -z `screen -list | grep -E "authserver"` ]] || [[ ! -z `screen -list | grep -E "charserver"` ]] || [[ ! -z `screen -list | grep -E "chatserver"` ]] || [[ ! -z `screen -list | grep -E "game-load-balancer"` ]] || [[ ! -z `screen -list | grep -E "guildserver"` ]] || [[ ! -z `screen -list | grep -E "mailserver"` ]]; then
            printf "${COLOR_RED}The server is already running.${COLOR_END}\n"
        else
            cd $ROOT/source/bin && ./start.sh
        fi
    fi

    printf "${COLOR_GREEN}Finished starting the server...${COLOR_END}\n"
}

function stop_server
{
    printf "${COLOR_GREEN}Stopping the server...${COLOR_END}\n"

    if [[ -z `screen -list | grep -E "nats-server"` ]] && [[ -z `screen -list | grep -E "servers-registry"` ]] && [[ -z `screen -list | grep -E "guidserver"` ]] && [[ -z `screen -list | grep -E "authserver"` ]] && [[ -z `screen -list | grep -E "charserver"` ]] && [[ -z `screen -list | grep -E "chatserver"` ]] && [[ -z `screen -list | grep -E "game-load-balancer"` ]] && [[ -z `screen -list | grep -E "guildserver"` ]] && [[ -z `screen -list | grep -E "mailserver"` ]]; then
        printf "${COLOR_RED}The server is not running.${COLOR_END}\n"
    else
        if [[ -f $ROOT/source/bin/stop.sh ]]; then
            cd $ROOT/source/bin && ./stop.sh
        fi
    fi

    printf "${COLOR_GREEN}Finished stopping the server...${COLOR_END}\n"
}

function parameters
{
    printf "${COLOR_GREEN}Available parameters${COLOR_END}\n"

    printf "${COLOR_GREEN}Available subparameters${COLOR_END}\n"
    printf "${COLOR_ORANGE}install/setup/update             ${COLOR_WHITE}| ${COLOR_BLUE}Downloads the source code and compiles it${COLOR_END}\n"
    printf "${COLOR_ORANGE}config/conf/cfg/settings/options ${COLOR_WHITE}| ${COLOR_BLUE}Updates all config files with options specified${COLOR_END}\n"
    printf "${COLOR_ORANGE}start                            ${COLOR_WHITE}| ${COLOR_BLUE}Starts the compiled processes${COLOR_END}\n"
    printf "${COLOR_ORANGE}stop                             ${COLOR_WHITE}| ${COLOR_BLUE}Stops the compiled processes${COLOR_END}\n"
    printf "${COLOR_ORANGE}restart                          ${COLOR_WHITE}| ${COLOR_BLUE}Stops and then starts the compiled processes${COLOR_END}\n\n"
    printf "${COLOR_ORANGE}all                              ${COLOR_WHITE}| ${COLOR_BLUE}Run all subparameters listed above, including stop and start${COLOR_END}\n"

    exit $?
}

if [[ $# -gt 0 ]]; then
    if [[ $1 == "install" ]] || [[ $1 == "setup" ]] || [[ $1 == "update" ]]; then
        stop_server
        install_packages
        get_source
        compile_source
    elif [[ $1 == "config" ]] || [[ $1 == "conf" ]] || [[ $1 == "cfg" ]] || [[ $1 == "settings" ]] || [[ $1 == "options" ]]; then
        set_config
    elif [[ $1 == "start" ]]; then
        start_server
    elif [[ $1 == "stop" ]]; then
        stop_server
    elif [[ $1 == "restart" ]]; then
        stop_server
        start_server
    elif [[ $1 == "all" ]]; then
        stop_server
        install_packages
        get_source
        compile_source
        set_config
        start_server
    else
        parameters
    fi
else
    parameters
fi
