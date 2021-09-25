#!/bin/bash
QUOTES=("You can please some of the people all of the time, you can please all of the people some of the time, but you can’t please all of the people all of the time" \
        "I disapprove of what you say, but I will defend to the death your right to say it" \
        "Don't let your friends you made memories with, become the memories" \
        "You can not excel at anything you do not love" \
        "Early is on time, on time is late and late is unacceptable")

function main_menu
{
    clear
    printf "${COLOR_PURPLE}AzerothCore${COLOR_END}\n"
    printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the source code${COLOR_END}\n"
    printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Manage the databases${COLOR_END}\n"
    printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Manage the configuration options${COLOR_END}\n"
    if [[ -f $CORE_DIRECTORY/bin/start.sh && -f $CORE_DIRECTORY/bin/stop.sh ]] && [[ -f $CORE_DIRECTORY/bin/auth.sh || -f $CORE_DIRECTORY/bin/world.sh ]]; then
        printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Manage the compiled binaries${COLOR_END}\n"
    fi
    printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Exit${COLOR_END}\n"
    printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
    read -n 1 s

    case $s in
        1) source_menu;;
        2) database_menu;;
        3) configuration_menu;;
        4) binary_menu;;
        0) exit_menu;;
        *) main_menu;;
    esac
}

function source_menu
{
    clear
    printf "${COLOR_PURPLE}Manage the cource code${COLOR_END}\n"
    printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the available modules${COLOR_END}\n"
    printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Download the latest version of the repository${COLOR_END}\n"
    printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Compile the source code into binaries${COLOR_END}\n"
    printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
    printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
    read -n 1 s

    case $s in
        1) source_module_menu;;
        2) stop_process; clone_source; source_menu;;
        3) source_compile_menu;;
        0) main_menu;;
        *) source_menu;;
    esac
}

function source_module_menu
{
    clear
    printf "${COLOR_PURPLE}Manage the available modules${COLOR_END}\n"
    printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Eluna LUA Engine: ${COLOR_END}"
    if [ $MODULE_ELUNA_ENABLED == "true" ]; then printf "${COLOR_GREEN}Enabled${COLOR_END}\n"; else printf "${COLOR_RED}Disabled${COLOR_END}\n"; fi
    printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Return to the previous menu${COLOR_END}\n"
    printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
    read -n 1 s

    case $s in
        1) if [ $MODULE_ELUNA_ENABLED == "true" ]; then MODULE_ELUNA_ENABLED="false"; else MODULE_ELUNA_ENABLED="true"; fi; generate_settings; source_module_menu;;
        0) source_menu;;
        *) source_module_menu;;
    esac
}

function source_compile_menu
{
    clear
}

function database_menu
{
    clear
}

function configuration_menu
{
    clear
}

function binary_menu
{
    clear
}

function exit_menu
{
    clear
    printf "${COLOR_PURPLE}Have a amazingly wonderful day!${COLOR_END}\n"
    printf "${COLOR_ORANGE}${QUOTES[$(( RANDOM % ${#QUOTES[@]} ))]}${COLOR_END}\n"
}
