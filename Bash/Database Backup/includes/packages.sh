#!/bin/bash
if [ $(dpkg-query -W -f='${Status}' libxml2-utils 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    apt-get update -y
    if [ $? -ne 0 ]; then
        exit 1
    fi

    apt-get install -y libxml2-utils
    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

function install_database_packages()
{
    if [ $(dpkg-query -W -f='${Status}' mariadb-client 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        apt-get update -y
        if [ $? -ne 0 ]; then
            exit 1
        fi

        apt-get install -y mariadb-client
        if [ $? -ne 0 ]; then
            exit 1
        fi
    fi
}
