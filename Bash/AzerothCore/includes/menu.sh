#!/bin/bash
function main_menu
{
    SELECTION=$(whiptail --title "AzerothCore" --menu "Choose an option" 11 50 0 \
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
    SELECTION=$(whiptail --title "Manage the source code" --menu "Choose an option" 11 50 0 \
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
            compile_source_menu
        elif [ $SELECTION == 4 ]; then
            fetch_client_data 0
        fi
    else
        main_menu
    fi
}

function compile_source_menu
{
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
            compile_source 0 0
        elif [[ $SELECTION == *"Auth"* ]]; then
            compile_source 0 1
        elif [[ $SELECTION == *"World"* ]]; then
            compile_source 0 2
        fi
    fi

    source_menu
}

function source_module_menu
{
    SELECTION=$(whiptail --title "Available Modules" --checklist \
    "Select the modules to use" 11 50 4 \
    "Eluna" "Allows scripts written in LUA" ${MODULE_ELUNA_ENABLED/true/ON} \
    3>&1 1>&2 2>&3)

    if [[ $SELECTION ]]; then
        if [[ $SELECTION == *"Eluna"* ]]; then
            MODULE_ELUNA_ENABLED="true"
            generate_settings
        else
            MODULE_ELUNA_ENABLED="false"
            generate_settings
        fi

        whiptail --title "Notice" --msgbox "A change of modules will require you to update the source code again" 7 72
    fi

    source_menu
}

function database_menu
{
    if (whiptail --title "Manage the databases" --yesno "Do you wish to customize the database credentials before proceeding?" 8 72); then
        MYSQL_HOSTNAME=$(whiptail --inputbox "The IP or hostname of the MySQL/MariaDB server" 8 60 $MYSQL_HOSTNAME --title "Manage the databases" 3>&1 1>&2 2>&3)
        MYSQL_PORT=$(whiptail --inputbox "The port number of the MySQL/MariaDB server" 8 60 $MYSQL_PORT --title "Manage the databases" 3>&1 1>&2 2>&3)
        MYSQL_USERNAME=$(whiptail --inputbox "The username used to connect to the MySQL/MariaDB server" 8 60 $MYSQL_USERNAME --title "Manage the databases" 3>&1 1>&2 2>&3)
        MYSQL_PASSWORD=$(whiptail --passwordbox "The password used to connect to the MySQL/MariaDB server" 8 60 $MYSQL_PASSWORD --title "Manage the databases" 3>&1 1>&2 2>&3)
        MYSQL_DATABASE_AUTH=$(whiptail --inputbox "The name of the auth database" 8 60 $MYSQL_DATABASE_AUTH --title "Manage the databases" 3>&1 1>&2 2>&3)
        MYSQL_DATABASE_CHARACTERS=$(whiptail --inputbox "The name of the characters database" 8 60 $MYSQL_DATABASE_CHARACTERS --title "Manage the databases" 3>&1 1>&2 2>&3)
        MYSQL_DATABASE_WORLD=$(whiptail --inputbox "The name of the world database" 8 60 $MYSQL_DATABASE_WORLD --title "Manage the databases" 3>&1 1>&2 2>&3)

        if [[ $MYSQL_HOSTNAME ]] && [[ $MYSQL_PORT ]] && [[ $MYSQL_USERNAME ]] && [[ $MYSQL_PASSWORD ]] && [[ $MYSQL_DATABASE_AUTH ]] && [[ $MYSQL_DATABASE_CHARACTERS ]] && [[ $MYSQL_DATABASE_WORLD ]]; then
            generate_settings
        else
            whiptail --title "An error has occured" --msgbox "At least one of the defined values is invalid or empty" 7 58
            main_menu
        fi
    fi

    SELECTION=$(whiptail --title "Manage the databases" --menu "Choose an option" 11 50 0 \
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
    SELECTION=$(whiptail --title "Manage the configuration files" --menu "Choose an option" 11 50 0 \
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
        SELECTION=$(whiptail --title "Manage the compiled binaries" --menu "Choose an option" 11 50 0 \
        1 "Not yet determined options" \
        3>&1 1>&2 2>&3)

        if [ $SELECTION ]; then
            if [ $SELECTION == 1 ]; then
                binary_menu
            fi
        else
            main_menu
        fi
    else
        whiptail --title "An error has occured" --msgbox "Unable to locate the required files\n\nYou first need to compile the source code into binaries" 9 59
        main_menu
    fi
}
