#!/bin/bash
if [ $(dpkg-query -W -f='${Status}' libxml2-utils 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    clear

    if [ $(id -u) -ne 0 ]; then
        echo -e "\e[0;31mThis script needs to be run as root or using sudo\e[0m"
        exit 1
    fi

    apt-get update -y
    if [ $? -ne 0 ]; then
        exit $?
    fi

    apt-get install -y libxml2-utils
    if [ $? -ne 0 ]; then
        exit $?
    fi
fi

function install_database_packages
{
    if [ $(dpkg-query -W -f='${Status}' mariadb-client 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        clear

        if [ $(id -u) -ne 0 ]; then
            echo -e "\e[0;31mThis script needs to be run as root or using sudo\e[0m"
            exit 1
        fi

        apt-get update -y
        if [ $? -ne 0 ]; then
            exit $?
        fi

        apt-get install -y mariadb-client
        if [ $? -ne 0 ]; then
            exit $?
        fi
    fi
}
