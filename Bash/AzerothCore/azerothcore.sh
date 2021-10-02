#!/bin/bash
INCLUDES=("color" "distribution" "packages" "configuration" "quote" "menu" "source" "database" "module" "process")

clear

for i in "${INCLUDES[@]}"; do
    if [ -f "includes/$i.sh" ]; then
        source "includes/$i.sh"
    else
        printf "${COLOR_ORANGE}Unable to access includes/$i.sh${COLOR_END}\n"
        exit 1
    fi
done

if [ $# -gt 0 ]; then
    if [ $# -eq 1 ]; then
        if [ $1 == "start" ]; then
            start_process
        elif [ $1 == "stop" ]; then
            stop_process
        elif [ $1 == "client" ]; then
            update_client_data
        else
            printf "${COLOR_GREEN}Invalid arguments${COLOR_END}\n"
            printf "${COLOR_ORANGE}The supplied arguments are invalid.${COLOR_END}\n"
        fi

        print_quote
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
                transfer_lua_scripts
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
                transfer_lua_scripts
                start_process
            elif [[ $2 == "modules" ]]; then
                transfer_lua_scripts
            else
                printf "${COLOR_GREEN}Invalid arguments${COLOR_END}\n"
                printf "${COLOR_ORANGE}The supplied arguments are invalid.${COLOR_END}\n"
            fi

            print_quote
        else
            printf "${COLOR_GREEN}Invalid arguments${COLOR_END}\n"
            printf "${COLOR_ORANGE}The supplied arguments are invalid.${COLOR_END}\n"
        fi
    else
        printf "${COLOR_GREEN}Invalid arguments${COLOR_END}\n"
        printf "${COLOR_ORANGE}The supplied arguments are invalid.${COLOR_END}\n"
    fi
else
    show_menu
fi
