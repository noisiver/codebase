#!/bin/bash
function import_database()
{
    install_database_packages

    clear

    echo -e "\e[0;32mImporting database files\e[0m"

    echo "[client]" > $MYSQL_CONFIG
    echo "host=\"$MYSQL_HOSTNAME\"" >> $MYSQL_CONFIG
    echo "port=\"$MYSQL_PORT\"" >> $MYSQL_CONFIG
    echo "user=\"$MYSQL_USERNAME\"" >> $MYSQL_CONFIG
    echo "password=\"$MYSQL_PASSWORD\"" >> $MYSQL_CONFIG

    rm -rf $MYSQL_CONFIG
}
