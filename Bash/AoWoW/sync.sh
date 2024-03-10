#!/bin/bash
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

OPTIONS=(access_requirement
         creature_template
         disables
         game_event
         gameobject_template
         item_template
         quest_template
         spell_enchant_proc_data
         spelldifficulty_dbc)

if [[ ! -f $ROOT/config.sh ]]; then
    printf "${COLOR_RED}The config file is missing. Generating one with default values.${COLOR_END}\n"
    printf "${COLOR_RED}Make sure to edit it before running this script again.${COLOR_END}\n"

    echo "MYSQL_HOSTNAME=\"127.0.0.1\"" > $ROOT/config.sh
    echo "MYSQL_PORT=\"3306\"" >> $ROOT/config.sh
    echo "MYSQL_USERNAME=\"acore\"" >> $ROOT/config.sh
    echo "MYSQL_PASSWORD=\"acore\"" >> $ROOT/config.sh
    echo "MYSQL_DATABASES_WORLD=\"acore_world\"" >> $ROOT/config.sh
    echo "SOURCE_REPOSITORY=\"https://github.com/azerothcore/azerothcore-wotlk.git\"" >> $ROOT/config.sh
    echo "SOURCE_BRANCH=\"master\"" >> $ROOT/config.sh
    echo "GROUP_QUESTS_ENABLED=\"false\"" >> $ROOT/config.sh
    echo "PROGRESSION_ENABLED=\"false\"" >> $ROOT/config.sh
    echo "PROGRESSION_PATCH=\"21\"" >> $ROOT/config.sh
    echo "AOWOW_LOCATION=\"/var/www/html/database\"" >> $ROOT/config.sh
    exit $?
fi

source "$ROOT/config.sh"

function install_packages
{
    PACKAGES=("git" "mysql-client")

    for p in "${PACKAGES[@]}"; do
        if [[ $(dpkg-query -W -f='${Status}' $p 2>/dev/null | grep -c "ok installed") -eq 0 ]]; then
            INSTALL+=($p)
        fi
    done

    if [[ ${#INSTALL[@]} -gt 0 ]]; then
        clear

        if [[ $EUID != 0 ]]; then
            sudo apt-get --yes update
        else
            apt-get --yes update
        fi
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        if [[ $EUID != 0 ]]; then
            sudo apt-get --yes install ${INSTALL[*]}
        else
            apt-get --yes install ${INSTALL[*]}
        fi
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi
}

function get_source
{
    printf "${COLOR_GREEN}Downloading the source code...${COLOR_END}\n"

    if [[ ! -d $ROOT/source ]]; then
        git clone --recursive --depth 1 --branch $SOURCE_BRANCH $SOURCE_REPOSITORY $ROOT/source
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    else
        cd $ROOT/source

        git reset --hard origin/$SOURCE_BRANCH
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        git pull
        if [[ $? -ne 0 ]]; then
            exit $?
        fi

        git submodule update
        if [[ $? -ne 0 ]]; then
            exit $?
        fi
    fi

    if [[ $GROUP_QUESTS_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/modules/mod-groupquests ]]; then
            git clone --depth 1 --branch master https://github.com/noisiver/mod-groupquests.git $ROOT/source/modules/mod-groupquests
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        else
            cd $ROOT/source/modules/mod-groupquests

            git reset --hard origin/master
            if [[ $? -ne 0 ]]; then
                exit $?
            fi

            git pull
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        fi
    else
        if [[ -d $ROOT/source/modules/mod-groupquests ]]; then
            rm -rf $ROOT/source/modules/mod-groupquests

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi

    if [[ $PROGRESSION_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/modules/mod-progression ]]; then
            git clone --depth 1 --branch master https://github.com/noisiver/mod-progression.git $ROOT/source/modules/mod-progression
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        else
            cd $ROOT/source/modules/mod-progression

            git reset --hard origin/master
            if [[ $? -ne 0 ]]; then
                exit $?
            fi

            git pull
            if [[ $? -ne 0 ]]; then
                exit $?
            fi
        fi
    else
        if [[ -d $ROOT/source/modules/mod-progression ]]; then
            rm -rf $ROOT/source/modules/mod-progression

            if [[ -d $ROOT/source/build ]]; then
                rm -rf $ROOT/source/build
            fi
        fi
    fi
}

function drop_tables
{
    clear

    printf "${COLOR_GREEN}Dropping all existing tables...${COLOR_END}\n"

    MYSQL_CNF="$ROOT/mysql.cnf"
    echo "[client]" > $MYSQL_CNF
    echo "host=\"$MYSQL_HOSTNAME\"" >> $MYSQL_CNF
    echo "port=\"$MYSQL_PORT\"" >> $MYSQL_CNF
    echo "user=\"$MYSQL_USERNAME\"" >> $MYSQL_CNF
    echo "password=\"$MYSQL_PASSWORD\"" >> $MYSQL_CNF

    TABLES=$(mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e 'show tables' | awk '{ print $1}' | grep -v '^Tables')
    for t in $TABLES; do
        printf "${COLOR_ORANGE}Dropping $t${COLOR_END}\n"
        mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DROP TABLE IF EXISTS $t"
        if [[ $? -ne 0 ]]; then
            rm -rf $MYSQL_CNF
            exit $?
        fi
    done
    if [[ $? -ne 0 ]]; then
        rm -rf $MYSQL_CNF
        exit $?
    fi
}

function import_database
{
    clear

    printf "${COLOR_GREEN}Importing the database files...${COLOR_END}\n"

    MYSQL_CNF="$ROOT/mysql.cnf"
    echo "[client]" > $MYSQL_CNF
    echo "host=\"$MYSQL_HOSTNAME\"" >> $MYSQL_CNF
    echo "port=\"$MYSQL_PORT\"" >> $MYSQL_CNF
    echo "user=\"$MYSQL_USERNAME\"" >> $MYSQL_CNF
    echo "password=\"$MYSQL_PASSWORD\"" >> $MYSQL_CNF

    if [[ `ls -1 $ROOT/source/data/sql/base/db_world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/data/sql/base/db_world/*.sql; do
            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    else
        printf "${COLOR_RED}The required files for the world database are missing.${COLOR_END}\n"
    fi

    if [[ `ls -1 $ROOT/source/data/sql/updates/db_world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/data/sql/updates/db_world/*.sql; do
            FILENAME=$(basename $f)
            HASH=($(sha1sum $f))

            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi

            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi

    if [[ `ls -1 $ROOT/source/data/sql/custom/db_world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/source/data/sql/custom/db_world/*.sql; do
            FILENAME=$(basename $f)
            HASH=($(sha1sum $f))

            if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                continue;
            fi

            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi

            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi

    if [[ $GROUP_QUESTS_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/modules/mod-groupquests/data/sql/db-world/base ]]; then
            printf "${COLOR_RED}The group quests module is enabled but the files aren't where they should be.${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first.${COLOR_END}\n"
            exit $?
        fi

        if [[ `ls -1 $ROOT/source/modules/mod-groupquests/data/sql/db-world/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $ROOT/source/modules/mod-groupquests/data/sql/db-world/base/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                    continue;
                fi

                printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi

                mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                if [[ $? -ne 0 ]]; then
                    rm -rf $MYSQL_CNF
                    exit $?
                fi
            done
        fi
    fi

    if [[ $PROGRESSION_ENABLED == "true" ]]; then
        if [[ ! -d $ROOT/source/modules/mod-progression/src/patch_00-1_1/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_01-1_2/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_02-1_3/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_03-1_4/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_04-1_5/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_05-1_6/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_06-1_7/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_07-1_8/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_08-1_9/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_09-1_10/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_10-1_11/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_11-1_12/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_12-2_0/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_13-2_1/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_14-2_2/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_15-2_3/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_16-2_4/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_17-3_0/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_18-3_1/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_19-3_2/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_20-3_3/sql ]] || [[ ! -d $ROOT/source/modules/mod-progression/src/patch_21-3_3_5/sql ]]; then
            printf "${COLOR_RED}The progression module is enabled but the files aren't where they should be${COLOR_END}\n"
            printf "${COLOR_RED}Please make sure to install the server first${COLOR_END}\n"
            rm -rf $MYSQL_CNF
            exit $?
        fi

        if [[ "$PROGRESSION_PATCH" -ge "0" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_00-1_1/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_00-1_1/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "1" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_01-1_2/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_01-1_2/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "2" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_02-1_3/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_02-1_3/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "3" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_03-1_4/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_03-1_4/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "4" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_04-1_5/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_04-1_5/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "5" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_05-1_6/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_05-1_6/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "6" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_06-1_7/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_06-1_7/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "7" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_07-1_8/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_07-1_8/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "8" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_08-1_9/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_08-1_9/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "9" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_09-1_10/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_09-1_10/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "10" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_10-1_11/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_10-1_11/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "11" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_11-1_12/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_11-1_12/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "12" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_12-2_0/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_12-2_0/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "13" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_13-2_1/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_13-2_1/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "14" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_14-2_2/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_14-2_2/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "15" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_15-2_3/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_15-2_3/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "16" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_16-2_4/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_16-2_4/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "17" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_17-3_0/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_17-3_0/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "18" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_18-3_1/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_18-3_1/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "19" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_19-3_2/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_19-3_2/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "20" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_20-3_3/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_20-3_3/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$PROGRESSION_PATCH" -ge "21" ]]; then
            if [[ `ls -1 $ROOT/source/modules/mod-progression/src/patch_21-3_3_5/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $ROOT/source/modules/mod-progression/src/patch_21-3_3_5/sql/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$MYSQL_CNF --skip-column-names $MYSQL_DATABASES_WORLD -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${COLOR_ORANGE}Skipping "$(basename $f)"${COLOR_END}\n"
                        continue;
                    fi

                    printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi

                    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        rm -rf $MYSQL_CNF
                        exit $?
                    fi
                done
            fi
        fi
    fi

    if [[ ! -f $AOWOW_LOCATION/setup/spell_learn_spell.sql ]]; then
        printf "${COLOR_RED}Unable to find a file provided by aowow.${COLOR_END}\n"
        printf "${COLOR_RED}Make sure aowow is properly set up before trying again.${COLOR_END}\n"
        rm -rf $MYSQL_CNF
        exit $?
    fi

    printf "${COLOR_ORANGE}Importing spell_learn_spell.sql${COLOR_END}\n"
    mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $AOWOW_LOCATION/setup/spell_learn_spell.sql
    if [[ $? -ne 0 ]]; then
        rm -rf $MYSQL_CNF
        exit $?
    fi

    if [[ `ls -1 $ROOT/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $ROOT/sql/*.sql; do
            printf "${COLOR_ORANGE}Importing "$(basename $f)"${COLOR_END}\n"
            mysql --defaults-extra-file=$MYSQL_CNF $MYSQL_DATABASES_WORLD < $f
            if [[ $? -ne 0 ]]; then
                rm -rf $MYSQL_CNF
                exit $?
            fi
        done
    fi
}

function sync_aowow
{
    clear

    printf "${COLOR_GREEN}Syncing data...${COLOR_END}\n"

    cd $AOWOW_LOCATION
    SECONDS=0
    PROGRESS=1
    for o in "${OPTIONS[@]}"; do
        printf "${COLOR_ORANGE}Syncing "$o" ("$PROGRESS" of "${#OPTIONS[@]}")${COLOR_END}\n"
        php aowow --sync=$o
        if [ $? -ne 0 ]; then
            printf "${COLOR_RED}Syncing "$o" failed after %02dh:%02dm:%02ds${COLOR_END}\n" $(($SECONDS / 3600)) $((($SECONDS / 60) % 60)) $(($SECONDS % 60))
            exit $?
        fi
        PROGRESS=$(($PROGRESS + 1))
    done
    printf "${COLOR_GREEN}Syncing finished after %02dh:%02dm:%02ds${COLOR_END}\n" $(($SECONDS / 3600)) $((($SECONDS / 60) % 60)) $(($SECONDS % 60))
}

clear

if [[ $# -eq 0 ]] || [[ ! $1 == "cron" ]]; then
    while true; do
        read -p "Do you want to sync all data from the world database into aowow? This may take a long time. (Y/N)" yn
            case $yn in
                [Yy]*) break;;
                [Nn]*) clear; exit;;
                *) echo "Please choose Y or N.";;
        esac
    done
fi

install_packages
get_source
drop_tables
import_database
sync_aowow
