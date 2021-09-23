#!/bin/bash
function main_menu
{
    SELECTION=$(whiptail --title "AzerothCore" --menu "Choose an option" 11 50 0 \
    1 "Manage the source code" \
    2 "Manage the databases" \
    3 "Manage the configuration files" \
    4 "Manage the compiled binaries" \
    3>&1 1>&2 2>&3)

    if [[ $SELECTION ]]; then
        if [[ $SELECTION == 1 ]]; then
            source_menu
        elif [[ $SELECTION == 2 ]]; then
            main_menu
        elif [[ $SELECTION == 3 ]]; then
            main_menu
        elif [[ $SELECTION == 4 ]]; then
            main_menu
        fi
    fi
}

function source_menu
{
    SELECTION=$(whiptail --title "Manage the source code" --menu "Choose an option" 11 50 0 \
    1 "Download or update the source code" \
    2 "Compile the source into binaries" \
    3 "Download or update the client data files" \
    3>&1 1>&2 2>&3)

    if [[ $SELECTION ]]; then
        if [[ $SELECTION == 1 ]]; then
            SELECTION=$(whiptail --title "Available Modules" --checklist \
            "Select the modules to use" 11 50 4 \
            "Eluna" "Allows scripts written in LUA" ${MODULE_ELUNA_ENABLED/true/ON} \
            3>&1 1>&2 2>&3)

            if [[ $SELECTION ]]; then
                if [[ $SELECTION == *"Eluna"* ]]; then
                    MODULE_ELUNA_ENABLED="true"
                else
                    MODULE_ELUNA_ENABLED="false"
                fi

                generate_settings
            else
                source_menu
                exit 0
            fi

            clone_source
            source_menu
        elif [[ $SELECTION == 2 ]]; then
            [ -f $CORE_DIRECTORY/bin/auth.sh ] && AUTH=1 || AUTH=0
            [ -f $CORE_DIRECTORY/bin/world.sh ] && WORLD=1 || WORLD=0
            [ ! -f $CORE_DIRECTORY/bin/start.sh ] && AUTH=1 WORLD=1

            SELECTION=$(whiptail --title "Compile the source into binaries" --checklist \
            "Select the parts to use for this compilation" 11 50 4 \
            "Auth" "Enable the use of authserver" $AUTH \
            "World" "Enable the use of worldserver" $WORLD \
            3>&1 1>&2 2>&3)

            if [[ $SELECTION ]]; then
                if [[ $SELECTION == *"Auth"* ]] && [[ $SELECTION == *"World"* ]]; then
                    compile_source 0
                elif [[ $SELECTION == *"Auth"* ]]; then
                    compile_source 1
                elif [[ $SELECTION == *"World"* ]]; then
                    compile_source 2
                fi

                source_menu
            fi
        elif [[ $SELECTION == 3 ]]; then
            fetch_client_data
            source_menu
        fi
    else
        main_menu
    fi
}
