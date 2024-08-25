#!/bin/bash
distribution=("ubuntu22.04" "ubuntu24.04" "debian12")

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    os=$ID
    version=$VERSION_ID

    if [[ ! " ${distribution[@]} " =~ " ${os}${version} " ]]; then
        echo -e "\e[0;31mThis distribution is currently not supported\e[0m"
        exit $?
    fi
else
    echo -e "\e[0;31mUnable to determine the distribution\e[0m"
    exit $?
fi

color_black="\e[0;30m"
color_red="\e[0;31m"
color_green="\e[0;32m"
color_orange="\e[0;33m"
color_blue="\e[0;34m"
color_purple="\e[0;35m"
color_cyan="\e[0;36m"
color_light_gray="\e[0;37m"
color_dark_gray="\e[1;30m"
color_light_red="\e[1;31m"
color_light_green="\e[1;32m"
color_yellow="\e[1;33m"
color_light_blue="\e[1;34m"
color_light_purple="\e[1;35m"
color_light_cyan="\e[1;36m"
color_white="\e[1;37m"
color_end="\e[0m"

root=$(pwd)
source="$root/source" # Do not edit
mysql_cnf="$root/mysql.cnf" # Do not edit
telegram_inf="$root/telegram" # Do not edit

mysql_hostname="127.0.0.1" # This is the hostname of the mysql database
mysql_port="3306" # This is the port of the mysql database
mysql_username="acore" # This is the username the script will use when importing database files and also write it to any config files
mysql_password="acore" # This is the username the script will use when importing database files and also write it to any config files
mysql_database="acore_auth" # This is the name of the database that holds the SQL data provided with this script
id=1 # This is realm id

function install_packages
{
    packages=("git" "screen" "cmake" "make" "gcc" "clang" "curl" "unzip" "g++" "libssl-dev" "libbz2-dev" "libreadline-dev" "libncurses-dev" "libmysqlclient-dev" "mysql-client")

    if [[ "$os" == "ubuntu" && "$version" == "24.04" ]]; then
        packages+=("libboost1.83-all-dev")
    else
        packages+=("libboost1.74-all-dev")
    fi

    for p in "${packages[@]}"; do
        if [[ $(dpkg-query -W -f='${Status}' $p 2>/dev/null | grep -c "ok installed") -eq 0 ]]; then
            install+=($p)
        fi
    done

    if [[ ${#install[@]} -gt 0 ]]; then
        if [[ $EUID != 0 ]]; then
            sudo apt-get --yes update
        else
            apt-get --yes update
        fi
        if [[ $? != 0 ]]; then
            notify_telegram "An error occurred while trying to install the required packages"
            exit $?
        fi

        if [[ $EUID != 0 ]]; then
            sudo apt-get --yes install ${install[*]}
        else
            apt-get --yes install ${install[*]}
        fi
        if [[ $? != 0 ]]; then
            notify_telegram "An error occurred while trying to install the required packages"
            exit $?
        fi
    fi
}

function install_mysql_client
{
    if [[ $(dpkg-query -W -f='${Status}' mysql-client 2>/dev/null | grep -c "ok installed") -eq 0 ]]; then
        if [[ $EUID != 0 ]]; then
            sudo apt-get --yes update
        else
            apt-get --yes update
        fi
        if [[ $? != 0 ]]; then
            notify_telegram "An error occurred while trying to install the required packages"
            exit $?
        fi

        if [[ $EUID != 0 ]]; then
            sudo apt-get --yes install mysql-client
        else
            apt-get --yes install mysql-client
        fi
        if [[ $? != 0 ]]; then
            notify_telegram "An error occurred while trying to install the required packages"
            exit $?
        fi
    fi
}

function get_settings
{
    printf "${color_green}Loading settings from database...${color_end}\n"

    echo "[client]" > "$mysql_cnf"
    echo "host=\"$mysql_hostname\"" >> "$mysql_cnf"
    echo "port=\"$mysql_port\"" >> "$mysql_cnf"
    echo "user=\"$mysql_username\"" >> "$mysql_cnf"
    echo "password=\"$mysql_password\"" >> "$mysql_cnf"

    if [[ -z `mysql --defaults-extra-file="$mysql_cnf" --skip-column-names -e "SHOW DATABASES LIKE '$mysql_database'"` ]]; then
        printf "${color_red}The database $mysql_database is inaccessible by the user $mysql_username${color_end}\n"
        notify_telegram "An error occurred while trying to load settings from the database"
        rm -rf "$mysql_cnf"
        exit $?
    fi

    while read setting value; do
        if [[ "$setting" == "ERROR" ]]; then
            printf "${color_red}An error occurred while trying to read settings from the database${color_end}\n"
            notify_telegram "An error occurred while trying to load settings from the database"
            exit $?
        fi

        case "$setting" in
            "build.auth") build_auth="$value";;
            "build.world") build_world="$value";;
            "database.auth") database_auth="$value";;
            "database.characters") database_characters="$value";;
            "database.playerbots") database_playerbots="$value";;
            "database.world") database_world="$value";;
            "git.branch") git_branch="$value";;
            "git.repository") git_repository="$value";;
            "module.ah_bot") module_ah_bot="$value";;
            "module.appreciation") module_appreciation="$value";;
            "module.appreciation.level_boost.level") module_appreciation_level_boost_level="$value";;
            "module.archmage_timear") module_archmage_timear="$value";;
            "module.assistant") module_assistant="$value";;
            "module.groupquests") module_groupquests="$value";;
            "module.junktogold") module_junktogold="$value";;
            "module.learnspells") module_learnspells="$value";;
            "module.playerbots") module_playerbots="$value";;
            "module.playerbots.bots") module_playerbots_bots="$value";;
            "module.progression") module_progression="$value";;
            "module.progression.aura") module_progression_aura="$value";;
            "module.progression.patch") module_progression_patch="$value";;
            "module.recruitafriend") module_recruitafriend="$value";;
            "module.skip_dk_starting_area") module_skip_dk_starting_area="$value";;
            "module.weekendbonus") module_weekendbonus="$value";;
            "telegram.chat_id") telegram_chat_id="$value";;
            "telegram.token") telegram_token="$value";;
            "world.address") world_address="$value";;
            "world.data_directory") world_data_directory="$value";;
            "world.name") world_name="$value";;
            "world.port") world_port="$value";;
            "world.preload_grids") world_preload_grids="$value";;
            "world.set_creatures_active") world_set_creatures_active="$value";;
            "world.warden") world_warden="$value";;
            *) unknown="true"
        esac
        if [[ ! -z $setting && ! -z $value && -z $unknown ]]; then
            printf "${color_orange}$setting has been set to $value${color_end}\n"
        fi
    done <<<$(mysql --defaults-extra-file="$mysql_cnf" $mysql_database --skip-column-names -e "WITH s AS (SELECT id, setting, VALUE, ROW_NUMBER() OVER (PARTITION BY setting ORDER BY id DESC) nr FROM realm_settings WHERE (id = $id OR id = -1)) SELECT setting, value FROM s WHERE nr = 1;" 2>&1)

    if [[ -z $build_auth || -z $build_world || -z $database_auth || -z $database_characters || -z $database_playerbots || -z $database_world || -z $git_branch || -z $git_repository || -z $module_ah_bot || -z $module_appreciation || -z $module_appreciation_level_boost_level || -z $module_archmage_timear || -z $module_assistant || -z $module_groupquests || -z $module_junktogold || -z $module_learnspells|| -z $module_playerbots || -z $module_playerbots_bots || -z $module_progression || -z $module_progression_aura || -z $module_progression_patch || -z $module_recruitafriend || -z $module_skip_dk_starting_area || -z $module_weekendbonus || -z $telegram_chat_id || -z $telegram_token || -z $world_address || -z $world_data_directory || -z $world_name || -z $world_port || -z $world_preload_grids || -z $world_set_creatures_active || -z $world_warden ]]; then
        if [[ -z $build_auth ]]; then printf "${color_red}build.auth is not set in the settings${color_end}\n"; fi
        if [[ -z $build_world ]]; then printf "${color_red}build.world is not set in the settings${color_end}\n"; fi
        if [[ -z $database_auth ]]; then printf "${color_red}database.auth is not set in the settings${color_end}\n"; fi
        if [[ -z $database_characters ]]; then printf "${color_red}database.characters is not set in the settings${color_end}\n"; fi
        if [[ -z $database_playerbots ]]; then printf "${color_red}database.playerbots is not set in the settings${color_end}\n"; fi
        if [[ -z $database_world ]]; then printf "${color_red}database.world is not set in the settings${color_end}\n"; fi
        if [[ -z $git_branch ]]; then printf "${color_red}git.branch is not set in the settings${color_end}\n"; fi
        if [[ -z $git_repository ]]; then printf "${color_red}git.repository is not set in the settings${color_end}\n"; fi
        if [[ -z $module_ah_bot ]]; then printf "${color_red}module.ah_bot is not set in the settings${color_end}\n"; fi
        if [[ -z $module_appreciation ]]; then printf "${color_red}module.appreciation is not set in the settings${color_end}\n"; fi
        if [[ -z $module_appreciation_level_boost_level ]]; then printf "${color_red}module.appreciation.level_boost.level is not set in the settings${color_end}\n"; fi
        if [[ -z $module_archmage_timear ]]; then printf "${color_red}module.archmage_timear is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant ]]; then printf "${color_red}module.assistant is not set in the settings${color_end}\n"; fi
        if [[ -z $module_groupquests ]]; then printf "${color_red}module.groupquests is not set in the settings${color_end}\n"; fi
        if [[ -z $module_junktogold ]]; then printf "${color_red}module.junktogold is not set in the settings${color_end}\n"; fi
        if [[ -z $module_learnspells ]]; then printf "${color_red}module.learnspells is not set in the settings${color_end}\n"; fi
        if [[ -z $module_playerbots ]]; then printf "${color_red}module.playerbots is not set in the settings${color_end}\n"; fi
        if [[ -z $module_playerbots_bots ]]; then printf "${color_red}module.playerbots.bots is not set in the settings${color_end}\n"; fi
        if [[ -z $module_progression ]]; then printf "${color_red}module.progression is not set in the settings${color_end}\n"; fi
        if [[ -z $module_progression_aura ]]; then printf "${color_red}module.progression.aura is not set in the settings${color_end}\n"; fi
        if [[ -z $module_progression_patch ]]; then printf "${color_red}module.progression.patch is not set in the settings${color_end}\n"; fi
        if [[ -z $module_recruitafriend ]]; then printf "${color_red}module.recruitafriend is not set in the settings${color_end}\n"; fi
        if [[ -z $module_skip_dk_starting_area ]]; then printf "${color_red}module.skip_dk_starting_area is not set in the settings${color_end}\n"; fi
        if [[ -z $module_weekendbonus ]]; then printf "${color_red}module.weekendbonus is not set in the settings${color_end}\n"; fi
        if [[ -z $telegram_chat_id ]]; then printf "${color_red}telegram.chat_id is not set in the settings${color_end}\n"; fi
        if [[ -z $telegram_token ]]; then printf "${color_red}telegram.token is not set in the settings${color_end}\n"; fi
        if [[ -z $world_address ]]; then printf "${color_red}world.address is not set in the settings${color_end}\n"; fi
        if [[ -z $world_data_directory ]]; then printf "${color_red}world.data_directory is not set in the settings${color_end}\n"; fi
        if [[ -z $world_name ]]; then printf "${color_red}world.name is not set in the settings${color_end}\n"; fi
        if [[ -z $world_port ]]; then printf "${color_red}world.port is not set in the settings${color_end}\n"; fi
        if [[ -z $world_preload_grids ]]; then printf "${color_red}world.preload_grids is not set in the settings${color_end}\n"; fi
        if [[ -z $world_set_creatures_active ]]; then printf "${color_red}world.set_creatures_active is not set in the settings${color_end}\n"; fi
        if [[ -z $world_warden ]]; then printf "${color_red}world.warden is not set in the settings${color_end}\n"; fi
        error="true"
    fi

    if [[ "$telegram_chat_id" == "0" || "$telegram_token" == "0" ]]; then
        if [[ -f "$telegram_inf" ]]; then
            rm -rf "$telegram_inf"
        fi
    else
        if [[ ! -z $telegram_chat_id && ! -z $telegram_tokens ]]; then
            echo "$telegram_chat_id $telegram_token" > "$telegram_inf"
        fi
    fi

    rm -rf "$mysql_cnf"
    printf "${color_green}Finished loading all settings...${color_end}\n"

    if [[ $error == "true" ]]; then
        notify_telegram "An error occurred while trying to load settings from the database"
        exit $?
    fi

    if [[ $module_progression_patch -lt 17 ]]; then
        module_recruitafriend="false"
    fi
}

function notify_telegram
{
    if [[ -z $telegram_chat_id || -z $telegram_token ]] && [[ -f $telegram_inf ]]; then
        IFS=" " read -ra tg <<< $(<$telegram_inf)
        if [[ ${#tg[@]} -eq 2 ]]; then
            telegram_chat_id="${tg[0]}"
            telegram_token="${tg[1]}"
        fi
    fi

    if [[ ! -z $telegram_chat_id && ! -z $telegram_token && $telegram_chat_id != "0" && $telegram_token != "0" ]]; then
        curl -s -X POST https://api.telegram.org/bot$telegram_token/sendMessage -d chat_id=$telegram_chat_id -d text="[$world_name (id: $id)]: $1" > /dev/null
    fi
}

function get_source
{
    SECONDS=0

    printf "${color_green}Downloading the source code...${color_end}\n"

    if [[ ! -d "$source" ]]; then
        git clone --recursive --depth 1 --branch $git_branch "https://github.com/$git_repository" "$source"
        if [[ $? != 0 ]]; then
            notify_telegram "An error occurred while trying to download the source code"
            exit $?
        fi
    else
        cd "$source"

        git reset --hard origin/$git_branch
        if [[ $? != 0 ]]; then
            notify_telegram "An error occurred while trying to update the source code"
            exit $?
        fi

        git pull
        if [[ $? != 0 ]]; then
            notify_telegram "An error occurred while trying to update the source code"
            exit $?
        fi

        git submodule update
        if [[ $? != 0 ]]; then
            notify_telegram "An error occurred while trying to update the source code"
            exit $?
        fi
    fi

    if [[ "$build_world" == "true" ]]; then
        if [[ "$module_ah_bot" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-ah-bot" ]]; then
                git clone --depth 1 --branch noisiver "https://github.com/noisiver/mod-ah-bot.git" "$source/modules/mod-ah-bot"
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-ah-bot"
                    exit $?
                fi
            else
                cd "$source/modules/mod-ah-bot"

                git reset --hard origin/noisiver
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-ah-bot"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-ah-bot"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-ah-bot" ]]; then
                rm -rf "$source/modules/mod-ah-bot"
            fi
        fi

        if [[ "$module_appreciation" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-appreciation" ]]; then
                git clone --depth 1 --branch master "https://github.com/noisiver/mod-appreciation.git" "$source/modules/mod-appreciation"
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-appreciation"
                    exit $?
                fi
            else
                cd "$source/modules/mod-appreciation"

                git reset --hard origin/master
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-appreciation"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-appreciation"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-appreciation" ]]; then
                rm -rf "$source/modules/mod-appreciation"
            fi
        fi

        if [[ "$module_archmage_timear" == "true" ]] && [[ "$module_progression" == "false" ]]; then
            if [[ ! -d "$source/modules/mod-archmage-timear" ]]; then
                git clone --depth 1 --branch master "https://github.com/noisiver/mod-archmage-timear.git" "$source/modules/mod-archmage-timear"
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-archmage-timear"
                    exit $?
                fi
            else
                cd "$source/modules/mod-archmage-timear"

                git reset --hard origin/master
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-archmage-timear"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-archmage-timear"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-archmage-timear" ]]; then
                rm -rf "$source/modules/mod-archmage-timear"
            fi
        fi

        if [[ "$module_assistant" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-assistant" ]]; then
                git clone --depth 1 --branch master "https://github.com/noisiver/mod-assistant.git" "$source/modules/mod-assistant"
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-assistant"
                    exit $?
                fi
            else
                cd "$source/modules/mod-assistant"

                git reset --hard origin/master
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-assistant"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-assistant"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-assistant" ]]; then
                rm -rf "$source/modules/mod-assistant"
            fi
        fi

        if [[ "$module_groupquests" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-groupquests" ]]; then
                git clone --depth 1 --branch master "https://github.com/noisiver/mod-groupquests.git" "$source/modules/mod-groupquests"
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-groupquests"
                    exit $?
                fi
            else
                cd "$source/modules/mod-groupquests"

                git reset --hard origin/master
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-groupquests"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-groupquests"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-groupquests" ]]; then
                rm -rf "$source/modules/mod-groupquests"
            fi
        fi

        if [[ "$module_junktogold" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-junk-to-gold" ]]; then
                git clone --depth 1 --branch master "https://github.com/noisiver/mod-junk-to-gold.git" "$source/modules/mod-junk-to-gold"
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-junk-to-gold"
                    exit $?
                fi
            else
                cd "$source/modules/mod-junk-to-gold"

                git reset --hard origin/master
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-junk-to-gold"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-junk-to-gold"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-junk-to-gold" ]]; then
                rm -rf "$source/modules/mod-junk-to-gold"
            fi
        fi

        if [[ "$module_learnspells" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-learnspells" ]]; then
                if [[ $module_progression_patch -lt 21 ]]; then
                    git clone --depth 1 --branch progression "https://github.com/noisiver/mod-learnspells.git" "$source/modules/mod-learnspells"
                else
                    git clone --depth 1 --branch master "https://github.com/noisiver/mod-learnspells.git" "$source/modules/mod-learnspells"
                fi
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-learnspells"
                    exit $?
                fi
            else
                cd "$source/modules/mod-learnspells"

                if [[ $module_progression_patch -lt 21 ]]; then
                    git reset --hard origin/progression
                else
                    git reset --hard origin/master
                fi
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-learnspells"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-learnspells"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-learnspells" ]]; then
                rm -rf "$source/modules/mod-learnspells"
            fi
        fi

        if [[ "$module_playerbots" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-playerbots" ]]; then
                git clone --depth 1 --branch master "https://github.com/liyunfan1223/mod-playerbots.git" "$source/modules/mod-playerbots"
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-playerbots"
                    exit $?
                fi
            else
                cd "$source/modules/mod-playerbots"

                git reset --hard origin/master
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-playerbots"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-playerbots"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-playerbots" ]]; then
                rm -rf "$source/modules/mod-playerbots"
            fi
        fi

        if [[ "$module_progression" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-progression" ]]; then
                git clone --depth 1 --branch master "https://github.com/noisiver/mod-progression.git" "$source/modules/mod-progression"
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-progression"
                    exit $?
                fi
            else
                cd "$source/modules/mod-progression"

                git reset --hard origin/master
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-progression"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-progression"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-progression" ]]; then
                rm -rf "$source/modules/mod-progression"
            fi
        fi

        if [[ "$module_recruitafriend" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-recruitafriend" ]]; then
                git clone --depth 1 --branch master "https://github.com/noisiver/mod-recruitafriend.git" "$source/modules/mod-recruitafriend"
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-recruitafriend"
                    exit $?
                fi
            else
                cd "$source/modules/mod-recruitafriend"

                git reset --hard origin/master
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-recruitafriend"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-recruitafriend"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-recruitafriend" ]]; then
                rm -rf "$source/modules/mod-recruitafriend"
            fi
        fi

        if [[ "$module_skip_dk_starting_area" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-skip-dk-starting-area" ]]; then
                git clone --depth 1 --branch master "https://github.com/azerothcore/mod-skip-dk-starting-area.git" "$source/modules/mod-skip-dk-starting-area"
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-skip-dk-starting-area"
                    exit $?
                fi
            else
                cd "$source/modules/mod-skip-dk-starting-area"

                git reset --hard origin/master
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-skip-dk-starting-area"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-skip-dk-starting-area"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-skip-dk-starting-area" ]]; then
                rm -rf "$source/modules/mod-skip-dk-starting-area"
            fi
        fi

        if [[ "$module_weekendbonus" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-weekendbonus" ]]; then
                git clone --depth 1 --branch master "https://github.com/noisiver/mod-weekendbonus.git" "$source/modules/mod-weekendbonus"
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to download the source code of mod-weekendbonus"
                    exit $?
                fi
            else
                cd "$source/modules/mod-weekendbonus"

                git reset --hard origin/master
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-weekendbonus"
                    exit $?
                fi

                git pull
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to update the source code of mod-weekendbonus"
                    exit $?
                fi
            fi
        else
            if [[ -d "$source/modules/mod-weekendbonus" ]]; then
                rm -rf "$source/modules/mod-weekendbonus"
            fi
        fi
    fi

    printf "${color_orange}Finished after %02dh:%02dm:%02ds${color_end}\n" $(($SECONDS / 3600)) $((($SECONDS / 60) % 60)) $(($SECONDS % 60))
    printf "${color_green}Finished downloading the source code...${color_end}\n"
}

function compile_source
{
    SECONDS=0

    printf "${color_green}Compiling the source code...${color_end}\n"

    mkdir -p "$source/build" && cd "$_"

    if [[ "$build_auth" == "true" && "$build_world" == "true" ]]; then
        apps="all"
    elif [[ "$build_auth" == "true" && "$build_world" != "true" ]]; then
        apps="auth-only"
    elif [[ "$build_auth" != "true" && "$build_world" == "true" ]]; then
        apps="world-only"
    fi

    for i in {1..2}; do
        if [[ "$module_playerbots" == "true" ]]; then
            cmake ../ -DCMAKE_INSTALL_PREFIX=$source -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=0 -DSCRIPTS=static -DAPPS_BUILD="$apps" -DCMAKE_CXX_FLAGS="-w"
        else
            cmake ../ -DCMAKE_INSTALL_PREFIX=$source -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DSCRIPTS=static -DAPPS_BUILD="$apps"
        fi

        if [[ $? -ne 0 ]]; then
            notify_telegram "An error occurred while trying to compile the source code"
            exit $?
        fi

        make -j $(nproc)
        if [[ $? -ne 0 ]]; then
            if [[ $i == 1 ]]; then
                make clean
            else
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi
        else
            break
        fi
    done

    make install
    if [[ $? -ne 0 ]]; then
        notify_telegram "An error occurred while trying to compile the source code"
        exit $?
    fi

    echo "#!/bin/bash" > "$source/bin/start.sh"
    echo "#!/bin/bash" > "$source/bin/stop.sh"

    if [[ "$build_auth" == "true" ]]; then
        echo "screen -AmdS auth ./auth.sh" >> "$source/bin/start.sh"
        echo "screen -X -S \"auth\" quit" >> "$source/bin/stop.sh"

        echo "#!/bin/bash" > "$source/bin/auth.sh"
        echo "while :; do" >> "$source/bin/auth.sh"
        echo "    ./authserver" >> "$source/bin/auth.sh"
        echo "    sleep 5" >> "$source/bin/auth.sh"
        echo "done" >> "$source/bin/auth.sh"

        chmod +x "$source/bin/auth.sh"
    else
        if [[ -f "$source/bin/auth.sh" ]]; then
            rm -rf "$source/bin/auth.sh"
        fi
    fi

    if [[ "$build_world" == "true" ]]; then
        echo "TIME=\$(date +%s)" >> "$source/bin/start.sh"
        echo "screen -L -Logfile \$TIME.log -AmdS world-$id ./world.sh" >> "$source/bin/start.sh"
        echo "screen -X -S \"world-$id\" quit" >> "$source/bin/stop.sh"

        echo "#!/bin/bash" > "$source/bin/world.sh"
        echo "while :; do" >> "$source/bin/world.sh"
        echo "    nice -n -19 taskset -c 1,2,3 ./worldserver" >> "$source/bin/world.sh"
        echo "    if [[ \$? == 0 ]]; then" >> "$source/bin/world.sh"
        echo "      break" >> "$source/bin/world.sh"
        echo "    fi" >> "$source/bin/world.sh"
        echo "    sleep 5" >> "$source/bin/world.sh"
        echo "done" >> "$source/bin/world.sh"

        chmod +x "$source/bin/world.sh"
    else
        if [[ -f "$source/bin/world.sh" ]]; then
            rm -rf "$source/bin/world.sh"
        fi
    fi

    chmod +x "$source/bin/start.sh"
    chmod +x "$source/bin/stop.sh"

    printf "${color_orange}Finished after %02dh:%02dm:%02ds${color_end}\n" $(($SECONDS / 3600)) $((($SECONDS / 60) % 60)) $(($SECONDS % 60))
    printf "${color_green}Finished compiling the source code...${color_end}\n"
}

function get_client_files
{
    if [[ "$build_world" == "true" ]]; then
        version=$(git ls-remote --tags --sort="v:refname" https://github.com/wowgaming/client-data.git | tail -n1 | cut --delimiter='/' --fields=3 | sed 's/v//')

        if [[ "$world_data_directory" == "." ]]; then
            world_data_directory="$source/bin"
        elif [[ "$world_data_directory" == ./* ]]; then
            world_data_directory="$source/bin/"${world_data_directory:2}""
        fi

        if [[ ! -d "$world_data_directory" ]]; then
            mkdir -p "$world_data_directory"
        fi

        if [[ -f "$world_data_directory/data.version" ]]; then
            world_data_version=$(<$world_data_directory/data.version)
        else
            world_data_version="0"
        fi

        if [[ "$world_data_version" == "0" || "$world_data_version" != "$version" || ! -d "$world_data_directory/Cameras" || ! -d "$world_data_directory/dbc" || ! -d "$world_data_directory/maps" || ! -d "$world_data_directory/mmaps" || ! -d "$world_data_directory/vmaps" ]]; then
            printf "${color_green}Downloading the client data files...${color_end}\n"

            if [[ -f "$world_data_directory/data.zip" ]]; then
                rm -rf "$world_data_directory/data.zip"
            fi
            if [[ -d "$world_data_directory/Cameras" ]]; then
                rm -rf "$world_data_directory/Cameras"
            fi
            if [[ -d "$world_data_directory/dbc" ]]; then
                rm -rf "$world_data_directory/dbc"
            fi
            if [[ -d "$world_data_directory/maps" ]]; then
                rm -rf "$world_data_directory/maps"
            fi
            if [[ -d "$world_data_directory/mmaps" ]]; then
                rm -rf "$world_data_directory/mmaps"
            fi
            if [[ -d "$world_data_directory/vmaps" ]]; then
                rm -rf "$world_data_directory/vmaps"
            fi

            curl -f -L "https://github.com/wowgaming/client-data/releases/download/v${version}/data.zip" -o "$world_data_directory/data.zip"
            if [[ $? -ne 0 ]]; then
                rm -rf "$world_data_directory/data.zip"
                notify_telegram "An error occurred while trying to download the client data files"
                exit $?
            fi

            unzip -o "$world_data_directory/data.zip" -d "$world_data_directory/"
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to download the client data files"
                exit $?
            fi

            rm -rf "$world_data_directory/data.zip"

            echo "$version" > "$world_data_directory/data.version"

            printf "${color_green}Finished downloading the client data files...${color_end}\n"
        fi
    fi
}

function copy_dbc_files
{
    printf "${color_green}Copying modified client data files...${color_end}\n"

    if [[ "$build_world" == "true" ]]; then
        if [[ ! -d "$root/dbc" ]]; then
            mkdir "$root/dbc"
        fi

        if [[ `ls -1 $root/dbc/*.dbc 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $root/dbc/*.dbc; do
                printf "${color_orange}Copying "$(basename $f)"${color_end}\n"
                cp "$f" "$world_data_directory/dbc/$(basename $f)"
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to copy custom dbc files"
                    exit $?
                fi
            done
        else
            printf "${color_orange}No files found in the directory${color_end}\n"
        fi
    else
        printf "${color_orange}Skipping process due to world server being disabled${color_end}\n"
    fi

    printf "${color_green}Finished copying modified client data files...${color_end}\n"
}

function drop_database_tables
{
    SECONDS=0

    printf "${color_green}Dropping the database tables...${color_end}\n"

    if [[ "$build_world" == "true" ]]; then
        echo "[client]" > "$mysql_cnf"
        echo "host=\"$mysql_hostname\"" >> "$mysql_cnf"
        echo "port=\"$mysql_port\"" >> "$mysql_cnf"
        echo "user=\"$mysql_username\"" >> "$mysql_cnf"
        echo "password=\"$mysql_password\"" >> "$mysql_cnf"

        tables=$(mysql --defaults-extra-file=$mysql_cnf $database_world -e 'show tables' | awk '{print $1}' | grep -v '^Tables')
        for t in $tables; do
            printf "${color_orange}Dropping $t${color_end}\n"
            mysql --defaults-extra-file=$mysql_cnf $database_world -e "DROP TABLE IF EXISTS $t"
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to drop the database tables"
                rm -rf "$mysql_cnf"
                exit $?
            fi
        done

        printf "${color_orange}Finished after %02dh:%02dm:%02ds${color_end}\n" $(($SECONDS / 3600)) $((($SECONDS / 60) % 60)) $(($SECONDS % 60))
    else
        printf "${color_orange}Skipping process due to world server being disabled${color_end}\n"
    fi

    printf "${color_green}Finished dropping the database tables..${color_end}\n"
}

function import_database_files
{
    SECONDS=0

    printf "${color_green}Importing the database files...${color_end}\n"

    echo "[client]" > "$mysql_cnf"
    echo "host=\"$mysql_hostname\"" >> "$mysql_cnf"
    echo "port=\"$mysql_port\"" >> "$mysql_cnf"
    echo "user=\"$mysql_username\"" >> "$mysql_cnf"
    echo "password=\"$mysql_password\"" >> "$mysql_cnf"

    if [[ -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names -e "SHOW DATABASES LIKE '$database_auth'"` ]]; then
        printf "${color_red}The database named $database_auth is inaccessible by the user named $mysql_username${color_end}\n"
        notify_telegram "An error occurred while trying to import the database files"
        rm -rf "$mysql_cnf"
        exit $?
    fi

    if [[ "$build_world" == "true" ]]; then
        if [[ -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names -e "SHOW DATABASES LIKE '$database_characters'"` ]]; then
            printf "${color_red}The database named $database_characters is inaccessible by the user named $mysql_username${color_end}\n"
            notify_telegram "An error occurred while trying to import the database files"
            rm -rf "$mysql_cnf"
            exit $?
        fi

        if [[ -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names -e "SHOW DATABASES LIKE '$database_world'"` ]] && [[ $1 == "world" || $1 == "both" ]]; then
            printf "${color_red}The database named $database_world is inaccessible by the user named $mysql_username${color_end}\n"
            notify_telegram "An error occurred while trying to import the database files"
            rm -rf "$mysql_cnf"
            exit $?
        fi
    fi

    if [[ ! -d "$source/data/sql/base/db_auth" ]] || [[ ! -d "$source/data/sql/updates/db_auth" ]] || [[ ! -d "$source/data/sql/custom/db_auth" ]]; then
        printf "${color_red}There are no database files where there should be${color_end}\n"
        printf "${color_red}Please make sure to install the server first${color_end}\n"
        notify_telegram "An error occurred while trying to import the database files"
        rm -rf "$mysql_cnf"
        exit $?
    fi

    if [[ "$build_world" == "true" ]]; then
        if [[ ! -d "$source/data/sql/base/db_characters" ]] || [[ ! -d "$source/data/sql/updates/db_characters" ]] || [[ ! -d "$source/data/sql/custom/db_characters" ]] || [[ ! -d "$source/data/sql/base/db_world" ]] || [[ ! -d "$source/data/sql/updates/db_world" ]] || [[ ! -d "$source/data/sql/custom/db_world" ]]; then
            printf "${color_red}There are no database files where there should be${color_end}\n"
            printf "${color_red}Please make sure to install the server first${color_end}\n"
            notify_telegram "An error occurred while trying to import the database files"
            rm -rf "$mysql_cnf"
            exit $?
        fi
    fi

    if [[ ! -d "$root/sql/auth" ]]; then
        mkdir -p "$root/sql/auth"
        if [[ $? -ne 0 ]]; then
            notify_telegram "An error occurred while trying to import the database files"
            rm -rf "$mysql_cnf"
            exit $?
        fi
    fi

    if [[ "$build_world" == "true" ]]; then
        if [[ ! -d "$root/sql/characters" ]]; then
            mkdir -p "$root/sql/characters"
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to import the database files"
                rm -rf "$mysql_cnf"
                exit $?
            fi
        fi

        if [[ ! -d "$root/sql/world" ]]; then
            mkdir -p "$root/sql/world"
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to import the database files"
                rm -rf "$mysql_cnf"
                exit $?
            fi
        fi
    fi

    if [[ `ls -1 $source/data/sql/base/db_auth/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $source/data/sql/base/db_auth/*.sql; do
            if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_auth -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]]; then
                printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                continue;
            fi

            printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
            mysql --defaults-extra-file=$mysql_cnf $database_auth < $f
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to import the database files"
                rm -rf "$mysql_cnf"
                exit $?
            fi
        done
    else
        printf "${color_red}The required files for the auth database are missing${color_end}\n"
        printf "${color_red}Please make sure to install the server first${color_end}\n"
    fi

    if [[ `ls -1 $source/data/sql/updates/db_auth/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $source/data/sql/updates/db_auth/*.sql; do
            FILENAME=$(basename $f)
            HASH=($(sha1sum $f))

            if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_auth -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                continue;
            fi

            printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
            mysql --defaults-extra-file=$mysql_cnf $database_auth < $f
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to import the database files"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            mysql --defaults-extra-file=$mysql_cnf $database_auth -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to import the database files"
                rm -rf "$mysql_cnf"
                exit $?
            fi
        done
    fi

    if [[ `ls -1 $source/data/sql/custom/db_auth/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $source/data/sql/custom/db_auth/*.sql; do
            FILENAME=$(basename $f)
            HASH=($(sha1sum $f))

            if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_auth -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                continue;
            fi

            printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
            mysql --defaults-extra-file=$mysql_cnf $database_auth < $f
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to import the database files"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            mysql --defaults-extra-file=$mysql_cnf $database_auth -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to import the database files"
                rm -rf "$mysql_cnf"
                exit $?
            fi
        done
    fi

    if [[ `ls -1 $root/sql/auth/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
        for f in $root/sql/auth/*.sql; do
            printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
            mysql --defaults-extra-file=$mysql_cnf $database_auth < $f
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to import the database files"
                rm -rf "$mysql_cnf"
                exit $?
            fi
        done
    fi

    if [[ "$build_world" == "true" ]]; then
        if [[ `ls -1 $source/data/sql/base/db_characters/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $source/data/sql/base/db_characters/*.sql; do
                if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_characters -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]]; then
                    printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                    continue;
                fi

                printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                mysql --defaults-extra-file=$mysql_cnf $database_characters < $f
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi
            done
        else
            printf "${color_red}The required files for the characters database are missing${color_end}\n"
            printf "${color_red}Please make sure to install the server first${color_end}\n"
        fi

        if [[ `ls -1 $source/data/sql/updates/db_characters/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $source/data/sql/updates/db_characters/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_characters -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                    continue;
                fi

                printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                mysql --defaults-extra-file=$mysql_cnf $database_characters < $f
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi

                mysql --defaults-extra-file=$mysql_cnf $database_characters -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi
            done
        fi

        if [[ `ls -1 $source/data/sql/custom/db_characters/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $source/data/sql/custom/db_characters/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_characters -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                    continue;
                fi

                printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                mysql --defaults-extra-file=$mysql_cnf $database_characters < $f
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi

                mysql --defaults-extra-file=$mysql_cnf $database_characters -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi
            done
        fi

        if [[ `ls -1 $source/data/sql/base/db_world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $source/data/sql/base/db_world/*.sql; do
                if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]]; then
                    printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                    continue;
                fi

                printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi
            done
        else
            printf "${color_red}The required files for the world database are missing${color_end}\n"
            printf "${color_red}Please make sure to install the server first${color_end}\n"
        fi

        if [[ `ls -1 $source/data/sql/updates/db_world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $source/data/sql/updates/db_world/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                    continue;
                fi

                printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi

                mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi
            done
        fi

        if [[ `ls -1 $source/data/sql/custom/db_world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $source/data/sql/custom/db_world/*.sql; do
                FILENAME=$(basename $f)
                HASH=($(sha1sum $f))

                if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                    printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                    continue;
                fi

                printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi

                mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'RELEASED')"
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi
            done
        fi

        if [[ "$module_ah_bot" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-ah-bot/sql/world" ]]; then
                printf "${color_red}The auction house bot module is enabled but the files aren't where they should be${color_end}\n"
                printf "${color_red}Please make sure to install the server first${color_end}\n"
                notify_telegram "An error occurred while trying to import the database files of mod-ah-bot"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            if [[ `ls -1 $source/modules/mod-ah-bot/sql/world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $source/modules/mod-ah-bot/sql/world/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                        continue;
                    fi

                    printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                    mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-ah-bot"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi

                    mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-ah-bot"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi
                done
            fi

            mysql --defaults-extra-file=$mysql_cnf $database_world -e "UPDATE mod_auctionhousebot SET minitems=25000, maxitems=25000"
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to import the database files of mod-ah-bot"
                rm -rf "$mysql_cnf"
                exit $?
            fi
        fi

        if [[ "$module_appreciation" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-appreciation/data/sql/db-world/base" ]]; then
                printf "${color_red}The appreciation module is enabled but the files aren't where they should be${color_end}\n"
                printf "${color_red}Please make sure to install the server first${color_end}\n"
                notify_telegram "An error occurred while trying to import the database files of mod-appreciation"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            if [[ `ls -1 $source/modules/mod-appreciation/data/sql/db-world/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $source/modules/mod-appreciation/data/sql/db-world/base/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                        continue;
                    fi

                    printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                    mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-appreciation"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi

                    mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-appreciation"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$module_archmage_timear" == "true" ]] && [[ "$module_progression" == "false" ]]; then
            if [[ ! -d "$source/modules/mod-archmage-timear/data/sql/db-world/base" ]]; then
                printf "${color_red}The archmage timear module is enabled but the files aren't where they should be${color_end}\n"
                printf "${color_red}Please make sure to install the server first${color_end}\n"
                notify_telegram "An error occurred while trying to import the database files of mod-archmage-timear"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            if [[ `ls -1 $source/modules/mod-archmage-timear/data/sql/db-world/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $source/modules/mod-archmage-timear/data/sql/db-world/base/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                        continue;
                    fi

                    printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                    mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-archmage-timear"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi

                    mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-archmage-timear"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$module_assistant" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-assistant/sql/world" ]]; then
                printf "${color_red}The assistant module is enabled but the files aren't where they should be${color_end}\n"
                printf "${color_red}Please make sure to install the server first${color_end}\n"
                notify_telegram "An error occurred while trying to import the database files of mod-assistant"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            if [[ `ls -1 $source/modules/mod-assistant/sql/world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $source/modules/mod-assistant/sql/world/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                        continue;
                    fi

                    printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                    mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-assistant"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi

                    mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-assistant"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$module_groupquests" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-groupquests/sql/world" ]]; then
                printf "${color_red}The group quests module is enabled but the files aren't where they should be${color_end}\n"
                printf "${color_red}Please make sure to install the server first${color_end}\n"
                notify_telegram "An error occurred while trying to import the database files of mod-groupquests"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            if [[ `ls -1 $source/modules/mod-groupquests/sql/world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $source/modules/mod-groupquests/sql/world/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                        continue;
                    fi

                    printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                    mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-groupquests"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi

                    mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-groupquests"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$module_playerbots" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-playerbots/sql/characters" ]] || [[ ! -d "$source/modules/mod-playerbots/sql/playerbots/base" ]] || [[ ! -d "$source/modules/mod-playerbots/sql/world" ]]; then
                printf "${color_red}The playerbots module is enabled but the files aren't where they should be${color_end}\n"
                printf "${color_red}Please make sure to install the server first${color_end}\n"
                notify_telegram "An error occurred while trying to import the database files of mod-playerbots"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            if [[ `ls -1 $source/modules/mod-playerbots/sql/characters/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $source/modules/mod-playerbots/sql/characters/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_characters -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                        continue;
                    fi

                    printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                    mysql --defaults-extra-file=$mysql_cnf $database_characters < $f
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-playerbots"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi

                    mysql --defaults-extra-file=$mysql_cnf $database_characters -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-playerbots"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi
                done
            fi

            if [[ `ls -1 $source/modules/mod-playerbots/sql/playerbots/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $source/modules/mod-playerbots/sql/playerbots/base/*.sql; do
                    if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_playerbots -e "SHOW TABLES LIKE '$(basename $f .sql)'"` ]]; then
                        printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                        continue;
                    fi

                    printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                    mysql --defaults-extra-file=$mysql_cnf $database_playerbots < $f
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-playerbots"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi
                done
            fi

            if [[ `ls -1 $source/modules/mod-playerbots/sql/world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $source/modules/mod-playerbots/sql/world/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                        continue;
                    fi

                    printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                    mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-playerbots"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi

                    mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-playerbots"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$module_progression" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-progression/src/patch_00-1_1/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_01-1_2/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_02-1_3/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_03-1_4/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_04-1_5/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_05-1_6/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_06-1_7/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_07-1_8/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_08-1_9/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_09-1_10/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_10-1_11/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_11-1_12/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_12-2_0/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_13-2_1/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_14-2_2/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_15-2_3/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_16-2_4/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_17-3_0/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_18-3_1/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_19-3_2/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_20-3_3/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_21-3_3_5/sql" ]]; then
                printf "${color_red}The progression module is enabled but the files aren't where they should be${color_end}\n"
                printf "${color_red}Please make sure to install the server first${color_end}\n"
                notify_telegram "An error occurred while trying to import the database files of mod-progression"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name LIKE 'patch_%'"
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to import the database files of mod-progression"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            if [[ "$module_progression_patch" -ge "0" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_00-1_1/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_00-1_1/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "1" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_01-1_2/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_01-1_2/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "2" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_02-1_3/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_02-1_3/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "3" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_03-1_4/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_03-1_4/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "4" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_04-1_5/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_04-1_5/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "5" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_05-1_6/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_05-1_6/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "6" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_06-1_7/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_06-1_7/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "7" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_07-1_8/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_07-1_8/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "8" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_08-1_9/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_08-1_9/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "9" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_09-1_10/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_09-1_10/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "10" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_10-1_11/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_10-1_11/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "11" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_11-1_12/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_11-1_12/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "12" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_12-2_0/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_12-2_0/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "13" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_13-2_1/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_13-2_1/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "14" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_14-2_2/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_14-2_2/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "15" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_15-2_3/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_15-2_3/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "16" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_16-2_4/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_16-2_4/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "17" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_17-3_0/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_17-3_0/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "18" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_18-3_1/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_18-3_1/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "19" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_19-3_2/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_19-3_2/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "20" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_20-3_3/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_20-3_3/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi

            if [[ "$module_progression_patch" -ge "21" ]]; then
                if [[ `ls -1 $source/modules/mod-progression/src/patch_21-3_3_5/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-progression/src/patch_21-3_3_5/sql/*.sql; do
                        FILENAME=$(basename $f)
                        HASH=($(sha1sum $f))

                        if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                            printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                            continue;
                        fi

                        printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                        mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi

                        mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                        if [[ $? -ne 0 ]]; then
                            notify_telegram "An error occurred while trying to import the database files of mod-progression"
                            rm -rf "$mysql_cnf"
                            exit $?
                        fi
                    done
                fi
            fi
        fi

        if [[ "$module_recruitafriend" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-recruitafriend/sql/auth" ]]; then
                printf "${color_red}The recruit-a-friend module is enabled but the files aren't where they should be${color_end}\n"
                printf "${color_red}Please make sure to install the server first${color_end}\n"
                notify_telegram "An error occurred while trying to import the database files of mod-recruitafriend"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            if [[ `ls -1 $source/modules/mod-recruitafriend/sql/auth/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $source/modules/mod-recruitafriend/sql/auth/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_auth -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                        continue;
                    fi

                    printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                    mysql --defaults-extra-file=$mysql_cnf $database_auth < $f
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-recruitafriend"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi

                    mysql --defaults-extra-file=$mysql_cnf $database_auth -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-recruitafriend"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi
                done
            fi
        fi

        if [[ "$module_skip_dk_starting_area" == "true" ]]; then
            if [[ ! -d "$source/modules/mod-skip-dk-starting-area/data/sql/db-world" ]]; then
                printf "${color_red}The skip dk starting area module is enabled but the files aren't where they should be${color_end}\n"
                printf "${color_red}Please make sure to install the server first${color_end}\n"
                notify_telegram "An error occurred while trying to import the database files of mod-skip-dk-starting-area"
                rm -rf "$mysql_cnf"
                exit $?
            fi

            if [[ `ls -1 $source/modules/mod-skip-dk-starting-area/data/sql/db-world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                for f in $source/modules/mod-skip-dk-starting-area/data/sql/db-world/*.sql; do
                    FILENAME=$(basename $f)
                    HASH=($(sha1sum $f))

                    if [[ ! -z `mysql --defaults-extra-file=$mysql_cnf --skip-column-names $database_world -e "SELECT * FROM updates WHERE name='$FILENAME' AND hash='${HASH^^}'"` ]]; then
                        printf "${color_orange}Skipping "$(basename $f)"${color_end}\n"
                        continue;
                    fi

                    printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                    mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-skip-dk-starting-area"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi

                    mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name='$(basename $f)';INSERT INTO updates (name, hash, state) VALUES ('$FILENAME', '${HASH^^}', 'CUSTOM')"
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-skip-dk-starting-area"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi
                done
            fi
        fi

        if [[ `ls -1 $root/sql/characters/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $root/sql/characters/*.sql; do
                printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                mysql --defaults-extra-file=$mysql_cnf $database_characters < $f
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi
            done
        fi

        if [[ `ls -1 $root/sql/world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
            for f in $root/sql/world/*.sql; do
                printf "${color_orange}Importing "$(basename $f)"${color_end}\n"
                mysql --defaults-extra-file=$mysql_cnf $database_world < $f
                if [[ $? -ne 0 ]]; then
                    notify_telegram "An error occurred while trying to import the database files"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi
            done
        fi

        printf "${color_orange}Adding to the realmlist (id: $id, name: $world_name, address $world_address, port $world_port)${color_end}\n"
        mysql --defaults-extra-file=$mysql_cnf $database_auth -e "DELETE FROM realmlist WHERE id='$id';INSERT INTO realmlist (id, name, address, localAddress, localSubnetMask, port) VALUES ('$id', '$world_name', '$world_address', '$world_address', '255.255.255.0', '$world_port')"
        if [[ $? -ne 0 ]]; then
            notify_telegram "An error occurred while trying to update the realm list"
            rm -rf "$mysql_cnf"
            exit $?
        fi

        printf "${color_orange}Updating message of the day${color_end}\n"
        mysql --defaults-extra-file=$mysql_cnf $database_auth -e "DELETE FROM motd WHERE realmid='$id';INSERT INTO motd (realmid, text) VALUES ('$id', 'Welcome to $world_name.')"
        if [[ $? -ne 0 ]]; then
            notify_telegram "An error occurred while trying to update message of the day"
            rm -rf "$mysql_cnf"
            exit $?
        fi
    fi

    rm -rf "$mysql_cnf"

    printf "${color_orange}Finished after %02dh:%02dm:%02ds${color_end}\n" $(($SECONDS / 3600)) $((($SECONDS / 60) % 60)) $(($SECONDS % 60))

    printf "${color_green}Finished importing the database files..${color_end}\n"
}

function set_config
{
    printf "${color_green}Updating the config files...${color_end}\n"

    if [[ "$build_auth" == "true" ]]; then
        if [[ ! -f "$source/etc/authserver.conf.dist" ]]; then
            printf "${color_red}The config file authserver.conf.dist is missing.${color_end}\n"
            printf "${color_red}Please make sure to install the server first.${color_end}\n"
            notify_telegram "An error occurred while trying to update the config files"
            exit $?
        fi

        printf "${color_orange}Updating authserver.conf${color_end}\n"

        cp "$source/etc/authserver.conf.dist" "$source/etc/authserver.conf"

        sed -i 's/LoginDatabaseInfo =.*/LoginDatabaseInfo = "'$mysql_hostname';'$mysql_port';'$mysql_username';'$mysql_password';'$database_auth'"/g' "$source/etc/authserver.conf"
        sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 0/g' "$source/etc/authserver.conf"
    fi

    if [[ "$build_world" == "true" ]]; then
        if [[ ! -f "$source/etc/worldserver.conf.dist" ]]; then
            printf "${color_red}The config file worldserver.conf.dist is missing.${color_end}\n"
            printf "${color_red}Please make sure to install the server first.${color_end}\n"
            notify_telegram "An error occurred while trying to update the config files"
            exit $?
        fi

        printf "${color_orange}Updating worldserver.conf${color_end}\n"

        cp "$source/etc/worldserver.conf.dist" "$source/etc/worldserver.conf"

        [ "$world_warden" == "true" ] && world_warden0="1" || world_warden0="0"
        [ "$world_preload_grids" == "true" ] && world_preload_grids0="1" || world_preload_grids0="0"
        [ "$world_set_creatures_active" == "true" ] && world_set_creatures_active0="1" || world_set_creatures_active0="0"

        sed -i 's/LoginDatabaseInfo     =.*/LoginDatabaseInfo     = "'$mysql_hostname';'$mysql_port';'$mysql_username';'$mysql_password';'$database_auth'"/g' "$source/etc/worldserver.conf"
        sed -i 's/WorldDatabaseInfo     =.*/WorldDatabaseInfo     = "'$mysql_hostname';'$mysql_port';'$mysql_username';'$mysql_password';'$database_world'"/g' "$source/etc/worldserver.conf"
        sed -i 's/CharacterDatabaseInfo =.*/CharacterDatabaseInfo = "'$mysql_hostname';'$mysql_port';'$mysql_username';'$mysql_password';'$database_characters'"/g' "$source/etc/worldserver.conf"
        sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/RealmID =.*/RealmID = '$id'/g' "$source/etc/worldserver.conf"
        sed -i 's/WorldServerPort =.*/WorldServerPort = '$world_port'/g' "$source/etc/worldserver.conf"
        sed -i 's/GameType =.*/GameType = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/RealmZone =.*/RealmZone = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/Expansion =.*/Expansion = 2/g' "$source/etc/worldserver.conf"
        sed -i 's/PlayerLimit =.*/PlayerLimit = 1000/g' "$source/etc/worldserver.conf"
        sed -i 's/StrictPlayerNames =.*/StrictPlayerNames = 3/g' "$source/etc/worldserver.conf"
        sed -i 's/StrictCharterNames =.*/StrictCharterNames = 3/g' "$source/etc/worldserver.conf"
        sed -i 's/StrictPetNames =.*/StrictPetNames = 3/g' "$source/etc/worldserver.conf"
        sed -i 's/AllowPlayerCommands =.*/AllowPlayerCommands = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/Quests.IgnoreRaid =.*/Quests.IgnoreRaid = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/Warden.Enabled =.*/Warden.Enabled = '$world_warden0'/g' "$source/etc/worldserver.conf"
        sed -i 's/PreloadAllNonInstancedMapGrids =.*/PreloadAllNonInstancedMapGrids = '$world_preload_grids0'/g' "$source/etc/worldserver.conf"
        sed -i 's/SetAllCreaturesWithWaypointMovementActive =.*/SetAllCreaturesWithWaypointMovementActive = '$world_set_creatures_active0'/g' "$source/etc/worldserver.conf"
        sed -i 's/Minigob.Manabonk.Enable =.*/Minigob.Manabonk.Enable = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.XP.Kill      =.*/Rate.XP.Kill      = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.XP.Quest     =.*/Rate.XP.Quest     = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.XP.Quest.DF  =.*/Rate.XP.Quest.DF  = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.XP.Explore   =.*/Rate.XP.Explore   = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.XP.Pet       =.*/Rate.XP.Pet       = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.Drop.Money                 =.*/Rate.Drop.Money                 = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.Reputation.Gain =.*/Rate.Reputation.Gain = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/GM.LoginState =.*/GM.LoginState = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/GM.Visible =.*/GM.Visible = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/GM.Chat =.*/GM.Chat = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/GM.WhisperingTo =.*/GM.WhisperingTo = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/GM.InGMList.Level =.*/GM.InGMList.Level = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/GM.InWhoList.Level =.*/GM.InWhoList.Level = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/GM.StartLevel = .*/GM.StartLevel = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/GM.AllowInvite =.*/GM.AllowInvite = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/GM.AllowFriend =.*/GM.AllowFriend = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/GM.LowerSecurity =.*/GM.LowerSecurity = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/LeaveGroupOnLogout.Enabled =.*/LeaveGroupOnLogout.Enabled = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/Group.Raid.LevelRestriction =.*/Group.Raid.LevelRestriction = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/DBC.EnforceItemAttributes =.*/DBC.EnforceItemAttributes = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/MapUpdate.Threads =.*/MapUpdate.Threads = '$(($(nproc)*2))'/g' "$source/etc/worldserver.conf"
        sed -i 's/MinWorldUpdateTime =.*/MinWorldUpdateTime = 10/g' "$source/etc/worldserver.conf"
        sed -i 's/MapUpdateInterval =.*/MapUpdateInterval = 100/g' "$source/etc/worldserver.conf"
        data_directory=$(echo "$world_data_directory" | sed 's#/#\\/#g')
        sed -i 's/DataDir =.*/DataDir = "'"$data_directory"'"/g' "$source/etc/worldserver.conf"
        sed -i 's/CharacterCreating.MinLevelForHeroicCharacter =.*/CharacterCreating.MinLevelForHeroicCharacter = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/RecruitAFriend.MaxLevel =.*/RecruitAFriend.MaxLevel = 79/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.Rest.InGame                 =.*/Rate.Rest.InGame                 = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.Rest.Offline.InTavernOrCity =.*/Rate.Rest.Offline.InTavernOrCity = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.Rest.Offline.InWilderness   =.*/Rate.Rest.Offline.InWilderness   = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/Daze.Enabled =.*/Daze.Enabled = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/DungeonFinder.CastDeserter =.*/DungeonFinder.CastDeserter = 0/g' "$source/etc/worldserver.conf"

        sed -i 's/Arena.MaxRatingDifference =.*/Arena.MaxRatingDifference = 1000/g' "$source/etc/worldserver.conf"
        #sed -i 's/Arena.AutoDistributePoints =.*/Arena.AutoDistributePoints = 1/g' "$source/etc/worldserver.conf"
        #sed -i 's/Arena.AutoDistributeInterval =.*/Arena.AutoDistributeInterval = 1/g' "$source/etc/worldserver.conf"
        sed -i 's/Arena.ArenaWinRatingModifier1 =.*/Arena.ArenaWinRatingModifier1 = 75/g' "$source/etc/worldserver.conf"
        sed -i 's/Arena.ArenaWinRatingModifier2 =.*/Arena.ArenaWinRatingModifier2 = 50/g' "$source/etc/worldserver.conf"
        sed -i 's/Arena.ArenaLoseRatingModifier =.*/Arena.ArenaLoseRatingModifier = 25/g' "$source/etc/worldserver.conf"
        sed -i 's/Arena.ArenaMatchmakerRatingModifier =.*/Arena.ArenaMatchmakerRatingModifier = 50/g' "$source/etc/worldserver.conf"
        #sed -i 's/Battleground.QueueAnnouncer.Enable =.*/Battleground.QueueAnnouncer.Enable = 1/g' "$source/etc/worldserver.conf"
        #sed -i 's/Arena.QueueAnnouncer.Enable =.*/Arena.QueueAnnouncer.Enable = 1/g' "$source/etc/worldserver.conf"

        if [[ "$module_ah_bot" == "true" ]]; then
            if [[ ! -f "$source/etc/modules/mod_ahbot.conf.dist" ]]; then
                printf "${color_red}The config file mod_ahbot.conf.dist is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files of mod-ah-bot"
                exit $?
            fi

            printf "${color_orange}Updating mod_ahbot.conf${color_end}\n"

            cp "$source/etc/modules/mod_ahbot.conf.dist" "$source/etc/modules/mod_ahbot.conf"

            sed -i 's/AuctionHouseBot.EnableSeller =.*/AuctionHouseBot.EnableSeller = 1/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.EnableBuyer =.*/AuctionHouseBot.EnableBuyer = 1/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.UseBuyPriceForSeller =.*/AuctionHouseBot.UseBuyPriceForSeller = 0/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.UseBuyPriceForBuyer =.*/AuctionHouseBot.UseBuyPriceForBuyer = 0/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.Account =.*/AuctionHouseBot.Account = 1/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.GUID =.*/AuctionHouseBot.GUID = 1/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.ItemsPerCycle =.*/AuctionHouseBot.ItemsPerCycle = 200/g' "$source/etc/modules/mod_ahbot.conf"

            if [[ $module_progression_patch -lt 6 ]]; then # T1
                sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = 66/g' "$source/etc/modules/mod_ahbot.conf"
            elif [[ $module_progression_patch -lt 7 ]]; then # T2
                sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = 76/g' "$source/etc/modules/mod_ahbot.conf"
            elif [[ $module_progression_patch -lt 12 ]]; then # T3
                sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = 92/g' "$source/etc/modules/mod_ahbot.conf"
            elif [[ $module_progression_patch -lt 13 ]]; then # T4
                sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = 120/g' "$source/etc/modules/mod_ahbot.conf"
            elif [[ $module_progression_patch -lt 14 ]]; then # T5
                sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = 133/g' "$source/etc/modules/mod_ahbot.conf"
            elif [[ $module_progression_patch -lt 17 ]]; then # T6
                sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = 154/g' "$source/etc/modules/mod_ahbot.conf"
            elif [[ $module_progression_patch  -lt 18 ]]; then # T7
                sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = 213/g' "$source/etc/modules/mod_ahbot.conf"
            elif [[ $module_progression_patch  -lt 19 ]]; then # T8
                sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = 226/g' "$source/etc/modules/mod_ahbot.conf"
            elif [[ $module_progression_patch  -lt 20 ]]; then # T9
                sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = 245/g' "$source/etc/modules/mod_ahbot.conf"
            else
                sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = 0/g' "$source/etc/modules/mod_ahbot.conf"
            fi
        fi

        if [[ "$module_appreciation" == "true" ]]; then
            if [[ ! -f "$source/etc/modules/mod_appreciation.conf.dist" ]]; then
                printf "${color_red}The config file mod_appreciation.conf.dist is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files of mod-appreciation"
                exit $?
            fi

            printf "${color_orange}Updating mod_appreciation.conf${color_end}\n"

            cp "$source/etc/modules/mod_appreciation.conf.dist" "$source/etc/modules/mod_appreciation.conf"

            sed -i 's/Appreciation.RequireCertificate.Enabled =.*/Appreciation.RequireCertificate.Enabled = 1/g' "$source/etc/modules/mod_appreciation.conf"
            sed -i 's/Appreciation.LevelBoost.Enabled =.*/Appreciation.LevelBoost.Enabled = 1/g' "$source/etc/modules/mod_appreciation.conf"
            sed -i 's/Appreciation.LevelBoost.TargetLevel =.*/Appreciation.LevelBoost.TargetLevel = '$module_appreciation_level_boost_level'/g' "$source/etc/modules/mod_appreciation.conf"

            if [[ "$module_appreciation_level_boost_level" == "60" ]]; then
                sed -i 's/Appreciation.LevelBoost.IncludedCopper =.*/Appreciation.LevelBoost.IncludedCopper = 2500000/g' "$source/etc/modules/mod_appreciation.conf"
            elif [[ "$module_appreciation_level_boost_level" == "70" ]]; then
                sed -i 's/Appreciation.LevelBoost.IncludedCopper =.*/Appreciation.LevelBoost.IncludedCopper = 5000000/g' "$source/etc/modules/mod_appreciation.conf"
            elif [[ "$module_appreciation_level_boost_level" == "80" ]]; then
                sed -i 's/Appreciation.LevelBoost.IncludedCopper =.*/Appreciation.LevelBoost.IncludedCopper = 10000000/g' "$source/etc/modules/mod_appreciation.conf"
            fi

            sed -i 's/Appreciation.UnlockContinents.Enabled =.*/Appreciation.UnlockContinents.Enabled = 1/g' "$source/etc/modules/mod_appreciation.conf"
            sed -i 's/Appreciation.RewardAtMaxLevel.Enabled =.*/Appreciation.RewardAtMaxLevel.Enabled = 1/g' "$source/etc/modules/mod_appreciation.conf"
        fi

        if [[ "$module_assistant" == "true" ]]; then
            if [[ ! -f "$source/etc/modules/mod_assistant.conf.dist" ]]; then
                printf "${color_red}The config file mod_assistant.conf.dist is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files of mod-assistant"
                exit $?
            fi

            printf "${color_orange}Updating mod_assistant.conf${color_end}\n"

            cp "$source/etc/modules/mod_assistant.conf.dist" "$source/etc/modules/mod_assistant.conf"

            if [[ $module_progression_patch -lt 17 ]]; then
                sed -i 's/Assistant.Heirlooms.Enabled  =.*/Assistant.Heirlooms.Enabled  = 0/g' "$source/etc/modules/mod_assistant.conf"
                sed -i 's/Assistant.Glyphs.Enabled     =.*/Assistant.Glyphs.Enabled     = 0/g' "$source/etc/modules/mod_assistant.conf"
                sed -i 's/Assistant.Gems.Enabled       =.*/Assistant.Gems.Enabled       = 0/g' "$source/etc/modules/mod_assistant.conf"
            else
                sed -i 's/Assistant.Heirlooms.Enabled  =.*/Assistant.Heirlooms.Enabled  = 1/g' "$source/etc/modules/mod_assistant.conf"
                sed -i 's/Assistant.Glyphs.Enabled     =.*/Assistant.Glyphs.Enabled     = 1/g' "$source/etc/modules/mod_assistant.conf"
                sed -i 's/Assistant.Gems.Enabled       =.*/Assistant.Gems.Enabled       = 1/g' "$source/etc/modules/mod_assistant.conf"
            fi

            sed -i 's/Assistant.Containers.Enabled =.*/Assistant.Containers.Enabled = 1/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Utilities.Enabled            =.*/Assistant.Utilities.Enabled            = 1/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.Vanilla.Enabled                  =.*/Assistant.FlightPaths.Vanilla.Enabled                  = 1/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.Vanilla.RequiredLevel            =.*/Assistant.FlightPaths.Vanilla.RequiredLevel            = 60/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.Vanilla.Cost                     =.*/Assistant.FlightPaths.Vanilla.Cost                     = 250000/g' "$source/etc/modules/mod_assistant.conf"

            if [[ $module_progression_patch -lt 12 ]]; then
                sed -i 's/Assistant.FlightPaths.BurningCrusade.Enabled           =.*/Assistant.FlightPaths.BurningCrusade.Enabled           = 0/g' "$source/etc/modules/mod_assistant.conf"
            else
                sed -i 's/Assistant.FlightPaths.BurningCrusade.Enabled           =.*/Assistant.FlightPaths.BurningCrusade.Enabled           = 1/g' "$source/etc/modules/mod_assistant.conf"
            fi

            sed -i 's/Assistant.FlightPaths.BurningCrusade.RequiredLevel     =.*/Assistant.FlightPaths.BurningCrusade.RequiredLevel     = 70/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.BurningCrusade.Cost              =.*/Assistant.FlightPaths.BurningCrusade.Cost              = 1000000/g' "$source/etc/modules/mod_assistant.conf"

            if [[ $module_progression_patch -lt 17 ]]; then
                sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       =.*/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       = 0/g' "$source/etc/modules/mod_assistant.conf"
            else
                sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       =.*/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       = 1/g' "$source/etc/modules/mod_assistant.conf"
            fi

            sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.RequiredLevel =.*/Assistant.FlightPaths.WrathOfTheLichKing.RequiredLevel = 80/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.Cost          =.*/Assistant.FlightPaths.WrathOfTheLichKing.Cost          = 2500000/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Apprentice.Enabled  =.*/Assistant.Professions.Apprentice.Enabled  = 1/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Apprentice.Cost     =.*/Assistant.Professions.Apprentice.Cost     = 1000000/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Journeyman.Enabled  =.*/Assistant.Professions.Journeyman.Enabled  = 1/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Journeyman.Cost     =.*/Assistant.Professions.Journeyman.Cost     = 2500000/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Expert.Enabled      =.*/Assistant.Professions.Expert.Enabled      = 1/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Expert.Cost         =.*/Assistant.Professions.Expert.Cost         = 5000000/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Artisan.Enabled     =.*/Assistant.Professions.Artisan.Enabled     = 1/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Artisan.Cost        =.*/Assistant.Professions.Artisan.Cost        = 7500000/g' "$source/etc/modules/mod_assistant.conf"

            if [[ $module_progression_patch -lt 12 ]]; then
                sed -i 's/Assistant.Professions.Master.Enabled      =.*/Assistant.Professions.Master.Enabled      = 0/g' "$source/etc/modules/mod_assistant.conf"
            else
                sed -i 's/Assistant.Professions.Master.Enabled      =.*/Assistant.Professions.Master.Enabled      = 1/g' "$source/etc/modules/mod_assistant.conf"
            fi

            sed -i 's/Assistant.Professions.Master.Cost         =.*/Assistant.Professions.Master.Cost         = 12500000/g' "$source/etc/modules/mod_assistant.conf"

            if [[ $module_progression_patch -lt 12 ]]; then
                sed -i 's/Assistant.Professions.GrandMaster.Enabled =.*/Assistant.Professions.GrandMaster.Enabled = 0/g' "$source/etc/modules/mod_assistant.conf"
            else
                sed -i 's/Assistant.Professions.GrandMaster.Enabled =.*/Assistant.Professions.GrandMaster.Enabled = 1/g' "$source/etc/modules/mod_assistant.conf"
            fi

            sed -i 's/Assistant.Professions.GrandMaster.Cost    =.*/Assistant.Professions.GrandMaster.Cost    = 25000000/g' "$source/etc/modules/mod_assistant.conf"
        fi

        if [[ "$module_learnspells" == "true" ]]; then
            if [[ ! -f "$source/etc/modules/mod_learnspells.conf.dist" ]]; then
                printf "${color_red}The config file mod_learnspells.conf.dist is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files of mod-learnspells"
                exit $?
            fi

            printf "${color_orange}Updating mod_learnspells.conf${color_end}\n"

            cp "$source/etc/modules/mod_learnspells.conf.dist" "$source/etc/modules/mod_learnspells.conf"

            sed -i 's/LearnSpells.ClassSpells =.*/LearnSpells.ClassSpells = 1/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.TalentRanks =.*/LearnSpells.TalentRanks = 1/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.Proficiencies =.*/LearnSpells.Proficiencies = 1/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.SpellsFromQuests =.*/LearnSpells.SpellsFromQuests = 1/g' "$source/etc/modules/mod_learnspells.conf"

            if [[ $module_progression_patch -lt 12 ]]; then
                sed -i 's/LearnSpells.Riding.Apprentice =.*/LearnSpells.Riding.Apprentice = 0/g' "$source/etc/modules/mod_learnspells.conf"
                sed -i 's/LearnSpells.Riding.Journeyman =.*/LearnSpells.Riding.Journeyman = 0/g' "$source/etc/modules/mod_learnspells.conf"
            else
                sed -i 's/LearnSpells.Riding.Apprentice =.*/LearnSpells.Riding.Apprentice = 1/g' "$source/etc/modules/mod_learnspells.conf"
                sed -i 's/LearnSpells.Riding.Journeyman =.*/LearnSpells.Riding.Journeyman = 1/g' "$source/etc/modules/mod_learnspells.conf"
            fi

            if [[ $module_progression_patch -lt 17 ]]; then
                sed -i 's/LearnSpells.Riding.Expert =.*/LearnSpells.Riding.Expert = 0/g' "$source/etc/modules/mod_learnspells.conf"
            else
                sed -i 's/LearnSpells.Riding.Expert =.*/LearnSpells.Riding.Expert = 1/g' "$source/etc/modules/mod_learnspells.conf"
            fi

            sed -i 's/LearnSpells.Riding.Artisan =.*/LearnSpells.Riding.Artisan = 0/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.Riding.ColdWeatherFlying =.*/LearnSpells.Riding.ColdWeatherFlying = 0/g' "$source/etc/modules/mod_learnspells.conf"
        fi

        if [[ "$module_playerbots" == "true" ]]; then
            if [[ ! -f "$source/etc/modules/playerbots.conf.dist" ]]; then
                printf "${color_red}The config file playerbots.conf.dist is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files of mod-playerbots"
                exit $?
            fi

            printf "${color_orange}Updating playerbots.conf${color_end}\n"

            cp "$source/etc/modules/playerbots.conf.dist" "$source/etc/modules/playerbots.conf"

            if [[ $module_playerbots_bots -gt 0 ]]; then
                module_playerbots_accounts=$(($module_playerbots_bots/9+1))
            else
                module_playerbots_accounts=0
            fi

            sed -i 's/AiPlayerbot.MinRandomBots =.*/AiPlayerbot.MinRandomBots = '$(($module_playerbots_bots/2))'/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.MaxRandomBots =.*/AiPlayerbot.MaxRandomBots = '$module_playerbots_bots'/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandomBotAccountCount =.*/AiPlayerbot.RandomBotAccountCount = '$module_playerbots_accounts'/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.AllowPlayerBots =.*/AiPlayerbot.AllowPlayerBots = 1/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.DisableRandomLevels =.*/AiPlayerbot.DisableRandomLevels = 1/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandombotStartingLevel =.*/AiPlayerbot.RandombotStartingLevel = 1/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.AutoTeleportForLevel =.*/AiPlayerbot.AutoTeleportForLevel = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.KillXPRate =.*/AiPlayerbot.KillXPRate = 1/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.EquipmentPersistence =.*/AiPlayerbot.EquipmentPersistence = 1/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.AllowSummonInCombat =.*/AiPlayerbot.AllowSummonInCombat = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.AllowSummonWhenMasterIsDead =.*/AiPlayerbot.AllowSummonWhenMasterIsDead = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.AllowSummonWhenBotIsDead =.*/AiPlayerbot.AllowSummonWhenBotIsDead = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.ReviveBotWhenSummoned =.*/AiPlayerbot.ReviveBotWhenSummoned = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.SayWhenCollectingItems =.*/AiPlayerbot.SayWhenCollectingItems = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.LimitEnchantExpansion =.*/AiPlayerbot.LimitEnchantExpansion = 1/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.LimitGearExpansion =.*/AiPlayerbot.LimitGearExpansion = 1/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandomBotUpdateInterval =.*/AiPlayerbot.RandomBotUpdateInterval = 5/g' "$source/etc/modules/playerbots.conf"

            if [[ $module_progression_patch -lt 12 ]]; then
                sed -i 's/AiPlayerbot.RandomBotMaxLevel =.*/AiPlayerbot.RandomBotMaxLevel = 60/g' "$source/etc/modules/playerbots.conf"
                sed -i 's/AiPlayerbot.RandomBotMaps =.*/AiPlayerbot.RandomBotMaps = 0,1/g' "$source/etc/modules/playerbots.conf"
                sed -i 's/AiPlayerbot.EquipmentPersistenceLevel =.*/AiPlayerbot.EquipmentPersistenceLevel = 60/g' "$source/etc/modules/playerbots.conf"
            elif [[ $module_progression_patch -lt 17 ]]; then
                sed -i 's/AiPlayerbot.RandomBotMaxLevel =.*/AiPlayerbot.RandomBotMaxLevel = 70/g' "$source/etc/modules/playerbots.conf"
                sed -i 's/AiPlayerbot.RandomBotMaps =.*/AiPlayerbot.RandomBotMaps = 0,1,530/g' "$source/etc/modules/playerbots.conf"
                sed -i 's/AiPlayerbot.EquipmentPersistenceLevel =.*/AiPlayerbot.EquipmentPersistenceLevel = 70/g' "$source/etc/modules/playerbots.conf"
            fi

            sed -i 's/AiPlayerbot.AutoPickReward =.*/AiPlayerbot.AutoPickReward = yes/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.AutoAvoidAoe =.*/AiPlayerbot.AutoAvoidAoe = 1/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.TellWhenAvoidAoe =.*/AiPlayerbot.TellWhenAvoidAoe = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandomBotGroupNearby =.*/AiPlayerbot.RandomBotGroupNearby = 1/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandomBotTalk =.*/AiPlayerbot.RandomBotTalk = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandomBotGuildTalk =.*/AiPlayerbot.RandomBotGuildTalk = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandomBotNonCombatStrategies =.*/AiPlayerbot.RandomBotNonCombatStrategies ="+quest,+travel"/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.KillXPRate =.*/AiPlayerbot.KillXPRate = 10000/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.SelfBotLevel =.*/AiPlayerbot.SelfBotLevel = 2/g' "$source/etc/modules/playerbots.conf"

            sed -i 's/AiPlayerbot.RandomBotArenaTeam2v2Count =.*/AiPlayerbot.RandomBotArenaTeam2v2Count = 10/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandomBotArenaTeam3v3Count =.*/AiPlayerbot.RandomBotArenaTeam3v3Count = 10/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandomBotArenaTeam5v5Count =.*/AiPlayerbot.RandomBotArenaTeam5v5Count = 35/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandomBotAutoJoinBG =.*/AiPlayerbot.RandomBotAutoJoinBG = 1/g' "$source/etc/modules/playerbots.conf"

            sed -i 's/AiPlayerbot.AutoGearQualityLimit =.*/AiPlayerbot.AutoGearQualityLimit = 3/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.AutoGearScoreLimit =.*/AiPlayerbot.AutoGearScoreLimit = 187/g' "$source/etc/modules/playerbots.conf"

            if [[ $module_progression_patch -lt 6 ]]; then
                sed -i 's/AiPlayerbot.RandomGearScoreLimit =.*/AiPlayerbot.RandomGearScoreLimit = 63/g' "$source/etc/modules/playerbots.conf"
            elif [[ $module_progression_patch -lt 7 ]]; then
                sed -i 's/AiPlayerbot.RandomGearScoreLimit =.*/AiPlayerbot.RandomGearScoreLimit = 66/g' "$source/etc/modules/playerbots.conf"
            elif [[ $module_progression_patch -lt 12 ]]; then
                sed -i 's/AiPlayerbot.RandomGearScoreLimit =.*/AiPlayerbot.RandomGearScoreLimit = 76/g' "$source/etc/modules/playerbots.conf"
            elif [[ $module_progression_patch -lt 13 ]]; then
                sed -i 's/AiPlayerbot.RandomGearScoreLimit =.*/AiPlayerbot.RandomGearScoreLimit = 110/g' "$source/etc/modules/playerbots.conf"
            elif [[ $module_progression_patch -lt 14 ]]; then
                sed -i 's/AiPlayerbot.RandomGearScoreLimit =.*/AiPlayerbot.RandomGearScoreLimit = 120/g' "$source/etc/modules/playerbots.conf"
            elif [[ $module_progression_patch -lt 17 ]]; then
                sed -i 's/AiPlayerbot.RandomGearScoreLimit =.*/AiPlayerbot.RandomGearScoreLimit = 133/g' "$source/etc/modules/playerbots.conf"
            elif [[ $module_progression_patch -lt 18 ]]; then
                sed -i 's/AiPlayerbot.RandomGearScoreLimit =.*/AiPlayerbot.RandomGearScoreLimit = 200/g' "$source/etc/modules/playerbots.conf"
            elif [[ $module_progression_patch -lt 19 ]]; then
                sed -i 's/AiPlayerbot.RandomGearScoreLimit =.*/AiPlayerbot.RandomGearScoreLimit = 213/g' "$source/etc/modules/playerbots.conf"
            elif [[ $module_progression_patch -lt 20 ]]; then
                sed -i 's/AiPlayerbot.RandomGearScoreLimit =.*/AiPlayerbot.RandomGearScoreLimit = 226/g' "$source/etc/modules/playerbots.conf"
            elif [[ $module_progression_patch -lt 21 ]]; then
                sed -i 's/AiPlayerbot.RandomGearScoreLimit =.*/AiPlayerbot.RandomGearScoreLimit = 245/g' "$source/etc/modules/playerbots.conf"
            fi

            if [[ $module_progression_patch -lt 19 ]]; then
                sed -i 's/AiPlayerbot.RandomGearQualityLimit =.*/AiPlayerbot.RandomGearQualityLimit = 3/g' "$source/etc/modules/playerbots.conf"
            else
                sed -i 's/AiPlayerbot.RandomGearQualityLimit =.*/AiPlayerbot.RandomGearQualityLimit = 4/g' "$source/etc/modules/playerbots.conf"
            fi

            sed -i 's/AiPlayerbot.CommandServerPort =.*/AiPlayerbot.CommandServerPort = 0/g' "$source/etc/modules/playerbots.conf"

            sed -i 's/AiPlayerbot.RandomBotSuggestDungeons =.*/AiPlayerbot.RandomBotSuggestDungeons = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.ToxicLinksRepliesChance =.*/AiPlayerbot.ToxicLinksRepliesChance = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.ThunderfuryRepliesChance =.*/AiPlayerbot.ThunderfuryRepliesChance = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.GuildRepliesRate =.*/AiPlayerbot.GuildRepliesRate = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AIPlayerbot.GuildFeedback =.*/AIPlayerbot.GuildFeedback = 0/g' "$source/etc/modules/playerbots.conf"

            sed -i 's/PlayerbotsDatabaseInfo =.*/PlayerbotsDatabaseInfo = "'$mysql_hostname';'$mysql_port';'$mysql_username';'$mysql_password';'$database_playerbots'"/g' "$source/etc/modules/playerbots.conf"
        fi

        if [[ "$module_progression" == "true" ]]; then
            if [[ ! -f "$source/etc/modules/mod_progression.conf.dist" ]]; then
                printf "${color_red}The config file mod_progression.conf.dist is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files of mod-progression"
                exit $?
            fi

            printf "${color_orange}Updating mod_progression.conf${color_end}\n"

            cp "$source/etc/modules/mod_progression.conf.dist" "$source/etc/modules/mod_progression.conf"

            sed -i 's/Progression.Patch =.*/Progression.Patch = '$module_progression_patch'/g' "$source/etc/modules/mod_progression.conf"
            sed -i 's/Progression.IcecrownCitadel.Aura =.*/Progression.IcecrownCitadel.Aura = '$module_progression_aura'/g' "$source/etc/modules/mod_progression.conf"
            sed -i 's/Progression.QuestInfo.Enforced =.*/Progression.QuestInfo.Enforced = 1/g' "$source/etc/modules/mod_progression.conf"
            sed -i 's/Progression.DungeonFinder.Enforced =.*/Progression.DungeonFinder.Enforced = 1/g' "$source/etc/modules/mod_progression.conf"
            sed -i 's/Progression.DualTalent.Enforced =.*/Progression.DualTalent.Enforced = 1/g' "$source/etc/modules/mod_progression.conf"
            sed -i 's/Progression.Reset =.*/Progression.Reset = 1/g' "$source/etc/modules/mod_progression.conf"
            sed -i 's/Progression.Multiplier.Damage =.*/Progression.Multiplier.Damage = 0.8/g' "$source/etc/modules/mod_progression.conf"
            sed -i 's/Progression.Multiplier.Healing =.*/Progression.Multiplier.Healing = 0.75/g' "$source/etc/modules/mod_progression.conf"
        fi

        if [[ "$module_recruitafriend" == "true" ]]; then
            if [[ ! -f "$source/etc/modules/mod_recruitafriend.conf.dist" ]]; then
                printf "${color_red}The config file mod_recruitafriend.conf.dist is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files of mod-recruitafriend"
                exit $?
            fi

            printf "${color_orange}Updating mod_recruitafriend.conf${color_end}\n"

            cp "$source/etc/modules/mod_recruitafriend.conf.dist" "$source/etc/modules/mod_recruitafriend.conf"

            sed -i 's/RecruitAFriend.Duration =.*/RecruitAFriend.Duration = 0/g' "$source/etc/modules/mod_recruitafriend.conf"
            sed -i 's/RecruitAFriend.MaxAccountAge =.*/RecruitAFriend.MaxAccountAge = 0/g' "$source/etc/modules/mod_recruitafriend.conf"
            sed -i 's/RecruitAFriend.Rewards.Days =.*/RecruitAFriend.Rewards.Days = 30/g' "$source/etc/modules/mod_recruitafriend.conf"
            sed -i 's/RecruitAFriend.Rewards.SwiftZhevra =.*/RecruitAFriend.Rewards.SwiftZhevra = 1/g' "$source/etc/modules/mod_recruitafriend.conf"
            sed -i 's/RecruitAFriend.Rewards.TouringRocket =.*/RecruitAFriend.Rewards.TouringRocket = 1/g' "$source/etc/modules/mod_recruitafriend.conf"
            sed -i 's/RecruitAFriend.Rewards.CelestialSteed =.*/RecruitAFriend.Rewards.CelestialSteed = 1/g' "$source/etc/modules/mod_recruitafriend.conf"
        fi

        if [[ "$module_skip_dk_starting_area" == "true" ]]; then
            if [[ ! -f "$source/etc/modules/skip_dk_module.conf.dist" ]]; then
                printf "${color_red}The config file skip_dk_module.conf.dist is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files of mod-skip-dk-starting-area"
                exit $?
            fi

            printf "${color_orange}Updating skip_dk_module.conf${color_end}\n"

            cp "$source/etc/modules/skip_dk_module.conf.dist" "$source/etc/modules/skip_dk_module.conf"

            sed -i 's/Skip.Deathknight.Starter.Announce.enable =.*/Skip.Deathknight.Starter.Announce.enable = 0/g' "$source/etc/modules/skip_dk_module.conf"
            sed -i 's/Skip.Deathknight.Starter.Enable =.*/Skip.Deathknight.Starter.Enable = 0/g' "$source/etc/modules/skip_dk_module.conf"
            sed -i 's/Skip.Deathknight.Optional.Enable =.*/Skip.Deathknight.Optional.Enable = 1/g' "$source/etc/modules/skip_dk_module.conf"
        fi

        if [[ "$module_weekendbonus" == "true" ]]; then
            if [[ ! -f "$source/etc/modules/mod_weekendbonus.conf.dist" ]]; then
                printf "${color_red}The config file mod_weekendbonus.conf.dist is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files of mod-weekendbonus"
                exit $?
            fi

            printf "${color_orange}Updating mod_weekendbonus.conf${color_end}\n"

            cp "$source/etc/modules/mod_weekendbonus.conf.dist" "$source/etc/modules/mod_weekendbonus.conf"

            sed -i 's/WeekendBonus.Multiplier.Experience =.*/WeekendBonus.Multiplier.Experience = 2/g' "$source/etc/modules/mod_weekendbonus.conf"
            sed -i 's/WeekendBonus.Multiplier.Money =.*/WeekendBonus.Multiplier.Money = 2/g' "$source/etc/modules/mod_weekendbonus.conf"
            sed -i 's/WeekendBonus.Multiplier.Professions =.*/WeekendBonus.Multiplier.Professions = 2/g' "$source/etc/modules/mod_weekendbonus.conf"
            sed -i 's/WeekendBonus.Multiplier.Reputation =.*/WeekendBonus.Multiplier.Reputation = 2/g' "$source/etc/modules/mod_weekendbonus.conf"
            sed -i 's/WeekendBonus.Multiplier.Proficiencies =.*/WeekendBonus.Multiplier.Proficiencies = 2/g' "$source/etc/modules/mod_weekendbonus.conf"
        fi
    fi

    printf "${color_green}Finished updating the config files...${color_end}\n"
}

function start_server
{
    printf "${color_green}Starting the server...${color_end}\n"

    if [[ ! -f "$source/bin/start.sh" ]] || [[ ! -f "$source/bin/stop.sh" ]]; then
        printf "${color_red}The required binaries are missing${color_end}\n"
        printf "${color_red}Please make sure to install the server first${color_end}\n"
    else
        if [[ ! -z `screen -list | grep -E "auth"` && -f "$source/bin/auth.sh" ]] || [[ ! -z `screen -list | grep -E "world-$id"` && -f "$source/bin/world.sh" ]]; then
            printf "${color_red}The server is already running${color_end}\n"
        else
            cd "$source/bin" && ./start.sh

            if [[ ! -z `screen -list | grep -E "auth"` && -f "$source/bin/auth.sh" ]]; then
                printf "${color_orange}To access the screen of the authserver, use the command ${color_blue}screen -r auth${color_orange}${color_end}\n"
            fi

            if [[ ! -z `screen -list | grep -E "world-$id"` && -f "$source/bin/world.sh" ]]; then
                printf "${color_orange}To access the screen of the worldserver, use the command ${color_blue}screen -r world-$id${color_orange}${color_end}\n"
            fi
        fi
    fi

    printf "${color_green}Finished starting the server...${color_end}\n"
}

function stop_server
{
    printf "${color_green}Stopping the server...${color_end}\n"

    if [[ -z `screen -list | grep -E "auth"` || ! -f "$source/bin/auth.sh" ]] && [[ -z `screen -list | grep -E "world-$id"` || ! -f "$source/bin/world.sh" ]]; then
        printf "${color_red}The server is not running${color_end}\n"
    else
        if [[ ! -z `screen -list | grep -E "world-$id"` && -f "$source/bin/world.sh" ]]; then
            printf "${color_orange}Telling the world server to shut down${color_end}\n"

            PID=$(screen -ls | grep -oE "[0-9]+\.world-$id" | sed -e "s/\..*$//g")

            if [[ $PID != "" ]]; then
                if [[ $1 == "restart" ]]; then
                    screen -S world-$id -p 0 -X stuff "server restart 10^m"
                else
                    screen -S world-$id -p 0 -X stuff "server shutdown 10^m"
                fi

                timeout 30 tail --pid=$PID -f /dev/null
            fi
        fi

        if [[ -f "$source/bin/stop.sh" ]]; then
            cd "$source/bin" && ./stop.sh
        fi
    fi

    printf "${color_green}Finished stopping the server...${color_end}\n"
}

function parameters
{
    printf "${color_green}Available parameters${color_end}\n"
    printf "${color_orange}install/setup/update             ${COLOR_WHITE}| ${color_blue}Downloads the source code, with enabled modules, and compiles it. Also downloads client files${color_end}\n"
    printf "${color_orange}database/db                      ${COLOR_WHITE}| ${color_blue}Import all files to the specified databases${color_end}\n"
    printf "${color_orange}config/conf/cfg/settings/options ${COLOR_WHITE}| ${color_blue}Updates all config files, including enabled modules, with options specified${color_end}\n"
    printf "${color_orange}dbc                              ${COLOR_WHITE}| ${color_blue}Copy modified client data files to the proper folder${color_end}\n"
    printf "${color_orange}reset                            ${COLOR_WHITE}| ${color_blue}Drops all database tables from the world database${color_end}\n"
    printf "${color_orange}all                              ${COLOR_WHITE}| ${color_blue}Run all parameters listed above, as well as stop and start${color_end}\n"
    printf "${color_orange}start                            ${COLOR_WHITE}| ${color_blue}Starts the compiled processes, based off of the choice for compilation${color_end}\n"
    printf "${color_orange}stop                             ${COLOR_WHITE}| ${color_blue}Stops the compiled processes, based off of the choice for compilation${color_end}\n"
    printf "${color_orange}restart                          ${COLOR_WHITE}| ${color_blue}Stops and then starts the compiled processes, based off of the choice for compilation${color_end}\n"
    exit $?
}

clear

if [[ $# == 1 ]]; then
    install_mysql_client
    get_settings

    if [[ $build_auth != "true" && $build_world != "true" ]]; then
        printf "${color_red}Auth and world are both disabled in the settings${color_end}\n"
        notify_telegram "An error occurred because auth and world are both disabled"
        exit $?
    fi

    if [[ "$1" == "install" ]] || [[ "$1" == "setup" ]] || [[ "$1" == "update" ]]; then
        install_packages
        stop_server
        get_source
        compile_source
        get_client_files
    elif [[ "$1" == "database" ]] || [[ "$1" == "db" ]]; then
        import_database_files
    elif [[ "$1" == "config" ]] || [[ "$1" == "conf" ]] || [[ "$1" == "cfg" ]] || [[ "$1" == "settings" ]] || [[ "$1" == "options" ]]; then
        set_config
    elif [[ "$1" == "dbc" ]]; then
        copy_dbc_files
    elif [[ "$1" == "reset" ]]; then
        drop_database_tables
    elif [[ "$1" == "all" ]]; then
        install_packages
        stop_server
        get_source
        compile_source
        get_client_files
        import_database_files
        set_config
        copy_dbc_files
        start_server
    elif [[ "$1" == "start" ]]; then
        start_server
    elif [[ "$1" == "stop" ]]; then
        stop_server
    elif [[ "$1" == "restart" ]]; then
        stop_server
        start_server
    else
        parameters
    fi
else
    parameters
fi
