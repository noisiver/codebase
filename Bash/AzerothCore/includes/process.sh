#!/bin/bash
function start_process
{
    clear

    printf "${COLOR_GREEN}Starting processes${COLOR_END}\n"

    if [[ -z `screen -list | grep -E "auth"` ]] && [[ -z `screen -list | grep -E "world"` ]]; then
        if [ -f $CORE_DIRECTORY/bin/start.sh ]; then
            printf "${COLOR_ORANGE}Starting the server process${COLOR_END}\n"

            cd $CORE_DIRECTORY/bin && ./start.sh
        else
            printf "${COLOR_ORANGE}Unable to locate the required executable${COLOR_END}\n"

            exit $?
        fi
    else
        printf "${COLOR_ORANGE}The server is already running${COLOR_END}\n"
    fi
}

function stop_process
{
    clear

    printf "${COLOR_GREEN}Stopping processes${COLOR_END}\n"

    if [[ ! -z `screen -list | grep -E "world"` ]]; then
        printf "${COLOR_ORANGE}Telling the world server to save${COLOR_END}\n"

        screen -S world -p 0 -X stuff "saveall^m"

        sleep 3
    fi

    if [[ ! -z `screen -list | grep -E "auth"` ]] || [[ ! -z `screen -list | grep -E "world"` ]]; then
        if [ -f $CORE_DIRECTORY/bin/stop.sh ]; then
            printf "${COLOR_ORANGE}Stopping the server process${COLOR_END}\n"

            cd $CORE_DIRECTORY/bin && ./stop.sh
        else
            printf "${COLOR_ORANGE}Unable to locate the required executable${COLOR_END}\n"

            exit $?
        fi
    else
        printf "${COLOR_ORANGE}No running server found${COLOR_END}\n"
    fi
}
