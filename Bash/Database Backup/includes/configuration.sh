#!/bin/bash
ROOT=$(pwd)
BACKUP_DATE=$(date +"%Y-%m-%d_%H-%M")

CONFIG_FILE="$ROOT/backup.xml"
MYSQL_CONFIG="$ROOT/mysql.cnf"

function export_settings
{
    echo "<?xml version=\"1.0\"?>
    <config>
        <mysql>
            <hostname>${1:-127.0.0.1}</hostname>
            <port>${2:-3306}</port>
            <username>${3:-backup}</username>
            <password>${4:-backup}</password>
        </mysql>
        <backup>
            <type>${5:-local}</type>
            <max_files>${6:-24}</max_files>
        </backup>
    </config>" | xmllint --format - > $CONFIG_FILE
}

function generate_settings
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
    echo -e "\e[0;33mGenerating default configuration\e[0m"
    export_settings
    exit $?
fi

MYSQL_HOSTNAME="$(echo "cat /config/mysql/hostname/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_PORT="$(echo "cat /config/mysql/port/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_USERNAME="$(echo "cat /config/mysql/username/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
MYSQL_PASSWORD="$(echo "cat /config/mysql/password/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

BACKUP_TYPE="$(echo "cat /config/backup/type/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"
BACKUP_MAX_FILES="$(echo "cat /config/backup/max_files/text()" | xmllint --nocdata --shell $CONFIG_FILE | sed '1d;$d')"

if [[ -z $MYSQL_HOSTNAME ]] || [[ $MYSQL_HOSTNAME == "" ]] || 
   [[ -z $MYSQL_PORT ]] || [[ $MYSQL_PORT == "" ]] || 
   [[ -z $MYSQL_USERNAME ]] || [[ $MYSQL_USERNAME == "" ]] || 
   [[ -z $MYSQL_PASSWORD ]] || [[ $MYSQL_PASSWORD == "" ]] || 
   [[ -z $BACKUP_TYPE ]] || [[ $BACKUP_TYPE == "" ]] || 
   [[ -z $BACKUP_MAX_FILES ]] || [[ $BACKUP_MAX_FILES == "" ]]; then
    clear
    echo -e "\e[0;31mAtleast one of the configuration options is missing or invalid\e[0m"
    exit $?
fi
