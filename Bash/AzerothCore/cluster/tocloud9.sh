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

SOURCE_REPOSITORY="https://github.com/walkline/ToCloud9.git"
SOURCE_BRANCH="master"
SOURCE_LOCATION="$ROOT/source"

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
}

function compile_source
{
    printf "${COLOR_GREEN}Compiling the source code...${COLOR_END}\n"

    cd $SOURCE_LOCATION

    go build -o bin/authserver apps/authserver/cmd/authserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    go build -o bin/charserver apps/charserver/cmd/charserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    go build -o bin/chatserver apps/chatserver/cmd/chatserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    go build -o bin/game-load-balancer apps/game-load-balancer/cmd/game-load-balancer/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    go build -o bin/servers-registry apps/servers-registry/cmd/servers-registry/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    go build -o bin/guidserver apps/guidserver/cmd/guidserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    go build -o bin/guildserver apps/guildserver/cmd/guildserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi

    go build -o bin/mailserver apps/mailserver/cmd/mailserver/main.go
    if [[ $? -ne 0 ]]; then
        exit $?
    fi
}

function set_config
{
    printf "${COLOR_GREEN}Updating the config files...${COLOR_END}\n"

    if [[ ! -f $SOURCE_LOCATION/config.yml.example ]]; then
        printf "${COLOR_RED}The config file config.yml.example is missing.${COLOR_END}\n"
        printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
        exit $?
    fi

    printf "${COLOR_ORANGE}Updating config.yml${COLOR_END}\n"

    cp $SOURCE_LOCATION/config.yml.example $SOURCE_LOCATION/bin/config.yml    
}

if [[ $# -gt 0 ]]; then
    if [[ $1 == "install" ]] || [[ $1 == "setup" ]] || [[ $1 == "update" ]]; then
        install_packages
        get_source
        compile_source
        set_config
    elif [[ $1 == "config" ]] || [[ $1 == "cfg" ]] || [[ $1 == "settings" ]]; then
        set_config
    fi
fi
