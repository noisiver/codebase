#!/bin/bash
INCLUDES=("distribution" "packages" "configuration" "source" "database" "process")

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
