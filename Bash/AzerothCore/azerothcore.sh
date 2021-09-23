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

if [ $# -gt 0 ]; then
    if [ $# -eq 1 ]; then
        if [ $1 == "start" ]; then
            start_process
        elif [ $1 == "stop" ]; then
            stop_process
        else
            echo -e "\n\e[0;32mInvalid arguments\e[0m"
            echo -e "\e[0;33mThe supplied arguments are invalid.\e[0m"
        fi
    elif [ $# -eq 2 ]; then
        if [ $1 == "auth" ] || [ $1 == "world" ] || [ $1 == "all" ]; then
            [ $1 == "all" ] && TYPE=0
            [ $1 == "auth" ] && TYPE=1
            [ $1 == "world" ] && TYPE=2

            if [ $2 == "setup" ] || [ $2 == "install" ] || [ $2 == "update" ]; then
                stop_process
                clone_source
                compile_source $TYPE
                fetch_client_data
            elif [ $2 == "database" ] || [ $2 == "db" ]; then
                import_database $TYPE
            elif [ $2 == "cfg" ] || [ $2 == "conf" ] || [ $2 == "config" ] || [ $2 == "configuration" ]; then
                update_configuration $TYPE
            elif [ $2 == "all" ]; then
                stop_process
                clone_source
                compile_source $TYPE
                fetch_client_data
                import_database $TYPE
                update_configuration $TYPE
                start_process
            else
                echo -e "\n\e[0;32mInvalid arguments\e[0m"
                echo -e "\e[0;33mThe supplied arguments are invalid.\e[0m"
            fi

            clear
            echo -e "\e[0;32mFinished\e[0m"
            echo -e "\e[0;33mAll actions completed successfully\e[0m"
        else
            echo -e "\n\e[0;32mInvalid arguments\e[0m"
            echo -e "\e[0;33mThe supplied arguments are invalid.\e[0m"
        fi
    else
        echo -e "\n\e[0;32mInvalid arguments\e[0m"
        echo -e "\e[0;33mThe supplied arguments are invalid.\e[0m"
    fi
else
    echo -e "\n\e[0;32mInvalid arguments\e[0m"
    echo -e "\e[0;33mThe supplied arguments are invalid.\e[0m"
fi
