#!/bin/bash
INCLUDES=("distro" "packages" "config" "functions")

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

if [ $# -gt 0 ]; then
    if [ $# -eq 2 ]; then
        if [[ $1 == "all" ]] || [[ $1 == "auth" ]] || [[ $1 == "world" ]]; then
            if [[ $2 == "setup" ]] || [[ $2 == "install" ]] || [[ $2 == "update" ]]; then
                if [ $(dpkg-query -W -f='${Status}' screen 2>/dev/null | grep -c "ok installed") -ne 0 ]; then
                    stop_server
                fi
                build_server $1
            elif [[ $2 == "database" ]] || [[ $2 == "db" ]]; then
                import_database $1
            elif [[ $2 == "configuration" ]] || [[ $2 == "config" ]] || [[ $2 == "conf" ]] || [[ $2 == "cfg" ]]; then
                update_configuration $1
            elif [ $2 == "all" ]; then
                stop_server
                build_server $1
                import_database $1
                update_configuration $1
                start_server
            else
                invalid_arguments
            fi
        else
            invalid_arguments
        fi
    elif [ $# -eq 1 ]; then
        if [ $1 == "start" ]; then
            start_server
        elif [ $1 == "stop" ]; then
            stop_server
        else
            invalid_arguments
        fi
    else
        invalid_arguments
    fi
else
    invalid_arguments
fi
