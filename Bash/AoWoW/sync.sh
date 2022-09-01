#!/bin/bash
if [[ $# -eq 0 ]] || [[ ! $1 == "cron" ]]; then
    while true; do
        read -p "Do you want to import all data from the world database into aowow? This may take a long time. (Y/N)" yn
            case $yn in
                [Yy]*) break;;
                [Nn]*) clear; exit;;
                *) echo "Please choose Y or N.";;
        esac
    done
fi

clear

ROOT=$(pwd)

OPTION_MYSQL_HOSTNAME="127.0.0.1"
OPTION_MYSQL_PORT="3306"
OPTION_MYSQL_USERNAME="aowow"
OPTION_MYSQL_PASSWORD="aowow"
OPTION_MYSQL_DATABASES_WORLD="aowow_world"
OPTION_SOURCE_LOCATION="/opt/azerothcore"

MYSQL_CNF="$ROOT/mysql.cnf"
echo "[client]" > $MYSQL_CNF
echo "host=\"$OPTION_MYSQL_HOSTNAME\"" >> $MYSQL_CNF
echo "port=\"$OPTION_MYSQL_PORT\"" >> $MYSQL_CNF
echo "user=\"$OPTION_MYSQL_USERNAME\"" >> $MYSQL_CNF
echo "password=\"$OPTION_MYSQL_PASSWORD\"" >> $MYSQL_CNF

if [[ -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names -e "SHOW DATABASES LIKE '$OPTION_MYSQL_DATABASES_WORLD'"` ]]; then
    printf "The database named $OPTION_MYSQL_DATABASES_WORLD is inaccessible by the user named $OPTION_MYSQL_USERNAME.\n"
    rm -rf $MYSQL_CNF
    exit $?
fi

if [[ ! -d $OPTION_SOURCE_LOCATION/data/sql/base/db_world ]] || [[ ! -d $OPTION_SOURCE_LOCATION/data/sql/updates/db_world ]]; then
    printf "There are no database files where there should be.\n"
    printf "Please make sure to install the server first.\n"
    rm -rf $MYSQL_CNF
    exit $?
fi

printf "Importing the database files...\n"

for f in $OPTION_SOURCE_LOCATION/data/sql/base/db_world/*.sql; do
    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_WORLD -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]]; then
        printf "Skipping "$(basename $f)"\n"
        continue;
    fi

    if [[ $? -ne 0 ]]; then
        rm -rf $MYSQL_CNF
        exit $?
    fi

    printf "Importing "$(basename $f)"\n"
    mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

    if [[ $? -ne 0 ]]; then
        rm -rf $MYSQL_CNF
        exit $?
    fi
done

for f in $OPTION_SOURCE_LOCATION/data/sql/updates/db_world/*.sql; do
    FILENAME=$(basename $f)
    HASH=($(sha1sum $f))

    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH@U}'"` ]]; then
        printf "Skipping "$(basename $f)"\n"
        continue;
    fi

    printf "Importing "$(basename $f)"\n"
    mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH@U}', 'RELEASED')"

    if [[ $? -ne 0 ]]; then
        rm -rf $MYSQL_CNF
        exit $?
    fi

    mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

    if [[ $? -ne 0 ]]; then
        rm -rf $MYSQL_CNF
        exit $?
    fi
done

if [[ -d $OPTION_SOURCE_LOCATION/modules/mod-archmage-timear/data/sql/db-world/base/ ]]; then
    for f in $OPTION_SOURCE_LOCATION/modules/mod-archmage-timear/data/sql/db-world/base/*.sql; do
        FILENAME=$(basename $f)
        HASH=($(sha1sum $f))

        if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH@U}'"` ]]; then
            printf "Skipping "$(basename $f)"\n"
            continue;
        fi

        printf "Importing "$(basename $f)"\n"
        mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH@U}', 'CUSTOM')"
        mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

        if [[ $? -ne 0 ]]; then
            rm -rf $MYSQL_CNF
            exit $?
        fi
    done
fi

if [[ -d $OPTION_SOURCE_LOCATION/modules/mod-assistant/data/sql/db-world/base/ ]]; then
    for f in $OPTION_SOURCE_LOCATION/modules/mod-assistant/data/sql/db-world/base/*.sql; do
        FILENAME=$(basename $f)
        HASH=($(sha1sum $f))

        if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH@U}'"` ]]; then
            printf "Skipping "$(basename $f)"\n"
            continue;
        fi

        printf "Importing "$(basename $f)"\n"
        mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH@U}', 'CUSTOM')"
        mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

        if [[ $? -ne 0 ]]; then
            rm -rf $MYSQL_CNF
            exit $?
        fi
    done
fi

if [[ -d $OPTION_SOURCE_LOCATION/modules/mod-groupquests/data/sql/db-world/base/ ]]; then
    for f in $OPTION_SOURCE_LOCATION/modules/mod-groupquests/data/sql/db-world/base/*.sql; do
        FILENAME=$(basename $f)
        HASH=($(sha1sum $f))

        if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $OPTION_MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH@U}'"` ]]; then
            printf "Skipping "$(basename $f)"\n"
            continue;
        fi

        printf "Importing "$(basename $f)"\n"
        mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH@U}', 'CUSTOM')"
        mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

        if [[ $? -ne 0 ]]; then
            rm -rf $MYSQL_CNF
            exit $?
        fi
    done
fi

if [[ -d $ROOT/sql/world ]]; then
    if [[ ! -z "$(ls -A $ROOT/sql/world/)" ]]; then
        for f in $ROOT/sql/world/*.sql; do
            printf "Importing "$(basename $f)"\n"
            mysql --defaults-extra-file=$MYSQL_CNF $OPTION_MYSQL_DATABASES_WORLD < $f

            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi
fi

LOCATION="/var/www/html/database"
OPTIONS=(access_requirement
         creature_template
         disables
         game_event
         gameobject_template
         item_template
         quest_template
         spell_enchant_proc_data
         spelldifficulty_dbc)

cd $LOCATION
SECONDS=0
PROGRESS=1
for o in "${OPTIONS[@]}"; do
    printf '\e[0;32mSyncing '$o' ('$PROGRESS' of '${#OPTIONS[@]}')\e[0m\n'
    php aowow --sync=$o
    if [ $? -ne 0 ]; then
        printf '\e[0;31mSyncing '$o' failed after %02dh:%02dm:%02ds\e[0m\n' $(($SECONDS / 3600)) $((($SECONDS / 60) % 60)) $(($SECONDS % 60))
        exit $?
    fi
    PROGRESS=$(($PROGRESS + 1))
done
printf '\e[0;32mSyncing finished after %02dh:%02dm:%02ds\e[0m\n' $(($SECONDS / 3600)) $((($SECONDS / 60) % 60)) $(($SECONDS % 60))
