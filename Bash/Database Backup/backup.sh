#!/bin/bash
INCLUDES=("distribution" "packages" "configuration" "database" "drive")

clear
echo -e "\e[0;32mInitializing...\e[0m"

for i in "${INCLUDES[@]}"; do
    if [ -f "includes/$i.sh" ]; then
        echo -e "\e[0;33mLoading includes/$i.sh\e[0m"
        source "includes/$i.sh"
    else
        echo -e "\e[0;33mUnable to access includes/$i.sh\e[0m"
        exit 1
    fi
done

if [ $BACKUP_TYPE == "local" ]; then
    backup_database "$root/database"
elif [ $BACKUP_TYPE == "gdrive" ]; then
    pull_drive "$HOME/gdrive"
    backup_database "$HOME/gdrive/database"
    push_drive "$HOME/gdrive"
else
    echo -e "\e[0;32mBackup aborted\e[0m"
    echo -e "\e[0;33mThe defined backup type is not valid\e[0m"
    exit 1  
fi
