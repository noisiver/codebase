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
            echo "Download or update the source code"
        elif [ $SELECTION == 2 ]; then
            echo "Manage the available modules"
        elif [ $SELECTION == 3 ]; then
            echo "Compile the source into binaries"
        elif [ $SELECTION == 4 ]; then
            echo "Download or update the client data files"
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
            echo "Not yet determined options"
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
            echo "Not yet determined options"
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
                echo "Start all processes"
            elif [ $SELECTION == 2 ]; then
                echo "Stop all processes"
            fi
        else
            main_menu
        fi
    else
        whiptail --title "An error has occured" --msgbox "Unable to locate the required files. Perform a compilation first by managing the source code" 8 78
        main_menu
    fi
}
