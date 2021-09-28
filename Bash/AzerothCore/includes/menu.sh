#!/bin/bash
function show_menu
{
    clear

    if [ -z $1 ]; then
        printf "${COLOR_PURPLE}AzerothCore${COLOR_END}\n"
        printf "${COLOR_CYAN}1) ${COLOR_ORANGE}Manage the source code${COLOR_END}\n"
        printf "${COLOR_CYAN}2) ${COLOR_ORANGE}Manage the databases${COLOR_END}\n"
        printf "${COLOR_CYAN}3) ${COLOR_ORANGE}Manage the configuration options${COLOR_END}\n"
        printf "${COLOR_CYAN}4) ${COLOR_ORANGE}Manage the compiled binaries${COLOR_END}\n"
        printf "${COLOR_CYAN}0) ${COLOR_ORANGE}Exit${COLOR_END}\n"
        printf "${COLOR_GREEN}Choose an option:${COLOR_END}"
        read -s -n 1 s

        case $s in
            [1-4]) show_menu $s;;
            0) print_quote;;
            *) show_menu;;
        esac
    elif [[ $1 == 1 ]]; then
        echo "1"
    else
        echo $1
    fi
}
