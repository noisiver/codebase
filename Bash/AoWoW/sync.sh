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

LOCATION="/var/www/html/database"
OPTIONS=(access_requirement,
         creature_template,
         disables,
         game_event,
         gameobject_template,
         item_template,
         quest_template,
         spell_enchant_proc_data,
         spelldifficulty_dbc)

cd $LOCATION
SECONDS=0
for o in "${OPTIONS[@]}"; do
    php aowow --sync=$o
    if [ $? -ne 0 ]; then
        printf 'Syncing failed after %02dh:%02dm:%02ds\n' $(($SECONDS / 3600)) $((($SECONDS / 60) % 60)) $(($SECONDS % 60))
        exit $?
    fi
done
printf 'Syncing ended after %02dh:%02dm:%02ds\n' $(($SECONDS / 3600)) $((($SECONDS / 60) % 60)) $(($SECONDS % 60))
