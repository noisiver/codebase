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
BACKUP_DATE=$(date +"%Y-%m-%d_%H-%M")

MYSQL_HOSTNAME="127.0.0.1"
MYSQL_PORT="3306"
MYSQL_USERNAME="backup"
MYSQL_PASSWORD="backup"
LOCAL_BACKUPS_TO_KEEP="0"
CLOUD_BACKUPS_TO_KEEP="72"

function database_package
{
    if [[ $(dpkg-query -W -f='${Status}' mysql-client 2>/dev/null | grep -c "ok installed") -eq 0 ]]; then
        clear

        if [[ $EUID != 0 ]]; then
            sudo apt-get --yes update
        else
            apt-get --yes update
        fi

        if [[ $EUID != 0 ]]; then
            sudo apt-get --yes install mysql-client
        else
            apt-get --yes install mysql-client
        fi
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi
}

function backup_database
{
    database_package

    clear

    printf "${COLOR_GREEN}Backing up the databases...${COLOR_END}\n"

    MYSQL_CNF="$ROOT/mysql.cnf"
    echo "[client]" > $MYSQL_CNF
    echo "host=\"$MYSQL_HOSTNAME\"" >> $MYSQL_CNF
    echo "port=\"$MYSQL_PORT\"" >> $MYSQL_CNF
    echo "user=\"$MYSQL_USERNAME\"" >> $MYSQL_CNF
    echo "password=\"$MYSQL_PASSWORD\"" >> $MYSQL_CNF

    if [[ -d $ROOT/tmp ]]; then
        rm -rf $ROOT/tmp
    fi

    if [[ $LOCAL_BACKUPS_TO_KEEP -gt 0 && ! -f $ROOT/local/database/$BACKUP_DATE.tar.gz ]] || [[ $CLOUD_BACKUPS_TO_KEEP -gt 0 && ! -f $ROOT/cloud/database/$BACKUP_DATE.tar.gz ]]; then
        if [[ -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names -e "SHOW DATABASES;"` ]]; then
            printf "${COLOR_RED}The database server at $MYSQL_HOSTNAME is inaccessible by user $MYSQL_USERNAME.${COLOR_END}\n"
            rm -rf $MYSQL_CNF
            exit $?
        fi

        DATABASES="$(mysql --defaults-extra-file=$MYSQL_CNF -Bse 'SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME NOT IN ("'information_schema'", "'mysql'", "'performance_schema'", "'sys'", "'phpmyadmin'", "'aowow'") AND SCHEMA_NAME NOT LIKE "'%world%'"')"

        for DATABASE in $DATABASES; do
            printf "${COLOR_ORANGE}Backing up database $DATABASE${COLOR_END}\n"

            mkdir -p $ROOT/tmp/$BACKUP_DATE/$DATABASE

            for TABLE in `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names -e "SHOW TABLES FROM $DATABASE"`; do
                mysqldump --defaults-extra-file=$MYSQL_CNF --hex-blob $DATABASE $TABLE > $ROOT/tmp/$BACKUP_DATE/$DATABASE/$TABLE.sql
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi
            done
        done

        cd $ROOT/tmp/$BACKUP_DATE

        printf "${COLOR_ORANGE}Creating the compressed archive${COLOR_END}\n"

        tar -czvf $ROOT/tmp/$BACKUP_DATE.tar.gz * > /dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            rm -rf $MYSQL_CNF
            exit $?
        fi

        if [[ $LOCAL_BACKUPS_TO_KEEP -gt 0 ]]; then
            if [[ ! -d $ROOT/local/database ]]; then
                mkdir -p $ROOT/local/database
            fi

            printf "${COLOR_ORANGE}Copying the archive to the local storage${COLOR_END}\n"

            cp -r $ROOT/tmp/$BACKUP_DATE.tar.gz $ROOT/local/database/$BACKUP_DATE.tar.gz

            MAX_FILES=$((LOCAL_BACKUPS_TO_KEEP + 1))
            ls -tp $ROOT/local/database/* | grep -v '/$' | tail -n +$MAX_FILES | xargs -d '\n' -r rm --
        fi

        if [[ $CLOUD_BACKUPS_TO_KEEP -gt 0 ]]; then
            if [[ ! -d $ROOT/cloud/database ]]; then
                mkdir -p $ROOT/cloud/database
            fi

            cp -r $ROOT/tmp/$BACKUP_DATE.tar.gz $ROOT/cloud/database/$BACKUP_DATE.tar.gz

            MAX_FILES=$((CLOUD_BACKUPS_TO_KEEP + 1))
            ls -tp $ROOT/cloud/database/* | grep -v '/$' | tail -n +$MAX_FILES | xargs -d '\n' -r rm --

            mega-put $ROOT/cloud/database /Backup
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi

            FILE_COUNT=$(mega-ls /Backup/database | wc -l)
            REMOVED_FILE_COUNT=$((FILE_COUNT - CLOUD_BACKUPS_TO_KEEP))

            if [[ $REMOVED_FILE_COUNT > 0 ]]; then
                for f in `mega-ls /Backup/database | head -n $REMOVED_FILE_COUNT`; do
                    mega-rm -r -f /Backup/database/$f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        rm -rf $ROOT/tmp
    else
        if [[ ! $LOCAL_BACKUPS_TO_KEEP -gt 0 ]] && [[ ! $CLOUD_BACKUPS_TO_KEEP -gt 0 ]]; then
            printf "${COLOR_RED}All backup storage options are disabled.${COLOR_END}\n"
        else
            printf "${COLOR_RED}A backup of the current date and time has already been created.${COLOR_END}\n"
        fi
    fi

    printf "${COLOR_GREEN}Finished backing up the databases...${COLOR_END}\n"

    rm -rf $MYSQL_CNF
}

load_options
backup_database
