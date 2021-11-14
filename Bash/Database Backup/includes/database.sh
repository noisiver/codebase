#!/bin/bash
function backup_database
{
    install_database_packages

    clear

    echo "[client]" > $MYSQL_CONFIG
    echo "host=\"$MYSQL_HOSTNAME\"" >> $MYSQL_CONFIG
    echo "port=\"$MYSQL_PORT\"" >> $MYSQL_CONFIG
    echo "user=\"$MYSQL_USERNAME\"" >> $MYSQL_CONFIG
    echo "password=\"$MYSQL_PASSWORD\"" >> $MYSQL_CONFIG

    if [[ -f $1/$BACKUP_DATE.tar.gz ]]; then
        echo -e "\e[0;32mInitialization aborted\e[0m"
        echo -e "\e[0;33mA backup for this date and time already exist\e[0m"
        rm -rf $MYSQL_CONFIG
        exit 1
    fi

    DATABASE="$(mysql --defaults-extra-file=$MYSQL_CONFIG -Bse 'SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME NOT IN ("'information_schema'", "'mysql'", "'performance_schema'", "'phpmyadmin'") AND SCHEMA_NAME NOT LIKE "'%world%'" AND SCHEMA_NAME NOT LIKE "'%aowow%'" AND SCHEMA_NAME NOT LIKE "'%hotfixes%'"')"

    echo -e "\e[0;32mInitializing\e[0m"
    echo -e "\e[0;33mBacking up databases\e[0m"

    for DB in $DATABASE; do
        echo -e "\n\e[0;32mBacking up database $DB\e[0m"
        mkdir -p $1/tmp/$BACKUP_DATE/$DB

        for TABLE in `mysql --defaults-extra-file=$MYSQL_CONFIG --skip-column-names -e "SHOW TABLES FROM $DB"`; do
            echo -e "\e[0;33mExporting table $TABLE\e[0m"
            mysqldump --defaults-extra-file=$MYSQL_CONFIG --hex-blob $DB $TABLE > $1/tmp/$BACKUP_DATE/$DB/$TABLE.sql
        done
    done

    cd $1/tmp/$BACKUP_DATE
    tar -czvf $1/$BACKUP_DATE.tar.gz * > /dev/null 2>&1
    rm -rf $1/tmp
    rm -rf $MYSQL_CONFIG

    MAX_FILES=$((BACKUP_MAX_FILES + 1))
    ls -tp $1/* | grep -v '/$' | tail -n +$MAX_FILES | xargs -d '\n' -r rm --
}
