#!/bin/bash
distribution=("ubuntu22.04" "debian12")

# Debian 12 required me to manually install mysql
# The reasoning behind this is that the nested queries that azerothcore use is not mariadb-friendly
# I used these commands to be able to install mysql:
# apt update && apt install -y wget
# wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb
# apt install -y ./mysql-apt-config_0.8.29-1_all.deb
# Followed the instructions and made sure that mysql server and connectors were enabled
# apt update && apt install -y mysql-server
# The script works after setting that up

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
source="$root/source"
mysql_cnf="$root/mysql.cnf"
telegram_inf="$root/telegram"

mysql_hostname="127.0.0.1"
mysql_port="3306"
mysql_username="acore"
mysql_password="acore"
mysql_database="acore_auth"
id=1
node=1

function install_packages
{
    packages=("git" "screen")

    if [[ "$world_cluster" == "true" ]]; then
        packages+=("golang-go" "redis")
    fi

    if [[ "$world_cluster" == "false" || "$build_world" == "true" ]]; then
        packages+=("cmake" "make" "gcc" "clang" "curl" "unzip" "g++" "libssl-dev" "libbz2-dev" "libreadline-dev" "libncurses-dev" "libboost1.74-all-dev" "libmysqlclient-dev" "mysql-client")
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

    if [[ "$world_cluster" == "true" && "$build_auth" == "true" ]]; then
        if ! [ -x "$(command -v nats-server)" ]; then
            if [[ $(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed") -eq 0 ]]; then
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
                    sudo apt-get --yes install curl
                else
                    apt-get --yes install curl
                fi
                if [[ $? != 0 ]]; then
                    notify_telegram "An error occurred while trying to install the required packages"
                    exit $?
                fi
            fi

            curl -L "https://github.com/nats-io/nats-server/releases/download/v2.10.7/nats-server-v2.10.7-amd64.deb" -o "$root/nats-server-v2.10.7-amd64.deb"
            if [[ $? != 0 ]]; then
                notify_telegram "An error occurred while trying to install the required packages"
                exit $?
            fi

            if [[ $EUID != 0 ]]; then
                sudo dpkg -i "$root/nats-server-v2.10.7-amd64.deb"
            else
                dpkg -i "$root/nats-server-v2.10.7-amd64.deb"
            fi
            if [[ $? != 0 ]]; then
                notify_telegram "An error occurred while trying to install the required packages"
                exit $?
            fi
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
            "module.ah_bot.account") module_ah_bot_account="$value";;
            "module.ah_bot.buy_items") module_ah_bot_buy_items="$value";;
            "module.ah_bot.character") module_ah_bot_character="$value";;
            "module.ah_bot.items") module_ah_bot_items="$value";;
            "module.ah_bot.items_per_cycle") module_ah_bot_items_per_cycle="$value";;
            "module.ah_bot.max_item_level") module_ah_bot_max_item_level="$value";;
            "module.ah_bot.sell_items") module_ah_bot_sell_items="$value";;
            "module.ah_bot.use_buyprice") module_ah_bot_use_buyprice="$value";;
            "module.appreciation") module_appreciation="$value";;
            "module.appreciation.level_boost") module_appreciation_level_boost="$value";;
            "module.appreciation.level_boost.included_copper") module_appreciation_level_boost_included_copper="$value";;
            "module.appreciation.level_boost.level") module_appreciation_level_boost_level="$value";;
            "module.appreciation.require_certificate") module_appreciation_require_certificate="$value";;
            "module.appreciation.reward_at_max_level") module_appreciation_reward_at_max_level="$value";;
            "module.appreciation.unlock_continents") module_appreciation_unlock_continents="$value";;
            "module.assistant") module_assistant="$value";;
            "module.assistant.fp.tbc") module_assistant_fp_tbc="$value";;
            "module.assistant.fp.tbc.cost") module_assistant_fp_tbc_cost="$value";;
            "module.assistant.fp.tbc.required_level") module_assistant_fp_tbc_required_level="$value";;
            "module.assistant.fp.vanilla") module_assistant_fp_vanilla="$value";;
            "module.assistant.fp.vanilla.cost") module_assistant_fp_vanilla_cost="$value";;
            "module.assistant.fp.vanilla.required_level") module_assistant_fp_vanilla_required_level="$value";;
            "module.assistant.fp.wotlk") module_assistant_fp_wotlk="$value";;
            "module.assistant.fp.wotlk.cost") module_assistant_fp_wotlk_cost="$value";;
            "module.assistant.fp.wotlk.required_level") module_assistant_fp_wotlk_required_level="$value";;
            "module.assistant.professions.apprentice") module_assistant_professions_apprentice="$value";;
            "module.assistant.professions.apprentice.cost") module_assistant_professions_apprentice_cost="$value";;
            "module.assistant.professions.artisan") module_assistant_professions_artisan="$value";;
            "module.assistant.professions.artisan.cost") module_assistant_professions_artisan_cost="$value";;
            "module.assistant.professions.expert") module_assistant_professions_expert="$value";;
            "module.assistant.professions.expert.cost") module_assistant_professions_expert_cost="$value";;
            "module.assistant.professions.grand_master") module_assistant_professions_grand_master="$value";;
            "module.assistant.professions.grand_master.cost") module_assistant_professions_grand_master_cost="$value";;
            "module.assistant.professions.journeyman") module_assistant_professions_journeyman="$value";;
            "module.assistant.professions.journeyman.cost") module_assistant_professions_journeyman_cost="$value";;
            "module.assistant.professions.master") module_assistant_professions_master="$value";;
            "module.assistant.professions.master.cost") module_assistant_professions_master_cost="$value";;
            "module.assistant.utilities") module_assistant_utilities="$value";;
            "module.assistant.vendor.containers") module_assistant_vendor_containers="$value";;
            "module.assistant.vendor.gems") module_assistant_vendor_gems="$value";;
            "module.assistant.vendor.glyphs") module_assistant_vendor_glyphs="$value";;
            "module.assistant.vendor.heirlooms") module_assistant_vendor_heirlooms="$value";;
            "module.groupquests") module_groupquests="$value";;
            "module.junktogold") module_junktogold="$value";;
            "module.learnspells") module_learnspells="$value";;
            "module.learnspells.class_spells") module_learnspells_class_spells="$value";;
            "module.learnspells.proficiencies") module_learnspells_proficiencies="$value";;
            "module.learnspells.quest_spells") module_learnspells_quest_spells="$value";;
            "module.learnspells.riding.apprentice") module_learnspells_riding_apprentice="$value";;
            "module.learnspells.riding.artisan") module_learnspells_riding_artisan="$value";;
            "module.learnspells.riding.cold_weather_flying") module_learnspells_riding_cold_weather_flying="$value";;
            "module.learnspells.riding.expert") module_learnspells_riding_expert="$value";;
            "module.learnspells.riding.journeyman") module_learnspells_riding_journeyman="$value";;
            "module.learnspells.talent_ranks") module_learnspells_talent_ranks="$value";;
            "module.playerbots") module_playerbots="$value";;
            "module.playerbots.accounts") module_playerbots_accounts="$value";;
            "module.playerbots.bots") module_playerbots_bots="$value";;
            "module.playerbots.random_level") module_playerbots_random_level="$value";;
            "module.playerbots.start_level") module_playerbots_start_level="$value";;
            "module.progression") module_progression="$value";;
            "module.progression.aura") module_progression_aura="$value";;
            "module.progression.enforce.dungeonfinder") module_progression_enforce_dungeonfinder="$value";;
            "module.progression.enforce.questinfo") module_progression_enforce_questinfo="$value";;
            "module.progression.patch") module_progression_patch="$value";;
            "module.progression.reset") module_progression_reset="$value";;
            "module.recruitafriend") module_recruitafriend="$value";;
            "module.recruitafriend.account_age") module_recruitafriend_account_age="$value";;
            "module.recruitafriend.celestial_steed") module_recruitafriend_celestial_steed="$value";;
            "module.recruitafriend.duration") module_recruitafriend_duration="$value";;
            "module.recruitafriend.reward_days") module_recruitafriend_reward_days="$value";;
            "module.recruitafriend.swift_zhevra") module_recruitafriend_swift_zhevra="$value";;
            "module.recruitafriend.touring_rocket") module_recruitafriend_touring_rocket="$value";;
            "module.skip_dk_starting_area") module_skip_dk_starting_area="$value";;
            "module.weekendbonus") module_weekendbonus="$value";;
            "module.weekendbonus.multiplier.experience") module_weekendbonus_multiplier_experience="$value";;
            "module.weekendbonus.multiplier.money") module_weekendbonus_multiplier_money="$value";;
            "module.weekendbonus.multiplier.professions") module_weekendbonus_multiplier_professions="$value";;
            "module.weekendbonus.multiplier.proficiencies") module_weekendbonus_multiplier_proficiencies="$value";;
            "module.weekendbonus.multiplier.reputation") module_weekendbonus_multiplier_reputation="$value";;
            "telegram.chat_id") telegram_chat_id="$value";;
            "telegram.token") telegram_token="$value";;
            "world.address") world_address="$value";;
            "world.cluster") world_cluster="$value";;
            "world.cluster.auth_address") world_cluster_auth_address="$value";;
            "world.cluster.maps") world_cluster_maps="$value";;
            "world.cluster.node_address") world_cluster_node_address="$value";;
            "world.data_directory") world_data_directory="$value";;
            "world.expansion") world_expansion="$value";;
            "world.leave_group_on_logout") world_leave_group_on_logout="$value";;
            "world.motd") world_motd="$value";;
            "world.name") world_name="$value";;
            "world.player_limit") world_player_limit="$value";;
            "world.port") world_port="$value";;
            "world.preload_grids") world_preload_grids="$value";;
            "world.quest_in_raid") world_quest_in_raid="$value";;
            "world.raid_min_level") world_raid_min_level="$value";;
            "world.rate.experience") world_rate_experience="$value";;
            "world.rate.money") world_rate_money="$value";;
            "world.rate.reputation") world_rate_reputation="$value";;
            "world.realm_zone") world_realm_zone="$value";;
            "world.set_creatures_active") world_set_creatures_active="$value";;
            "world.type") world_type="$value";;
            "world.warden") world_warden="$value";;
            *) unknown="true"
        esac
        if [[ ! -z $setting && ! -z $value && -z $unknown ]]; then
            printf "${color_orange}$setting has been set to $value${color_end}\n"
        fi
    done <<<$(mysql --defaults-extra-file="$mysql_cnf" $mysql_database --skip-column-names -e "WITH s AS (SELECT id, node, setting, VALUE, ROW_NUMBER() OVER (PARTITION BY setting ORDER BY id DESC, node DESC) nr FROM realm_settings WHERE (id = $id OR id = -1) AND (node = $node OR node = -1)) SELECT setting, value FROM s WHERE nr = 1;" 2>&1)

    if [[ -z $build_auth || -z $build_world || -z $database_auth || -z $database_characters || -z $database_playerbots || -z $database_world || -z $git_branch || -z $git_repository || -z $module_ah_bot || -z $module_ah_bot_account || -z $module_ah_bot_buy_items || -z $module_ah_bot_character || -z $module_ah_bot_items || -z $module_ah_bot_items_per_cycle || -z $module_ah_bot_max_item_level || -z $module_ah_bot_sell_items || -z $module_ah_bot_use_buyprice || -z $module_appreciation || -z $module_appreciation_level_boost || -z $module_appreciation_level_boost_included_copper || -z $module_appreciation_level_boost_level || -z $module_appreciation_require_certificate || -z $module_appreciation_reward_at_max_level || -z $module_appreciation_unlock_continents || -z $module_assistant || -z $module_assistant_fp_tbc || -z $module_assistant_fp_tbc_cost || -z $module_assistant_fp_tbc_required_level || -z $module_assistant_fp_vanilla || -z $module_assistant_fp_vanilla_cost || -z $module_assistant_fp_vanilla_required_level || -z $module_assistant_fp_wotlk || -z $module_assistant_fp_wotlk_cost || -z $module_assistant_fp_wotlk_required_level || -z $module_assistant_professions_apprentice || -z $module_assistant_professions_apprentice_cost || -z $module_assistant_professions_artisan || -z $module_assistant_professions_artisan_cost || -z $module_assistant_professions_expert || -z $module_assistant_professions_expert_cost || -z $module_assistant_professions_grand_master || -z $module_assistant_professions_grand_master_cost || -z $module_assistant_professions_journeyman || -z $module_assistant_professions_journeyman_cost || -z $module_assistant_professions_master || -z $module_assistant_professions_master_cost || -z $module_assistant_utilities || -z $module_assistant_vendor_containers || -z $module_assistant_vendor_gems || -z $module_assistant_vendor_glyphs || -z $module_assistant_vendor_heirlooms || -z $module_groupquests || -z $module_junktogold || -z $module_learnspells|| -z $module_learnspells_class_spells || -z $module_learnspells_proficiencies || -z $module_learnspells_quest_spells || -z $module_learnspells_riding_apprentice || -z $module_learnspells_riding_artisan || -z $module_learnspells_riding_cold_weather_flying || -z $module_learnspells_riding_expert || -z $module_learnspells_riding_journeyman || -z $module_learnspells_talent_ranks || -z $module_playerbots || -z $module_playerbots_accounts || -z $module_playerbots_bots || -z $module_playerbots_random_level || -z $module_playerbots_start_level || -z $module_progression || -z $module_progression_aura || -z $module_progression_enforce_dungeonfinder || -z $module_progression_enforce_questinfo || -z $module_progression_patch || -z $module_progression_reset || -z $module_recruitafriend || -z $module_recruitafriend_account_age || -z $module_recruitafriend_celestial_steed || -z $module_recruitafriend_duration || -z $module_recruitafriend_reward_days || -z $module_recruitafriend_swift_zhevra || -z $module_recruitafriend_touring_rocket || -z $module_skip_dk_starting_area || -z $module_weekendbonus || -z $module_weekendbonus_multiplier_experience || -z $module_weekendbonus_multiplier_money || -z $module_weekendbonus_multiplier_professions || -z $module_weekendbonus_multiplier_proficiencies || -z $module_weekendbonus_multiplier_reputation || -z $telegram_chat_id || -z $telegram_token || -z $world_address || -z $world_cluster || -z $world_cluster_auth_address || -z $world_cluster_maps || -z $world_cluster_node_address || -z $world_data_directory || -z $world_expansion || -z $world_leave_group_on_logout || -z $world_motd || -z $world_name || -z $world_player_limit || -z $world_port || -z $world_preload_grids || -z $world_quest_in_raid || -z $world_raid_min_level || -z $world_rate_experience || -z $world_rate_money || -z $world_rate_reputation || -z $world_realm_zone || -z $world_set_creatures_active || -z $world_type || -z $world_warden ]]; then
        if [[ -z $build_auth ]]; then printf "${color_red}build.auth is not set in the settings${color_end}\n"; fi
        if [[ -z $build_world ]]; then printf "${color_red}build.world is not set in the settings${color_end}\n"; fi
        if [[ -z $database_auth ]]; then printf "${color_red}database.auth is not set in the settings${color_end}\n"; fi
        if [[ -z $database_characters ]]; then printf "${color_red}database.characters is not set in the settings${color_end}\n"; fi
        if [[ -z $database_playerbots ]]; then printf "${color_red}database.playerbots is not set in the settings${color_end}\n"; fi
        if [[ -z $database_world ]]; then printf "${color_red}database.world is not set in the settings${color_end}\n"; fi
        if [[ -z $git_branch ]]; then printf "${color_red}git.branch is not set in the settings${color_end}\n"; fi
        if [[ -z $git_repository ]]; then printf "${color_red}git.repository is not set in the settings${color_end}\n"; fi
        if [[ -z $module_ah_bot ]]; then printf "${color_red}module.ah_bot is not set in the settings${color_end}\n"; fi
        if [[ -z $module_ah_bot_account ]]; then printf "${color_red}module.ah_bot.account is not set in the settings${color_end}\n"; fi
        if [[ -z $module_ah_bot_buy_items ]]; then printf "${color_red}module.ah_bot.buy_items is not set in the settings${color_end}\n"; fi
        if [[ -z $module_ah_bot_character ]]; then printf "${color_red}module.ah_bot.character is not set in the settings${color_end}\n"; fi
        if [[ -z $module_ah_bot_items ]]; then printf "${color_red}module.ah_bot.items is not set in the settings${color_end}\n"; fi
        if [[ -z $module_ah_bot_items_per_cycle ]]; then printf "${color_red}module.ah_bot.items_per_cycle is not set in the settings${color_end}\n"; fi
        if [[ -z $module_ah_bot_max_item_level ]]; then printf "${color_red}module.ah_bot.max_item_level is not set in the settings${color_end}\n"; fi
        if [[ -z $module_ah_bot_sell_items ]]; then printf "${color_red}module.ah_bot.sell_items is not set in the settings${color_end}\n"; fi
        if [[ -z $module_ah_bot_use_buyprice ]]; then printf "${color_red}module.ah_bot.use_buyprice is not set in the settings${color_end}\n"; fi
        if [[ -z $module_appreciation ]]; then printf "${color_red}module.appreciation is not set in the settings${color_end}\n"; fi
        if [[ -z $module_appreciation_level_boost ]]; then printf "${color_red}module.appreciation.level_boost is not set in the settings${color_end}\n"; fi
        if [[ -z $module_appreciation_level_boost_included_copper ]]; then printf "${color_red}module.appreciation.level_boost.included_copper is not set in the settings${color_end}\n"; fi
        if [[ -z $module_appreciation_level_boost_level ]]; then printf "${color_red}module.appreciation.level_boost.level is not set in the settings${color_end}\n"; fi
        if [[ -z $module_appreciation_require_certificate ]]; then printf "${color_red}module.appreciation.require_certificate is not set in the settings${color_end}\n"; fi
        if [[ -z $module_appreciation_reward_at_max_level ]]; then printf "${color_red}module.appreciation.reward_at_max_level is not set in the settings${color_end}\n"; fi
        if [[ -z $module_appreciation_unlock_continents ]]; then printf "${color_red}module.appreciation.unlock_continents is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant ]]; then printf "${color_red}module.assistant is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_fp_tbc ]]; then printf "${color_red}module.assistant.fp.tbc is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_fp_tbc_cost ]]; then printf "${color_red}module.assistant.fp.tbc.cost is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_fp_tbc_required_level ]]; then printf "${color_red}module.assistant.fp.tbc.required_level is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_fp_vanilla ]]; then printf "${color_red}module.assistant.fp.vanilla is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_fp_vanilla_cost ]]; then printf "${color_red}module.assistant.fp.vanilla.cost is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_fp_vanilla_required_level ]]; then printf "${color_red}module.assistant.fp.vanilla.required_level is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_fp_wotlk ]]; then printf "${color_red}module.assistant.fp.wotlk is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_fp_wotlk_cost ]]; then printf "${color_red}module.assistant.fp.wotlk.cost is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_fp_wotlk_required_level ]]; then printf "${color_red}module.assistant.fp.wotlk.required_level is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_apprentice ]]; then printf "${color_red}module.assistant.professions.apprentice is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_apprentice_cost ]]; then printf "${color_red}module.assistant.professions.apprentice.cost is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_artisan ]]; then printf "${color_red}module.assistant.professions.artisan is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_artisan_cost ]]; then printf "${color_red}module.assistant.professions.artisan.cost is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_expert ]]; then printf "${color_red}module.assistant.professions.expert is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_expert_cost ]]; then printf "${color_red}module.assistant.professions.expert.cost is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_grand_master ]]; then printf "${color_red}module.assistant.professions.grand_master is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_grand_master_cost ]]; then printf "${color_red}module.assistant.professions.grand_master.cost is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_journeyman ]]; then printf "${color_red}module.assistant.professions.journeyman is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_journeyman_cost ]]; then printf "${color_red}module.assistant.professions.journeyman.cost is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_master ]]; then printf "${color_red}module.assistant.professions.master is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_professions_master_cost ]]; then printf "${color_red}module.assistant.professions.master.cost is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_utilities ]]; then printf "${color_red}module.assistant.utilities is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_vendor_containers ]]; then printf "${color_red}module.assistant.vendor.containers is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_vendor_gems ]]; then printf "${color_red}module.assistant.vendor.gems is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_vendor_glyphs ]]; then printf "${color_red}module.assistant.vendor.glyphs is not set in the settings${color_end}\n"; fi
        if [[ -z $module_assistant_vendor_heirlooms ]]; then printf "${color_red}module.assistant.vendor.heirlooms is not set in the settings${color_end}\n"; fi
        if [[ -z $module_groupquests ]]; then printf "${color_red}module.groupquests is not set in the settings${color_end}\n"; fi
        if [[ -z $module_junktogold ]]; then printf "${color_red}module.junktogold is not set in the settings${color_end}\n"; fi
        if [[ -z $module_learnspells ]]; then printf "${color_red}module.learnspells is not set in the settings${color_end}\n"; fi
        if [[ -z $module_learnspells_class_spells ]]; then printf "${color_red}module.learnspells.class_spells is not set in the settings${color_end}\n"; fi
        if [[ -z $module_learnspells_proficiencies ]]; then printf "${color_red}module.learnspells.proficiencies is not set in the settings${color_end}\n"; fi
        if [[ -z $module_learnspells_quest_spells ]]; then printf "${color_red}module.learnspells.quest_spells is not set in the settings${color_end}\n"; fi
        if [[ -z $module_learnspells_riding_apprentice ]]; then printf "${color_red}module.learnspells.riding.apprentice is not set in the settings${color_end}\n"; fi
        if [[ -z $module_learnspells_riding_artisan ]]; then printf "${color_red}module.learnspells.riding.artisan is not set in the settings${color_end}\n"; fi
        if [[ -z $module_learnspells_riding_cold_weather_flying ]]; then printf "${color_red}module.learnspells.riding.cold_weather_flying is not set in the settings${color_end}\n"; fi
        if [[ -z $module_learnspells_riding_expert ]]; then printf "${color_red}module.learnspells.riding.expert is not set in the settings${color_end}\n"; fi
        if [[ -z $module_learnspells_riding_journeyman ]]; then printf "${color_red}module.learnspells.riding.journeyman is not set in the settings${color_end}\n"; fi
        if [[ -z $module_learnspells_talent_ranks ]]; then printf "${color_red}module.learnspells.talent_ranks is not set in the settings${color_end}\n"; fi
        if [[ -z $module_playerbots ]]; then printf "${color_red}module.playerbots is not set in the settings${color_end}\n"; fi
        if [[ -z $module_playerbots_accounts ]]; then printf "${color_red}module.playerbots.accounts is not set in the settings${color_end}\n"; fi
        if [[ -z $module_playerbots_bots ]]; then printf "${color_red}module.playerbots.bots is not set in the settings${color_end}\n"; fi
        if [[ -z $module_playerbots_random_level ]]; then printf "${color_red}module.playerbots.random_level is not set in the settings${color_end}\n"; fi
        if [[ -z $module_playerbots_start_level ]]; then printf "${color_red}module.playerbots.start_level is not set in the settings${color_end}\n"; fi
        if [[ -z $module_progression ]]; then printf "${color_red}module.progression is not set in the settings${color_end}\n"; fi
        if [[ -z $module_progression_aura ]]; then printf "${color_red}module.progression.aura is not set in the settings${color_end}\n"; fi
        if [[ -z $module_progression_enforce_dungeonfinder ]]; then printf "${color_red}module.progression.enforce.dungeonfinder is not set in the settings${color_end}\n"; fi
        if [[ -z $module_progression_enforce_questinfo ]]; then printf "${color_red}module.progression.enforce.questinfo is not set in the settings${color_end}\n"; fi
        if [[ -z $module_progression_patch ]]; then printf "${color_red}module.progression.patch is not set in the settings${color_end}\n"; fi
        if [[ -z $module_progression_reset ]]; then printf "${color_red}module.progression.reset is not set in the settings${color_end}\n"; fi
        if [[ -z $module_recruitafriend ]]; then printf "${color_red}module.recruitafriend is not set in the settings${color_end}\n"; fi
        if [[ -z $module_recruitafriend_account_age ]]; then printf "${color_red}module.recruitafriend.account_age is not set in the settings${color_end}\n"; fi
        if [[ -z $module_recruitafriend_celestial_steed ]]; then printf "${color_red}module.recruitafriend.celestial_steed is not set in the settings${color_end}\n"; fi
        if [[ -z $module_recruitafriend_duration ]]; then printf "${color_red}module.recruitafriend.duration is not set in the settings${color_end}\n"; fi
        if [[ -z $module_recruitafriend_reward_days ]]; then printf "${color_red}module.recruitafriend.reward_days is not set in the settings${color_end}\n"; fi
        if [[ -z $module_recruitafriend_swift_zhevra ]]; then printf "${color_red}module.recruitafriend.swift_zhevra is not set in the settings${color_end}\n"; fi
        if [[ -z $module_recruitafriend_touring_rocket ]]; then printf "${color_red}module.recruitafriend.touring_rocket is not set in the settings${color_end}\n"; fi
        if [[ -z $module_skip_dk_starting_area ]]; then printf "${color_red}module.skip_dk_starting_area is not set in the settings${color_end}\n"; fi
        if [[ -z $module_weekendbonus ]]; then printf "${color_red}module.weekendbonus is not set in the settings${color_end}\n"; fi
        if [[ -z $module_weekendbonus_multiplier_experience ]]; then printf "${color_red}module.weekendbonus.multiplier.experience is not set in the settings${color_end}\n"; fi
        if [[ -z $module_weekendbonus_multiplier_money ]]; then printf "${color_red}module.weekendbonus.multiplier.money is not set in the settings${color_end}\n"; fi
        if [[ -z $module_weekendbonus_multiplier_professions ]]; then printf "${color_red}module.weekendbonus.multiplier.professions is not set in the settings${color_end}\n"; fi
        if [[ -z $module_weekendbonus_multiplier_proficiencies ]]; then printf "${color_red}module.weekendbonus.multiplier.proficiencies is not set in the settings${color_end}\n"; fi
        if [[ -z $module_weekendbonus_multiplier_reputation ]]; then printf "${color_red}module.weekendbonus.multiplier.reputation is not set in the settings${color_end}\n"; fi
        if [[ -z $telegram_chat_id ]]; then printf "${color_red}telegram.chat_id is not set in the settings${color_end}\n"; fi
        if [[ -z $telegram_token ]]; then printf "${color_red}telegram.token is not set in the settings${color_end}\n"; fi
        if [[ -z $world_address ]]; then printf "${color_red}world.address is not set in the settings${color_end}\n"; fi
        if [[ -z $world_cluster ]]; then printf "${color_red}world.cluster is not set in the settings${color_end}\n"; fi
        if [[ -z $world_cluster_auth_address ]]; then printf "${color_red}world.cluster.auth_address is not set in the settings${color_end}\n"; fi
        if [[ -z $world_cluster_maps ]]; then printf "${color_red}world.cluster.maps is not set in the settings${color_end}\n"; fi
        if [[ -z $world_cluster_node_address ]]; then printf "${color_red}world.cluster.node_address is not set in the settings${color_end}\n"; fi
        if [[ -z $world_data_directory ]]; then printf "${color_red}world.data_directory is not set in the settings${color_end}\n"; fi
        if [[ -z $world_expansion ]]; then printf "${color_red}world.expansion is not set in the settings${color_end}\n"; fi
        if [[ -z $world_leave_group_on_logout ]]; then printf "${color_red}world.leave_group_on_logout is not set in the settings${color_end}\n"; fi
        if [[ -z $world_motd ]]; then printf "${color_red}world.motd is not set in the settings${color_end}\n"; fi
        if [[ -z $world_name ]]; then printf "${color_red}world.name is not set in the settings${color_end}\n"; fi
        if [[ -z $world_player_limit ]]; then printf "${color_red}world.player_limit is not set in the settings${color_end}\n"; fi
        if [[ -z $world_port ]]; then printf "${color_red}world.port is not set in the settings${color_end}\n"; fi
        if [[ -z $world_preload_grids ]]; then printf "${color_red}world.preload_grids is not set in the settings${color_end}\n"; fi
        if [[ -z $world_quest_in_raid ]]; then printf "${color_red}world.quest_in_raid is not set in the settings${color_end}\n"; fi
        if [[ -z $world_raid_min_level ]]; then printf "${color_red}world.raid_min_level is not set in the settings${color_end}\n"; fi
        if [[ -z $world_rate_experience ]]; then printf "${color_red}world.rate.experience is not set in the settings${color_end}\n"; fi
        if [[ -z $world_rate_money ]]; then printf "${color_red}world.rate.money is not set in the settings${color_end}\n"; fi
        if [[ -z $world_rate_reputation ]]; then printf "${color_red}world.rate.reputation is not set in the settings${color_end}\n"; fi
        if [[ -z $world_set_creatures_active ]]; then printf "${color_red}world.set_creatures_active is not set in the settings${color_end}\n"; fi
        if [[ -z $world_type ]]; then printf "${color_red}world.type is not set in the settings${color_end}\n"; fi
        if [[ -z $world_warden ]]; then printf "${color_red}world.warden is not set in the settings${color_end}\n"; fi
        if [[ -z $world_realm_zone ]]; then printf "${color_red}world.realm_zone is not set in the settings${color_end}\n"; fi
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

    if [[ $patch  -eq 0 ]] && [[ $module_ah_bot_max_item_level -eq 0 || $module_ah_bot_max_item_level -gt 213 ]]; then
        module_ah_bot_max_item_level="213"
    elif [[ $patch  -eq 1 ]] && [[ $module_ah_bot_max_item_level -eq 0 || $module_ah_bot_max_item_level -gt 226 ]]; then
        module_ah_bot_max_item_level="226"
    elif [[ $patch  -eq 2 ]] && [[ $module_ah_bot_max_item_level -eq 0 || $module_ah_bot_max_item_level -gt 245 ]]; then
        module_ah_bot_max_item_level="245"
    fi

    if [[ "$world_cluster" == "true" ]]; then
        source="$root/source/azerothcore"
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
        if [[ "$world_cluster" == "true" ]]; then
            curl -s -X POST https://api.telegram.org/bot$telegram_token/sendMessage -d chat_id=$telegram_chat_id -d text="[$world_name (id: $id, node: $node)]: $1" > /dev/null
        else
            curl -s -X POST https://api.telegram.org/bot$telegram_token/sendMessage -d chat_id=$telegram_chat_id -d text="[$world_name (id: $id)]: $1" > /dev/null
        fi
    fi
}

function get_source
{
    printf "${color_green}Downloading the source code...${color_end}\n"

    if [[ "$world_cluster" == "true" ]]; then
        if [[ ! -d "$root/source/tocloud9" ]]; then
            git clone --recursive --depth 1 --branch master "https://github.com/walkline/ToCloud9.git" "$root/source/tocloud9"
            if [[ $? != 0 ]]; then
                notify_telegram "An error occurred while trying to download the source code"
                exit $?
            fi
        else
            cd "$root/source/tocloud9"

            git reset --hard origin/master
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
    fi

    if [[ "$world_cluster" == "false" ]] || [[ "$build_world" == "true" ]]; then
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
                if [[ $patch -lt 4 ]]; then
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

                if [[ $patch -lt 4 ]]; then
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

    printf "${color_green}Finished downloading the source code...${color_end}\n"
}

function compile_source
{
    printf "${color_green}Compiling the source code...${color_end}\n"

    if [[ "$world_cluster" == "true" ]]; then
        if [[ "$build_auth" == "true" ]]; then
            cd "$root/source/tocloud9"

            printf "${color_orange}Building authserver${color_end}\n"
            go build -o bin/authserver apps/authserver/cmd/authserver/main.go
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi

            printf "${color_orange}Building charserver${color_end}\n"
            go build -o bin/charserver apps/charserver/cmd/charserver/main.go
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi

            printf "${color_orange}Building chatserver${color_end}\n"
            go build -o bin/chatserver apps/chatserver/cmd/chatserver/main.go
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi

            printf "${color_orange}Building game-load-balancer${color_end}\n"
            go build -o bin/game-load-balancer apps/game-load-balancer/cmd/game-load-balancer/main.go
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi

            printf "${color_orange}Building servers-registry${color_end}\n"
            go build -o bin/servers-registry apps/servers-registry/cmd/servers-registry/main.go
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi

            printf "${color_orange}Building groupserver${color_end}\n"
            go build -o bin/groupserver apps/groupserver/cmd/groupserver/main.go
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi

            printf "${color_orange}Building guidserver${color_end}\n"
            go build -o bin/guidserver apps/guidserver/cmd/guidserver/main.go
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi

            printf "${color_orange}Building guildserver${color_end}\n"
            go build -o bin/guildserver apps/guildserver/cmd/guildserver/main.go
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi

            printf "${color_orange}Building mailserver${color_end}\n"
            go build -o bin/mailserver apps/mailserver/cmd/mailserver/main.go
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi

            echo "#!/bin/bash" > $root/source/tocloud9/bin/start.sh
            echo "screen -L -Logfile nats-server.log -dmS nats-server ./nats-server.sh" >> $root/source/tocloud9/bin/start.sh
            echo "screen -L -Logfile servers-registry.log -dmS servers-registry ./servers-registry.sh" >> $root/source/tocloud9/bin/start.sh
            echo "screen -L -Logfile guidserver.log -dmS guidserver ./guidserver.sh" >> $root/source/tocloud9/bin/start.sh
            echo "screen -L -Logfile authserver.log -dmS authserver ./authserver.sh" >> $root/source/tocloud9/bin/start.sh
            echo "screen -L -Logfile charserver.log -dmS charserver ./charserver.sh" >> $root/source/tocloud9/bin/start.sh
            echo "screen -L -Logfile chatserver.log -dmS chatserver ./chatserver.sh" >> $root/source/tocloud9/bin/start.sh
            echo "screen -L -Logfile game-load-balancer.log -dmS game-load-balancer ./game-load-balancer.sh" >> $root/source/tocloud9/bin/start.sh
            echo "screen -L -Logfile groupserver.log -dmS groupserver ./groupserver.sh" >> $root/source/tocloud9/bin/start.sh
            echo "screen -L -Logfile guildserver.log -dmS guildserver ./guildserver.sh" >> $root/source/tocloud9/bin/start.sh
            echo "screen -L -Logfile mailserver.log -dmS mailserver ./mailserver.sh" >> $root/source/tocloud9/bin/start.sh
            chmod +x $root/source/tocloud9/bin/start.sh

            echo "#!/bin/bash" > $root/source/tocloud9/bin/nats-server.sh
            echo "while :; do" >> $root/source/tocloud9/bin/nats-server.sh
            echo "    nats-server" >> $root/source/tocloud9/bin/nats-server.sh
            echo "    sleep 5" >> $root/source/tocloud9/bin/nats-server.sh
            echo "done" >> $root/source/tocloud9/bin/nats-server.sh
            chmod +x $root/source/tocloud9/bin/nats-server.sh

            echo "#!/bin/bash" > $root/source/tocloud9/bin/servers-registry.sh
            echo "while :; do" >> $root/source/tocloud9/bin/servers-registry.sh
            echo "    ./servers-registry" >> $root/source/tocloud9/bin/servers-registry.sh
            echo "    sleep 5" >> $root/source/tocloud9/bin/servers-registry.sh
            echo "done" >> $root/source/tocloud9/bin/servers-registry.sh
            chmod +x $root/source/tocloud9/bin/servers-registry.sh

            echo "#!/bin/bash" > $root/source/tocloud9/bin/guidserver.sh
            echo "while :; do" >> $root/source/tocloud9/bin/guidserver.sh
            echo "    ./guidserver" >> $root/source/tocloud9/bin/guidserver.sh
            echo "    sleep 5" >> $root/source/tocloud9/bin/guidserver.sh
            echo "done" >> $root/source/tocloud9/bin/guidserver.sh
            chmod +x $root/source/tocloud9/bin/guidserver.sh

            echo "#!/bin/bash" > $root/source/tocloud9/bin/authserver.sh
            echo "while :; do" >> $root/source/tocloud9/bin/authserver.sh
            echo "    ./authserver" >> $root/source/tocloud9/bin/authserver.sh
            echo "    sleep 5" >> $root/source/tocloud9/bin/authserver.sh
            echo "done" >> $root/source/tocloud9/bin/authserver.sh
            chmod +x $root/source/tocloud9/bin/authserver.sh

            echo "#!/bin/bash" > $root/source/tocloud9/bin/charserver.sh
            echo "while :; do" >> $root/source/tocloud9/bin/charserver.sh
            echo "    ./charserver" >> $root/source/tocloud9/bin/charserver.sh
            echo "    sleep 5" >> $root/source/tocloud9/bin/charserver.sh
            echo "done" >> $root/source/tocloud9/bin/charserver.sh
            chmod +x $root/source/tocloud9/bin/charserver.sh

            echo "#!/bin/bash" > $root/source/tocloud9/bin/chatserver.sh
            echo "while :; do" >> $root/source/tocloud9/bin/chatserver.sh
            echo "    ./chatserver" >> $root/source/tocloud9/bin/chatserver.sh
            echo "    sleep 5" >> $root/source/tocloud9/bin/chatserver.sh
            echo "done" >> $root/source/tocloud9/bin/chatserver.sh
            chmod +x $root/source/tocloud9/bin/chatserver.sh

            echo "#!/bin/bash" > $root/source/tocloud9/bin/game-load-balancer.sh
            echo "while :; do" >> $root/source/tocloud9/bin/game-load-balancer.sh
            echo "    ./game-load-balancer" >> $root/source/tocloud9/bin/game-load-balancer.sh
            echo "    sleep 5" >> $root/source/tocloud9/bin/game-load-balancer.sh
            echo "done" >> $root/source/tocloud9/bin/game-load-balancer.sh
            chmod +x $root/source/tocloud9/bin/game-load-balancer.sh

            echo "#!/bin/bash" > $root/source/tocloud9/bin/groupserver.sh
            echo "while :; do" >> $root/source/tocloud9/bin/groupserver.sh
            echo "    ./groupserver" >> $root/source/tocloud9/bin/groupserver.sh
            echo "    sleep 5" >> $root/source/tocloud9/bin/groupserver.sh
            echo "done" >> $root/source/tocloud9/bin/groupserver.sh
            chmod +x $root/source/tocloud9/bin/groupserver.sh

            echo "#!/bin/bash" > $root/source/tocloud9/bin/guildserver.sh
            echo "while :; do" >> $root/source/tocloud9/bin/guildserver.sh
            echo "    ./guildserver" >> $root/source/tocloud9/bin/guildserver.sh
            echo "    sleep 5" >> $root/source/tocloud9/bin/guildserver.sh
            echo "done" >> $root/source/tocloud9/bin/guildserver.sh
            chmod +x $root/source/tocloud9/bin/guildserver.sh

            echo "#!/bin/bash" > $root/source/tocloud9/bin/mailserver.sh
            echo "while :; do" >> $root/source/tocloud9/bin/mailserver.sh
            echo "    ./mailserver" >> $root/source/tocloud9/bin/mailserver.sh
            echo "    sleep 5" >> $root/source/tocloud9/bin/mailserver.sh
            echo "done" >> $root/source/tocloud9/bin/mailserver.sh
            chmod +x $root/source/tocloud9/bin/mailserver.sh

            echo "#!/bin/bash" > $root/source/tocloud9/bin/stop.sh
            echo "screen -X -S \"nats-server\" quit && pkill \"nats-server\"" >> $root/source/tocloud9/bin/stop.sh
            echo "screen -X -S \"servers-registry\" quit" >> $root/source/tocloud9/bin/stop.sh
            echo "screen -X -S \"guidserver\" quit" >> $root/source/tocloud9/bin/stop.sh
            echo "screen -X -S \"authserver\" quit" >> $root/source/tocloud9/bin/stop.sh
            echo "screen -X -S \"charserver\" quit" >> $root/source/tocloud9/bin/stop.sh
            echo "screen -X -S \"chatserver\" quit" >> $root/source/tocloud9/bin/stop.sh
            echo "screen -X -S \"game-load-balancer\" quit" >> $root/source/tocloud9/bin/stop.sh
            echo "screen -X -S \"groupserver\" quit" >> $root/source/tocloud9/bin/stop.sh
            echo "screen -X -S \"guildserver\" quit" >> $root/source/tocloud9/bin/stop.sh
            echo "screen -X -S \"mailserver\" quit" >> $root/source/tocloud9/bin/stop.sh
            chmod +x $root/source/tocloud9/bin/stop.sh
        fi

        if [[ "$build_world" == "true" ]]; then
            cd "$root/source/tocloud9"

            printf "${color_orange}Building libsidecar${color_end}\n"
            go build -o bin/libsidecar.so -buildmode=c-shared ./game-server/libsidecar/
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi

            cp "$root/source/tocloud9/bin/libsidecar.so" "$root/source/azerothcore/deps/libsidecar/libsidecar.so"
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi

            if [[ ! -f "/usr/lib/libsidecar.so" ]]; then
                if [[ $EUID != 0 ]]; then
                    sudo cp "$root/source/tocloud9/bin/libsidecar.so" "/usr/lib/libsidecar.so"
                else
                    cp "$root/source/tocloud9/bin/libsidecar.so" "/usr/lib/libsidecar.so"
                fi
            fi
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to compile the source code"
                exit $?
            fi
        fi
    fi

    if [[ "$world_cluster" == "false" ]] || [[ "$build_world" == "true" ]]; then
        mkdir -p "$source/build" && cd "$_"

        if [[ "$build_auth" == "true" && "$build_world" == "true" ]]; then
            apps="all"
        elif [[ "$build_auth" == "true" && "$build_world" != "true" ]]; then
            apps="auth-only"
        elif [[ "$build_auth" != "true" && "$build_world" == "true" ]]; then
            apps="world-only"
        fi

        for i in {1..2}; do
            if [[ "$world_cluster" == "true" ]]; then
                cmake ../ -DCMAKE_INSTALL_PREFIX=$source -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DSCRIPTS=static -DAPPS_BUILD="world-only" -DUSE_REAL_LIBSIDECAR=ON
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

        if [[ "$world_cluster" == "false" && "$build_auth" == "true" ]]; then
            echo "screen -AmdS auth ./auth.sh" >> "$source/bin/start.sh"
            echo "screen -X -S \"auth\" quit" >> "$source/bin/stop.sh"

            echo "#!/bin/bash" > "$source/bin/auth.sh"
            echo "while :; do" >> "$source/bin/auth.sh"
            echo "  ./authserver" >> "$source/bin/auth.sh"
            echo "  sleep 5" >> "$source/bin/auth.sh"
            echo "done" >> "$source/bin/auth.sh"

            chmod +x "$source/bin/auth.sh"
        else
            if [[ -f "$source/bin/auth.sh" ]]; then
                rm -rf "$source/bin/auth.sh"
            fi
        fi

        if [[ "$build_world" == "true" ]]; then
            echo "TIME=\$(date +%s)" >> "$source/bin/start.sh"
            if [[ "$world_cluster" == "true" ]]; then
                echo "screen -L -Logfile \$TIME.log -AmdS world-$id-$node ./world.sh" >> "$source/bin/start.sh"
                echo "screen -X -S \"world-$id-$node\" quit" >> "$source/bin/stop.sh"
            else
                echo "screen -L -Logfile \$TIME.log -AmdS world-$id ./world.sh" >> "$source/bin/start.sh"
                echo "screen -X -S \"world-$id\" quit" >> "$source/bin/stop.sh"
            fi

            echo "#!/bin/bash" > "$source/bin/world.sh"
            echo "while :; do" >> "$source/bin/world.sh"
            if [[ "$world_cluster" == "true" ]]; then
                echo "  TC9_CONFIG_FILE=$source/bin/config.yml AC_WORLD_SERVER_PORT="$(($node+9643))" GRPC_PORT="$(($node+9500))" HEALTH_CHECK_PORT="$(($node+8900))" ./worldserver" >> "$source/bin/world.sh"
            else
                echo "  ./worldserver" >> "$source/bin/world.sh"
            fi
            echo "  if [[ \$? == 0 ]]; then" >> "$source/bin/world.sh"
            echo "    break" >> "$source/bin/world.sh"
            echo "  fi" >> "$source/bin/world.sh"
            echo "  sleep 5" >> "$source/bin/world.sh"
            echo "done" >> "$source/bin/world.sh"

            chmod +x "$source/bin/world.sh"
        else
            if [[ -f "$source/bin/world.sh" ]]; then
                rm -rf "$source/bin/world.sh"
            fi
        fi

        chmod +x "$source/bin/start.sh"
        chmod +x "$source/bin/stop.sh"
    fi

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
                cp "$f" "$source/bin/dbc/$(basename $f)"
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

function import_database_files
{
    printf "${color_green}Importing the database files...${color_end}\n"

    if [[ "$world_cluster" == "false" || "$build_world" == "true" ]]; then
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

        if [[ "$world_cluster" == "true" ]]; then
            cp "$root/source/tocloud9/sql/characters/mysql/000001_create_guild_invites_table.up.sql" "$source/data/sql/custom/db_characters/000001_create_guild_invites_table.up.sql"
            cp "$root/source/tocloud9/sql/characters/mysql/000002_add_auto_increment_to_mail.up.sql" "$source/data/sql/custom/db_characters/000002_add_auto_increment_to_mail.up.sql"
            cp "$root/source/tocloud9/sql/characters/mysql/000003_create_group_invites_table.up.sql" "$source/data/sql/custom/db_characters/000003_create_group_invites_table.up.sql"
        else
            rm -rf "$source/data/sql/custom/db_characters/000001_create_guild_invites_table.up.sql"
            rm -rf "$source/data/sql/custom/db_characters/000002_add_auto_increment_to_mail.up.sql"
            rm -rf "$source/data/sql/custom/db_characters/000003_create_group_invites_table.up.sql"
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
                if [[ ! -d "$source/modules/mod-ah-bot/data/sql/db-world/base" ]]; then
                    printf "${color_red}The auction house bot module is enabled but the files aren't where they should be${color_end}\n"
                    printf "${color_red}Please make sure to install the server first${color_end}\n"
                    notify_telegram "An error occurred while trying to import the database files of mod-ah-bot"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi

                if [[ `ls -1 $source/modules/mod-ah-bot/data/sql/db-world/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-ah-bot/data/sql/db-world/base/*.sql; do
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

                mysql --defaults-extra-file=$mysql_cnf $database_world -e "UPDATE mod_auctionhousebot SET minitems='$module_ah_bot_max_item_level', maxitems='$module_ah_bot_max_item_level'"
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

            if [[ "$module_assistant" == "true" ]]; then
                if [[ ! -d "$source/modules/mod-assistant/data/sql/db-world/base" ]]; then
                    printf "${color_red}The assistant module is enabled but the files aren't where they should be${color_end}\n"
                    printf "${color_red}Please make sure to install the server first${color_end}\n"
                    notify_telegram "An error occurred while trying to import the database files of mod-assistant"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi

                if [[ `ls -1 $source/modules/mod-assistant/data/sql/db-world/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-assistant/data/sql/db-world/base/*.sql; do
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
                if [[ ! -d "$source/modules/mod-groupquests/data/sql/db-world/base" ]]; then
                    printf "${color_red}The group quests module is enabled but the files aren't where they should be${color_end}\n"
                    printf "${color_red}Please make sure to install the server first${color_end}\n"
                    notify_telegram "An error occurred while trying to import the database files of mod-groupquests"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi

                if [[ `ls -1 $source/modules/mod-groupquests/data/sql/db-world/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-groupquests/data/sql/db-world/base/*.sql; do
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
                if [[ ! -d "$source/modules/mod-progression/src/patch_01-3_0/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_02-3_1/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_03-3_2/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_04-3_3/sql" ]] || [[ ! -d "$source/modules/mod-progression/src/patch_05-3_3_5/sql" ]]; then
                    printf "${color_red}The progression module is enabled but the files aren't where they should be${color_end}\n"
                    printf "${color_red}Please make sure to install the server first${color_end}\n"
                    notify_telegram "An error occurred while trying to import the database files of mod-progression"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi

                if [[ "$module_progression_reset" == "true" ]]; then
                    mysql --defaults-extra-file=$mysql_cnf $database_world -e "DELETE FROM updates WHERE name LIKE 'patch_%'"
                    if [[ $? -ne 0 ]]; then
                        notify_telegram "An error occurred while trying to import the database files of mod-progression"
                        rm -rf "$mysql_cnf"
                        exit $?
                    fi
                fi

                if [[ "$module_progression_patch" -ge "0" ]]; then
                    if [[ `ls -1 $source/modules/mod-progression/src/patch_01-3_0/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                        for f in $source/modules/mod-progression/src/patch_01-3_0/sql/*.sql; do
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
                    if [[ `ls -1 $source/modules/mod-progression/src/patch_02-3_1/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                        for f in $source/modules/mod-progression/src/patch_02-3_1/sql/*.sql; do
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
                    if [[ `ls -1 $source/modules/mod-progression/src/patch_03-3_2/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                        for f in $source/modules/mod-progression/src/patch_03-3_2/sql/*.sql; do
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
                    if [[ `ls -1 $source/modules/mod-progression/src/patch_04-3_3/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                        for f in $source/modules/mod-progression/src/patch_04-3_3/sql/*.sql; do
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
                    if [[ `ls -1 $source/modules/mod-progression/src/patch_05-3_3_5/sql/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                        for f in $source/modules/mod-progression/src/patch_05-3_3_5/sql/*.sql; do
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
                if [[ ! -d "$source/modules/mod-recruitafriend/data/sql/db-auth/base" ]]; then
                    printf "${color_red}The recruit-a-friend module is enabled but the files aren't where they should be${color_end}\n"
                    printf "${color_red}Please make sure to install the server first${color_end}\n"
                    notify_telegram "An error occurred while trying to import the database files of mod-recruitafriend"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi

                if [[ `ls -1 $source/modules/mod-recruitafriend/data/sql/db-auth/base/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-recruitafriend/data/sql/db-auth/base/*.sql; do
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
                if [[ ! -d "$source/modules/mod-skip-dk-starting-area/sql/world" ]]; then
                    printf "${color_red}The skip dk starting area module is enabled but the files aren't where they should be${color_end}\n"
                    printf "${color_red}Please make sure to install the server first${color_end}\n"
                    notify_telegram "An error occurred while trying to import the database files of mod-skip-dk-starting-area"
                    rm -rf "$mysql_cnf"
                    exit $?
                fi

                if [[ `ls -1 $source/modules/mod-skip-dk-starting-area/sql/world/*.sql 2>/dev/null | wc -l` -gt 0 ]]; then
                    for f in $source/modules/mod-skip-dk-starting-area/sql/world/*.sql; do
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
            mysql --defaults-extra-file=$mysql_cnf $database_auth -e "DELETE FROM motd WHERE realmid='$id';INSERT INTO motd (realmid, text) VALUES ('$id', '$world_motd')"
            if [[ $? -ne 0 ]]; then
                notify_telegram "An error occurred while trying to update message of the day"
                rm -rf "$mysql_cnf"
                exit $?
            fi
        fi

        rm -rf "$mysql_cnf"
    else
        printf "${color_orange}Skipping process due to cluster being enabled and world server being disabled${color_end}\n"
    fi

    printf "${color_green}Finished importing the database files..${color_end}\n"
}

function set_config
{
    printf "${color_green}Updating the config files...${color_end}\n"

    if [[ "$world_cluster" == "true" ]]; then
        if [[ "$build_auth" == "true" ]]; then
            if [[ ! -f "$root/source/tocloud9/config.yml.example" ]]; then
                printf "${color_red}The config file config.yml.example is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files"
                exit $?
            fi

            printf "${color_orange}Updating config.yml${color_end}\n"

            cp "$root/source/tocloud9/config.yml.example" "$root/source/tocloud9/bin/config.yml"

            sed -i 's/  auth: \&defaultAuthDB.*/  auth: \&defaultAuthDB "'$mysql_username':'$mysql_password'@tcp('$mysql_hostname':'$mysql_port')\/'$database_auth'"/g' $root/source/tocloud9/bin/config.yml
            sed -i 's/  characters: \&defaultCharactersDB.*/  characters: \&defaultCharactersDB "'$mysql_username':'$mysql_password'@tcp('$mysql_hostname':'$mysql_port')\/'$database_characters'"/g' $root/source/tocloud9/bin/config.yml
            sed -i 's/  world: \&defaultWorldDB.*/  world: \&defaultWorldDB "'$mysql_username':'$mysql_password'@tcp('$mysql_hostname':'$mysql_port')\/'$database_world'"/g' $root/source/tocloud9/bin/config.yml
            sed -i 's/  schemaType: \&defaultSchemaType.*/  schemaType: \&defaultSchemaType "ac"/g' $root/source/tocloud9/bin/config.yml
            #sed -i 's/  serversRegistryServiceAddress:.*/  serversRegistryServiceAddress: '$world_cluster_node_address':8999/g' $root/source/tocloud9/bin/config.yml
            #sed -i 's/  charactersServiceAddress:.*/  charactersServiceAddress: "'$world_cluster_node_address':8991"/g' $root/source/tocloud9/bin/config.yml
            #sed -i 's/  chatServiceAddress:.*/  chatServiceAddress: "'$world_cluster_node_address':8992"/g' $root/source/tocloud9/bin/config.yml
            #sed -i 's/  guildsServiceAddress:.*/  guildsServiceAddress: "'$world_cluster_node_address':8995"/g' $root/source/tocloud9/bin/config.yml
            #sed -i 's/  mailServiceAddress:.*/  mailServiceAddress: "'$world_cluster_node_address':8997"/g' $root/source/tocloud9/bin/config.yml
            #sed -i 's/  groupServiceAddress:.*/  groupServiceAddress: "'$world_cluster_node_address':8998"/g' $root/source/tocloud9/bin/config.yml
            sed -i 's/  preferredHostname:.*/  preferredHostname: '$world_cluster_node_address'/g' $root/source/tocloud9/bin/config.yml
            #sed -i 's/  guidProviderServiceAddress:.*/  guidProviderServiceAddress: "'$world_cluster_node_address':8996"/g' $root/source/tocloud9/bin/config.yml
        fi

        if [[ "$build_world" == "true" ]]; then
            if [[ ! -f "$root/source/tocloud9/config.yml.example" ]]; then
                printf "${color_red}The config file config.yml.example is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files"
                exit $?
            fi

            printf "${color_orange}Updating config.yml${color_end}\n"

            cp "$root/source/tocloud9/config.yml.example" "$root/source/azerothcore/bin/config.yml"

            sed -i 's/  auth: \&defaultAuthDB.*/  auth: \&defaultAuthDB "'$mysql_username':'$mysql_password'@tcp('$mysql_hostname':'$mysql_port')\/'$database_auth'"/g' $root/source/azerothcore/bin/config.yml
            sed -i 's/  characters: \&defaultCharactersDB.*/  characters: \&defaultCharactersDB "'$mysql_username':'$mysql_password'@tcp('$mysql_hostname':'$mysql_port')\/'$database_characters'"/g' $root/source/azerothcore/bin/config.yml
            sed -i 's/  world: \&defaultWorldDB.*/  world: \&defaultWorldDB "'$mysql_username':'$mysql_password'@tcp('$mysql_hostname':'$mysql_port')\/'$database_world'"/g' $root/source/azerothcore/bin/config.yml
            sed -i 's/  schemaType: \&defaultSchemaType.*/  schemaType: \&defaultSchemaType "ac"/g' $root/source/azerothcore/bin/config.yml
            sed -i 's/nats: \&defaultNatsUrl.*/nats: \&defaultNatsUrl "nats:\/\/'$world_cluster_auth_address':4222"/g' $root/source/azerothcore/bin/config.yml
            sed -i 's/  serversRegistryServiceAddress:.*/  serversRegistryServiceAddress: "'$world_cluster_auth_address':8999"/g' $root/source/azerothcore/bin/config.yml
            #sed -i 's/  charactersServiceAddress:.*/  charactersServiceAddress: "'$world_cluster_auth_address':8991"/g' $root/source/azerothcore/bin/config.yml
            #sed -i 's/  chatServiceAddress:.*/  chatServiceAddress: "'$world_cluster_auth_address':8992"/g' $root/source/azerothcore/bin/config.yml
            #sed -i 's/  guildsServiceAddress:.*/  guildsServiceAddress: "'$world_cluster_auth_address':8995"/g' $root/source/azerothcore/bin/config.yml
            #sed -i 's/  mailServiceAddress:.*/  mailServiceAddress: "'$world_cluster_auth_address':8997"/g' $root/source/azerothcore/bin/config.yml
            #sed -i 's/  groupServiceAddress:.*/  groupServiceAddress: "'$world_cluster_node_address':8998"/g' $root/source/azerothcore/bin/config.yml
            sed -i 's/  preferredHostname:.*/  preferredHostname: '$world_cluster_node_address'/g' $root/source/azerothcore/bin/config.yml
            sed -i 's/  guidProviderServiceAddress:.*/  guidProviderServiceAddress: "'$world_cluster_auth_address':8996"/g' $root/source/azerothcore/bin/config.yml
        fi
    fi

    if [[ "$world_cluster" == "false" && "$build_auth" == "true" ]]; then
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

        [ "$world_quest_in_raid" == "true" ] && world_quest_in_raid0="1" || world_quest_in_raid0="0"
        [ "$world_warden" == "true" ] && world_warden0="1" || world_warden0="0"
        [ "$world_leave_group_on_logout" == "true" ] && world_leave_group_on_logout0="1" || world_leave_group_on_logout0="0"

        sed -i 's/LoginDatabaseInfo     =.*/LoginDatabaseInfo     = "'$mysql_hostname';'$mysql_port';'$mysql_username';'$mysql_password';'$database_auth'"/g' "$source/etc/worldserver.conf"
        sed -i 's/WorldDatabaseInfo     =.*/WorldDatabaseInfo     = "'$mysql_hostname';'$mysql_port';'$mysql_username';'$mysql_password';'$database_world'"/g' "$source/etc/worldserver.conf"
        sed -i 's/CharacterDatabaseInfo =.*/CharacterDatabaseInfo = "'$mysql_hostname';'$mysql_port';'$mysql_username';'$mysql_password';'$database_characters'"/g' "$source/etc/worldserver.conf"
        sed -i 's/Updates.EnableDatabases =.*/Updates.EnableDatabases = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/RealmID =.*/RealmID = '$id'/g' "$source/etc/worldserver.conf"
        sed -i 's/WorldServerPort =.*/WorldServerPort = '$world_port'/g' "$source/etc/worldserver.conf"
        sed -i 's/GameType =.*/GameType = '$world_type'/g' "$source/etc/worldserver.conf"
        sed -i 's/RealmZone =.*/RealmZone = '$world_realm_zone'/g' "$source/etc/worldserver.conf"
        sed -i 's/Expansion =.*/Expansion = '$world_expansion'/g' "$source/etc/worldserver.conf"
        sed -i 's/PlayerLimit =.*/PlayerLimit = '$world_player_limit'/g' "$source/etc/worldserver.conf"
        sed -i 's/StrictPlayerNames =.*/StrictPlayerNames = 3/g' "$source/etc/worldserver.conf"
        sed -i 's/StrictCharterNames =.*/StrictCharterNames = 3/g' "$source/etc/worldserver.conf"
        sed -i 's/StrictPetNames =.*/StrictPetNames = 3/g' "$source/etc/worldserver.conf"
        sed -i 's/AllowPlayerCommands =.*/AllowPlayerCommands = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/Quests.IgnoreRaid =.*/Quests.IgnoreRaid = '$world_quest_in_raid0'/g' "$source/etc/worldserver.conf"
        sed -i 's/Warden.Enabled =.*/Warden.Enabled = '$world_warden0'/g' "$source/etc/worldserver.conf"
        sed -i 's/PreloadAllNonInstancedMapGrids =.*/PreloadAllNonInstancedMapGrids = '$world_preload_grids'/g' "$source/etc/worldserver.conf"
        sed -i 's/SetAllCreaturesWithWaypointMovementActive =.*/SetAllCreaturesWithWaypointMovementActive = '$world_set_creatures_active'/g' "$source/etc/worldserver.conf"
        sed -i 's/Minigob.Manabonk.Enable =.*/Minigob.Manabonk.Enable = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.XP.Kill      =.*/Rate.XP.Kill      = '$world_rate_experience'/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.XP.Quest     =.*/Rate.XP.Quest     = '$world_rate_experience'/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.XP.Quest.DF  =.*/Rate.XP.Quest.DF  = '$world_rate_experience'/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.XP.Explore   =.*/Rate.XP.Explore   = '$world_rate_experience'/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.XP.Pet       =.*/Rate.XP.Pet       = '$world_rate_experience'/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.Drop.Money                 =.*/Rate.Drop.Money                 = '$world_rate_money'/g' "$source/etc/worldserver.conf"
        sed -i 's/Rate.Reputation.Gain =.*/Rate.Reputation.Gain = '$world_rate_reputation'/g' "$source/etc/worldserver.conf"
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
        sed -i 's/LeaveGroupOnLogout.Enabled =.*/LeaveGroupOnLogout.Enabled = '$world_leave_group_on_logout0'/g' "$source/etc/worldserver.conf"
        sed -i 's/Group.Raid.LevelRestriction =.*/Group.Raid.LevelRestriction = '$world_raid_min_level'/g' "$source/etc/worldserver.conf"
        sed -i 's/DBC.EnforceItemAttributes =.*/DBC.EnforceItemAttributes = 0/g' "$source/etc/worldserver.conf"
        sed -i 's/MapUpdate.Threads =.*/MapUpdate.Threads = '$(nproc)'/g' "$source/etc/worldserver.conf"
        sed -i 's/MinWorldUpdateTime =.*/MinWorldUpdateTime = 10/g' "$source/etc/worldserver.conf"
        sed -i 's/MapUpdateInterval =.*/MapUpdateInterval = 100/g' "$source/etc/worldserver.conf"
        data_directory=$(echo "$world_data_directory" | sed 's#/#\\/#g')
        sed -i 's/DataDir =.*/DataDir = "'"$data_directory"'"/g' "$source/etc/worldserver.conf"
        #sed -i 's/CharacterCreating.MinLevelForHeroicCharacter =.*/CharacterCreating.MinLevelForHeroicCharacter = 0/g' "$source/etc/worldserver.conf"
        #sed -i 's/RecruitAFriend.MaxLevel =.*/RecruitAFriend.MaxLevel = 79/g' "$source/etc/worldserver.conf"
        if [[ "$world_cluster" == "true" ]]; then
            sed -i 's/Cluster.Enabled=.*/Cluster.Enabled=1/g' "$source/etc/worldserver.conf"
            if [[ "$world_cluster_maps" == "all" ]]; then
                sed -i 's/Cluster.AvailableMaps=.*/Cluster.AvailableMaps=""/g' "$source/etc/worldserver.conf"
            else
                sed -i 's/Cluster.AvailableMaps=.*/Cluster.AvailableMaps="'$world_cluster_maps'"/g' "$source/etc/worldserver.conf"
            fi
        fi

        if [[ "$module_ah_bot" == "true" ]]; then
            if [[ ! -f "$source/etc/modules/mod_ahbot.conf.dist" ]]; then
                printf "${color_red}The config file mod_ahbot.conf.dist is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files of mod-ah-bot"
                exit $?
            fi

            printf "${color_orange}Updating mod_ahbot.conf${color_end}\n"

            cp "$source/etc/modules/mod_ahbot.conf.dist" "$source/etc/modules/mod_ahbot.conf"

            [ "$module_ah_bot_sell_items" == "true" ] && module_ah_bot_sell_items0="1" || module_ah_bot_sell_items="0"
            [ "$module_ah_bot_buy_items" == "true" ] && module_ah_bot_buy_items0="1" || module_ah_bot_buy_items0="0"
            [ "$module_ah_bot_use_buyprice" == "true" ] && module_ah_bot_use_buyprice0="0" || module_ah_bot_use_buyprice0="1"

            sed -i 's/AuctionHouseBot.EnableSeller =.*/AuctionHouseBot.EnableSeller = '$module_ah_bot_sell_items0'/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.EnableBuyer =.*/AuctionHouseBot.EnableBuyer = '$module_ah_bot_buy_items0'/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.UseBuyPriceForSeller =.*/AuctionHouseBot.UseBuyPriceForSeller = '$module_ah_bot_use_buyprice0'/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.UseBuyPriceForBuyer =.*/AuctionHouseBot.UseBuyPriceForBuyer = '$module_ah_bot_use_buyprice0'/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.Account =.*/AuctionHouseBot.Account = '$module_ah_bot_account'/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.GUID =.*/AuctionHouseBot.GUID = '$module_ah_bot_character'/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.ItemsPerCycle =.*/AuctionHouseBot.ItemsPerCycle = '$module_ah_bot_items_per_cycle'/g' "$source/etc/modules/mod_ahbot.conf"
            sed -i 's/AuctionHouseBot.DisableItemsAboveLevel =.*/AuctionHouseBot.DisableItemsAboveLevel = '$module_ah_bot_max_item_level'/g' "$source/etc/modules/mod_ahbot.conf"
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

            [ "$module_appreciation_require_certificate" == "true" ] && module_appreciation_require_certificate0="1" || module_appreciation_require_certificate0="0"
            [ "$module_appreciation_level_boost" == "true" ] && module_appreciation_level_boost0="1" || module_appreciation_level_boost0="0"
            [ "$module_appreciation_unlock_continents" == "true" ] && module_appreciation_unlock_continents0="1" || module_appreciation_unlock_continents0="0"
            [ "$module_appreciation_reward_at_max_level" == "true" ] && module_appreciation_reward_at_max_level0="1" || module_appreciation_reward_at_max_level0="0"

            sed -i 's/Appreciation.RequireCertificate.Enabled =.*/Appreciation.RequireCertificate.Enabled = '$module_appreciation_require_certificate0'/g' "$source/etc/modules/mod_appreciation.conf"
            sed -i 's/Appreciation.LevelBoost.Enabled =.*/Appreciation.LevelBoost.Enabled = '$module_appreciation_level_boost0'/g' "$source/etc/modules/mod_appreciation.conf"
            sed -i 's/Appreciation.LevelBoost.TargetLevel =.*/Appreciation.LevelBoost.TargetLevel = '$module_appreciation_level_boost_level'/g' "$source/etc/modules/mod_appreciation.conf"
            sed -i 's/Appreciation.LevelBoost.IncludedCopper =.*/Appreciation.LevelBoost.IncludedCopper = '$module_appreciation_level_boost_included_copper'/g' "$source/etc/modules/mod_appreciation.conf"
            sed -i 's/Appreciation.UnlockContinents.Enabled =.*/Appreciation.UnlockContinents.Enabled = '$module_appreciation_unlock_continents0'/g' "$source/etc/modules/mod_appreciation.conf"
            sed -i 's/Appreciation.RewardAtMaxLevel.Enabled =.*/Appreciation.RewardAtMaxLevel.Enabled = '$module_appreciation_reward_at_max_level0'/g' "$source/etc/modules/mod_appreciation.conf"
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

            [ "$module_assistant_vendor_heirlooms" == "true" ] && module_assistant_vendor_heirlooms0="1" || module_assistant_vendor_heirlooms0="0"
            [ "$module_assistant_vendor_glyphs" == "true" ] && module_assistant_vendor_glyphs0="1" || module_assistant_vendor_glyphs0="0"
            [ "$module_assistant_vendor_gems" == "true" ] && module_assistant_vendor_gems0="1" || module_assistant_vendor_gems0="0"
            [ "$module_assistant_vendor_containers" == "true" ] && module_assistant_vendor_containers0="1" || module_assistant_vendor_containers0="0"
            [ "$module_assistant_utilities" == "true" ] && module_assistant_utilities0="1" || module_assistant_utilities0="0"
            [ "$module_assistant_fp_vanilla" == "true" ] && module_assistant_fp_vanilla0="1" || module_assistant_fp_vanilla0="0"
            [ "$module_assistant_fp_tbc" == "true" ] && module_assistant_fp_tbc0="1" || module_assistant_fp_tbc0="0"
            [ "$module_assistant_fp_wotlk" == "true" ] && module_assistant_fp_wotlk0="1" || module_assistant_fp_wotlk0="0"
            [ "$module_assistant_professions_apprentice" == "true" ] && module_assistant_professions_apprentice0="1" || module_assistant_professions_apprentice0="0"
            [ "$module_assistant_professions_journeyman" == "true" ] && module_assistant_professions_journeyman0="1" || module_assistant_professions_journeyman0="0"
            [ "$module_assistant_professions_expert" == "true" ] && module_assistant_professions_expert0="1" || module_assistant_professions_expert0="0"
            [ "$module_assistant_professions_artisan" == "true" ] && module_assistant_professions_artisan0="1" || module_assistant_professions_artisan0="0"
            [ "$module_assistant_professions_master" == "true" ] && module_assistant_professions_master0="1" || module_assistant_professions_master0="0"
            [ "$module_assistant_professions_grand_master" == "true" ] && module_assistant_professions_grand_master0="1" || module_assistant_professions_grand_master0="0"

            sed -i 's/Assistant.Heirlooms.Enabled  =.*/Assistant.Heirlooms.Enabled  = '$module_assistant_vendor_heirlooms0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Glyphs.Enabled     =.*/Assistant.Glyphs.Enabled     = '$module_assistant_vendor_glyphs0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Gems.Enabled       =.*/Assistant.Gems.Enabled       = '$module_assistant_vendor_gems0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Containers.Enabled =.*/Assistant.Containers.Enabled = '$module_assistant_vendor_containers0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Utilities.Enabled            =.*/Assistant.Utilities.Enabled            = '$module_assistant_utilities0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.Vanilla.Enabled                  =.*/Assistant.FlightPaths.Vanilla.Enabled                  = '$module_assistant_fp_vanilla0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.Vanilla.RequiredLevel            =.*/Assistant.FlightPaths.Vanilla.RequiredLevel            = '$module_assistant_fp_vanilla_required_level'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.Vanilla.Cost                     =.*/Assistant.FlightPaths.Vanilla.Cost                     = '$module_assistant_fp_vanilla_cost'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.BurningCrusade.Enabled           =.*/Assistant.FlightPaths.BurningCrusade.Enabled           = '$module_assistant_fp_tbc0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.BurningCrusade.RequiredLevel     =.*/Assistant.FlightPaths.BurningCrusade.RequiredLevel     = '$module_assistant_fp_tbc_required_level'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.BurningCrusade.Cost              =.*/Assistant.FlightPaths.BurningCrusade.Cost              = '$module_assistant_fp_tbc_cost'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       =.*/Assistant.FlightPaths.WrathOfTheLichKing.Enabled       = '$module_assistant_fp_wotlk0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.RequiredLevel =.*/Assistant.FlightPaths.WrathOfTheLichKing.RequiredLevel = '$module_assistant_fp_wotlk_required_level'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.FlightPaths.WrathOfTheLichKing.Cost          =.*/Assistant.FlightPaths.WrathOfTheLichKing.Cost          = '$module_assistant_fp_wotlk_cost'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Apprentice.Enabled  =.*/Assistant.Professions.Apprentice.Enabled  = '$module_assistant_professions_apprentice0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Apprentice.Cost     =.*/Assistant.Professions.Apprentice.Cost     = '$module_assistant_professions_apprentice_cost'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Journeyman.Enabled  =.*/Assistant.Professions.Journeyman.Enabled  = '$module_assistant_professions_journeyman0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Journeyman.Cost     =.*/Assistant.Professions.Journeyman.Cost     = '$module_assistant_professions_journeyman_cost'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Expert.Enabled      =.*/Assistant.Professions.Expert.Enabled      = '$module_assistant_professions_expert0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Expert.Cost         =.*/Assistant.Professions.Expert.Cost         = '$module_assistant_professions_expert_cost'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Artisan.Enabled     =.*/Assistant.Professions.Artisan.Enabled     = '$module_assistant_professions_artisan0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Artisan.Cost        =.*/Assistant.Professions.Artisan.Cost        = '$module_assistant_professions_artisan_cost'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Master.Enabled      =.*/Assistant.Professions.Master.Enabled      = '$module_assistant_professions_master0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.Master.Cost         =.*/Assistant.Professions.Master.Cost         = '$module_assistant_professions_master_cost'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.GrandMaster.Enabled =.*/Assistant.Professions.GrandMaster.Enabled = '$module_assistant_professions_grand_master0'/g' "$source/etc/modules/mod_assistant.conf"
            sed -i 's/Assistant.Professions.GrandMaster.Cost    =.*/Assistant.Professions.GrandMaster.Cost    = '$module_assistant_professions_grand_master_cost'/g' "$source/etc/modules/mod_assistant.conf"
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

            [ "$module_learnspells_class_spells" == "true" ] && module_learnspells_class_spells0="1" || module_learnspells_class_spells0="0"
            [ "$module_learnspells_talent_ranks" == "true" ] && module_learnspells_talent_ranks0="1" || module_learnspells_talent_ranks0="0"
            [ "$module_learnspells_proficiencies" == "true" ] && module_learnspells_proficiencies0="1" || module_learnspells_proficiencies0="0"
            [ "$module_learnspells_quest_spells" == "true" ] && module_learnspells_quest_spells0="1" || module_learnspells_quest_spells0="0"
            [ "$module_learnspells_riding_apprentice" == "true" ] && module_learnspells_riding_apprentice0="1" || module_learnspells_riding_apprentice0="0"
            [ "$module_learnspells_riding_journeyman" == "true" ] && module_learnspells_riding_journeyman0="1" || module_learnspells_riding_journeyman0="0"
            [ "$module_learnspells_riding_expert" == "true" ] && module_learnspells_riding_expert0="1" || module_learnspells_riding_expert0="0"
            [ "$module_learnspells_riding_artisan" == "true" ] && module_learnspells_riding_artisan0="1" || module_learnspells_riding_artisan0="0"
            [ "$module_learnspells_riding_cold_weather_flying" == "true" ] && module_learnspells_riding_cold_weather_flying0="1" || module_learnspells_riding_cold_weather_flying0="0"

            sed -i 's/LearnSpells.ClassSpells =.*/LearnSpells.ClassSpells = '$module_learnspells_class_spells0'/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.TalentRanks =.*/LearnSpells.TalentRanks = '$module_learnspells_talent_ranks0'/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.Proficiencies =.*/LearnSpells.Proficiencies = '$module_learnspells_proficiencies0'/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.SpellsFromQuests =.*/LearnSpells.SpellsFromQuests = '$module_learnspells_quest_spells0'/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.Riding.Apprentice =.*/LearnSpells.Riding.Apprentice = '$module_learnspells_riding_apprentice0'/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.Riding.Journeyman =.*/LearnSpells.Riding.Journeyman = '$module_learnspells_riding_journeyman0'/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.Riding.Expert =.*/LearnSpells.Riding.Expert = '$module_learnspells_riding_expert0'/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.Riding.Artisan =.*/LearnSpells.Riding.Artisan = '$module_learnspells_riding_artisan0'/g' "$source/etc/modules/mod_learnspells.conf"
            sed -i 's/LearnSpells.Riding.ColdWeatherFlying =.*/LearnSpells.Riding.ColdWeatherFlying = '$module_learnspells_riding_cold_weather_flying0'/g' "$source/etc/modules/mod_learnspells.conf"
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

            [ "$module_playerbots_random_level" == "true" ] && module_playerbots_random_level0="0" || module_playerbots_random_level0="1"

            sed -i 's/AiPlayerbot.MinRandomBots =.*/AiPlayerbot.MinRandomBots = '$module_playerbots_bots'/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.MaxRandomBots =.*/AiPlayerbot.MaxRandomBots = '$module_playerbots_bots'/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandomBotAccountCount =.*/AiPlayerbot.RandomBotAccountCount = '$module_playerbots_accounts'/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.DisableRandomLevels =.*/AiPlayerbot.DisableRandomLevels = '$module_playerbots_random_level0'/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.RandombotStartingLevel =.*/AiPlayerbot.RandombotStartingLevel = '$module_playerbots_start_level'/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.PvpProhibitedZoneIds =.*/AiPlayerbot.PvpProhibitedZoneIds = "2255,656,2361,2362,2363,976,35,2268,3425,392,541,1446,3828,3712,3738,3565,3539,3623,4152,3988,4658,4284,4418,4436,4275,4323,4395,3703,4298"/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.AutoTeleportForLevel =.*/AiPlayerbot.AutoTeleportForLevel = 0/g' "$source/etc/modules/playerbots.conf"
            sed -i 's/AiPlayerbot.KillXPRate =.*/AiPlayerbot.KillXPRate = 1/g' "$source/etc/modules/playerbots.conf"

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

            [ "$module_progression_enforce_dungeonfinder" == "true" ] && module_progression_enforce_dungeonfinder0="1" || module_progression_enforce_dungeonfinder0="0"
            [ "$module_progression_enforce_questinfo" == "true" ] && module_progression_enforce_questinfo0="1" || module_progression_enforce_questinfo0="0"
            [ "$module_progression_reset" == "true" ] && module_progression_reset0="1" || module_progression_reset0="0"

            sed -i 's/Progression.Patch =.*/Progression.Patch = '$module_progression_patch'/g' "$source/etc/modules/mod_progression.conf"
            sed -i 's/Progression.IcecrownCitadel.Aura =.*/Progression.IcecrownCitadel.Aura = '$module_progression_aura'/g' "$source/etc/modules/mod_progression.conf"
            sed -i 's/Progression.QuestInfo.Enforced =.*/Progression.QuestInfo.Enforced = '$module_progression_enforce_questinfo0'/g' "$source/etc/modules/mod_progression.conf"
            sed -i 's/Progression.DungeonFinder.Enforced =.*/Progression.DungeonFinder.Enforced = '$module_progression_enforce_dungeonfinder0'/g' "$source/etc/modules/mod_progression.conf"
            sed -i 's/Progression.Reset =.*/Progression.Reset = '$module_progression_reset0'/g' "$source/etc/modules/mod_progression.conf"
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

            [ "$module_recruitafriend_swift_zhevra" == "true" ] && module_recruitafriend_swift_zhevra0="1" || module_recruitafriend_swift_zhevra0="0"
            [ "$module_recruitafriend_touring_rocket" == "true" ] && module_recruitafriend_touring_rocket0="1" || module_recruitafriend_touring_rocket0="0"
            [ "$module_recruitafriend_celestial_steed" == "true" ] && module_recruitafriend_celestial_steed0="1" || module_recruitafriend_celestial_steed0="0"

            sed -i 's/RecruitAFriend.Duration =.*/RecruitAFriend.Duration = '$module_recruitafriend_duration'/g' "$source/etc/modules/mod_recruitafriend.conf"
            sed -i 's/RecruitAFriend.MaxAccountAge =.*/RecruitAFriend.MaxAccountAge = '$module_recruitafriend_account_age'/g' "$source/etc/modules/mod_recruitafriend.conf"
            sed -i 's/RecruitAFriend.Rewards.Days =.*/RecruitAFriend.Rewards.Days = '$module_recruitafriend_reward_days'/g' "$source/etc/modules/mod_recruitafriend.conf"
            sed -i 's/RecruitAFriend.Rewards.SwiftZhevra =.*/RecruitAFriend.Rewards.SwiftZhevra = '$module_recruitafriend_swift_zhevra0'/g' "$source/etc/modules/mod_recruitafriend.conf"
            sed -i 's/RecruitAFriend.Rewards.TouringRocket =.*/RecruitAFriend.Rewards.TouringRocket = '$module_recruitafriend_touring_rocket0'/g' "$source/etc/modules/mod_recruitafriend.conf"
            sed -i 's/RecruitAFriend.Rewards.CelestialSteed =.*/RecruitAFriend.Rewards.CelestialSteed = '$module_recruitafriend_celestial_steed0'/g' "$source/etc/modules/mod_recruitafriend.conf"
        fi

        if [[ "$module_skip_dk_starting_area" == "true" ]]; then
            if [[ ! -f "$source/etc/modules/SkipDKModule.conf.dist" ]]; then
                printf "${color_red}The config file SkipDKModule.conf.dist is missing.${color_end}\n"
                printf "${color_red}Please make sure to install the server first.${color_end}\n"
                notify_telegram "An error occurred while trying to update the config files of mod-skip-dk-starting-area"
                exit $?
            fi

            printf "${color_orange}Updating SkipDKModule.conf${color_end}\n"

            cp "$source/etc/modules/SkipDKModule.conf.dist" "$source/etc/modules/SkipDKModule.conf"

            sed -i 's/Skip.Deathknight.Starter.Announce.enable =.*/Skip.Deathknight.Starter.Announce.enable = 0/g' "$source/etc/modules/SkipDKModule.conf"
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

            sed -i 's/WeekendBonus.Multiplier.Experience =.*/WeekendBonus.Multiplier.Experience = '$module_weekendbonus_multiplier_experience'/g' "$source/etc/modules/mod_weekendbonus.conf"
            sed -i 's/WeekendBonus.Multiplier.Money =.*/WeekendBonus.Multiplier.Money = '$module_weekendbonus_multiplier_money'/g' "$source/etc/modules/mod_weekendbonus.conf"
            sed -i 's/WeekendBonus.Multiplier.Professions =.*/WeekendBonus.Multiplier.Professions = '$module_weekendbonus_multiplier_professions'/g' "$source/etc/modules/mod_weekendbonus.conf"
            sed -i 's/WeekendBonus.Multiplier.Reputation =.*/WeekendBonus.Multiplier.Reputation = '$module_weekendbonus_multiplier_reputation'/g' "$source/etc/modules/mod_weekendbonus.conf"
            sed -i 's/WeekendBonus.Multiplier.Proficiencies =.*/WeekendBonus.Multiplier.Proficiencies = '$module_weekendbonus_multiplier_proficiencies'/g' "$source/etc/modules/mod_weekendbonus.conf"
        fi
    fi

    printf "${color_green}Finished updating the config files...${color_end}\n"
}

function start_server
{
    printf "${color_green}Starting the server...${color_end}\n"

    if [[ "$world_cluster" == "true" && "$build_auth" == "true" ]]; then
        if [[ ! -f "$root/source/tocloud9/bin/start.sh" ]] || [[ ! -f "$root/source/tocloud9/bin/stop.sh" ]]; then
            printf "${color_red}The required binaries are missing${color_end}\n"
            printf "${color_red}Please make sure to install the server first${color_end}\n"
        else
            if [[ ! -z `screen -list | grep -E "nats-server"` ]] || [[ ! -z `screen -list | grep -E "servers-registry"` ]] || [[ ! -z `screen -list | grep -E "guidserver"` ]] || [[ ! -z `screen -list | grep -E "authserver"` ]] || [[ ! -z `screen -list | grep -E "charserver"` ]] || [[ ! -z `screen -list | grep -E "chatserver"` ]] || [[ ! -z `screen -list | grep -E "game-load-balancer"` ]] || [[ ! -z `screen -list | grep -E "groupserver"` ]] || [[ ! -z `screen -list | grep -E "guildserver"` ]] || [[ ! -z `screen -list | grep -E "mailserver"` ]]; then
                printf "${color_red}The server is already running.${color_end}\n"
            else
                cd "$root/source/tocloud9/bin" && ./start.sh
            fi
        fi
    fi

    if [[ "$world_cluster" == "false" || "$build_world" == "true" ]]; then
        if [[ ! -f "$source/bin/start.sh" ]] || [[ ! -f "$source/bin/stop.sh" ]]; then
            printf "${color_red}The required binaries are missing${color_end}\n"
            printf "${color_red}Please make sure to install the server first${color_end}\n"
        else
            if [[ ! -z `screen -list | grep -E "world-$id-$node"` && -f "$source/bin/world.sh" && "$world_cluster" == "true" ]]; then
                printf "${color_red}The server is already running${color_end}\n"
            elif [[ ! -z `screen -list | grep -E "auth"` && -f "$source/bin/auth.sh" ]] || [[ ! -z `screen -list | grep -E "world-$id"` && -f "$source/bin/world.sh" && "$world_cluster" == "false" ]]; then
                printf "${color_red}The server is already running${color_end}\n"
            else
                cd "$source/bin" && ./start.sh

                if [[ ! -z `screen -list | grep -E "auth"` && -f "$source/bin/auth.sh" ]]; then
                    printf "${color_orange}To access the screen of the authserver, use the command ${color_blue}screen -r auth${color_orange}${color_end}\n"
                fi

                if [[ ! -z `screen -list | grep -E "world-$id-$node"` && -f "$source/bin/world.sh" && "$world_cluster" == "true" ]]; then
                    printf "${color_orange}To access the screen of the worldserver, use the command ${color_blue}screen -r world-$id-$node${color_orange}${color_end}\n"
                elif [[ ! -z `screen -list | grep -E "world-$id"` && -f "$source/bin/world.sh" && "$world_cluster" == "false" ]]; then
                    printf "${color_orange}To access the screen of the worldserver, use the command ${color_blue}screen -r world-$id${color_orange}${color_end}\n"
                fi
            fi
        fi
    fi

    printf "${color_green}Finished starting the server...${color_end}\n"
}

function stop_server
{
    printf "${color_green}Stopping the server...${color_end}\n"

    if [[ "$world_cluster" == "true" && "$build_auth" == "true" ]]; then
        if [[ -z `screen -list | grep -E "nats-server"` ]] && [[ -z `screen -list | grep -E "servers-registry"` ]] && [[ -z `screen -list | grep -E "guidserver"` ]] && [[ -z `screen -list | grep -E "authserver"` ]] && [[ -z `screen -list | grep -E "charserver"` ]] && [[ -z `screen -list | grep -E "chatserver"` ]] && [[ -z `screen -list | grep -E "game-load-balancer"` ]] && [[ -z `screen -list | grep -E "groupserver"` ]] && [[ -z `screen -list | grep -E "guildserver"` ]] && [[ -z `screen -list | grep -E "mailserver"` ]]; then
            printf "${color_red}The server is not running.${color_end}\n"
        else
            if [[ -f "$root/source/tocloud9/bin/stop.sh" ]]; then
                cd "$root/source/tocloud9/bin" && ./stop.sh
            fi
        fi
    fi

    if [[ "$world_cluster" == "false" || "$build_world" == "true" ]]; then
        if [[ -z `screen -list | grep -E "auth"` || ! -f "$source/bin/auth.sh" ]] && [[ -z `screen -list | grep -E "world-$id"` || ! -f "$source/bin/world.sh" ]]; then
            printf "${color_red}The server is not running${color_end}\n"
        else
            if [[ ! -z `screen -list | grep -E "world-$id"` && -f "$source/bin/world.sh" && "$world_cluster" == "false" ]] || [[ ! -z `screen -list | grep -E "world-$id-$node"` && -f "$source/bin/world.sh" && "$world_cluster" == "true" ]]; then
                printf "${color_orange}Telling the world server to shut down${color_end}\n"

                if [[ "$world_cluster" == "true" ]]; then
                    PID=$(screen -ls | grep -oE "[0-9]+\.world-$id-$node" | sed -e "s/\..*$//g")
                else
                    PID=$(screen -ls | grep -oE "[0-9]+\.world-$id" | sed -e "s/\..*$//g")
                fi

                if [[ $PID != "" ]]; then
                    if [[ $1 == "restart" ]]; then
                        if [[ "$world_cluster" == "true" ]]; then
                            screen -S world-$id-$node -p 0 -X stuff "server restart 10^m"
                        else
                            screen -S world-$id-$node -p 0 -X stuff "server restart 10^m"
                        fi
                    else
                        if [[ "$world_cluster" == "true" ]]; then
                            screen -S world-$id-$node -p 0 -X stuff "server shutdown 10^m"
                        else
                            screen -S world-$id -p 0 -X stuff "server shutdown 10^m"
                        fi
                    fi

                    timeout 30 tail --pid=$PID -f /dev/null
                fi
            fi

            if [[ -f "$source/bin/stop.sh" ]]; then
                cd "$source/bin" && ./stop.sh
            fi
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
