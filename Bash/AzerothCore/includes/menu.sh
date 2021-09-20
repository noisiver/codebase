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
    2 "Compile the source into binaries" \
    3 "Download or update the client data files" \
    3>&1 1>&2 2>&3)

    if [ $SELECTION ]; then
        if [ $SELECTION == 1 ]; then
            clone_source 0
        elif [ $SELECTION == 2 ]; then
            compile_source 0
        elif [ $SELECTION == 3 ]; then
            source_menu
        fi
    else
        main_menu
    fi
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
