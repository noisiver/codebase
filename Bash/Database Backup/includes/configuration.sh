#!/bin/bash
ROOT=$(pwd)
BACKUP_DATE=$(date +"%Y-%m-%d_%H-%M")

CONFIG_FILE="$ROOT/backup.xml"
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
            <username>${3:-backup}</username>
            <!-- The password used to connect to the database server -->
            <password>${4:-backup}</password>
        </mysql>
        <backup>
            <!-- The type of storage to use. local = store it locally, gdrive = store it on an initialized google drive which must be at ~/gdrive -->
            <type>${5:-local}</type>
            <!-- The max amount of files to store. The type of storage has no effect on this setting -->
            <max_files>${6:-24}</max_files>
        </backup>
    </config>" | xmllint --format - > $CONFIG_FILE
}

function export_settings
{
    export_settings \
    $MYSQL_HOSTNAME \
    $MYSQL_PORT \
    $MYSQL_USERNAME \
    $MYSQL_PASSWORD \
    $BACKUP_TYPE \
    $BACKUP_MAX_FILES
}

if [ ! -f $CONFIG_FILE ]; then
    clear
    printf "${COLOR_ORANGE}Generating default configuration${COLOR_END}\n"
    generate_settings
    exit $?
fi

MYSQL_HOSTNAME="$(echo "cat /config/mysql/hostname/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_PORT="$(echo "cat /config/mysql/port/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_USERNAME="$(echo "cat /config/mysql/username/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_PASSWORD="$(echo "cat /config/mysql/password/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

BACKUP_TYPE="$(echo "cat /config/backup/type/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
BACKUP_MAX_FILES="$(echo "cat /config/backup/max_files/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

if [[ -z $MYSQL_HOSTNAME ]] || [[ $MYSQL_HOSTNAME == "" ]]; then
    MYSQL_HOSTNAME="127.0.0.1"
    REQUIRE_EXPORT=true
fi

if [[ -z $MYSQL_PORT ]] || [[ $MYSQL_PORT == "" ]]; then
    MYSQL_PORT="3306"
    REQUIRE_EXPORT=true
fi

if [[ -z $MYSQL_USERNAME ]] || [[ $MYSQL_USERNAME == "" ]]; then
    MYSQL_USERNAME="backup"
    REQUIRE_EXPORT=true
fi

if [[ -z $MYSQL_PASSWORD ]] || [[ $MYSQL_PASSWORD == "" ]]; then
    MYSQL_PASSWORD="backup"
    REQUIRE_EXPORT=true
fi

if [[ -z $BACKUP_TYPE ]] || [[ $BACKUP_TYPE == "" ]]; then
    BACKUP_TYPE="local"
    REQUIRE_EXPORT=true
fi

if [[ ! $BACKUP_MAX_FILES =~ ^[0-9]+$ ]] || [[ $BACKUP_MAX_FILES < 1 ]]; then
    BACKUP_MAX_FILES=24
    REQUIRE_EXPORT=true
fi

if [ $REQUIRE_EXPORT ]; then
    printf "${COLOR_ORANGE}Invalid settings have been reset to their default values${COLOR_END}\n"
    export_settings
    exit 1
else
    printf "${COLOR_ORANGE}Successfully loaded all settings${COLOR_END}\n"
fi
