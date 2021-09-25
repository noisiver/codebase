#!/bin/bash
function import_database
{
    install_database_packages

    clear

    echo -e "\e[0;32mImporting database files\e[0m"

    echo "[client]" > $MYSQL_CONFIG
    echo "host=\"$MYSQL_HOSTNAME\"" >> $MYSQL_CONFIG
    echo "port=\"$MYSQL_PORT\"" >> $MYSQL_CONFIG
    echo "user=\"$MYSQL_USERNAME\"" >> $MYSQL_CONFIG
    echo "password=\"$MYSQL_PASSWORD\"" >> $MYSQL_CONFIG

    if [ $1 == 0 ] || [ $1 == 1 ]; then
        if [ ! -z `mysql --defaults-extra-file=$MYSQL_CONFIG --skip-column-names -e "SHOW DATABASES LIKE '$MYSQL_DATABASE_AUTH'"` ]; then
        
        fi
    fi

    if [ $1 == 0 ] || [ $1 == 2 ]; then
        if [ ! -z `mysql --defaults-extra-file=$MYSQL_CONFIG --skip-column-names -e "SHOW DATABASES LIKE '$MYSQL_DATABASE_CHARACTERS'"` ]; then
        
        fi
    fi

    if [ $1 == 0 ] || [ $1 == 2 ]; then
        if [ ! -z `mysql --defaults-extra-file=$MYSQL_CONFIG --skip-column-names -e "SHOW DATABASES LIKE '$MYSQL_DATABASE_WORLD'"` ]; then
        
        fi
    fi

    if [ $1 == 0 ] || [ $1 == 2 ]; then
        if [ ! -z `mysql --defaults-extra-file=$MYSQL_CONFIG --skip-column-names -e "SHOW DATABASES LIKE '$MYSQL_DATABASE_LOGS'"` ]; then
        
        fi
    fi

    rm -rf $MYSQL_CONFIG
}

function update_database
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

for f in db/*_world.sql; do
    MIGRATION="${f:3:-10}"

    if [ -z `mysql --defaults-extra-file=$MYSQL_CONFIG --skip-column-names $MYSQL_DATABASE_WORLD -e "SELECT id FROM migrations WHERE id='${MIGRATION}'"` ]; then
        echo "No"
    fi
done
