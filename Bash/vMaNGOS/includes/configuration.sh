#!/bin/bash
ROOT=$(pwd)

CONFIG_FILE="vmangos.xml"
MYSQL_CONFIG="$ROOT/mysql.cnf"

function export_settings
{
    echo "<?xml version=\"1.0\"?>
    <config>
        <mysql>
            <hostname>${1:-127.0.0.1}</hostname>
            <port>${2:-3306}</port>
            <username>${3:-acore}</username>
            <password>${4:-acore}</password>
            <database>
                <auth>${5:-vmangos_auth}</auth>
                <characters>${6:-vmangos_characters}</characters>
                <world>${7:-vmangos_world}</world>
                <logs>${8:-vmangos_logs}</logs>
            </database>
        </mysql>
        <core>
            <directory>${9:-/opt/vmangos}</directory>
        </core>
    </config>" | xmllint --format - > $ROOT/$CONFIG_FILE
}

function generate_settings
{
    export_settings \
    $MYSQL_HOSTNAME \
    $MYSQL_PORT \
    $MYSQL_USERNAME \
    $MYSQL_PASSWORD \
    $MYSQL_DATABASE_AUTH \
    $MYSQL_DATABASE_CHARACTERS \
    $MYSQL_DATABASE_WORLD \
    "$CORE_DIRECTORY"
}

if [ ! -f $ROOT/$CONFIG_FILE ]; then
    clear
    echo -e "\e[0;33mGenerating default configuration\e[0m"
    export_settings
    exit $?
fi

MYSQL_HOSTNAME="$(echo "cat /config/mysql/hostname/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_PORT="$(echo "cat /config/mysql/port/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_USERNAME="$(echo "cat /config/mysql/username/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_PASSWORD="$(echo "cat /config/mysql/password/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_AUTH="$(echo "cat /config/mysql/database/auth/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_CHARACTERS="$(echo "cat /config/mysql/database/characters/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"
MYSQL_DATABASE_WORLD="$(echo "cat /config/mysql/database/world/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"

CORE_DIRECTORY="$(echo "cat /config/core/directory/text()" | xmllint --nocdata --shell $ROOT/$CONFIG_FILE | sed '1d;$d')"

if [[ -z $MYSQL_HOSTNAME ]] || [[ $MYSQL_HOSTNAME == "" ]] || 
   [[ -z $MYSQL_PORT ]] || [[ $MYSQL_PORT == "" ]] || 
   [[ -z $MYSQL_USERNAME ]] || [[ $MYSQL_USERNAME == "" ]] || 
   [[ -z $MYSQL_PASSWORD ]] || [[ $MYSQL_PASSWORD == "" ]] || 
   [[ -z $MYSQL_DATABASE_AUTH ]] || [[ $MYSQL_DATABASE_AUTH == "" ]] || 
   [[ -z $MYSQL_DATABASE_CHARACTERS ]] || [[ $MYSQL_DATABASE_CHARACTERS == "" ]] || 
   [[ -z $MYSQL_DATABASE_WORLD ]] || [[ $MYSQL_DATABASE_WORLD == "" ]] || 
   [[ -z $CORE_DIRECTORY ]] || [[ $CORE_DIRECTORY == "" ]]; then
    clear
    echo -e "\e[0;31mAtleast one of the configuration options is missing or invalid\e[0m"
    exit $?
fi
