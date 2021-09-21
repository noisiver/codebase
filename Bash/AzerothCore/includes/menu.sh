#!/bin/bash
function main_menu
{
    SELECTION=$(whiptail --title "AzerothCore" --menu "Choose an option" 25 78 16 \
    1 "Manage the source code" \
    2 "Manage the databases" \
    3 "Manage the configuration files" \
    4 "Manage the compiled binaries" \
    3>&1 1>&2 2>&3)

    if [ $SELECTION ]; then
        if [ $SELECTION == 1 ]; then
            source_menu
        elif [ $SELECTION == 2 ]; then
            database_menu
        elif [ $SELECTION == 3 ]; then
            configuration_menu
        elif [ $SELECTION == 4 ]; then
            binary_menu
        fi
    fi
}

function source_menu
{
    SELECTION=$(whiptail --title "Manage the source code" --menu "Choose an option" 25 78 16 \
    1 "Download or update the source code" \
    2 "Manage the available modules" \
    3 "Compile the source into binaries" \
    4 "Download or update the client data files" \
    3>&1 1>&2 2>&3)

    if [ $SELECTION ]; then
        if [ $SELECTION == 1 ]; then
            clone_source 0
        elif [ $SELECTION == 2 ]; then
            source_module_menu
        elif [ $SELECTION == 3 ]; then
            compile_source 0
        elif [ $SELECTION == 4 ]; then
            fetch_client_data 0
        fi
    else
        main_menu
    fi
}

function source_module_menu
{
    SELECTION=$(whiptail --title "Available Modules" --checklist \
    "Select the modules to use" 20 78 4 \
    "Eluna" "A LUA engine allowing the use of scripts written in LUA" ${MODULE_ELUNA_ENABLED/true/ON} \
    3>&1 1>&2 2>&3)

    if [ $SELECTION ]; then
        if [[ $SELECTION == *"Eluna"* ]]; then
            MODULE_ELUNA_ENABLED="true"
            generate_settings
        else
            MODULE_ELUNA_ENABLED="false"
            generate_settings
        fi
    else
        MODULE_ELUNA_ENABLED="false"
        generate_settings
    fi

    source_menu
}

function database_menu
{
    SELECTION=$(whiptail --title "Manage the databases" --menu "Choose an option" 25 78 16 \
    1 "Not yet determined options" \
    3>&1 1>&2 2>&3)

    if [ $SELECTION ]; then
        if [ $SELECTION == 1 ]; then
            database_menu
        fi
    else
        main_menu
    fi
}

function configuration_menu
{
    SELECTION=$(whiptail --title "Manage the configuration files" --menu "Choose an option" 25 78 16 \
    1 "Not yet determined options" \
    3>&1 1>&2 2>&3)

    if [ $SELECTION ]; then
        if [ $SELECTION == 1 ]; then
            configuration_menu
        fi
    else
        main_menu
    fi
}

function binary_menu
{
    if [[ -f $CORE_DIRECTORY/bin/start.sh ]] && [[ -f $CORE_DIRECTORY/bin/worldserver ]] && [[ -f $CORE_DIRECTORY/bin/authserver ]]; then
        SELECTION=$(whiptail --title "Manage the compiled binaries" --menu "Choose an option" 25 78 16 \
        1 "Start all processes" \
        2 "Stop all processes" \
        3>&1 1>&2 2>&3)

        if [ $SELECTION ]; then
            if [ $SELECTION == 1 ]; then
                binary_menu
            elif [ $SELECTION == 2 ]; then
                binary_menu
            fi
        else
            main_menu
        fi
    else
        whiptail --title "An error has occured" --msgbox "Unable to locate the required files. Perform a compilation first by managing the source code" 8 78
        main_menu
    fi
}
